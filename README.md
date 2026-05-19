# ServiceSathi AI 🤖🔧

> **AI-powered service discovery platform** — connecting citizens with local service providers using voice, AI, and real-time location.

---

## 📁 Repository Structure

```
ServiceSathiAI/
├── backend/          # FastAPI Python backend (REST API + AI logic)
└── flutter_app/      # Flutter mobile application (Android/iOS)
```

---

## 🚀 Quick Start

### Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Flutter App
```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter (Dart) |
| Backend | FastAPI (Python) |
| AI | Google Gemini API |
| Maps | Google Maps Platform |
| Database | PostgreSQL (Railway) |
| Deployment | Railway |

---

## 📖 Documentation

- [Backend API Docs](backend/README.md)
- [Flutter App](flutter_app/README.md)
