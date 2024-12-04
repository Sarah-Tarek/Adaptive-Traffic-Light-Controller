# **Adaptive Traffic Light Controller**

An adaptive traffic light controller for a four-way intersection designed in Verilog. This project utilizes real-time sensor inputs to dynamically manage traffic light states, prioritize congested lanes, and ensure smooth and collision-free traffic flow.

---

## **Table of Contents**

1. [Overview](#overview)
2. [Features](#features)
3. [System Design](#system-design)
4. [Project Structure](#project-structure)
5. [Modules](#modules)
6. [Installation and Usage](#installation-and-usage)
7. [Testing and Validation](#testing-and-validation)
8. [Future Improvements](#future-improvements)
9. [License](#license)

---

## **Overview**

This project implements an adaptive traffic light controller using a **Finite State Machine (FSM)**. It dynamically adjusts the traffic light durations based on real-time sensor data, ensuring efficient traffic management.

---

## **Features**

- **Dynamic Light Timing**: Adjusts green light duration based on congestion.
- **Collision Avoidance**: Ensures only one lane has a green or yellow light at a time.
- **Idle Lane Skipping**: Skips lanes without waiting cars to optimize traffic flow.
- **Extensible Design**: Easily configurable for intersections with different layouts or requirements.

---

## **System Design**

### **Input Sensors**

- **`S1` Sensors**: Detect cars near the start of the lane.
- **`S5` Sensors**: Detect congestion when five or more cars are waiting in a lane.

### **FSM States**

1. **North-South Lane 1**: `NS1_RED`, `NS1_GREEN`, `NS1_YELLOW`
2. **North-South Lane 2**: `NS2_RED`, `NS2_GREEN`, `NS2_YELLOW`
3. **East-West Lane 1**: `EW1_RED`, `EW1_GREEN`, `EW1_YELLOW`
4. **East-West Lane 2**: `EW2_RED`, `EW2_GREEN`, `EW2_YELLOW`

### **Timers**

- **Default Green Duration**: 20 seconds.
- **Extended Green Duration**: 30 seconds (if congestion is detected).
- **Yellow Duration**: 5 seconds.

---

## **Project Structure**

```plaintext
.
├── LICENSE                                # License file for the project
├── README.md                              # Documentation file for the project
├── docs/                                  # Documentation and design-related files
│   ├── project-specs.pdf                  # Project specifications and requirements
│   ├── system-design and-light-algorithm.pdf # Detailed system design and algorithms
│   └── traffic-light-fsm.png              # FSM diagram for the traffic light controller
├── src/                                   # Verilog source code files
│   ├── adaptive_traffic_light_controller.v # Top-level module integrating all components
│   ├── sensor_input_handler.v            # Handles and debounces sensor inputs
│   ├── timer.v                           # Manages the timing for green, yellow, and red lights
│   ├── traffic_light_driver.v            # Converts FSM signals into traffic light outputs
│   └── traffic_light_fsm.v               # FSM module for managing traffic light states
├── synthesis/                             # Synthesis-related files
│   ├── constraints.sdc                   # Timing constraints for synthesis
│   └── synthesized_netlist.v             # Synthesized Verilog netlist
└── tb/                                    # Testbenches for simulation
    ├── sensor_input_handler.v            # Testbench for the sensor input handler
    ├── tb_adaptive_traffic_light_controller.v # Testbench for the top-level module
    ├── tb_timer.v                        # Testbench for the timer module
    ├── tb_traffic_light_driver.v         # Testbench for the traffic light driver
    └── tb_traffic_light_fsm.v            # Testbench for the FSM module
```

### **Explanation of Directories**

- **`docs/`**: Contains supporting documents and diagrams for the project, such as FSM diagrams and system specifications.
- **`src/`**: Source Verilog files for the traffic light controller and its submodules.
- **`synthesis/`**: Files related to synthesis, including constraints and the synthesized netlist.
- **`tb/`**: Testbenches for individual modules and the integrated system.

---

## **Modules**

### **1. `traffic_light_fsm.v`**

Implements the FSM for managing traffic light states and transitions.

### **2. `timer.v`**

Handles the timing of green, yellow, and red light durations with optional extensions.

### **3. `sensor_input_handler.v`**

Debounces raw sensor inputs to provide stable signals to the FSM.

### **4. `traffic_light_driver.v`**

Converts FSM-generated control signals into physical traffic light outputs.

### **5. Top-Level Module: `adaptive_traffic_light_controller.v`**

Integrates all submodules to form the complete system.

---

## **Installation and Usage**

### **Clone the Repository**

```bash
git clone https://github.com/Sarah-Tarek/Adaptive-Traffic-Light-Controller.git
cd Adaptive-Traffic-Lights
```

### **Simulate the Design**

1. **Run Testbenches**:

   ```bash
   vlog src/*.v tb/tb_traffic_light_fsm.v
   vsim tb_traffic_light_fsm
   ```

   - Repeat for other testbenches in the `tb/` directory.

2. **Simulate the Full System**:

   ```bash
   vlog src/*.v tb/tb_adaptive_traffic_light_controller.v
   vsim tb_adaptive_traffic_light_controller
   ```

3. **View Waveforms**:
   - Use a waveform viewer to validate outputs and state transitions.

### **Synthesize the Design**

- Use a synthesis tool (e.g., **Vivado**, **Quartus**, or **Synopsys DC**) with files from the `src/` directory.
- Apply timing constraints from `synthesis/constraints.sdc`.

---

## **Testing and Validation**

### **Test Scenarios**

- Validate transitions from `RED` to `GREEN` based on sensor inputs (`S1 = 1`).
- Verify timer-based transitions from `GREEN` to `YELLOW` and `YELLOW` to `RED`.
- Ensure idle lane skipping when `S1 = 0`.
- Test congestion handling (`S5 = 1`) to extend green light duration.

---

## **Future Improvements**

1. **Scalability**:

   - Extend the design for larger intersections or roundabouts.

2. **Advanced Features**:

   - Include pedestrian signals and emergency vehicle prioritization.

3. **Dynamic Priority**:
   - Dynamically adjust priorities based on historical congestion data.

---

## **License**

This project is licensed under the [MIT License](LICENSE).
