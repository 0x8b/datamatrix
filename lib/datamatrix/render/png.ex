defmodule DataMatrix.Render.PNG do
  @moduledoc false

  @signature <<0x89, "PNG\r\n", 0x1A, "\n">>

  @defaults %{
    module_size: 10,
    dark: <<0, 0, 0>>,
    light: <<255, 255, 255>>
  }

  @doc """

  """
  def format(%{nrow: nrow, ncol: ncol, matrix: rows}, opts \\ []) do
    opts = Map.merge(@defaults, Map.new(opts))

    light = to_rgb(opts[:light])
    dark = to_rgb(opts[:dark])

    width = ncol * opts[:module_size]
    height = nrow * opts[:module_size]

    idhr = png_chunk("IHDR", <<width::32, height::32, 8::8, 3::8, 0::24>>)
    plte = png_chunk("PLTE", <<light::binary, dark::binary>>)
    idat = png_chunk("IDAT", pixels(rows, opts))
    iend = png_chunk("IEND", "")

    [@signature, idhr, plte, idat, iend]
    |> List.flatten()
    |> Enum.join()
  end

  defp to_rgb("#" <> rgb) do
    <<String.to_integer(rgb, 16)::24>>
  end

  defp to_rgb(rgb), do: rgb

  defp png_chunk(type, binary) do
    length = byte_size(binary)
    crc = :erlang.crc32(type <> binary)

    [<<length::32>>, type, binary, <<crc::32>>]
  end

  defp pixels(rows, opts) do
    rows
    |> Enum.map(&row_pixels(&1, opts))
    |> Enum.join()
    |> :zlib.compress()
  end

  defp row_pixels(row, opts) do
    module_size = opts[:module_size]

    pixels =
      row
      |> Stream.map(&module_pixels(&1, module_size))
      |> Enum.join()

    :binary.copy(<<0>> <> pixels, module_size)
  end

  defp module_pixels(0, size), do: :binary.copy(<<0>>, size)
  defp module_pixels(1, size), do: :binary.copy(<<1>>, size)
end
