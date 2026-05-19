from app.core.database import SessionLocal, engine, Base
from app.models.domain import ProviderModel

MOCK_PROVIDERS = [
    {"name": "Ali AC Services", "service": "AC Technician", "location": "G-13", "lat": 33.6491, "lng": 72.9691, "rating": 4.8, "available": True, "experience": 5, "phone": "+923001234567", "price_range": "$$"},
    {"name": "Hassan Plumbers", "service": "Plumber", "location": "G-13", "lat": 33.6511, "lng": 72.9711, "rating": 4.5, "available": True, "experience": 3, "phone": "+923007654321", "price_range": "$"},
    {"name": "Raza Electrician", "service": "Electrician", "location": "F-11", "lat": 33.6828, "lng": 73.0033, "rating": 4.2, "available": True, "experience": 8, "phone": "+923331234567", "price_range": "$$"},
    {"name": "Quick Fix AC", "service": "AC Technician", "location": "F-11", "lat": 33.6800, "lng": 73.0010, "rating": 3.9, "available": True, "experience": 2, "phone": "+923211234567", "price_range": "$"},
    {"name": "Karachi Coolers", "service": "AC Technician", "location": "Clifton", "lat": 24.8138, "lng": 67.0305, "rating": 4.7, "available": True, "experience": 10, "phone": "+923451234567", "price_range": "$$$"},
    {"name": "Sana Beautician", "service": "Beautician", "location": "G-13", "lat": 33.6520, "lng": 72.9650, "rating": 4.9, "available": True, "experience": 6, "phone": "+923009876543", "price_range": "$$"},
]

def seed_database():
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    
    db = SessionLocal()
    
    # Check if data already exists
    existing_count = db.query(ProviderModel).count()
    if existing_count == 0:
        for provider_data in MOCK_PROVIDERS:
            provider = ProviderModel(**provider_data)
            db.add(provider)
        db.commit()
        print("Mock providers seeded successfully.")
    else:
        print(f"Database already seeded with {existing_count} providers.")
        
    db.close()

if __name__ == "__main__":
    seed_database()
