# Async FIFO Verification – UVM & SystemVerilog

## 📌 Project Overview

This project focuses on the **functional verification** of an **Asynchronous FIFO** (First-In-First-Out) buffer using **SystemVerilog** and **UVM** (Universal Verification Methodology).

The FIFO design under test (DUT) implements a production-grade asynchronous FIFO architecture, including:
- Clock-domain crossing (CDC) logic
- Gray-code pointer synchronization
- Programmable status flags

**Goal:** Verify correctness, robustness, and corner-case behavior of the FIFO across independent read and write clock domains using simulation-based verification.

> ⚠️ **Note:** Formal verification is intentionally excluded from this project. All verification is performed using UVM + SystemVerilog simulation.

---

## 🎯 Verification Objectives

The primary objectives of this verification project are:

1. **Validate correct FIFO behavior** across asynchronous clock domains
2. **Ensure data integrity** from write to read operations
3. **Verify status flags** (full, empty, almost_full, almost_empty)
4. **Stress-test FIFO** under randomized traffic and clock ratios
5. **Detect protocol violations** (overflow, underflow)
6. **Build a scalable, reusable** UVM verification environment

---

## 🧩 Design Under Test (DUT)

### FIFO Characteristics

- **Asynchronous FIFO** with separate read/write clocks
- **Gray-coded pointer synchronization** for CDC safety
- **Parameterized design:**
  - Configurable data width
  - Configurable FIFO depth
  - Configurable synchronization stages

### Status Signals
- `full` – FIFO is full
- `empty` – FIFO is empty
- `almost_full` – FIFO approaching full capacity
- `almost_empty` – FIFO approaching empty state

### Error Indicators
- `overflow` – Write attempted when FIFO is full
- `underflow` – Read attempted when FIFO is empty
- `parity_error` – Optional parity checking (if enabled)

> The RTL is treated as a **black box** for verification purposes.

---

## 🛠 Verification Methodology

This project uses **UVM (IEEE 1800.2)** for verification, following standard best practices.

### Key Techniques Used

- **Transaction-based verification**
- **Constrained random stimulus**
- **Scoreboarding** for data integrity checking
- **Functional coverage** collection
- **SystemVerilog Assertions (SVA)** at interface level
- **Clock-domain–aware** stimulus sequencing

---

## 🧱 Verification Architecture

```
+-----------------------------+
|        UVM Testbench        |
+-----------------------------+
|                             |
|  +-----------------------+  |
|  |        Test           |  |
|  +-----------------------+  |
|            |                |
|  +-----------------------+  |
|  |     Virtual Seq       |  |
|  +-----------------------+  |
|      |           |          |
| +---------+ +---------+     |
| | WR Agent| | RD Agent|     |
| +---------+ +---------+     |
|      |           |          |
| +--------------------------------+
| |        Async FIFO DUT          |
| +--------------------------------+
|              |                  |
|         +------------+          |
|         | Scoreboard |          |
|         +------------+          |
|              |                  |
|        +----------------+       |
|        | Coverage Model |       |
|        +----------------+       |
+---------------------------------+
```

### Component Description

- **Test Layer:** Configures and initiates test scenarios
- **Virtual Sequencer:** Coordinates write and read sequences
- **Write Agent:** Drives write-side transactions
- **Read Agent:** Monitors read-side transactions
- **Scoreboard:** Validates data integrity and ordering
- **Coverage Model:** Tracks functional coverage metrics

---

## 🧪 Test Scenarios

### Directed Tests

- Basic write → read sequence
- FIFO full condition
- FIFO empty condition
- Reset during operation
- Back-to-back writes and reads

### Constrained Random Tests

- Random write/read enables
- Random data patterns
- Random clock frequencies and phase offsets
- Random burst sizes
- Simultaneous read/write operations

### Corner & Stress Cases

- Write when FIFO is full (overflow detection)
- Read when FIFO is empty (underflow detection)
- Long-duration random traffic
- Fast write / slow read scenarios
- Slow write / fast read scenarios

---

## 📊 Coverage Strategy

### Functional Coverage

- FIFO occupancy levels (0%, 25%, 50%, 75%, 100%)
- Full and empty transitions
- Almost-full and almost-empty thresholds
- Reset interactions
- Overflow and underflow events

### Coverage Goals

- ✅ 100% functional coverage on defined covergroups
- ✅ All FIFO state transitions exercised
- ✅ All status flag combinations observed

---

## 🔍 Scoreboarding

The scoreboard performs:

- **Reference model maintenance** using a queue
- **Output comparison** between DUT and expected values
- **Data ordering verification**
- **Error detection** for mismatches, underflows, and overflows

---

## ⏱ Clocking Strategy

- **Independent write and read clocks**
- **Programmable clock ratios** (e.g., 1:1, 2:1, 5:3)
- **Randomized clock jitter** (optional)
- **Asynchronous reset** per clock domain

---

## 🚀 How to Run

### Requirements

- SystemVerilog simulator supporting UVM:
  - Questa Sim
  - Synopsys VCS
  - Cadence Xcelium
- UVM 1.2 or IEEE 1800.2 compliant library

### Example Simulation Flow

```bash
# Compile RTL and testbench
vlog -sv rtl/*.sv tb/*.sv

# Run simulation
vsim -c top_tb -do "run -all; quit"
```

> **Note:** Commands may vary depending on your simulator.

---

## 📁 Project Structure

```
async_fifo_verification/
├── rtl/
│   └── async_fifo.sv              # DUT RTL
├── tb/
│   ├── interfaces/                # Interface definitions
│   ├── agents/                    # UVM agents
│   ├── sequences/                 # Test sequences
│   ├── env/                       # UVM environment
│   ├── scoreboard/                # Reference model & checker
│   ├── coverage/                  # Functional coverage
│   └── tests/                     # Test cases
├── sim/
│   └── run_scripts/               # Simulation scripts
├── docs/
│   └── waveforms/                 # Captured waveforms
└── README.md                      # This file
```

---

## 🧠 Key Learnings

- Verifying **CDC-based designs** requires careful stimulus coordination
- **Scoreboards are critical** for async data validation
- **Randomized clocks** expose bugs not found in directed tests
- **UVM enables scalable** and reusable verification environments
- **Gray-code synchronization** is essential for safe pointer crossing

---

## 🔮 Future Enhancements

- [ ] Add performance metrics (throughput / latency tracking)
- [ ] Introduce power-aware verification scenarios
- [ ] Extend to AXI-Stream FIFO wrapper verification
- [ ] Add regression automation scripts
- [ ] Parameter sweep testing across multiple FIFO configurations
- [ ] Integrate with CI/CD pipeline

---

## 👤 Author

**Verification Engineer:** [Your Name]  
**RTL Source:** Generated by ChatGPT (OpenAI)  
**Verification Methodology:** SystemVerilog + UVM

---

## 📜 License

This project is intended for **educational and demonstration purposes**.  
Feel free to use, modify, and extend with attribution.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check the [issues page](../../issues).

---

## ⭐ Show Your Support

Give a ⭐️ if this project helped you learn UVM or async FIFO verification!