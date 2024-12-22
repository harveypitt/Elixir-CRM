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
        email: "some email",
        name: "some name"
      })
      |> Capclearv1.Contacts.create_contact()

    contact
  end
end
