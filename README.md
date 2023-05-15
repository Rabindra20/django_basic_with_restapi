###  create virtual environment
```
python -m venv venv
```

### activate on Windows (cmd.exe)
```
venv\Scripts\activate.bat
```

### install django in the virtual environment
```
pip install django
```

### start your django project
```
django-admin startproject django_starter
```
### Run app 
```
py manage.py runserver
```
OR
```
python manage.py runserver ip-addr:8000
```
### create our poll app in the same directory as your manage.py file
```
py manage.py startapp polls
```
### In setting we can add sb connect , time and etc

### create url.py inside `home`
### import view in url.py inside home
```
from . import views
```
### Add route in url.py in root folder
```
urlpatterns = [
    path('admin/', admin.site.urls),
    # path("polls/", include('polls.urls'))
    path("", include('home.urls')),
    path("polls/", include('polls.urls')),
    # path("about/", include('about.urls')) #about page is inside home
]
```

# change admin text (url.py in root folder)
```
admin.site.site_header = "Demo Admin"
admin.site.site_title = "Demo Admin Portal"
admin.site.index_title = "Welcome to Demo Researcher Portal"
```
### for migration
```
py manage.py makemigrations
```
```
py manage.py migrate
```
### create user
```
py manage.py createsuperuser
```
### delete super user
```
python manage.py shell
from django.contrib.auth.models import User
User.objects.get(username="joebloggs", is_superuser=True).delete()
```

### Add model in home/model.py for contact form 
```
class contact(models.Model):
    email = models.CharField(max_length=454)
    message = models.CharField(max_length=454)
```

import contact in home/admin.py
```
from home.models import contact
admin.site.register(contact)
```

then add `home.apps.HomeConfig` under INSTALLED_APPS  in setting.py <br/>


Gunicorn: gunicorn is an HTTP server. We’ll use it to serve the application inside the Docker container.
Martor: Martor is Markdown plugin for Django
```
echo martor >> requirements.txt
echo gunicorn >> requirements.txt
```
Install all the modules using:
```
pip install -r requirements.txt
```
### For django rest framework
```
python -m pip install djangorestframework
```
### For JWT token
```
pip install djangorestframework-simplejwt
```
```
pip freeze
``` 
### For Env
```
pip install django-environ
```
for postgres
```
pip install psycopg2
```