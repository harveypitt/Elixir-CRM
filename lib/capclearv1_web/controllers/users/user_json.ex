defmodule Capclearv1Web.UserJSON do
  alias Capclearv1.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      gender: user.gender,
      phone: user.phone,
      type: user.type,
      email: user.account && user.account.email
    }
  end
end
