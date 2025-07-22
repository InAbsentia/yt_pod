defmodule YTPodWeb.PageController do
  use YTPodWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
