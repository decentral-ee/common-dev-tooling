#!/bin/bash

function oops() {
    echo "$@" >&2
    exit 1
}

BUILDS_DIR=$1
[ -d "$BUILDS_DIR"/branches ] && [ -d "$BUILDS_DIR"/revs ] || oops "Invalild builds directory: $BUILDS_DIR"

echo "Cleaning builds directory: $BUILDS_DIR ..."

# list all revs
tmpfile=$(mktemp /tmp/cleanup-builds.XXXXXX)
ls $BUILDS_DIR/revs > $tmpfile

# keep branches
ls $BUILDS_DIR/branches | while read branch;do
    rev=$(basename $(readlink "$BUILDS_DIR/branches/$branch"))
    echo "Keeping branch $branch rev $rev"
    sed -i "/^$rev$/d" $tmpfile 
done

# delete stray revs
mkdir -p $BUILDS_DIR/archives
cat $tmpfile | while read rev;do
    echo "Deleting rev $rev"
    mv $BUILDS_DIR/revs/$rev $BUILDS_DIR/archives/$rev
done
rm -rf $BUILDS_DIR/archives

rm -f $tmpfile

echo "Done."
