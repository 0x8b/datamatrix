defmodule DataMatrix.SVG do
  @default_options %{
    background: "white",
    color: "black",
    module_size: 5
  }

  def format(%{nrow: nrow, ncol: ncol, matrix: rows}, options \\ []) do
    options = Map.merge(@default_options, Map.new(options))

    {height, width} =
      get_size(options[:height], options[:width], options[:module_size], nrow, ncol)

    dimensions =
      if options[:viewport] do
        ~s()
      else
        ~s(width="#{width}" height="#{height}" preserveAspectRatio="none")
      end

    points =
      rows
      |> Stream.with_index(0)
      |> Stream.flat_map(fn {row, index} ->
        row
        |> Stream.chunk_by(& &1)
        |> Enum.map(&Enum.count/1)
        |> prepend(0)
        |> Stream.scan(&(&1 + &2))
        |> Stream.flat_map(fn x -> [x, x] end)
        |> Stream.drop(1)
        |> Stream.drop(-1)
        |> Stream.chunk_every(2)
        |> Stream.zip(Stream.dedup(row))
        |> Stream.map(fn {[start, stop], module} ->
          "#{start},#{index + 1 - module} #{stop},#{index + 1 - module}"
        end)
        |> Stream.concat(["#{ncol},#{index + 1} 0,#{index + 1}"])
      end)
      |> Enum.join(" ")

    ~s"""
    <?xml version="1.0" standalone="yes"?>
    <svg #{dimensions} viewBox="0 0 #{ncol} #{nrow}" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="#{options[:background]}"/>
      <polyline fill="#{options[:color]}" points="#{points}"/>
    </svg>
    """
  end

  defp prepend(list, element) do
    [element | list]
  end

  defp get_size(nil, nil, module_size, nrow, ncol) do
    {nrow * module_size, ncol * module_size}
  end

  defp get_size(height, nil, _module_size, nrow, ncol) when is_number(height) do
    {height, height * (ncol / nrow)}
  end

  defp get_size(nil, width, _module_size, nrow, ncol) when is_number(width) do
    {width * (nrow / ncol), width}
  end

  defp get_size(height, width, _module_size, _nrow, _ncol) do
    {height, width}
  end
end
