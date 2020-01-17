defmodule DataMatrix.MappingMatrixTest do
  use ExUnit.Case
  alias DataMatrix.MappingMatrix

  doctest MappingMatrix

  @size [
    8,
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    28,
    32,
    36,
    40,
    44,
    48,
    56,
    64,
    72,
    80,
    88,
    96,
    108,
    120,
    132,
    {6, 16},
    {6, 28},
    {10, 24},
    {10, 32},
    {14, 32},
    {14, 44}
  ]

  test "test mapping for all sizes" do
    result =
      @size
      |> Stream.map(&get_size/1)
      |> Stream.map(fn {nrow, ncol} ->
        map =
          MappingMatrix.new(nrow, ncol)
          |> MappingMatrix.get_mapping()
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

    assert {:ok, result} == File.read("./test/assets/mapping_matrices.data")
  end

  defp get_size(size) when is_integer(size) do
    {size, size}
  end

  defp get_size(size) when is_tuple(size) do
    size
  end

  defp generate_labels(nrow, ncol) do
    for major <- 1..div(nrow * ncol, 8),
        minor <- 1..8,
        do: "#{String.pad_leading(Integer.to_string(major), 3)}.#{minor} "
  end
end
