# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_mux4x1(dut):
    dut._log.info("Start 4x1 MUX test")

    # -----------------------------
    # Clock setup
    # -----------------------------
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # -----------------------------
    # Reset
    # -----------------------------
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # -----------------------------
    # Test cases (d0,d1,d2,d3, sel, expected)
    # -----------------------------
    test_cases = [
        (0,0,0,1, 0, 0),
        (0,1,0,0, 1, 1),
        (1,0,0,0, 2, 0),
        (1,0,0,0, 3, 0),
        (1,1,1,1, 0, 1),
        (0,1,1,0, 2, 1),
        (1,0,1,0, 2, 1),
    ]

    dut._log.info("Testing MUX behavior")

    for d0, d1, d2, d3, sel, expected in test_cases:

        sel0 = sel & 1
        sel1 = (sel >> 1) & 1

        dut.ui_in.value = (
            (sel1 << 5) |
            (sel0 << 4) |
            (d3 << 3) |
            (d2 << 2) |
            (d1 << 1) |
            d0
        )

        await ClockCycles(dut.clk, 1)

        output = int(dut.uo_out.value)
        actual = output & 1

        assert actual == expected, \
            f"FAIL: d0={d0} d1={d1} d2={d2} d3={d3} sel={sel} -> got {actual}, expected {expected}"

        dut._log.info(
            f"PASS: sel={sel} output={actual}"
        )
