defmodule ElixirCrmTest do
  use ExUnit.Case
  doctest ElixirCRM

  test "greets the world" do
    assert ElixirCRM.hello() == :world
  end
end
