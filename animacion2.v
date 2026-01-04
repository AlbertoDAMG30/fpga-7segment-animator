`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 08:05:58 PM
// Design Name: 
// Module Name: animacion2
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

module animacion2(
    input clk_slow,         // 190Hz para multiplexar
    input clk_anim,         // 6Hz para animación
    input enable,
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    // ROM con espacios adicionales para el rebote completo
    reg [6:0] letras_rom [0:11]; // Más espacios para permitir el rebote
    initial begin
        letras_rom[0]  = 7'b1111111; // espacio
        letras_rom[1]  = 7'b1111111; // espacio
        letras_rom[2]  = 7'b1111111; // espacio
        letras_rom[3]  = 7'b0100001; // D
        letras_rom[4]  = 7'b0001000; // A
        letras_rom[5]  = 7'b1100011; // V
        letras_rom[6]  = 7'b1111011; // I
        letras_rom[7]  = 7'b0100001; // D
        letras_rom[8]  = 7'b1111111; // espacio
        letras_rom[9]  = 7'b1111111; // espacio
        letras_rom[10] = 7'b1111111; // espacio
        letras_rom[11] = 7'b1111111; // espacio
    end

    reg [3:0] offset = 0;  // Rango 0-7 para cubrir 8 displays
    reg dir = 0;           // 0: derecha, 1: izquierda
    reg [2:0] display = 0; 
    reg [6:0] buffer [0:7]; // Buffer para 8 displays
    reg prev_clk_anim;

    // Lógica de animación
    always @(posedge clk_slow) begin
        prev_clk_anim <= clk_anim;

        // Actualizar offset en cada flanco de clk_anim
        if (enable && prev_clk_anim == 0 && clk_anim == 1) begin
            if (dir == 0) begin // Movimiento hacia la derecha
                if (offset == 4) begin // Límite derecho (último display)
                    dir <= 1;
                    offset <= offset - 1;
                end else begin
                    offset <= offset + 1;
                end
            end else begin // Movimiento hacia la izquierda
                if (offset == 0) begin // Límite izquierdo (primer display)
                    dir <= 0;
                    offset <= offset + 1;
                end else begin
                    offset <= offset - 1;
                end
            end
        end

        // Cargar buffer con desplazamiento
        buffer[0] <= letras_rom[offset];
        buffer[1] <= letras_rom[offset + 1];
        buffer[2] <= letras_rom[offset + 2];
        buffer[3] <= letras_rom[offset + 3];
        buffer[4] <= letras_rom[offset + 4];
        buffer[5] <= letras_rom[offset + 5];
        buffer[6] <= letras_rom[offset + 6];
        buffer[7] <= letras_rom[offset + 7];
    end

    // Multiplexado de los 8 displays
    always @(posedge clk_slow) begin
        if (enable) begin
            case (display)
                0: begin anodos = 8'b01111111; segmentos = buffer[0]; end
                1: begin anodos = 8'b10111111; segmentos = buffer[1]; end
                2: begin anodos = 8'b11011111; segmentos = buffer[2]; end
                3: begin anodos = 8'b11101111; segmentos = buffer[3]; end
                4: begin anodos = 8'b11110111; segmentos = buffer[4]; end
                5: begin anodos = 8'b11111011; segmentos = buffer[5]; end
                6: begin anodos = 8'b11111101; segmentos = buffer[6]; end
                7: begin anodos = 8'b11111110; segmentos = buffer[7]; end
                default: begin anodos = 8'b11111111; segmentos = 7'b1111111; end
            endcase
            display <= (display == 7) ? 0 : display + 1;
        end else begin
            anodos <= 8'b11111111;
            segmentos <= 7'b1111111;
            display <= 0;
        end
    end
endmodule



