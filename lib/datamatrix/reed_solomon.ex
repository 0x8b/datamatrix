defmodule DataMatrix.ReedSolomon do
  @moduledoc false

  import Bitwise

  alias DataMatrix.{GaloisField, SymbolAttribute}

  @poly Code.eval_file("lib/datamatrix/polynomials.map") |> elem(0)

  @doc """
  ## Examples

      iex> DataMatrix.ReedSolomon.encode(0, <<142, 164, 186>>)
      <<114, 25, 5, 88, 102>>
  """
  def encode(version, data) do
    blocks = SymbolAttribute.interleaved_blocks(version)
    errors = SymbolAttribute.total_error_codewords(version)
    length = div(errors, blocks)
    coefficients = gen_poly(length)

    0..(blocks - 1)
    |> Stream.map(fn offset ->
      :binary.bin_to_list(data)
      |> Enum.drop(offset)
      |> Enum.take_every(blocks)
      |> Enum.reduce(
        Stream.cycle([0]) |> Enum.take(length + 1),
        fn codeword, acc ->
          k = Enum.at(acc, 0) ^^^ codeword

          acc =
            for j <- 0..(length - 1),
                do: Enum.at(acc, j + 1) ^^^ prod(k, elem(coefficients, length - j - 1))

          Enum.concat(acc, [0])
        end
      )
      |> Enum.take(length)
    end)
    |> Enum.zip()
    |> Enum.flat_map(&Tuple.to_list(&1))
    |> :binary.list_to_bin()
  end

  defp gen_poly(nc) do
    Map.get(@poly, nc)
  end

  defp prod(0, _) do
    0
  end

  defp prod(_, 0) do
    0
  end

  defp prod(a, b) do
    GaloisField.antilog(rem(GaloisField.log(a) + GaloisField.log(b), 255))
  end
end
