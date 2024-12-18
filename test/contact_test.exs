defmodule ElixirCRM.ContactTest do
  use ExUnit.Case
  alias ElixirCRM.Contact

  test "create_contact" do
    contact_params = %{
      id: UUID.uuid4(),
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      phone: "555-0123"
    }

    assert {:ok, created_contact} = Contact.create(contact_params)
    assert created_contact.first_name == "John"
    assert created_contact.last_name == "Doe"
    assert created_contact.email == "john.doe@example.com"
    assert created_contact.phone == "555-0123"
  end

  test "get_contact" do
    contact_params = %{
      id: UUID.uuid4(),
      first_name: "Jane",
      last_name: "Smith",
      email: "jane.smith@example.com",
      phone: "555-0456"
    }

    {:ok, created_contact} = Contact.create(contact_params)
    Contact.save(created_contact)

    assert {:ok, fetched_contact} = Contact.get(created_contact.id)
    assert fetched_contact == created_contact
  end

  test "update_contact" do
    contact_params = %{
      id: UUID.uuid4(),
      first_name: "Mike",
      last_name: "Brown",
      email: "mike.brown@example.com",
      phone: "555-0789"
    }

    {:ok, contact} = Contact.create(contact_params)
    Contact.save(contact)

    updated_params = %{phone: "555-0000"}
    {:ok, updated_contact} = Contact.update(contact.id, updated_params)

    assert updated_contact.phone == "555-0000"
  end

  test "delete_contact" do
    contact_params = %{
      id: UUID.uuid4(),
      first_name: "Alice",
      last_name: "Johnson",
      email: "alice.johnson@example.com",
      phone: "555-1234"
    }

    {:ok, contact} = Contact.create(contact_params)
    Contact.save(contact)

    assert :ok = Contact.delete(contact.id)
    assert {:error, :not_found} = Contact.get(contact.id)
  end

  test "create_contact_missing_fields" do
    incomplete_params = %{
      first_name: "Invalid",
      email: "invalid@example.com"
    }

    assert_raise KeyError, fn ->
      Contact.create(incomplete_params)
    end
  end
end
