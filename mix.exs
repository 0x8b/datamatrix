defmodule DataMatrix.MixProject do
  use Mix.Project

  @version "0.1.3"

  def project do
    [
      app: :datamatrix,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:git_hooks, "~> 0.4.0", only: [:test, :dev], runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.11.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "Library that enables programs to write Data Matrix barcodes of the modern ECC200 variety."
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/0x8b/datamatrix"}
    ]
  end

  defp escript do
    [
      main_module: DataMatrix.CLI
    ]
  end
end
