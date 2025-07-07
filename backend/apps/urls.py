from django.urls import path, include

urlpatterns = [
    path("task/", include("apps.tasks.urls")),
]
