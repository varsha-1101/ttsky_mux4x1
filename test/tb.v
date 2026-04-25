import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_mux_4x1(dut):
    dut._log.info("Starting 4x1 MUX Simulation...")

    # -----------------------------
    # Reset sequence
    # -----------------------------
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await Timer(50, unit="ns")

    dut.rst_n.value = 1
    await Timer(50, unit="ns")

    # -----------------------------
    # Test cases: (d0,d1,d2,d3, sel, expected)
    # -----------------------------
    test_cases = [
        (0,0,0,1, 0, 0),
        (0,1,0,0, 1, 1),
        (1,0,0,0, 2, 0),
        (1,0,0,0, 3, 0),
        (1,1,1,1, 3, 1),
        (0,1,1,0, 2, 1),
    ]

    for d0, d1, d2, d3, sel, expected in test_cases:

        # Pack inputs:
        # ui_in[0]=d0, [1]=d1, [2]=d2, [3]=d3
        # [4]=sel0, [5]=sel1
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

        await Timer(20, unit="ns")

        output = int(dut.uo_out.value)
        actual = output & 1

        assert actual == expected, \
            f"FAILED: d0={d0} d1={d1} d2={d2} d3={d3} sel={sel} -> got {actual}, expected {expected}"

        dut._log.info(
            f"PASS: sel={sel} -> output={actual}"
        )
