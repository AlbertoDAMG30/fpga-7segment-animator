`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: main
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

module main(
    input clk,
    input [9:0] sw,  // SW[0] = ON/OFF, SW[7] = anim1, SW[8] = anim2, SW[9] = anim3
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    wire clk_slow, clk_anim1, clk_anim2, clk_anim3;
    wire [6:0] segmentos_a1, segmentos_a2, segmentos_a3, segmentos_mux, segmentos_err;
    wire [7:0] anodos_a1, anodos_a2, anodos_a3, anodos_mux, anodos_err;
    
    // Detectar error (más de un switch de animación activo)
    wire error_condition = (sw[7] + sw[8] + sw[9]) > 1;
    
    divisor_reloj div(
        .clk(clk),
        .clk_slow(clk_slow),
        .clk_anim1(clk_anim1),
        .clk_anim2(clk_anim2),
        .clk_anim3(clk_anim3)
    );
    
    // Módulo normal (solo se activa si SW[0]=1 y no hay animaciones/error)
    multiplexor_nombre mux(
        .clk(clk_slow),
        .enable(sw[0] & ~error_condition & ~(sw[7] | sw[8] | sw[9])),
        .segmentos(segmentos_mux),
        .anodos(anodos_mux)
    );
    
    // Animación 1
    animacion1 a1 (
        .clk(clk_anim1),
        .enable(sw[7] & sw[0] & ~error_condition),
        .segmentos(segmentos_a1),
        .anodos(anodos_a1)
    );
    
    // Animación 2
    animacion2 a2 (
        .clk_slow(clk_slow),
        .clk_anim(clk_anim2),
        .enable(sw[8] & sw[0] & ~error_condition),
        .segmentos(segmentos_a2),
        .anodos(anodos_a2)
    );
    
    // Animación 3
    animacion3 a3 (
        .clk_slow(clk_slow),
        .clk_anim(clk_anim3),
        .enable(sw[9] & sw[0] & ~error_condition),
        .segmentos(segmentos_a3),
        .anodos(anodos_a3)
    );
    
    // Módulo de error
    error_display err (
        .clk(clk_slow),
        .enable(error_condition & sw[0]),
        .segmentos(segmentos_err),
        .anodos(anodos_err)
    );
    
    // Lógica de selección con prioridades
    always @(*) begin
        if (~sw[0]) begin  // Si SW[0] está en OFF
            segmentos = 7'b1111111;
            anodos = 8'b11111111;
        end else if (error_condition) begin  // Error tiene prioridad máxima
            segmentos = segmentos_err;
            anodos = anodos_err;
        end else if (sw[9]) begin  // Prioridad anim3 > anim2 > anim1 > normal
            segmentos = segmentos_a3;
            anodos = anodos_a3;
        end else if (sw[8]) begin
            segmentos = segmentos_a2;
            anodos = anodos_a2;
        end else if (sw[7]) begin
            segmentos = segmentos_a1;
            anodos = anodos_a1;
        end else begin
            segmentos = segmentos_mux;
            anodos = anodos_mux;
        end
    end
endmodule




