defmodule Coveralls do
  def start(compile_path, opts) do
    Cover.compile(compile_path)
    output = opts[:output]
    System.at_exit fn(_) ->
      File.mkdir_p!(output)
      stats = calculate_stats(Cover.modules)
      generate_coverage(stats)
    end
  end

  def calculate_stats(modules) do
    Enum.reduce(modules, HashDict.new, fn(module, dict) ->
      {:ok, lines} = Cover.analyze(module)
      analyze_lines(lines, dict)
    end)
  end

  def generate_coverage(stats) do
#    Enum.
  end

  def read_source(file_path) do
    File.read!(file_path)
  end

  defp analyze_lines(lines, module_hash) do
    Enum.reduce(lines, module_hash, fn({{module, line}, count}, module_hash) ->
      add_counts(module_hash, module, line, count)
    end)
  end

  defp add_counts(module_hash, module, line, count) do
    count_hash = HashDict.get(module_hash, module, HashDict.new)
    HashDict.put(module_hash, module, HashDict.put(count_hash, line, count))
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

  def module_path(module) do
    module.__info__(:compile)[:source]
  end
end