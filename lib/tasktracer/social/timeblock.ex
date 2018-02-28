defmodule Tasktracer.Social.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracer.Social.Timeblock
  alias Tasktracer.Social.Task

  schema "timeblocks" do
    field :endtb, :string
    field :starttb, :string
    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:starttb, :endtb, :task_id])
    |> validate_required([:starttb, :endtb, :task_id])
  end
end
