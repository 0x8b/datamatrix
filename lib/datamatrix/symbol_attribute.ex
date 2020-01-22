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

  @total_data_codewords {
    3,
    5,
    8,
    12,
    18,
    22,
    30,
    36,
    44,
    62,
    86,
    114,
    144,
    174,
    204,
    280,
    368,
    456,
    576,
    696,
    816,
    1050,
    1304,
    1558,
    5,
    10,
    16,
    22,
    32,
    49
  }

  @total_error_codewords {
    5,
    7,
    10,
    12,
    14,
    18,
    20,
    24,
    28,
    36,
    42,
    48,
    56,
    68,
    84,
    112,
    144,
    192,
    224,
    272,
    336,
    408,
    496,
    620,
    7,
    11,
    14,
    18,
    24,
    28
  }

  @interleaved_blocks {
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    2,
    2,
    4,
    4,
    4,
    4,
    6,
    6,
    8,
    10,
    1,
    1,
    1,
    1,
    1,
    1
  }

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

  def total_data_codewords do
    Tuple.to_list(@total_data_codewords)
  end

  def data_capacity(version) do
    elem(@total_data_codewords, version)
  end

  def total_error_codewords(version) do
    elem(@total_error_codewords, version)
  end

  def interleaved_blocks(version) do
    elem(@interleaved_blocks, version)
  end
end
