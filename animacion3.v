`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 11:09:27 PM
// Design Name: 
// Module Name: animacion3
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

module animacion3(
    input clk_slow,         // 190 Hz (multiplexado)
    input clk_anim,         // 2 Hz (velocidad del scroll)
    input enable,
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    // ROM con "DAVID" + espacios para el scroll infinito
    reg [6:0] letras_rom [0:12]; // Tamaño suficiente para el loop
    initial begin
        letras_rom[0]  = 7'b0100001; // D
        letras_rom[1]  = 7'b0001000; // A
        letras_rom[2]  = 7'b1100011; // V
        letras_rom[3]  = 7'b1111011; // I
        letras_rom[4]  = 7'b0100001; // D
        letras_rom[5]  = 7'b1111111; // espacio
        letras_rom[6]  = 7'b1111111; // espacio
        letras_rom[7]  = 7'b1111111; // espacio
        letras_rom[8]  = 7'b1111111; // espacio
        letras_rom[9]  = 7'b1111111; // espacio
        letras_rom[10] = 7'b1111111; // espacio
        letras_rom[11] = 7'b1111111; // espacio
        letras_rom[12] = 7'b1111111; // espacio
    end

    reg [3:0] offset = 0;  // Controla el inicio del scroll
    reg [2:0] display = 0; // Display actual
    reg [6:0] buffer [0:7]; // Buffer para 8 displays
    reg prev_clk_anim;

    // Actualizar offset con clk_anim
    always @(posedge clk_slow) begin
        prev_clk_anim <= clk_anim;
        
        if (enable && prev_clk_anim == 0 && clk_anim == 1) begin
            offset <= (offset == 12) ? 0 : offset + 1; // Reinicia al final
        end

        // Cargar buffer con desplazamiento
        buffer[0] <= letras_rom[(offset) % 13];
        buffer[1] <= letras_rom[(offset + 1) % 13];
        buffer[2] <= letras_rom[(offset + 2) % 13];
        buffer[3] <= letras_rom[(offset + 3) % 13];
        buffer[4] <= letras_rom[(offset + 4) % 13];
        buffer[5] <= letras_rom[(offset + 5) % 13];
        buffer[6] <= letras_rom[(offset + 6) % 13];
        buffer[7] <= letras_rom[(offset + 7) % 13];
    end

    // Multiplexar displays
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
