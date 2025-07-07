from django.urls import path

from .views.task import AdminTaskCreateAPIView

urlpatterns = [path("admin/create/", AdminTaskCreateAPIView.as_view())]
