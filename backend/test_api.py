import requests
import json

URL = "http://127.0.0.1:8000/api/request"

payload = {
    "text": "Mujhe kal subah G-13 mein AC technician chahiye"
}

print(f"Sending request: {payload['text']}\n")
response = requests.post(URL, json=payload)

if response.status_code == 200:
    print("Success!\n")
    print(json.dumps(response.json(), indent=2))
else:
    print(f"Error: {response.status_code}")
    print(response.text)
