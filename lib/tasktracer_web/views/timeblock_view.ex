defmodule TasktracerWeb.TimeblockView do
  use TasktracerWeb, :view
  alias TasktracerWeb.TimeblockView

  def render("index.json", %{timeblocks: timeblocks}) do
    %{data: render_many(timeblocks, TimeblockView, "timeblock.json")}
  end

  def render("show.json", %{timeblock: timeblock}) do
    %{data: render_one(timeblock, TimeblockView, "timeblock.json")}
  end

  def render("timeblock.json", %{timeblock: timeblock}) do
    %{id: timeblock.id,
      starttb: timeblock.starttb,
      endtb: timeblock.endtb}
  end
end
