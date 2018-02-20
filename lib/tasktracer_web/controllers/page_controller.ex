defmodule TasktracerWeb.PageController do
  use TasktracerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, _params) do
    tasks = Tasktracer.Social.list_tasks()
    changeset = Tasktracer.Social.change_task(%Tasktracer.Social.Task{})
    render conn, "feed.html", tasks: tasks, changeset: changeset
  end
end
