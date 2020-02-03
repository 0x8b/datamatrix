defmodule DataMatrix.Render.SVG do
  @moduledoc false

  @default_options [
    background: "white",
    color: "black",
    module_size: 5
  ]

  @doc """

  """
  def format(%{nrow: nrow, ncol: ncol, matrix: rows}, options \\ []) do
    options = Keyword.merge(@default_options, options)

    {height, width} =
      get_size(options[:height], options[:width], options[:module_size], nrow, ncol)

    dimensions =
      if options[:viewbox] do
        ~s()
      else
        ~s(width="#{width}" height="#{height}" preserveAspectRatio="none")
      end

    lines =
      rows
      |> Stream.with_index(0)
      |> Stream.map(fn {row, index} ->
        dasharray =
          row
          |> Stream.chunk_by(& &1)
          |> Stream.map(&Enum.count/1)
          |> Enum.join(" ")

        dasharray =
          if hd(row) == 0 do
            "0 " <> dasharray
          else
            dasharray
          end

        ~s(<line x1="0" y1="#{index}" x2="#{ncol}" y2="#{index}" stroke-dasharray="#{dasharray}"/>)
      end)
      |> Enum.join("\n")

    ~s"""
    <?xml version="1.0" standalone="yes"?>
    <svg #{dimensions} viewBox="0 0 #{ncol} #{nrow}" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="#{options[:background]}"/>
      <g transform="translate(0 0.5)" stroke="#{options[:color]}" stroke-width="1">
        #{lines}
      </g>
    </svg>
    """
  end

  defp get_size(nil, nil, module_size, nrow, ncol), do: {nrow * module_size, ncol * module_size}

  defp get_size(height, nil, _module_size, nrow, ncol) when is_number(height) do
    {height, height * (ncol / nrow)}
  end

  defp get_size(nil, width, _module_size, nrow, ncol) when is_number(width) do
    {width * (nrow / ncol), width}
  end

  defp get_size(height, width, _module_size, _nrow, _ncol), do: {height, width}
end
