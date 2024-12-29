defmodule Capclearv1Web.ContactJSON do
  alias Capclearv1.Contacts.Contact

  @doc """
  Renders a list of contacts.
  """
  def index(%{contacts: contacts}) do
    %{data: for(contact <- contacts, do: data(contact))}
  end

  @doc """
  Renders a single contact.
  """
  def show(%{contact: contact}) do
    %{data: data(contact)}
  end

  defp data(%Contact{} = contact) do
    %{
      contact_id: contact.id,
      first_name: contact.first_name,
      last_name: contact.last_name,
      email: contact.email,
      phone: contact.phone,
      dietitian_id: contact.user_id
    }
  end
end
