defmodule DataMatrix do
  @moduledoc """
  Library that enables programs to write Data Matrix barcodes of the modern ECC200 variety.
  Docs: https://github.com/0x8b/datamatrix
  """

  alias DataMatrix.{Bits, Encode, Matrix, ReedSolomon, Render}

  @default_opts [
    quiet_zone: 1,
    shape: :square
  ]

  @doc """

  """
  def encode!(data, opts \\ [])

  def encode!(data, opts) when is_binary(data) do
    opts = Keyword.merge(@default_opts, opts)

    case Encode.encode!(data, opts[:version] || opts[:shape]) do
      {:ok, version, data_codewords} -> do_encode(version, data_codewords, opts)
      {:error, error} -> raise ArgumentError, message: error
    end
  end

  def encode!(data, _opts) when is_nil(data) do
    raise ArgumentError, message: "Missing `data` argument."
  end

  defp do_encode(version, data_codewords, opts) do
    error_codewords = ReedSolomon.encode(version, data_codewords)

    Matrix.new(version)
    |> Matrix.draw_patterns()
    |> Matrix.draw_data(Bits.extract(data_codewords <> error_codewords))
    |> Matrix.draw_quiet_zone(opts[:quiet_zone])
    |> Matrix.export()
  end

  @doc """

  """
  def format(matrix, _, opts \\ [])

  def format(matrix, :svg, opts) do
    Render.SVG.format(matrix, opts)
  end

  def format(matrix, :text, opts) do
    Render.Text.format(matrix, opts)
  end
end
