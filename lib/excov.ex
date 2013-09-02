defmodule Excov do
  def plus(x, y, flag // true) do
    #IO.inspect __FILE__
    if flag do
      _ = x + y
      x + y
    else
      _ = x + y
      x + y
    end
  end

  def minus(x, y) do
    x - y
  end

  def multiply(x, y) do
    x * y
  end
end

defmodule Excov2 do
  def minus(x, y) do
    x - y
  end

  def multiply(x, y) do
    x * y
  end

  defmodule ExCov3 do
    def hello do
      IO.puts "hello"
    end
  end
end
