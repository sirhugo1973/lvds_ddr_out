--==============================================================
--fibrisTerre
--==============================================================
--
--unit name: util_pkg.vhd
--
--author: Nathan Boyles (nathanh.boyles@gmail.com)
--
--date created: 16-07-2023
--
--version: 0.1
--
--description:
	--Utilities Package
--dependencies:
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



package util_pkg is 

	procedure clk_240(signal clk_240_o: out std_logic;
							signal clk_running_o: out boolean;
							c_NUM_CYCLES: integer:=512);

end util_pkg;

package body util_pkg is

	procedure clk_240(signal clk_240_o: out std_logic;
							signal clk_running_o: out boolean;
							c_NUM_CYCLES: integer:=512) is
							
				--~240MHz
				begin
				clk_running_o<=TRUE;
				for i in 1 to c_NUM_CYCLES loop
					clk_240_o<='1';
					wait for 2.079 ns;
					clk_240_o<='0';
					wait for 2.079 ns;
				end loop;
				clk_running_o<=FALSE;
				wait;
	end clk_240;

end util_pkg;