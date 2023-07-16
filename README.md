# Development Environment
- Ubuntu 20.04
- Vivado 2023.1
- Xilinx Simulator
- Part xcau20p-sfvb784-1-e

# Building the Project
- Clone the project
- Navigate to project directory
- vivado -mode tcl 
- "source lvds_ddr_out.tcl"
- "start_gui" 
# Known Bugs
- Clock Cycle Delay in FRAME signals due to combinational logic
- Possibly unnecessary synchronization phase
- Output signals initialized to zero at reset
- Need to get the right part XCZU4CG
  
# DAC3282 LVDS FPGA Interface

Your task is to design an LVDS output interface for an FPGA, which feeds a dual
channel 16bit high speed DAC at 250 MSPS.

The FPGA: Xilinx Zynq Ultrascale+ XCZU4CG speedgrade 1
The DAC: Texas Instruments DAC3282.

The data interface of the DAC is described on p. 30 of the attached datasheet.
The data is delivered to your interface as 2x 16 bit data and a 250 MHz clock, both
coming from sources within the FPGA. You can assume perfect timing of the source
data with respect to CLK. The 250 MHz clock input CLK is driven by a BUFG.

The VHDL interface of your block looks like this:

entity LVDS_DDR_out is
Port (CLK : in STD_LOGIC;
data_I : in STD_LOGIC_VECTOR (15 downto 0);
data_Q : in STD_LOGIC_VECTOR (15 downto 0);
RST
: in STD_LOGIC;
DoutP : out STD_LOGIC_VECTOR (7 downto 0);
DoutN : out STD_LOGIC_VECTOR (7 downto 0);
FRAMEp : out std_logic;
FRAMEn : out std_logic;
CLKoutP : out std_logic;
CLKoutN : out std_logic);
end LVDS_DDR_out;

The RST signal is coming from the ARM core and is NOT synchronized to CLK. You
have to take care of proper synchronization.
While the RST signal is applied, all outputs must be logic 0.

### Q: The output signals will be assigned directly to FPGA pins. Which bank would you recommend to use and why?
### A: I would suggest a High Performance (HP) bank [HP 64, HP 65, HP 66]. The application suggests  High Performance over High Density.

Your solution can be pure VHDL, you don’t need to setup a Vivado project.
If you prefer, you can also use any tools of the Vivado Suite.

The XCZU4CG is a webpack part, which means you can use Vivado without a license.

Bonus question: how would you modify your design, if you knew that the PCB traces
between FPGA and DAC are not of identical length? (Assume a skew of max. 400ps,
with the P/N traces being perfectly matched within one pair)
