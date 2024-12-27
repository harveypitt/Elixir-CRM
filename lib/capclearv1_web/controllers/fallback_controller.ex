defmodule Capclearv1Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Capclearv1Web, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: Capclearv1Web.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause handles errors from Ecto.Multi operations
  def call(conn, {:error, _failed_operation, %Ecto.Changeset{} = changeset, _changes_so_far}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: Capclearv1Web.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is called for all other errors.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: Capclearv1Web.ErrorHTML, json: Capclearv1Web.ErrorJSON)
    |> render(:"404")
  end
end
