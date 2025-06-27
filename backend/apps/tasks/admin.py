from django.contrib import admin
from .models import Task, SubTask


# Register your models here.
@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = (
        "title",
        "assigned_by",
        "assigned_to",
        "status",
        "due_date",
        "priority",
    )
    list_filter = (
        "status",
        "priority",
        "assigned_by__username",
        "assigned_to__username",
    )
    search_fields = ("title", "description")
    raw_id_fields = ("assigned_by", "assigned_to")


@admin.register(SubTask)
class SubTaskAdmin(admin.ModelAdmin):
    list_display = ("title", "task", "assigned_by", "assigned_to", "status", "due_date")
    list_filter = ("status", "assigned_by__username", "assigned_to__username")
    search_fields = ("title", "description")
    raw_id_fields = ("task", "assigned_by", "assigned_to")
