defaults write com.apple.dock orientation -string "left" &&
  defaults write com.apple.dock mineffect -string "scale" &&
  defaults write com.apple.dock autohide -int 1 &&
  killall Dock

dockitems_to_remove=(
  'Siri'
  'Launchpad'
  'Safari'
  'Mail'
  'Contacts'
  'Calendar'
  'Notes'
  'Reminders'
  'Maps'
  'Photos'
  'Messages'
  'FaceTime'
  'iTunes'
  'App Store'
  'System Preferences'
)

for item in "${dockitems_to_remove[@]}"
do
  dockutil --remove "${item}"
done

dockitems_to_add=(
  'Google Chrome'
  'Evernote'
  'Slack'
  'Visual Studio Code'
  'Sublime Text'
  'iTerm'
  'zoom.us'
)

for item in "${dockitems_to_add[@]}"
do
  dockutil --find "${item}" || dockutil --add "/Applications/${item}.app"
done

for index in "${!dockitems_to_add[@]}"
do
  dockutil --move "${dockitems_to_add[$index]}" --position $((${index}+1))
done

killall Dock
