-- this is mostly to stop the hover sound, since 3d2d makes it do an endless loop
local buttonPadding = ScreenScale(14) * 0.5

DEFINE_BASECLASS("ixMenuButton")
local PANEL = {}

AccessorFunc(PANEL, "backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "backgroundAlpha", "BackgroundAlpha")

function PANEL:Init()
	self:SetFont("ixIntroTitleBlurFont")
	self:SetTextColor(color_white)
	self:SetPaintBackground(false)
	self:SetContentAlignment(5)
	self:SetTextInset(buttonPadding, 0)

	self.padding = {32, 12, 32, 12}
	self.backgroundColor = Color(0, 0, 0)
	self.hoverColor = ix.config.Get("color")
	self.backgroundAlpha = 128
	self.currentBackgroundAlpha = 0
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then
		return
	end

	local color = self.hoverColor
	self:SetTextColorInternal(Color(math.max(color.r - 25, 0), math.max(color.g - 25, 0), math.max(color.b - 25, 0)))

	self:CreateAnimation(0.15, {
		target = {currentBackgroundAlpha = self.backgroundAlpha}
	})
end

vgui.Register("ixAtmMenuButton", PANEL, "ixMenuButton")
