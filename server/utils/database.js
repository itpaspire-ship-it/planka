const POSTGRES_DIALECT = 'postgres';
const MSSQL_DIALECT = 'mssql';
const DEFAULT_MSSQL_SCHEMA = 'dbo';

const parseBoolean = (value) => {
  if (value === undefined) {
    return undefined;
  }

  return value === 'true';
};

const getDatabaseDialect = () => {
  const dialect = (process.env.DATABASE_DIALECT || POSTGRES_DIALECT).toLowerCase();

  if (dialect === POSTGRES_DIALECT || dialect === MSSQL_DIALECT) {
    return dialect;
  }

  throw new Error(
    `Unsupported DATABASE_DIALECT "${process.env.DATABASE_DIALECT}". Expected "${POSTGRES_DIALECT}" or "${MSSQL_DIALECT}".`,
  );
};

const getSailsAdapter = () => {
  if (process.env.DATABASE_ADAPTER) {
    return process.env.DATABASE_ADAPTER;
  }

  return getDatabaseDialect() === MSSQL_DIALECT ? 'sails-sqlserver' : 'sails-postgresql';
};

const getKnexClient = () => (getDatabaseDialect() === MSSQL_DIALECT ? 'mssql' : 'pg');

const getDatabaseSchema = () => {
  if (getDatabaseDialect() !== MSSQL_DIALECT) {
    return undefined;
  }

  return process.env.DATABASE_SCHEMA || DEFAULT_MSSQL_SCHEMA;
};

const buildMssqlOptions = () => {
  const encrypt = parseBoolean(process.env.MSSQL_ENCRYPT);
  const trustServerCertificate = parseBoolean(process.env.MSSQL_TRUST_SERVER_CERTIFICATE);
  const enableArithAbort = parseBoolean(process.env.MSSQL_ENABLE_ARITH_ABORT);

  return {
    ...(encrypt === undefined ? {} : { encrypt }),
    ...(trustServerCertificate === undefined ? {} : { trustServerCertificate }),
    ...(enableArithAbort === undefined ? { enableArithAbort: true } : { enableArithAbort }),
  };
};

const buildDiscreteConnection = () => {
  const host = process.env.DATABASE_HOST;
  const port = process.env.DATABASE_PORT;
  const user = process.env.DATABASE_USERNAME;
  const password = process.env.DATABASE_PASSWORD;
  const database = process.env.DATABASE_NAME;

  if (!host || !user || !database) {
    return null;
  }

  return {
    host,
    ...(port ? { port: parseInt(port, 10) } : {}),
    user,
    ...(password ? { password } : {}),
    database,
  };
};

const buildKnexConnection = () => {
  const discreteConnection = buildDiscreteConnection();

  if (getDatabaseDialect() === MSSQL_DIALECT) {
    const connection = discreteConnection || process.env.DATABASE_URL;
    const options = buildMssqlOptions();

    if (Object.keys(options).length === 0) {
      return connection;
    }

    if (discreteConnection) {
      return {
        ...discreteConnection,
        options,
      };
    }

    return {
      connectionString: connection,
      options,
    };
  }

  if (discreteConnection) {
    if (process.env.KNEX_REJECT_UNAUTHORIZED_SSL_CERTIFICATE === 'false') {
      return {
        ...discreteConnection,
        ssl: {
          rejectUnauthorized: false,
        },
      };
    }

    return {
      ...discreteConnection,
      ssl: false,
    };
  }

  if (process.env.KNEX_REJECT_UNAUTHORIZED_SSL_CERTIFICATE === 'false') {
    return {
      connectionString: process.env.DATABASE_URL,
      ssl: {
        rejectUnauthorized: false,
      },
    };
  }

  return {
    connectionString: process.env.DATABASE_URL,
    ssl: false,
  };
};

const buildSailsDatastoreConfig = () => {
  const dialect = getDatabaseDialect();
  const adapter = getSailsAdapter();

  if (dialect === MSSQL_DIALECT) {
    const discreteConnection = buildDiscreteConnection();

    return {
      adapter,
      url: process.env.DATABASE_URL,
      ...(discreteConnection || {}),
      schemaName: getDatabaseSchema(),
      options: buildMssqlOptions(),
    };
  }

  return {
    adapter,
    url: process.env.DATABASE_URL,
  };
};

module.exports = {
  buildKnexConnection,
  buildSailsDatastoreConfig,
  getDatabaseSchema,
  getDatabaseDialect,
  getKnexClient,
  getSailsAdapter,
  DEFAULT_MSSQL_SCHEMA,
  MSSQL_DIALECT,
  POSTGRES_DIALECT,
};
