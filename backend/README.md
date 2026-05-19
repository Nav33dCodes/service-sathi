# 🤖 ServiceSathi AI — Backend

<div align="center">

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009688?style=for-the-badge&logo=fastapi)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Railway-336791?style=for-the-badge&logo=postgresql)
![Groq](https://img.shields.io/badge/Groq-LLaMA_3.1-orange?style=for-the-badge)
![Google Maps](https://img.shields.io/badge/Google_Maps-Geocoding_API-4285F4?style=for-the-badge&logo=googlemaps)
![Railway](https://img.shields.io/badge/Deployed_on-Railway-0B0D0E?style=for-the-badge&logo=railway)

**An AI-powered multi-agent orchestration backend for intelligent home service discovery in Pakistan.**

[Live API](https://service-sathi-production.up.railway.app/api) · [API Docs](https://service-sathi-production.up.railway.app/docs) · [Health Check](https://service-sathi-production.up.railway.app/api/health)

</div>

---

## 🧠 What is ServiceSathi AI?

ServiceSathi AI is an intelligent service-matching platform built for Pakistani users. Users describe what they need — in Urdu, English, or Roman Urdu — and the AI pipeline:

1. **Understands** their intent (service type, location, timing, language)
2. **Discovers** nearby providers from a live PostgreSQL database
3. **Geocodes** user location using Google Maps API for real distance calculation
4. **Ranks** providers by rating and proximity
5. **Books** the best provider and schedules automated follow-ups

---

## 🏗️ Architecture — Multi-Agent Pipeline

```
User Request (Natural Language)
        │
        ▼
┌───────────────────┐
│   IntentAgent     │  ← LLaMA 3.1 via Groq API
│  (NLU Parsing)    │    Extracts: service, location, time, language
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  DiscoveryAgent   │  ← PostgreSQL (Railway) + Google Maps Geocoding
│ (Provider Search) │    Real distance calculation via Haversine formula
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  DecisionAgent    │  ← Custom ranking algorithm
│  (AI Matching)    │    Ranks by: rating ↓, distance ↑
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  ExecutionAgent   │  ← DB write + follow-up pipeline generation
│ (Book & Schedule) │    Confirms booking, generates 4-step follow-up
└───────────────────┘
        │
        ▼
  OrchestratorResponse (JSON)
```

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | FastAPI (Python 3.11) |
| **AI / LLM** | Groq API — LLaMA 3.1 8B Instant |
| **Database** | PostgreSQL on Railway |
| **ORM** | SQLAlchemy |
| **Geocoding** | Google Maps Geocoding API |
| **Distance Calc** | Haversine Formula |
| **Deployment** | Railway (auto-deploy from GitHub) |
| **Validation** | Pydantic v2 |

---

## 📡 API Endpoints

### `POST /api/request`
Main AI orchestration endpoint. Accepts natural language input, runs the full multi-agent pipeline.

**Request:**
```json
{
  "text": "Mujhe G-13 mein AC technician chahiye kal subah"
}
```

**Response:**
```json
{
  "intent": {
    "service_type": "AC Technician",
    "location": "G-13",
    "time": "Tomorrow morning",
    "language": "Roman Urdu"
  },
  "recommended_provider": {
    "id": 1,
    "name": "Ali AC Services",
    "service": "AC Technician",
    "location": "G-13",
    "lat": 33.6491,
    "lng": 72.9691,
    "rating": 4.8,
    "distance": 1.2,
    "experience": 5,
    "phone": "+923001234567",
    "price_range": "$$"
  },
  "reasoning": "Selected Ali AC Services — Highest rated (4.8⭐) and only 1.2km away...",
  "booking": {
    "booking_id": 42,
    "provider_name": "Ali AC Services",
    "scheduled_time": "Tomorrow morning",
    "status": "Confirmed"
  },
  "follow_up_schedule": ["..."],
  "agent_trace": [...]
}
```

---

### `GET /api/providers`
Returns all available providers. Optionally accepts a `?location=` param for real-time distance calculation.

```
GET /api/providers?location=G-13
```

---

### `GET /api/bookings`
Returns all confirmed bookings from the database.

---

### `GET /api/health`
Health check endpoint for uptime monitoring.

```json
{ "status": "ok", "service": "ServiceSathi AI Backend", "version": "2.0" }
```

---

## ⚙️ Local Setup

### Prerequisites
- Python 3.11+
- PostgreSQL (or use the Railway DB URL)
- Google Maps API Key
- Groq API Key

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/Nav33dCodes/service-sathi.git
cd service-sathi/backend

# 2. Create and activate virtual environment
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

# 3. Install dependencies
pip install -r requirements.txt

# 4. Create .env file
cp .env.template .env
# Fill in your keys (see .env.template)

# 5. Seed the database
python seed_data.py

# 6. Run the server
uvicorn app.main:app --reload
```

Server runs at: `http://localhost:8000`  
Interactive docs at: `http://localhost:8000/docs`

---

## 🔐 Environment Variables

Create a `.env` file in the `backend/` directory:

```env
GROQ_API_KEY=your_groq_api_key_here
DATABASE_URL=postgresql://user:password@host:port/dbname
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

> **Required Google Cloud APIs:**
> - Maps SDK for Android
> - Geocoding API
> - Places API

---

## 🗄️ Database Schema

### `providers` table
| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Primary key |
| `name` | String | Provider full name |
| `service` | String | Service category |
| `location` | String | Area/neighborhood |
| `lat` | Float | GPS latitude |
| `lng` | Float | GPS longitude |
| `rating` | Float | Rating out of 5.0 |
| `available` | Boolean | Currently available |
| `experience` | Integer | Years of experience |
| `phone` | String | Contact number |
| `price_range` | String | `$`, `$$`, or `$$$` |

### `bookings` table
| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Primary key / booking ID |
| `user_request` | String | Original user text |
| `provider_id` | FK | Links to providers |
| `scheduled_time` | String | When to arrive |
| `status` | String | Confirmed / Cancelled |

---

## 🌍 Deployment — Railway

This backend auto-deploys to Railway on every push to `main`.

**Procfile:**
```
web: uvicorn app.main:app --host 0.0.0.0 --port $PORT
```

**Live URL:** `https://service-sathi-production.up.railway.app`

---

## 📱 Flutter App

The frontend Flutter app connects to this backend. See [`/service_sathi_app`](../service_sathi_app) for setup.

Features powered by this backend:
- 🗣️ Voice + text service requests (Urdu/English/Roman Urdu)
- 📍 Google Maps provider location with dark theme
- 📞 One-tap Call provider
- 🧭 Turn-by-turn Directions
- 📋 Booking confirmation with follow-up pipeline

---

## 👨‍💻 Built By

**Naveed** — Built for a Hackathon Demo  
ServiceSathi AI — *Ghar ki zaroorat, ek awaaz mein.*

---

<div align="center">
  <sub>Powered by Groq LLaMA 3.1 · Google Maps API · Railway · FastAPI</sub>
</div>
