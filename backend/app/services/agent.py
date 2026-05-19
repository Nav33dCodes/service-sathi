import json
from groq import Groq
from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.schemas import IntentOutput, ProviderResponse, BookingConfirmation, OrchestratorResponse
from app.models.domain import ProviderModel, BookingModel
import googlemaps
import math

def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0  # Earth radius in kilometers
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat / 2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c
    return round(distance, 1)

def geocode_location(location: str) -> tuple[float | None, float | None]:
    """Geocode a location string to lat/lng using Google Maps API."""
    if not location or location.lower() == "unknown":
        return None, None
    if not settings.google_maps_api_key:
        return None, None
    
    try:
        gmaps = googlemaps.Client(key=settings.google_maps_api_key)
        # Add Pakistan context for better geocoding accuracy
        query = f"{location}, Pakistan"
        geocode_result = gmaps.geocode(query)
        if geocode_result:
            loc = geocode_result[0]['geometry']['location']
            return loc['lat'], loc['lng']
    except Exception as e:
        print(f"[Geocoding ERROR] {e}")
    return None, None

# Initialize Groq Client
client = Groq(api_key=settings.groq_api_key)

def get_groq_completion(prompt: str) -> str:
    if not settings.groq_api_key:
        raise ValueError("Groq API Key is not set in environment.")
    
    response = client.chat.completions.create(
        messages=[{"role": "user", "content": prompt}],
        model="llama-3.1-8b-instant",
        temperature=0.0,
        response_format={"type": "json_object"}
    )
    return response.choices[0].message.content

class IntentAgent:
    """Agent responsible for understanding natural language and extracting structured intent."""
    def execute(self, user_text: str) -> dict:
        prompt = f"""
        You are an AI assistant that extracts service requests from Pakistani users.
        User Input: "{user_text}"
        Extract the following information and return ONLY a JSON object:
        - service_type (e.g., "AC Technician", "Plumber", "Electrician")
        - location (e.g., "G-13", "Clifton", "DHA", "F-11")
        - time (e.g., "Tomorrow morning", "Today 5 PM", "ASAP")
        - language (e.g., "Urdu", "English", "Roman Urdu")
        
        If any field is missing, infer it from context or use "Unknown".
        JSON Format required:
        {{
          "service_type": "...",
          "location": "...",
          "time": "...",
          "language": "..."
        }}
        """
        response_text = get_groq_completion(prompt)
        return json.loads(response_text)

class DiscoveryAgent:
    """Agent responsible for querying external tools/databases for context."""
    def execute(self, db: Session, service_type: str, location: str) -> list[ProviderModel]:
        query = db.query(ProviderModel).filter(ProviderModel.available == True)
        
        if service_type and service_type.lower() != "unknown":
            # Match the first word (e.g., 'AC' from 'AC Repair') for broader matching
            search_term = service_type.split()[0]
            query = query.filter(ProviderModel.service.ilike(f"%{search_term}%"))
            
        providers = query.all()
        
        # Geocode user location with Pakistan context
        user_lat, user_lng = geocode_location(location)
        print(f"[DiscoveryAgent] Geocoded '{location}' → lat={user_lat}, lng={user_lng}")
        
        # Calculate distance and attach to provider
        for provider in providers:
            if user_lat is not None and user_lng is not None:
                if provider.lat and provider.lng:
                    distance = haversine(user_lat, user_lng, provider.lat, provider.lng)
                else:
                    distance = 5.0
            else:
                # Fallback: text match on location field
                distance = 2.0 if location.lower() in (provider.location or "").lower() else 10.0
            setattr(provider, "_distance", distance)
            
        return providers

class DecisionAgent:
    """Agent responsible for matching, ranking, and explaining its reasoning."""
    def execute(self, providers: list[ProviderModel], intent: dict) -> dict:
        if not providers:
            return {"provider": None, "reasoning": "No providers found for the requested service and location."}
        
        # Ensure all have distance
        for p in providers:
            if not hasattr(p, "_distance"):
                setattr(p, "_distance", 10.0)
                
        # Ranking logic: highest rating first, then shortest distance
        ranked = sorted(providers, key=lambda x: (-x.rating, x._distance))
        best_provider = ranked[0]
        
        dist = getattr(best_provider, "_distance", 5.0)
        phone_info = f" | 📞 {best_provider.phone}" if best_provider.phone else ""
        reasoning = (
            f"✅ Selected **{best_provider.name}** — Highest rated ({best_provider.rating}⭐) "
            f"and only {dist}km away from {intent.get('location', 'your location')}. "
            f"Specializes in {best_provider.service} with {best_provider.experience} years experience.{phone_info}"
        )
        return {"provider": best_provider, "reasoning": reasoning}

class ExecutionAgent:
    """Agent responsible for simulating real-world actions (bookings, follow-ups)."""
    def generate_whatsapp_message(self, provider_name: str, service_type: str, location: str, scheduled_time: str, booking_id: int, language: str) -> str:
        prompt = f"""
        You are ServiceSathi AI. Generate a professional and polite notification message in the user's language: "{language}" (can be English, Roman Urdu, or Urdu script) to be sent on WhatsApp to the service provider.
        
        Details:
        - Provider Name: {provider_name}
        - Service requested: {service_type}
        - Location: {location}
        - Scheduled Time: {scheduled_time}
        - Booking Reference ID: #{booking_id}
        
        Generate ONLY the plain text of the WhatsApp message. Do not include any intro, outro, HTML, markdown blocks, quotes, or JSON formatting. Keep it short and readable for mobile.
        """
        try:
            json_prompt = f"""
            {prompt}
            Return ONLY a JSON object with a single key "message".
            JSON Format:
            {{
              "message": "..."
            }}
            """
            response_text = get_groq_completion(json_prompt)
            data = json.loads(response_text)
            return data.get("message", "")
        except Exception as e:
            print(f"[WhatsApp Agent ERROR] {e}")
            return (
                f"Assalam-o-Alaikum {provider_name}, ServiceSathi booking confirmed!\n"
                f"Service: {service_type}\n"
                f"Location: {location}\n"
                f"Time: {scheduled_time}\n"
                f"Ref ID: #{booking_id}"
            )

    def execute_booking(self, db: Session, user_text: str, provider: ProviderModel, scheduled_time: str, language: str) -> BookingConfirmation:
        new_booking = BookingModel(
            user_request=user_text,
            provider_id=provider.id,
            scheduled_time=scheduled_time,
            status="Confirmed"
        )
        db.add(new_booking)
        db.commit()
        db.refresh(new_booking)
        
        whatsapp_msg = self.generate_whatsapp_message(
            provider_name=provider.name,
            service_type=provider.service,
            location=provider.location,
            scheduled_time=scheduled_time,
            booking_id=new_booking.id,
            language=language
        )
        
        return BookingConfirmation(
            booking_id=new_booking.id,
            provider_name=provider.name,
            scheduled_time=scheduled_time,
            status="Confirmed",
            whatsapp_message=whatsapp_msg
        )

    def generate_follow_up(self, scheduled_time: str) -> list[str]:
        return [
            f"📅 Reminder scheduled 1 hour before: {scheduled_time}",
            "📍 Real-time provider location tracking will activate 30 mins before arrival.",
            "⭐ Completion & rating prompt scheduled after service ends.",
            "💬 Feedback survey will be sent 2 hours post-completion."
        ]

def run_orchestrator(db: Session, user_text: str) -> OrchestratorResponse:
    """The central ServiceSathi Orchestrator that coordinates the multi-agent pipeline."""
    trace = []
    
    # Initialize our Agents
    intent_agent = IntentAgent()
    discovery_agent = DiscoveryAgent()
    decision_agent = DecisionAgent()
    execution_agent = ExecutionAgent()
    
    # --- PHASE 1: PLANNING & UNDERSTANDING ---
    trace.append({"step": "Intent Extraction", "agent": "IntentAgent", "input": user_text, "status": "Running"})
    intent_dict = intent_agent.execute(user_text)
    intent = IntentOutput(**intent_dict)
    trace[-1]["result"] = f"Detected: {intent.service_type} in {intent.location} ({intent.language})"
    trace[-1]["status"] = "Completed"
    
    # --- PHASE 2: TOOL USAGE & DISCOVERY ---
    trace.append({"step": "Provider Discovery + Geocoding", "agent": "DiscoveryAgent", "query": f"{intent.service_type} in {intent.location}", "status": "Running"})
    providers = discovery_agent.execute(db, intent.service_type, intent.location)
    trace[-1]["result"] = f"Found {len(providers)} available providers. Google Maps Geocoding used for real distances."
    trace[-1]["status"] = "Completed"
    
    # --- PHASE 3: DECISION LOGIC ---
    trace.append({"step": "AI Matching & Decision", "agent": "DecisionAgent", "status": "Running"})
    decision = decision_agent.execute(providers, intent_dict)
    best_provider = decision["provider"]
    trace[-1]["result"] = decision["reasoning"]
    trace[-1]["status"] = "Completed"
    
    # --- PHASE 4: ACTION SIMULATION & FOLLOW-UP ---
    booking = None
    follow_up = []
    best_provider_response = None
    
    if best_provider:
        # Build ProviderResponse with distance properly set
        dist = getattr(best_provider, "_distance", 5.0)
        provider_data = {
            "id": best_provider.id,
            "name": best_provider.name,
            "service": best_provider.service,
            "location": best_provider.location,
            "lat": best_provider.lat,
            "lng": best_provider.lng,
            "rating": best_provider.rating,
            "distance": dist,
            "available": best_provider.available,
            "experience": best_provider.experience or 0,
            "phone": best_provider.phone,
            "price_range": best_provider.price_range,
        }
        best_provider_response = ProviderResponse(**provider_data)
        
        trace.append({"step": "Booking Execution", "agent": "ExecutionAgent", "action": "Book Provider", "status": "Running"})
        booking = execution_agent.execute_booking(db, user_text, best_provider, intent.time, intent.language)
        trace[-1]["result"] = f"Booking #{booking.booking_id} confirmed for {booking.provider_name} at {booking.scheduled_time}"
        trace[-1]["status"] = "Completed"
        
        trace.append({"step": "Follow-Up Scheduling", "agent": "ExecutionAgent", "status": "Running"})
        follow_up = execution_agent.generate_follow_up(intent.time)
        trace[-1]["result"] = f"{len(follow_up)} follow-up tasks scheduled in pipeline."
        trace[-1]["status"] = "Completed"
        
    return OrchestratorResponse(
        intent=intent,
        recommended_provider=best_provider_response,
        reasoning=decision["reasoning"],
        booking=booking,
        follow_up_schedule=follow_up,
        agent_trace=trace
    )
