defmodule ElixirCRM.Contact do
  @enforce_keys [:id, :first_name, :last_name, :email]
  defstruct [:id, :first_name, :last_name, :email, :phone]

  def create(params) do
    case struct(__MODULE__, params) do
      %{id: nil} -> {:error, :missing_id}
      %{first_name: nil} -> {:error, :missing_first_name}
      %{last_name: nil} -> {:error, :missing_last_name}
      %{email: nil} -> {:error, :missing_email}
      contact -> {:ok, contact}
    end
  end
end
