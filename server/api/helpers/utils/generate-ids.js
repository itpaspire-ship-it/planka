/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { getDatabaseSchema } = require('../../../utils/database');

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

const escapeSqlName = (value) => value.replace(/]/g, ']]');

module.exports = {
  inputs: {
    total: {
      type: 'number',
      required: true,
    },
    connection: {
      type: 'ref',
    },
    sequenceName: {
      type: 'string',
      defaultsTo: 'next_id_seq',
    },
  },

  async fn(inputs) {
    const total = Math.trunc(inputs.total);

    if (total < 1) {
      return [];
    }

    const schemaName = escapeSqlName(getDatabaseSchema());
    const sequenceName = escapeSqlName(inputs.sequenceName);
    const qualifiedSequenceName = `[${schemaName}].[${sequenceName}]`;
    const createSequenceQuery = `
IF OBJECT_ID(N'${schemaName}.${sequenceName}', N'SO') IS NULL
BEGIN
  EXEC(N'CREATE SEQUENCE ${qualifiedSequenceName} AS BIGINT START WITH 1 INCREMENT BY 1');
END
`;
    const selectIdsQuery = `
WITH generated_rows AS (
  SELECT TOP (${total}) ROW_NUMBER() OVER (ORDER BY object_id) AS row_num
  FROM sys.all_objects
)
SELECT NEXT VALUE FOR ${qualifiedSequenceName} OVER (ORDER BY row_num) AS id
FROM generated_rows
ORDER BY row_num
`;

    let query = sails.sendNativeQuery(createSequenceQuery);

    if (inputs.connection) {
      query = query.usingConnection(inputs.connection);
    }

    await query;

    query = sails.sendNativeQuery(selectIdsQuery);

    if (inputs.connection) {
      query = query.usingConnection(inputs.connection);
    }

    const queryResult = await query;

    return sails.helpers.utils.mapRecords(getNativeRows(queryResult));
  },
};
