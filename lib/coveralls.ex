defmodule Coveralls do
    def start(compile_path, opts) do
      :cover.start
      :cover.compile_beam_directory(compile_path |> to_char_list)

      output = opts[:output]

      System.at_exit fn(_) ->
        File.mkdir_p!(output)
        calculate_stats(:cover.modules)
      end
    end

    def calculate_stats(modules) do
      dict = HashDict.new
      Enum.each(modules, fn(module) ->
        {:ok, lines} = analyze(module)
        Enum.each(lines, fn({{module, line}, count}) ->
          HashDict.put(dict, {module, line}, count)
        end)
      end)
    end

    defp analyze(module) do
      :cover.analyse(module, :calls, :line)
    end
end
