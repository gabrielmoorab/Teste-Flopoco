library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionMemory is
	port (
		Address     : in STD_LOGIC_VECTOR(31 downto 0);
		Instruction : out STD_LOGIC_VECTOR(31 downto 0)
	);
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    type Memory is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    -- Programa de demonstração FP:
    -- DMem(0) = 1.5f (0x3FC00000), DMem(1) = 2.0f (0x40000000)
    -- 0: lw   $1, 0($0)          ; $1 = 1.5f
    -- 1: lw   $2, 1($0)          ; $2 = 2.0f
    -- 2: fadd.s $3, $1, $2       ; $3 = 3.5f
    -- 3: sw   $3, 2($0)          ; MEM[2] = 3.5f (0x40600000)
    -- 4: fmul.s $4, $1, $2       ; $4 = 3.0f
    -- 5: sw   $4, 3($0)          ; MEM[3] = 3.0f (0x40400000)
    -- 6..: NOPs
    signal IMem : Memory := (
	    X"8C010000", -- lw  $1, 0($0)
	    X"8C020001", -- lw  $2, 1($0)
	    X"7C221800", -- fadd.s $3,$1,$2  (opcode=0x1F, funct=0x00)
	    X"AC030002", -- sw  $3, 2($0)
	    X"7C222002", -- fmul.s $4,$1,$2  (opcode=0x1F, funct=0x02)
	    X"AC040003", -- sw  $4, 3($0)
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000",
	    X"00000000"
    );

begin

	process (Address)
	begin
		Instruction <= IMem(TO_INTEGER(UNSIGNED(Address)) / 4);
	end process;

end Behavioral;
