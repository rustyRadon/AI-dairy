use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct InboxItem {
    pub id: String,
    pub user_id: String,
    pub message: String,
    pub read: bool,
    pub created_at: String,
}
