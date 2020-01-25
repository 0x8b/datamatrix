defmodule DataMatrix do
  @moduledoc """
  Documentation for DataMatrix.
  """

  alias DataMatrix.{Bits, Encode, Matrix, ReedSolomon, SymbolAttribute, SVG}

  def encode(data, options \\ [quiet_zone: 1, type: :square]) when is_binary(data) do
    {version, encoded} = Encode.encode(data, options[:type])

    blocks = SymbolAttribute.interleaved_blocks(version)
    errors = SymbolAttribute.total_error_codewords(version)

    ecc =
      0..(blocks - 1)
      |> Stream.map(fn offset ->
        dropped =
          Enum.drop(:binary.bin_to_list(encoded), offset)
          |> Enum.take_every(blocks)
          |> :binary.list_to_bin()

        ReedSolomon.encode(dropped, div(errors, blocks))
      end)
      |> Enum.map(&:binary.bin_to_list/1)
      |> Enum.zip()
      |> Enum.flat_map(&Tuple.to_list(&1))
      |> :binary.list_to_bin()

    bits = (encoded <> ecc) |> Bits.extract()

    Matrix.new(version)
    |> Matrix.draw_patterns()
    |> Matrix.draw_data(bits)
    |> Matrix.draw_quiet_zone(options[:quiet_zone])
    |> Matrix.export()
  end

  def format(matrix, :svg, options \\ []) do
    SVG.format(matrix, options)
  end
end
