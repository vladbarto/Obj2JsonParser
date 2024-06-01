# Wavefront .obj to JSON Parser

## Overview

This project involves the development of a parser that reads a Wavefront (.obj) file and converts it into a JSON format. The parser specifically processes only the vertices and faces from the .obj file, ignoring other data such as textures and normals.

## Features

- **Extracts vertices and faces**: Parses only the lines starting with `v` (vertices) and `f` (faces).
- **Outputs JSON**: Converts the extracted vertices and faces into a JSON file format.
- **Ignores other data**: Efficiently ignores texture coordinates, vertex normals, and other irrelevant data in the .obj file.

## Getting Started

### Prerequisites

Ensure you have the following tools installed on your system:

- `flex`: Fast Lexical Analyzer Generator
- `bison`: GNU Parser Generator

### Installation

1. Clone the repository:

```sh
git clone https://github.com/your-username/obj-to-json-parser.git
cd obj-to-json-parser
```

2. Compile the lexer and parser:

```sh
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o obj_to_json_parser -lm
```

### Usage

1. Prepare your .obj file ensuring it contains only triangular faces.

2. Run the parser on your .obj file:

```sh
./obj_to_json_parser < input.obj > output.json
```

## File Descriptions

### `lexer.l`

This file contains the lexical analyzer written using Flex. It defines patterns to identify vertex (`v`), face (`f`), floating-point numbers, integers, and other tokens.

### `parser.y`

This file contains the parser written using Bison. It defines the grammar rules for parsing vertex and face lines, storing them in appropriate data structures, and producing the JSON output.

### `main.c`

The main C file that integrates the lexer and parser, processes the input .obj file, and generates the output JSON.

## Example

### Input (.obj) File

```
v 1.0 2.0 3.0
v 4.0 5.0 6.0
v 7.0 8.0 9.0
f 1/1/1 2/2/2 3/3/3
```

### Output (JSON) File

```json
{
	"vertices": [
		[1.000000, 2.000000, 3.000000],
		[4.000000, 5.000000, 6.000000],
		[7.000000, 8.000000, 9.000000]
	],
	"faces": [
		[0, 1, 2]
	]
}
```

## Troubleshooting

- **Lexical errors**: Ensure that the .obj file contains only valid lines starting with `v` or `f` for vertices and faces.
- **Compilation errors**: Make sure Flex and Bison are properly installed and in your system's PATH.

## Contributing

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch`.
3. Make your changes and commit them: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature-branch`.
5. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flex](https://github.com/westes/flex)
- [Bison](https://www.gnu.org/software/bison/)

For any further questions or issues, please open an issue in the repository or contact the maintainer at [your-email@example.com].
