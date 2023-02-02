#!/bin/bash

# COLOR VARIABLES
RED="\e[31m"
ENDCOLOR="\e[0m"

sudo pacman -Syu --noconfirm

zenitypkg="zenity";
check="$(sudo pacman -Qs --color always "${zenitypkg}" | grep "local" | grep "${zenitypkg} ")";
if [ -n "${check}" ] ; then
	echo "${zenitypkg} is installed";
elif [ -z "${check}" ] ; then
	sudo pacman -Syu --noconfirm zenity
fi;
zenity --info --text="Script made by Loomeh.\n\nCredit to:\nNayamAmarshe - for creating GameReady\nGhoulBoii - for creating the original GameReady Arch Linux port." --no-wrap

zenity --warning --width 300 --title="Before Starting the Installation" --text="You may see a text asking for your password, just enter your password in the terminal. The password is for installing system libraries, so root access is required by ArchReady. When you enter your password, do not worry if it doesn't show you what you typed, it's totally normal."

sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# INSTALL GRAPHICS DRIVERS
if zenity --question --width 300 --title="Install graphics drivers?" --text="Would you like to install the correct graphics drivers for your system? (If you already have graphics drivers installed then reinstalling them won't hurt, it'll just waste some time. Better to be safe than sorry.)"; then
	{
		if zenity --question --width 300 --title="Select your GPU." --text="Do you have an Nvidia graphics card?"; then
		{
			sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader	
		} fi
		if zenity --question --width 300 --title="Select your GPU." --text="Do you have an AMD graphics card?"; then
		{
			sudo pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
		} fi
		if zenity --question --width 300 --title="Select your GPU." --text="Do you have an Intel graphics card? (Don't install this if you already have a dedicated GPU driver installed)"; then
		{
			sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
		} fi
	}
fi

# INSTALL PARU
echo -e "\n\n${RED}<-- Installing PARU -->${ENDCOLOR}"
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin || {
	echo "Failed at command cd paru"
	exit 1
}
makepkg --noconfirm -si
cd .. || {
	echo "Failed at command cd in paru"
	exit 1
}
rm -rf paru-bin

# INSTALL CHAOTIC AUR
if zenity --question --width 300 --title="Enable Chaotic AUR?" --text="Would you like the enable the Chaotic AUR? It provides precompiled binaries for some AUR packages and is required to install the Xanmod kernel (unless you want to wait 5 hours)."; then
{
	sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key FBA220DFC880C036
	sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	sudo echo "[chaotic-aur]" >> /etc/pacman.conf
	sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
	sudo pacman -Syu --noconfirm
}
fi

# INSTALL WINE
echo -e "\n\n${RED}<-- Installing WINE -->${ENDCOLOR}"
sudo pacman -S --noconfirm wine-staging wine-mono
  
# INSTALL WINETRICKS
echo -e "\n\n${RED}<-- Installing Winetricks -->${ENDCOLOR}"
sudo pacman -S --noconfirm winetricks
sudo winetricks --self-update
  
# INSTALL LUTRIS
echo -e "\n\n${RED}<-- Installing Lutris -->${ENDCOLOR}"
sudo pacman -S --noconfirm lutris
  
# INSTALL GAMEMODE
echo -e "\n\n${RED}<-- Installing Gamemode -->${ENDCOLOR}"
sudo pacman -S --noconfirm gamemode lib32-gamemode

# INSTALL XANMOD
if zenity --question --width 300 --title="Install Xanmod Kernel?" --text="Your current kernel is $(uname -r). We're going to install Xanmod kernel next, Xanmod is for enabling extra performance patches for kernels. Do you want to install Xanmod? (This requires that you enabled the Chaotic AUR)"; then
{
	sudo pacman -S --noconfirm chaotic-aur/linux-xanmod
	sudo pacman -S --noconfirm chaotic-aur/linux-xanmod-headers
	sudo grub-mkconfig -o /boot/grub/grub.cfg
}
fi

# INSTALL WINETRICKS DEPENDENCIES
zenity --warning --title="Alright Listen Up" --width 300 --text="Now we're going to install dependencies for WINE like DirectX, Visual C++, DotNet and more. Winetricks will try to install these dependencies for you, so it'll take some time. Do not panic if you don't receive visual feedback, it'll take time."
echo -e "\n\n${RED}<-- Installing Important WINE Helpers -->${ENDCOLOR}"
winetricks -q -v d3dx10 d3dx9 dotnet35 dotnet40 dotnet45 dotnet48 dxvk vcrun2008 vcrun2010 vcrun2012 vcrun2019 vcrun6sp6

zenity --info --title="Success" --text="Make sure to reboot for all the changes to apply. Happy Gaming!"
