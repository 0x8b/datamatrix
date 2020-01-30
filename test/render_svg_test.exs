defmodule DataMatrix.Render.SVGTest do
  use ExUnit.Case

  alias DataMatrix.Render.SVG

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

    svg = SVG.format(data, color: "crimson", background: "pink")

    directory = Path.expand("./test/output")

    File.mkdir(directory)
    File.write!(Path.join(directory, "output_1.svg"), svg)
  end

  test "write SVG to file (matrix without quiet zone)" do
    data = %{
      nrow: 10,
      ncol: 10,
      matrix: [
        [1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
        [1, 1, 0, 0, 1, 0, 1, 1, 0, 1],
        [1, 1, 0, 0, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 1, 1, 0, 1],
        [1, 1, 0, 0, 0, 0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 1, 1, 1, 1],
        [1, 1, 1, 0, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 1, 1, 0, 0, 1],
        [1, 0, 0, 1, 1, 1, 0, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      ]
    }

    svg = SVG.format(data, color: "green", background: "lightgreen")

    directory = Path.expand("./test/output")

    File.mkdir(directory)
    File.write!(Path.join(directory, "output_2.svg"), svg)
  end
end
