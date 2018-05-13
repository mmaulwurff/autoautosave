acc source/autoautosave.acs acs/autoautosave.o && \
    rm -f autoautosave.pk3 && \
    zip autoautosave.pk3 \
        acs/autoautosave.o \
        loadacs.txt \
        README.txt \
        source/autoautosave.acs \
        mapinfo.txt zscript.txt \
        keyconf.txt menudef.txt \
        cvarinfo.txt && \
    gzdoom -glversion 3 \
           -file \
           autoautosave.pk3 \
           ~/Programs/Games/wads/maps/DOOMTEST.wad \
           +map test \
           -nomonsters
