# RDRAMA
The RealDRAM assembler.

## Introduction
RDRAMA is an assembler for [the RealDRAM architecture](https://github.com/jlxip/RealDRAM), written in lex, yacc and C++.

Running `sudo make install` will install four programs into `/bin`:
- `rdrama-preprocessor`: parses and executes all preprocessor directives, and also removes comments.
- `rdrama-resolver`: creates a symbol table for all the declarations, such as `start:` and `br start`.
- `rdrama-assembler`: creates the final binary.
- `rdrama`: a script to run all the programs in order, this is what you should use.

My idea was to make this as similar as possible to NASM, which is an assembler I'm quite used to.

In this file, an address can be specified in decimal (`br 0`) or hex (`br 0xFE`).

## Instructions
| Mnemonic | First argument | Second argument | Third argument | Equivalent opcode | Description |
| --- | --- | --- | --- | --- | --- |
| `br` | addr | | | `00000000` | Conditional branch, jumps if the flag is up. |
| `ibr` | indirect addr | | | `01000000` | Indirect conditional branch. |
| `nand`, `nandd` | addr | | | `11100000` | NAND-BYTE-ITSELF-DIRECT |
| `nandi` | indirect addr | | | `11100011` | NAND-BYTE-ITSELF-INDIRECT |
| `nand`, `nanddd` | addr (orig) | addr (dest) | | `11000000` | NAND-BYTE-OTHER-DIRECT-DIRECT |
| `nandi` | indirect addr (orig) | indirect addr (dest) | | `11000011` | NAND-BYTE-OTHER-INDIRECT-INDIRECT |
| `nandid` | indirect addr (orig) | addr (dest) | | `11000010` | NAND-BYTE-OTHER-INDIRECT-DIRECT |
| `nanddi` | addr (orig) | indirect addr (dest) | | `11000001` | NAND-BYTE-OTHER-DIRECT-INDIRECT |
| `bnand`, `bnandd` | 0 <= bit <= 7 | addr | | `101xxx00` | NAND-BIT-ITSELF-DIRECT |
| `bnandi` | bit | indirect addr | | `101xxx11` | NAND-BIT-ITSELF-INDIRECT |
| `bnand`, `bnanddd` | bit | addr (orig) | addr (dest) | `100xxx00` | NAND-BIT-OTHER-DIRECT |
| `bnandi` | bit | indirect addr (orig) | indirect addr (dest) | `100xxx11` | NAND-BIT-OTHER-INDIRECT |
| `bnandid` | bit | indirect addr (orig) | addr (dest) | `100xxx10` | NAND-BIT-OTHER-INDIRECT-DIRECT |
| `bnanddi` | bit | addr (orig) | indirect addr (dest) | `100xxx01` | NAND-BIT-OTHER-DIRECT-INDIRECT |

## Declarations
A declaration is a tag linked to an address which can be used in any instruction as if it was a regular address.
```asm
br next
thing: nand 0xFFFD
next: nand thing
```

A declaration behaves like an address, and addresses can be added. For instance, `string_addr+1` will work.

## Literals
RDRAMA supports literal insertion. That is, raw bytes. There are two pseudoinstructions for this: `rawd` (raw data, bytes) and `rawa` (raw address).
```asm
ibr jump
jump: rawa 0xFFFF
```

## Comments
Comments are done with a semicolon, like in NASM.
```asm
bnand 0, 0xFFFD ; Read a character.
```
