# tmr-hardware-trojan-detection

This project implements and evaluates a **Triple Modular Redundancy (TMR)** system enhanced with a **temporal anomaly monitor** to detect stealthy hardware Trojans that bypass traditional majority voting.

Implementation is done at RTL level in Verilog and validated through simulation and waveform analysis.

---

## Motivation

Classic TMR systems assume that faults are:
- transient, or
- random, or
- isolated to a single replica

However, **stealth hardware Trojans** can violate these assumptions by:
- selectively corrupting outputs,
- activating only under specific conditions, or
- exploiting timing to evade instantaneous majority voting.

This project demonstrates how **temporal behavior analysis** can be used to detect such attacks even when the TMR voter output appears correct.

---

## High-Level Architecture

The design consists of:

- **Three redundant data paths** (`r_a`, `r_b`, `r_c`)
- **Bitwise majority voter** (`tmr_core.v`)
- **Trojan-injection logic** (in `tmr_trojan_top_mon.v`)
- **Temporal monitor** (`tmr_monitor.v`) that:
  - tracks mismatch history across cycles
  - raises suspicion only after persistent abnormal behavior

---

## Temporal Detection Principle

Instead of reacting to single-cycle mismatches, the monitor observes replica behavior across time:

1. Detects disagreements between redundant replicas
2. Accumulates mismatch history across cycles
3. Tracks consecutive mismatches via a streak counter
4. Raises suspicion only after persistent abnormal behavior

This allows detection of stealthy Trojans that intentionally evade instantaneous majority voting.

---

## File Overview

| File | Description |
|------|------------|
| `tmr_core.v` | Bitwise majority voter |
| `tmr_monitor.v` | Temporal anomaly monitor |
| `tmr_trojan_top_mon.v` | Top-level design with Trojan injection |
| `tmr_trojan_mon_tb.v` | Simulation testbench |
| `uart_tx_byte.v` | UART transmitter (auxiliary) |
| `uart_rx_byte.v` | UART receiver (auxiliary) |

Generated artifacts (bitstreams, waveforms, synthesis outputs) are intentionally excluded from version control.

---

## Simulation & Results

Simulation and waveform analysis confirm that:

- Majority voting output remains correct
- Individual replicas exhibit intermittent mismatches
- Temporal counters accumulate across cycles
- Suspicious behavior is flagged only after sustained anomalies

GTKWave traces demonstrate how temporal monitoring reveals attacks invisible to instantaneous logic.

---

## Toolchain

- Verilog HDL  
- Icarus Verilog  
- GTKWave  
- OSS CAD Suite  

---

## Key Takeaway

> **Temporal behavior reveals what instantaneous logic cannot.**

Enhancing TMR with lightweight temporal monitoring significantly improves resilience against stealth hardware Trojans.

