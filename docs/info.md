<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 200 kHz Direct Digital Synthesis (DDS) sine-wave generator using a simple lookup table (LUT) approach. The TinyTapeout board provides a 3 MHz system clock, and the design divides this clock through sequential table indexing to produce a stable, periodic sine output.

Core Operation

A 15-entry lookup table stores one full cycle of an 8-bit sine wave

Values range from 1 to 255

Offset = 128 (for mid-rail)

Amplitude = 127

Ideal for audio, RF demos, or simple signal-generation circuits

A 4-bit counter (0 to 14) steps through the table on every rising clock edge.

At a 3 MHz clock, cycling through all 15 samples produces:

Output frequency = 3,000,000 / 15 = 200,000 Hz (200 kHz)


Each cycle outputs one value from the sine table to uo_out[7:0], giving a continuous 8-bit digital sine wave.

Reset Behavior

When rst_n = 0, the generator resets:

Table index returns to 0

Output is forced to mid-level (128)

## How to test

disable reset

## External hardware

dac,LPF
