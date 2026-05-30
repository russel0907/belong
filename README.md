# belong

**Helping lost items find their way home.**

Belong is a community-driven lost and found platform that helps reunite people with their belongings. Users can report lost or found items, match them through smart search, and coordinate returns — all within a trusted community network.

## Project Structure

```
belong/
├── app/          # Flutter mobile application (iOS & Android)
├── admin/        # Admin web panel (React + Vite + TypeScript)
├── backend/      # API server (Node.js + TypeScript + Express)
├── docs/         # Project documentation
└── README.md
```

## Getting Started

### Prerequisites

- **Flutter** 3.41+ — for the mobile app
- **Node.js** 20+ — for backend and admin
- **npm** 10+ — package manager

### Mobile App (`app/`)

```bash
cd app
flutter pub get
flutter run
```

### Admin Panel (`admin/`)

```bash
cd admin
npm install
npm run dev
```

The admin dev server runs at `http://localhost:5173`.

### Backend API (`backend/`)

```bash
cd backend
npm install
npm run dev
```

The API server runs at `http://localhost:3001`.

Health check: `GET /health`

## Modules

| Module   | Stack                          | Description                        |
|----------|--------------------------------|------------------------------------|
| `app/`   | Flutter (Dart)                 | Mobile app for end users           |
| `admin/` | React + Vite + TypeScript      | Admin dashboard for moderators     |
| `backend`| Node.js + Express + TypeScript | REST API server                    |
| `docs/`  | Markdown                       | Architecture & design documentation |

## License

MIT
