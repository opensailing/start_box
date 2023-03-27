defmodule StartBoxTest do
  use ExUnit.Case
  doctest Startbox

  test "greets the world" do
    assert Startbox.hello() == :world
  end
end
