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
        RegWrite <= '0'; MemRead  <= '0'; MemWrite <= '0';
        MemtoReg <= '0'; ALUSrc   <= '0'; RegDst   <= '0';
        Branch   <= '0'; ALUOp    <= "00";

        case opcode is
            when "000000" => -- R-type
                RegDst <= '1'; ALUOp <= "10"; RegWrite <= '1';
            when "100011" => -- lw
                ALUSrc <= '1'; MemtoReg <= '1'; RegWrite <= '1'; MemRead <= '1';
            when "101011" => -- sw
                ALUSrc <= '1'; MemWrite <= '1';
            when "000100" => -- beq
                Branch <= '1'; ALUOp <= "01";
            when "001000" => -- addi
                ALUSrc <= '1'; RegWrite <= '1'; ALUOp <= "00";
            when others => null; -- Keep defaults for unsupported opcodes
        end case;
    end process;
end Behavioral;

-- Unidade que passa ordens aos outros componentes do processador
-- A unica entrada recebe apenas uma impormação "opcode" 6 bits
-- usando um case para decidir que instrução é essa, e as 9 saidas
-- são sinais de controle que comandam o restante do processo.
