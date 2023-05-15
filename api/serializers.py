# Serializers allow complex data such as querysets and model instances to be converted to native Python datatypes that can then be easily rendered into JSON, XML or other content types. 
from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework.validators import UniqueValidator
from django.contrib.auth.password_validation import validate_password
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):

# For add claims to payload we need to create a subclass for TokenObtainPairView as well as a subclass for TokenObtainPairSerializer.
    @classmethod
    def get_token(cls, user):
        token = super(MyTokenObtainPairSerializer, cls).get_token(user)

        # Add custom claims
        token['username'] = user.username 
        return token

# serializers->import
# 
class RegisterSerializer(serializers.ModelSerializer):
# We are stating that;

# the type of email attribute is an EmailField and that it is required and should be unique amongst all User objects in our database.
# the type of password attribute is an CharField and that it is write only, required and should be a valid password.
# the type of Confirm_Password attribute is an CharField and that it is write only, and required.
# These are the fields that our registration form is contains.
    email = serializers.EmailField(
            required=True,
            validators=[UniqueValidator(queryset=User.objects.all())]
            )

    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    Confirm_Password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ('username', 'password', 'Confirm_Password', 'email', 'first_name', 'last_name')
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True}
        }
# Password fields must be same. We can validate these fields with serializers validate(self, attrs) method:
    def validate(self, attrs):
        if attrs['password'] != attrs['Confirm_Password']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})

        return attrs

    def create(self, validated_data):
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name']
        )

        
        user.set_password(validated_data['password'])
        user.save()

        return user
class UserProfileSerializer(serializers.ModelSerializer):
  class Meta:
    model = User
    fields = ['id', 'email', 'username']

# class StudentSerializer(serializers.Serializer):
#     email = serializers.CharField(max_length=454)
