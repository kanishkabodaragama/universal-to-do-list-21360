# Universal ToDo - Flutter Frontend

This Flutter app implements a cross-platform (mobile/desktop/web-capable) Todo UI with:
- Ocean Professional theme (blue primary with amber accents)
- Email/password authentication (register, login)
- Todos CRUD with filters (All, Active, Completed)
- Modular structure (services, providers, models, screens, widgets)

## Requirements
- Flutter SDK (>=3.7)
- A running backend (FastAPI). Use BACKEND_BASE_URL from .env to point to it.

## Setup
1. Copy `.env.example` to `.env` and set:
   BACKEND_BASE_URL=https://<host>:<port>
2. Get packages:
   flutter pub get
3. Run:
   flutter run

## Structure
- lib/src/app_theme.dart: Theme configuration.
- lib/src/services: API clients for auth and todos.
- lib/src/providers: State management with Provider.
- lib/src/screens: Login, Signup, Home, Todo Form screens.
- lib/src/widgets: Reusable UI components.

## Notes
- Tokens are persisted using SharedPreferences.
- Backend contract is based on provided OpenAPI:
  - POST /auth/register
  - POST /auth/token (x-www-form-urlencoded: username, password)
  - GET /users/me
  - GET/POST /todos, PUT/DELETE /todos/{id}
