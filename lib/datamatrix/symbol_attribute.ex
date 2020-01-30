defmodule DataMatrix.SymbolAttribute do
  @moduledoc false

  @symbol_size {
    {10, 10},
    {12, 12},
    {14, 14},
    {16, 16},
    {18, 18},
    {20, 20},
    {22, 22},
    {24, 24},
    {26, 26},
    {32, 32},
    {36, 36},
    {40, 40},
    {44, 44},
    {48, 48},
    {52, 52},
    {64, 64},
    {72, 72},
    {80, 80},
    {88, 88},
    {96, 96},
    {104, 104},
    {120, 120},
    {132, 132},
    {144, 144},
    {8, 18},
    {8, 32},
    {12, 26},
    {12, 36},
    {16, 36},
    {16, 48}
  }

  @data_region {
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1},
    {2, 2},
    {2, 2},
    {2, 2},
    {2, 2},
    {2, 2},
    {2, 2},
    {4, 4},
    {4, 4},
    {4, 4},
    {4, 4},
    {4, 4},
    {4, 4},
    {6, 6},
    {6, 6},
    {6, 6},
    {1, 1},
    {1, 2},
    {1, 1},
    {1, 2},
    {1, 2},
    {1, 2}
  }

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

  @doc """

  """
  def size(version) do
    elem(@symbol_size, version)
  end

  @doc """

  """
  def mapping_matrix_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = elem(@data_region, version)

    {nrow - 2 * nr, ncol - 2 * nc}
  end

  @doc """

  """
  def data_region_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = elem(@data_region, version)

    {div(nrow, nr) - 2, div(ncol, nc) - 2}
  end

  @doc """

  """
  def total_data_codewords do
    Tuple.to_list(@total_data_codewords)
  end

  @doc """

  """
  def total_error_codewords(version) do
    elem(@total_error_codewords, version)
  end

  @doc """

  """
  def data_capacity(version) do
    elem(@total_data_codewords, version)
  end

  @doc """

  """
  def interleaved_blocks(version) do
    elem(@interleaved_blocks, version)
  end
end
