defmodule DataMatrix.CLI do
  @moduledoc false

  alias DataMatrix.Render.SVG

  @version Mix.Project.config()[:version]

  @aliases [
    h: :help,
    v: :version,
    i: :input,
    q: :quietzone,
    o: :output,
    r: :rectangle
  ]

  @switches [
    help: :boolean,
    version: :boolean,
    input: :string,
    quietzone: :integer,
    output: :string,
    rectangle: :boolean,
    width: :integer,
    height: :integer,
    viewbox: :boolean,
    color: :string,
    background: :string,
    module_size: :integer
  ]

  @doc """

  """
  def main(args \\ System.argv()) do
    {opts, _args, _invalid} = OptionParser.parse(args, aliases: @aliases, strict: @switches)

    cond do
      Keyword.has_key?(opts, :help) ->
        display_usage()

      Keyword.has_key?(opts, :version) ->
        display_version()

      true ->
        process(opts)
    end
  end

  defp process(opts) do
    data = opts[:input] || IO.read(:stdio, :all)

    shape = if Keyword.has_key?(opts, :rectangle), do: :rectangle, else: :square

    datamatrix =
      data
      |> DataMatrix.encode!(quiet_zone: opts[:quietzone], shape: shape)

    datamatrix
    |> DataMatrix.format(:text, dark: "  ", light: "\u2588\u2588")
    |> IO.puts()

    if Keyword.has_key?(opts, :output) do
      svg = SVG.format(datamatrix, opts)

      File.write(opts[:output], svg)
    end
  end

  defp display_version do
    IO.puts("Data Matrix CLI v" <> @version)
  end

  defp display_usage do
    IO.puts(~S"""
    Usage:
      datamatrix ...

    Examples:
      echo -n 123456 | datamatrix -q 2 -o output.svg
      cat content.txt | datamatrix
      datamatrix -i "content"

    Options:
      -o, --output      Path to output DataMatrix symbol file.
      -q, --quietzone   Set quiet zone border width.
      -h, --help        Display this usage.
      -v, --version     Display Data Matrix CLI version.
      -r, --rectangle   

      SVG options:
      --width
      --height
      --viewbox
      --module-size
      --color
      --background

    """)
  end
end
