//-----------------------------------------------------------------------------
//-- Generacion de baudios
//-- Señal cuadrada, de periodo igual a la frecuencia de los baudios indicados
//-- El ancho del pulso positivo es de 1 ciclo de reloj
//--
//-- (c) BQ. August 2015. written by Juan Gonzalez (obijuan)
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------
`define log2(n)   ((n) <= (1<<0)  ? 0 : (n)  <= (1<<1)  ? 1  :\
                   (n) <= (1<<2)  ? 2 : (n)  <= (1<<3)  ? 3  :\
                   (n) <= (1<<4)  ? 4 : (n)  <= (1<<5)  ? 5  :\
                   (n) <= (1<<6)  ? 6 : (n)  <= (1<<7)  ? 7  :\
                   (n) <= (1<<8)  ? 8 : (n)  <= (1<<9)  ? 9  :\
                   (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                   (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                   (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                   (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                   (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                   (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                   (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                   (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                   (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                   (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                   (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)

// 50MHz External Clock
`define B115200 434
`define B57600  868
`define B38400  1302
`define B19200  2604
`define B9600   5208
`define B4800   10417
`define B2400   20833
`define B1200   41667
`define B600    83333
`define B300    166667
//-- ENTRADAS:
//--     -clk: Senal de reloj del sistema (12 MHZ en la iceStick)
//--     -clk_ena: Habilitacion. 
//--            1. funcionamiento normal. Emitiendo pulsos
//--            0: Inicializado y parado. No se emiten pulsos
//
//-- SALIDAS:
//--     - clk_out. Señal de salida para lograr la velocidad en baudios indicada
//--                Anchura de 1 periodo de clk. SALIDA NO REGISTRADA
module baudgen(input wire clk,
               input wire clk_ena, 
               output wire clk_out);

//-- Valor por defecto de la velocidad en baudios
parameter M = `B115200;

//-- Numero de bits para almacenar el divisor de baudios
//localparam N = $clog2(M); 
localparam N = `log2(M);

//-- Registro para implementar el contador modulo M
reg [N-1:0] divcounter = 0;

//-- Contador módulo M
always @(posedge clk)

  if (clk_ena)
    //-- Funcionamiento normal
    divcounter <= (divcounter == M - 1) ? 0 : divcounter + 1;
  else
    //-- Contador "congelado" al valor maximo
    divcounter <= M - 1;

//-- Sacar un pulso de anchura 1 ciclo de reloj si el generador
//-- esta habilitado (clk_ena == 1)
//-- en caso contrario se saca 0
assign clk_out = (divcounter == 0) ? clk_ena : 0;


endmodule
