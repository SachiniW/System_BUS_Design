module LCD_in(
	input clock,
	input rst,
	//input [15:0] Data_Line1,
   //input [15:0] Data_Line2,
   output LCD_ON,	// LCD Power ON/OFF
   output LCD_BLON,	// LCD Back Light ON/OFF
   output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
   output LCD_EN,	// LCD Enable
   output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
   inout [7:0] LCD_DATA	// LCD Data bus 8 bits
);

//reg [1:0] Data_Type1 = 2'd1; //00-address, 01-data, 10-Master, 11-Selected Slave  
//reg [1:0] Data_Type2 = 2'd0;
reg [15:0] Data_Line1 = 16'b1100110011001100;
reg [15:0] Data_Line2 = 16'b1000100010001000;

lcdlab3 LCD(
	.clock(clock),
	.rst(rst),
	.Line11(Line11),
	.Line12(Line12),
	.Line13(Line13),
	.Line14(Line14),
   .Line15(Line15),
	.Line16(Line16),
	.Line17(Line17),
	.Line18(Line18),
	.Line19(Line19),
	.Line110(Line110),
	.Line111(Line111),
	.Line112(Line112),
	.Line113(Line113),
	.Line114(Line114),
	.Line115(Line115),
	.Line116(Line116),
	
	.Line21(Line21),
	.Line22(Line22),
	.Line23(Line23),
	.Line24(Line24),
    .Line25(Line25),
	.Line26(Line26),
	.Line27(Line27),
	.Line28(Line28),
	.Line29(Line29),
	.Line210(Line210),
	.Line211(Line211),
	.Line212(Line212),
	.Line213(Line213),
	.Line214(Line214),
	.Line215(Line215),
	.Line216(Line216),	
   .LCD_ON(LCD_ON),	
   .LCD_BLON(LCD_BLON),	
   .LCD_RW(LCD_RW),	
   .LCD_EN(LCD_EN),	
   .LCD_RS(LCD_RS),	
   .LCD_DATA(LCD_DATA));

//assign Line11    = (Data_Type1 == 2'd0 )? 8'h41 : 
//						 (Data_Type1 == 2'd1 )? 8'h44 : 
//						 (Data_Type1 == 2'd2 )? 8'h4D : 
//						 (Data_Type1 == 2'd3 )? 8'h53 : 8'h41 ; 
//						 
//assign Line12    = (Data_Type1 == 2'd0 )? 8'h44 :
//						 (Data_Type1 == 2'd1 )? 8'h54 : 
//						 (Data_Type1 == 2'd2 )? 8'h41 :
//						 (Data_Type1 == 2'd3 )? 8'h53 : 8'h30 ;

assign Line11    = (Data_Line1[15] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line12    = (Data_Line1[14] == 1'b1 )? 8'h31 : 8'h30 ;						 
assign Line13    = (Data_Line1[13] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line14    = (Data_Line1[12] == 1'b1 )? 8'h31 : 8'h30 ;      
assign Line15    = (Data_Line1[11] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line16    = (Data_Line1[10] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line17    =  (Data_Line1[9] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line18    =  (Data_Line1[8] ==  1'b1 )? 8'h31 : 8'h30 ;    
assign Line19    =  (Data_Line1[7] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line110    = (Data_Line1[6] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line111    = (Data_Line1[5] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line112    = (Data_Line1[4] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line113    = (Data_Line1[3] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line114    = (Data_Line1[2] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line115    = (Data_Line1[1] ==  1'b1 )? 8'h31 : 8'h30 ;       
assign Line116    = (Data_Line1[0] ==  1'b1 )? 8'h31 : 8'h30 ; 

//assign Line21    = (Data_Type2 == 2'd0 )? 8'h41 : 
//						 (Data_Type2 == 2'd1 )? 8'h44 : 
//						 (Data_Type2 == 2'd2 )? 8'h4D : 
//						 (Data_Type2 == 2'd3 )? 8'h53 : 8'h30 ; 
//						 
//assign Line22    = (Data_Type2 == 2'd0 )? 8'h44 :
//						 (Data_Type2 == 2'd1 )? 8'h54 : 
//						 (Data_Type2 == 2'd2 )? 8'h41 :
//						 (Data_Type2 == 2'd3 )? 8'h53 : 8'h30 ;

assign Line21   = (Data_Line2[15] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line22   = (Data_Line2[14] == 1'b1 )? 8'h31 : 8'h30 ;        
assign Line23   = (Data_Line2[13] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line24   = (Data_Line2[12] == 1'b1 )? 8'h31 : 8'h30 ;      
assign Line25   = (Data_Line2[11] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line26   = (Data_Line2[10] == 1'b1 )? 8'h31 : 8'h30 ;       
assign Line27   = (Data_Line2[9] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line28   = (Data_Line2[8] ==  1'b1 )? 8'h31 : 8'h30 ;    
assign Line29    = (Data_Line2[7] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line210   = (Data_Line2[6] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line211   = (Data_Line2[5] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line212   = (Data_Line2[4] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line213   = (Data_Line2[3] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line214   = (Data_Line2[2] ==  1'b1 )? 8'h31 : 8'h30 ;        
assign Line215   = (Data_Line2[1] ==  1'b1 )? 8'h31 : 8'h30 ;       
assign Line216   = (Data_Line2[0] ==  1'b1 )? 8'h31 : 8'h30 ; 	

//assign Line1[127:120]  = (Data_Line1[15] == 1'b1 )? 8'h31 : 8'h30 ;
//assign Line1[119:112]  = (Data_Line1[14] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line1[111:104]  = (Data_Line1[13] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line1[103:96]   = (Data_Line1[12] == 1'b1 )? 8'h31 : 8'h30 ;      
//assign Line1[95:88]    = (Data_Line1[11] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line1[87:80]    = (Data_Line1[10] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line1[79:72]    = (Data_Line1[9] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[71:64]    = (Data_Line1[8] ==  1'b1 )? 8'h31 : 8'h30 ;    
//assign Line1[63:56]    = (Data_Line1[7] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[55:48]    = (Data_Line1[6] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[47:40]    = (Data_Line1[5] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[39:32]    = (Data_Line1[4] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[31:24]    = (Data_Line1[3] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[23:16]    = (Data_Line1[2] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line1[15:8]     = (Data_Line1[1] ==  1'b1 )? 8'h31 : 8'h30 ;       
//assign Line1[7:0]      = (Data_Line1[0] ==  1'b1 )? 8'h31 : 8'h30 ; 
//
//
//assign Line2[127:120]  = (Data_Line2[15] == 1'b1 )? 8'h31 : 8'h30 ;
//assign Line2[119:112]  = (Data_Line2[14] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line2[111:104]  = (Data_Line2[13] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line2[103:96]   = (Data_Line2[12] == 1'b1 )? 8'h31 : 8'h30 ;      
//assign Line2[95:88]    = (Data_Line2[11] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line2[87:80]    = (Data_Line2[10] == 1'b1 )? 8'h31 : 8'h30 ;       
//assign Line2[79:72]    = (Data_Line2[9] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[71:64]    = (Data_Line2[8] ==  1'b1 )? 8'h31 : 8'h30 ;    
//assign Line2[63:56]    = (Data_Line2[7] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[55:48]    = (Data_Line2[6] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[47:40]    = (Data_Line2[5] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[39:32]    = (Data_Line2[4] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[31:24]    = (Data_Line2[3] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[23:16]    = (Data_Line2[2] ==  1'b1 )? 8'h31 : 8'h30 ;        
//assign Line2[15:8]     = (Data_Line2[1] ==  1'b1 )? 8'h31 : 8'h30 ;       
//assign Line2[7:0]      = (Data_Line2[0] ==  1'b1 )? 8'h31 : 8'h30 ;          
	
	
endmodule 