
/************************************************************** 
   A 64bit interposed XAPUF design with picoblaze micro controller 
   used for data communication between FPGA and PC.
  
   Author: Durga Prasad Sahoo, BOSCH India
   Last Update: 4/11/2017   
***************************************************************/

//module iXOR_APUF_64_DOLUT_wrapper(clk,rx,tx,led2,led3,led4,led5);
module iXOR_APUF_64_DOLUT_wrapper(clk,rx,tx);
	localparam CLOCK_FRE = 100000000;  		// Frequency in Hz
	localparam BAUD_RATE = 19200;      		// Baud rate for RS232 communication   
   
	localparam N = 128;     // Challenge length
	localparam K = 8;     	// No. of APUF
	
	(* CLOCK_SIGNAL = "yes" *)
	input  clk;
	input  rx;
	output tx;
	
//	output reg led2;
//	output reg led3;
//	output reg led4;
//	output  reg led5;

	wire tigSig_t, tigSig_b;
	wire respReady, respReady_t;
	wire [K-1:0] respBitA;
	wire respBit;
	reg [N-1:0] challenge;
	
	///////////////////////////////////////////////////////////////////////
   //   PUF INSTANTIATION
	///////////////////////////////////////////////////////////////////////


    //XOR PUF
	(*KEEP_HIERARCHY="TRUE"*)
	xor_apuf #(.N(N),.K(K)) XAPUF(
	   .clk(clk),
		.tigSignal(tigSig_t),
		.c(challenge),
		.respReady(respReady),
		.respBitA(respBitA),
		.respBit(respBit)
	);
	
	/////////////////////////////////////////////////////////////////////////////
	// CHALLENGE PREPARATION
	/////////////////////////////////////////////////////////////////////////////
	
	wire [127:0] dataIn_128;
	wire [7:0] chal_1,chal_2,chal_3,chal_4,chal_5,chal_6,chal_7,chal_8,chal_9,chal_17,chal_18,chal_19,chal_20,chal_21,chal_22,chal_23,chal_24;
	wire chalEn;

	assign dataIn_128 = {chal_2,chal_3,chal_4,chal_5,chal_6,chal_7,chal_8,chal_9,chal_17,chal_18,chal_19,chal_20,chal_21,chal_22,chal_23,chal_24};// �ɵ�λ����λchal24��2

	wire wrEn;
	wire [1:0] inId;             // Change this accordingly
	assign inId = chal_1; 
 
	// Receive challenges
	always@(posedge clk) begin
	  if(~chalEn) begin
		 challenge <= 0;
	  end else begin
			if (wrEn) begin
				 case(inId)
					  //3: challenge[63:0] <= dataIn_64;
						  
					  //2: challenge[127:64] <= dataIn_64;
						  
					  //1: challenge[63:0] <= dataIn_64;
								
				  0: begin
				         challenge[127:0] <= dataIn_128;
                      end
			    endcase
			//	   challenge[127:0] <= dataIn_128;
				   
			  end else begin
					challenge <= challenge;
			  end // else wrEn
	  end // else chalEn
	end // always
    
    
//    always@(posedge tigSig_t) begin
//           led2=~led2;
//          end
          
//      always@(posedge chalEn) begin
//           led5=~led5;
//          end     
    
	          
//      always@(posedge dataIn_128[3]) begin
//          led4=~led4;
//          end     
//       always@(posedge dataIn_128[120]) begin
//          led3=~led3;
//          end    
	///////////////////////////////////////////////////////////////////////
   //   PICBLAZE MICRO-CONTROLLER (8-Bit)
	///////////////////////////////////////////////////////////////////////
	
	(* KEEP_HIERARCHY = "TRUE" *)
	puf_controller #(.CLOCK_FRE(CLOCK_FRE), .BAUD_RATE(BAUD_RATE)) PUF_CU (
        .clk(clk),
        .response_ready(respReady),
        .RESP_1_PORT(respBit),
        .RESP_2_PORT(respBitA[7:0]),
        .RESP_3_PORT(),
        .RESP_4_PORT(),
        .RESP_5_PORT(),
        .RESP_6_PORT(),
        .RESP_7_PORT(),
        .RESP_8_PORT(),
        .RESP_9_PORT(),
        .RESP_10_PORT(),
        .RESP_11_PORT(),
        .RESP_12_PORT(),
        .RESP_13_PORT(),
        .RESP_14_PORT(),
        .RESP_15_PORT(),
        .RESP_16_PORT(),
        .rx(rx),
        .tx(tx),
        .CHAl_1_PORT(chal_1),
        .CHAl_2_PORT(chal_2),
        .CHAl_3_PORT(chal_3),
        .CHAl_4_PORT(chal_4),
        .CHAl_5_PORT(chal_5),
        .CHAl_6_PORT(chal_6),
        .CHAl_7_PORT(chal_7),
        .CHAl_8_PORT(chal_8),
        .CHAl_9_PORT(chal_9),
        .CHAl_10_PORT(tigSig_t),
        .CHAl_11_PORT(),
        .CHAl_12_PORT(),
        .CHAl_13_PORT(),
        .CHAl_14_PORT(),
        .CHAl_15_PORT(), // First byte in matlab program
        .CHAl_16_PORT(wrEn),
        .CHAL_EN_PORT(chalEn),
        .PUF_START_PORT(),	
        .CHAl_17_PORT(chal_17),
        .CHAl_18_PORT(chal_18),
        .CHAl_19_PORT(chal_19),
        .CHAl_20_PORT(chal_20),
        .CHAl_21_PORT(chal_21),
        .CHAl_22_PORT(chal_22),
        .CHAl_23_PORT(chal_23),
        .CHAl_24_PORT(chal_24)
	);

endmodule

// END
