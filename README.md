<div align="center">

  ![Logo](https://raw.githubusercontent.com/plankanban/planka/master/assets/logo.png)

  # PLANKA

  _Project mastering driven by fun_

  ![Version](https://img.shields.io/github/package-json/v/plankanban/planka?style=flat-square) [![Docker Pulls](https://img.shields.io/badge/docker_pulls-8M%2B-%23066da5?style=flat-square&color=red)](https://github.com/plankanban/planka/pkgs/container/planka) [![Contributors](https://img.shields.io/github/contributors/plankanban/planka?style=flat-square&color=blue)](https://github.com/plankanban/planka/graphs/contributors) [![Chat](https://img.shields.io/discord/1041440072953765979?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/WqqYNd7Jvt)

  [Install](https://docs.planka.cloud/docs/installation/docker/production-version/) ·  [Demo](https://planka.app) · [Docs](https://docs.planka.cloud/docs/welcome/) · [API](https://plankanban.github.io/planka/swagger-ui/) · [Cloud](https://planka.app/pricing) · [Pro version](https://planka.app/pro)

  ![Demo](https://raw.githubusercontent.com/plankanban/planka/master/assets/demo.gif)

</div>

## Key Features

- **Collaborative Kanban Boards:** Create projects, boards, lists, cards, and manage tasks with an intuitive drag-and-drop interface
- **Real-Time Updates:** Instant syncing across all users, no refresh needed
- **Rich Markdown Support:** Write beautifully formatted card descriptions with a powerful markdown editor
- **Flexible Notifications:** Get alerts through 100+ providers, fully customizable to your workflow
- **Seamless Authentication:** Single sign-on with OpenID Connect integration
- **Multilingual & Easy to Translate:** Full internationalization support for a global audience

## How to Deploy

PLANKA is easy to install using multiple methods - learn more in the [installation guide](https://docs.planka.cloud/docs/welcome/).

For configuration and environment settings, see the [configuration section](https://docs.planka.cloud/docs/category/configuration/).

Interested in a hosted or [Pro version](https://planka.app/pro) of PLANKA? Check out the pricing on our [website](https://planka.app/pricing).

## Development

This repository contains the full PLANKA application:

- `client/` - React + Vite frontend
- `server/` - Sails.js API, realtime server, and database workflows
- `charts/planka/` - Helm chart for Kubernetes deployments
- `database/` - PostgreSQL export artifacts and MSSQL migration workspace

### Prerequisites

- Node.js `>=20`
- PostgreSQL `16` for local non-Docker development
- npm

### Install dependencies

From the repository root:

```bash
npm install
```

This installs the root, server, and client dependencies through the existing `postinstall` flow.

### Run with Docker

For containerized development or self-hosting, use the provided compose files:

```bash
docker compose up
```

For the development compose variant:

```bash
docker compose -f docker-compose-dev.yml up
```

Production deployment guidance lives in the hosted docs:

- [Docker installation](https://docs.planka.cloud/docs/installation/docker/production-version/)
- [Configuration](https://docs.planka.cloud/docs/category/configuration/)

### Run locally without Docker

The repo also supports running the frontend and backend directly on your machine.

1. Install and start PostgreSQL 16, then create the local database:

```bash
brew install postgresql@16
brew services start postgresql@16
createdb planka
```

2. Initialize the database:

```bash
npm run server:db:init
```

3. Start the backend and frontend in separate terminals:

```bash
npm run server:start
npm run client:start
```

4. Build the server-served client shell when needed:

```bash
INDEX_FORMAT=ejs DISABLE_ESLINT_PLUGIN=true npm run client:build
bash client/tests/setup-symlinks.sh
```

Local URLs:

- Frontend: `http://localhost:3000`
- API/backend: `http://localhost:1337`

Default local login after seeding:

- Email: `admin@local.test`
- Password: `admin1234`

See [LOCALHOST.md](https://github.com/plankanban/planka/blob/master/LOCALHOST.md) for the repo's local setup notes.

### Useful scripts

- `npm start` - run server and client together
- `npm run lint` - run server and client linting
- `npm test` - run server and client tests
- `npm run server:db:init` - run migrations and seed data
- `npm run server:db:upgrade` - run upgrade workflow
- `npm run server:swagger:generate` - regenerate API docs

## Database Migration Workspace

The [`database/`](https://github.com/plankanban/planka/blob/master/database/README.md) directory is reserved for the PostgreSQL-to-MSSQL migration workflow and related export artifacts.

It includes:

- PostgreSQL schema snapshots and data exports
- SQL Server DDL and DML work directories
- helper scripts for exporting and replaying database artifacts

See [database/README.md](https://github.com/plankanban/planka/blob/master/database/README.md) for the detailed workflow.

## Notes App

A testing version of the Notes app is now available on multiple platforms:

- **iOS:** Join the [TestFlight](https://testflight.apple.com/join/5eJqTaJW) to try the app
- **Windows & Android:** Download the app [here](https://planka-notes.hillerdaniel.de)

## Contact

For any security issues, please do not create a public issue on GitHub - instead, report it privately by emailing [security@planka.group](mailto:security@planka.group).

**Note:** We do NOT offer any public support via email, please use GitHub.

**Join our community:** Get help, share ideas, or contribute on our [Discord server](https://discord.gg/WqqYNd7Jvt).

## License

PLANKA is [fair-code](https://faircode.io) distributed under the [Fair Use License](https://github.com/plankanban/planka/blob/master/LICENSES/PLANKA%20Community%20License%20EN.md) and [PLANKA Pro/Enterprise License](https://github.com/plankanban/planka/blob/master/LICENSES/PLANKA%20Commercial%20License%20EN.md).

- **Source Available:** The source code is always visible
- **Self-Hostable:** Deploy and host it anywhere
- **Extensible:** Customize with your own functionality
- **Enterprise Licenses:** Available for additional features and support

For more details, check the [License Guide](https://github.com/plankanban/planka/blob/master/LICENSES/PLANKA%20License%20Guide%20EN.md).

## Contributing

Found a bug or have a feature request? Check out our [Contributing Guide](https://github.com/plankanban/planka/blob/master/CONTRIBUTING.md) to get started.

For setting up the project locally, see the [development section](https://docs.planka.cloud/docs/category/development/).

**Thanks to all our contributors!**

[![Contributors](https://contrib.rocks/image?repo=plankanban/planka)](https://github.com/plankanban/planka/graphs/contributors)
