
module mealy_detector (
    input clk,
    input rst,
    input din,
    output reg dout
);

    // State encoding
    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] state, next_state;

    // Process 1: State register
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Process 2: Next-state logic
    always @(*)
    begin
        case (state)

            S0: next_state = din ? S1 : S0;

            S1: next_state = din ? S1 : S2;

            S2: next_state = din ? S3 : S0;

            S3: next_state = din ? S1 : S2;

            default: next_state = S0;

        endcase
    end

    // Process 3: Output logic
    always @(*)
    begin
        if ((state == S3) && (din == 1'b1))
            dout = 1'b1;
        else
            dout = 1'b0;
    end

endmodule
