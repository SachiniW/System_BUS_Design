module control(input clk,
					input z,
					input instruction,
					input rst,
			      output reg [15:0] ctrlsig,
					output reg end_process);

reg [5:0] present = 6'd0;
reg [5:0] next = 6'd1;
 
parameter
fetch1 = 6'd0,
fetch2 = 6'd1,
fetch3 = 6'd2,
add1 = 6'd3,
add2 = 6'd4,
add3 = 6'd5,
add4 = 6'd6,
add5 = 6'd7,
add6 = 6'd8,
add7 = 6'd9,
endop = 6'd10;

always @(posedge clk or posedge rst)
begin 
	if (rst == 1)
	present <= fetch1;
	else
	present <= next;
end

always @(posedge clk)
begin
	if (present == endop)
	end_process <= 1'd1;
	else
	end_process <= 1'd0;
end


always @(present)
case(present)
	fetch1: begin
		next <= fetch2 ;
	end
	fetch2: begin
		next <= fetch3 ;
	end
	fetch3: begin
		next <= add1 ;
	end
	add1: begin
		next <= add2 ;
	end
	add2: begin	
		next <= add3 ;
	end
	add3: begin	
		next <= add4 ;
	end
	add4: begin	
		next <= add5 ;
	end
	add5: begin
		next <= add6 ;
	end
	add6: begin
		next <= add7 ;
	end
	add7: begin
		next <= endop;
	end
	endop: begin
		next <= endop;
	end
	default: begin 
		next = endop;
	end
endcase

endmodule
