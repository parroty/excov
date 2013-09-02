defmodule Coveralls do
  def start(compile_path, opts) do
    Cover.compile(compile_path)
    output = opts[:output]
    System.at_exit fn(_) ->
      File.mkdir_p!(output)
      calculate_stats(Cover.modules)
    end
  end

  def calculate_stats(modules) do
    Enum.reduce(modules, HashDict.new, fn(module, dict) ->
      {:ok, lines} = Cover.analyze(module)
      analyze_lines(lines, dict)
    end)
  end

  defp analyze_lines(lines, dict) do
    Enum.reduce(lines, dict, fn({{module, line}, count}, dict) ->
      HashDict.put(dict, {module, line}, count)
    end)
  end
end

defmodule Cover do
  def compile(compile_path) do
    :cover.start
    :cover.compile_beam_directory(compile_path |> to_char_list)
  end

  def modules do
    :cover.modules
  end

  def analyze(module) do
    :cover.analyse(module, :calls, :line)
  end
end