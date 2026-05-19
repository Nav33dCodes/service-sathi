<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,50:0a3d62,100:1e3799&height=200&section=header&text=ServiceSathi%20AI&fontSize=60&fontColor=ffffff&fontAlignY=38&desc=Ghar%20ki%20zaroorat%2C%20ek%20awaaz%20mein.&descAlignY=58&descSize=20&animation=fadeIn" width="100%"/>

<br/>

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&size=22&duration=3000&pause=800&color=00D9FF&center=true&vCenter=true&multiline=false&width=700&lines=🤖+AI-Powered+Home+Service+Discovery;🗣️+Supports+Urdu+%2B+English+%2B+Roman+Urdu;📍+Real-Time+Location+%26+Distance+Matching;🚀+Multi-Agent+LLM+Orchestration+Pipeline;📱+Flutter+App+%2B+FastAPI+Backend)](https://git.io/typing-svg)

<br/>

![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Railway-336791?style=for-the-badge&logo=postgresql&logoColor=white)

![Groq](https://img.shields.io/badge/Groq-LLaMA_3.1_8B-FF6B35?style=for-the-badge&logoColor=white)
![Google Maps](https://img.shields.io/badge/Google_Maps-Geocoding_API-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)
![Railway](https://img.shields.io/badge/Deployed_on-Railway-0B0D0E?style=for-the-badge&logo=railway&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

<br/>

[![Live API](https://img.shields.io/badge/🌐_Live_API-service--sathi.railway.app-00D9FF?style=for-the-badge)](https://service-sathi-production.up.railway.app/api)
[![API Docs](https://img.shields.io/badge/📖_Swagger_Docs-/docs-FF6B35?style=for-the-badge)](https://service-sathi-production.up.railway.app/docs)
[![Health](https://img.shields.io/badge/💚_Health_Check-/api/health-4CAF50?style=for-the-badge)](https://service-sathi-production.up.railway.app/api/health)

</div>

---

## 📁 Repository Structure

```
🗂️ service-sathi/
│
├── 📂 backend/               ← FastAPI Python Backend
│   ├── 📂 app/               ← Core application modules
│   │   ├── main.py           ← FastAPI entry point
│   │   ├── models.py         ← SQLAlchemy DB models
│   │   ├── schemas.py        ← Pydantic request/response schemas
│   │   ├── database.py       ← DB connection
│   │   └── agents/           ← AI agent pipeline
│   ├── requirements.txt      ← Python dependencies
│   ├── Procfile              ← Railway deployment config
│   ├── seed_data.py          ← Seed DB with providers
│   └── .env.template         ← Environment variable template
│
└── 📂 flutter_app/           ← Flutter Mobile App
    ├── lib/
    │   ├── main.dart          ← App entry point
    │   ├── screens/           ← All UI screens
    │   ├── services/          ← API service layer
    │   ├── models/            ← Data models
    │   ├── theme/             ← App theming
    │   └── widgets/           ← Reusable components
    └── pubspec.yaml           ← Flutter dependencies
```

---

## 🧠 What is ServiceSathi AI?

> ServiceSathi AI is an intelligent home service discovery platform built for Pakistani users. A user describes what they need — in **Urdu, English, or Roman Urdu** — by voice or text, and the AI pipeline handles everything automatically.

<div align="center">

```
🗣️ User speaks/types  →  🤖 AI understands  →  📍 Finds nearby provider  →  ✅ Books automatically
```

</div>

---

## 🏗️ Multi-Agent AI Pipeline

```
┌─────────────────────────────────────────────────────────────┐
│           User Request (Voice / Text)                        │
│        Urdu · English · Roman Urdu                           │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────┐
        │      IntentAgent        │  🧠 LLaMA 3.1 via Groq API
        │      (NLU Parsing)      │  Extracts: service · location · time · language
        └────────────┬────────────┘
                     │
                     ▼
        ┌─────────────────────────┐
        │     DiscoveryAgent      │  🗄️ PostgreSQL (Railway)
        │    (Provider Search)    │  📍 Google Maps Geocoding
        └────────────┬────────────┘  📏 Haversine Distance Formula
                     │
                     ▼
        ┌─────────────────────────┐
        │     DecisionAgent       │  🏆 Custom Ranking Algorithm
        │      (AI Matching)      │  Sorts by: Rating ↓  ·  Distance ↑
        └────────────┬────────────┘
                     │
                     ▼
        ┌─────────────────────────┐
        │    ExecutionAgent       │  ✅ Confirms Booking in DB
        │   (Book & Schedule)     │  📋 Generates 4-step follow-up plan
        └────────────┬────────────┘
                     │
                     ▼
        ┌─────────────────────────┐
        │   Flutter App (UI)      │  📱 Shows result on map
        │    Final Response       │  📞 One-tap call · 🧭 Directions
        └─────────────────────────┘
```

---

## 🚀 Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| 📱 **Mobile App** | Flutter 3.x (Dart) | Android / iOS frontend |
| ⚡ **Backend** | FastAPI (Python 3.11) | REST API server |
| 🤖 **AI / LLM** | Groq — LLaMA 3.1 8B | Natural language understanding |
| 🗄️ **Database** | PostgreSQL on Railway | Providers & bookings storage |
| 🗺️ **Geocoding** | Google Maps API | Real location coordinates |
| 📏 **Distance** | Haversine Formula | GPS-accurate km calculation |
| 🎤 **Voice Input** | speech_to_text plugin | Urdu & English voice capture |
| 🗺️ **Maps UI** | google_maps_flutter | Dark-theme provider map |
| ☁️ **Deployment** | Railway | Auto-deploy from GitHub |
| ✅ **Validation** | Pydantic v2 | Request/response validation |

---

## ⚙️ Complete Setup Guide

> Follow these steps **in order**. Both backend and frontend are covered below.

---

### 🔑 Step 1 — Get Your API Keys First

You need **3 API keys** before anything will work:

| Key | Where to Get | Cost |
|-----|-------------|------|
| `GROQ_API_KEY` | [console.groq.com](https://console.groq.com) → Create API Key | 🆓 Free |
| `DATABASE_URL` | [railway.app](https://railway.app) → New Project → PostgreSQL | 🆓 Free tier |
| `GOOGLE_MAPS_API_KEY` | [console.cloud.google.com](https://console.cloud.google.com) → APIs & Services | 💳 Requires billing (free $200/month credit) |

> **Google Maps APIs to enable:** Maps SDK for Android · Geocoding API · Places API

---

### 📥 Step 2 — Clone the Repository

```bash
git clone https://github.com/Nav33dCodes/service-sathi.git
cd service-sathi
```

---

### 🐍 Step 3 — Backend Setup

```bash
# Navigate to backend
cd backend

# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate          # ← Windows
# source venv/bin/activate     # ← macOS / Linux

# Install all dependencies
pip install -r requirements.txt
```

**Create your `.env` file:**

```bash
# Copy the template
cp .env.template .env
```

Now open `.env` and fill in your keys:

```env
GROQ_API_KEY=your_groq_api_key_here
DATABASE_URL=postgresql://user:password@host:port/dbname
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

**Seed the database with sample providers:**

```bash
python seed_data.py
```

**Start the backend server:**

```bash
uvicorn app.main:app --reload
```

| URL | Purpose |
|-----|---------|
| `http://localhost:8000` | Base API |
| `http://localhost:8000/docs` | Swagger UI (test all endpoints) |
| `http://localhost:8000/api/health` | Health check |

✅ **Backend is running!**

---

### 📱 Step 4 — Flutter App Setup

> Make sure you have Flutter SDK installed. [Get Flutter →](https://flutter.dev/docs/get-started/install)

```bash
# From the repo root, go to flutter app
cd flutter_app

# Install Flutter packages
flutter pub get
```

**Add your Google Maps API Key:**

Open `flutter_app/android/app/src/main/AndroidManifest.xml` and find this section:

```xml
<application ...>
    <!-- Add this line inside <application> tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

**Point the app to your backend:**

Open `flutter_app/lib/services/api_service.dart` and update:

```dart
// For local testing:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// For production (Railway):
static const String baseUrl = 'https://service-sathi-production.up.railway.app/api';
```

**Run the app:**

```bash
# Connect Android device or start emulator, then:
flutter run
```

✅ **Flutter app is running!**

---

### ☁️ Step 5 — Deploy Backend to Railway

1. Push your code to GitHub (already done if you forked)
2. Go to [railway.app](https://railway.app) → **New Project** → **Deploy from GitHub**
3. Select your repo → Railway auto-detects the `Procfile`
4. Go to **Settings** → set **Root Directory** = `backend`
5. Go to **Variables** → add your 3 environment variables
6. Railway auto-deploys on every push to `main` 🚀

**Live URL format:** `https://your-app-name.up.railway.app`

---

## 📡 API Reference

### `POST /api/request` — Main AI Endpoint

```bash
curl -X POST https://service-sathi-production.up.railway.app/api/request \
  -H "Content-Type: application/json" \
  -d '{"text": "Mujhe G-13 mein AC technician chahiye kal subah"}'
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
    "name": "Ali AC Services",
    "rating": 4.8,
    "distance": 1.2,
    "phone": "+923001234567",
    "price_range": "$$"
  },
  "booking": {
    "booking_id": 42,
    "status": "Confirmed"
  }
}
```

### Other Endpoints

| Method | Endpoint | Description |
|--------|---------|-------------|
| `GET` | `/api/health` | Server health check |
| `GET` | `/api/providers` | All providers (add `?location=G-13` for distances) |
| `GET` | `/api/bookings` | All confirmed bookings |

---

## 🗄️ Database Schema

### `providers` table

| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Primary key |
| `name` | String | Provider full name |
| `service` | String | Service category |
| `location` | String | Area / neighbourhood |
| `lat` | Float | GPS latitude |
| `lng` | Float | GPS longitude |
| `rating` | Float | Rating out of 5.0 ⭐ |
| `available` | Boolean | Currently available? |
| `experience` | Integer | Years of experience |
| `phone` | String | WhatsApp contact number |
| `price_range` | String | `$` cheap · `$$` mid · `$$$` premium |

### `bookings` table

| Column | Type | Description |
|--------|------|-------------|
| `id` | Integer | Booking ID |
| `user_request` | String | Original user query |
| `provider_id` | FK → providers | Matched provider |
| `scheduled_time` | String | Arrival time |
| `status` | String | Confirmed / Cancelled |

---

## ❓ Troubleshooting

| Problem | Solution |
|---------|---------|
| `GROQ_API_KEY invalid` | Double-check key at console.groq.com |
| `Database connection failed` | Verify `DATABASE_URL` format and Railway DB is running |
| `Maps not showing` | Enable Geocoding API + Maps SDK in Google Cloud Console |
| `flutter pub get fails` | Run `flutter doctor` and fix any missing SDK issues |
| `App can't reach backend` | Check `baseUrl` in `api_service.dart` matches your server |
| `Railway red ❌ on commit` | Set Root Directory = `backend` in Railway service settings |

---

## 👥 Team

<div align="center">

| 👑 Leader | 💻 Developer |
|-----------|-------------|
| **Sanan Malik** | **Naveed Ahmed** |
| Project Lead & Vision | Backend · AI · Flutter |

*Built with ❤️ for a Hackathon Demo 🏆*

*ServiceSathi AI — Ghar ki zaroorat, ek awaaz mein.*

</div>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1e3799,50:0a3d62,100:0d1117&height=120&section=footer&animation=fadeIn" width="100%"/>

<sub>⚡ Powered by Groq LLaMA 3.1 · Google Maps API · Railway · FastAPI · Flutter</sub>

</div>
