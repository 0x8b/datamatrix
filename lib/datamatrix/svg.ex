defmodule DataMatrix.SVG do
  @default_options %{
    background: "white",
    color: "black"
  }

  def format(%{nrow: nrow, ncol: ncol, matrix: matrix}, options \\ []) do
    options = Map.merge(@default_options, Map.new(options))

    points =
      matrix
      |> Stream.with_index(1)
      |> Stream.flat_map(fn {modules, row} ->
        modules
        |> Stream.chunk_by(& &1)
        |> Enum.map(&Enum.count/1)
        |> prepend(0)
        |> Stream.scan(&(&1 + &2))
        |> Stream.flat_map(fn x -> [x, x] end)
        |> Stream.drop(1)
        |> Stream.drop(-1)
        |> Stream.chunk_every(2)
        |> Stream.zip(Stream.dedup(modules))
        |> Stream.map(fn {[start, stop], module} ->
          "#{start},#{row - module} #{stop},#{row - module}"
        end)
        |> Stream.concat(["0,#{row}"])
      end)
      |> Enum.join(" ")

    ~s"""
    <?xml version="1.0" standalone="yes"?>
    <svg viewBox="0 0 #{ncol} #{nrow}" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="#{options[:background]}"/>
      <polyline fill="#{options[:color]}" points="#{points}"/>
    </svg>
    """
  end

  defp prepend(list, element) do
    [element | list]
  end
end
