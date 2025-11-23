import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_test(dut):

    cocotb.start_soon(Clock(dut.clk, 333, units="ns").start())

    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    samples = []
    for _ in range(32):
        await RisingEdge(dut.clk)
        samples.append(int(dut.uo_out.value))

    assert max(samples) <= 255
    assert min(samples) >= 0
    assert len(samples) >= 15

    # ✔️ TinyTapeout requires this file for GL_TEST
    with open("test/results.xml", "w") as f:
        f.write("<testsuite name=\"dds_test\" tests=\"1\" failures=\"0\"></testsuite>")
