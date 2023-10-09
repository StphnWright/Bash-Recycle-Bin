#!/usr/bin/env bash

readonly JUNK_DIR=~/.junk

usage() {
    cat << EOF
Usage: $(basename $0) [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
EOF
}

checkOptions() {
    if (( $1 == 1 || $2 == 1 || $3 == 1)); then
        echo "Error: Too many options enabled."
        usage
        exit 1
    fi
}

if (( $# == 0 )); then
   usage 
fi 

hopt=0
lopt=0
popt=0

# Section 1

while getopts ":hlp" arg; do
    case $arg in
    h)
        checkOptions $hopt $lopt $popt
        hopt=1
        ;;
    l)
        checkOptions $hopt $lopt $popt
        lopt=1
        ;;
    p)
        checkOptions $hopt $lopt $popt
        popt=1
        ;;
    *)
        echo "Error: Unkown option '-$OPTARG'."
        usage
        exit 1
        ;;
    esac
done

if (( (hopt == 1 || lopt == 1 || popt == 1) && OPTIND <= $# )); then
    echo "Error: Too many options enabled."
    usage
    exit 1
fi

# Section 2

if [[ ! -d "$JUNK_DIR" ]]; then
    mkdir "$JUNK_DIR"
fi

# Section 3, 4, 5

if (( hopt == 1 )); then
    usage
elif (( lopt == 1 )); then
    ls -lAF "$JUNK_DIR"
elif (( popt == 1 )); then
    rm -rf "$JUNK_DIR/"* "$JUNK_DIR/."*
else
    for filename in "$@"; do
        if [[ ! -e "$filename" ]]; then
            echo "Warning: '$filename' not found"
        else
            rm -rf "$JUNK_DIR/$filename"
            mv "$filename" "$JUNK_DIR"
        fi
    done
fi
