from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone


class User(AbstractUser):
    """
    Custom User model to define different roles and reporting hierarchy.
    """

    class Role(models.TextChoices):
        ADMIN = "ADMIN", "Admin"
        MANAGER = "MANAGER", "Manager"
        TEAM_LEADER = (
            "TEAM_LEADER",
            "Team Leader",
        )
        EMPLOYEE = "EMPLOYEE", "Employee"

    role = models.CharField(
        max_length=15,
        choices=Role.choices,
        default=Role.EMPLOYEE,
        help_text="Designates the user's role in the organization.",
    )
    report_to = models.ForeignKey(
        "self",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="subordinates",
        help_text="The user this person reports to (e.g., Employee reports to Team Leader, Team Leader to Manager).",
    )

    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"
        ordering = ["username"]

    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"

    def get_direct_subordinates(self):
        """Returns users directly reporting to this user."""
        return self.subordinates.all()

    def get_all_subordinates(self):
        """Recursively returns all subordinates under this user."""
        subordinates_list = list(self.subordinates.all())
        for subordinate in self.subordinates.all():
            if subordinate.role in [User.Role.MANAGER, User.Role.TEAM_LEADER]:
                subordinates_list.extend(subordinate.get_all_subordinates())
        return list(set(subordinates_list))
