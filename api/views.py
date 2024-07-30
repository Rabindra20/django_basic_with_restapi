from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from .serializers import MyTokenObtainPairSerializer,RegisterSerializer,UserProfileSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated,AllowAny,BasePermission
from rest_framework.views import APIView
from rest_framework.generics import RetrieveAPIView,ListCreateAPIView
from rest_framework import status,generics,viewsets
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.response import Response
from rest_framework.renderers import JSONRenderer


class MyObtainTokenPairView(TokenObtainPairView):
    permission_classes = (AllowAny,)
    serializer_class = MyTokenObtainPairSerializer

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (AllowAny,)
    serializer_class = RegisterSerializer

class UserProfileView(APIView):
  permission_classes = [IsAuthenticated]
  def get(self, request, format=None):
    serializer = UserProfileSerializer(request.user)
    # queryset=User.objects.all()
    return Response(serializer.data, status=status.HTTP_200_OK)

class UserProfileViewAll(APIView):
  permission_classes = [IsAuthenticated]
  def get(self, request, format=None):
    queryset=User.objects.all()
    serializer = UserProfileSerializer(queryset,many=true)
    return Response(serializer.data, status=status.HTTP_200_OK)
# def student(request):
#     stu =Student.object.get(get=1)
# #     stu =Student.object.all()
#     serializer = StudentSerializer(stu)
# #    serializer = StudentSerializer(stu,many=true)
#     json = JSONRenderer().render(serializer.data)
#     return HttpResponse(json_data,content_type='application/json')




# class UserProfileView(generics.ListCreateAPIView):
#     serializer_class = UserProfileSerializer
#     queryset = User.objects.all()
#     # permission_classes = [IsAuthenticated]
# class UserProfileView(generics.RetrieveAPIView):
#     serializer_class = UserProfileSerializer
#     permission_classes = [IsAuthenticated]
#     # def get_object(self):
#     #     return self.request.user
#     def get_object(self):
#         if request.user:
#             if request.user.is_superuser:
#                 return request.user
#             else:
#                 return obj.owner == request.user
#         else:
#             return request.user

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        try:
            print(request.data,"*")
            refresh_token = request.data["refresh_token"]
            
            token = RefreshToken(token=refresh_token)
            token.blacklist()

            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)


  
