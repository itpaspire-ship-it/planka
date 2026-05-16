/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const dotenv = require('dotenv');
const _ = require('lodash');

const { buildKnexConnection, getKnexClient } = require('../utils/database');

dotenv.config({
  path: path.resolve(__dirname, '../.env'),
  quiet: true,
});

module.exports = {
  client: getKnexClient(),
  connection: buildKnexConnection(),
  seeds: {
    directory: path.join(__dirname, 'seeds'),
  },
  wrapIdentifier: (value, origImpl) => origImpl(_.snakeCase(value)),
};
