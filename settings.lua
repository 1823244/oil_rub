Settings = class(function(acc)
end)
function Settings:Init()

	self.dark_theme = true
	
	self.brent_code = 'BRF7'
	self.brent_class = 'SPBFUT'
	
	self.usd_fut_code = 'SiZ6'
	self.usd_fut_class = 'SPBFUT'

	self.usd_cets_code = 'USD000UTSTOM'
	self.usd_cets_class = 'CETS'
	
	----------------------------------------------------
	--MAIN OPTION!!!!! switch between FORTS and SELT
	self.use_usd_fut = false --if false then we use CETS
	----------------------------------------------------
	----------------------------------------------------
	
	
	if self.use_usd_fut == false then
		self.usd_code = self.usd_cets_code
		self.usd_class = self.usd_cets_class
	else
		self.usd_code = self.usd_fut_code
		self.usd_class = self.usd_fut_class
	end
	
end