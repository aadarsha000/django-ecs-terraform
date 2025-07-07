from ..models import SubTask

from rest_framework import serializers


class SubTaskSerializers(serializers.ModelSerializer):
    class Meta:
        model = SubTask
        fields = ["title", "description", "due_date"]
