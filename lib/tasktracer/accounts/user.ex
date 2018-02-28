defmodule Tasktracer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracer.Accounts.User
  alias Tasktracer.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    belongs_to :manager, User

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :manager_id])
    |> validate_required([:email, :name])
  end
end
