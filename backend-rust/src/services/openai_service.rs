use anyhow::Context;
use reqwest::Client;
use serde_json::json;

pub struct OpenAiService {
    pub api_key: String,
    pub client: Client,
}

impl OpenAiService {
    pub fn new(api_key: String) -> Self {
        Self {
            api_key,
            client: Client::new(),
        }
    }

    pub async fn generate_reply(&self, user_text: &str) -> anyhow::Result<String> {
        let request_body = json!({
            "model": "gpt-4o-mini",
            "messages": [
                {
                    "role": "system",
                    "content": "You are Ọ̀rẹ́, a mindful and empathetic AI diary companion. Keep responses warm and concise."
                },
                { "role": "user", "content": user_text }
            ],
            "max_tokens": 300,
        });

        let response = self.client
            .post("https://api.openai.com/v1/chat/completions")
            .bearer_auth(&self.api_key)
            .json(&request_body)
            .send()
            .await
            .context("OpenAI request failed")?;

        let json: serde_json::Value = response.json().await?;
        
        let text = json["choices"][0]["message"]["content"]
            .as_str()
            .context("Failed to extract content from OpenAI response")?
            .to_string();
            
        Ok(text)
    }
}