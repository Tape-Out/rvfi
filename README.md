# rvfi

RISC-V Formal Interface record and harness for the cores in this library.

![maturity](https://img.shields.io/badge/maturity-simulated-yellow) ![license](https://img.shields.io/badge/license-Apache--2.0-blue)

Part of the [Tape-Out](https://github.com/Tape-Out) IP library: Bluespec IP over the
bus-neutral contracts in [`hwcore`](https://github.com/Tape-Out/hwcore), assembled by
[`xirang`](https://github.com/Tape-Out/xirang). Maturity runs `planned` -> `simulated` ->
`fpga-proven` -> `asic-ready` -> `silicon-proven`.

## Status

A core that supports formal verification drives one RVFI commit record per retired instruction, and [riscv-formal](https://github.com/YosysHQ/riscv-formal) checks the records against its instruction models and consistency properties. This package holds the parts every core shares:

| File | Language | Content |
| :-- | :-- | :-- |
| `hwsrc/Rvfi.bs` | Bluespec Haskell | The `Rvfi` record for NRET 1, XLEN 32, ILEN 32, with field names taken from `rvfi.rst`, and three constructors (`readRs`, `writeRd`, `access`) that enforce the zero rules of the interface, so a core never assembles fields by hand |
| `hwsrc/RvfiPins.bsv` | Bluespec SystemVerilog | `RvfiPins`, one `always_ready` method per signal with the exact `rvfi_*` port name, and `rvfiPins` to drive it from a record |
| `formal/run.sh` | shell | Runs riscv-formal on a core directory holding `wrapper.sv`, `checks.cfg` and the Verilog under test, with riscv-formal pinned at `c992aa61`, and lists the result of every check |

The ports are written one method each because the pinned bsc 2026.01 has no `SplitPorts`, so a struct cannot be split into named ports. A core puts the interface under `(* prefix = "" *)` to keep the names unprefixed.

The wrapper, the check list and the top under test live with each core, since the top instantiates the core and the core depends on this package. For [`hart`](https://github.com/Tape-Out/hart) they are in `hart/formal/`.

## Running

```sh
bsc -verilog -u -g mkRvOn -p <register block>:<hart>/bsv:<hwcore>/bsv:<rvfi>/bsv:+ <hart>/formal/Top.bsv
cp mkRvOn.v <hart>/formal/
formal/run.sh <hart>/formal            # all checks
formal/run.sh <hart>/formal reg_ch0    # one check
```

`sby`, `yosys-smtbmc` and the solver named in `checks.cfg` must be on `PATH`; [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) has all of them.

For `hart` in its RV32I machine-mode configuration all 45 checks pass: one per RV32I instruction at depth 20, `reg` at depth 15, `pc_fwd`, `pc_bwd`, `unique`, `causal`, `ill`, `liveness` and `hang`. Five checks in parallel took 37 minutes on a 12-core machine; the load and store instructions take the longest, up to 23 minutes each. The full run is not part of the organisation CI for that reason.

Seven mutations of the core each fail the check they were predicted to fail, while the checks they were predicted to pass stay green. Examples: comparing SLT as unsigned, a JAL target off by four, a register write that the commit record still claims, and a stuck `rvfi_order`.

## Specification sources

The specifications this package is implemented against, with their links, digests and the clause-by-clause comparison, are kept on the [`spec` branch](https://github.com/Tape-Out/rvfi/tree/spec).

## License

Apache License 2.0.
