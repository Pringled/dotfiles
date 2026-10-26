require("hs.ipc")

if hs.focusLockHotkey then hs.focusLockHotkey:delete() end
if hs.focusLockAppSwitchBlocker then hs.focusLockAppSwitchBlocker:stop() end
if hs.focusLockAppWatcher then hs.focusLockAppWatcher:stop() end
if hs.focusLockMenu then hs.focusLockMenu:delete() end

local lockedBundleID
local lockedAppName
local menu = hs.menubar.new()
hs.focusLockMenu = menu

local function updateMenu()
  if lockedBundleID then
    menu:setTitle("🔒 " .. lockedAppName)
    menu:setTooltip("Focus locked to " .. lockedAppName .. ". Click to unlock.")
  else
    menu:setTitle("Focus")
    menu:setTooltip("Click to lock the current app")
  end
end

local function toggleFocusLock()
  if lockedBundleID then
    local previous = lockedAppName
    lockedBundleID = nil
    lockedAppName = nil
    updateMenu()
    hs.alert.show("Focus unlocked from " .. previous, 2)
    return
  end

  local app = hs.application.frontmostApplication()
  if not app then
    hs.alert.show("Could not find the frontmost app", 2)
    return
  end

  lockedBundleID = app:bundleID()
  lockedAppName = app:name()
  updateMenu()
  hs.alert.show("Focus locked to " .. lockedAppName .. "\nCtrl-Alt-L to unlock", 2)
end

hs.focusLockHotkey = hs.hotkey.bind({ "ctrl", "alt" }, "l", toggleFocusLock)
menu:setClickCallback(toggleFocusLock)

hs.focusLockAppSwitchBlocker = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if not lockedBundleID then
    return false
  end

  local flags = event:getFlags()
  if event:getKeyCode() == 48 and flags.cmd then
    hs.alert.show("Focus locked to " .. lockedAppName .. "\nCtrl-Alt-L to unlock", 2)
    return true
  end
  return false
end)
hs.focusLockAppSwitchBlocker:start()

hs.focusLockAppWatcher = hs.application.watcher.new(function(_, event, app)
  if event ~= hs.application.watcher.activated or not lockedBundleID or not app then
    return
  end
  if app:bundleID() ~= lockedBundleID then
    local lockedApp = hs.application.get(lockedBundleID)
    if lockedApp then
      hs.alert.show("Focus locked to " .. lockedAppName .. "\nCtrl-Alt-L to unlock", 2)
      lockedApp:activate(true)
    end
  end
end)
hs.focusLockAppWatcher:start()

updateMenu()
