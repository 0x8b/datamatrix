defmodule DataMatrix.Matrix do
  @moduledoc false

  alias DataMatrix.MappingMatrix

  defstruct ~w(dark version nrow ncol)a

  @symbol_size Code.eval_file("lib/datamatrix/static/symbol_size.tuple") |> elem(0)
  @region_size Code.eval_file("lib/datamatrix/static/data_region_size.tuple") |> elem(0)

  @doc """

  """
  def new(version) when version in 0..29 do
    {nrow, ncol} = elem(@symbol_size, version)

    %__MODULE__{
      dark: nil,
      version: version,
      nrow: nrow,
      ncol: ncol
    }
  end

  @doc """

  """
  def draw_patterns(%__MODULE__{nrow: nrow, ncol: ncol, version: version} = symbol) do
    {row_gap, col_gap} = elem(@region_size, version)

    alignment_patterns =
      [
        draw_horizontal_patterns(row_gap, nrow, ncol),
        draw_vertical_patterns(col_gap, nrow, ncol)
      ]
      |> Enum.concat()
      |> List.flatten()

    %__MODULE__{symbol | dark: alignment_patterns}
  end

  defp draw_horizontal_patterns(gap, nrow, ncol) do
    0
    |> Stream.iterate(&(&1 + gap + 2))
    |> Stream.take_while(&(&1 < nrow))
    |> Stream.map(fn row ->
      [
        draw_dashed_horizontal_line(row, ncol),
        draw_solid_horizontal_line(row + gap + 1, ncol)
      ]
    end)
  end

  defp draw_vertical_patterns(gap, nrow, ncol) do
    0
    |> Stream.iterate(&(&1 + gap + 2))
    |> Stream.take_while(&(&1 < ncol))
    |> Stream.map(fn col ->
      [
        draw_solid_vertical_line(col, nrow),
        draw_dashed_vertical_line(col + gap + 1, nrow)
      ]
    end)
  end

  defp draw_solid_horizontal_line(row, ncol) do
    for col <- 0..(ncol - 1), do: {row, col}
  end

  defp draw_dashed_horizontal_line(row, ncol) do
    for col <- 0..(div(ncol, 2) - 1), do: {row, 2 * col}
  end

  defp draw_solid_vertical_line(col, nrow) do
    for row <- 0..(nrow - 1), do: {row, col}
  end

  defp draw_dashed_vertical_line(col, nrow) do
    for row <- 0..(div(nrow, 2) - 1), do: {2 * row + 1, col}
  end

  @doc """

  """
  def draw_data(%__MODULE__{dark: dark, version: version} = symbol, bits) do
    {mapping, remaining_area} = MappingMatrix.get_mapping_matrix(version)

    data =
      mapping
      |> Stream.zip(bits)
      |> Stream.filter(fn {_, bit} -> bit == 1 end)
      |> Stream.map(&elem(&1, 0))
      |> Stream.concat(remaining_area)
      |> subdivide_into_data_regions(elem(@region_size, version))
      |> Stream.map(fn {row, col} -> {row + 1, col + 1} end)

    %__MODULE__{symbol | dark: Enum.concat(dark, data)}
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
  def draw_quiet_zone(%__MODULE__{nrow: nrow, ncol: ncol, dark: dark} = symbol, quiet_zone) do
    translated =
      Enum.map(dark, fn {row, col} ->
        {row + quiet_zone, col + quiet_zone}
      end)

    nrow = nrow + 2 * quiet_zone
    ncol = ncol + 2 * quiet_zone

    %__MODULE__{symbol | nrow: nrow, ncol: ncol, dark: translated}
  end

  @doc """

  """
  def export(%__MODULE__{nrow: nrow, ncol: ncol, version: version} = symbol) do
    dark =
      symbol.dark
      |> Stream.map(&{&1, 1})
      |> Enum.into(Map.new())

    flatten =
      for row <- 0..(nrow - 1),
          col <- 0..(ncol - 1),
          do: Map.get(dark, {row, col}, 0)

    %{
      version: version,
      nrow: nrow,
      ncol: ncol,
      matrix: Enum.chunk_every(flatten, ncol)
    }
  end
end
