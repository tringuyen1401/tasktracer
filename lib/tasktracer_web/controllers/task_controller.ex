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
    tbs = Social.tbs_map_for(task)
    render(conn, "show.html", task: task, tbs: tbs)
  end

  def edit(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    tbs = Social.tbs_map_for(task)
    changeset = Social.change_task(task)
    all_users = Accounts.list_users()
    IO.puts("EDIT #{Kernel.inspect(tbs)}")
    render(conn, "edit.html", task: task, changeset: changeset, all_users: all_users, tbs: tbs)
  end

  def email_to_id(task_params) do
    user_email = task_params |> Map.get("user_id")
    user = nil
    new_params = task_params
    if user_email != "" && !is_nil(user_email) do
      user = Accounts.get_user_by_email(task_params |> Map.get("user_id"))
      new_params = Map.update!(task_params, "user_id", fn cur -> user |> Map.get(:id) end)
      IO.puts(Kernel.inspect(new_params))
    end
    new_params
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)
    new_params = email_to_id(task_params)
    if (Map.get(task_params, "timeblock") != nil) do
      tb = Social.get_timeblock!(Map.get(task_params, "timeblock"))
      IO.puts(Kernel.inspect(DateTime.utc_now()))
      timeblock_params = %{starttb: DateTime.to_string(map_to_date(Map.get(new_params, "starttb"))), endtb: DateTime.to_string(map_to_date(Map.get(new_params, "endtb")))}
      Social.update_timeblock(tb, timeblock_params)
    end
    case Social.update_task(task, new_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def map_to_date(tup) do
    result = Map.get(tup, "year") <> "-" <> correct(Map.get(tup, "month")) <> "-" <> correct(Map.get(tup, "day")) <> " " <> correct(Map.get(tup, "hour")) <> ":" <> correct(Map.get(tup, "minute")) <> ":" <> "00.000000" <> "Z"
    Enum.at(Tuple.to_list(DateTime.from_iso8601(result)),1)
  end

  def correct(s) do
    if (String.length(s) != 2) do
      "0" <> s
    else
      s
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
