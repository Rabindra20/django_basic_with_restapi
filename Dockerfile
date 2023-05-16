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
RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps

# copy project
COPY . .
RUN echo "SECRET_KEY=${SECRET_KEY}" > /usr/src/app/django_starter/.env
# ENTRYPOINT ["/usr/src/app/start.sh"]
CMD ["python" , "manage.py" ,"runserver", "0.0.0.0:8000"]
# FROM nginx:1.21-alpine
# COPY nginx.conf /etc/nginx/conf.d