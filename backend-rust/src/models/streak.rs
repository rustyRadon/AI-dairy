use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct StreakSummary {
    pub user_id: String,
    pub current_streak: u32,
    pub longest_streak: u32,
    pub last_active_date: String,
}
