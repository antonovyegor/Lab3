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
	type STATE is (st1,st2,st3);
	signal st : STATE := st1;
	--signal shl_signal : std_logic;
	--signal xor_signal : std_logic;
	signal COUNT : integer :=0;
	signal M : std_logic_vector(0 to 47):=X"9B0E2C670000"  ;
	begin

	CRC: process (C)

	begin
		if C'event and C='1' then
			if st=st1 then
				R(15 downto 1)<=R(14 downto 0);
				R(15)<=R(15) xor R(14);
				R(2)<=R(1) xor R(15);
				R(0)<= R(15) xor M(COUNT);
				COUNT<=COUNT+1;
			end if;
			if st=st2 then
				M(47-15 to 47)<=R;
				COUNT<=0;
				M(45)<= not M(45);
				R<=X"0000";
			end if;

		end if;
	end process;



	PROCESS (st,R,COUNT,C)
BEGIN
	if C'event  then
	CASE st IS
		WHEN st1 =>
		if COUNT = 48 then
			st<=st2;
		else st<=st1;
			end if;
		WHEN st2 =>
			st <= st1;
		when others => st<=st3;

	END CASE;
	end if;
END PROCESS;

end BEH;