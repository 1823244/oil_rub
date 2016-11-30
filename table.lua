--operations with main table

MainTable = class(function(acc)
end)

function MainTable:Init()
  self.t = nil --ID of table
end


 
--clean main table
function MainTable:clearTable()

  for row = self.t:GetSize(self.t.t_id), 1, -1 do
    DeleteRow(self.t.t_id, row)
  end  
  
end

-- SHOW MAIN TABLE

--show main table on screen
function MainTable:showTable()

  self.t:Show()
  
end

--creates main table
function MainTable:createTable(caption)

  -- create instance of table
  local t = QTable.new()
  if not t then
    message("error!", 3)
    return
  else
    --message("table with id = " ..t.t_id .. " created", 1)
  end
  
  t:AddColumn("secCode",    	QTABLE_CACHED_STRING_TYPE, 15)  
  t:AddColumn("classCode",  	QTABLE_CACHED_STRING_TYPE, 8)  
  t:AddColumn("lot",  		 	QTABLE_INT_TYPE, 7)
  
  t:AddColumn("price",  		QTABLE_DOUBLE_TYPE, 15)     
  t:AddColumn("quantity",   	QTABLE_INT_TYPE, 10)        
  t:AddColumn("amount",    		QTABLE_DOUBLE_TYPE, 10)     
  
  --collateral
  t:AddColumn("buyDepo",    	QTABLE_DOUBLE_TYPE, 15)      --buyer
  t:AddColumn("sellDepo",    	QTABLE_DOUBLE_TYPE, 15)     -- seller

  t:AddColumn("timeUpdate",  	QTABLE_STRING_TYPE, 15)     
  
  t:SetCaption(caption)
  
  return t
  
end

--creates tables that belongs to this class
function MainTable:createOwnTable(caption)
	local t = self:createTable(caption)
	self.t = t
end

