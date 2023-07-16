--==============================================================
--fibrisTerre
--==============================================================
--
--unit name: lvds_ddr_tb.vhd
--
--author: Nathan Boyles (nathanh.boyles@gmail.com)
--
--date created: 27-06-2023
--
--version: 0.1
--
--description:
	--lvds_ddr testbench
--dependencies: lvd_ddr.vhd
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
use work.util_pkg.all;

--entity declaration
entity lvds_ddr_tb is
end entity lvds_ddr_tb;

--architecture declaration
architecture behaviour of lvds_ddr_tb is
	
	--signal declaration
	signal clk_250_i			: std_logic;
	signal s_rst_n_i		: std_logic := '1';
	signal s_clk_running	: boolean;
	
	signal s_data_I_i			: std_logic_vector(15 downto 0) := (others => 'Z');
	signal s_data_Q_i		: std_logic_vector(15 downto 0);
	--dac_3282 interface
	signal s_D_p_o			: std_logic_vector(7 downto 0);
	signal s_D_n_o			: std_logic_vector(7 downto 0);
	signal s_FRAME_p_o	: std_logic;
	signal s_FRAME_n_o	: std_logic;
	signal s_clk_p_o			: std_logic;
	signal s_clk_n_o			: std_logic;
	
	constant c_SETTLING_TIME: time :=2 ns;
	
	--component decalaration
	component lvds_ddr_out is
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
	end component lvds_ddr_out;
	
	component stim_gen is
    port (
        rst_i				: in  std_logic;
        clk_250_i		: in  std_logic;
        random_flag	: in  std_logic;
        random_data	: out std_logic_vector (15 downto 0)
    );
	end component stim_gen;


	--architecture begin
	begin
	
	--clock
	clk_240(clk_250_i,s_clk_running,10000); --Clock generator procedure

	--stimuli generator
	cmp_stim_gen: stim_gen
	port map(
		rst_i				=> s_rst_n_i,
        clk_250_i		=> clk_250_i,
        random_flag	=> '1',
        random_data	=> s_data_I_i
	);
	
	--component instantiation
	dut :  lvds_ddr_out
	port map(
		clk_250_i		=> clk_250_i,
		data_I_i		=> s_data_I_i,
		data_Q_i		=> s_data_Q_i,
		rst_n_i			=> s_rst_n_i,
		--dac_3282 interface
		D_p_o			=> s_D_p_o,
		D_n_o			=> s_D_n_o,
		FRAME_p_o	=> s_FRAME_p_o,
		FRAME_n_o	=> s_FRAME_n_o,
		clk_p_o			=> s_clk_p_o,
		clk_n_o			=> s_clk_n_o
	);
	
	 s_data_Q_i<= not(s_data_I_i);
	process
	begin
		wait for 5 ns;
		s_rst_n_i <= '1';
		wait for 5 ns;
		s_rst_n_i <= '0';
		wait;
	end process;
	
end behaviour;