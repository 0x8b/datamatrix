# Data Matrix

This is a software library that enables programs to **write** Data Matrix barcodes of the modern ECC200 variety.

References:

- ISO/IEC 16022:2006(E)

## Table of Contents

- [Installation](#installation)
- [CLI](#cli)
- [Features](#features)
- [Examples](#examples)
- [Encode options](#encode-options)
- [Rendering options](#rendering-options)
  - [SVG](#svg-options)
  - [Text](#text-options)
- [Maximum data capacity](#maximum-data-capacity)
- [Notes](#notes)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)

## Installation

The package can be installed by adding `data_matrix` to your list of dependencies in mix.exs:

```exs
def deps do
  [
    {:data_matrix, "~> 0.1.2"}
  ]
end
```

To find out the latest release available on Hex, you can run `mix hex.info datamatrix` in your shell, or by going to the [datamatrix page on Hex.pm](https://hex.pm/packages/datamatrix)

Then, update your dependencies:

`$ mix deps.get`

## CLI

You can create Data Matrix symbols using the command line as follows:

1) Install `datamatrix` as an escript:

```console
mix escript.install github 0x8b/datamatrix
```

2) Then you are ready to use it:

```console
datamatrix -i "hello" -o "symbol.svg"
```

or 

```console
echo -n 123456 | datamatrix
```

For more details about using the command line tool, review the usage guide:

`datamatrix --help`

## Features

- rectangular symbols (this is optional according to ISO/IEC 16022:2006(E))
- default encoding scheme

## Examples

```ex
data = "A1B2C3D4E5F6G7H8I9J0K1L2"

matrix = DataMatrix.encode!(data, quiet_zone: 2, shape: :rectangle)

svg = DataMatrix.format(matrix, :svg, module_size: 8)

File.write("dm.svg", svg)
```

<img src="./docs/figures/example_rectangular.svg" alt="Example rectangular Data Matrix">

```ex
data = "123456"

svg =
  data
  |> DataMatrix.encode!()
  |> DataMatrix.format(:svg, color: "#6e4a7e", background: "aliceblue", width: 200)

File.write!("square.svg", svg)
```

<img src="./docs/figures/example_square.svg" alt="Example square Data Matrix">

## `DataMatrix.encode!` options

`ArgumentError` is thrown when the number of data codewords exceeds the symbol capacity.

| Option | Default value | Description |
| :-- | :-- | :-- |
| `quiet_zone` | `1` | All four sides of symbol are surrounded by quiet zone border. |
| `version` | auto | See [Maximum data capacity](#maximum-data-capacity). Version is selected automatically if not specified. |
| `shape` | `:square` | Shape of symbol. Available shapes are `:square` and `:rectangle`. |


## Rendering options

There are currently two formats available: `:svg` and `:text`.

### SVG options

| Option name | Default value | Description |
| :-- | :-- | :-- |
| `width` | auto | Width in pixels (quiet zone included). |
| `height` | auto | Height in pixels (quiet zone included). |
| `viewbox` | `false` | Width and height are not included in SVG if `viewbox` is set to `true`. |
| `module_size` | `5` | Size of module. |
| `color` | `"black"` | Color of dark module. |
| `background` | `"white"` | Color of light module. |

### Text options

| Option name | Default value | Description |
| :-- | :-- | :-- |
| `light` | `"0"` | Representation of light module. |
| `dark` | `"1"` | Representation of dark module. |
| `separator` | `""` | String that is used to join modules in a row. |
| `newline` | `"\n"` | String that is used to join rows. |

## Maximum data capacity

[See docs/maximum_data_capacity.md](docs/maximum_data_capacity.md)

## Notes

All additional features mentioned below will be provided in next major releases.

ECC 200 includes various **encodation schemes** which allow a defined set of characters to be converted  into codewords more efficiently than the default scheme.

**Extended  Channel  Interpretations** mechanism  enables characters from other character sets (e.g. Arabic, Cyrillic, Greek, Hebrew) and other data interpretations or industry-specific requirements to be represented.

**Structured append** allows files of data to be represented in up to 16 Data Matrix  symbols.  The  original  data  can  be  correctly  reconstructed  regardless  of  the  order  in  which  the  symbols are scanned.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to:
- update tests as appropriate
- run `mix format`

## Contact

If you want to contact me you can reach me at <mkgumienny@gmail.com>

## License

[MIT](LICENSE)