# forth09

A FORTH-79-ish interpreter for OS-9, originally written by Dennis M. Weldy
(OS9ER) in 1987 (`FORTH09 v 01.00.00`). Original source recovered from the
[Color Computer Archive](https://colorcomputerarchive.com/search?q=forth).
This repo builds it two ways:

- **`unix/`** — a native build (plain `gcc`) for quick iteration and testing
  on macOS/Linux.
- **`coco/`** — the real target: cross-compiled with [CMOC](http://sarrazip.com/dev/cmoc.html)
  for OS-9 on a Tandy Color Computer 3, installed onto a bootable NitrOS-9
  disk image (`l2_coco3.dsk`).

## Building

```sh
make unix   # builds unix/forth09
make coco   # builds coco/forth09
```

`make -C coco install` copies the freshly-built binary onto `coco/l2_coco3.dsk`
(via the `os9` tool from [Toolshed](https://github.com/boisy/toolshed)), ready
to boot in an emulator (e.g. MAME) or on real hardware.

## Testing

`unix/test_forth09.sh` is a small assertion-based test suite covering
arithmetic, stack manipulation, comparisons, `DO`/`LOOP`, `IF`/`THEN`,
`BEGIN`/`UNTIL`/`WHILE`/`REPEAT`, colon definitions, and error handling.
Run it after `make unix`:

```sh
cd unix && ./test_forth09.sh
```

The same test cases, as plain FORTH source, live at `coco/forthtest.4th` on
the disk image itself — boot the disk and run:

```
forth09 <forthtest.4th
```

## Files

| Path | Purpose |
|---|---|
| `main.c`, `token.c`, `stack.c`, `dictiona.c`, `basic_fu.c` | Interpreter source, shared by both builds |
| `*.h` | Shared headers/type definitions |
| `unix/Makefile`, `coco/Makefile` | Per-target build rules |
| `coco/l2_coco3.dsk` | Bootable NitrOS-9 Level 2 disk image (CoCo 3) with `forth09` and the test suite installed |
