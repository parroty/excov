defmodule Excov.Mixfile do
  use Mix.Project

  def project do
    [ app: :excov,
      version: "0.0.1",
      elixir: "~> 0.10.2-dev",
      deps: deps,
      test_coverage: test_coverage
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:mock, ">= 0.0.3", github: "parroty/mock"},
      {:exjson, github: "guedes/exjson"},
      {:httpotion, github: "parroty/httpotion"},
    ]
  end

  defp test_coverage do
    [output: "cover", tool: Coveralls]
  end
end
