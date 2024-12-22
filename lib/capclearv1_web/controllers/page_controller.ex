defmodule Capclearv1Web.PageController do
  use Capclearv1Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def users(conn, _params) do
    users = [
      %{id: 1, name: "Harvey", email: "harvey@email.com"},
      %{id: 2, name: "Francis", email: "francis@email.com"}
    ]
    json(conn, %{users: users})
  end
end
