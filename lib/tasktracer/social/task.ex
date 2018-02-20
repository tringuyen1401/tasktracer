defmodule Tasktracer.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracer.Social.Task


  schema "tasks" do
    field :assigned_at, :utc_datetime
    field :description, :string
    field :is_complete, :boolean, default: false
    field :title, :string
    belongs_to :user, Tasktracer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    if (:user_id != nil) do
      assigned = DateTime.utc_now()
    end
    task
    |> cast(attrs, [:title, :description, :is_complete, :user_id])
    |> cast(%{assigned_at: assigned}, [:assigned_at])
    |> validate_required([:title, :description, :is_complete])
  end
end
