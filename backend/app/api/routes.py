from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.core.database import get_db
from app.models.schemas import ServiceRequest, OrchestratorResponse, ProviderResponse, BookingConfirmation
from app.models.domain import ProviderModel, BookingModel
from app.services.agent import run_orchestrator, geocode_location, haversine

router = APIRouter()

@router.post("/request", response_model=OrchestratorResponse)
def handle_request(request: ServiceRequest, db: Session = Depends(get_db)):
    try:
        response = run_orchestrator(db, request.text)
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/providers", response_model=List[ProviderResponse])
def get_providers(
    db: Session = Depends(get_db),
    location: Optional[str] = Query(None, description="User location for distance calc e.g. G-13")
):
    providers = db.query(ProviderModel).all()
    
    # Try real geocoding if location is provided
    user_lat, user_lng = None, None
    if location:
        user_lat, user_lng = geocode_location(location)
    
    results = []
    for p in providers:
        if user_lat is not None and user_lng is not None and p.lat and p.lng:
            dist = haversine(user_lat, user_lng, p.lat, p.lng)
        else:
            dist = 5.0  # Default distance
        
        results.append(ProviderResponse(
            id=p.id,
            name=p.name,
            service=p.service,
            location=p.location,
            lat=p.lat,
            lng=p.lng,
            rating=p.rating,
            distance=dist,
            available=p.available,
            experience=p.experience or 0,
            phone=p.phone,
            price_range=p.price_range,
        ))
    return results

@router.get("/bookings", response_model=List[BookingConfirmation])
def get_bookings(db: Session = Depends(get_db)):
    bookings = db.query(BookingModel).all()
    results = []
    for b in bookings:
        provider_name = "Unknown Provider"
        provider = db.query(ProviderModel).filter(ProviderModel.id == b.provider_id).first()
        if provider:
            provider_name = provider.name
            
        results.append(BookingConfirmation(
            booking_id=b.id,
            provider_name=provider_name,
            scheduled_time=b.scheduled_time or "Not Scheduled",
            status=b.status or "Confirmed"
        ))
    return results

@router.get("/health")
def health_check():
    return {"status": "ok", "service": "ServiceSathi AI Backend", "version": "2.0"}
