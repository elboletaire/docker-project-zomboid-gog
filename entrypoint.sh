#!/usr/bin/env bash

# @author Òscar Casajuana <elboletaire@underave.net>
# @license: GPL-3.0

base=/zomboid
game=$base/game
folder=projectzomboid
server=start-server.sh
executable=$game/$folder/$server

if [[ ! -d $game ]]; then
  echo "Expected zomboid game folder in ${base} but wasn't found. Exiting."
  exit 1
fi

if [[ ! -f $executable ]]; then
  echo "Expected start-server.sh to be in ${executable}, but could not be found. Exiting."
  exit 1
fi

# After this, and taking the default gog installation as an example, everything
# should be located on their expected places

# Ensure start-server.sh is executable
if [[ ! -x $executable ]]; then
  chmod +x $executable
fi

# Ensure jre bin paths have executable files...
if [[ ! -x $game/$folder/jre/java ]] || [[ ! -x $game/$folder/jre64/java ]]; then
  chmod +x $game/$folder/jre*/bin/*
fi

# We're not using steam, that's for sure...
params="-nosteam"

# sets the path for the game data cache dir.
# Example: -cachedir=C:\Zomboid
if [ -v cachedir ]; then
  params="${params} -cachedir=${cachedir}"
else
  params="${params} -cachedir=/zomboid/config"
fi

# option to control where mods are loaded from. "-modfolders workshop,steam,mods" is the default.
# Any of the 3 keywords may be left out and may appear in any order.
if [ -v modfolders ]; then
  params="${params} -modfolders ${modfolders}"
fi

# safe mode ??
if [ -v safemode ] && [ $safemode ]; then
  params="${params} -safemode"
fi

# option to bypasses the enter-a-password prompt when creating a server.
# Example: -adminpassword YourPasswdXYZ
if [ -v adminpassword ]; then
  params="${params} -adminpassword ${adminpassword}"
fi

# You can choose a different servername by using this option when starting the server.
# Example: -servername MySecondServer
if [ -v servername ]; then
  params="${params} -servername ${servername}"
fi

# option to handle multiple network cards.
# Example: -ip 127.0.0.1
if [ -v ip ]; then
  params="${params} -ip ${ip}"
fi

# option which overrides the .ini option "DefaultPort".
# Example: -port 16261
if [ -v port ]; then
  params="${params} -port ${port}"
fi

# Maximum amount of
# Memory. Example: -Xmx1024m ( 1024m=1Gig , 2048m=2Gig , 4096m=4Gig )
if [ -v max_memory ]; then
  params="${params} -Xmx${max_memory}"
fi

# Initial/Minimum Memory allocation.
# Example: -Xms1024m ( 1024m=1Gig , 2048m=2Gig , 4096m=4Gig )
if [ -v min_memory ]; then
  params="${params} -Xms${min_memory}"
fi

# overwrites the "/Zomboid" homedir to whatever path you want.
# Example: -Duser.home=C:\Zomboid
if [ -v home ]; then
  params="${params} -Duser.home=${home}"
fi

if [ -v debug ] && [ $debug ]; then
  params="${params} -Ddebug"
fi

# This should not be necessary, but just in case...
cd $game/$folder

# Now run that shit :B
./start-server.sh $params
