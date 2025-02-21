
with Ada.Text_IO;
with RandomInteger; Use RandomInteger;
with ReadFromFile; use ReadFromFile;
with MyHashFunction; use MyHashFunction;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use  Ada.Numerics.Elementary_Functions;

procedure Myhashmain is

   type rec is record
      key:String(1..16);
      initial_hashaddress: integer;
      numProbes:integer;
   end record;
   hashTable: array(1..128) of rec;
   word, empty:String(1..16) := "Empty           ";

   package IIO is new Ada.text_io.Integer_IO(Integer);
   use IIO;


   fileOut: Ada.Text_IO.File_Type;
   rec1: rec;
   tempRec: rec;
   inserted, found: boolean:= false;
   hashAddr, OriginalHA, f, l: Integer:= 0;
   minProbes: integer := 1000;
   maxProbes, SumOfProbes: integer := 0;
   AvgProbes, Linear_Theoretical, Random_Theoretical: float:= 0.0;

   begin
     -- Iitialize hash file empty with table size = 128
     rec1.key := empty;
     rec1.initial_hashaddress := 1;
     rec1.numProbes := 0;

     for pt in 1..128 loop
         hashTable( pt ) := rec1;
     end loop;

     --create .txt file to print output to
     Ada.Text_IO.Create(File=>fileOut, Mode=> Ada.Text_IO.Out_File, Name => "AMyOutput");-- LabB_MyHashFunction

     Ada.Text_IO.put(fileOut, "------------------------------------Linear Probing------------------------------------");
     Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, ASCII.LF);

    -- Hash 100 keys from the file using linear probe collision handling

     for pt1 in 1..100 loop

           word:= (findKey(pt1)); -- call function from package ReadFromFile
                                -- to get the 16-character string from the file
           rec1.key := word;
           myHash(word, hashAddr);   -- get hash address using procedure myHash
           rec1.initial_hashaddress:= hashAddr; -- and store it within the record
           inserted := false;
           rec1.numProbes:= 0;           --reset number of probes for next key
           While (inserted = false) loop --insert into hash table
                 tempRec := hashTable( hashAddr );
                 rec1.numProbes:= rec1.numProbes + 1; --count number of probes
                -- Linear Collision Handling
                if(tempRec.key = empty) then -- we found a vacant spot
                     hashTable( hashAddr ) := rec1; -- so we store the record in it
                     inserted := true;
                else --Linear collision handling
                     if hashAddr = 128 then --wrap around to beginning of table
                         hashAddr:= 1;
                     else
                         hashAddr := hashAddr + 1; --move to the next spot
                     end if;
                end if;
           end loop;
     end loop;

   --Here I found the min, max, and avg number of probes for the first and last 25
   --keys hashed into the table using linear probing.

   for loopThrough in 1..2 loop

       if loopThrough = 1 then -- the first loop is for the first 25 keys
           f:= 1;
           l:= 25;
           Ada.Text_IO.put(fileOut, "First 25 keys: "); Ada.Text_IO.put(fileOut, ASCII.LF);
       else       -- the second loop is for the last 25 keys
           f:= 75;
           l:= 100;
           SumOfProbes:= 0;
           Ada.Text_IO.put(fileOut, "Last 25 keys: "); Ada.Text_IO.put(fileOut, ASCII.LF);
       end if;
         --reset the statistics
       minProbes:= 1000;
       maxProbes:= 0;
       for pt2 in f..l loop -- set range, either 1..25 or 75..100

            word:= (findKey(pt2));      --get string at line pt2 from file
            myHash(word, hashAddr); --calculate hash address
            found:= false;
            While found = false loop
                  rec1 := hashTable( hashAddr );

                  if rec1.key = word then      --find the max number of probes
                      if (rec1.numProbes > maxProbes) then
                          maxProbes:= rec1.numProbes;
                      end if;

                      if (rec1.numProbes < minProbes) then --find the min number of probes
                          minProbes:= rec1.numProbes;
                      end if;

                      SumOfProbes:= SumOfProbes + rec1.numProbes; -- find the cumulative sum of probes
                      found := true;
                  else
                    --Linear Collision Handling
                      if hashAddr = 128 then --wrap around to beginning of table
                         hashAddr:= 1;
                      else
                         hashAddr := hashAddr + 1; --move to next spot in table
                      end if;
                  end if;
            end loop;
       end loop;

       AvgProbes:=(float(SumOfProbes)/25.0); --calculate the average number of probes
       --print the statistics
       Ada.Text_IO.put(fileOut, ASCII.LF);
       Ada.Text_IO.put(fileOut, "Minimum # of probes: "); put(fileOut, minProbes); Ada.Text_IO.put(fileOut, ASCII.LF);
       Ada.Text_IO.put(fileOut, "Maximum # of probes: "); put(fileOut, maxProbes); Ada.Text_IO.put(fileOut, ASCII.LF);
       Ada.Text_IO.put(fileOut, "Average # of probes: "); Ada.Text_IO.Put_Line(fileOut, Float'Image (AvgProbes));
       Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, ASCII.LF);
   end loop;

   --Print Entire Hash Table including the final hash address, key, original hash address
   --and number of probes needed to find each key
   for pt4 in 1..128 loop
         rec1 := hashTable( pt4 );
         IIO.put(fileOut, Pt4, 3 );  Ada.Text_IO.put(fileOut, "  ");
         for J in 1..16 loop Ada.Text_IO.put(fileOut, rec1.key(J)); end loop;
         iio.put(fileOut, rec1.initial_hashaddress); Ada.Text_IO.put(fileOut, "   ");
         iio.put(fileOut, rec1.numProbes);
         Ada.Text_IO.put(fileOut, ASCII.LF);
   end loop;

   --calculate and print the theoretical expected number of probes

   Linear_Theoretical := float((1.0 - (100.0/128.0)/ 2.0 ) / ( 1.0 - (100.0/128.0)));

   Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, "Theoretical expected # of probes:" );

   Ada.Text_IO.Put_Line(fileOut, Float'Image(Linear_Theoretical)); Ada.Text_IO.put(fileOut, ASCII.LF);


   -- Search for all 100 Keys in table and calculate actual average

   SumOfProbes:= 0; -- reset the sum of the # of probes to 0
   for pt5 in 1..100 loop

       found:= false;
       word:= (findKey(pt5)); --get string from file
       myHash(word, hashAddr); --get hash address

       --Linear Probing Collision Handling
       While found = false loop
             rec1 := hashTable( hashAddr );
             if rec1.key = word then
                 SumOfProbes:= SumOfProbes + rec1.numProbes;
                 found := true;
             else
                 if hashAddr = 128 then --wrap around
                     hashAddr:= 1;
                 else
                     hashAddr := hashAddr + 1; --move to next spot
                 end if;
             end if;
       end loop;
   end loop;
   AvgProbes:=(float(SumOfProbes)/100.0); --calculate average and print
   Ada.Text_IO.put(fileOut, "Average # of probes: ");
   Ada.Text_IO.Put_Line(fileOut, Float'Image (AvgProbes)); Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.Put_Line(Integer'Image(SumOfProbes));


   ---------------------------------------------------------------------

   -- Random Probe Collision Handling

   -- re-initialize table
   rec1.key := empty;
   rec1.initial_hashaddress := 1;
   rec1.numProbes := 0;

   for pt in 1..128 loop
       hashTable( pt ) := rec1;
   end loop;

   Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.put(fileOut, "------------------------------------Random Probing------------------------------------");
   Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, ASCII.LF);

   --hash 100 keys into the table using random collision handling
   for pt1 in 1..100 loop

       word:= (findKey(pt1)); -- get 16-character string from file
       rec1.key := word;      --store key
       myHash(word, hashAddr);  --calculate hash address
       rec1.initial_hashaddress:= hashAddr;--store original hash address
       inserted := false;
       rec1.numProbes:= 0;     --reset number of probes

       OriginalHA := hashAddr; --store the original hash function for collision handling
       InitialRandInteger;   --intialize the random number generator
       While (inserted = false) loop
                                          --insert into hash table
         tempRec := hashTable(hashAddr);

             rec1.numProbes:= rec1.numProbes + 1; --increment probe count

             if (tempRec.key = empty) then  -- we found a vacant spot

                 hashTable( hashAddr ) := rec1; -- so we store the record in it
                 inserted := true;
             else                         --A collision has occurred.
                 hashAddr := OriginalHA + UniqueRandInteger; --calculate new
                 if hashAddr > 128 then                        --hash address adding random offset to
                      hashAddr:= hashAddr - 128;               --the original hash address
                     -- if it exceeds the table size, we subtract the table size
                 end if;
             end if;
       end loop;
   end loop;

   --Here I found the min, max, and avg number of probes for the first and last 25
   --keys hashed into the table using random probing.

   for loopThrough in 1..2 loop

      if loopThrough = 1 then -- the first loop is for the first 25 keys
          f:= 1;
          l:= 25;
          Ada.Text_IO.put(fileOut, "First 25 keys: "); Ada.Text_IO.put(fileOut, ASCII.LF);
      else                    -- the second loop is for the last 25 keys
          f:= 75;
          l:= 100;
          Ada.Text_IO.put(fileOut, "Last 25 keys: "); Ada.Text_IO.put(fileOut, ASCII.LF);
      end if;
      minProbes:= 1000;   --reset the statistics
      maxProbes:= 0;
      SumOfProbes:= 0;
      for pt2 in f..l loop  -- set range, either 1..25 or 75..100

          InitialRandInteger; --initialize random number generator
          word:= (findKey(pt2));        -- get string from line pt2 in file and use it to
          myHash(word, hashAddr);-- calculate the hash address
          OriginalHA := hashAddr;  --store hash address for collision handling
          found:= false;
          While found = false loop --loop until desired key is found

                rec1 := hashTable(hashAddr); --read record at hash address
                if rec1.key = word then --found desired key

                    if (rec1.numProbes > maxProbes) then --find max probes
                        maxProbes:= rec1.numProbes;
                    end if;

                    if (rec1.numProbes < minProbes) then --find min probes
                        minProbes:= rec1.numProbes;
                    end if;

                    SumOfProbes:= SumOfProbes + rec1.numProbes; --find sum of probes
                    found := true;
                else --Random Collision Handling
                    hashAddr := OriginalHA + UniqueRandInteger;
                    if hashAddr > 128 then
                        hashAddr:= hashAddr - 128;
                    end if;
                end if;
          end loop;
      end loop;

   AvgProbes:=(float(SumOfProbes)/25.0); --calculate average number of probes

   --print the statistics
   Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.put(fileOut, "Minimum # of probes: "); put(fileOut, minProbes); Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.put(fileOut, "Maximum # of probes: "); put(fileOut, maxProbes); Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.put(fileOut, "Average # of probes: "); Ada.Text_IO.Put_Line(fileOut, Float'Image (AvgProbes)); Ada.Text_IO.put(fileOut, ASCII.LF);
   Ada.Text_IO.put(fileOut, ASCII.LF);
   end loop;

   Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, ASCII.LF); --print new lines for readability

   -- Print Entire Hash Table including hash address, key, initial hash address,
   -- and number of probes needed for each key

   for pt4 in 1..128 loop
       rec1 := hashTable( pt4 ); --get record from position pt4 in the table
       IIO.put(fileOut, Pt4, 3 );  Ada.Text_IO.put(fileOut, "  ");
       for J in 1..16 loop Ada.Text_IO.put(fileOut, rec1.key(J)); end loop;
       iio.put(fileOut, rec1.initial_hashaddress); Ada.Text_IO.put(fileOut, "   ");
       iio.put(fileOut, rec1.numProbes);
       Ada.Text_IO.put(fileOut, ASCII.LF);
   end loop;
   --calculate and print the theoretical
   Random_Theoretical := (-1.0)*( 1.0 / (100.0/128.0)*Log( 1.0 - (100.0/128.0)));
   Ada.Text_IO.put(fileOut, ASCII.LF); Ada.Text_IO.put(fileOut, "Theoretical expected # of probes:" );

   Ada.Text_IO.Put_Line(fileOut, Float'Image(Random_Theoretical)); Ada.Text_IO.put(fileOut, ASCII.LF);

    --Search for all 100 Keys in table and calculate average probes

   SumOfProbes:= 0; -- reset the sum of the # of probes to 0
   for pt5 in 1..100 loop
      found:= false;
      word:= (findKey(pt5)); --get string and calculate hash address
      myHash(word, hashAddr);
      OriginalHA := hashAddr; -- store original hash address
      InitialRandInteger;   -- and initialize random number generator
      While found = false loop
          rec1 := hashTable(hashAddr);
          if rec1.key = word then -- found key
              SumOfProbes:= SumOfProbes + rec1.numProbes; --increment sum
              found := true;
          else
               --Random Collision Handling
              hashAddr := OriginalHA + UniqueRandInteger;
              if hashAddr > 128 then
                  hashAddr:= hashAddr - 128;
              end if;
          end if;
      end loop;
   end loop;
   Ada.Text_IO.Put_Line(Integer'Image(SumOfProbes));
   AvgProbes:=(float(SumOfProbes)/100.0); --calculate and print average
   Ada.Text_IO.put(fileOut, "Average # of probes: "); Ada.Text_IO.Put_Line(fileOut, Float'Image (AvgProbes));

   --close files
   Ada.Text_IO.close(fileOut);

end Myhashmain;
