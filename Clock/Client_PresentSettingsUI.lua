
function Client_PresentSettingsUI(rootParent)

	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local time = Mod.Settings
	UI.CreateLabel(vert).SetText('Starting Second: ' .. time.Second).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Starting Mintue: ' .. time.Mintue).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Starting Hour: ' .. time.Hour).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Starting Day: ' .. time.Day).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Starting Month: ' .. time.Month).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Starting Year: ' .. time.Year).SetColor('#00B5FF')

	UI.CreateLabel(vert).SetText('Passing Seconds: ' .. time.ISecond).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Passing Minutes: ' .. time.IMinute).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Passing Hours: ' .. time.IHour).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Passing Days: ' .. time.IDay).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Passing Months: ' .. time.IMonth).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Passing Years: ' .. time.IYear).SetColor('#00B5FF')

	UI.CreateLabel(vert).SetText('Month Names ' .. time.HMonthnames).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Week Day Names ' .. time.HWeeknames).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Days in each month ' .. time.HMonthdays).SetColor('#00B5FF')

	UI.CreateLabel(vert).SetText('Before 0 : ' .. time.Before).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('After 0 : ' .. time.After).SetColor('#00B5FF')
end
