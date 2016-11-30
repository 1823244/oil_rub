--отображение синтетики "Нефть в рублях"

--local sqlite3 = require("lsqlite3")
--эта dll нужна для работы с битовыми флагами сделок. там зашито направление buy/sell
--local bit = require"bit"

--пример из учебника по QLUA
dofile (getScriptPath() .. "\\quik_table_wrapper.lua")

dofile (getScriptPath() .. "\\class.lua")
dofile (getScriptPath() .. "\\helper.lua")
dofile (getScriptPath() .. "\\settings.lua")
dofile (getScriptPath() .. "\\table.lua")


-- классы
helper={}
settings={}
maintable={}

-- Константы --

-- Глобальные переменные --
local t = nil --таблица робота
local is_run = true

-- main module



--создает строки с инструментами в таблице робота
function load_instruments()
  --BRENT
  local r = maintable.t:AddLine()
  maintable.t:SetValue(r, 'secCode', settings.brent_code)
  maintable.t:SetValue(r, 'classCode', settings.brent_class)
  maintable.t:SetValue(r, 'lot', 10)
  
  maintable.t:SetValue(r, 'price', 0)
  maintable.t:SetValue(r, 'quantity', 0)
  maintable.t:SetValue(r, 'amount', 0)
  
  --USD
  local r = maintable.t:AddLine()
  maintable.t:SetValue(r, 'secCode', settings.usd_code)
  maintable.t:SetValue(r, 'classCode', settings.usd_class)
  maintable.t:SetValue(r, 'lot', 1)
  
  maintable.t:SetValue(r, 'price', 0)
  maintable.t:SetValue(r, 'quantity', 0)
  maintable.t:SetValue(r, 'amount', 0)
  
  --Стоимость в рублях. RUB
  local r = maintable.t:AddLine()
  maintable.t:SetValue(r, 'secCode', 'TOTAL')
  maintable.t:SetValue(r, 'classCode', 'RUB')
  maintable.t:SetValue(r, 'lot', '')
  
  maintable.t:SetValue(r, 'price', 0)
  maintable.t:SetValue(r, 'quantity', 0)
  maintable.t:SetValue(r, 'amount', 0)
    
end

function DestroyTables()
  is_run = false
  DestroyTable(maintable.t.t_id)
end

-- обработчики событий ----

function OnInit(s)

	helper= Helper()
	helper:Init()
	
	settings= Settings()
	settings:Init()


  maintable= MainTable()
  maintable:Init()

  
  --create and show table
  
  maintable:createOwnTable("OIL RUB")
  
  maintable:showTable()
  
  --message(settings.usd_code)
  
  load_instruments()
  
end

function OnStop(s)
  DestroyTables()
  is_run = false
  return 1000
end



-- +----------------------------------------------------+
--                  MAIN
-- +----------------------------------------------------+

-- функция обратного вызова для обработки событий в таблице. вызывается из main()
--(или, другими словами, обработчик клика по таблице робота)
--параметры:
--  t_id - хэндл таблицы, полученный функцией AllocTable()
--  msg - тип события, происшедшего в таблице
--  par1 и par2 – значения параметров определяются типом сообщения msg, 
--
--функция должна располагаться перед main(), иначе - скрипт не останавливается при закрытии окна
local f_cb = function( t_id,  msg,  par1, par2)
	if (msg==QTABLE_CLOSE)  then
		DestroyTables()
		is_run = false
	end
	if msg==QTABLE_VKEY then
		--par2 = 27 - esc
		--par2 = 13 - enter
		if par2 == 27 then
			DestroyTables()
		end
	end  
end 


function main()
	--set the callback handler
	SetTableNotificationCallback (maintable.t.t_id, f_cb)
	while is_run do  
		--get quotes
		price_brent = getParamEx (settings.brent_class, settings.brent_code, 'last').param_value
		price_usd = getParamEx (settings.usd_class, settings.usd_code, 'last').param_value
		--show quotes in table
		for row = 1, maintable.t:GetSize(maintable.t.t_id)  do
			if maintable.t:GetValue(row,'secCode').image == settings.brent_code then
				maintable.t:SetValue(row, 'price', price_brent)
				--collateral
				maintable.t:SetValue(row, 'buyDepo', helper:math_round(getParamEx(settings.brent_class, settings.brent_code, 'buydepo').param_value, 2))
				maintable.t:SetValue(row, 'sellDepo', helper:math_round(getParamEx(settings.brent_class, settings.brent_code, 'selldepo').param_value,2))
			end
			if maintable.t:GetValue(row,'secCode').image == settings.usd_code then
				maintable.t:SetValue(row, 'price', price_usd)
				--collateral
				if settings.usd_class == 'SPBFUT' then
					maintable.t:SetValue(row, 'buyDepo', helper:math_round(getParamEx(settings.usd_class, settings.usd_code, 'buydepo').param_value,2))
					maintable.t:SetValue(row, 'sellDepo', helper:math_round(getParamEx(settings.usd_class, settings.usd_code, 'selldepo').param_value,2))
				end
			end
			--totas in rub
			if maintable.t:GetValue(row,'secCode').image == 'TOTAL' then
				if settings.usd_class == 'SPBFUT' then
					price_usd = price_usd / 1000
				end		
				--вычислить стоимость в рублях
				local price_rub = helper:math_round(price_brent * price_usd, 2)
				maintable.t:SetValue(row, 'price', price_rub)
			end
			maintable.t:SetValue(row, 'timeUpdate', os.date()	)
		end
		
		--days_in_position('2016-11-24', '2016-11-29')
		
		sleep(1000)
	end
end



