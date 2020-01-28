# Data Matrix

This is a software library that enables programs to **write** Data Matrix barcodes of the modern ECC200 variety.

References:

- ISO/IEC 16022:2006(E)

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
- [Encode options](#encode-options)
- [Rendering options](#rendering-options)
  - [SVG](#svg-options)
  - [Text](#text-options)
- [Table of maximum data capacity](#maximum-data-capacity)
- [Notes](#notes)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)

## Installation

The package can be installed by adding `data_matrix` to your list of dependencies in mix.exs:

```exs
def deps do
  [
    {:data_matrix, "~> 1.0.0"}
  ]
end
```

Don't forget to run `mix deps.get`

## Features

- rectangular symbols (this is optional according to ISO/IEC 16022:2006(E))
- default encoding scheme

## Usage

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
| --- | --: | --- |
| `quiet_zone` | `1` | All four sides of symbol are surrounded by quiet zone border. |
| `version` | auto | See [Maximum data capacity](#maximum-data-capacity). Version is selected automatically if not specified. |
| `shape` | `:square` | Shape of symbol. Available shapes are `:square` and `:rectangle`. |


## Rendering options

There are currently two formats available: `:svg` and `:text`.

### SVG options

| Option name | Default value | Description |
| --- | --- | --- |
| `width` | auto | Width in pixels (quiet zone included). |
| `height` | auto | Height in pixels (quiet zone included). |
| `viewbox` | `false` | Width and height are not included in SVG if `viewbox` is set to `true`. |
| `module_size` | `5` | Size of module. |
| `color` | `"black"` | Color of dark module. |
| `background` | `"white"` | Color of light module. |

### Text options

| Option name | Default value | Description |
| --- | --- | --- |
| `zero` | `"0"` | Representation of light module. |
| `one` | `"1"` | Representation of dark module. |
| `newline` | `"\n"` | String that is used to join modules in a row. |
| `separator` | `""` | String that is used to join rows. |


## Maximum data capacity

### Maximum data capacity for square symbols

| Version | Symbol size (without quiet zone) | Numeric | Alphanumeric<sup>a</sup> | Byte |
| --: | --: | --: | --: | --: |
| 0 | 10 | 6 | 3 | 1 |
| 1 | 12 | 10 | 6 | 3 |
| 2 | 14 | 16 | 10 | 6 |
| 3 | 16 | 24 | 16 | 10 |
| 4 | 18 | 36 | 25 | 16 |
| 5 | 20 | 44 | 31 | 20 |
| 6 | 22 | 60 | 43 | 28 |
| 7 | 24 | 72 | 52 | 34 |
| 8 | 26 | 88 | 64 | 42 |
| 9 | 32 | 124 | 91 | 60 |
| 10 | 36 | 172 | 127 | 84 |
| 11 | 40 | 228 | 169 | 112 |
| 12 | 44 | 288 | 214 | 142 |
| 13 | 48 | 348 | 259 | 172 |
| 14 | 52 | 408 | 304 | 202 |
| 15 | 64 | 560 | 418 | 277 |
| 16 | 72 | 736 | 550 | 365 |
| 17 | 80 | 912 | 682 | 453 |
| 18 | 88 | 1152 | 862 | 573 |
| 19 | 96 | 1392 | 1042 | 693 |
| 20 | 104 | 1632 | 1222 | 813 |
| 21 | 120 | 2100 | 1573 | 1047 |
| 22 | 132 | 2608 | 1954 | 1301 |
| 23 | 144 | 3116 | 2335 | 1555 |

### Maximum data capacity for rectangular symbols

| Version | Symbol size (without quiet zone) | Numeric | Alphanumeric<sup>a</sup> | Byte |
| --: | --: | --: | --: | --: |
| 24 | 8x18 | 10 | 6 | 3 |
| 25 | 8x32 | 20 | 13 | 8 |
| 26 | 12x26 | 32 | 22 | 14 |
| 27 | 12x36 | 44 | 31 | 20 |
| 28 | 16x36 | 64 | 46 | 30 |
| 29 | 16x48 | 98 | 72 | 47 |

---

<sup>a</sup>
> Based on text or C40 encoding without switching or  shifting; for other encoding schemes, this value may vary depending on the mix and grouping of character sets.
>
> <cite>ISO/IEC 16022:2006(E)</cite>

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