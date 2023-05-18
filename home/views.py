from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from home.models import Contact
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, logout


def index(request):
    if not request.user.is_authenticated:
        return render(request, "login.html")
    else:
      context = {
      'variable':":this variablevaule"
      }
      return render(request, 'index.html', context)
#     return HttpResponse("Hello...............")
def contact(request):
    if request.method == "POST":
        email = request.POST.get('email')
        message = request.POST.get('message')
        contact = Contact(email=email,message=message)
        contact.save()
    return render(request, 'contact.html')
    # return HttpResponse("Hi...............")
def about(request):
    context = {
    'variable':":this variablevaule"
    }
    return render(request, 'about.html',context)
    # return HttpResponse("Hi index about...............")
def login(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
        # Redirect to a success page.
         context = {
         'username':username
         }          
         return render(request, 'index.html',context)
        else:
        # Return an 'invalid login' error message.
         return render(request, "login.html")
    return render(request, 'login.html')
def logoutuser(request):
    logout(request)
    return render(request, 'login.html')