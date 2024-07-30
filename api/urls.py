from django.urls import path,re_path, include, reverse_lazy
from . import views
from api.views import MyObtainTokenPairView,RegisterView,UserProfileView,LogoutView
from rest_framework_simplejwt.views import TokenRefreshView
from django.views.generic.base import RedirectView
# from rest_framework_simplejwt.views import TokenBlacklistView

urlpatterns = [
    path('login/', MyObtainTokenPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('register/', RegisterView.as_view(), name='auth_register'),
    path('profile/', UserProfileView.as_view(), name='APIView'),
    path('viewuser/', UserProfileViewAll.as_view(), name='APIViewAll'),
    path('logout/', LogoutView.as_view(), name='auth_logout'),
    re_path(r'^$', RedirectView.as_view(url=reverse_lazy('api-root'), permanent=False)),
] 
