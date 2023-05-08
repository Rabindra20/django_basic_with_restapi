from django.urls import path
from . import views
# from polls import views

urlpatterns = [
    path("", views.index, name="index"),
]