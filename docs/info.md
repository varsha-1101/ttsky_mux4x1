<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 4-to-1 multiplexer (MUX) in Verilog.

The design takes four 1-bit input signals:
- d0 = ui_in[0]
- d1 = ui_in[1]
- d2 = ui_in[2]
- d3 = ui_in[3]

It also takes a 2-bit select signal:
- sel0 = ui_in[4]
- sel1 = ui_in[5]

These two bits are combined into a select bus:
- sel = {sel1, sel0}

Based on the value of `sel`, one of the four inputs is routed to the output `y`:
- 00 → d0
- 01 → d1
- 10 → d2
- 11 → d3

The selected output is driven on:
- uo_out[0]

All other output bits are set to 0.

The module is purely combinational logic, so the output changes immediately when inputs change.

---

## How to test

You can test this design using cocotb simulations provided in the testbench files.

### Test procedure:
1. Apply reset:
   - Set `rst_n = 0` for a short duration
   - Then set `rst_n = 1`

2. Apply input patterns:
   - Assign values to d0–d3 (ui_in[0:3])
   - Set select lines (ui_in[4:5])

3. Observe output:
   - Check `uo_out[0]`
   - Verify it matches the selected input

### Example test cases:
- sel = 00 → output should equal d0
- sel = 01 → output should equal d1
- sel = 10 → output should equal d2
- sel = 11 → output should equal d3

The cocotb testbench automatically verifies correctness using multiple input combinations.

---

## External hardware

No external hardware is required for this project.

The design is fully digital and runs entirely on the FPGA / simulation environment.
