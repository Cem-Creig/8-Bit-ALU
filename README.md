# 8-bit ALU in Verilog

An 8-bit combinational arithmetic logic unit (ALU) written in Verilog and tested with Icarus Verilog. It takes two 8-bit inputs, `a` and `b`, and a 3-bit operation selector, `op`.

## Operations

| `op`  | Operation                  |
| ----- | -------------------------- |
| `000` | Add `a + b`                |
| `001` | Subtract `a - b`           |
| `010` | Bitwise AND                |
| `011` | Bitwise OR                 |
| `100` | Bitwise XOR                |
| `101` | Bitwise NOT of `a`         |
| `110` | Shift `a` left by one bit  |
| `111` | Shift `a` right by one bit |

The result is eight bits wide, so bits shifted out or produced beyond bit 7 are discarded. The `b` input is unused for NOT and shift operations.

## Flags

- `zero` is 1 when the result is zero.
- For addition, `carry` is the ninth bit of the sum.
- For subtraction, `carry` is 1 when no borrow is needed.
- `overflow` is 1 when a signed addition or subtraction result falls outside the 8-bit signed range of -128 to 127.

`carry` and `overflow` are 0 for the logic and shift operations.



## Run the tests

Install Icarus Verilog, then run these commands from the project folder:

```sh
iverilog -g2012 -Wall -s alu8_tb -o alu8_tb.vvp alu8.v alu8_tb.v
vvp alu8_tb.vvp
```

A successful run includes:

```text
ALL 17 TESTS PASSED
```

## Files

- `alu8.v` : ALU design
- `alu8_tb.v` : self-checking simulation testbench

