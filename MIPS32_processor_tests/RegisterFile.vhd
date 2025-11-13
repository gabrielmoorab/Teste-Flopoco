library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port ( clk : in STD_LOGIC;
           reg_write : in STD_LOGIC;
           read_reg1 : in STD_LOGIC_VECTOR (4 downto 0);
           read_reg2 : in STD_LOGIC_VECTOR (4 downto 0);
           write_reg : in STD_LOGIC_VECTOR (4 downto 0);
           write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_data1 : out STD_LOGIC_VECTOR (31 downto 0);
           read_data2 : out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;
architecture Behavioral of RegisterFile is
type reg_array is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
signal registers : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reg_write = '1' then
                registers(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
    read_data1 <= registers(to_integer(unsigned(read_reg1)));
    read_data2 <= registers(to_integer(unsigned(read_reg2)));
end Behavioral;


--  Memoria de trabalho principal do processador
--  Banco de registradores de 3 portas, permite 3 acessos independentes ao mesmo tempo;
-- (Ex: add $t2, $t0, $t1 (Some $t0 e $t1 e salve em $t2)
--  a ALU só pode operar em dados que estão dentro deste Banco de Registradores.
