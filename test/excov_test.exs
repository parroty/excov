defmodule ExcovTest do
  use ExUnit.Case

  test "the truth" do
    assert(true)
  end

  test "plus" do
    assert(Excov.plus(1, 2) == 3)
  end
end
