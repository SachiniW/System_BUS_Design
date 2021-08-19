# System_BUS
A point to point multiplexed serial bus design.

# 1. Slave Signals
| Wire | Description |
| --- | --- |
| `clk` | Clock signal: should be supplied externally |
| `reset` | Asyncronous reset signal; active HIGH signal |
| `read_en` | Write enable signal for BRAM; Drive high for one cycle at start |
| `write_en` | Read enable signal for BRAM; Drive high for one cycle at start |
| `master_ready` | Ready to accept data from the slave; driven by master |
| `master_valid` | Data in the data and address wires are valid; driven by master |
| `slave_ready` | Ready to accept data from the master; driven by slave |
| `slave_valid` | Data in the data wire is valid; driven by slave |
| `rx_done` | Acknowledgement for receiving of address; driven by slave |
| `slave_tx_done` | Acknowledgement for transmitting the data; driven by slave |
| `rx_address` | Receives address serially; driven by master |
| `rx_data` | Receives data serially; driven by master |
| `tx_data` | Transmits data serially; driven by slave |

# 2. Slave Top View

![Slave Top View](https://github.com/SachiniW/System_BUS_Design/blob/main/Images/Slave_top_view.png)

# 3. Slave Data Read Operation

![Read](https://github.com/SachiniW/System_BUS_Design/blob/main/Images/Slave_read.png)


# 4. Slave Data Write Operation

![Write](https://github.com/SachiniW/System_BUS_Design/blob/main/Images/Slave_write.png)
