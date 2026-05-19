<div align="center">

# 🤖 ServiceSathi AI
### *Ghar ki zaroorat, ek awaaz mein.*

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009688?style=for-the-badge&logo=fastapi)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Railway-336791?style=for-the-badge&logo=postgresql)
![Groq](https://img.shields.io/badge/Groq-LLaMA_3.1-orange?style=for-the-badge)
![Google Maps](https://img.shields.io/badge/Google_Maps-API-4285F4?style=for-the-badge&logo=googlemaps)
![Railway](https://img.shields.io/badge/Deployed_on-Railway-0B0D0E?style=for-the-badge&logo=railway)

**An AI-powered multi-agent platform that connects Pakistani citizens with local home service providers using voice, Urdu/English NLU, and real-time location.**

[🌐 Live API](https://service-sathi-production.up.railway.app/api) · [📖 API Docs](https://service-sathi-production.up.railway.app/docs) · [💚 Health Check](https://service-sathi-production.up.railway.app/api/health)

</div>

---

## 📁 Repository Structure

```
ServiceSathiAI/
├── backend/          # FastAPI Python backend — AI agents, REST API, DB
└── flutter_app/      # Flutter mobile app — Android/iOS frontend
```

---

## 🧠 What is ServiceSathi AI?

ServiceSathi AI is an intelligent home service discovery platform built for Pakistani users. A user simply describes what they need — in **Urdu, English, or Roman Urdu** — by typing or speaking, and the AI pipeline does the rest:

1. 🧾 **Understands** intent (service type, location, timing, language)
2. 📍 **Geocodes** the location using Google Maps API
3. 🔍 **Discovers** nearby providers from a live PostgreSQL database
4. 🏆 **Ranks** providers by rating and real GPS distance
5. ✅ **Books** the best match and schedules automated follow-ups
6. 📱 **Displays** results on a beautiful Flutter UI with Maps, Call, and Directions

---

## 🏗️ Multi-Agent Pipeline Architecture

```
User Request (Voice / Text — Urdu / English / Roman Urdu)
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
│ (Provider Search) │    Real distance via Haversine formula
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
│ (Book & Schedule) │    Confirms booking, generates 4-step follow-up plan
└───────────────────┘
        │
        ▼
  OrchestratorResponse (JSON) → Flutter App
```

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Mobile App** | Flutter 3.x (Dart) |
| **Backend Framework** | FastAPI (Python 3.11) |
| **AI / LLM** | Groq API — LLaMA 3.1 8B Instant |
| **Database** | PostgreSQL on Railway |
| **ORM** | SQLAlchemy |
| **Geocoding** | Google Maps Geocoding API |
| **Distance Calc** | Haversine Formula |
| **Voice Input** | `speech_to_text` Flutter plugin |
| **Maps UI** | `google_maps_flutter` |
| **Deployment** | Railway (auto-deploy from GitHub) |
| **Validation** | Pydantic v2 |

---

## ⚙️ Backend Setup — `backend/`

### Prerequisites
- Python 3.11+
- PostgreSQL database (or use the Railway hosted DB URL)
- Groq API Key → [console.groq.com](https://console.groq.com)
- Google Maps API Key → [console.cloud.google.com](https://console.cloud.google.com)

### Local Installation

```bash
# 1. Clone the repo
git clone https://github.com/Nav33dCodes/service-sathi.git
cd service-sathi/backend

# 2. Create and activate virtual environment
python -m venv venv
venv\Scripts\activate          # Windows
# source venv/bin/activate     # macOS/Linux

# 3. Install dependencies
pip install -r requirements.txt

# 4. Create .env file
cp .env.template .env
# Fill in your keys (see Environment Variables section below)

# 5. Seed the database with sample providers
python seed_data.py

# 6. Start the server
uvicorn app.main:app --reload
```

- **Server:** `http://localhost:8000`
- **Interactive Docs (Swagger):** `http://localhost:8000/docs`

### Environment Variables

Create a `.env` file inside `backend/`:

```env
GROQ_API_KEY=your_groq_api_key_here
DATABASE_URL=postgresql://user:password@host:port/dbname
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

> **Required Google Cloud APIs:** Maps SDK for Android · Geocoding API · Places API

---

## 📡 API Reference

### `POST /api/request` — Main AI Orchestration

Accepts natural language input, runs the full 4-agent pipeline.

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
  "reasoning": "Selected Ali AC Services — Highest rated (4.8⭐) and only 1.2km away",
  "booking": {
    "booking_id": 42,
    "provider_name": "Ali AC Services",
    "scheduled_time": "Tomorrow morning",
    "status": "Confirmed"
  },
  "follow_up_schedule": ["...", "..."],
  "agent_trace": [...]
}
```

### `GET /api/providers` — List All Providers
Optionally pass `?location=G-13` for real-time distance calculation.

### `GET /api/bookings` — List All Bookings
Returns all confirmed bookings from the database.

### `GET /api/health` — Health Check
```json
{ "status": "ok", "service": "ServiceSathi AI Backend", "version": "2.0" }
```

---

## 🗄️ Database Schema

### `providers` table

| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Primary key |
| `name` | String | Provider full name |
| `service` | String | Service category |
| `location` | String | Area/neighbourhood |
| `lat` | Float | GPS latitude |
| `lng` | Float | GPS longitude |
| `rating` | Float | Rating out of 5.0 |
| `available` | Boolean | Currently available |
| `experience` | Integer | Years of experience |
| `phone` | String | Contact number (WhatsApp) |
| `price_range` | String | `$`, `$$`, or `$$$` |

### `bookings` table

| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Primary key / Booking ID |
| `user_request` | String | Original user query |
| `provider_id` | FK | Links to providers |
| `scheduled_time` | String | When provider will arrive |
| `status` | String | Confirmed / Cancelled |

---

## 📱 Flutter App Setup — `flutter_app/`

### Prerequisites
- Flutter SDK 3.x → [flutter.dev/get-started](https://flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter plugin
- Android device or emulator (API 21+)
- Google Maps API Key (same key as backend)

### Installation

```bash
cd service-sathi/flutter_app

# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### Flutter Dependencies

| Package | Purpose |
|---------|---------|
| `http` | REST API calls to FastAPI backend |
| `google_fonts` | Premium typography (Inter / Outfit) |
| `glassmorphism` | Glass-card UI effects |
| `lucide_icons` | Modern icon set |
| `speech_to_text` | Voice-to-text (Urdu & English) |
| `google_maps_flutter` | Provider map with dark theme |
| `url_launcher` | One-tap call & directions |

### Add Your Google Maps API Key

In `flutter_app/android/app/src/main/AndroidManifest.xml`, add:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

### App Features

| Feature | Description |
|---------|-------------|
| 🗣️ **Voice Input** | Speak your request in Urdu, English, or Roman Urdu |
| 🤖 **AI Chat** | Natural language service request processing |
| 📍 **Live Map** | Google Maps with dark theme showing provider location |
| 📞 **One-tap Call** | Instantly call the matched provider |
| 🧭 **Directions** | Turn-by-turn navigation to provider |
| 📋 **Bookings** | View all confirmed bookings |
| 🔍 **Agent Logs** | See the AI agent pipeline trace in real-time |

---

## 🌍 Deployment

### Backend — Railway

The backend auto-deploys to Railway on every push to `main`.

**Procfile** (`backend/Procfile`):
```
web: uvicorn app.main:app --host 0.0.0.0 --port $PORT
```

**Live URL:** `https://service-sathi-production.up.railway.app`

To deploy your own instance:
1. Fork this repo
2. Create a new Railway project → connect your fork
3. Set environment variables in Railway dashboard
4. Railway auto-detects the Procfile and deploys

### Flutter App — Android Release

```bash
cd flutter_app
flutter build apk --release
# APK → flutter_app/build/outputs/flutter-apk/app-release.apk
```

---

## 👨‍💻 Built By

**Naveed** — Built for a Hackathon Demo 🏆

> *ServiceSathi AI — Ghar ki zaroorat, ek awaaz mein.*  
> *"Your home service need, in one voice."*

---

<div align="center">
  <sub>Powered by Groq LLaMA 3.1 · Google Maps API · Railway · FastAPI · Flutter</sub>
</div>
