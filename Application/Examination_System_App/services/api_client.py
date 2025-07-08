import requests

# Your Node.js backend URL via ngrok
# api_ID="2bba-197-132-233-192"
BASE_URL = "https://fb7e-102-191-11-189.ngrok-free.app/api"

class APIClient:
    def __init__(self):
        self.session = requests.Session()
        self.token = None

    def set_token(self, token):
        self.token = token
        self.session.headers.update({"Authorization": f"Bearer {token}"})

    def post(self, endpoint, data=None, json=None):
        url = f"{BASE_URL}{endpoint}"
        try:
            return self.session.post(url, data=data, json=json)
        except requests.RequestException as e:
            print("POST request failed:", e)
            return None

    def get(self, endpoint, params=None):
        url = f"{BASE_URL}{endpoint}"
        try:
            return self.session.get(url, params=params)
        except requests.RequestException as e:
            print("GET request failed:", e)
            return None

    def login(self, username, password, role):
        payload = {
            "username": username,
            "password": password,
            "role": role
        }
        resp = self.post("/auth/login", json=payload)
        if resp and resp.ok:
            token = resp.json().get("token")
            if token:
                self.set_token(token)
        return resp

# Global instance
api_client = APIClient()
