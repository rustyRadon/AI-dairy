mod app;
mod auth;
mod config;
mod db;
mod handlers;
mod models;
mod routes;
mod services;
mod utils;

use anyhow::Context;
use config::Config;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();
    let config = Config::from_env().context("Failed to load configuration")?;
    let db = db::connect(&config).await?;
    let app = app::create_app(&config, db);
    let addr = std::net::SocketAddr::from(([127, 0, 0, 1], config.port));

    tracing::info!(%addr, "Starting backend-rust server");
    let listener = tokio::net::TcpListener::bind(&addr).await?;
    axum::serve(
        listener,
        app.into_make_service_with_connect_info::<std::net::SocketAddr>(),
    )
    .await
    .context("Server failed")?;

    Ok(())
}
