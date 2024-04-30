import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from django.shortcuts import get_object_or_404
from Aplicaciones.bbdd.models import Sala
import logging

logger = logging.getLogger(__name__)

class ChatConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.slug = self.scope['url_route']['kwargs']['slug']
        self.room = await self.get_room(self.slug)
        user_mail = self.scope["user"].mail if self.scope["user"].is_authenticated else None

        is_authorized = await self.is_authorized(user_mail, self.slug)

        if is_authorized:
            self.room_group_name = f'chat_{self.slug}'
            logger.info(f'Conectado al chat {self.slug}')
            await self.channel_layer.group_add(
                self.room_group_name,
                self.channel_name
            )
            await self.accept()
        else:
            logger.info('Usuario no autorizado')
            await self.close()

    @database_sync_to_async
    def is_authorized(self, user_mail, slug):
        if not user_mail:
            return False
        try:
            room = Sala.objects.get(slug=slug)
            return room.emisor.mail == user_mail or room.receptor.mail == user_mail
        except Sala.DoesNotExist:
            return False

    @database_sync_to_async
    def get_room(self, slug):
        return Sala.objects.get(slug=slug)

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        print(message)
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message
            }
        )

    async def chat_message(self, event):
        message = event['message']

        await self.send(text_data=json.dumps({
            'message': message
        }))
