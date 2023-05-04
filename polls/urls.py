from django.urls import path
from . import views
# from polls import views

#setup route 
urlpatterns = [
    path("", views.index, name="index"),
]