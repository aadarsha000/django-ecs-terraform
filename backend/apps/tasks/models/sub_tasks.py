from django.db import models

from apps.shared.abstract_base_model import AbstractBaseModel
from apps.accounts.models import User
from apps.tasks.models import Task


class SubTask(models.Model):

    class Status(models.TextChoices):
        PENDING = "PENDING", "Pending"
        IN_PROGRESS = "IN_PROGRESS", "In Progress"
        COMPLETED = "COMPLETED", "Completed"
        CANCELLED = "CANCELLED", "Cancelled"

    task = models.ForeignKey(
        Task,
        on_delete=models.CASCADE,
        related_name="sub_tasks",
        help_text="The main task this sub-task belongs to.",
    )
    title = models.CharField(max_length=255, help_text="Brief title for the sub-task.")
    description = models.TextField(
        blank=True, help_text="Detailed description of the sub-task."
    )
    assigned_by = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name="assigned_sub_tasks",
    )
    assigned_to = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name="received_sub_tasks",
    )
    status = models.CharField(
        max_length=15,
        choices=Status.choices,
        default=Status.PENDING,
        help_text="Current status of the sub-task.",
    )
    due_date = models.DateTimeField(
        null=True, blank=True, help_text="Due date for the sub-task."
    )

    class Meta:
        verbose_name = "Sub-Task"
        verbose_name_plural = "Sub-Tasks"
        ordering = ["due_date", "task__priority"]

    def __str__(self):
        return f"SubTask: {self.title} (for Task: {self.task.title})"

    def save(self, *args, **kwargs):
        # Ensure assigned_by is the Team Leader responsible for the parent Task
        if (
            self.assigned_by.role != User.Role.MANAGER
            or self.assigned_by != self.task.assigned_to
        ):
            raise ValueError(
                "SubTask can only be assigned by the Team Leader responsible for the parent Task."
            )

        # Ensure assigned_to is an Employee reporting to the Team Leader
        if (
            self.assigned_to.role != User.Role.EMPLOYEE
            or self.assigned_to.report_to != self.assigned_by
        ):
            raise ValueError(
                "SubTask can only be assigned to an Employee who reports to the assigning Team Leader."
            )

        super().save(*args, **kwargs)
