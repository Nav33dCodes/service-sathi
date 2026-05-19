from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, DateTime
from app.core.database import Base
from datetime import datetime

class UserModel(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, nullable=True)
    hashed_password = Column(String, nullable=False)
    reset_otp = Column(String, nullable=True)
    otp_expires_at = Column(DateTime, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class ProviderModel(Base):
    __tablename__ = "providers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    service = Column(String, nullable=False)
    location = Column(String, nullable=False)
    lat = Column(Float, nullable=False)
    lng = Column(Float, nullable=False)
    rating = Column(Float, default=0.0)
    available = Column(Boolean, default=True)
    experience = Column(Integer, default=0)
    phone = Column(String, nullable=True)
    price_range = Column(String, nullable=True)

class BookingModel(Base):
    __tablename__ = "bookings"

    id = Column(Integer, primary_key=True, index=True)
    user_request = Column(String, nullable=True)
    provider_id = Column(Integer, ForeignKey("providers.id"))
    scheduled_time = Column(String, nullable=True)
    status = Column(String, default="Confirmed")
