from django.db import models

# Create your models here.
class Contact(models.Model):
    email = models.CharField(max_length=454)
    message = models.CharField(max_length=454)