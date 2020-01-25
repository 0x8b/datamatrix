defmodule DataMatrix.Bits do
  @doc """
    iex> DataMatrix.Bits.extract(<<99>>)
    [0, 1, 1, 0, 0, 0, 1, 1]
  """
  def extract(bits) when is_bitstring(bits) do
    do_extract(bits, [])
  end

  defp do_extract(<<bit::size(1), rest::bitstring>>, bits) when is_bitstring(rest) do
    do_extract(rest, [bit | bits])
  end

  defp do_extract(<<>>, bits), do: bits |> Enum.reverse()
end
