defmodule DataMatrix.SymbolAttribute do
  @data_region {1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 36, 36, 36,
                1, 2, 1, 2, 2, 2}

  symbol_size =
    [
      10,
      12,
      14,
      16,
      18,
      20,
      22,
      24,
      26,
      32,
      36,
      40,
      44,
      48,
      52,
      64,
      72,
      80,
      88,
      96,
      104,
      120,
      132,
      144,
      {8, 18},
      {8, 32},
      {12, 26},
      {12, 36},
      {16, 36},
      {16, 48}
    ]
    |> Enum.map(fn size ->
      cond do
        is_integer(size) -> {size, size}
        true -> size
      end
    end)

  Module.put_attribute(__MODULE__, :symbol_size, List.to_tuple(symbol_size))

  def size(version) do
    elem(@symbol_size, version)
  end

  defp data_region(version) do
    elem(@data_region, version)
  end

  def mapping_matrix_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = no_of_data_regions(version)

    {nrow - 2 * nr, ncol - 2 * nc}
  end

  def data_region_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = no_of_data_regions(version)

    {div(nrow, nr) - 2, div(ncol, nc) - 2}
  end

  defp no_of_data_regions(version) do
    case data_region(version) do
      1 -> {1, 1}
      2 -> {1, 2}
      4 -> {2, 2}
      16 -> {4, 4}
      36 -> {6, 6}
    end
  end
end
