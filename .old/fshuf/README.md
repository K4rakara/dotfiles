## fshuf - **v2.0**

Applies, modifies, or removes prefixes on every file in the current directory in order to "shuffle" the directories contents.

**Usage:**

`fshuf COMMAND [ PREFIX ]`

where COMMAND := { add | rem | mod | help }
	- add\u{000d}<forward 25>: Adds a prefix to every file in the current directory.
	- rem\u{000d}<forward 25>: Removes a prefix from every file in the current directory.
	- mod\u{000d}<forward 25>: Modifies a prefix on every file in the current directory.
	- help\u{000d}<forward 25>: Displays this menu.

where PREFIX ::= d | b | B
	- d\u{000d}<forward 25>: Use a decimal number in the randomly generated prefixes.
	- b\u{000d}<forward 25>: Use a binary number in the randomly generated prefixes.
	- B\u{000d}<forward 25>: Use a base64 number in the randomly generated prefixes.

**Example:**

`fshuf add bdB`
