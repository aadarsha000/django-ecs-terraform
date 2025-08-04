from django.contrib import admin
from django.urls import path, include
from core import settings
from django.conf.urls.static import static
from django.http import HttpResponse

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("apps.urls")),
    path("health", lambda request: HttpResponse("OK", status=200)),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
