defmodule DataMatrix.Encode do
  alias DataMatrix.SymbolAttribute

  @ascii_digit 48..57
  @ascii_pad 129
  @upper_shift 235

  @doc """
    iex> DataMatrix.Encode.encode("1234569")
    {1, <<142, 164, 186, 58, 129>>}

    iex> DataMatrix.Encode.encode("Aa999")
    {1, <<66, 98, 229, 58, 129>>}

    iex> DataMatrix.Encode.encode("AAAAAAAAA")
    {3, <<66, 66, 66, 66, 66, 66, 66, 66, 66, 129, 101, 251>>}
  """
  def encode(input) when is_binary(input) do
    encoded = do_encode(input)
    length = byte_size(encoded)

    version = find_symbol_version(length)
    capacity = SymbolAttribute.data_capacity(version)

    {version, encoded <> randomize_253_state(length, capacity - length)}
  end

  defp do_encode(<<tens, unit, rest::binary>>)
       when tens in @ascii_digit and unit in @ascii_digit do
    encoded = 130 + (tens - 48) * 10 + (unit - 48)

    <<encoded>> <> do_encode(rest)
  end

  defp do_encode(<<character, rest::binary>>) when character in 0..127 do
    <<character + 1>> <> do_encode(rest)
  end

  defp do_encode(<<character, rest::binary>>) when character in 128..255 do
    encoded = character - 128 + 1

    <<@upper_shift>> <> <<encoded>> <> do_encode(rest)
  end

  defp do_encode(<<>>) do
    <<>>
  end

  defp find_symbol_version(data_length) do
    Enum.find_index(SymbolAttribute.total_data_codewords(), fn capacity ->
      capacity >= data_length
    end)
  end

  defp randomize_253_state(_, 0) do
    <<>>
  end

  defp randomize_253_state(position, n) do
    <<@ascii_pad>> <> do_randomize_253_state(position + 1, n - 1)
  end

  defp do_randomize_253_state(_, 0) do
    <<>>
  end

  defp do_randomize_253_state(position, n) do
    pseudo_random = @ascii_pad + rem(149 * position, 253) + 1

    pseudo_random =
      if pseudo_random <= 254 do
        pseudo_random
      else
        pseudo_random - 254
      end

    <<pseudo_random>> <> do_randomize_253_state(position + 1, n - 1)
  end
end
