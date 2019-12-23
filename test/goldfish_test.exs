defmodule GoldfishTest do
  use ExUnit.Case
  doctest Goldfish

  test "greets the world" do
    assert Goldfish.hello() == :world
  end
end
