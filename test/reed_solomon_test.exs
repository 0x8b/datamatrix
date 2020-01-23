defmodule DataMatrix.ReedSolomonTest do
  use ExUnit.Case
  doctest DataMatrix.ReedSolomon

  alias DataMatrix.ReedSolomon

  test "generator polynomial coefficients" do
    number_of_check_characters = [5, 7, 10, 11, 12, 14, 18, 20, 24, 28, 36, 42, 48, 56, 62, 68]

    expected =
      "./test/assets/generator_polynomial_coefficients.data"
      |> File.stream!()
      |> Stream.zip(number_of_check_characters)
      |> Stream.map(fn {line, n} ->
        coefficients =
          line
          |> String.trim()
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()

        {n, coefficients}
      end)
      |> Map.new()

    result =
      number_of_check_characters
      |> Stream.map(fn n -> {n, ReedSolomon.gen_poly(n)} end)
      |> Map.new()

    assert result == expected
  end
end
