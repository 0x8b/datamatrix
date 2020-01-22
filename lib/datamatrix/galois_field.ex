defmodule DataMatrix.GaloisField do
  import Bitwise

  @gf 256
  @prime 301
  @log_301 %{0 => 1 - @gf}
  @antilog_301 %{}

  Stream.iterate(1, fn antilog_value ->
    value = 2 * antilog_value

    if value >= @gf, do: value ^^^ @prime, else: value
  end)
  |> Stream.take(@gf)
  |> Stream.with_index()
  |> Enum.each(fn {value, index} ->
    Module.put_attribute(__MODULE__, :log_301, Map.put(@log_301, value, index))
    Module.put_attribute(__MODULE__, :antilog_301, Map.put(@antilog_301, index, value))
  end)

  def log(i) do
    Map.get(@log_301, i)
  end

  def antilog(i) do
    Map.get(@antilog_301, i)
  end
end
