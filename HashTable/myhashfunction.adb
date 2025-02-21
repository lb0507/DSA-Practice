
with Ada.Unchecked_Conversion;
package body MyHashFunction is

   pragma Suppress (overflow_check); --switch off overflow checks

   function ToLongLongInt is new
     Ada.Unchecked_Conversion (Source =>character, Target=> Long_Long_Integer);
   
   function ToInt is new
     Ada.Unchecked_Conversion (Source =>Long_Long_Integer, Target=> Integer);
   
   A, A1, A2, firstChar, secondChar, thirdChar, fourthChar, HA: long_long_integer:= 0;
  
    
   -- For my hash function, I will be using the Square and Extract N bits technique
   -- on the first four characters of the key.
   -- I will then use divide and take the remainder + 1 to ensure that the Hash 
   -- Address stays between 1 and 128
 
   procedure myHash(word: in String; HashAddr: out Integer) is
   begin
      
      firstChar:= ToLongLongInt(word(word'First)); --get value of 1st character
      secondChar:= ToLongLongInt(word(word'First + 1));--get value of 2nd character
      thirdChar:= ToLongLongInt(word(word'First + 2)); --get value of 3rd character
      fourthChar:= ToLongLongInt(word(word'First + 3));--get value of 4th character
      
      --concatenate values of characters 1 and 2
      if secondChar < 100 then 
          A1 := firstChar * 100 + secondChar; 
      else
          A1 := firstChar * 1000 + secondChar; 
      end if;
     
      --concatenate values of characters 3 and 4
      if fourthChar < 100 then 
          A2 := thirdChar * 100 + fourthChar; 
      else
          A2 := thirdChar * 1000 + fourthChar; 
      end if;
        
      --concatenate the two resulting integers to get final sum of string
      if A2 < 10000 then 
          A := A1 * 10000 + A2; 
      elsif (A2 < 100000) and (A2 >= 10000) then 
         A := A1 * 100000 + A2; 
      else
         A := A1 * 1000000 + A2;
      end if;
 
      HA := (A**2); --square the sum
     
      HA := HA * 2**11; -- Get rid of 11 high order bits, shift left 11.
     
      HA := abs(HA / 2**23); -- shift right 23
     
      HA := (HA mod 128) + 1; -- ensure the HA is between 1 and 128
       
      hashAddr:= ToInt(HA); -- return resulting hash address

   end myHash;   

end MyHashFunction;
