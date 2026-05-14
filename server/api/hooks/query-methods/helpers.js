/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const makeWhereQueryBuilder = (Model) => (criteria) => {
  if (_.isPlainObject(criteria)) {
    if (Object.keys(criteria).length === 0) {
      throw new Error('Empty criteria');
    }

    const parts = [];
    const values = [];

    // eslint-disable-next-line no-restricted-syntax
    for (const [key, value] of Object.entries(criteria)) {
      // eslint-disable-next-line no-underscore-dangle
      const columnName = Model._transformer._transformations[key];

      if (!columnName) {
        throw new Error('Unknown column');
      }

      values.push(value);
      parts.push(`${columnName} = $${values.length}`);
    }

    return [parts.join(' AND '), values];
  }

  return ['id = $1', [criteria]];
};

const makeRowToModelTransformer = (Model) => {
  // eslint-disable-next-line no-underscore-dangle
  const transformations = _.invert(Model._transformer._transformations);

  return (row) => _.mapKeys(row, (_, key) => transformations[key]);
};

const getNativeRows = (queryResult) => {
  if (Array.isArray(queryResult?.rows)) {
    return queryResult.rows;
  }

  if (Array.isArray(queryResult?.recordset)) {
    return queryResult.recordset;
  }

  if (Array.isArray(queryResult?.recordsets?.[0])) {
    return queryResult.recordsets[0];
  }

  if (Array.isArray(queryResult)) {
    return queryResult;
  }

  return [];
};

const buildLockedSelectQuery = ({ table, columns, whereClause, one = false }) => {
  return `SELECT ${one ? 'TOP 1 ' : ''}${columns} FROM ${table} WITH (UPDLOCK, ROWLOCK) WHERE ${whereClause}`;
};

const buildUpdateQuery = ({ table, setClause, whereClause, returningColumns }) => {
  const outputClause = returningColumns
    ? ` OUTPUT ${
        returningColumns === '*'
          ? 'inserted.*'
          : returningColumns
              .split(',')
              .map((column) => `inserted.${column.trim()}`)
              .join(', ')
      }`
    : '';

  return `UPDATE ${table} SET ${setClause}${outputClause} WHERE ${whereClause}`;
};

module.exports = {
  buildLockedSelectQuery,
  buildUpdateQuery,
  getNativeRows,
  makeWhereQueryBuilder,
  makeRowToModelTransformer,
};
