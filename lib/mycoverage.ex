defmodule MyCoverage do
    def start(compile_path, opts) do
      IO.puts "[compiled path] " <> compile_path <> "\n"
      IO.write "[modified] Cover compiling modules ... "
      :cover.start
      :cover.compile_beam_directory(compile_path |> to_char_list)
      IO.puts "ok"

      output = opts[:output]

      System.at_exit fn(_) ->
        IO.write "\nGenerating cover results ... "
        File.mkdir_p!(output)
        Enum.each :cover.modules, fn(mod) ->
          :cover.analyse_to_file(mod, '#{output}/#{mod}.html', [:html])

          IO.puts "\n[clause]"
          {:ok, result} = :cover.analyse(mod, :calls, :clause)
          Enum.each(result, fn(x) -> IO.inspect x end)

          IO.puts "\n[line]"
          {:ok, result} = :cover.analyse(mod, :calls, :line)
          Enum.each(result, fn(x) -> IO.inspect x end)

          IO.puts "\n[file]"
          IO.inspect mod.__info__(:compile)[:source]
        end

        IO.puts "ok"
      end
    end
end