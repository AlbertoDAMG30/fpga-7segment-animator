`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 12:08:20 PM
// Design Name: 
// Module Name: animacion1
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

module animacion1(
    input clk,              // reloj lento (~3Hz)
    input enable,           // activado por SW[7]
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    // Letras codificadas (gfedcba, activo en bajo)
    reg [6:0] letras [0:4];
    initial begin
        letras[0] = 7'b0100001; // D
        letras[1] = 7'b0001000; // A
        letras[2] = 7'b1100011; // V
        letras[3] = 7'b1111011; // I
        letras[4] = 7'b0100001; // D
    end

    reg [2:0] display = 0;        // Display actual (0 a 4)
    reg [2:0] letras_mostradas = 0; // Cuántas letras se han activado (0 a 5)

    always @(posedge clk) begin
        if (enable) begin
            // Mostrar solo hasta letras_mostradas
            case (display)
                0: begin anodos = 8'b10111111; segmentos = (letras_mostradas > 0) ? letras[0] : 7'b1111111; end
                1: begin anodos = 8'b11011111; segmentos = (letras_mostradas > 1) ? letras[1] : 7'b1111111; end
                2: begin anodos = 8'b11101111; segmentos = (letras_mostradas > 2) ? letras[2] : 7'b1111111; end
                3: begin anodos = 8'b11110111; segmentos = (letras_mostradas > 3) ? letras[3] : 7'b1111111; end
                4: begin anodos = 8'b11111011; segmentos = (letras_mostradas > 4) ? letras[4] : 7'b1111111; end
                default: begin anodos = 8'b11111111; segmentos = 7'b1111111; end
            endcase

            display <= (display == 4) ? 0 : display + 1;

            // Cuando volvemos al primer display, sumamos una letra más si no hemos terminado
            if (display == 4 && letras_mostradas < 5)
                letras_mostradas <= letras_mostradas + 1;
        end else begin
            segmentos <= 7'b1111111;
            anodos <= 8'b11111111;
            letras_mostradas <= 0;
            display <= 0;
        end
    end
endmodule


