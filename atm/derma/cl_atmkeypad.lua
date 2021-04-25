local function DelayInput(button) -- yet another workaround for 3d2d
    button:SetMouseInputEnabled(false)

    timer.Simple(0.1, function()
        button:SetMouseInputEnabled(true)
    end)
end

local function AddValue(button, textentry, newVal)
    if not IsValid(textentry) then return end

    DelayInput(button)

    textentry:SetText(textentry:GetText() .. newVal)
end

local function RemoveValue(button, textentry)
    if not IsValid(textentry) then return end

    DelayInput(button)

    local oldVal = textentry:GetText()
    textentry:SetText(oldVal:sub(1, #oldVal - 1))
end

PANEL = {}

function PANEL:Init()
    self:SetSize(600, 450)
    self:Hide()

    self.color = ix.config.Get("color")
    self.backgroundColor = Color(0, 0, 0, 225)

    local numbers = self:Add("DIconLayout")
    numbers:SetSize(450, 300)
    numbers:SetPos(0, 0)

    for i = 9, 1, -1 do
        local num = numbers:Add("ixAtmMenuButton")
        num:SetText(i)
        num:SetSize(numbers:GetWide() / 3, numbers:GetTall() / 3)

        num.DoClick = function()
            AddValue(num, ix.gui.atmScreen.entry, tostring(i))
        end
    end

    local backspace = self:Add("ixAtmMenuButton")
    backspace:SetTextColor(color_red)
    backspace:SetText("❌")
    backspace:SetSize(150, 450 / 2)
    backspace:SetPos(450, 0)

    backspace.DoClick = function()
        local screen = ix.gui.atmScreen
        local state = screen:GetState()

        if state == "options" then
            screen:Cleanup()
            screen:Delay(function()
                screen:DrawIdle()
            end)
        end

        if not IsValid(screen.entry) then return end

        if state == "withdraw" or state == "deposit" then
            local value = screen.entry:GetText()

            if #value <= 1 then
                screen:Cleanup()
                screen:Delay(function()
                    screen:DrawOptions()
                end)
            else
                RemoveValue(backspace, screen.entry)
            end
        end
    end

    local enter = self:Add("ixAtmMenuButton")
    enter:SetTextColor(color_green)
    enter:SetText("✔")
    enter:SetSize(150, 450 / 2)
    enter:SetPos(450, 450 / 2)

    enter.DoClick = function()
        local screen = ix.gui.atmScreen
        local state = screen:GetState()

        if not IsValid(screen.entry) then return end

        local value = tonumber(screen.entry:GetText())

        if not value then return end

        if state == "withdraw" then
            net.Start("ixAtmWithdraw")
                net.WriteUInt(math.abs(value), 32)
            net.SendToServer()

            screen:Cleanup()
            screen:DrawIdle()
        end

        if state == "deposit" then
            net.Start("ixAtmDeposit")
                net.WriteUInt(math.abs(value), 32)
            net.SendToServer()

            screen:Cleanup()
            screen:DrawIdle()
        end
    end

    local zero = self:Add("ixAtmMenuButton")
    zero:SetPos(0, 300)
    zero:SetText("0")
    zero:SetSize(450, 150)

    zero.DoClick = function()
        AddValue(zero, ix.gui.atmScreen.entry, "0")
    end
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(self.backgroundColor)
    surface.DrawRect(0, 0, width, height)
    surface.SetDrawColor(self.color)
    surface.DrawOutlinedRect(-10, -10, width + 10, height + 10, 10)
end

vgui.Register("ixAtmKeypad", PANEL, "Panel")