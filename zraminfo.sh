
#!/bin/sh -eu

TOTAL_DATA=0
TOTAL_COMP=0
HAS_ZRAM=

# Iterate through swap devices searching for compressed ones
while read NAME _; do
    # Filter zram swaps and let's hope your ordinary swap doesn't have
    # "zram" in its name :D
    case $NAME in
	*zram*) ;;
	*) continue
    esac

    DIR=/sys`udevadm info --query=path --name=$NAME`
    DATA=$(awk '{print $1}' $DIR/mm_stat)
    COMP=$(awk '{print $3}' $DIR/mm_stat)
    TOTAL_DATA=$((TOTAL_DATA + DATA))
    TOTAL_COMP=$((TOTAL_COMP + COMP))
    HAS_ZRAM=1
done </proc/swaps

# Extract physical memory in kibibytes and scale back to bytes
{
    read _ MEM_KIB _
    read _ FREE_KIB _
    read _ BUF_KIB _
    read _ CACHE_KIB _
} </proc/meminfo

/usr/bin/printf "\
Physical memory:   %'17d bytes
Buffers and cache: %'17d bytes / %4.1f%% of physical memory
Unallocated:       %'17d bytes / %4.1f%% of physical memory
" `echo "scale=6; 1024*$MEM_KIB; 1024*($BUF_KIB+$CACHE_KIB); 100*($BUF_KIB+$CACHE_KIB)/$MEM_KIB; 1024*$FREE_KIB; 100*$FREE_KIB/$MEM_KIB"|bc`

if test "$HAS_ZRAM"; then
    /usr/bin/printf "\
Compressed:        %'17d bytes / %4.1f%% of physical memory
Decompressed size: %'17d bytes / %4.1f%% of decompressed memory
Compression ratio: %.3f
" `echo "scale=6; $TOTAL_COMP; 100*$TOTAL_COMP/$MEM_KIB/1024; $TOTAL_DATA; 100*$TOTAL_DATA/(1024*$MEM_KIB-$TOTAL_COMP+$TOTAL_DATA); $TOTAL_DATA/$TOTAL_COMP"|bc`
else
    echo "Compressed:                        0 bytes / zram not in use"
fi
