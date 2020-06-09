# Fshuf

Shuffles files in a directory by adding, modifying, or removing a prefix.

### Usage:

`fshuf [mode] [format]`

mode:
 - `add` - Adds a prefix in order to shuffle files.
 - `mod` - Modifies an existing prefix in order to shuffle files.
 - `rem` - Removes an existing prefix.

format:
`d` | `b` | `B`, 1 or more times.
 - `d` - Inserts a random decimal value as part of the prefix.
 - `b` - Inserts a random binary value as part of the prefix.
 - `B` - Inserts a random base 64 value as part of the prefix.

### Examples:

- `fshuf add ddd` -- Adds a 3 character long prefix containing numbers 0-9 to every file in the current directory.
- `fshuf mod ddd` -- Modifies an existing 3 character long prefix containing numbers 0-9, replacing it with random characters 0-9 for every file in the current directory.
- `fshuf rem ddd` -- Removes a 3 character long prefix containing numbers 0-9 from every file in the current directory.
- `fshuf add dbB` -- Adds a 3 character long prefix containing a number 0-9, a 0 or 1, and a base 64 character to every file in the current directory.

### Building:
Building the "binary" simply requires the npm package "luamin" installed globally. Then run `make`.