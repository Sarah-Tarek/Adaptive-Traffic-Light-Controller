# **Adaptive Traffic Light Controller**

An adaptive traffic light controller designed to dynamically manage traffic flow at a four-way intersection. The system prioritizes heavily congested lanes and ensures smooth, collision-free transitions between traffic lights.

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

### **How Each Module Works Together**

1. **Sensor Input Handler**:
   - Cleans noisy signals from `raw_s1` and `raw_s5`.

2. **FSM**:
   - Determines the current state of the system (`light_signal`).
   - Handles transitions based on timer expiration or congestion.

3. **Timer**:
   - Tracks the duration of each state (green, yellow, extended green).
   - Signals the FSM when the current state should change (`timer_expired`).

4. **Traffic Light Driver**:
   - Decodes the FSM’s `light_signal` to control the actual traffic lights.
