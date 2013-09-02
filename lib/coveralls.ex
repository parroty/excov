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

  def generate_coverage(hash) do
    Enum.map(hash.keys, fn(module) ->
      total = get_source_line_count(module)
      {module, do_generate_coverage(HashDict.fetch!(hash, module), total - 1, [])}
    end)
  end

  def do_generate_coverage(_hash, 0, acc),   do: acc
  def do_generate_coverage(hash, index, acc) do
    count = HashDict.get(hash, index, nil)
    do_generate_coverage(hash, index - 1, [count | acc])
  end

  def get_source_line_count(module) do
    Cover.module_path(module) |> read_source |> count_lines
  end

  defp count_lines(string) do
    1 + Enum.count(to_char_list(string), fn(x) -> x == ?\n end)
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