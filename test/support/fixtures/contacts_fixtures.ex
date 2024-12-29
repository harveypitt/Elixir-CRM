defmodule Capclearv1.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Capclearv1.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        first_name: "some first name",
        last_name: "some last name",
        email: "some@email.com",
        phone: "1234567890"
      })
      |> Capclearv1.Contacts.create_contact()

    contact
  end
end
