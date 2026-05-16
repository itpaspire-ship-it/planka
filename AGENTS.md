# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project Shape

- `client/` contains the React frontend built with Vite.
- `server/` contains the Sails backend and database tooling.
- `database/`, `charts/`, and `assets/` hold supporting deployment, data, and static resources.
- Root `package.json` scripts delegate to `client` and `server`; prefer those root scripts when working across both apps.

## Common Commands

- Install dependencies: `npm install`
- Start both apps: `npm start`
- Start backend only: `npm run server:start`
- Start frontend only: `npm run client:start`
- Build frontend: `npm run client:build`
- Build backend: `npm run server:build`
- Lint everything: `npm run lint`
- Lint backend: `npm run server:lint`
- Lint frontend: `npm run client:lint`
- Run all tests: `npm test`
- Run backend tests: `npm run server:test`
- Run frontend tests: `npm run client:test`

For local setup details, see `LOCALHOST.md`. The app expects Node `>=20`.

## Database Commands

- Seed initial database data: `npm run server:db:init`
- Seed database: `npm run server:db:seed`
- Create an admin user: `npm run server:db:create-admin-user`

## Code Style

- Follow the existing Airbnb + Prettier configuration.
- JavaScript uses single quotes, trailing commas, and a 100-column print width.
- Keep changes scoped to the requested behavior; avoid broad refactors unless they are necessary.
- Prefer existing local utilities, patterns, components, actions, selectors, and services over introducing new abstractions.
- Do not edit generated build output or archives unless the task explicitly requires it.

## Frontend Notes

- Client source lives under `client/src`.
- Reuse existing React, Redux, saga, selector, and component patterns.
- Run `npm run client:lint` after frontend changes when practical.
- For UI work, verify the page in a browser when a local dev server is available.

## Backend Notes

- Server source lives under `server`.
- Reuse the existing Sails conventions for controllers, models, helpers, services, and policies.
- Database seed helpers live under `server/db`.
- Run `npm run server:lint` and relevant backend tests after backend changes when practical.

## Git And Workspace Hygiene

- Check `git status --short` before editing and before finishing.
- Preserve user changes and untracked files you did not create.
- Do not run destructive git commands such as `git reset --hard` or `git checkout --` unless the user explicitly asks.
- If you touch both client and server behavior, consider running root `npm run lint` and `npm test` before finalizing.
