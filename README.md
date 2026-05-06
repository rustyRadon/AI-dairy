# AI Conversational Diary (MVP)

Mobile app + backend that lets users have daily conversations (text/voice) with an AI that **remembers** and helps them reflect over time.

## Repo structure

- `backend/`: Node.js API (MongoDB, OpenAI integration points)
- `mobile/`: Flutter mobile app (iOS/Android)

## Quickstart (backend)

### 1) Start MongoDB

```bash
docker compose up -d
```

### 2) Run the API

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

API will be at `http://localhost:3000`.

## MVP scope implemented here

- **Foundations**: API skeleton, Mongo connection, env validation
- **Planned endpoints** (to implement next): chat, memory extraction, memory recall, streaks

# AI-dairy
# AI-diary
