defmodule DataMatrix.Render.Text do
  @default_opts [one: "1", zero: "0", separator: "", newline: "\n"]

  def format(%{matrix: rows}, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    symbol_for_one = to_string(opts[:one])
    symbol_for_zero = to_string(opts[:zero])

    rows
    |> Stream.map(fn row ->
      Stream.map(row, fn module ->
        case module do
          0 -> symbol_for_zero
          1 -> symbol_for_one
        end
      end)
      |> Enum.join(opts[:separator])
    end)
    |> Enum.join(opts[:newline])
  end
end
