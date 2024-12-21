defmodule Capclearv1.Repo do
  use Ecto.Repo,
    otp_app: :capclearv1,
    adapter: Ecto.Adapters.Postgres
end
