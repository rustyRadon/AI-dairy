use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Insight {
    pub id: String,
    pub user_id: String,
    pub kind: String,
    pub title: String,
    pub content: String,
    pub created_at: String,
}
