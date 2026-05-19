from fastapi import FastAPI
from app.api.routes import router as api_router
from app.core.database import engine, Base

# Create database tables automatically
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Antigravity ServiceSathi Orchestrator")

app.include_router(api_router, prefix="/api")

@app.get("/")
def read_root():
    return {"message": "Welcome to ServiceSathi API. Use /docs for documentation."}
