defmodule CoverallsTest do
  use ExUnit.Case
  import Mock

  @stats_value [{{Coveralls, 1}, 0}, {{Coveralls, 2}, 1}]
  test_with_mock "calculate stats", Cover, [analyze: fn(_module) -> {:ok, @stats_value} end] do
    assert(Coveralls.calculate_stats([Coveralls]) == HashDict.new(@stats_value))
  end

end
