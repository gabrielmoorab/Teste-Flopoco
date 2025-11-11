library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataMemory is
    Port ( clk : in STD_LOGIC;
           mem_read : in STD_LOGIC;
           mem_write : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (31 downto 0);
           write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_data : out STD_LOGIC_VECTOR (31 downto 0));
end DataMemory;
architecture Behavioral of DataMemory is
type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
signal mem : memory_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                mem(to_integer(unsigned(address))) <= write_data;
            end if;
        end if;
    end process;
    read_data <= mem(to_integer(unsigned(address))) when mem_read = '1' else (others => '0');
end Behavioral;
