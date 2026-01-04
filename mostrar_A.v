`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 11:53:38 PM
// Design Name: 
// Module Name: mostrar_A
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

module mostrar_A(
    output reg [6:0] segmentos,   // CA a CG
    output reg [7:0] anodos       // AN[0] a AN[7]
);
    always @(*) begin
        // Activar primer display
        anodos = 8'b11011111;

        // Mostrar letra "A": segmentos a, b, c, e, f, g (d apagado)
        segmentos = 7'b0001000;
    end
endmodule

