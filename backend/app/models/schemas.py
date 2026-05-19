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

    model_config = ConfigDict(from_attributes=True)

class OrchestratorResponse(BaseModel):
    intent: IntentOutput
    recommended_provider: Optional[ProviderResponse] = None
    reasoning: str
    booking: Optional[BookingConfirmation] = None
    follow_up_schedule: List[str] = []
    agent_trace: List[dict] = []

# Authentication Schemas
class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    phone: Optional[str] = None

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    phone: Optional[str] = None
    is_active: bool

    model_config = ConfigDict(from_attributes=True)

class UserLogin(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: str

class ResetPasswordRequest(BaseModel):
    email: str
    otp: str
    new_password: str

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

class TokenData(BaseModel):
    email: Optional[str] = None
