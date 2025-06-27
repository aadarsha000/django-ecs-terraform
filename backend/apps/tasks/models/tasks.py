from django.db import models

from apps.shared.abstract_base_model import AbstractBaseModel
from apps.accounts.models import User


class Task(AbstractBaseModel):

    class Status(models.TextChoices):
        PENDING = "PENDING", "Pending"
        IN_PROGRESS = "IN_PROGRESS", "In Progress"
        COMPLETED = "COMPLETED", "Completed"
        CANCELLED = "CANCELLED", "Cancelled"

    title = models.CharField(max_length=255, help_text="Brief title for the main task.")
    description = models.TextField(
        blank=True, help_text="Detailed description of the task."
    )
    assigned_by = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name="assigned_tasks",
    )
    assigned_to = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name="received_tasks",
    )
    status = models.CharField(
        max_length=15,
        choices=Status.choices,
        default=Status.PENDING,
        help_text="Current status of the main task.",
    )
    priority = models.IntegerField(
        default=1,
        help_text="Priority level (e.g., 1=High, 2=Medium, 3=Low).",
        choices=[
            (1, "High"),
            (2, "Medium"),
            (3, "Low"),
        ],
    )
    due_date = models.DateTimeField(
        null=True, blank=True, help_text="Due date for the task."
    )

    class Meta:
        verbose_name = "Task"
        verbose_name_plural = "Tasks"
        ordering = ["due_date", "priority"]

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        # Ensure assigned_by is an ADMIN
        if (
            self.assigned_by.role != User.Role.ADMIN
            or self.assigned_by.role != User.Role.MANAGER
        ):
            raise ValueError("Task can only be assigned by an Admin or Manager.")
        # Ensure assigned_to is a MANAGER
        if self.assigned_to.role != User.Role.TEAM_LEADER:
            raise ValueError("Task can only be assigned to a Team leader.")
        super().save(*args, **kwargs)
