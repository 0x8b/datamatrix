defmodule DataMatrix.MappingMatrix do
  @moduledoc false

  defstruct [:nrow, :ncol]

  def new(nrow, ncol) do
    %__MODULE__{
      nrow: nrow,
      ncol: ncol
    }
  end

  def get_mapping(%__MODULE__{nrow: nrow, ncol: ncol} = m) do
    {mapping, _} =
      Enum.flat_map_reduce(generate_placement_path(m), MapSet.new(), fn module, occupied ->
        if available?(module, occupied) do
          modules =
            Enum.map(shape(module, {nrow, ncol}), fn {row, col} ->
              module({row, col}, {nrow, ncol})
            end)

          new_occupied = MapSet.union(occupied, MapSet.new(modules))

          {modules, new_occupied}
        else
          {[], occupied}
        end
      end)

    mapping
  end

  defp generate_placement_path(%__MODULE__{nrow: nrow, ncol: ncol}) do
    Stream.iterate({4, 0, :upper_right}, fn {row, col, direction} ->
      if direction == :upper_right do
        if row - 2 >= 0 && col + 2 < ncol do
          {row - 2, col + 2, :upper_right}
        else
          {row - 1, col + 5, :lower_left}
        end
      else
        if row + 2 < nrow && col - 2 >= 0 do
          {row + 2, col - 2, :lower_left}
        else
          {row + 5, col - 1, :upper_right}
        end
      end
    end)
    |> Stream.map(fn {row, col, _} ->
      {row, col}
    end)
    |> Enum.take_while(fn {row, col} ->
      row < nrow || col < ncol
    end)
  end

  defp available?(module, occupied) do
    not MapSet.member?(occupied, module)
  end

  defp shape({row, col}, {nrow, ncol}) when row == nrow and col == 0 do
    [
      {nrow - 1, 0},
      {nrow - 1, 1},
      {nrow - 1, 2},
      {0, ncol - 2},
      {0, ncol - 1},
      {1, ncol - 1},
      {2, ncol - 1},
      {3, ncol - 1}
    ]
  end

  defp shape({row, col}, {nrow, ncol})
       when row == nrow - 2 and col == 0 and rem(ncol, 4) != 0 do
    [
      {nrow - 3, 0},
      {nrow - 2, 0},
      {nrow - 1, 0},
      {0, ncol - 4},
      {0, ncol - 3},
      {0, ncol - 2},
      {0, ncol - 1},
      {1, ncol - 1}
    ]
  end

  defp shape({row, col}, {nrow, ncol})
       when row == nrow - 2 and col == 0 and rem(ncol, 8) == 4 do
    [
      {nrow - 3, 0},
      {nrow - 2, 0},
      {nrow - 1, 0},
      {0, ncol - 2},
      {0, ncol - 1},
      {1, ncol - 1},
      {2, ncol - 1},
      {3, ncol - 1}
    ]
  end

  defp shape({row, col}, {nrow, ncol})
       when row == nrow + 4 and col == 2 and rem(ncol, 8) == 0 do
    [
      {nrow - 1, 0},
      {nrow - 1, ncol - 1},
      {0, ncol - 3},
      {0, ncol - 2},
      {0, ncol - 1},
      {1, ncol - 3},
      {1, ncol - 2},
      {1, ncol - 1}
    ]
  end

  defp shape({row, col}, {nrow, ncol}) when row in 0..(nrow - 1) and col in 0..(ncol - 1) do
    [
      {row - 2, col - 2},
      {row - 2, col - 1},
      {row - 1, col - 2},
      {row - 1, col - 1},
      {row - 1, col},
      {row, col - 2},
      {row, col - 1},
      {row, col}
    ]
  end

  defp shape({_, _}, {_, _}) do
    []
  end

  defp module({row, col}, {nrow, ncol}) when row < 0 do
    module({row + nrow, col + 4 - rem(nrow + 4, 8)}, {nrow, ncol})
  end

  defp module({row, col}, {nrow, ncol}) when col < 0 do
    module({row + 4 - rem(ncol + 4, 8), col + ncol}, {nrow, ncol})
  end

  defp module({row, col}, {_, _}) do
    {row, col}
  end
end
