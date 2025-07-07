from ..models import Task
from .sub_task import SubTaskSerializers
from ..task import assign_task_controller

from rest_framework import serializers


class TaskSerializers(serializers.ModelSerializer):
    sub_task = SubTaskSerializers(many=True)

    class Meta:
        model = Task
        fields = [
            "title",
            "description",
            "assigned_to",
            "priority",
            "due_date",
            "sub_task",
        ]

    def create(self, validated_data):
        request_user = self.context["request"].user
        sub_tasks = validated_data.pop("sub_task")

        validated_data["assigned_by"] = request_user
        print(request_user.role)
        task = Task.objects.create(**validated_data)

        assign_task_controller.delay(
            manager_id=task.assigned_to.id,
            task_id=task.id,
            sub_tasks=sub_tasks,
        )
        return task
