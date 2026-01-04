`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 06:00:16 AM
// Design Name: 
// Module Name: multiplexor_nombre
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module multiplexor_nombre(
    input clk,
    input enable,
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    reg [2:0] indice = 0;

    wire [6:0] letras [0:4];
    assign letras[0] = 7'b0100001; // D
    assign letras[1] = 7'b0001000; // A
    assign letras[2] = 7'b1100011; // V
    assign letras[3] = 7'b1111011; // I
    assign letras[4] = 7'b0100001; // D

    always @(posedge clk) begin
        if (enable) begin
            case (indice)
                0: begin anodos = 8'b10111111; segmentos = letras[0]; end
                1: begin anodos = 8'b11011111; segmentos = letras[1]; end
                2: begin anodos = 8'b11101111; segmentos = letras[2]; end
                3: begin anodos = 8'b11110111; segmentos = letras[3]; end
                4: begin anodos = 8'b11111011; segmentos = letras[4]; end
                default: begin anodos = 8'b11111111; segmentos = 7'b1111111; end
            endcase
            indice <= (indice == 4) ? 0 : indice + 1;
        end else begin
            anodos <= 8'b11111111;      // apaga todos los displays
            segmentos <= 7'b1111111;    // apaga todos los segmentos
        end
    end
endmodule


