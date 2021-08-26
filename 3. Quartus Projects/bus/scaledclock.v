//File name : clock_divider.v
//This module is used to convert a 50MHz clock to give out a 1Hz clock pulse.

module scaledclock(input inclk,
						 input ena,
					    output reg clk = 1);

parameter maxcount=28'd50000000;// input 10MHz clock and output 1Hz clk
reg [27:0] count=28'd0;

always @ (posedge inclk)
	begin
	if (ena)
		begin
			if (count==maxcount)
				begin
				clk<=~clk;
				count<=28'd0;
				end
			else
				begin
				count<=count+1;
				end
		end
	else
		begin
		clk<=0;
		end
	end

endmodule
