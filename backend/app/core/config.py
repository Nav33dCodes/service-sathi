from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    groq_api_key: str = ""
    google_maps_api_key: str = ""
    database_url: str = "sqlite:///./service_sathi.db" # Default fallback for local testing
    
    class Config:
        env_file = ".env"

settings = Settings()
