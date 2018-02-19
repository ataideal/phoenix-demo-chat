defmodule ChatdemoWeb.PageController do
  use ChatdemoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
