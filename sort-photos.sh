#!/bin/sh

unsorted_dir="./unsorted"
sorted_dir="./sorted"

# Query for the list of images
pictures="$(find "$unsorted_dir" -type f -iregex ".*\.\(jpg\|jpeg\)$" \
    -printf "%T@\t%p\n" | sort -n | awk -F'\t' '{print $2}' | \
    sxiv -iotq)"
[ -z "$pictures" ] && exit 1

echo "Selected following pictures:"
for picture in $pictures
do
    echo "$(basename "$picture")"
done

# Query collection directory name
echo -n "Enter collection directory name: "
read collection
[ -z "$collection" ] && exit 1

# Confirm move
echo -n "Move selected images to '"$collection"' collection directory (y/N)? "
read answer
[ "$answer" = "${answer#[Yy]}" ] && exit 0

# Actually move pictures
mkdir -p "$sorted_dir/$collection"
for picture in $pictures
do
    mv "$picture" "$sorted_dir/$collection/"
done

exit 0