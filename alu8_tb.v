`timescale 1ns/1ps

module alu8_tb;
    reg [7:0] a, b;
    reg [2:0] op;
    wire [7:0] result;
    wire zero, carry, overflow;
    integer tests_run, failures;

    alu8 dut (
        .a(a), .b(b), .op(op),
        .result(result), .zero(zero),
        .carry(carry), .overflow(overflow)
    );

    task check;
        input [7:0] test_a, test_b;
        input [2:0] test_op;
        input [7:0] expected_result;
        input expected_zero, expected_carry, expected_overflow;

        begin
            a = test_a;
            b = test_b;
            op = test_op;
            #1;

            tests_run = tests_run + 1;

            if (result !== expected_result ||
                zero !== expected_zero ||
                carry !== expected_carry ||
                overflow !== expected_overflow) begin

                failures = failures + 1;
                $display("FAIL op=%b a=%0d b=%0d got result=%0d Z=%b C=%b V=%b expected result=%0d Z=%b C=%b V=%b",
                         op, a, b, result, zero, carry, overflow,
                         expected_result, expected_zero,
                         expected_carry, expected_overflow);
            end else begin
                $display("PASS op=%b a=%0d b=%0d result=%0d Z=%b C=%b V=%b",
                         op, a, b, result, zero, carry, overflow);
            end
        end
    endtask

    initial begin
        tests_run = 0;
        failures = 0;

        //       a,      b,       op, expected result,   zero, carry, overflow
        check(8'd5,   8'd3,   3'b000,            8'd8,   1'b0,  1'b0, 1'b0); // ADD
        check(8'd3,   8'd3,   3'b001,            8'd0,   1'b1,  1'b1, 1'b0); // SUB
        check(8'd12,  8'd10,  3'b010,            8'd8,   1'b0,  1'b0, 1'b0); // AND
        check(8'd12,  8'd10,  3'b011,            8'd14,  1'b0,  1'b0, 1'b0); // OR
        check(8'd12,  8'd10,  3'b100,            8'd6,   1'b0,  1'b0, 1'b0); // XOR
        check(8'd5,   8'd0,   3'b101,            8'd250, 1'b0,  1'b0, 1'b0); // NOT
        check(8'd129, 8'd0,   3'b110,            8'd2,   1'b0,  1'b0, 1'b0); // SHL
        check(8'd129, 8'd0,   3'b111,            8'd64,  1'b0,  1'b0, 1'b0); // SHR

        check(8'd255, 8'd1,   3'b000,            8'd0,   1'b1,  1'b1, 1'b0); // add carry
        check(8'd0,   8'd1,   3'b001,            8'd255, 1'b0,  1'b0, 1'b0); // subtract borrow
        check(8'd1,   8'd0,   3'b111,            8'd0,   1'b1,  1'b0, 1'b0); // shift to zero
        check(8'd127, 8'd1,   3'b000,            8'd128, 1'b0,  1'b0, 1'b1); // signed overflow
        check(8'd128, 8'd128, 3'b000,            8'd0,   1'b1,  1'b1, 1'b1); // carry and overflow
        check(8'd128, 8'd1,   3'b001,            8'd127, 1'b0,  1'b1, 1'b1); // subtract overflow
        check(8'd127, 8'd255, 3'b001,            8'd128, 1'b0,  1'b0, 1'b1); // subtract overflow
        check(8'd200, 8'd100, 3'b000,            8'd44,  1'b0,  1'b1, 1'b0); // carry only
        check(8'd12,  8'd3,   3'b010,            8'd0,   1'b1,  1'b0, 1'b0); // AND gives zero

        if (failures == 0)
            $display("ALL %0d TESTS PASSED", tests_run);
        else
            $fatal(1, "%0d of %0d tests failed", failures, tests_run);

        $finish;
    end
endmodule