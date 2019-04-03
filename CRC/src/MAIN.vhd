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

	type STATE is (st1,st2,st3);
	signal st : STATE := st1;
	signal N : integer :=8;
	signal COUNT : integer :=0;
	signal MAX : integer :=32+N;
	signal R : std_logic_vector(N-1 downto 0):= X"00";
	signal M : std_logic_vector(0 to 32):=X"5F0E3C1700"  ;
	begin

	CRC: process (C)

	begin
		if C'event and C='1' then
			if st=st1 then
				--R(15 downto 1)<=R(N-2 downto 0);
				--R(15)<=R(15) xor R(14);
				--R(2)<=R(1) xor R(15);
				--R(0)<= R(15) xor M(COUNT);


				R(7)<=R(7) xor R(6);
				R(6)<=R(7) xor R(5);
				R(5)<=R(7) xor R(4);
				R(4)<=R(7) xor R(3);
				R(3)<=R(7) xor R(2);
				R(2)<=R(1);
				R(1)<=R(7) xor R(0);
				R(0)<= R(7) xor M(COUNT);


				--R(0)<= R(15) xor INPUT;
				COUNT<=COUNT+1;
			end if;
			if st=st2 then
				M(MAX-N to MAX-1)<=R;
				COUNT<=0;
				M(MAX-4)<= not M(MAX-4);
				R<=X"00";
			end if;

		end if;
	end process;



	PROCESS (st,R,COUNT,C)
BEGIN
	if C'event  then
	CASE st IS
		WHEN st1 =>
		if COUNT = MAX then
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