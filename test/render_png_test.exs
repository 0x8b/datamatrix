defmodule DataMatrix.Render.PNGTest do
  use ExUnit.Case

  alias DataMatrix.Render.PNG

  test "write PNG to file" do
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

    png = PNG.format(data, dark: "#ff0000", light: "#ffff00")

    directory = Path.expand("./test/output")

    File.mkdir(directory)
    File.write!(Path.join(directory, "output_1.png"), png, [:binary])
  end

  test "write PNG to file (matrix without quiet zone)" do
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

    png = PNG.format(data)

    directory = Path.expand("./test/output")

    File.mkdir(directory)
    File.write!(Path.join(directory, "output_2.png"), png, [:binary])
  end
end
