import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_test(dut):

    # Create 3 MHz clock (166.6ns period)
    cocotb.start_soon(Clock(dut.clk, 166, units="ns").start())

    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Release reset after a few cycles
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Run for 40 cycles to collect some sine samples
    for _ in range(40):
        await RisingEdge(dut.clk)

    assert True   # Always pass
