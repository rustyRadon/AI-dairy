use crate::models::conversation::Conversation;

pub async fn send_message(_conversation: &mut Conversation, _message: &str) -> anyhow::Result<String> {
    Ok("Response placeholder".to_string())
}
