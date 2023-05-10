`include "global.vh"

module pc(
input clk,
input reset,
output reg[31:0] pc,
input wire[31:0] pc_next
);

always @ (posedge clk) begin
    if (reset) begin
        pc <= 32'h00000000;
    end
    else begin
        pc <= pc_next;
    end
end

endmodule