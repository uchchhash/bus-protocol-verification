# 🧪 I2C Slave Verification Project

This repository contains the UVM-based verification environment for an I2C Slave IP core originally developed by Steve Fielding ([OpenCores I2C Slave](https://opencores.org/projects/i2c)).

---

## 📌 Project Overview

- **Project Name**: I2C Slave Verification (OpenCores)
- **IP Owner**: Steve Fielding (sfielding@base2designs.com)
- **Verification Engineer**: Uchchhash Sarkar (uchchhash.sarkar@ulkasemi.com)

---

## 📐 Specification Highlights

The I2C slave responds to transactions initiated by a master according to the I2C protocol, supporting both individual and successive register access.

### 🔹 Write to Individual Registers

- Master sends a START condition
- Slave address + Write bit
- Register address + Data byte
- STOP condition

### 🔹 Write to Successive Registers

- Similar to above, but followed by multiple DATA BYTEs
- Each data byte goes to incremented register address

### 🔹 Read from Registers

- START → Slave address + Write → Register address
- REPEATED START → Slave address + Read
- Slave drives register value(s)

---

## ✅ Test Plan Summary

| Sl No | Test Name              | Type | Purpose                                      | Notes |
|-------|------------------------|------|----------------------------------------------|-------|
| 1     | `i2c_slv_reset_test`   | TC   | Verify slave reset behavior                  | Assert reset, observe default outputs |
| 2     | `i2c_slv_indv_wr_test` | TC   | Write to individual registers                | Use single register write |
| 3     | `i2c_slv_seq_wr_test`  | TC   | Write to successive registers                | Auto-increment address |
| 4     | `i2c_slv_rd_test`      | TC   | Read register values                         | Verify response bytes |
| 5     | `i2c_addr_mismatch_test` | ABV | Ensure correct response to invalid address   | Check slave does not ACK |
| 6     | `i2c_wr_rd_mixed_test` | TC   | Mixed write-read transactions                | Complex sequence checking |
| 7     | `i2c_start_stop_test`  | ABV  | Check valid/invalid START/STOP combinations  | Protocol edge cases |
| ...   | ...                    | ...  | ...                                          | ... |

> Full testplan is available in the `docs/testplan.xlsx`.

---

## 📁 Directory Structure

```bash
i2c-slave-verification/
├── rtl/                      # I2C Slave RTL (if available)
├── tb/
│   ├── interfaces/           # I2C interface (signals + transactions)
│   ├── environment/          # env, config, scoreboard
│   ├── agents/               # I2C Master agent components
│   ├── sequences/            # Stimulus sequences
│   ├── tests/                # Testcases
│   └── tb_top.sv             # Top-level testbench
├── sim/
│   ├── run.sh                # Simulation script (VCS/ModelSim)
│   ├── filelist.f            # File list
│   └── *.svwf                # Optional waveform config
├── docs/
│   └── testplan.xlsx         # Detailed testplan
└── README.md
