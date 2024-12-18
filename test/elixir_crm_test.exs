defmodule ElixirCrmTest do
  use ExUnit.Case
  doctest ElixirCrm

  test "greets the world" do
    assert ElixirCrm.hello() == :world
  end
end
