defmodule DataMatrix.Bits do
  @doc """
    iex> DataMatrix.Bits.extract(<<99>>)
    [0, 1, 1, 0, 0, 0, 1, 1]
  """
  def extract(str) when is_binary(str) do
    extract(str, [])
  end

  defp extract(<<b::size(1), bits::bitstring>>, acc) when is_bitstring(bits) do
    extract(bits, [b | acc])
  end

  defp extract(<<>>, acc), do: acc |> Enum.reverse()
end
