defmodule Bank.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:domo_compiler] ++ Mix.compilers(),
      test_coverage: [ignore_modules: [~r/\.TypeEnsurer$/]]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Bank.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:domo, "~> 1.5"},
      {:typed_struct, "~> 0.3.0"},
      {:uniq, "~> 0.6.0"}
    ]
  end
end
