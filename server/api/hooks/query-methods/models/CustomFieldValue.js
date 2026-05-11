/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { getNativeRows, makeRowToModelTransformer } = require('../helpers');

const transformRowToModel = makeRowToModelTransformer(CustomFieldValue);

const defaultFind = (criteria, { customFieldGroupIdOrIds } = {}) => {
  if (customFieldGroupIdOrIds) {
    criteria.customFieldGroupId = customFieldGroupIdOrIds; // eslint-disable-line no-param-reassign
  }

  return CustomFieldValue.find(criteria).sort('id');
};

/* Query methods */

const create = (arrayOfValues) => CustomFieldValue.createEach(arrayOfValues).fetch();

const createOrUpdateOne = async (values) => {
  const queryValues = [
    values.cardId,
    values.customFieldGroupId,
    values.customFieldId,
    values.content,
    new Date().toISOString(),
  ];

  const query = `
    MERGE custom_field_value WITH (HOLDLOCK) AS target
    USING (
      SELECT
        $1 AS card_id,
        $2 AS custom_field_group_id,
        $3 AS custom_field_id,
        $4 AS content,
        $5 AS created_at
    ) AS source
    ON target.card_id = source.card_id
      AND target.custom_field_group_id = source.custom_field_group_id
      AND target.custom_field_id = source.custom_field_id
    WHEN MATCHED THEN
      UPDATE SET content = source.content, updated_at = source.created_at
    WHEN NOT MATCHED THEN
      INSERT (card_id, custom_field_group_id, custom_field_id, content, created_at)
      VALUES (
        source.card_id,
        source.custom_field_group_id,
        source.custom_field_id,
        source.content,
        source.created_at
      )
    OUTPUT inserted.*;
  `;

  const queryResult = await sails.sendNativeQuery(query, queryValues);

  return transformRowToModel(getNativeRows(queryResult)[0]);
};

const getByIds = (ids) => defaultFind(ids);

const getByCardId = (cardId, { customFieldGroupIdOrIds } = {}) =>
  defaultFind(
    {
      cardId,
    },
    { customFieldGroupIdOrIds },
  );

const getByCardIds = (cardIds, { customFieldGroupIdOrIds } = {}) =>
  defaultFind(
    {
      cardId: cardIds,
    },
    { customFieldGroupIdOrIds },
  );

const getByCustomFieldGroupId = (customFieldGroupId) =>
  defaultFind({
    customFieldGroupId,
  });

const getOneByCardIdAndCustomFieldGroupIdAndCustomFieldId = (
  cardId,
  customFieldGroupId,
  customFieldId,
) =>
  CustomFieldValue.findOne({
    cardId,
    customFieldGroupId,
    customFieldId,
  });

const updateOne = (criteria, values) => CustomFieldValue.updateOne(criteria).set({ ...values });

// eslint-disable-next-line no-underscore-dangle
const delete_ = (criteria) => CustomFieldValue.destroy(criteria).fetch();

const deleteOne = (criteria) => CustomFieldValue.destroyOne(criteria);

module.exports = {
  create,
  createOrUpdateOne,
  getByIds,
  getByCardId,
  getByCardIds,
  getByCustomFieldGroupId,
  getOneByCardIdAndCustomFieldGroupIdAndCustomFieldId,
  updateOne,
  deleteOne,
  delete: delete_,
};
