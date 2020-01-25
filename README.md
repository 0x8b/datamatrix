# Data Matrix

This is a software library that enables programs to write Data Matrix barcodes of the modern ECC200 variety.

## Installation

```exs
def deps do
  [
    {:data_matrix, "~> 0.1.0"}
  ]
end
```

## Example

```ex
data = "123456"

svg =
  data
  |> DataMatrix.encode()
  |> DataMatrix.format(:svg, color: "purple", background: "bisque", width: 200)

File.write!("square.svg", svg)
```

<img src="./docs/figures/example_square.svg" alt="Example square Data Matrix">

```ex
matrix = DataMatrix.encode("A1B2C3D4E5F6G7H8I9J0K1L2", quiet_zone: 2, type: :rectangle)

File.write("rectangular.svg", DataMatrix.format(matrix, :svg))
```

<img src="./docs/figures/example_rectangular.svg" alt="Example rectangular Data Matrix">

