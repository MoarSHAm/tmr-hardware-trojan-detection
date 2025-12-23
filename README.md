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

