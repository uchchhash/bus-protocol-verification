# Bus Protocol Verification (Private Repository)
Functional Verification of AMBA APB, AHB, AXI Slave, I2C Slave, and SPI Controller

This repository contains the full SystemVerilog/UVM-based functional verification environments developed for standard bus protocol controllers. It includes reusable agent-based architectures, constrained-random testing, assertions, and coverage models.

> **Note:** This is a private repository containing internal verification work. Redistribution or reuse of the contents is strictly prohibited.

---

## 📁 Directory Structure

```
bus-protocol-verification/
│
├── apb/
│   ├── doc/
│   ├── rtl/
│   ├── tb/
│   │   ├── agent/
│   │   ├── environment/
│   │   ├── sequence_library/
│   │   ├── test/
│   │   └── top/
│   ├── sim/
│   └── defines/
│
├── ahb/
│   ├── doc/
│   ├── rtl/
│   ├── tb/
│   │   ├── agent/
│   │   ├── environment/
│   │   ├── sequence_library/
│   │   ├── test/
│   │   └── top/
│   ├── sim/
│   └── defines/
│
├── axi/
│   ├── doc/
│   ├── rtl/
│   ├── tb/
│   │   ├── agent/
│   │   ├── environment/
│   │   ├── sequence_library/
│   │   ├── test/
│   │   └── top/
│   ├── sim/
│   └── defines/
│
├── spi/
│   ├── doc/
│   ├── rtl/
│   ├── tb/
│   │   ├── apb_agent/
│   │   ├── spi_agent/
│   │   ├── environment/
│   │   ├── sequence_library/
│   │   ├── register_model/
│   │   ├── test/
│   │   └── top/
│   ├── sim/
│   └── defines/
│
├── i2c/
│   ├── doc/
│   ├── rtl/
│   ├── tb/
│   │   ├── agent/
│   │   ├── environment/
│   │   ├── sequence_library/
│   │   ├── test/
│   │   └── top/
│   ├── sim/
│   └── defines/
```

## 🧪 Key Features

- **Modular Testbench Architecture**: Protocol-specific agents and environments for better reuse.
- **UVM Methodology**: Factory override, config DB, RAL integration.
- **Constraint-Random Testing**: Extensive scenario coverage including corner cases.
- **Assertion-Based Verification (ABV)**: SystemVerilog assertions for sequence checking.
- **Coverage-Driven Verification**: Functional and code coverage models to ensure plan-to-coverage closure.
- **Bash Scripting**: Regression automation and batch simulation setup.

---

## 🛠️ Tools & Technologies

- **Hardware Languages**: Verilog, SystemVerilog, SV-Assertions, UVM  
- **EDA Tools**: Cadence (Xcelium, Virtuoso, IMC, vManager) 
- **Waveform/Debug**: SimVision  

---

## 👤 Author

**Uchchhash Sarkar**  
Design Verification Engineer  
📧 [uchchhash.sarkar@gmail.com](mailto:uchchhash.sarkar@gmail.com)

---

## 🔒 Confidential Notice

This project is protected. Sharing, modifying, or reproducing any part of it is not permitted without prior written consent.
