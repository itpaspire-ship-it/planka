# Run Planka locally without Docker

## 1. Install PostgreSQL

On macOS with Homebrew:

```bash
brew install postgresql@16
brew services start postgresql@16
createdb planka
```

If `createdb` says the database already exists, that is fine.

Homebrew usually creates a PostgreSQL role matching your macOS username. On this machine, that means the local app config uses `itpaspire`, not `postgres`.

## 2. Install npm dependencies

From the repo root:

```bash
npm install
```

This installs root, server, and client dependencies via the existing `postinstall` script.

## 3. Initialize the database

```bash
npm run server:db:init
```

This runs migrations and seeds the default admin from [server/.env](/Users/itpaspire/Documents/code/planka/server/.env).

## 4. Start the app

In one terminal:

```bash
npm run server:start
```

In a second terminal:

```bash
npm run client:start
```

## 5. Build the server-served client shell

The backend root route expects the built client shell and linked assets:

```bash
INDEX_FORMAT=ejs DISABLE_ESLINT_PLUGIN=true npm run client:build
bash client/tests/setup-symlinks.sh
```

Run this once after a fresh checkout, or again any time you need to refresh the server-served built assets.

## URLs

- Frontend: `http://localhost:3000`
- API/backend: `http://localhost:1337`

## Default local login

- Email: `admin@local.test`
- Password: `admin1234`

## Notes

- The repo expects Node `>=20`. Your machine is currently on Node `v25.9.0`, which may work, but if install/runtime issues appear, switch to Node 20 or 22 first.
- The client proxies API calls to `http://localhost:1337`, so keep the backend running while using the frontend.
