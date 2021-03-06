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
    "extension.json"
)

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CHROME_EXTENSIONS=(
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock
    "hdokiejnpimakedhajhdlcegeplioahd" # LastPass
    "ojhmphdkpgbibohbnpbfiefkgieacjmh" # Currently
    "niloccemoadcdkdjlinkgdfekeahmflj" # Pocket
    "immpkjjlgappgfkkfieppnmlhakdmaab" # Imagus
    "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
    "oknpjjbmpnndlpmnhmekjpocelpnlfdi" # Mercury Reader
)

BREW_APPS=(
    "heroku"
    "node"
)

CASK_APPS=(
    "appcleaner"
    "atom"
    "bittorrent"
    "google-chrome"
    "ngrok"
    "psequel"
    "spotify"
    "teamviewer"
)

ATOM_PACKAGES=(
    "atom-material-ui"
    "atom-meterial_syntax"
    "file-icons"
    "linter"
)

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 6)
NORMAL=$(tput sgr0)
UNDERLINE=$(tput smul)
NO_UNDERLINE=$(tput rmul)

print () {
    printf "%$2s%$2s$1"
}

info () {
    print "${UNDERLINE}INFO:${NO_UNDERLINE} $1\n" $2
}

user () {
    print "${BLUE}${UNDERLINE}USER:${NO_UNDERLINE} $1${NORMAL} " $2
}

success () {
    print "${GREEN}${UNDERLINE}OK:${NO_UNDERLINE} $1${NORMAL}\n" $2
}

fail () {
    print "${RED}${UNDERLINE}FAIL:${NO_UNDERLINE} $1${NORMAL}\n" $2
    exit
}

warn () {
    print "${YELLOW}${UNDERLINE}WARN:${NO_UNDERLINE} $1${NORMAL}\n" $2
}

confirm () {
    user "Would you like to $1?\n%6s[y]es, [n]o" $2

    read -sn 1 action

    case "$action" in
        y )
          print "\r%6s${GREEN}[y]es${BLUE}, [n]o${NORMAL}\n"
          return 0;;
        n )
          print "\r%6s${BLUE}[y]es, ${RED}[n]o${NORMAL}\n"
          return 1;;
        * )
        ;;
    esac
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

                read action

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
    info "installing dotfiles"

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

    success "installed dotfiles"
}

###############################################################################
# Homebrew
###############################################################################

install_homebrew () {
    info "installing homebrew"

    # Install Homebrew
    #/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/
    #                  Homebrew/install/master/install)"

    success "installed homebrew"
}

###############################################################################
# pip
###############################################################################

install_pip () {
    info "installing pip"

    # Install pip
    sudo easy_install pip
    # Install virtualenv
    sudo pip install virtualenv

    success "installed pip"
}

###############################################################################
# ZSH
###############################################################################

install_oh_my_zsh () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

###############################################################################
# Apps
###############################################################################

install_apps () {
    info "installing apps"

    for brew_app in "${BREW_APPS[@]}"
    do
      brew install "${brew_app}"
    done

    # Install applications through cask
    # See https://caskroom.github.io for more information
    for cask_app in "${CASK_APPS[@]}"
    do
      brew cask install "${cask_app}"
    done

    # Other Apps to Install
    #   - Pages
    #   - Numbers
    #   - Keynote
    #   - Mathematica
    #   - Matlab
    #   - Illustrator
    #   - InDesign
    #   - Photoshop

    success "installed apps"
}

###############################################################################
# Google Chrome Preferences
###############################################################################

install_chrome_extensions () {
    info "installing Chrome extensions"

    local extension_dir=~/Library/Application\ Support/Google/Chrome/External\ Extensions/
    if [ ! -d "$extension_dir" ]; then
      mkdir "$extension_dir"
    fi

    for extension in "${CHROME_EXTENSIONS[@]}"
    do
        cp ./extension.json "${extension_dir}${extension}.json"
    done

    success "installed Chrome extensions"
}

setup_chrome () {
    info "setting up Chrome"

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
    # defaults write com.google.Chrome AudioCaptureAllowed -bool false

    # Prevent video capturing
    # defaults write com.google.Chrome VideoCaptureAllowed -bool false

    ## TODO: Send a "Do not track request" by default

    # Install extensions specified in CHROME_EXTENSIONS
    install_chrome_extensions

    success "setup Chrome complete"
}

###############################################################################
# TextEdit Preferences
###############################################################################

setup_textedit () {
    info "setting up TextEdit"

    # Open TextEdit with Plain Text mode
    # Change to `-int 1` for default behavior (Rich Text mode)
    defaults write com.apple.TextEdit RichText -int 0

    # Disable smart quotes
    # Change to `-int 1` for default behavior (smart quotes enabled)
    defaults write com.apple.TextEdit SmartQuotes -int 0

    success "setup TextEdit complete"
}

###############################################################################
# System Preferences
###############################################################################

setup_system () {
    info "setting up System"

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
    Defaults write com.apple.finder FXArrangeGroupViewBy -string "kind"

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

    # Change clock format in menu bar
    # Possible values:
    #   - 12 Hour Mode with AM/PM: EEE MMM d  h:mm:ss a
    #   - 12 Hour Mode without AM/PM: EEE MMM d  h:mm:ss
    #   - 24 Hour Mode: EEE MMM d  H:mm:ss
    defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm'

    # Disable auto-correct
    # Change to `-bool true` for default behavior
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Turn off keyboard illumination after 5 minutes (300 seconds)
    defaults write com.apple.BezelServices kDimTime -int 300

    # Set cmd-shift-v to paste and match style in all applications
    defaults write NSGlobalDomain NSUserKeyEquivalents -dict 'Paste and Match Style' '@$v'

    # Set Desktop wallpaper to user folder
    defaults write com.apple.systempreferences DSKDesktopPrefPane -dict 'UserFolderPaths' '("Users/dylan/Documents/Graphics/Desktop Wallpapers")'

    success "setup System complete"
}

###############################################################################
# Vim
###############################################################################

setup_vim () {
    info "installing vim-plug"

    # Using vim-plug to manage vim plug-ins
    # See https://github.com/junegunn/vim-plug for more information
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    info "Run `:PlugInstall` after downloading to install the plugins specified
          in the .vimrc"

    success "installed vim-plug"
}

###############################################################################
# Atom
###############################################################################

setup_atom () {
    info "installing atom packages"

    for atom_package in "${ATOM_PACKAGES[@]}"
    do
      apm install "${atom_package}"
    done

    success "installed atom packages"
}

###############################################################################
# Git
###############################################################################

setup_git () {
    info "setting up git"

    git config --global core.excludesfile ~/.gitignore_global
    git config --global user.name "Dylan Steele"
    git config --global user.email "dylansteele8@gmail.com"
    git config --global core.editor "/usr/bin/vim"

    success "setup git complete"
}

###############################################################################
# Main
###############################################################################

main () {
    info "Running install.sh..."

    if confirm "install dotfiles"
    then
        install_dotfiles
    fi

    if confirm "install homebrew"
    then
        install_homebrew
    fi

    if confirm "install pip"
    then
        install_pip
    fi

    if confirm "install zsh"
    then
        install_oh_my_zsh
    fi

    if confirm "install apps"
    then
        install_apps
    fi

    if confirm "setup Chrome"
    then
        setup_chrome
    fi

    if confirm "setup TextEdit"
    then
        setup_textedit
    fi

    if confirm "setup System"
    then
        setup_system
    fi

    if confirm "setup vim"
    then
        setup_vim
    fi

    if confirm "setup Atom"
    then
        setup_atom
    fi

    if confirm "setup git"
    then
        setup_git
    fi

    success "All installed and setup!"
}

main
