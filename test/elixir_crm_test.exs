defmodule ElixirCRMTest do
  use ExUnit.Case
  doctest ElixirCRM

  test "successful_start" do
    assert ElixirCRM.main() == :success
  end
end
