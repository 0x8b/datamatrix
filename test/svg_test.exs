defmodule DataMatrix.SVGTest do
  use ExUnit.Case

  test "write SVG to file" do
    data = %{
      nrow: 12,
      ncol: 12,
      matrix: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0],
        [0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        [0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0],
        [0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0],
        [0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0],
        [0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0],
        [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    }

    svg = DataMatrix.SVG.format(data, color: "crimson", background: "pink")

    directory = Path.expand("./test/output")

    File.mkdir!(directory)
    File.write!(Path.join(directory, "output.svg"), svg)
  end
end
