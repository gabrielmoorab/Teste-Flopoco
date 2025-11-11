library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           ALUControl : in STD_LOGIC_VECTOR (3 downto 0);
           Result : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
end ALU;
architecture Behavioral of ALU is
begin
    process(A, B, ALUControl)
    begin
        case ALUControl is
            when "0000" => Result <= A + B;         -- Addition
            when "0001" => Result <= A - B;         -- Subtraction
            when "0010" => Result <= A and B;       -- AND
            when "0011" => Result <= A or B;        -- OR
            when others => Result <= (others => '0');
        end case;
        Zero <= '1' when Result = "00000000000000000000000000000000" else '0';
    end process;
end Behavioral;
