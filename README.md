# FPGA-Based Digital System Design

This project implements a custom digital system on the Intel Altera DE2-115 FPGA board. The system is based on a custom ISA and is composed of a synchronous multi-cycle controller and a combinational datapath. It includes a PWM output unit and connects to board peripherals such as switches, LEDs, and 7-segment displays.

## Project Structure

- `DUT/` – RTL VHDL modules for the controller, datapath, and supporting logic  
- `TB/` – Testbenches for simulation of functional behavior  
- `SIM/` – Scripts and files for simulation setup and waveform analysis

## System Architecture

The digital system is divided into two main parts:

1. **Control Unit (FSM)** – Issues control signals across multiple clock cycles according to decoded instruction  
2. **Combinational Datapath** – Performs ALU operations, routing between registers and memory

Additional components include:
- Instruction Register
- Program Counter (PC)
- ALU
- Register File
- PWM Generator

## Features

- Execution of instructions over multiple clock cycles using a custom FSM-based controller  
- Support for a custom-defined instruction set architecture (ISA)  
- PWM signal generation based on control inputs  
- Full simulation support with waveform viewing in ModelSim  
- Synthesizable and deployable on the DE2-115 FPGA board

## FPGA I/O Mapping

- Input: Switches and Pushbuttons  
- Output: 7-segment display, LEDs, PWM (audio out)  
- Clock and Reset: Derived from board defaults  
- I/O mapping is described in the design specification PDF (see figures 2–6)

## How to Run

1. Compile all VHDL sources in `DUT/` using Quartus  
2. Use `TB/` to simulate behavior in ModelSim  
3. Load compiled design to DE2-115 via JTAG  
4. Use switches to control input and observe outputs on display and PWM

## Tools Used

- **Language**: VHDL  
- **Simulation**: ModelSim  
- **Synthesis**: Intel Quartus Prime  
- **Board**: DE2-115 FPGA Development Board

## Documentation

- [`FPGA based Digital Design.pdf`](FPGA%20based%20Digital%20Design.pdf) – full spec including architecture diagrams, ISA, and interface details

## Author

This project was developed as part of an academic lab in FPGA and digital system design.
