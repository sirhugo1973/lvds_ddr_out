--==============================================================
--fibrisTerre
--==============================================================
--
--unit name: lvds_ddr.vhd
--
--author: Nathan Boyles (nathanh.boyles@gmail.com)
--
--date created: 16-07-2023
--
--version: 0.1
--
--description:
	--The DAC3282 has a single 8-bit LVDS bus that accepts dual, 16-bit data 
	--input in byte-wide format. Data into the	--DAC3282 is formatted according 
	--to the diagram shown in Figure 34 where index 0 is the data LSB and 
	--index 15is the data MSB. The data is sampled by DATACLK, a double data 
	--rate (DDR) clock. The FRAME signal is required to indicate the beginning 
	--of a frame. The frame signal can be either a pulse or a periodic signal where
	--the frame period corresponds to 8 samples. The pulse-width (t(FRAME)) 
	--needs to be at least equal to 1/2f the DATACLK period. FRAME is sampled 
	--by a rising edge in DATACLK.
	--DATACLK 250 MPMS
--dependencies: diff_buf.vhd, synchronizer.vhd, data_readout.vhd
--
--references: 
--
--date modified:
-- <date> <name> <email>
------------------------------------------------------------------------------------------------------------------------------
-- to do:
--==============================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity declaration
entity lvds_ddr_out is
	port(
		clk_250_i		: in std_logic;
		data_I_i		: in std_logic_vector(15 downto 0);
		data_Q_i		: in std_logic_vector(15 downto 0);
		rst_n_i			: in std_logic;
		--dac_3282 interface
		D_p_o			: out std_logic_vector(7 downto 0);
		D_n_o			: out std_logic_vector(7 downto 0);
		FRAME_p_o	: out std_logic;
		FRAME_n_o	: out std_logic;
		clk_p_o			: out std_logic;
		clk_n_o			: out std_logic
	);
end entity lvds_ddr_out;

--architecture declaration

architecture behaviour of lvds_ddr_out is

	--signal aliasing
	
	--signal declaration
	signal s_clk_250_i 		: std_logic;
	signal s_wr_en_0 			: std_logic;
	signal s_data_I_i 			: std_logic_vector ( 15 downto 0 );
	signal s_wr_en_1 			: std_logic;
	signal s_data_Q_i 		: std_logic_vector ( 15 downto 0 );
	signal s_din_2 				: std_logic_vector ( 31 downto 0 );
	signal s_D_p_o 			: std_logic_vector ( 7 downto 0 );
	signal s_D_n_o 			: std_logic_vector ( 7 downto 0 );
	signal s_clk_p_o 			: std_logic_vector ( 0 to 0 );
	signal s_clk_n_o 			: std_logic_vector ( 0 to 0 );
	signal s_FRAME_p_o 	: std_logic_vector ( 0 to 0 );
	signal s_FRAME_n_o 	: std_logic_vector ( 0 to 0 );
	signal s_rst_n_i 			: std_logic_vector ( 0 downto 0 );
	signal s_data_I_sync 	: std_logic_vector ( 15 downto 0 );
	signal s_data_Q_sync 	: std_logic_vector ( 15 downto 0 );
	
	signal s_data_combined: std_logic_vector(31 downto 0);
	
	
	--------------------------------------------------------
	signal s_FRAME_pulse : std_logic;
	signal s_clk_500			: std_logic;
	signal s_gb_data_valid_o: std_logic;
	signal r0_input                           : std_logic;
	signal r1_input                           : std_logic;
	-------------------------------------------------------

	--signal aliasing

	--Component Declaration
	 component design_1 is
	 port (
		clk_250_i 			: in std_logic;
		wr_en_0 			: in std_logic;
		data_I_i 			: in std_logic_vector ( 15 downto 0 );
		wr_en_1 			: in std_logic;
		data_Q_i 			: in std_logic_vector ( 15 downto 0 );
		din_2 				: in std_logic_vector ( 31 downto 0 );
		D_p_o 				: out std_logic_vector ( 7 downto 0 );
		D_n_o 				: out std_logic_vector ( 7 downto 0 );
		clk_p_o 			: out std_logic_vector ( 0 to 0 );
		clk_n_o 			: out std_logic_vector ( 0 to 0 );
		FRAME_p_o 	: out std_logic_vector ( 0 to 0 );
		FRAME_n_o 	: out std_logic_vector ( 0 to 0 );
		rst_n_i 				: in std_logic_vector ( 0 downto 0 );
		data_I_sync 		: out std_logic_vector ( 15 downto 0 );
		---------------------------------------------------------------------------------
		clk_500_o : out STD_LOGIC;
		gb_data_valid_o : out STD_LOGIC;
		FRAME_pulse_i : in STD_LOGIC_VECTOR ( 0 to 0 );
		 --------------------------------------------------------------------------------
		data_Q_sync 	: out std_logic_vector ( 15 downto 0 )
	  );
	  end component design_1;
		
	--architecture begin
	begin
		--signal assignment
		
		--component instantiation
		
		cmp_lvds_ddr_out: component design_1
		port map (
			D_n_o			=> s_D_n_o,
			D_p_o			=> s_D_p_o,
			FRAME_n_o(0)	=> s_FRAME_n_o(0),
			FRAME_p_o(0)	=> s_FRAME_p_o(0),
			clk_250_i 		=> clk_250_i,
			clk_n_o			=> s_clk_n_o,
			clk_p_o			=> s_clk_p_o,
			data_I_i		=> s_data_I_i,
			data_I_sync	=> s_data_combined(15 downto 0),
			data_Q_i 		=> s_data_Q_i,
			data_Q_sync	=> s_data_combined(31 downto 16),
			din_2			=> s_data_combined,
			rst_n_i			=> s_rst_n_i,
			wr_en_0 		=> s_wr_en_0, --Rename these
			-------------------------------------------------------------------------------
			FRAME_pulse_i(0) => s_FRAME_pulse,
			clk_500_o => s_clk_500,
			gb_data_valid_o => s_gb_data_valid_o,
			-----------------------------------------------------------------------------
			wr_en_1 		=> s_wr_en_1
		);

		--Synchonize Reset
		p_synq_rst: process(clk_250_i, rst_n_i) is
		begin
		if rst_n_i = '1' then                  -- do reset
			if rising_edge(clk_250_i) then 
				s_rst_n_i <= "1";
			end if;
		elsif rst_n_i = '0' then                  -- do reset
			if rising_edge(clk_250_i) then 
				s_rst_n_i <= "0";
			end if;
		end if;
		end process p_synq_rst;
		
		--Signal Assignment
		FRAME_p_o	<=	s_FRAME_p_o(0);
		FRAME_n_o	<=	s_FRAME_n_o(0); 
		D_n_o 		 	<=	s_D_p_o;
		D_p_o 			<=	s_D_n_o;
		clk_p_o			<=	s_clk_p_o(0);
		clk_n_o			<=	s_clk_n_o(0);
		s_data_I_i		<=	data_I_i;
		s_data_Q_i	<=	data_Q_i;
		
		--Change this code to synchronous reset
		p_main : process(clk_250_i) is
		begin
			if rising_edge(clk_250_i) then
				if s_rst_n_i(0) = '1' then -- do reset
					s_wr_en_0 <= '0';
					s_wr_en_1 <= '0';
				else
					s_wr_en_0 <= '1';
					s_wr_en_1 <= '1';
				end if;
			end if;
		end process p_main;
		
	--FRAME Pulse Generator
	p_rising_edge_detector : process(clk_250_i,s_rst_n_i)
	begin
	  if s_rst_n_i(0) = '1'  then
		r0_input           <= '0';
		r1_input           <= '0';
	  elsif rising_edge(clk_250_i) then
		r0_input           <= s_gb_data_valid_o;
		r1_input           <= r0_input;
	  end if;
	end process p_rising_edge_detector;

	s_FRAME_pulse            <= not r1_input and r0_input;
end behaviour;