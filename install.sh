#!/usr/bin/env bash
#
# Inspired by https://github.com/zhaorz/.dotfiles/
# References:
#   - https://github.com/holman/dotfiles
#   - https://github.com/boochtek/mac_config
#   - https://github.com/herrbischoff/awesome-osx-command-line

IGNORE=(
    ".git"
    ".gitignore"
    ".gitmodules"
    "README.md"
    ".DS_Store"
    "install.sh"
    "extensions.txt"
    "default_search.txt"
)

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

info () {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

link_file () {
    local src=$1 dst=$2

    local overwrite= backup= skip=
    local action=

    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
    then

        if [ "$overwrite_all" == "false" ] && \
               [ "$backup_all" == "false" ] && \
               [ "$skip_all" == "false" ]
        then

            local currentSrc="$(readlink $dst)"

            if [ "$currentSrc" == "$src" ]
            then

                skip=true;

            else
                user "File already exists: $dst ($(basename "$src")), \
what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, \
[O]verwrite all, [b]ackup, [B]ackup all?"

                read -n 1 action

                case "$action" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    * )
                    ;;
                esac

            fi

        fi

        overwrite=${overwrite:-$overwrite_all}
        backup=${backup:-$backup_all}
        skip=${skip:-$skip_all}

        if [ "$overwrite" == "true" ]
        then
            rm -rf "$dst"
            success "removed $dst"
        fi

        if [ "$backup" == "true" ]
        then
            mv "$dst" "${dst}.backup"
            success "moved $dst to ${dst}.backup"
        fi

        if [ "$skip" == "true" ]
        then
            success "skipped $src"
        fi
    fi

    if [ "$skip" != "true" ]  # "false" or empty
    then
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}

###############################################################################
# Dotfiles
###############################################################################

install_dotfiles () {
    info 'installing dotfiles'

    local overwrite_all=false backup_all=false skip_all=false

    for src in $(find "$DOTFILES_ROOT" -mindepth 1 -maxdepth 1)
    do
        if [[ "${IGNORE[@]}" =~ "$(basename $src)" ]]
        then
            continue
        fi
        dst="$HOME/.$(basename "$src")"
        link_file "$src" "$dst"
    done
    
}


###############################################################################
# Homebrew
###############################################################################

install_homebrew () {
    info 'installing homebrew'

    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_apps () {
    info 'installing apps'

    # Install Node
    brew install node

    # Install applications through cask
    # See https://caskroom.github.io for more information
    brew cask install google-chrome
    brew cask install atom
    brew cask install spotify
    brew cask install appcleaner
    brew cask install flux # Need to open f.lux with `open -a flux` later

    # Other Apps to Install
    #   - Pages
    #   - Numbers
    #   - Keynote
    #   - Mathematica
    #   - Matlab
    #   - Illustrator
    #   - InDesign
    #   - Photoshop
}

###############################################################################
# Google Chrome Preferences
###############################################################################

setup_chrome () {
    info 'setting up Chrome'

    # Change what opens when Chrome is launched:
    #   - 1 = Restore the last session
    #   - 4 = Open a list of URLs
    #   - 5 = Open New Tab Page
    defaults write com.google.Chrome RestoreOnStartup -int 1

    # Change what cookies are saved:
    #   - 1 = Allow all sites to set local data
    #   - 2 = Do not allow any site to set local data
    #   - 4 = Keep cookies for the duration of the session
    defaults write com.google.Chrome DefaultCookiesSetting -int 4

    # Block third party cookies
    defaults write com.google.Chrome BlockThirdPartyCookies -bool true

    # Prevent sites from tracking physical location
    #   - 1 = Allow sites to track the users' physical location
    #   - 2 = Do not allow any site to track the users' physical location
    #   - 3 = Ask whenever a site wants to track the users' physical location
    defaults write com.google.Chrome DefaultGeolocationSetting -int 2

    # Prevent audio capturing
    defaults write com.google.Chrome AudioCaptureAllowed -bool false

    # Prevent video capturing
    defaults write com.google.Chrome VideoCaptureAllowed -bool false 

    ## TODO: Send a "Do not track request" by default
}

###############################################################################
# TextEdit Preferences
###############################################################################

setup_textedit () {
    info 'setting up TextEdit'

    # Open TextEdit with Plain Text mode
    # Change to `-int 1` for default behavior (Rich Text mode)
    defaults write com.apple.TextEdit RichText -int 0

    # Disable smart quotes
    # Change to `-int 1` for default behavior (smart quotes enabled)
    defaults write com.apple.TextEdit SmartQuotes -int 0
}

###############################################################################
# System Preferences
###############################################################################

setup_system () {
    info 'setting up System'

    # Don’t automatically rearrange Spaces based on most recent use
    # Change to `bool true` for default behavior
    defaults write com.apple.dock mru-spaces -bool false 

    # Make Crash Reporter appear as a native notification
    # Change to `-int 0` for default behavior (non-native notification)
    # defaults write com.apple.CrashReporter UseUNC -int 1

    # Add ability to toggle between Light and Dark mode using ctrl+opt+cmd+t
    # Change to `-bool face` for default behavior
    sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

    # Enable Tap to click (tapping with one finger to click)
    # Change the first line to `-bool false` and the second line to `-int 0` for default behavior
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Arrange Desktop icons by kind
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

    # Arrange list views by kind
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ListViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

    # Don't send search queries to Apple from Safari
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true

    # Hide Dock automatically
    # Change to `-bool false` for default behavior
    defaults write com.apple.dock autohide -bool true

    # Make Dock icons of hidden applications translucent
    # Change to `-bool false` for default behavior
    defaults write com.apple.dock showhidden -bool true

    ## TODO: Ask for number of spacers
    # defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'

    # Bottom right screen corner start screen saver
    # Change first line to `-int 0` for default behavior
    # Possible values:
    #   - 0 = no-op
    #   - 2 = Mission Control
    #   - 3 = Show application windows
    #   - 4 = Desktop
    #   - 5 = Start screen saver
    #   - 6 = Disable screen saver
    #   - 7 = Dashboard
    #   - 10 = Put display to sleep
    #   - 11 = Launchpad
    #   - 12 = Notification Center
    defaults write com.apple.dock wvous-br-corner -int 5
    defaults write com.apple.dock wvous-br-modifier -int 0
}

###############################################################################
# Aliases
###############################################################################

setup_aliases () {
    info 'setting up aliases'

    alias nanobash='nano ~/.bashrc'
    alias sourcebash='source ~/.bashrc'
    alias cddev='cd ~/Developer'
}

###############################################################################
# Setup
###############################################################################

setup () {
    info 'setup'

    setup_chrome
    setup_textedit
    setup_system
    setup_aliases
}

main () {
    echo ''
    # install_dotfiles
    echo ''
    # setup

    echo ''
    echo 'All installed!'
    echo ''
    echo 'Restarting in 60s'
    countdown 60 && echo 'Shutdown!' # shutdown -r now

}

main