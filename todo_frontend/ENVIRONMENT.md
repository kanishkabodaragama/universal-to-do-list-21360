Environment setup

Create a .env file at universal-to-do-list-21360/todo_frontend/.env with:
BACKEND_BASE_URL=https://<host>:<port>

Notes:
- Do not add a trailing slash.
- This file is loaded at runtime by flutter_dotenv.
- For CI/builds, ensure this variable is defined or tests that depend on network are skipped.
