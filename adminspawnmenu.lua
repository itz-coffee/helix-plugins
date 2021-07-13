PLUGIN.name = "Admin Spawn Menu"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.desc = "Allow admins to easily spawn items."

if (SERVER) then
	util.AddNetworkString("ixAdminSpawnMenu")
	util.AddNetworkString("ixAdminSpawnItem")

	ix.log.AddType("adminSpawnItemLog", function(client, name)
	  return string.format("%s has spawned \"%s\"", client:GetCharacter():GetName(), tostring(name))
	end)

	net.Receive("ixAdminSpawnItem", function(len, client)
		local name = net.ReadString()

		if not client:IsAdmin() then return end

		for k, v in pairs(ix.item.list) do
			if v.name == name then
				ix.item.Spawn(v.uniqueID, client:GetShootPos() + client:GetAimVector()*84 + Vector(0, 0, 16))
				ix.log.Add(client, "adminSpawnItemLog", v.name)
				break
			end
		end
	end)
end

ix.command.Add("AdminSpawnMenu", {
    adminOnly = true,
    OnRun = function(self, client)
      net.Start("adminSpawnMenu")
      net.Send(client)
    end
})

if (CLIENT) then
	net.Receive("ixAdminSpawnMenu",function()
		local background = vgui.Create("DFrame")
		background:SetSize(ScrW() / 2, ScrH() / 2)
		background:Center()
		background:SetTitle("Admin Spawn Menu")
		background:MakePopup()
		background:ShowCloseButton(true)

		local search = background:Add("DTextEntry")
		search:Dock(TOP)
		search:SetUpdateOnType(true)
		search.OnValueChange = function(self, text)
			background.LoadItems(text:lower())
		end

		local scroll = background:Add("DScrollPanel")
		scroll:Dock(FILL)

		background.LoadItems = function(text)
			scroll:Clear()
			scroll:InvalidateLayout(true)

			local categoryPanels = {}

			for k, v in pairs(ix.item.list) do
				if (!categoryPanels[L(v.category)]) then
					categoryPanels[L(v.category)] = v.category
				end
			end

			for category, realName in SortedPairs(categoryPanels) do
				local collapsibleCategory = scroll:Add("DCollapsibleCategory")
				collapsibleCategory:SetTall(36)
				collapsibleCategory:SetLabel(category)
				collapsibleCategory:Dock(TOP)
				collapsibleCategory:SetExpanded(text and 1 or 0)
				collapsibleCategory:DockMargin(5, 5, 5, 0)
				collapsibleCategory.category = realName

				for uniqueID, data in pairs(ix.item.list) do
					local lowerName = data.name:lower()

					if text and not lowerName:find(text) then
						continue
					end

					if data.category == collapsibleCategory.category then
						local item = collapsibleCategory:Add("DButton")
						item:SetText(data.name)
						item:SizeToContents()
						item.DoClick = function()
							net.Start("ixAdminSpawnItem")
								net.WriteString(data.name)
							net.SendToServer()
							surface.PlaySound("buttons/button14.wav")
						end
					end
				end

				categoryPanels[realName] = collapsibleCategory
			end
		end

		background.LoadItems()
	end)
end
