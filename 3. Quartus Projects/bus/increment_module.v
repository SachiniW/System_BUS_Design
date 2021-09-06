/* 
 file name : increment_module.v

 Description:
	This file contains the code for a increment module containing a master and a slave post.
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module increment_module #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8, 
								parameter BURST_LEN=12)(
	input clk,
	input reset,
	
	output busy,
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input read,
	input write,
	input [DATA_LEN-1:0]data_load,
	input [ADDR_LEN:0]address_load,
	input [SLAVE_LEN-1:0]slave_select_load,
	input [ADDR_LEN:0]burst_num_load,
	
	//MASTER
	
	input m_arbitor_busy,
	input m_bus_busy,
	input m_approval_grant,
	output m_approval_request,
	output m_tx_slave_select,
	output m_trans_done,
	
	input m_rx_data,
	output m_tx_address,
	output m_tx_data,
	output m_tx_burst_num,
	
	input m_slave_valid,
	input m_slave_ready,
	output m_master_valid,
	output m_master_ready,
	output m_write_en,
	output m_read_en,
	
	//SLAVE
	
	input [5:0]s_slave_delay,

	input s_read_en,
	input s_write_en,

	input s_master_ready,
	input s_master_valid,

	output s_slave_valid,
	output s_slave_ready,

	input s_rx_address,
	input s_rx_data,
	input s_rx_burst, 
	output s_split_en,
	output s_tx_data);
	
	
// MASTER
	
wire [1:0]m_instruction;
wire [SLAVE_LEN-1:0]m_slave_select;
wire [ADDR_LEN-1:0]m_address;
wire [DATA_LEN-1:0]m_data_out;
wire [BURST_LEN-1:0]m_burst_num;
wire [DATA_LEN-1:0]m_data_in;
wire m_rx_done;
wire m_tx_done;
wire m_new_rx;

// SLAVE

wire [7:0]s_datain;
wire [11:0]s_address;
wire [7:0]s_data;
wire s_read_en_in;
wire s_write_en_in;

//
parameter[1:0] INC_IDLE = 2'd0;
parameter[1:0] INCREMENT = 2'd1;
parameter[1:0] DISPLAY = 2'd2;
parameter[1:0] SEND_DATA = 2'd3;

reg [1:0]inc_state =0;
reg [7:0]output_data;
reg [7:0]data_to_master;
reg [5:0]delay_count = 6'd10; // for testing
reg [5:0]delay_counter = 0;

assign m_data_out = data_to_master;

slave_port SLAVE_PORT(
	.clk(clk), 
	.reset(reset),
	.slave_delay(s_slave_delay),
	.read_en(s_read_en),
	.write_en(s_write_en),
	.master_ready(s_master_ready),
	.master_valid(s_master_valid),
	.slave_valid(s_slave_valid),
	.slave_ready(s_slave_ready),
	.rx_address(s_rx_address),
	.rx_data(s_rx_data),
	.rx_burst(s_rx_burst),
	
	.tx_data(s_tx_data),
	.datain(s_datain),
	.address(s_address),
	.data(s_data),
	.read_en_in(s_read_en_in),
	.write_en_in(s_write_en_in),
	.split_en(s_split_en));
	

master_port #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN)) MASTER_PORT(
	.clk(clk), 
	.reset(reset),
	
	.instruction(m_instruction),
	.slave_select(m_slave_select),
	.address(m_address),
	.data_out(m_data_out),
	.burst_num(m_burst_num),
	.data_in(m_data_in),
	.rx_done(m_rx_done),
	.tx_done(m_tx_done),
	.new_rx(m_new_rx),
	
	.arbitor_busy(m_arbitor_busy),
	.bus_busy(m_bus_busy),
	.approval_grant(m_approval_grant),
	.approval_request(m_approval_request),
	.tx_slave_select(m_tx_slave_select),
	.trans_done(m_trans_done),
	
	
	.rx_data(m_rx_data),
	.tx_address(m_tx_address),
	.tx_data(m_tx_data),
	.tx_burst_num(m_tx_burst_num),
	
	.slave_valid(m_slave_valid),
	.slave_ready(m_slave_ready),
	.master_valid(m_master_valid),
	.master_ready(m_master_ready),
	.write_en(m_write_en),
	.read_en(m_read_en));
								
button_event1 #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN)) BUTTON_EVENT1(
	.clk(clk), 
	.reset(reset),
	.busy(busy),
	.display1_pin(display1_pin),
	.display2_pin(display2_pin),
	
	.read(read),
	.write(write),
	.data_load(data_load),
	.address_load(address_load),
	.slave_select_load(slave_select_load),
	.burst_num_load(burst_num_load),
	
	.data_in(m_data_in),
	.rx_done(m_rx_done),
	.tx_done(m_tx_done),
	.trans_done(m_trans_done),
	.new_rx(m_new_rx),
	.instruction(m_instruction),
	.slave_select(m_slave_select),
	.address(m_address),
	.data_out(), //changed	m_data_out
	.burst_num(m_burst_num));
	
	
always @(posedge clk or posedge reset)
begin
if (reset == 1'd1)
	begin
		output_data <= 0;
		delay_counter <= 0;
		inc_state <= INC_IDLE;
	end
else
	begin
		case (inc_state)
			INC_IDLE:begin
				if (s_write_en_in == 1) //when reciever done
				begin
					//output_data <= s_data; // if the received number needs to be displayed
					//display1_pin <= output_data;
					output_data <= 7'd7;
					inc_state <= INCREMENT;
				end
				else
				begin
					output_data <= 0;
					delay_counter <= 0;
				end
			end
			INCREMENT:begin
					output_data <= output_data + 1;
					inc_state <= DISPLAY;
			end
			DISPLAY:begin
				if (delay_counter == delay_count)
				begin
					delay_counter <= 0;
					inc_state <= SEND_DATA;					
				end
				else
				begin
					delay_counter <= delay_counter + 1;
					//display1_pin <= output_data;
				end
			end
			SEND_DATA:begin
					data_to_master <= output_data;
			end
			default:begin
					output_data <= 0;
					delay_counter <= 0;
				end
		endcase			
	end
end
	
	
	
								
endmodule