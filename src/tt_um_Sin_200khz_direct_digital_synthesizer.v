`default_nettype none

module tt_um_Sin_200khz_direct_digital_synthesizer (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // 3 MHz clock from TinyTapeout board
    input  wire       rst_n     // active-low reset
);

    // ----------------------------------------------------------
    //  Convert TinyTapeout reset (active-low) to active-high rst
    // ----------------------------------------------------------
    wire rst = ~rst_n;

    // ----------------------------------------------------------
    //  200 kHz Sine Wave DDS (15-sample LUT, 3 MHz / 15 = 200 kHz)
    // ----------------------------------------------------------

    // Sine output register
    reg [7:0] sin_out;

    // 15-entry sine lookup table
    reg [7:0] sine_lut [0:14];

    initial begin
        sine_lut[0]  = 8'd128;
        sine_lut[1]  = 8'd180;
        sine_lut[2]  = 8'd224;
        sine_lut[3]  = 8'd251;
        sine_lut[4]  = 8'd255;
        sine_lut[5]  = 8'd233;
        sine_lut[6]  = 8'd189;
        sine_lut[7]  = 8'd128;
        sine_lut[8]  = 8'd67;
        sine_lut[9]  = 8'd23;
        sine_lut[10] = 8'd1;
        sine_lut[11] = 8'd5;
        sine_lut[12] = 8'd32;
        sine_lut[13] = 8'd76;
        sine_lut[14] = 8'd120;
    end

    reg [3:0] addr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr     <= 0;
            sin_out  <= 8'd128;
        end else begin
            addr     <= (addr == 14) ? 0 : addr + 1;
            sin_out  <= sine_lut[addr];
        end
    end

    // ----------------------------------------------------------
    // Send sine output to TinyTapeout dedicated output pins
    // ----------------------------------------------------------
    assign uo_out = sin_out;

    // ----------------------------------------------------------
    // Disable bidirectional IO (not used)
    // ----------------------------------------------------------
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    // ----------------------------------------------------------
    // Prevent unused warning
    // ----------------------------------------------------------
    wire _unused = &{ui_in, uio_in, ena, 1'b0};

endmodule

`default_nettype wire
