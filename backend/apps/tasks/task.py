import time
from celery import shared_task

from apps.accounts.models import User
from apps.tasks.models import Task, SubTask


@shared_task
def assign_task_controller(manager_id, task_id, sub_tasks):
    """
    Assigns each subtask to a user under the manager asynchronously.
    """
    try:
        manager = User.objects.get(id=manager_id)
        task = Task.objects.get(id=task_id)
    except User.DoesNotExist:
        raise Exception(f"Manager with id {manager_id} does not exist")
    except Task.DoesNotExist:
        raise Exception(f"Task with id {task_id} does not exist")

    users_under_manager = manager.get_all_subordinates()
    if not users_under_manager:
        raise Exception(f"No users found reporting to manager {manager.username}")

    for i, user in enumerate(users_under_manager):
        # Use round-robin or truncate if sub_tasks < users
        sub_task = sub_tasks[i % len(sub_tasks)]
        assign_task_to_user.delay(manager_id, task_id, sub_task, user.id)


@shared_task
def assign_task_to_user(manager_id, task_id, sub_task, user_id):
    """
    Assigns a single subtask to a user.
    """
    time.sleep(10)  # Simulate delay or rate-limit

    try:
        task = Task.objects.get(id=task_id)
        manager = User.objects.get(id=manager_id)
        employee = User.objects.get(id=user_id)

        SubTask.objects.create(
            task=task,
            title=sub_task["title"],
            description=sub_task.get("description", ""),
            assigned_by=manager,
            assigned_to=employee,
            due_date=sub_task.get("due_date"),
        )
        print(f"Subtask assigned to {employee.username}")

    except (User.DoesNotExist, Task.DoesNotExist) as e:
        print(f"Error assigning subtask: {e}")
