from django.db import models


class AbstractBaseModel(models.Model):
    metadata = models.JSONField(default=dict, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, null=True)

    class Meta:
        abstract = True
        ordering = ["-created_at"]