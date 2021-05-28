ITEM.name = "Stackable Miscellaneous"

ITEM.stackMax = 32

if SERVER then
	function ITEM:OnRegistered()
		self:SetData("stackSize", self:GetData("stackSize", 1))
	end
else
	function ITEM:PaintOver(item, w, h)
		local stack = item:GetData("stackSize", 1)

		draw.SimpleText(
			stack .. "/" .. item.stackMax, "DermaDefault", 5, h - 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black
		)
	end
end