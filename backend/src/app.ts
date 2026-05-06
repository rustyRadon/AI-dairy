import cors from "cors";
import express from "express";

export function createApp() {
  const app = express();

  app.use(cors());
  app.use(express.json({ limit: "2mb" }));

  app.get("/health", (_req, res) => {
    res.json({ ok: true });
  });

  // Placeholder for MVP routes:
  // - POST /v1/chat
  // - POST /v1/memory/extract
  // - POST /v1/memory/recall
  // - GET  /v1/streak

  return app;
}

