defmodule DataMatrixTest do
  use ExUnit.Case
  doctest DataMatrix

  test "30Q324343430794<OQQ" do
    data_matrix = """
    █░█░█░█░█░█░█░█░
    █░█░█░█░█░░░░░░█
    █░█░█░█░███░██░░
    █░█░█░█░█░██░░██
    █░█░█░█░█░░░██░░
    █░█░█░█░█░░░██░█
    █░█░█░█░█░░░░█░░
    █░█░█░█░░██░█░░█
    █░█░█░█░█░░░░██░
    █░░░░░█░░█░██░░█
    █████████░░░░█░░
    ██░██░░██░░█░█░█
    ███████░░██░░█░░
    ███░░█░████░░█░█
    ███░░█░░█░█░░░█░
    ████████████████
    """

    expected = %{
      version: 3,
      nrow: 16,
      ncol: 16,
      matrix: to_matrix(data_matrix, 16)
    }

    result = DataMatrix.encode!("30Q324343430794<OQQ", quiet_zone: 0)

    assert result == expected
  end

  test "123456" do
    data_matrix = """
    ░░░░░░░░░░░░░░
    ░░░░░░░░░░░░░░
    ░░█░█░█░█░█░░░
    ░░██░░█░██░█░░
    ░░██░░░░░█░░░░
    ░░██░░░███░█░░
    ░░██░░░░█░░░░░
    ░░█░░░░░████░░
    ░░███░██░░░░░░
    ░░████░██░░█░░
    ░░█░░███░█░░░░
    ░░██████████░░
    ░░░░░░░░░░░░░░
    ░░░░░░░░░░░░░░
    """

    expected = %{
      version: 0,
      nrow: 14,
      ncol: 14,
      matrix: to_matrix(data_matrix, 14)
    }

    result = DataMatrix.encode!("123456", quiet_zone: 2)

    assert result == expected
  end

  @tag :skip
  test "A1B2C3D4E5F6G7H8I9J0K1L2" do
    data_matrix = """
    █░█░█░█░█░█░█░█░█░
    █░█░░░█░█░█░░░████
    █░██░░░░░███░░░░█░
    █░░░░░█░███░█░░███
    █░░█░░░░░█░░░███░░
    █░█░█████░█░█░████
    █░░██░░███████░██░
    ██░░███░████████░█
    ██████████░█████░░
    █░███░██░█░░█░██░█
    █░░░█░██░█░█░░███░
    █░██░████░░██░░░░█
    ██░░░██░█░█░░████░
    ██░██░█░░░░░█░░░██
    █░██░█░░██░█░██░█░
    █░░░█░░██░░█░██░██
    █░░░██░░░░░░█░░█░░
    ██████████████████
    """

    expected = %{
      version: 0,
      nrow: 18,
      ncol: 18,
      matrix: to_matrix(data_matrix, 18)
    }

    result = DataMatrix.encode!("A1B2C3D4E5F6G7H8I9J0K1L2", quiet_zone: 0)

    assert result == expected
  end

  defp to_matrix(datamatrix, ncol) do
    datamatrix
    |> String.trim()
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Stream.map(fn module ->
      case module do
        "█" -> 1
        "░" -> 0
      end
    end)
    |> Enum.chunk_every(ncol)
  end
end
