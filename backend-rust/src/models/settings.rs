use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Settings {
    pub user_id: String,
    pub theme: String,
    pub notifications_enabled: bool,
}
