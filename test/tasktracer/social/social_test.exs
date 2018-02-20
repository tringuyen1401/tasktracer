defmodule Tasktracer.SocialTest do
  use Tasktracer.DataCase

  alias Tasktracer.Social

  describe "tasks" do
    alias Tasktracer.Social.Task

    @valid_attrs %{assigned_at: ~N[2010-04-17 14:00:00.000000], description: "some description", is_complete: true, title: "some title"}
    @update_attrs %{assigned_at: ~N[2011-05-18 15:01:01.000000], description: "some updated description", is_complete: false, title: "some updated title"}
    @invalid_attrs %{assigned_at: nil, description: nil, is_complete: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Social.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Social.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Social.create_task(@valid_attrs)
      assert task.assigned_at == ~N[2010-04-17 14:00:00.000000]
      assert task.description == "some description"
      assert task.is_complete == true
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Social.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.assigned_at == ~N[2011-05-18 15:01:01.000000]
      assert task.description == "some updated description"
      assert task.is_complete == false
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_task(task, @invalid_attrs)
      assert task == Social.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Social.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Social.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Social.change_task(task)
    end
  end
end
