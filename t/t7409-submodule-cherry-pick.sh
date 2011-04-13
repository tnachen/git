#!/bin/sh
#
# Author: Timothy Chen (tnachen@gmail.com)
#

test_description='test cherry-pick with submodules'
. ./test-lib.sh

base_dir=`pwd`

U=$base_dir/UPLOAD_LOG

test_expect_success 'preparing first repository' \
'test_create_repo A && cd A &&
echo first > file1 &&
git add file1 &&
git commit -m A-initial'

cd "$base_dir"

test_expect_success 'preparing second repository' \
'test_create_repo B && cd B &&
echo first > file2 &&
git add file2 &&
git commit -m B-initial'

cd "$base_dir"

test_expect_success 'create subdir A and branch b in B' \
'cd B && git branch b && mkdir A &&
touch A/y && git add A/y &&
git commit -my && echo 1 > file2 && git commit -a -mx1'

cd "$base_dir"

test_expect_success 'create submodule in branch b and cherrypick' \
'cd B && CHERRY=$(git rev-parse HEAD) &&
git checkout b && git submodule add "file://$base_dir/A" A &&
git submodule update &&
git commit -my &&
git cherry-pick $CHERRY'

test_done
