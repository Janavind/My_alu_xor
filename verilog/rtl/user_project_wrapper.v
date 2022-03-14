`default_nettype none

module user_project_wrapper  (
	`ifdef USE_POWER_PINS
		//inout vdda1,	// User area 1 3.3V supply
		//	inout vdda2,	// User area 2 3.3V supply
		//	inout vssa1,	// User area 1 analog ground
		//	inout vssa2,	// User area 2 analog ground
			inout vccd1,	// User area 1 1.8V supply
		//	inout vccd2,	// User area 2 1.8v supply
			inout vssd1,	// User area 1 digital ground
		//	inout vssd2,	// User area 2 digital ground
	`endif
		// Wishbone Slave ports (WB MI A)
		 input wb_clk_i,
		 input wb_rst_i,
		 input wbs_stb_i,
		 input wbs_cyc_i,
		 input wbs_we_i,
		 input [3:0] wbs_sel_i,
		 input [31:0] wbs_dat_i,
		 input [31:0] wbs_adr_i,
		 output wbs_ack_o,
		 output [31:0] wbs_dat_o,
		
		// // Logic Analyzer Signals
		 input  [127:0] la_data_in,
		 output [127:0] la_data_out,
		 input  [127:0] la_oenb,
		
		// // IOs
		 input  [`MPRJ_IO_PADS-1:0] io_in,
		 output [`MPRJ_IO_PADS-1:0] io_out,
		 output [`MPRJ_IO_PADS-1:0] io_oeb,
		
		// // Analog (direct connection to GPIO pad---use with
		// caution)
		// // Note that analog I/O is not available on the
		// 7 lowest-numbered
		// // GPIO pads, and so the analog_io indexing is offset from
		// the
		// // GPIO indexing by 7 (also upper 2 GPIOs do not have
		// analog_io).
		 inout [`MPRJ_IO_PADS-10:0] analog_io,
		
		// // Independent clock (on independent integer divider)
		// input   user_clock2,
		
		// // User maskable interrupt signals
		 output [2:0] user_irq
		 );
		//
		// /*--------------------------------------*/
		// /* User project is instantiated  here   */
		// /*--------------------------------------*/

 wire clk;

 wire [`MPRJ_IO_PADS-1:0] io_in;
 wire [`MPRJ_IO_PADS-1:0] io_out;
 wire [7:0] A0,B0,A1,B1;  // ALU 8-bit Inputs                 
 wire [1:0] ALU_Sel1,ALU_Sel2;// ALU Selection
 wire [7:0] ALU_Out1,ALU_Out2; // ALU 8-bit Output
 wire CarryOut1,CarryOut2; // Carry Out Flag
 wire [7:0] x;
 wire y;
 wire wb_clk_i;

 assign wb_clk_i = clk;
 assign A0 = io_in[7:0];
 assign B0 = io_in[15:8];
 assign A1 = io_in[23:16];
 assign B1 = io_in[31:24]; 
 assign ALU_Sel1 = io_in[33:32];
 assign ALU_Sel2 = io_in[35:34];
 assign io_out[7:0] = ALU_Out1; 
 assign io_out[15:8] = ALU_Out2;
 assign io_out[16] = CarryOut1;
 assign io_out[17] = CarryOut2;
 assign io_out[25:18] = x;
 assign io_out[26] = y; 

 user_proj_example user_proj_example_1(
`ifdef USE_POWER_PINS
 .vccd1(vccd1),
 .vssd1(vssd1),
`endif
 .clk(wb_clk_i),
 .A0(io_in[7:0]),
 .B0(io_in[15:8]),
 .A1(io_in[23:16]),
 .B1(io_in[31:24]),
 .ALU_Sel1(io_in[33:32]),
 .ALU_Sel2(io_in[35:34]),
 .ALU_Out1(io_out[7:0]),
 .ALU_Out2(io_out[15:8]),
 .CarryOut1(io_out[16]),
 .CarryOut2(io_out[17]),
 .x(io_out[25:18]),
 .y(io_out[26])
 );
 

 endmodule	// user_project_wrapper

 `default_nettype wire
