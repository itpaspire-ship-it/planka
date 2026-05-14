/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { buildUpdateQuery, getNativeRows } = require('../helpers');

const defaultFind = (criteria) => BackgroundImage.find(criteria).sort('id');

/* Query methods */

const createOne = (values) =>
  sails.getDatastore().transaction(async (db) => {
    const backgroundImage = await BackgroundImage.create({ ...values })
      .fetch()
      .usingConnection(db);

    const queryResult = await sails
      .sendNativeQuery(
        'UPDATE uploaded_file SET references_total = references_total + 1, updated_at = $1 WHERE id = $2 AND references_total IS NOT NULL',
        [new Date().toISOString(), values.uploadedFileId],
      )
      .usingConnection(db);

    if (queryResult.rowCount === 0) {
      throw 'uploadedFileNotFound';
    }

    return backgroundImage;
  });

const getByIds = (ids) => defaultFind(ids);

const getByProjectId = (projectId) =>
  defaultFind({
    projectId,
  });

const getByProjectIds = (projectIds) =>
  defaultFind({
    projectId: projectIds,
  });

const getOneById = (id, { projectId } = {}) => {
  const criteria = {
    id,
  };

  if (projectId) {
    criteria.projectId = projectId;
  }

  return BackgroundImage.findOne(criteria);
};

// eslint-disable-next-line no-underscore-dangle
const delete_ = (criteria) =>
  sails.getDatastore().transaction(async (db) => {
    const backgroundImages = await BackgroundImage.destroy(criteria).fetch().usingConnection(db);

    let uploadedFiles = [];
    if (backgroundImages.length > 0) {
      const backgroundImagesByUploadedFileId = _.groupBy(backgroundImages, 'uploadedFileId');

      const uploadedFileIdsByTotal = Object.entries(backgroundImagesByUploadedFileId).reduce(
        (result, [uploadedFileId, backgroundImagesItem]) => ({
          ...result,
          [backgroundImagesItem.length]: [
            ...(result[backgroundImagesItem.length] || []),
            uploadedFileId,
          ],
        }),
        {},
      );

      const queryValues = [];
      let query = 'UPDATE uploaded_file SET references_total = CASE WHEN references_total = CASE ';

      Object.entries(uploadedFileIdsByTotal).forEach(([total, uploadedFileIds]) => {
        const inValues = uploadedFileIds.map((uploadedFileId) => {
          queryValues.push(uploadedFileId);
          return `$${queryValues.length}`;
        });

        queryValues.push(total);
        query += `WHEN id IN (${inValues.join(', ')}) THEN CAST($${queryValues.length} AS INT) `;
      });

      query += 'END THEN NULL ELSE references_total - CASE ';

      Object.entries(uploadedFileIdsByTotal).forEach(([total, uploadedFileIds]) => {
        const inValues = uploadedFileIds.map((uploadedFileId) => {
          queryValues.push(uploadedFileId);
          return `$${queryValues.length}`;
        });

        queryValues.push(total);
        query += `WHEN id IN (${inValues.join(', ')}) THEN CAST($${queryValues.length} AS INT) `;
      });

      const inValues = Object.keys(backgroundImagesByUploadedFileId).map((uploadedFileId) => {
        queryValues.push(uploadedFileId);
        return `$${queryValues.length}`;
      });

      queryValues.push(new Date().toISOString());
      query = buildUpdateQuery({
        table: 'uploaded_file',
        setClause: `${query.slice('UPDATE uploaded_file SET '.length)}END END, updated_at = $${
          queryValues.length
        }`,
        whereClause: `id IN (${inValues.join(', ')}) AND references_total IS NOT NULL`,
        returningColumns: '*',
      });

      const queryResult = await sails.sendNativeQuery(query, queryValues).usingConnection(db);
      uploadedFiles = getNativeRows(queryResult).map((row) =>
        UploadedFile.qm.transformRowToModel(row),
      );
    }

    return { backgroundImages, uploadedFiles };
  });

const deleteOne = (criteria) =>
  sails.getDatastore().transaction(async (db) => {
    const backgroundImage = await BackgroundImage.destroyOne(criteria).usingConnection(db);

    const queryResult = await sails
      .sendNativeQuery(
        buildUpdateQuery({
          table: 'uploaded_file',
          setClause:
            'references_total = CASE WHEN references_total > 1 THEN references_total - 1 END, updated_at = $1',
          whereClause: 'id = $2',
          returningColumns: '*',
        }),
        [new Date().toISOString(), backgroundImage.uploadedFileId],
      )
      .usingConnection(db);

    const uploadedFile = UploadedFile.qm.transformRowToModel(getNativeRows(queryResult)[0]);

    return { backgroundImage, uploadedFile };
  });

module.exports = {
  createOne,
  getByIds,
  getByProjectId,
  getByProjectIds,
  getOneById,
  deleteOne,
  delete: delete_,
};
