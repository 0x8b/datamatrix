defmodule DataMatrix.GaloisField do
  @moduledoc """
  Provides log and antilog tables for the Galois Field of size 256 with prime modulus 301.  
  """

  import Bitwise

  @log Code.eval_file("lib/datamatrix/static/log.tuple") |> elem(0)
  @antilog Code.eval_file("lib/datamatrix/static/antilog.tuple") |> elem(0)

  @doc """

  """
  def log(i), do: elem(@log, i)

  @doc """

  """
  def antilog(i), do: elem(@antilog, i)

  @doc """

  """
  def add(a, b), do: a ^^^ b

  @doc """

  """
  def multiply(0, _), do: 0
  def multiply(_, 0), do: 0
  def multiply(a, b), do: antilog(rem(log(a) + log(b), 255))
end
