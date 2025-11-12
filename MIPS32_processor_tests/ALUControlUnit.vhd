library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControlUnit is
    Port ( ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0));
end ALUControlUnit;

architecture Behavioral of ALUControlUnit is
begin
    process(ALUOp, funct)
    begin
        case ALUOp is
            when "00" => -- For lw and sw
                ALUControl <= "0000"; -- Addition for address calculation
            when "01" => -- For beq
                ALUControl <= "0001"; -- Subtraction for comparison
            when "10" => -- For R-type, check funct field
                case funct is
                    when "100000" => ALUControl <= "0000"; -- add
                    when "100010" => ALUControl <= "0001"; -- sub
                    when "100100" => ALUControl <= "0010"; -- and
                    when "100101" => ALUControl <= "0011"; -- or
                    when others   => ALUControl <= "0000"; -- Default to add
                end case;
            when others =>
                ALUControl <= "0000"; -- Default to add
        end case;
    end process;
end Behavioral;

-- Ponte entre a unidade de controle principal do processador e a ALU.
-- FUnciona verificando os sinais da instrução em MIPS e decidindo qual comando
-- de 4 bits (ALUControl) deve enviar para a ALU.

-- ALUOP: sinalsimplificado vindo do controle principal, diz a categoria da operação

-- funct(6 bits): E um pedaço da propria instrução MIPS(os 6 bits finais), usado apenas
-- para instruções do tipo-R

-- instruções ALUOp :
    -- lw/sw: 00,  somam um endereço base e um deslocamentoi.
    -- beq: 01, compara dois registradores
    -- Tipo-r: 10,  ass, sub, and, or
