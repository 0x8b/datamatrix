defmodule DataMatrix.Render.TextTest do
  use ExUnit.Case

  alias DataMatrix.Render.Text

  test "write text to file" do
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

    text = Text.format(data)

    directory = Path.expand("./test/output")

    File.mkdir(directory)
    File.write!(Path.join(directory, "text.txt"), text)
  end
end
