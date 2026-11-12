
`timescale 1ns / 1ps

module sequence_detector_tb;

    reg clk;
    reg rst;
    reg din;

    wire mealy_out;
    wire moore_out;

    integer i;
    reg [7:0] test_data;

    // Mealy DUT
    mealy_detector M1 (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(mealy_out)
    );

    // Moore DUT
    moore_detector M2 (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(moore_out)
    );

    // Clock generation: 10 ns
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply one input bit and observe outputs
    task send_bit;
        input bit_value;
        begin
            @(negedge clk);
            din = bit_value;
            #1;

            $display("Time=%0t DIN=%b Mealy=%b Moore=%b",
                     $time, din, mealy_out, moore_out);

            @(posedge clk);
            #1;
        end
    endtask

    // Test sequence
    initial
    begin
        $dumpfile("sequence_detector.vcd");
        $dumpvars(0, sequence_detector_tb);

        rst = 1;
        din = 0;

        #12;
        rst = 0;

        // Pattern stream: 10110110
        test_data = 8'b10110110;

        $display("---- DETERMINISTIC TEST ----");

        for (i = 7; i >= 0; i = i - 1)
        begin
            send_bit(test_data[i]);
        end

        // Random test
        $display("---- RANDOM TEST ----");

        for (i = 0; i < 20; i = i + 1)
        begin
            send_bit($random & 1);
        end

        $display("---- SIMULATION COMPLETED ----");

        #20;
        $finish;
    end

endmodule
