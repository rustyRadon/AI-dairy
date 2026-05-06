use crate::config::Config;
use mongodb::{options::ClientOptions, Client, Database as MongoDatabase};

#[derive(Clone)]
pub struct Database {
    pub client: Client,
    pub inner: MongoDatabase,
}

pub async fn connect(config: &Config) -> anyhow::Result<Database> {
    let mut client_options = ClientOptions::parse(&config.mongo_uri).await?;
    client_options.app_name = Some("ai_diary_backend_rust".to_string());
    let client = Client::with_options(client_options)?;
    let db = client.database("ai_diary");

    Ok(Database { client, inner: db })
}
