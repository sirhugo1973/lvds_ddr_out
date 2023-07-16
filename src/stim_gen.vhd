--==============================================================
--fibrisTerre
--==============================================================
--
--unit name: lvds_ddr.vhd
--
--author: Nathan Boyles (nathanh.boyles@gmail.com)
--
--date created: 27-06-2023
--
--version: 0.1
--
--description:
	--16 Bit Random Pattern Generator
--dependencies: <entity name>
--
--references: 
--
--date modified:
-- <date> <name> <email>
------------------------------------------------------------------------------------------------------------------------------
-- to do: 
--
--==============================================================
library ieee;
use ieee.std_logic_1164.all;

entity stim_gen is
    port (
        rst_i:                in  std_logic;
        clk_250_i:            in  std_logic;
        random_flag:        in  std_logic;
        random_data:        out std_logic_vector (15 downto 0)
    );
end entity stim_gen;

architecture behavioral of stim_gen is
    signal q:             std_logic_vector(15 downto 0);
    signal n1, n2, n3:    std_logic;
begin
    process (rst_i, clk_250_i) -- ADDED rst_i to sensitivity list
    begin
        if rst_i = '1' then 
            q <= "1001101001101010";
        elsif rising_edge(clk_250_i) then
            if random_flag = '1' then
                -- REMOVED intermediary products as flip flops
                q <= q(14 downto 0) & n3;  -- REMOVED after 10 ns;
            end if;
        end if;
        
        
    end process;
    -- MOVED intermediary products to concurrent signal assignments:
    n1 <= q(15) xor q(13);
    n2 <= n1 xor q(11); --  REMOVED after 10 ns;
    n3 <= n2 xor q(10); --  REMOVED after 10 ns;

    random_data <= q;
end architecture behavioral;