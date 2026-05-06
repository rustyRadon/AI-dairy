use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct MemoryItem {
    pub id: String,
    pub user_id: String,
    pub text: String,
    pub tags: Vec<String>,
    pub created_at: String,
}
