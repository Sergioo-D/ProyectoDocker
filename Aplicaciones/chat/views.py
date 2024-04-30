from django.http import HttpResponse
from django.shortcuts import render
from Aplicaciones.bbdd.models import Sala, MensajeDirecto
from Aplicaciones.templates import *

# Create your views here.
def index(request):
    return render(request,'index.html', {})

def Salaa(request, slug):
    sala = Sala.objects.get(slug=slug)
    # Asumiendo que quieres obtener todos los mensajes de esa sala
    # Aquí tendrías que modificar la lógica según cómo quieres filtrar los mensajes.
    mensajes = MensajeDirecto.objects.filter(sala=sala).order_by('-timestamp')
    return render(request, 'chatroom.html', {'sala': sala, 'mensajes': mensajes})