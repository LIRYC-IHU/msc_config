# Find the dmg name
dmg=$(ls . | grep .dmg)
echo "The current package to adapt: $dmg"

if [[ -n $dmg ]]; then
	# Attach to read-write format and retrieve mount path
    path=$(hdiutil attach -owners on $dmg -shadow | grep -i 'Volumes' | cut -f 3)
    echo "The current volume: $path"
            
    # Update dmg design
    echo "Update the dmg design..."
    volumeName=$(basename "$path")
    /usr/local/bin/dmgbuild -s ../msc_config/dmgbuild-config.json "$volumeName" $dmg
    
    # Unmount and convert back to read-only file
    hdiutil detach "$path"
    hdiutil convert -format UDZO -imagekey zlib-level=9 -o $dmg $dmg -shadow 1>/dev/null 2>/dev/null

    echo "End of update"
    
    # Remove shadow image
    rm $dmg.shadow
else
    echo "A problem happened in compilation, no dmg is built"
fi
