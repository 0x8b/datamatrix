defmodule DataMatrix.Matrix do
  @moduledoc false

  alias DataMatrix.MappingMatrix

  @symbol_size {
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
  }

  @data_region {1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 16, 16, 16, 16, 16, 16, 36, 36, 36,
                1, 2, 1, 2, 2, 2}

  defstruct [:matrix, :version, :nrow, :ncol]

  def new(version) when version in 0..29 do
    {nrow, ncol} = size(version)

    %__MODULE__{
      matrix: empty_matrix(nrow, ncol),
      version: version,
      nrow: nrow,
      ncol: ncol
    }
  end

  defp size(version) do
    size = elem(@symbol_size, version)

    cond do
      is_integer(size) -> {size, size}
      true -> size
    end
  end

  def draw_patterns(%__MODULE__{matrix: matrix, nrow: nrow, ncol: ncol, version: version} = m) do
    {region_nrow, region_ncol} = data_region_size(version)

    horizontal_patterns =
      get_positions(region_nrow, nrow)
      |> Stream.zip(Stream.cycle([:dotted, :solid]))
      |> Stream.map(fn {row, type} ->
        for col <- 0..(ncol - 1),
            into: %{},
            do: {{row, col}, if(type == :dotted, do: 1 - rem(col, 2), else: 1)}
      end)

    vertical_patterns =
      get_positions(region_ncol, ncol)
      |> Stream.zip(Stream.cycle([:solid, :dotted]))
      |> Stream.map(fn {col, type} ->
        for row <- 0..(nrow - 1),
            into: %{},
            do: {{row, col}, if(type == :dotted, do: rem(row, 2), else: 1)}
      end)

    patterns =
      horizontal_patterns
      |> Stream.concat(vertical_patterns)
      |> Enum.reduce(%{}, &Map.merge/2)

    %{m | matrix: Map.merge(matrix, patterns)}
  end

  defp get_positions(gap, length) do
    positions =
      [gap + 1, 1]
      |> Stream.cycle()
      |> Stream.scan(&(&1 + &2))
      |> Enum.take_while(&(&1 < length))

    [0 | positions]
  end

  def mapping_matrix_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = no_of_data_regions(version)

    {nrow - 2 * nr, ncol - 2 * nc}
  end

  defp data_region_size(version) do
    {nrow, ncol} = size(version)
    {nr, nc} = no_of_data_regions(version)

    {div(nrow, nr) - 2, div(ncol, nc) - 2}
  end

  defp no_of_data_regions(version) do
    case elem(@data_region, version) do
      1 -> {1, 1}
      2 -> {1, 2}
      4 -> {2, 2}
      16 -> {4, 4}
      36 -> {6, 6}
    end
  end

  def draw_data(%__MODULE__{matrix: matrix, version: version} = m, bits) do
    {nrow, ncol} = mapping_matrix_size(version)
    {mapping, mapping_matrix} = MappingMatrix.get_mapping_matrix(nrow, ncol)

    data_matrix =
      mapping
      |> subdivide_into_data_regions(data_region_size(version))
      |> Stream.zip(bits)
      |> Map.new()

    data_matrix =
      mapping_matrix
      |> Map.merge(data_matrix)
      |> translate(1, 1)

    %{m | matrix: Map.merge(matrix, data_matrix)}
  end

  defp subdivide_into_data_regions(points, {nrow, ncol}) do
    Stream.map(points, fn {row, col} ->
      {
        div(row, nrow) * (nrow + 2) + rem(row, nrow),
        div(col, ncol) * (ncol + 2) + rem(col, ncol)
      }
    end)
  end

  defp translate(matrix, drow, dcol) do
    for {{row, col}, value} <- matrix,
        into: %{},
        do: {{row + drow, col + dcol}, value}
  end

  def draw_quiet_zone(%__MODULE__{matrix: matrix, nrow: nrow, ncol: ncol} = m, width \\ 1) do
    new_nrow = nrow + 2 * width
    new_ncol = ncol + 2 * width

    empty = empty_matrix(new_nrow, new_ncol)

    centered_matrix = translate(matrix, width, width)

    %__MODULE__{m | matrix: Map.merge(empty, centered_matrix), nrow: new_nrow, ncol: new_ncol}
  end

  def export(%__MODULE__{matrix: matrix, nrow: nrow, ncol: ncol, version: version}) do
    flatten =
      for row <- 0..(nrow - 1),
          col <- 0..(ncol - 1),
          do: Map.get(matrix, {row, col})

    %{
      version: version,
      nrow: nrow,
      ncol: ncol,
      matrix: flatten |> Enum.chunk_every(ncol)
    }
  end

  defp empty_matrix(nrow, ncol) do
    for row <- 0..(nrow - 1),
        col <- 0..(ncol - 1),
        into: %{},
        do: {{row, col}, 0}
  end
end
