import json
from channels.generic.websocket import AsyncWebsocketConsumer


class TestConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        await self.send(text_data=json.dumps({"message": "You are connected!"}))

    async def disconnect(self, close_code):
        print("Disconnected!")

    async def receive(self, text_data):
        data = json.loads(text_data)
        msg = data.get("message", "")

        await self.send(text_data=json.dumps({"message": f"You said: {msg}"}))
