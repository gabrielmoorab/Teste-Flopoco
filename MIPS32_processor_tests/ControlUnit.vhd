library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Port ( opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           RegWrite : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           RegDst : out STD_LOGIC;
           Branch : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is
begin
    process(opcode)
    begin
        -- Default values
        RegWrite <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUSrc   <= '0';
        RegDst   <= '0';
        Branch   <= '0';
        ALUOp    <= "00";

        case opcode is
            when "000000" => -- R-type instructions (add, sub, and, or)
                RegDst   <= '1';
                ALUSrc   <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                MemRead  <= '0';
                MemWrite <= '0';
                Branch   <= '0';
                ALUOp    <= "10";

            when "100011" => -- lw (load word)
                RegDst   <= '0';
                ALUSrc   <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                MemRead  <= '1';
                MemWrite <= '0';
                Branch   <= '0';
                ALUOp    <= "00"; -- ALU adds for address calculation

            when "101011" => -- sw (store word)
                ALUSrc   <= '1';
                RegWrite <= '0';
                MemRead  <= '0';
                MemWrite <= '1';
                Branch   <= '0';
                ALUOp    <= "00"; -- ALU adds for address calculation

            when "000100" => -- beq (branch if equal)
                ALUSrc   <= '0';
                RegWrite <= '0';
                MemRead  <= '0';
                MemWrite <= '0';
                Branch   <= '1';
                ALUOp    <= "01"; -- ALU subtracts to check for equality

            when others =>
                -- Keep default values for unsupported instructions
        end case;
    end process;
end Behavioral;
