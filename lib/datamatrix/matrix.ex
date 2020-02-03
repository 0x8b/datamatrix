defmodule DataMatrix.Matrix do
  @moduledoc false

  alias DataMatrix.MappingMatrix

  defstruct ~w(matrix version nrow ncol quiet_zone)a

  @symbol_size Code.eval_file("lib/datamatrix/static/symbol_size.tuple") |> elem(0)
  @region_size Code.eval_file("lib/datamatrix/static/data_region_size.tuple") |> elem(0)

  @doc """

  """
  def new(version, quiet_zone) when version in 0..29 and is_integer(quiet_zone) do
    {nrow, ncol} = elem(@symbol_size, version)

    %__MODULE__{
      matrix: nil,
      version: version,
      nrow: nrow,
      ncol: ncol,
      quiet_zone: quiet_zone
    }
  end

  @doc """

  """
  def draw_patterns(%__MODULE__{nrow: nrow, ncol: ncol, quiet_zone: qz} = symbol) do
    {vgap, hgap} = elem(@region_size, symbol.version)

    alignment_patterns =
      [
        draw_horizontal_patterns(hgap, nrow, ncol),
        draw_vertical_patterns(vgap, nrow, ncol)
      ]
      |> Stream.concat()
      |> Stream.flat_map(& &1)
      |> Stream.map(fn {row, col} -> {{row + qz, col + qz}, 1} end)
      |> Enum.into(Map.new())

    %__MODULE__{symbol | matrix: alignment_patterns}
  end

  defp draw_horizontal_patterns(gap, nrow, ncol) do
    get_positions(gap, nrow)
    |> Stream.zip(Stream.cycle([:dashed, :solid]))
    |> Stream.map(fn {row, type} ->
      draw_horizontal_line(row, ncol, type)
    end)
  end

  defp draw_vertical_patterns(gap, nrow, ncol) do
    get_positions(gap, ncol)
    |> Stream.zip(Stream.cycle([:solid, :dashed]))
    |> Stream.map(fn {col, type} ->
      draw_vertical_line(col, nrow, type)
    end)
  end

  defp draw_horizontal_line(row, ncol, :solid) do
    for col <- 0..(ncol - 1), do: {row, col}
  end

  defp draw_horizontal_line(row, ncol, :dashed) do
    for col <- 0..(div(ncol, 2) - 1), do: {row, 2 * col}
  end

  defp draw_vertical_line(col, nrow, :solid) do
    for row <- 0..(nrow - 1), do: {row, col}
  end

  defp draw_vertical_line(col, nrow, :dashed) do
    for row <- 0..(div(nrow, 2) - 1), do: {2 * row + 1, col}
  end

  defp get_positions(gap, length) do
    positions =
      [gap + 1, 1]
      |> Stream.cycle()
      |> Stream.scan(&(&1 + &2))
      |> Enum.take_while(&(&1 < length))

    [0 | positions]
  end

  @doc """

  """
  def draw_data(%__MODULE__{nrow: nrow, ncol: ncol, quiet_zone: qz} = symbol, bits) do
    remaining_area =
      if {nrow, ncol} in [{12, 12}, {16, 16}, {20, 20}, {24, 24}] do
        %{
          {nrow + qz - 2, ncol + qz - 2} => 1,
          {nrow + qz - 3, ncol + qz - 3} => 1
        }
      else
        %{}
      end

    mapping = MappingMatrix.get_mapping_matrix(symbol.version)

    matrix =
      mapping
      |> subdivide_into_data_regions(elem(@region_size, symbol.version))
      |> Stream.map(fn {row, col} -> {row + qz + 1, col + qz + 1} end)
      |> Stream.zip(bits)
      |> Map.new()
      |> Map.merge(symbol.matrix)
      |> Map.merge(remaining_area)

    %__MODULE__{symbol | matrix: matrix}
  end

  defp subdivide_into_data_regions(points, {nrow, ncol}) do
    Stream.map(points, fn {row, col} ->
      {
        div(row, nrow) * (nrow + 2) + rem(row, nrow),
        div(col, ncol) * (ncol + 2) + rem(col, ncol)
      }
    end)
  end

  @doc """

  """
  def export(%__MODULE__{nrow: nrow, ncol: ncol, version: version, quiet_zone: qz} = symbol) do
    nrow = nrow + 2 * qz
    ncol = ncol + 2 * qz

    flatten =
      for row <- 0..(nrow - 1),
          col <- 0..(ncol - 1),
          do: Map.get(symbol.matrix, {row, col}, 0)

    %{
      version: version,
      nrow: nrow,
      ncol: ncol,
      matrix: flatten |> Enum.chunk_every(ncol)
    }
  end
end
