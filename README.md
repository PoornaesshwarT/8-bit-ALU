<div align="center">

# 8-bit Arithmetic Logic Unit (ALU) — Verilog HDL

A synthesizable 8-bit ALU implemented in Verilog HDL, verified through randomized functional simulation in Xilinx Vivado, and targeted for deployment on an Artix-7 FPGA.

[![HDL](https://img.shields.io/badge/HDL-Verilog-blue)](#tools--technologies)
[![Simulator](https://img.shields.io/badge/Simulator-Xilinx%20Vivado-orange)](#tools--technologies)
[![FPGA](https://img.shields.io/badge/FPGA-Artix--7-green)](#fpga-implementation)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Supported Operations](#supported-operations)
- [Status Flags](#status-flags)
- [Repository Structure](#repository-structure)
- [RTL Design](#rtl-design)
- [Verification Methodology](#verification-methodology)
- [Simulation Results](#simulation-results)
- [RTL Schematic](#rtl-schematic)
- [FPGA Implementation](#fpga-implementation)
- [Tools & Technologies](#tools--technologies)
- [Getting Started](#getting-started)
- [Roadmap](#roadmap)
- [Learning Outcomes](#learning-outcomes)
- [Author](#author)
- [License](#license)

---

## Overview

This project implements an **8-bit Arithmetic Logic Unit (ALU)** at the Register Transfer Level (RTL), capable of performing eight arithmetic, logical, and shift operations selected via a 3-bit opcode. The design generates four standard status flags — **Zero, Carry, Overflow, and Negative** — commonly used in processor datapaths for conditional branching and arithmetic validation.

The ALU was functionally verified using a self-contained Verilog testbench executing **100 randomized test cases**, and is structured for straightforward synthesis and deployment on Artix-7 based FPGA boards such as the Nexys 4 DDR.

## Features

- 8-bit wide operands (`A`, `B`) with 3-bit opcode-based operation selection
- Combinational RTL design using a single `always @(*)` block
- Four arithmetic operations: addition, subtraction
- Three logical operations: AND, OR, XOR, plus bitwise NOT
- Two shift operations: logical left shift, logical right shift
- Full status flag generation: Zero (Z), Carry (C), Overflow (V), Negative (N)
- Randomized, repeatable functional verification via testbench
- Verified in Xilinx Vivado behavioral simulation
- Ready for synthesis and FPGA implementation on Artix-7 devices

## Architecture

```text
                  ┌──────────────────────┐
                  │                      │
     A[7:0] ─────►│                      │
                  │                      │────► Y[7:0]
     B[7:0] ─────►│       8-bit ALU      │
                  │                      │────► Z
 Opcode[2:0] ────►│                      │────► C
                  │                      │────► V
                  │                      │────► N
                  └──────────────────────┘
```

**Ports**

| Signal        | Direction | Width | Description                    |
| ------------- | :-------: | :---: | ------------------------------- |
| `A`           | Input     | 8     | First operand                  |
| `B`           | Input     | 8     | Second operand                 |
| `opcode`      | Input     | 3     | Operation select                |
| `Y`           | Output    | 8     | ALU result                     |
| `Z`           | Output    | 1     | Zero flag                       |
| `C`           | Output    | 1     | Carry flag                      |
| `V`           | Output    | 1     | Overflow flag                   |
| `N`           | Output    | 1     | Negative flag                   |

## Supported Operations

| Opcode | Operation   | Function |
| :----: | ----------- | :------: |
| `000`  | Addition    | `A + B`  |
| `001`  | Subtraction | `A - B`  |
| `010`  | AND         | `A & B`  |
| `011`  | OR          | `A \| B` |
| `100`  | XOR         | `A ^ B`  |
| `101`  | NOT         | `~A`     |
| `110`  | Left Shift  | `A << 1` |
| `111`  | Right Shift | `A >> 1` |

## Status Flags

| Flag | Name     | Description                                               |
| :--: | -------- | ----------------------------------------------------------- |
| **Z** | Zero     | Set when the ALU result equals zero                         |
| **C** | Carry    | Indicates carry-out (arithmetic) or shifted-out bit (shift) |
| **V** | Overflow | Indicates signed arithmetic overflow                        |
| **N** | Negative | Reflects the sign bit (MSB) of the result                   |

## Repository Structure

```text
8-bit-ALU-Verilog/
│
├── README.md
├── LICENSE
│
├── RTL/
│   └── alu_8.v                    # ALU design source
│
├── Testbench/
│   └── alu_8_tb.v                 # Randomized verification testbench
│
├── Simulation/
│   └── waveform.png               # Vivado simulation waveform
│
├── Implementation/
│   ├── rtl_schematic.png          # Synthesized RTL schematic
│   └── fpga_implementation.png    # FPGA implementation / board image
│
└── Constraints/
    └── nexys4_ddr.xdc             # Physical/timing constraints (Nexys 4 DDR)
```

## RTL Design

The ALU is implemented as a purely combinational block using `always @(*)`, with the operation selected by the 3-bit `opcode` input.

For arithmetic operations, a 9-bit temporary register captures the carry-out bit:

```verilog
reg [8:0] temp;
```

The 8 least-significant bits of `temp` form the result `Y`, while bit 8 provides the carry flag for addition and subtraction. Logical and shift operations bypass the extended register and drive `Y` directly, with `C` defined by the bit shifted out where applicable. `Z`, `V`, and `N` are derived combinationally from the final result and operand values on every operation.

## Verification Methodology

The design is verified using a self-checking-ready Verilog testbench that:

1. Initializes and drives the ALU's input ports.
2. Generates **100 randomized test vectors** using `$random`.
3. Randomizes both 8-bit operands (`A`, `B`) independently.
4. Randomizes the 3-bit `opcode` across all eight operations.
5. Applies a 10 ns delay between successive test cases.
6. Captures and observes `Y`, `Z`, `C`, `V`, and `N` for each vector.

```verilog
A = $random;
B = $random;
opcode = $random & 3'b111;
```

This approach exercises a broad and unbiased set of operand/opcode combinations, increasing confidence in RTL correctness ahead of synthesis.

## Simulation Results

Functional simulation was performed in **Xilinx Vivado** using behavioral simulation.

![Simulation Waveform](Simulation/waveform.png)

> Place your captured waveform at `Simulation/waveform.png` to have it render above.

## RTL Schematic

The Vivado-generated RTL schematic below illustrates the synthesized structure of the design.

![RTL Schematic](Implementation/rtl_schematic.png)

> Place your schematic capture at `Implementation/rtl_schematic.png` to have it render above.

## FPGA Implementation

The ALU targets an **Artix-7** FPGA, validated on the **Nexys 4 DDR** development board.

![FPGA Implementation](Implementation/fpga_implementation.png)

> Place your implementation/board photo at `Implementation/fpga_implementation.png` to have it render above.

## Tools & Technologies

| Category        | Details              |
| ---------------- | --------------------- |
| HDL               | Verilog                |
| Design Level      | RTL (Register Transfer Level) |
| Simulation Tool   | Xilinx Vivado          |
| Target FPGA       | Artix-7                |
| Development Board | Nexys 4 DDR             |
| Verification      | Verilog testbench, randomized stimulus |

## Getting Started

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (Design Suite, any recent version)
- A Nexys 4 DDR board (or other Artix-7 target), if pursuing FPGA implementation

### 1. Clone the Repository

```bash
git clone <your-github-repository-link>
cd 8-bit-ALU-Verilog
```

### 2. Create a Vivado Project

Open Vivado and create a new RTL project targeting the required Artix-7 device (e.g., `xc7a100tcsg324-1` for the Nexys 4 DDR).

### 3. Add Design Sources

Add the ALU design file:

```text
RTL/alu_8.v
```

### 4. Add Simulation Sources

Add the testbench:

```text
Testbench/alu_8_tb.v
```

### 5. Run Behavioral Simulation

In Vivado:

```text
Flow Navigator → Simulation → Run Behavioral Simulation
```

Inspect `Y`, `Z`, `C`, `V`, and `N` in the waveform viewer against expected values for each randomized test case.

### 6. Synthesize and Implement on FPGA (Optional)

If targeting hardware, add the constraints file:

```text
Constraints/nexys4_ddr.xdc
```

Then run the standard implementation flow:

```text
Synthesis → Implementation → Generate Bitstream → Program Device
```

## Roadmap

- [ ] Add a self-checking testbench with automated pass/fail reporting
- [ ] Add SystemVerilog Assertions (SVA) for property-based verification
- [ ] Extend the design to 16-bit and 32-bit variants
- [ ] Add multiplication and division operations
- [ ] Interface the ALU with onboard switches and 7-segment displays
- [ ] Build a UVM or SystemVerilog-based verification environment

## Learning Outcomes

This project provided hands-on experience with:

- Verilog HDL and RTL design methodology
- Combinational logic implementation
- Arithmetic and logical operation design
- Status/condition flag generation
- Randomized testbench development
- Functional simulation in Xilinx Vivado
- FPGA synthesis and implementation flow

## Author

**Poornaesshwar T**
Electronics Engineering — VLSI Design and Technology
RMK College of Engineering and Technology

## License

This project is licensed under the terms described in [LICENSE](LICENSE).

---

<div align="center">

If you found this project useful, consider giving the repository a ⭐.

</div># 8-bit-ALU
