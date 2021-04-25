PANEL = {}

function PANEL:Init()
    self:SetSize(870, 750)
    self:Hide()

    self.color = ix.config.Get("color")
    self.backgroundColor = Color(0, 0, 0, 225)

    self.state = "idle"

    self:DrawIdle()
end

function PANEL:GetState()
    return self.state
end

function PANEL:Delay(callback)
    timer.Simple(0.5, function()
        callback()
    end)
end

function PANEL:Cleanup()
    for _, child in ipairs(self:GetChildren()) do
        child:Remove()
    end
end

function PANEL:DrawIdle()
    local mat = Schema.logo and ix.util.GetMaterial(Schema.logo)

    if mat and not mat:IsError() then
        local logo = self:Add("DImage")
        logo:SetMaterial(mat)
        logo:SetSize(mat:Width() / 2, mat:Height() / 2)
        logo:SetImageColor(self.color)
        logo:Center()
    else
        local logo = self:Add("DLabel")
        logo:SetFont("ixIntroTitleBlurFont")
        logo:SetContentAlignment(5)
        logo:SetText("ATM")
        logo:SetWide(self:GetWide())
        logo:SetTall(200)
        logo:Center()
    end

    local start = self:Add("ixAtmMenuButton")
    start:SetText("Start")
    start:SetWide(self:GetWide())
    start:SetTall(200)
    start:CenterHorizontal()
    start:SetPos(0, self:GetTall() - start:GetTall())

    start.Paint = function(_, w, h)
        surface.SetDrawColor(self.color)
        surface.DrawOutlinedRect(0, 0, w, h, 10)
    end

    start.DoClick = function()
        self:Cleanup()
        self:Delay(function()
            self:DrawOptions()
        end)
    end
end

function PANEL:DrawOptions()
    self.state = "options"

    local layout = self:Add("DListLayout")
    layout:Dock(FILL)

    self.optionsLayout = layout

    local label = layout:Add("DLabel")
    label:SetFont("ixIntroTitleBlurFont")
    label:SetText("Balance:")
    label:SetContentAlignment(5)
    label:SetTall(self:GetTall() / 4)

    local balance = layout:Add("DLabel")
    balance:SetFont("ixIntroTitleBlurFont")
    balance:SetContentAlignment(5)
    balance:SetText(ix.currency.symbol .. string.Comma(LocalPlayer():GetCharacter():GetBankMoney()))
    balance:SetTall(175)

    local deposit = layout:Add("ixAtmMenuButton")
    deposit:SetTall(self:GetTall() / 4)
    deposit:SetText("Deposit")

    deposit.Paint = function(_, w, h)
        surface.SetDrawColor(self.color)
        surface.DrawRect(0, 0, w, h)
    end

    deposit.DoClick = function()
        self:Cleanup()
        self:Delay(function()
            self:DrawDeposit()
        end)
    end

    local withdraw = layout:Add("ixAtmMenuButton")
    withdraw:SetTall(self:GetTall() / 4)
    withdraw:SetText("Withdraw")

    withdraw.Paint = function(_, w, h)
        surface.SetDrawColor(self.color)
        surface.DrawRect(0, 0, w, h)
    end

    withdraw.DoClick = function()
        self:Cleanup()
        self:Delay(function()
            self:DrawWithdraw()
        end)
    end
end

function PANEL:DrawDeposit()
    self.state = "deposit"

    local entry = self:Add("ixTextEntry")
    entry:SetFont("ixIntroTitleBlurFont")
    entry:SetWide(self:GetWide())
    entry:Center()
    entry:SetBackgroundColor(self.color)

    self.entry = entry
end

function PANEL:DrawWithdraw()
    self.state = "withdraw"

    local entry = self:Add("ixTextEntry")
    entry:SetFont("ixIntroTitleBlurFont")
    entry:SetWide(self:GetWide())
    entry:Center()
    entry:SetBackgroundColor(self.color)

    self.entry = entry
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(self.backgroundColor)
    surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixAtmScreen", PANEL, "Panel")