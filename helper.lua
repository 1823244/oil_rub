
Helper = class(function(acc)
end)

function Helper:Init()
  
end





--writes text to file
function Helper:save_sql_to_file(sql, filename)
   -- try to open file for read/write
   f = io.open(getScriptPath().."\\"..filename,"r+");
   --try to open file for append
   --f = io.open(getScriptPath().."\\"..filename,"a");
   --if file does not exist
   if f == nil then 
      -- creates file in 'write' mode
      f = io.open(getScriptPath().."\\"..filename,"w"); 
      -- close file
      f:close();
      -- try to open file for read/write
      f = io.open(getScriptPath().."\\sql.txt","r+");
		--try to open file for append
		--f = io.open(getScriptPath().."\\"..filename,"a");
   end;
   -- ���������� � ���� 2 ������
   --f:write("Line1\nLine2"); -- "\n" ������� ����� ������
   
   f:write(sql); -- "\n" ������� ����� ������
   
   
   -- save changes
   f:flush();
   -- ������ � ������ ����� 
      -- 1-�� ���������� �������� ������������ ���� ����� ��������: "set" - ������, "cur" - ������� �������, "end" - ����� �����
      -- 2-�� ���������� �������� ��������
   --f:seek("set",0);
   -- ���������� ������ �����, ������� �� ���������� � ����������
   --for line in f:lines() do message(tostring(line));end
   -- ��������� ����
   f:close();
end



--������� ���������� true, ���� ��� [index] ���������� � 1 (����� �� �������� some_callbacks.lua)
--������ ������ ��� ����������� �����������
--if bit_set(flags, 2) then
--		t["sell"]=1
--	else
--		t["buy"] = 1
--	end
--
function Helper:bit_set( flags, index )
  local n=1
  n=bit.lshift(1, index)
  if bit.band(flags, n) ~=0 then
    return true
  else
    return false
  end
end

--��������� ���������� � �������� ���������
--math.round(3.27893, 2) -- ������ ������� 3.28
function Helper:math_round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
 
