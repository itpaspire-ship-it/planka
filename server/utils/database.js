const MSSQL_DIALECT = 'mssql';
const DEFAULT_MSSQL_SCHEMA = 'dbo';
const sailsSqlServerAdapter = require('../adapters/sails-sqlserver');

const parseBoolean = (value) => {
  if (value === undefined) {
    return undefined;
  }

  return value === 'true';
};

const getDatabaseDialect = () => {
  const dialect = (process.env.DATABASE_DIALECT || MSSQL_DIALECT).toLowerCase();

  if (dialect === MSSQL_DIALECT) {
    return dialect;
  }

  throw new Error(
    `Unsupported DATABASE_DIALECT "${process.env.DATABASE_DIALECT}". Expected "${MSSQL_DIALECT}".`,
  );
};

const getSailsAdapter = () => {
  if (process.env.DATABASE_ADAPTER) {
    return process.env.DATABASE_ADAPTER;
  }

  return sailsSqlServerAdapter;
};

const getKnexClient = () => 'mssql';

const getDatabaseSchema = () => {
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
};

const buildSailsDatastoreConfig = () => {
  const adapter = getSailsAdapter();
  const discreteConnection = buildDiscreteConnection();

  return {
    adapter,
    url: process.env.DATABASE_URL,
    ...(discreteConnection || {}),
    schemaName: getDatabaseSchema(),
    options: buildMssqlOptions(),
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
};
