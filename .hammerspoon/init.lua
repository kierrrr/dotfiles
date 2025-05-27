hs.hotkey.bind({ "cmd", "shift" }, "k", function()
	local app = hs.application.get("kitty")
	local win = app:focusedWindow()
	local appscreen = win:screen()
	local mousescreen = hs.mouse.getCurrentScreen()

	if app then
		if appscreen == mousescreen then
			if app:isFrontmost() then
				app:hide()
			else
				app:activate()
			end
		else
			win:moveToScreen(mousescreen)

			if app:isHidden() then
				app:activate()
			end
		end
	end
end)

hs.hotkey.bind({ "cmd", "shift" }, "o", function()
	local app = hs.application.get("Arc")
	local win = app:focusedWindow()
	local appscreen = win:screen()
	local mousescreen = hs.mouse.getCurrentScreen()

	if app then
		if appscreen == mousescreen then
			if app:isFrontmost() then
				app:hide()
			else
				app:activate()
			end
		else
			if app:isHidden() then
				app:activate()
			end
		end
	end
end)

hs.hotkey.bind({ "cmd", "shift" }, "i", function()
	local app = hs.application.get("Chrome")
	local win = app:focusedWindow()
	local appscreen = win:screen()
	local mousescreen = hs.mouse.getCurrentScreen()

	if app then
		if appscreen == mousescreen then
			if app:isFrontmost() then
				app:hide()
			else
				app:activate()
			end
		else
			if app:isHidden() then
				app:activate()
			end
		end
	end
end)

hs.hotkey.bind({ "alt" }, "0", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreenFrame = hs.screen.mainScreen():frame()
	local windowPercentage = win:frame().w / mainScreenFrame.w

	if app then
		win:move({ 1 - windowPercentage, 0, windowPercentage, 1 })
	end
end)

hs.hotkey.bind({ "alt" }, "9", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreenFrame = hs.screen.mainScreen():frame()
	local windowPercentage = win:frame().w / mainScreenFrame.w

	if app then
		win:move({ 0, 0, windowPercentage, 1 })
	end
end)

hs.hotkey.bind({ "alt" }, "=", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreenFrame = hs.screen.mainScreen():frame()
	local windowPercentage = win:frame().w / mainScreenFrame.w

	if app then
		win:move({ 1 - windowPercentage, 0, windowPercentage, 1 })
	end
end)

hs.hotkey.bind({ "alt" }, "1", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()

	if app then
		win:maximize()
		-- win:toggleFullScreen()
		-- win:moveToUnit({ 0, 0, 1, 1 })
	end
end)

hs.hotkey.bind({ "alt" }, "2", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreen = hs.screen.mainScreen()
	local isLeftPositioned = mainScreen:absoluteToLocal(win:topLeft()).x == 0

	if app then
		if isLeftPositioned then
			win:move({ 0, 0, 0.6, 1 })
		else
			win:move({ 0.4, 0, 0.6, 1 })
		end
	end
end)

hs.hotkey.bind({ "alt" }, "3", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreen = hs.screen.mainScreen()
	local isLeftPositioned = mainScreen:absoluteToLocal(win:topLeft()).x == 0.0

	if app then
		if isLeftPositioned then
			win:move({ 0, 0, 0.75, 1 })
		else
			win:move({ 0.25, 0, 0.75, 1 })
		end
	end
end)

hs.hotkey.bind({ "alt" }, "4", function()
	local app = hs.application.frontmostApplication()
	local win = app:focusedWindow()
	local mainScreen = hs.screen.mainScreen()
	local isLeftPositioned = mainScreen:absoluteToLocal(win:topLeft()).x == 0.0

	if app then
		if isLeftPositioned then
			win:move({ 0, 0, 0.5, 1 })
		else
			win:move({ 0.5, 0, 0.5, 1 })
		end
	end
end)
