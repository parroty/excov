defmodule CoverallsTest do
  use ExUnit.Case
  import Mock

  # test_with_mock "calculate stats", Coveralls.analyze, [get: fn(_module) -> [{{Coveralls, 25}, 0}] end] do
  #   assert(Coverall.analyze([Coveralls]) == HashDict.new)
  # end

end
