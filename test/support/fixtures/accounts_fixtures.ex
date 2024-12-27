defmodule Capclearv1.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Capclearv1.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      "first_name" => "John",
      "last_name" => "Doe",
      "gender" => "male",
      "phone" => "1234567890",
      "type" => "dietitian",
      "email" => unique_user_email()
    })
  end

  def user_fixture(attrs \\ %{}) do
    attrs = valid_user_attributes(attrs)

    {:ok, %{user: user}} =
      Capclearv1.Users.create_user_with_account(
        Map.drop(attrs, ["email"]),
        %{"email" => attrs["email"], "hashed_password" => "somehashedpassword"}
      )

    user
  end
end
