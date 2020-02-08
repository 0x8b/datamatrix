defmodule DataMatrix.ReedSolomon do
  @moduledoc false

  alias DataMatrix.GaloisField

  @blocks Code.eval_file("lib/datamatrix/static/interleaved_blocks.tuple") |> elem(0)
  @error_codewords Code.eval_file("lib/datamatrix/static/total_error_codewords.tuple") |> elem(0)
  @generator_polynomial Code.eval_file("lib/datamatrix/static/polynomials.map") |> elem(0)

  @doc """
  ## Examples

      iex> DataMatrix.ReedSolomon.encode(0, <<142, 164, 186>>)
      <<114, 25, 5, 88, 102>>
  """
  def encode(version, data) do
    stride = elem(@blocks, version)
    errors = elem(@error_codewords, version)
    order_polynomial = div(errors, stride)
    coefficients = Map.get(@generator_polynomial, order_polynomial)

    data = :binary.bin_to_list(data)

    0..(stride - 1)
    |> Enum.map(fn offset ->
      data
      |> Stream.drop(offset)
      |> Stream.take_every(stride)
      |> Enum.reduce(
        Tuple.duplicate(0, order_polynomial + 1),
        fn codeword, acc ->
          k = GaloisField.add(elem(acc, 0), codeword)

          acc =
            for j <- 0..(order_polynomial - 1),
                do:
                  GaloisField.add(
                    elem(acc, j + 1),
                    GaloisField.multiply(k, elem(coefficients, order_polynomial - j - 1))
                  )

          List.to_tuple(acc)
          |> Tuple.append(0)
        end
      )
      |> Tuple.delete_at(order_polynomial)
    end)
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.zip()
    |> Enum.flat_map(&Tuple.to_list(&1))
    |> :binary.list_to_bin()
  end
end
