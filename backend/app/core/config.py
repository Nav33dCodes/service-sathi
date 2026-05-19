from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    groq_api_key: str = ""
    google_maps_api_key: str = ""
    database_url: str = "sqlite:///./service_sathi.db" # Default fallback for local testing
    
    # JWT Auth Configuration
    jwt_secret: str = "323528b3df9e6717a61d1b913d80bf26ef6998ff1fca691c98114f6b528b6d8a" # Default fallback
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24 * 7 # 7 days session
    
    # SMTP/Email Integration Settings
    smtp_host: str = "smtp.gmail.com"
    smtp_port: int = 587
    smtp_username: str = ""
    smtp_password: str = ""
    
    class Config:
        env_file = ".env"

settings = Settings()
