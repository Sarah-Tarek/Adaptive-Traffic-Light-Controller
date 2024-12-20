# **Adaptive Traffic Light Controller**

An adaptive traffic light controller designed to dynamically manage traffic flow at a four-way intersection. The system prioritizes heavily congested lanes and ensures smooth, collision-free transitions between traffic lights.

---

## **Table of Contents**

1. [Introduction](#introduction)  
2. [Scenario Walkthrough](#scenario-walkthrough)  
   - [Scenario Setup](#scenario-setup)  
   - [Step-by-Step Trace](#step-by-step-trace)  
   - [Summary of Key Signals](#summary-of-key-signals)  
3. [Sensor Input Handler Explained](#sensor-input-handler-explained)  
   - [Module Components](#module-components)  
   - [How It Works](#how-it-works)  
   - [Numerical Example](#numerical-example)  
   - [Step-by-Step Explanation](#step-by-step-explanation)  
   - [Why This Design Works](#why-this-design-works)  
   - [When to Use](#when-to-use)

---

## **Introduction**

The Adaptive Traffic Light Controller is designed to optimize traffic flow at a four-way intersection. It dynamically adjusts green light durations based on lane congestion and ensures smooth transitions between lanes using a robust FSM and debouncing mechanisms for 8 sensors.

---

## **Scenario Walkthrough**

Let’s walk through the **`adaptive_traffic_light_controller`** module step-by-step, with a **trace of signals and behavior** based on a real-world scenario.

---

### **Scenario Setup**

We’ll assume the following:

1. **Initial State**: The system starts with `NS1_GREEN` (North-South Lane 1 green light).
2. **Sensor Inputs**:
   - `raw_s1[0]` (car at NS1 start): Active.
   - `raw_s5[0]` (congestion at NS1): Inactive.
   - All other sensors: Inactive.
3. **FSM Behavior**:
   - State transitions follow the sequence:  
     `NS1_GREEN → NS1_YELLOW → NS2_GREEN → NS2_YELLOW → EW1_GREEN → EW1_YELLOW → EW2_GREEN → EW2_YELLOW`.
   - Congestion (`raw_s5`) may extend green light durations.
4. **Timer Durations**:
   - Default green: 20 clock cycles.
   - Yellow: 5 clock cycles.
   - Extended green: 30 clock cycles (if congestion is detected).

---

### **Step-by-Step Trace**

#### **1. Initialization**

- **Reset (`rst = 1`)**:
  - All modules reset their internal states.
  - FSM starts at `NS1_GREEN` (`light_signal = 4'b0001`).
  - Timer is idle (`start_timer = 0`, `yellow_mode = 0`).

#### **2. FSM in `NS1_GREEN`**

- **Inputs**:
  - `raw_s1[0] = 1` (car detected at NS1 start).
  - `raw_s5[0] = 0` (no congestion at NS1).
  - `light_signal = 4'b0001` (`NS1_GREEN`).

- **Timer**:
  - `yellow_mode = 0` (not a yellow state).
  - `extend_timer = 0` (no congestion detected).
  - `start_timer = 1` (green light duration starts).
  - Timer counts 20 clock cycles.

- **Traffic Lights**:
  - `NS1_light = GREEN`.
  - `NS2_light, EW1_light, EW2_light = RED`.

#### **3. Timer Expiration in `NS1_GREEN`**

- After 20 clock cycles, `timer_expired = 1`.

- **FSM Transition**:
  - FSM moves from `NS1_GREEN` → `NS1_YELLOW`.
  - `light_signal = 4'b0010`.

- **Traffic Lights**:
  - `NS1_light = YELLOW`.
  - All other lights remain RED.

- **Timer**:
  - `yellow_mode = 1` (yellow light duration).
  - Timer starts for 5 clock cycles.

#### **4. Timer Expiration in `NS1_YELLOW`**

- After 5 clock cycles, `timer_expired = 1`.

- **FSM Transition**:
  - FSM moves from `NS1_YELLOW` → `NS2_GREEN`.
  - `light_signal = 4'b0011`.

- **Traffic Lights**:
  - `NS2_light = GREEN`.
  - `NS1_light, EW1_light, EW2_light = RED`.

- **Timer**:
  - `yellow_mode = 0` (back to green mode).
  - `start_timer = 1`.
  - Timer starts for 20 clock cycles.

#### **5. Congestion in `NS2_GREEN`**

- During `NS2_GREEN`:
  - `raw_s1[1] = 1` (car detected at NS2 start).
  - `raw_s5[1] = 1` (congestion detected at NS2).

- **FSM**:
  - `light_signal = 4'b0011` (`NS2_GREEN`).

- **Timer**:
  - `yellow_mode = 0`.
  - `extend_timer = 1` (congestion detected).
  - Timer runs for 30 clock cycles instead of 20.

#### **6. Timer Expiration in `NS2_GREEN`**

- After 30 clock cycles, `timer_expired = 1`.

- **FSM Transition**:
  - FSM moves from `NS2_GREEN` → `NS2_YELLOW`.
  - `light_signal = 4'b0100`.

- **Traffic Lights**:
  - `NS2_light = YELLOW`.
  - All other lights remain RED.

- **Timer**:
  - `yellow_mode = 1`.
  - Timer starts for 5 clock cycles.

#### **7. Timer Expiration in `NS2_YELLOW`**

- After 5 clock cycles, `timer_expired = 1`.

- **FSM Transition**:
  - FSM moves from `NS2_YELLOW` → `EW1_GREEN`.
  - `light_signal = 4'b0101`.

- **Traffic Lights**:
  - `EW1_light = GREEN`.
  - `NS1_light, NS2_light, EW2_light = RED`.

- **Timer**:
  - `yellow_mode = 0`.
  - Timer starts for 20 clock cycles.

---

### **Summary of Key Signals**

| **State**       | **light_signal** | **Traffic Lights**          | **Timer Mode**     | **Duration** |
|------------------|------------------|-----------------------------|--------------------|--------------|
| `NS1_GREEN`      | `4'b0001`        | NS1: GREEN, Others: RED     | Green (default)    | 20 cycles    |
| `NS1_YELLOW`     | `4'b0010`        | NS1: YELLOW, Others: RED    | Yellow             | 5 cycles     |
| `NS2_GREEN`      | `4'b0011`        | NS2: GREEN, Others: RED     | Green (extended)   | 30 cycles    |
| `NS2_YELLOW`     | `4'b0100`        | NS2: YELLOW, Others: RED    | Yellow             | 5 cycles     |
| `EW1_GREEN`      | `4'b0101`        | EW1: GREEN, Others: RED     | Green (default)    | 20 cycles    |

---

### **Sensor Input Handler Explained**

The **`sensor_input_handler`** module is responsible for debouncing raw sensor inputs, ensuring that noisy signals are filtered and stable signals are sent to the traffic light controller system. After the recent updates, the module now handles **individual sensors** at a time. This makes the system simpler and aligns with the requirements for the `adaptive_traffic_light_controller`.

---

### **Module Components**

1. **Parameters:**
   - `DEBOUNCE_TIME`: Defines the number of clock cycles a signal must remain stable before it is considered valid. Default: `4`.

2. **Registers:**
   - `sync [1:0]`: A 2-bit register for synchronizing the raw input signal (`raw_sensor`) with the clock signal to prevent metastability.
   - `counter [2:0]`: A 3-bit counter to track the stability duration of the input signal.
   - `debounced_sensor`: The final output, updated only when the input signal remains stable for the defined `DEBOUNCE_TIME`.

---

### **How It Works**

1. **Synchronization (`sync`):**
   - The raw input signal is sampled over two clock cycles and stored in a 2-bit synchronizer (`sync`).
   - This ensures the signal is synchronized to the system clock and prevents metastability issues.

2. **Stability Check:**
   - The two most recent samples of the signal are compared (`sync[1] == sync[0]`).
   - If stable (equal), the counter increments.
   - If unstable (not equal), the counter resets to `0`.

3. **Debouncing Logic:**
   - Once the signal is stable for `DEBOUNCE_TIME` cycles, the `debounced_sensor` is updated to the stabilized value.

4. **Output (`debounced_sensor`):**
   - Reflects the stable, debounced version of the raw input signal.

---

### **Numerical Example**

#### **Setup**

- `DEBOUNCE_TIME = 4` (signal must remain stable for 4 clock cycles).
- `raw_sensor`: Represents the noisy sensor input.
- `sync`: Holds synchronized samples of the input.
- `counter`: Tracks the duration of signal stability.
- `debounced_sensor`: Outputs the debounced value.

---

#### **Input Signal Sequence**

For simplicity, we'll trace the debouncing process for one sensor input (`raw_sensor`).

| Clock Cycle | `raw_sensor` | `sync[1:0]` | `counter` | `debounced_sensor` | **Notes**                           |
|-------------|--------------|-------------|-----------|---------------------|-------------------------------------|
| 0           | `0`          | `00`        | `0`       | `0`                 | Reset state.                        |
| 1           | `1`          | `01`        | `0`       | `0`                 | Signal changes, counter resets.     |
| 2           | `1`          | `11`        | `1`       | `0`                 | Signal stable, counter increments.  |
| 3           | `1`          | `11`        | `2`       | `0`                 | Signal stable, counter increments.  |
| 4           | `1`          | `11`        | `3`       | `0`                 | Signal stable, counter increments.  |
| 5           | `1`          | `11`        | `4`       | `1`                 | Counter reaches `DEBOUNCE_TIME`, output updates. |
| 6           | `1`          | `11`        | `4`       | `1`                 | Signal remains stable.              |
| 7           | `0`          | `10`        | `0`       | `1`                 | Signal changes, counter resets.     |
| 8           | `0`          | `00`        | `1`       | `1`                 | Signal stable, counter increments.  |
| 9           | `0`          | `00`        | `2`       | `1`                 | Signal stable, counter increments.  |
| 10          | `0`          | `00`        | `3`       | `1`                 | Signal stable, counter increments.  |
| 11          | `0`          | `00`        | `4`       | `0`                 | Counter reaches `DEBOUNCE_TIME`, output updates. |

---

### **Step-by-Step Explanation**

1. **Clock 0:**
   - The input `raw_sensor` is `0`.
   - The synchronizer (`sync`) is initialized to `00`.
   - The counter and `debounced_sensor` are both reset to `0`.

2. **Clock 1:**
   - The input `raw_sensor` changes to `1`.
   - The first sample of the synchronizer captures this change (`sync = 01`).
   - Since the signal is unstable (`sync[1] != sync[0]`), the counter resets to `0`.

3. **Clock 2–5:**
   - The input `raw_sensor` remains stable at `1`.
   - The synchronizer stabilizes (`sync = 11`).
   - The counter increments until it reaches `DEBOUNCE_TIME = 4`.
   - At `clock 5`, the `debounced_sensor` updates to `1`.

4. **Clock 7:**
   - The input `raw_sensor` changes back to `0`.
   - The synchronizer captures the change (`sync = 10`).
   - The counter resets to `0`.

5. **Clock 8–11:**
   - The input `raw_sensor` stabilizes at `0`.
   - The counter increments until it reaches `DEBOUNCE_TIME = 4`.
   - At `clock 11`, the `debounced_sensor` updates to `0`.

---

### **Why This Design Works**

1. **Noise Immunity:**
   - Short glitches or brief noise spikes are ignored because the counter resets on instability.

2. **Parallel Processing:**
   - Each sensor is processed independently, allowing simultaneous debouncing for all 8 inputs.

3. **Flexible Timing:**
   - The `DEBOUNCE_TIME` parameter allows adjustments based on noise characteristics.

4. **Synchronization:**
   - The two-stage `sync` register ensures the input signals are synchronized to the system clock, preventing metastability.

---

### **When to Use**

This module is ideal for:

- Physical sensors (e.g., vehicle detectors, push-buttons) where signal noise or instability might cause erratic behavior.
- Scenarios requiring validated, noise-free sensor data for reliable system operation.
