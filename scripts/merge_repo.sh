#!/bin/bash

# The script to merge AnnotationTool into 3DMotionDB

# cd into a directory


git clone  https://github.com/jxc761/AnnotationTool.git

# move all files into an directory and update the related record
cd AnnotationTool
dirname="AnnotationTool"
git filter-branch --tree-filter \
            "(mkdir -p $dirname; find . -maxdepth 1 ! -name . ! -name .git ! -name $dirname -exec mv {} $dirname/ \;)"

# return to the root directory
cd ..

# merge the filtered repo 
git clone https://github.com/jxc761/3DMotionDB.git
cd 3DMotionDB
git pull --no-commit ../AnnotationTool
git commit -m "merge repo:AnnotationTool"
git push


:<<'REFER_CODE'
me=$(basename $0)

TMP=$(mktemp -d /tmp/$me.XXXXXXXX)
echo 
echo "building new repo in $TMP"
echo
sleep 1

set -e

cd $TMP
mkdir new-repo
cd new-repo
    git init
    cd ..

x=0
while [ -n "$1" ]; do
    repo="$1"; shift
    git clone "$repo"
    dirname=$(basename $repo | sed -e 's/\s/-/g')
    if [[ $dirname =~ ^git:.*\.git$ ]]; then
        dirname=$(echo $dirname | sed s/.git$//)
    fi

    cd $dirname
        git remote rm origin
        git filter-branch --tree-filter \
            "(mkdir -p $dirname; find . -maxdepth 1 ! -name . ! -name .git ! -name $dirname -exec mv {} $dirname/ \;)"
        cd ..

    cd new-repo
        git pull --no-commit ../$dirname
        [ $x -gt 0 ] && git commit -m "merge made by $me"
        cd ..

    x=$(( x + 1 ))
done
REFER_CODE