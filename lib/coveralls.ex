defmodule Coveralls do
    def start(compile_path, opts) do
      :cover.start
      :cover.compile_beam_directory(compile_path |> to_char_list)

      output = opts[:output]

      System.at_exit fn(_) ->
        File.mkdir_p!(output)
        analyze
      end
    end

    defp analyze do
      Enum.each(:cover.modules, fn(module) ->
        {:ok, lines} = :cover.analyse(module, :calls, :line)
      end)
    end
end
