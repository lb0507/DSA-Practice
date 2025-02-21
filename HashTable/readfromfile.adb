with Ada.Text_IO; use Ada.Text_IO;
package body ReadFromFile is

  fileIn: File_Type;  
  word: String(1..16);
   
  function findKey (pt: in integer ) return String is
  begin
   
      Open(File=>fileIn, Mode=> In_File, --To read given file
      Name =>"200Words.txt");  -- renamed, orignially "Words200D16.txt"
                               
      if pt /= 1 then -- skip the loop, we are taking the first line
        
         for j in 1..(pt-1) loop --skip to the line we want to read
             skip_Line(fileIn);
         end loop;
      end if;
   
      get(fileIn,word);   
      close(File => fileIn);
      
      return word; --return the string at line pt
   
  end findKey;

end ReadFromFile;
