library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;


entity CRC is
	port (
	C: in std_logic;
	INPUT : in std_logic
	);

end entity;

architecture BEH of CRC is
signal R : std_logic_vector(15 downto 0):= X"0000";
--signal R : std_logic_vector(3 downto 0):= X"0";
	type STATE is (st1,st2,st3);
	signal st : STATE := st1;
	signal shl_signal : std_logic;
	signal xor_signal : std_logic;
	signal COUNT : integer :=0;
	signal M : std_logic_vector(0 to 47):=X"9B0E2C67B5B7"  ;
	--signal M : std_logic_vector(0 to 11):=X"D70"  ;
begin

	CRC: process (C)

	begin
		if C'event and C='1' then
			if shl_signal='1' then
				R(15 downto 1)<=R(14 downto 0);
				--R(3 downto 1)<=R(2 downto 0);
				R(0)<=M(COUNT);
				COUNT<=COUNT+1;
			end if;

			if xor_signal = '1' then
				R<= R xor X"8005";
				--R<= R xor X"5";
			end if;
	    end if;
	end process;



PROCESS (st,R,COUNT,C)
BEGIN
	if C'event and C='1' then
	CASE st IS
		WHEN st1 =>
			if COUNT > 32+16 then st<=st3;
			end if;

			IF R(15) = '1'
			--IF R(3) = '1'
				THEN st <= st2;
			ELSE
				st <= st1;
			END IF;
		WHEN st2 =>
			IF COUNT > 32+16
				THEN st <= st3;
				ELSE st <= st1;
			END IF;
		when others => st<=st3;

	END CASE;
	end if;
END PROCESS;
   shl_signal <='1' when st=st1 else '0' ;
   xor_signal <='1' when st=st2 else '0'  ;
end BEH;