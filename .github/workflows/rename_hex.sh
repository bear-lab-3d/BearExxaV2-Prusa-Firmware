#!/bin/bash

#######################################################################
# Description:
# Rename all hex files by adding the BEX2 version
#######################################################################

# Constants
HEXDIR="build/release/"
FW_BEAR_VER=""

# Get Bear BEX2 version
FW_BEAR_VER=$(awk '/^#define[ \t]?FW_COMMITNR[ \t]?BEX/ {print $3;exit}' Firmware/Configuration.h)
if [ -z $FW_BEAR_VER ]; then
  echo "Cannot retrieve Bear firmware version from Firmware/Configuration.h"
  exit 1
else
  echo "–------------"
  echo "BEX2 version = $FW_BEAR_VER"
fi

cd "${HEXDIR}"
echo "–------------"
echo "Firmware files before:"
ls -1 *

# Rename MK3S hex file
new_hex_fname=$(ls MK3S_MK3S+_*.hex | sed -E "s/(3\.[0-9]*\.[0-9]*)/\1-${FW_BEAR_VER}/")
echo "–------------"
echo "New MK3S name =  ${new_hex_fname}"
mv MK3S_MK3S+_*.hex ${new_hex_fname}

# Unzip MK2.5S files
echo "–------------"
echo -n "Start decompressing the MK2.5S files ... "
unzip -q MK25S-RAMBo10a*.zip
unzip -q MK25S-RAMBo13a*.zip
echo "done"

# Reneame MK2.5S RAMBo10a
echo "–------------"
echo -n "Rename MK25S-RAMBo10a files ... "
for file in $(ls MK25S-RAMBo10a*.hex); do
    new_hex_fname=$(ls "$file" | sed -E "s/(3\.[0-9]*\.[0-9]*)/\1-${FW_BEAR_VER}/")
    #echo "New MK25S-RAMBo10a name =  $new_hex_fname"
    mv "$file" "$new_hex_fname"
done
echo "done"

# Zip MK2.5S-RAMBo10a files
echo "–------------"
echo -n "Compress MK25S-RAMBo10a files ... "
new_mk25s_zipname=$(ls MK25S-RAMBo10a*.zip | sed -E "s/(3\.[0-9]*\.[0-9]*)/\1-${FW_BEAR_VER}/")
rm MK25S-RAMBo10a*.zip
zip -mq "$new_mk25s_zipname" MK25S-RAMBo10a*.hex
echo "done"
echo "$new_mk25s_zipname has been created"

# Reneame MK2.5S RAMBo13a
echo "–------------"
echo -n "Rename MK25S-RAMBo13a files ... "
for file in $(ls MK25S-RAMBo13a*.hex); do
    new_hex_fname=$(ls "$file" | sed -E "s/(3\.[0-9]*\.[0-9]*)/\1-${FW_BEAR_VER}/")
    #echo "New MK25S-RAMBo13a name =  $new_hex_fname"
    mv "$file" "$new_hex_fname"
done
echo "done"

# Zip MK2.5S-RAMBo13a files
echo "–------------"
echo -n "Compress MK25S-RAMBo13a files ... "
new_mk25s_zipname=$(ls MK25S-RAMBo13a*.zip | sed -E "s/(3\.[0-9]*\.[0-9]*)/\1-${FW_BEAR_VER}/")
rm MK25S-RAMBo13a*.zip
zip -mq "$new_mk25s_zipname" MK25S-RAMBo13a*.hex
echo "done"
echo "$new_mk25s_zipname has been created"

echo "–------------"
echo "Firmware files after:"
ls -1 *

echo "–------------"
echo "Renaming finished successfully"
exit
