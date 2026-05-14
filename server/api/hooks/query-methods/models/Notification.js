/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const LIMIT = 100;

const defaultFind = (criteria) => Notification.find(criteria).sort('id DESC');

/* Query methods */

const create = (arrayOfValues) =>
  sails.getDatastore().transaction(async (db) => {
    const notifications = await Notification.createEach(arrayOfValues).fetch().usingConnection(db);
    const userIds = sails.helpers.utils.mapRecords(notifications, 'userId', true, true);

    if (userIds.length > 0) {
      const queryValues = [];
      const inValues = userIds.map((userId) => {
        queryValues.push(userId);
        return `$${queryValues.length}`;
      });

      const unreadValuePlaceholder = `$${queryValues.push(false)}`;
      queryValues.push(LIMIT);
      const limitPlaceholder = `$${queryValues.length}`;
      const readValuePlaceholder = `$${queryValues.push(true)}`;

      const query = `
        WITH exceeded_notification AS (
          SELECT id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY id DESC) AS rank
          FROM notification
          WHERE user_id IN (${inValues.join(', ')}) AND is_read = ${unreadValuePlaceholder}
        )
        UPDATE notification
        SET is_read = ${readValuePlaceholder}
        WHERE id IN (SELECT id FROM exceeded_notification WHERE rank > ${limitPlaceholder})
      `;

      await sails.sendNativeQuery(query, queryValues).usingConnection(db);
    }

    return notifications;
  });

const createOne = (values) => {
  if (values.userId) {
    return sails.getDatastore().transaction(async (db) => {
      const notification = await Notification.create({ ...values })
        .fetch()
        .usingConnection(db);

      const unreadValuePlaceholder = '$3';
      const readValuePlaceholder = '$4';
      const query = `
        WITH exceeded_notification AS (
          SELECT id
          FROM notification
          WHERE user_id = $1 AND is_read = ${unreadValuePlaceholder}
          ORDER BY id DESC
          OFFSET $2 ROWS
        )
        UPDATE notification
        SET is_read = ${readValuePlaceholder}
        WHERE id IN (SELECT id FROM exceeded_notification)
      `;

      await sails.sendNativeQuery(query, [values.userId, LIMIT, false, true]).usingConnection(db);

      return notification;
    });
  }

  return Notification.create({ ...values }).fetch();
};

const getByIds = (ids) => defaultFind(ids);

const getUnreadByUserId = (userId) =>
  defaultFind({
    userId,
    isRead: false,
  });

const getOneById = (id, { userId } = {}) => {
  const criteria = {
    id,
  };

  if (userId) {
    criteria.userId = userId;
  }

  return Notification.findOne(criteria);
};

const update = (criteria, values) => Notification.update(criteria).set(values).fetch();

const updateOne = (criteria, values) => Notification.updateOne(criteria).set({ ...values });

// eslint-disable-next-line no-underscore-dangle
const delete_ = (criteria) => Notification.destroy(criteria).fetch();

module.exports = {
  create,
  createOne,
  getByIds,
  getUnreadByUserId,
  getOneById,
  update,
  updateOne,
  delete: delete_,
};
