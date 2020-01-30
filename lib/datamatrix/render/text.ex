defmodule DataMatrix.Render.Text do
  @moduledoc false

  @default_opts [one: "1", zero: "0", separator: "", newline: "\n"]

  @doc """

  """
  def format(%{matrix: rows}, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    dark = to_string(opts[:one])
    light = to_string(opts[:zero])

    Stream.map(rows, fn row ->
      row
      |> map_row(light, dark)
      |> Enum.join(opts[:separator])
    end)
    |> Enum.join(opts[:newline])
  end

  defp map_row(row, light, dark) do
    Enum.map(row, fn module ->
      case module do
        0 -> light
        1 -> dark
      end
    end)
  end
end
