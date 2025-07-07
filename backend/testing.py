from apps.accounts.models import User

from django.db import transaction

with transaction.atomic():
    for m_index in range(1, 11):
        manager_username = f"manager{m_index}"
        manager_email = f"{manager_username}@example.com"
        manager, created = User.objects.get_or_create(
            username=manager_username,
            defaults={
                "email": manager_email,
                "role": User.Role.MANAGER,
            },
        )
        if created:
            manager.set_password("password123")
            manager.save()
        for e_index in range(1, 51):
            emp_username = f"employee{m_index}_{e_index}"
            emp_email = f"{emp_username}@example.com"
            employee, created = User.objects.get_or_create(
                username=emp_username,
                defaults={
                    "email": emp_email,
                    "role": User.Role.EMPLOYEE,
                    "report_to": manager,
                },
            )
            if created:
                employee.set_password("password123")
                employee.save()
