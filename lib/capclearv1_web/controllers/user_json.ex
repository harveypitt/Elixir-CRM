defmodule Capclearv1Web.UserJSON do
  alias Capclearv1.Accounts.User
  alias Capclearv1.Contacts.Contact

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
      name: user.name,
      email: user.email,
      contacts: for(contact <- user.contacts, do: contacts_data(contact))
    }
  end

  defp contacts_data(%Contact{} = contact) do
    %{
      id: contact.id,
      name: contact.name,
      email: contact.email
    }
  end
end
