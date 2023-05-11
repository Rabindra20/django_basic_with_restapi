# pull official base image
FROM python:3.9.6-alpine
ARG SECRET_KEY

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .
RUN echo "SECRET_KEY=${SECRET_KEY}" > /usr/src/app/django_starter/.env
CMD ["python" , "manage.py" ,"runserver", "0.0.0.0:80"]
# FROM nginx:1.21-alpine
# COPY nginx.conf /etc/nginx/conf.d