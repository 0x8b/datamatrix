defmodule DataMatrix.MappingMatrixTest do
  use ExUnit.Case
  alias DataMatrix.{MappingMatrix, Matrix}

  doctest MappingMatrix

  test "test mapping for all sizes" do
    result =
      0..29
      |> Stream.map(&Matrix.mapping_matrix_size/1)
      |> Stream.map(fn {nrow, ncol} ->
        map =
          MappingMatrix.get_mapping_matrix(nrow, ncol)
          |> elem(0)
          |> Stream.zip(generate_labels(nrow, ncol))
          |> Map.new()

        list =
          for row <- 0..(nrow - 1),
              col <- 0..(ncol - 1),
              do: Map.get(map, {row, col}, "EMPTY ")

        list
        |> Stream.chunk_every(ncol)
        |> Stream.map(&Enum.join(&1, ""))
        |> Enum.join("\n")
      end)
      |> Enum.join("\n")

    assert result ==
             File.read!("./test/assets/mapping_matrices.data") |> String.replace("\r\n", "\n")
  end

  defp generate_labels(nrow, ncol) do
    for major <- 1..div(nrow * ncol, 8),
        minor <- 1..8,
        do: "#{String.pad_leading(Integer.to_string(major), 3)}.#{minor} "
  end
end
