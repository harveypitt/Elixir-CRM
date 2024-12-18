defmodule ElixirCRM do
  @moduledoc """
  Documentation for `ElixirCRM`.
  """
  use Application

  def start(_type, _args) do
    ElixirCRM.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end


  def main do
    IO.puts(:success)
    current_time = DateTime.utc_now()
    IO.puts(current_time)
    :success
  end
end
