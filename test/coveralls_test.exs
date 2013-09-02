defmodule CoverallsTest do
  use ExUnit.Case
  import Mock

  @stats_value [{{Coveralls, 1}, 0}, {{Coveralls, 2}, 1}]
  @modules [Coveralls]
  @source "test/fixtures/test.ex"

  test_with_mock "start", Cover, [compile: fn(_) -> nil end,
                                  modules: fn -> @modules end,
                                  analyze: fn(_) -> {:ok, @stats_value} end] do
    assert(Coveralls.start("", [output: nil]) == :ok)
  end

  test_with_mock "calculate stats", Cover, [analyze: fn(_) -> {:ok, @stats_value} end] do
    assert(Coveralls.calculate_stats([Coveralls]) == HashDict.new(@stats_value))
  end

  test "read file" do
    assert(Coveralls.read_source(@source) == "defmodule Test do\n  def test do\n  end\nend\n")
  end

  test "generate json" do
    assert(Coveralls.generate_json(@stats_value) == nil)
  end
end
