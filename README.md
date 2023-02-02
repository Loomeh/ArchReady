![](https://i.imgur.com/zSSwzOm.png)
# **ArchReady**
This is a port of [NayamAmarshe](https://github.com/NayamAmarshe)'s GameReady script to Arch Linux (plus any Arch derivatives like Manjaro)

This script functions basically the same but has new features such as installing correct GPU drivers for your system and automatically enabling the Chaotic AUR.

## Features
 - Installs graphics drivers
 - Installs an AUR helper (paru)
 - Enables Chaotic AUR
 - Installs Wine
 - Installs Winetricks
 - Installs Lutris
 - Installs GameMode
 - Installs the Xanmod kernel for extra performance
 - Configures Wine to work with a majority of games out of the box

## Usage
Run `curl -L https://raw.githubusercontent.com/Loomeh/ArchReady/main/archready.sh | bash`

Or if you want to run from source:

    git clone https://github.com/Loomeh/ArchReady
    cd ArchReady
    chmod +x ./archready.sh
    ./archready.sh

