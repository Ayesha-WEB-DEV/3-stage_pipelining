# *Three-Stage Pipelining with Hazard Handling and CSR*

## Introduction
This project implements a three-stage pipelined processor aimed at demonstrating an efficient pipelining architecture that manages hazards and incorporates Control and Status Registers (CSR) for improved control and performance.

## Architecture Overview

### Stages
**1.** **Instruction Fetch (IF):** Fetches instructions from memory.

**2. Instruction Decode (ID):** Decodes instructions and prepares them for execution.

**3. Execute (EX):** Executes instructions based on decoded information.

## Features
## 1. **Hazard Handling**

### 1. Control Hazard

**Definition:** Control hazards occur when the outcome of a conditional branch instruction is unknown at the time of instruction fetch, leading to a possible misprediction of the branch.

**Causes:**

**Branch Instructions:** Conditional branches like if, while, or for statements.

**Delayed Branch Resolutions:** When the outcome of a branch is resolved later in the pipeline than the instruction fetch stage.

**Impact:**

**Pipeline Stalls or Flushes:** Traditional solutions involve stalling the pipeline until the outcome of the branch is known. In some cases, flushing the pipeline (discarding instructions fetched after the branch) might be necessary.

### **Mitigation Strategies:**

**Branch Prediction:** Using historical data or algorithms to predict the outcome of a branch before it's resolved.


### 2. Data Hazard

**Definition:** Data hazards occur when an instruction depends on the result of a previous incomplete instruction, leading to incorrect execution or pipeline stalls.

**Types of Data Hazards:**

**Read-After-Write (RAW):** Also known as a true data hazard, it occurs when an instruction reads a register or memory location before a previous instruction that writes to the same location completes.

**Write-After-Read (WAR):** Also called an anti-dependency, this occurs when an instruction writes to a location before a previous instruction reads from that location.

**Write-After-Write (WAW):** Also called an output dependency, this happens when two instructions write to the same location, and the order of their execution affects the final value.

**Impact:**

**Pipeline Stalls:** Occur when the dependent instruction needs the result of a previous instruction that hasn’t been completed yet.

### **Mitigation Strategies:**

**Data Forwarding (or Bypassing):** Transmitting data directly from one pipeline stage to another to prevent stalls caused by dependencies.

**Stalling the Pipeline:** Holding up the pipeline until the required data is available.

## 2. **Control and Status Registers (CSR)**

**Control Registers:** Manage control flow aspects, including program counters and branch prediction tables.

**Status Registers:** Maintain flags and status information, such as interrupt enable/disable bits and condition code flags.

## Usage
1. **Run the Simulation:** Execute the main program to initiate the simulation.
2. **Input Test Cases:** Create your test case to observe hazard handling and CSR functionalities.
3. **Observe Execution:** Analyze how the processor manages hazards and utilizes CSR during instruction processing.

## Pipelining Diagram
- Review in the images folder
![Three-Stage Pipelining](images/pipeline_diagram.jpeg)
