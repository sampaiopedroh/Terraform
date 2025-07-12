from locust import FastHttpUser, task # type: ignore

class WebsiteUser(FastHttpUser):
    
    host = "http://127.0.0.1:8089"

    @task
    def index(self):
        self.client.get("/")
        