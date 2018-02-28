defmodule TasktracerWeb.UserController do
  use TasktracerWeb, :controller

  alias Tasktracer.Accounts
  alias Tasktracer.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    all_users = Enum.map(Accounts.list_users(), fn(user) -> user.email end)
    render(conn, "new.html", changeset: changeset, all_users: [nil] ++ all_users)
  end

  def email_to_id(user_params) do
    IO.puts(Kernel.inspect(user_params))
    manager_email = user_params |> Map.get("manager_id")
    manager = nil
    new_params = user_params
    if manager_email != "" do
      user = Accounts.get_user_by_email(user_params |> Map.get("manager_id"))
      new_params = Map.update!(user_params, "manager_id", fn cur -> user |> Map.get(:id) end)
    end
    new_params
  end

  def create(conn, %{"user" => user_params}) do
    new_params = email_to_id(user_params)

    case Accounts.create_user(new_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    all_users = Accounts.list_users()
    render(conn, "show.html", user: user, all_users: all_users)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    all_users = Enum.map(Accounts.list_users(), fn(user) -> user.email end)
    render(conn, "edit.html", user: user, changeset: changeset, all_users: [nil] ++ all_users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    new_params = email_to_id(user_params)
   
    case Accounts.update_user(user, new_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
