defmodule DataMatrix.MatrixTest do
  use ExUnit.Case
  doctest DataMatrix.Matrix

  alias DataMatrix.{Bits, Matrix}

  test "example" do
    expected = %{
      nrow: 14,
      ncol: 14,
      version: 0,
      matrix: [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    }

    version = 0

    result =
      Matrix.new(version)
      |> Matrix.draw_patterns()
      |> Matrix.draw_data(Bits.extract(<<0x8E, 0xA4, 0xBA, 0x72, 0x19, 0x05, 0x58, 0x66>>))
      |> Matrix.fill_remaining_area()
      |> Matrix.draw_quiet_zone(2)
      |> Matrix.export()

    assert Map.equal?(result, expected)
  end
end
