defmodule TasktracerWeb.TaskController do
  use TasktracerWeb, :controller

  alias Tasktracer.Social
  alias Tasktracer.Social.Task
  alias Tasktracer.Accounts

  def index(conn, _params) do
    tasks = Social.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Social.change_task(%Task{})
    all_users = Enum.map(Accounts.list_users(), fn(user) -> user.email end)
    render(conn, "new.html", changeset: changeset, all_users: [nil] ++ all_users)
  end

  def create(conn, %{"task" => task_params}) do
    new_params = email_to_id(task_params)

    case Social.create_task(new_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    changeset = Social.change_task(task)
    all_users = Enum.map(Accounts.list_users(), fn(user) -> user.email end)
    render(conn, "edit.html", task: task, changeset: changeset, all_users: [nil] ++ all_users)
  end

  def email_to_id(task_params) do
    user_email = task_params |> Map.get("user_id")
    user = nil
    new_params = task_params
    if user_email != "" do
      user = Accounts.get_user_by_email(task_params |> Map.get("user_id"))
      new_params = Map.update!(task_params, "user_id", fn cur -> user |> Map.get(:id) end)
    end
    new_params
  end
  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)
    new_params = email_to_id(task_params)
    
    case Social.update_task(task, new_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    {:ok, _task} = Social.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
