from services.api_client import api_client

class AdminAPI:
    def create_user(self, user_data: dict):
        try:
            response = api_client.post("/users/add-user", json=user_data)
            return response
        except Exception as e:
            print(f"[AdminAPI] Create user failed: {e}")
            return None

    # You can expand here:
    # def delete_user(self, user_id):
    # def create_course(self, course_data):
    # def get_users(self):
    # etc.

# Global instance to use anywhere
admin_api = AdminAPI()
