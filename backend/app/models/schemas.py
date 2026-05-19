from pydantic import BaseModel, ConfigDict
from typing import List, Optional

class ServiceRequest(BaseModel):
    text: str

class IntentOutput(BaseModel):
    service_type: str
    location: str
    time: str
    language: str

class ProviderResponse(BaseModel):
    id: int
    name: str
    service: str
    location: str
    lat: float
    lng: float
    rating: float
    distance: float = 0.0
    available: bool
    experience: int = 0
    phone: Optional[str] = None
    price_range: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class BookingConfirmation(BaseModel):
    booking_id: int
    provider_name: str
    scheduled_time: str
    status: str
    whatsapp_message: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class OrchestratorResponse(BaseModel):
    intent: IntentOutput
    recommended_provider: Optional[ProviderResponse] = None
    reasoning: str
    booking: Optional[BookingConfirmation] = None
    follow_up_schedule: List[str] = []
    agent_trace: List[dict] = []
