defmodule Capclearv1Web.ContactController do
  use Capclearv1Web, :controller

  alias Capclearv1.Contacts
  alias Capclearv1.Contacts.Contact

  action_fallback Capclearv1Web.FallbackController

  def index(conn, _params) do
    contacts = Contacts.list_contacts()
    render(conn, :index, contacts: contacts)
  end

  def create(conn, %{"contact" => contact_params}) do
    with {:ok, %Contact{} = contact} <- Contacts.create_contact(contact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/contacts/#{contact}")
      |> render(:show, contact: contact)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, :show, contact: contact)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    with {:ok, %Contact{} = contact} <- Contacts.update_contact(contact, contact_params) do
      render(conn, :show, contact: contact)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)

    with {:ok, %Contact{}} <- Contacts.delete_contact(contact) do
      send_resp(conn, :no_content, "")
    end
  end
end
