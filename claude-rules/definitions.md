# Definitions (`definitions/*.jsonc`)

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

The `definitions/` dir holds three data files that tell Apio which boards, programmers and FPGAs exist. They are JSON with comments (`.jsonc`). Each file is one JSON object whose keys are IDs, such as a board ID or a programmer ID.

| File | Defines | Referenced by |
|---|---|---|
| `boards.jsonc` | The boards Apio supports | `board =` in each example's `apio.ini` |
| `programmers.jsonc` | The commands that upload a bitstream to a board | the `programmer` field of each board |
| `fpgas.jsonc` | Overrides of the FPGA definitions | the `fpga-id` field of each board |

## Boards (`boards.jsonc`)

Each entry describes one board. For example:

```jsonc
// https://github.com/FPGAwars/Alhambra-II-FPGA
"alhambra-ii": {
  "description": "Alhambra II",
  "fpga-id": "ice40hx4k-tq144-8k",
  "programmer": {
    "id": "openfpgaloader",
    "extra-args": "-b ice40_generic --vid ${VID} --pid ${PID} --busdev-num ${BUS}:${DEV}"
  },
  "usb": {
    "vid": "0403",
    "pid": "6010",
    "product-regex": "^Alhambra II.*"
  }
}
```

The fields:

| Field | Required | Meaning |
|---|---|---|
| key (`alhambra-ii`) | yes | The board ID. Lowercase letters, digits and `-`. It is also the board's dir name under `examples/` and the value of `board =` in `apio.ini`. |
| `description` | yes | The board's name as people know it. |
| `fpga-id` | yes | The FPGA on the board, as an FPGA ID (see "FPGAs" below). |
| `programmer.id` | yes | Which entry of `programmers.jsonc` uploads to this board. |
| `programmer.extra-args` | no | Arguments added after the programmer's own arguments, for options that are specific to this board. |
| `usb.vid`, `usb.pid` | no | The USB vendor and product IDs (hex, without `0x`), used to find the board when it's plugged in. |
| `usb.product-regex` | no | A Python regex matched against the USB product string, as shown by `apio devices usb`. Use it to tell apart boards that share a VID and PID. Start it with `^` to match from the beginning of the string. |
| `tinyprog.name-regex` | no | For boards programmed with `tinyprog`: a regex matched against the name the board reports. |

**Board link:** put a comment with a link to the board above each entry, on the line right before the board ID (`// https://...`).

- **Which page:** the one with the most technical information: the maker's hardware repo, wiki or documentation page with the schematic, pinout and constraint files. Use a store or product page only when nothing more technical exists.
- **One page per board:** boards that are the same hardware with a different programmer or FPGA size (e.g. the `-ft232h` and `-usb-blaster` variants) share the same link. When a page covers several boards, link to the part for this board if there is one (e.g. a folder or page for that version).
- **Check it:** open the link and make sure it loads and is about this board.
- **No page found:** write `// TODO: Add a link to the board's home page.` instead. Replace it when a page turns up.

## Programmers (`programmers.jsonc`)

Each entry is a command line for uploading a bitstream. For example:

```jsonc
"iceprog": {
  "command": "iceprog",
  "args": "-d d:${BUS}/${DEV}"
}
```

Apio builds the full command from the programmer and the board:

```
<command> <programmer args> <board extra-args>
```

Apio replaces these placeholders when it runs the command:

| Placeholder | Replaced with |
|---|---|
| `${VID}`, `${PID}` | The board's USB vendor and product IDs |
| `${BUS}`, `${DEV}` | The board's USB bus number and device address |
| `${SERIAL_PORT}` | The board's serial port |
| `${BIN_FILE}` | The path to the bitstream file |

A command can use the USB placeholders or `${SERIAL_PORT}`, but not both. If `${BIN_FILE}` doesn't appear in the command, Apio adds the bitstream path at the end.

## FPGAs (`fpgas.jsonc`)

The main FPGA definitions are not in this repo. They are generated automatically elsewhere. `fpgas.jsonc` is only an **override** file: an entry here replaces or adds to the generated definition with the same ID. Add an entry only when a generated definition is wrong or missing.

Today the file holds no active entries, only commented-out templates, one per FPGA family (`ice40`, `ecp5`, `gowin`, `xilinx`). Copy the matching template when you need an override. For example:

```jsonc
"lfe5u-12f-6bg256c": {
  "arch": "ecp5",
  "vendor-part": "LFE5U-12F-6BG256C",
  "size": "12k",
  "ecp5-params": {
    "nextpnr-type": "12k",
    "nextpnr-package": "CABGA256",
    "nextpnr-speed": "6"
  }
}
```

- **Key (FPGA ID):** the vendor part number in lowercase, keeping only letters and digits. It may end with a variant suffix, such as `-8k` for a 4k part that is used as an 8k part (`ice40hx4k-tq144-8k`).
- **Values:** follow the `FpgaDefinition` protocol buffer in Apio's `apio-definitions.proto`.

## Testing definition changes

By default, Apio reads the three definition files from the installed `definitions` package, not from this repo. The env var `APIO_DEFINITIONS` makes Apio read them from another dir instead.

- **`invoke test`** sets `APIO_DEFINITIONS` to this repo's `definitions/` dir, so it always tests the examples against the definitions in this repo.
- **Running `test_examples.py` or `apio` directly** uses the installed package's definitions, unless you set the env var yourself, e.g. `APIO_DEFINITIONS=$PWD/definitions python scripts/test_examples.py`.
- **CI** (`test.yaml`) still copies `definitions/*` into the installed package's `definitions` dir before testing. To find that dir, run `apio api get-system` and look for the key `apio-packages-dir`.

`APIO_DEFINITIONS` affects only `boards.jsonc`, `fpgas.jsonc` and `programmers.jsonc`. Other content of the definitions package, such as the examples used by `apio examples`, still comes from the installed package. It needs an Apio version that supports the env var.
