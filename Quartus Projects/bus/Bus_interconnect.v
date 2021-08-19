 
 module Bus_interconnect(

input sys_clk,
input sys_rst,
input m1_request, 
input m2_request,
input m1_slave_sel,
input m2_slave_sel,

output m1_grant,
output m2_grant,

input m1_clk, 
input m1_rst,
input m1_valid,
input m1_tx_address,
input m1_tx_data,
output m1_rx_data,
input m1_write_en,
input m1_read_en,
output m1_slave_ready,

input m2_clk, 
input m2_rst,
input m2_valid,
input m2_tx_address,
input m2_tx_data,
output m2_rx_data,
input m2_write_en,
input m2_read_en,
output m2_slave_ready,

output s1_clk, 
output s1_rst,
output s1_valid,
output s1_rx_address,
output s1_rx_data,
input s1_tx_data,
output s1_write_en,
output s1_read_en,
input s1_slave_ready,

output s2_clk, 
output s2_rst,
output s2_valid,
output s2_rx_address,
output s2_rx_data,
input s2_tx_data,
output s2_write_en,
output s2_read_en,
input s2_slave_ready,

output s3_clk, 
output s3_rst,
output s3_valid,
output s3_rx_address,
output s3_rx_data,
input s3_tx_data,
output s3_write_en,
output s3_read_en,
input s3_slave_ready

);

wire [1:0] bus_grant; 
wire [1:0] slave_sel;  

 
 Bus_Arbiter Bus_Arbiter1(
.sys_clk(sys_clk), 
.sys_rst(sys_rst),
.m1_request (m1_request), 
.m2_request(m2_request),
.m1_slave_sel(m1_slave_sel),
.m2_slave_sel(m2_slave_sel),
.m1_grant(m1_grant),
.m2_grant(m2_grant),
.bus_grant(bus_grant), 
.slave_sel(slave_sel));
 
 
 Bus_mux Bus_mux1(
.bus_grant(bus_grant), 
.slave_sel(slave_sel),
.m1_clk(m1_clk), 
.m1_rst(m1_rst),
.m1_valid(m1_valid),
.m1_tx_address(m1_tx_address),
.m1_tx_data(m1_tx_data),
.m1_rx_data(m1_rx_data),
.m1_write_en(m1_write_en),
.m1_read_en(m1_read_en),
.m1_slave_ready(m1_slave_ready),
.m2_clk(m2_clk), 
.m2_rst(m2_rst),
.m2_valid(m2_valid),
.m2_tx_address(m2_tx_address),
.m2_tx_data(m2_tx_data),
.m2_rx_data(m2_rx_data),
.m2_write_en(m2_write_en),
.m2_read_en(m2_read_en),
.m2_slave_ready(m2_slave_ready),
.s1_clk(s1_clk), 
.s1_rst(s1_rst),
.s1_valid(s1_valid),
.s1_rx_address(s1_rx_address),
.s1_rx_data(s1_rx_data),
.s1_tx_data(s1_tx_data),
.s1_write_en(s1_write_en),
.s1_read_en(s1_read_en),
.s1_slave_ready(s1_slave_ready),
.s2_clk(s2_clk), 
.s2_rst(s2_rst),
.s2_valid(s2_valid),
.s2_rx_address(s2_rx_address),
.s2_rx_data(s2_rx_data),
.s2_tx_data(s2_tx_data),
.s2_write_en(s2_write_en),
.s2_read_en(s2_read_en),
.s2_slave_ready(s2_slave_ready),
.s3_clk(s3_clk), 
.s3_rst(s3_rst),
.s3_valid(s3_valid),
.s3_rx_address(s3_rx_address),
.s3_rx_data(s3_rx_data),
.s3_tx_data(s3_tx_data),
.s3_write_en(s3_write_en),
.s3_read_en(s3_read_en),
.s3_slave_ready(s3_slave_ready)
);



endmodule
