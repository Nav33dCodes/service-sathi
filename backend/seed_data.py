import random
from app.core.database import SessionLocal, engine, Base
from app.models.domain import ProviderModel

# List of service types
SERVICES = ["AC Technician", "Plumber", "Electrician", "Tutor", "Beautician", "Painter"]

# First names for Pakistan
FIRST_NAMES = [
    "Ali", "Hassan", "Raza", "Sana", "Fatima", "Usman", "Bilal", "Hamza", "Zain", "Ayesha",
    "Maryam", "Kamran", "Imran", "Tariq", "Yasir", "Faisal", "Junaid", "Farhan", "Waleed",
    "Asad", "Amna", "Hina", "Sara", "Kiran", "Sadia", "Zahid", "Noman", "Basit", "Waseem",
    "Arsalan", "Zeeshan", "Mudassir", "Haris", "Saad", "Talha", "Umer", "Naveed", "Ahmed"
]

# Suffixes depending on service
SUFFIXES = {
    "AC Technician": ["AC Repair", "Cooling Services", "AC Experts", "Air Solutions", "AC Masters"],
    "Plumber": ["Plumbing", "Sanitary Works", "Plumber Services", "Water Fixers", "Plumb Pros"],
    "Electrician": ["Electricians", "Power Solutions", "Wiring Experts", "Electric Fix", "Electro Tech"],
    "Tutor": ["Academy", "Home Tuition", "Tutors", "Educational Center", "Learning Hub"],
    "Beautician": ["Salon", "Beauty Studio", "Makeover Salon", "Glamour Studio", "Beautician"],
    "Painter": ["Painters", "Decorators", "Wall Arts", "Painting Solutions", "Premium Paint"]
}

# Sectors/Locations in Islamabad and Clifton (Karachi) with base Lat/Lng
LOCATIONS = [
    {"name": "G-13", "lat": 33.6491, "lng": 72.9691},
    {"name": "F-11", "lat": 33.6828, "lng": 73.0033},
    {"name": "E-11", "lat": 33.6920, "lng": 72.9850},
    {"name": "I-8", "lat": 33.6680, "lng": 73.0750},
    {"name": "G-11", "lat": 33.6610, "lng": 72.9980},
    {"name": "F-10", "lat": 33.6910, "lng": 73.0120},
    {"name": "G-10", "lat": 33.6760, "lng": 73.0180},
    {"name": "F-8", "lat": 33.7110, "lng": 73.0380},
    {"name": "G-9", "lat": 33.6850, "lng": 73.0450},
    {"name": "F-7", "lat": 33.7220, "lng": 73.0580},
    {"name": "G-8", "lat": 33.6980, "lng": 73.0650},
    {"name": "F-6", "lat": 33.7290, "lng": 73.0780},
    {"name": "I-9", "lat": 33.6550, "lng": 73.0850},
    {"name": "I-10", "lat": 33.6400, "lng": 73.0650},
    {"name": "D-12", "lat": 33.7080, "lng": 72.9550},
    {"name": "Bahria Town", "lat": 33.5650, "lng": 73.1250},
    {"name": "DHA Phase 2", "lat": 33.5250, "lng": 73.1550},
    {"name": "Clifton", "lat": 24.8138, "lng": 67.0305},
]

def generate_mock_providers(count=50):
    providers = []
    # Seed fixed initial ones to maintain compatibility with existing tests
    fixed_initial = [
        {"name": "Ali AC Services", "service": "AC Technician", "location": "G-13", "lat": 33.6491, "lng": 72.9691, "rating": 4.8, "available": True, "experience": 5, "phone": "+923001234567", "price_range": "$$"},
        {"name": "Hassan Plumbers", "service": "Plumber", "location": "G-13", "lat": 33.6511, "lng": 72.9711, "rating": 4.5, "available": True, "experience": 3, "phone": "+923007654321", "price_range": "$"},
        {"name": "Raza Electrician", "service": "Electrician", "location": "F-11", "lat": 33.6828, "lng": 73.0033, "rating": 4.2, "available": True, "experience": 8, "phone": "+923331234567", "price_range": "$$"},
        {"name": "Quick Fix AC", "service": "AC Technician", "location": "F-11", "lat": 33.6800, "lng": 73.0010, "rating": 3.9, "available": True, "experience": 2, "phone": "+923211234567", "price_range": "$"},
        {"name": "Karachi Coolers", "service": "AC Technician", "location": "Clifton", "lat": 24.8138, "lng": 67.0305, "rating": 4.7, "available": True, "experience": 10, "phone": "+923451234567", "price_range": "$$$"},
        {"name": "Sana Beautician", "service": "Beautician", "location": "G-13", "lat": 33.6520, "lng": 72.9650, "rating": 4.9, "available": True, "experience": 6, "phone": "+923009876543", "price_range": "$$"},
    ]
    
    providers.extend(fixed_initial)
    used_names = {p["name"] for p in fixed_initial}
    
    for _ in range(count - len(fixed_initial)):
        service = random.choice(SERVICES)
        first_name = random.choice(FIRST_NAMES)
        suffix = random.choice(SUFFIXES[service])
        name = f"{first_name} {suffix}"
        
        # Ensure name uniqueness
        counter = 1
        while name in used_names:
            name = f"{first_name} {suffix} {counter}"
            counter += 1
        used_names.add(name)
        
        loc_choice = random.choice(LOCATIONS)
        location = loc_choice["name"]
        
        # Add small random offset to base coordinates to keep them distinct
        lat = round(loc_choice["lat"] + random.uniform(-0.005, 0.005), 4)
        lng = round(loc_choice["lng"] + random.uniform(-0.005, 0.005), 4)
        
        rating = round(random.uniform(3.5, 5.0), 1)
        available = random.choice([True, True, True, False]) # 75% availability
        experience = random.randint(1, 15)
        
        # Generate Pakistani mobile number format: +923XXYYYYYYY
        phone = f"+923{random.randint(0, 4)}{random.randint(0, 9)}{random.randint(1000000, 9999999)}"
        price_range = random.choice(["$", "$$", "$$$"])
        
        providers.append({
            "name": name,
            "service": service,
            "location": location,
            "lat": lat,
            "lng": lng,
            "rating": rating,
            "available": available,
            "experience": experience,
            "phone": phone,
            "price_range": price_range
        })
        
    return providers

def seed_database():
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    
    db = SessionLocal()
    
    # Delete existing providers to keep seed fresh and avoid duplicates
    db.query(ProviderModel).delete()
    db.commit()
    
    providers_list = generate_mock_providers(50)
    for provider_data in providers_list:
        provider = ProviderModel(**provider_data)
        db.add(provider)
    db.commit()
    print(f"Database successfully cleared and re-seeded with {len(providers_list)} providers.")
    db.close()

if __name__ == "__main__":
    seed_database()
