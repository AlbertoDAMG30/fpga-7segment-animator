`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 11:19:06 PM
// Design Name: 
// Module Name: Proyecto2
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
    output reg [7:0] anodos       // AN0 a AN7
);
    initial begin
        // Activar primer display
        anodos = 8'b11111110;

        // Mostrar letra "A": segmentos a,b,c,e,f,g encendidos (0 = ON en ánodo común)
        segmentos = 7'b0001000;
    end
endmodule

