`timescale 1ns/1ps

module alu8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [2:0] op,
    output reg [7:0] result,
    output wire zero,
    output reg carry,
    output reg overflow
);

    always @* begin
        result = 8'b0;
        carry = 1'b0;
        overflow = 1'b0;

        case (op)
            3'b000: begin // ADD
                {carry, result} = {1'b0, a} + {1'b0, b};
                overflow = (~(a[7] ^ b[7])) & (a[7] ^ result[7]);
            end

            3'b001: begin // SUBTRACT
                result = a - b;
                carry = (a >= b); // 1 means no borrow
                overflow = (a[7] ^ b[7]) & (a[7] ^ result[7]);
            end

            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~a;
            3'b110: result = a << 1;
            3'b111: result = a >> 1;
            default: result = 8'b0;
        endcase
    end

    assign zero = (result == 8'b0);

endmodule