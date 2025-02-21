package body randomInteger is

     R: Integer := 1;
  procedure InitialRandInteger is 
  begin  
      R := 1;   -- reset generator to seed
  end InitialRandInteger;

  function UniqueRandInteger return Integer is
     begin  R := (5 * R) Mod (2 ** (7 + 2)) + 1;  return R / 4; 
  end UniqueRandInteger;


end randomInteger;
