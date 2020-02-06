defmodule DataMatrix.Encode do
  @moduledoc false

  @symbol_capacity Code.eval_file("lib/datamatrix/static/total_data_codewords.tuple") |> elem(0)

  @ascii_digit 48..57
  @ascii_pad 129
  @upper_shift 235

  @doc """
  ## Examples
      iex> DataMatrix.Encode.encode("1234569")
      {:ok, 1, <<142, 164, 186, 58, 129>>}

      iex> DataMatrix.Encode.encode("Aa999")
      {:ok, 1, <<66, 98, 229, 58, 129>>}

      iex> DataMatrix.Encode.encode("AAAAAAAAA")
      {:ok, 3, <<66, 66, 66, 66, 66, 66, 66, 66, 66, 129, 101, 251>>}
  """
  def encode(binary), do: encode(binary, :square)

  @doc """

  """
  def encode(binary, version) do
    data_codewords = encode_ascii(binary)
    data_codewords_length = byte_size(data_codewords)

    case find_symbol(data_codewords_length, version) do
      {:ok, version} ->
        {:ok, version,
         data_codewords <>
           randomize_253_state(
             data_codewords_length,
             elem(@symbol_capacity, version) - data_codewords_length
           )}

      {:error, error} ->
        {:error, error}
    end
  end

  defp encode_ascii(<<tens, unit, rest::binary>>)
       when tens in @ascii_digit and unit in @ascii_digit do
    encoded = 130 + (tens - 48) * 10 + (unit - 48)

    <<encoded>> <> encode_ascii(rest)
  end

  defp encode_ascii(<<character, rest::binary>>) when character in 0..127 do
    <<character + 1>> <> encode_ascii(rest)
  end

  defp encode_ascii(<<character, rest::binary>>) when character in 128..255 do
    encoded = character - 128 + 1

    <<@upper_shift>> <> <<encoded>> <> encode_ascii(rest)
  end

  defp encode_ascii(<<>>), do: <<>>

  defp find_symbol(data_length, version) when version in 0..29 do
    if data_length <= elem(@symbol_capacity, version) do
      {:ok, version}
    else
      {:error, "Specified version is too small for the data."}
    end
  end

  defp find_symbol(data_length, :rectangle) do
    find_symbol_by_offset(data_length, 24)
  end

  defp find_symbol(data_length, _) do
    find_symbol_by_offset(data_length, 0)
  end

  defp find_symbol_by_offset(data_length, offset) do
    version =
      @symbol_capacity
      |> Tuple.to_list()
      |> Stream.drop(offset)
      |> Enum.find_index(fn capacity ->
        capacity >= data_length
      end)

    if version do
      {:ok, version + offset}
    else
      {:error, "The data is too long."}
    end
  end

  defp randomize_253_state(_, 0), do: <<>>

  defp randomize_253_state(position, n) do
    <<@ascii_pad>> <> do_randomize_253_state(position + 1, n - 1)
  end

  defp do_randomize_253_state(_, 0), do: <<>>

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
