defmodule DataMatrix.Render.Text do
  @default_options %{
    one: "1",
    zero: "0",
    newline: "\n",
    separator: ""
  }

  def format(%{nrow: nrow, ncol: ncol, matrix: rows}, options \\ []) do
    options = Map.merge(@default_options, Map.new(options))

    symbol_for_one = to_string(options[:one])
    symbol_for_zero = to_string(options[:zero])

    rows
    |> Stream.map(fn row ->
      Stream.map(row, fn module ->
        case module do
          0 -> symbol_for_zero
          1 -> symbol_for_one
        end
      end)
      |> Enum.join(options[:separator])
    end)
    |> Enum.join(options[:newline])
  end
end
