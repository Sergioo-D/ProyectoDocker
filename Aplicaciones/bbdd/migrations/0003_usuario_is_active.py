# Generated by Django 4.2.5 on 2023-12-10 18:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bbdd', '0002_remove_usuario_identificador'),
    ]

    operations = [
        migrations.AddField(
            model_name='usuario',
            name='is_active',
            field=models.BooleanField(default=True),
        ),
    ]
