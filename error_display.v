`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 04:12:27 AM
// Design Name: 
// Module Name: error_display
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

module error_display(
    input clk,
    input enable,
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    reg [2:0] indice = 0;  // Índice para multiplexar displays
    
    // Codificación de "Error" (E, r, r, o, r)
    wire [6:0] letras_err [0:4];
    assign letras_err[0] = 7'b0000110; // E
    assign letras_err[1] = 7'b0101111; // r
    assign letras_err[2] = 7'b0101111; // r
    assign letras_err[3] = 7'b1000000; // o
    assign letras_err[4] = 7'b0101111; // r
    
    always @(posedge clk) begin
        if (enable) begin
            case (indice)
                0: begin anodos = 8'b01111111; segmentos = letras_err[0]; end // Display 0: E
                1: begin anodos = 8'b10111111; segmentos = letras_err[1]; end // Display 1: r
                2: begin anodos = 8'b11011111; segmentos = letras_err[2]; end // Display 2: r
                3: begin anodos = 8'b11101111; segmentos = letras_err[3]; end // Display 3: o
                4: begin anodos = 8'b11110111; segmentos = letras_err[4]; end // Display 4: r
                default: begin anodos = 8'b11111111; segmentos = 7'b1111111; end
            endcase
            indice <= (indice == 4) ? 0 : indice + 1;
        end else begin
            anodos <= 8'b11111111;
            segmentos <= 7'b1111111;
            indice <= 0;
        end
    end
endmodule
