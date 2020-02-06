defmodule DataMatrix.CLI do
  @moduledoc false

  alias DataMatrix.Render

  @version Mix.Project.config()[:version]

  @switches [
    help: :boolean,
    version: :boolean,
    preview: :boolean,
    input: :string,
    output: :string,
    symbol: :integer,
    rectangle: :boolean,
    dark: :string,
    light: :string,
    module_size: :integer,
    quiet_zone: :integer,
    width: :integer,
    height: :integer,
    viewbox: :boolean
  ]

  @aliases [
    h: :help,
    v: :version,
    p: :preview,
    i: :input,
    q: :quiet_zone,
    o: :output,
    s: :symbol,
    r: :rectangle
  ]

  @doc """

  """
  def main(argv \\ System.argv()) do
    argv
    |> parse_args()
    |> process()
  end

  defp parse_args(argv) do
    {opts, args, _invalid} = OptionParser.parse(argv, strict: @switches, aliases: @aliases)

    data =
      case read_data(opts, args) do
        {:ok, data} ->
          data

        {:error, error} ->
          print_error(error)
          System.halt(1)
      end

    cond do
      Keyword.has_key?(opts, :help) ->
        :help

      Keyword.has_key?(opts, :version) ->
        :version

      String.length(data) > 0 ->
        {data, opts}

      true ->
        :help
    end
  end

  defp read_data(opts, args) do
    positional = List.first(args) || ""

    cond do
      Keyword.has_key?(opts, :input) ->
        read_file(opts[:input])

      positional == "-" ->
        read_stdin()

      true ->
        {:ok, positional}
    end
  end

  defp read_file(path) do
    case File.read(path) do
      {:error, error} ->
        {:error, :file.format_error(error)}

      {:ok, data} ->
        {:ok, data}
    end
  end

  defp read_stdin do
    case IO.read(:stdio, :all) do
      {:error, error} ->
        {:error, Atom.to_string(error)}

      data ->
        {:ok, data}
    end
  end

  defp process(:help) do
    display_usage()
  end

  defp process(:version) do
    display_version()
  end

  defp process({data, opts}) do
    shape = if opts[:rectangle], do: :rectangle, else: :square

    symbol =
      case DataMatrix.encode(data,
             quiet_zone: opts[:quiet_zone],
             version: opts[:symbol],
             shape: shape
           ) do
        {:ok, symbol} ->
          symbol

        {:error, error} ->
          print_error(error)
          System.halt(1)
      end

    if opts[:preview] do
      symbol
      |> DataMatrix.format(:text, dark: "  ", light: "\u2588\u2588")
      |> Kernel.<>("\n")
      |> IO.puts()
    end

    save(opts[:output], symbol, opts)
  end

  defp save(nil, _, _), do: nil

  defp save(path, symbol, opts) do
    renderer =
      path
      |> Path.extname()
      |> String.downcase()
      |> get_renderer()

    content = renderer.format(symbol, opts)

    case File.write(path, content, [:binary]) do
      :ok ->
        print_success("SAVED: #{path}")

      {:error, error} ->
        print_error(:file.format_error(error))
    end
  end

  defp get_renderer(".png") do
    Render.PNG
  end

  defp get_renderer(".svg") do
    Render.SVG
  end

  defp get_renderer(".txt") do
    Render.Text
  end

  defp get_renderer(_) do
    Render.PNG
  end

  defp display_version do
    IO.puts("Data Matrix CLI v" <> @version)
  end

  defp display_usage do
    IO.puts(~s"""

    Create Data Matrix barcode of the modern ECC200 variety.

    USAGE:

      datamatrix [DATA] [OPTIONS]

    When DATA is -, read standard input.

    EXAMPLES:

      $ datamatrix hello
      $ datamatrix -i hello.txt
      $ cat hello.txt | datamatrix -

    OPTIONS:

      -h, --help               Display this usage.
      -v, --version            Display Data Matrix CLI version.
      -p, --preview            Preview generated symbol.
      -i, --input      PATH    Path to input file.
      -o, --output     PATH    Path to output DataMatrix symbol file.
      -s, --symbol     SIZE    Set symbol size. Higher priority than shape.
      -r, --rectangle          Set symbol shape to rectangle.
      -q, --quiet-zone WIDTH   Set quiet zone border width.
      --dark  COLOR            Set color for dark modules.
      --light COLOR            Set color for light modules.
      --module-size    SIZE    Set module size in pixels.
      --width          WIDTH   Set width of SVG (quiet zone included).
      --height         HEIGHT  Set height of SVG (quiet zone included).
      --viewbox                Don't put `width` and `height` attributes in SVG.

    """)
  end

  defp print_error(error) do
    IO.puts(IO.ANSI.red() <> error <> IO.ANSI.reset())
  end

  defp print_success(message) do
    IO.puts(IO.ANSI.green() <> message <> IO.ANSI.reset())
  end
end
