module pattern_matcher (
    input wire clk,
    input wire rst,
    input wire [3:0] pattern_a, // 4-bit pattern
    input wire [3:0] pattern_b, // 4-bit pattern
    output reg match // Indicate wether the patterns match
);

    // Pipeline stage index
    reg [1:0] stage;
    // Pipeline stage labels
    parameter START = 2'b00;
    parameter COMPUTE = 2'b01;
    parameter REDUCE = 2'b10;
    parameter DONE  = 2'b11;
    
    // Registers
    reg [3:0] reg_a, reg_b; // Save patterns
    reg [3:0] xor_result; // Save computation result
    reg sum_bits; // Sum result
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            stage <= START;
            reg_a <= 0;
            reg_b <= 0;
            xor_result <= 0;
            sum_bits <= 0;
            match <= 0;
        end else begin
            case (stage)
                START: begin // Save patterns internally
                    reg_a <= pattern_a;
                    reg_b <= pattern_b;
                    stage <= COMPUTE;
                end
                
                COMPUTE: begin // Compute XOR
                    xor_result <= reg_a ^ reg_b;
                    stage <= REDUCE;
                end
                
                REDUCE: begin // Sum all XOR-result bits
                    sum_bits <= |xor_result;
                    stage <= DONE;
                end
                
                DONE: begin // Negate and output match
                    match <= !sum_bits;
                    stage <= START;
                end
                
                default: begin
                    stage <= START;
                end
            endcase
        end
    end
endmodule
