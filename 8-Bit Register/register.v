`timescale 1ns/100ps
`default_nettype none

module register_8bit (
    output reg [7:0] Q,
    input wire [7:0] D,
    input wire clk,
    input wire en,
    input wire rst
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 8'b0;
        else if (en)
            Q <= D;
    end
endmodule // register_8bit

module register_file (
    output wire [7:0] r_data1,
    output wire [7:0] r_data2,
    input wire clk,
    input wire we,
    input wire rst,
    input wire [2:0] w_addr,
    input wire [2:0] r_addr1,
    input wire [2:0] r_addr2,
    input wire [7:0] w_data
);
    wire [7:0] reg_out [0:7]; // 2D array of wires
    wire [7:0] we_bus;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : regs
            assign we_bus[i] = we && (w_addr == i);
            register_8bit reg_inst (
                .Q(reg_out[i]),
                .D(w_data),
                .clk(clk),
                .en(we_bus[i]),
                .rst(rst)
            );
        end
    endgenerate

    assign r_data1 = reg_out[r_addr1];
    assign r_data2 = reg_out[r_addr2];

endmodule // register_file
