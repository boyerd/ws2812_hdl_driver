----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:06:50 03/29/2014 
-- Design Name: 
-- Module Name:    ws2812_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ws2812_gen is
    Port ( clk : in  STD_LOGIC;
           g : in  STD_LOGIC_VECTOR (7 downto 0);
           r : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           dout : out  STD_LOGIC);
end ws2812_gen;

architecture Behavioral of ws2812_gen is

    type state_type is ( BNK, GRN, RED, BLU );
    signal state : state_type := BNK;

    signal bytebuf : std_logic_vector (7 downto 0);

begin

    process (clk)    
        variable cntr : natural range 0 to 9 := 0;
        variable period : natural range 0 to 400 := 0;
        variable hightime : natural range 0 to 255 := 0;
    begin

        if (rising_edge(clk)) then
            case state is
                when BNK =>
                    if (cntr = 0) then
                        state <= GRN;
                        bytebuf <= g;
                        cntr := 9;
                        period := 0;
                    else
                        if (period = 0) then
                            cntr := cntr - 1;
                            period := 315;
                        else
                            period := period - 1;
                        end if;
                    end if;

               when GRN =>
                   if (cntr = 0) then
                       -- all bits transmitted, next state
                       bytebuf <= r;
                       cntr := 9;
                       state <= RED;
                        period := 0;

                   else
                       if (period = 0) then
                           --period over, load next bit
                           bytebuf <= bytebuf(6 downto 0) & '0';
                           cntr := cntr - 1;
                           if (bytebuf(7) = '1') then
                               period := 65;
                               hightime := 35;
                           else
                               period := 58;
                               hightime := 18;
                           end if;
                       else
                           -- on current bit
                           if (hightime = 0) then
                               dout <= '0';
                           else
                               hightime := hightime - 1;
                               dout <= '1';
                           end if;
                           period := period - 1;
                       end if;
                   end if;

               when RED =>
                   if (cntr = 0) then
                       -- all bits transmitted, next state
                       bytebuf <= b;
                       cntr := 9;
                       state <= BLU;
                        period := 0;
                   else
                       if (period = 0) then
                           --period over, load next bit
                           bytebuf <= bytebuf(6 downto 0) & '0';
                           cntr := cntr - 1;
                           if (bytebuf(7) = '1') then
                               period := 65;
                               hightime := 35;
                           else
                               period := 58;
                               hightime := 18;
                           end if;
                       else
                           -- on current bit
                           if (hightime = 0) then
                               dout <= '0';
                           else
                               hightime := hightime - 1;
                               dout <= '1';
                           end if;
                           period := period - 1;
                       end if;
                   end if;

               when BLU =>
                   if (cntr = 0) then
                       -- all bits transmitted, next state
                       cntr := 9;
                       state <= BNK;
                        period := 0;
                   else
                       if (period = 0) then
                           --period over, load next bit
                           bytebuf <= bytebuf(6 downto 0) & '0';
                           cntr := cntr - 1;
                           if (bytebuf(7) = '1') then
                               period := 65;
                               hightime := 35;
                           else
                               period := 58;
                               hightime := 18;
                           end if;
                       else
                           -- on current bit
                           if (hightime = 0) then
                               dout <= '0';
                           else
                               hightime := hightime - 1;
                               dout <= '1';
                           end if;
                           period := period - 1;
                       end if;
                   end if;
            end case;
        end if;


    end process;

end Behavioral;

