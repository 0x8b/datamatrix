# Data Matrix

This is a software library that enables programs to write Data Matrix barcodes of the modern ECC200 variety.

## Example

```ex
data = "123456"

svg =
  data
  |> DataMatrix.encode()
  |> DataMatrix.format(:svg, color: "crimson", background: "#ddffff")

File.write!("data_matrix.svg", svg)
```

<img src="./docs/figures/example_123456.svg" width="200" alt="Example Data Matrix">
