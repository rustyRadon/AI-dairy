# Backend Rust Skeleton

This directory contains the Rust backend skeleton for the Ọ̀rẹ́ AI Diary project.

## Structure
- `src/main.rs`: Application entry point
- `src/app.rs`: Router and middleware setup
- `src/config.rs`: Environment configuration
- `src/db.rs`: Database client initialization
- `src/routes.rs`: Route registration
- `src/auth.rs`: Authorization middleware
- `src/handlers/`: HTTP request handlers
- `src/models/`: Domain and database models
- `src/services/`: Business logic services
- `src/utils/`: Shared utilities
- `backend-rust/tests/`: Integration and feature tests

## Run locally
1. Copy `.env.example` to `.env`
2. Adjust environment variables
3. Run `cargo run`
4. Confirm `http://127.0.0.1:3000/health`
