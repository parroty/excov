defmodule CoverallsTest do
  use ExUnit.Case
  import Mock

  @stats       [{{Coveralls, 1}, 0}, {{Coveralls, 2}, 1}]
  @modules     [Coveralls]
  @source      "test/fixtures/test.ex"
  @content     "defmodule Test do\n  def test do\n  end\nend\n"
  @count_hash  HashDict.new([{1, 0}, {2, 1}])
  @module_hash HashDict.new([{Coveralls, @count_hash}])
  @counts      [0, 1, nil, nil]
  @coverage    [{Coveralls, @counts}]

  test_with_mock "start", Cover, [compile: fn(_) -> nil end,
                                  modules: fn -> @modules end,
                                  analyze: fn(_) -> {:ok, @stats} end] do
    assert(Coveralls.start("", [output: nil]) == :ok)
  end

  test_with_mock "calculate stats", Cover, [analyze: fn(_) -> {:ok, @stats} end] do
    assert(Coveralls.calculate_stats([Coveralls]) == @module_hash)
  end

  test_with_mock "get source line count", Cover, [module_path: fn(_) -> @source end] do
    assert(Coveralls.get_source_line_count([Coveralls]) == 5)
  end

  test "read source file" do
    assert(Coveralls.read_source(@source) == @content)
  end

  test_with_mock "generate coverage", Cover, [module_path: fn(_) -> @source end] do
    assert(Coveralls.generate_coverage(@module_hash) == @coverage)
  end

  test_with_mock "generate source info", Cover, [module_path: fn(_) -> @source end] do
    assert(Coveralls.generate_source_info(@coverage) == [
      [
        name: "test.ex",
        source: @content,
        coverage: @counts
      ]
    ])
  end
end
