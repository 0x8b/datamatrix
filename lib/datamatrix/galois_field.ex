defmodule DataMatrix.GaloisField do
  @moduledoc """
  Provides log and antilog tables for the Galois Field of size 256 with prime modulus 301.  
  """

  @log Code.eval_file("lib/datamatrix/static/log.tuple") |> elem(0)
  @antilog Code.eval_file("lib/datamatrix/static/antilog.tuple") |> elem(0)

  @doc """

  """
  def log(i), do: elem(@log, i)

  @doc """

  """
  def antilog(i), do: elem(@antilog, i)
end
