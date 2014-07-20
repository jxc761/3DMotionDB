#!/bin/bash

# begin step
# git clone https://github.com/jxc761/3DMotionDB.git
# cd 3DMotionDB
# cd to the project directory

# Add the application to your project, i.e. add the project 
# as a remote reference in your own project
remote_name="tools_remote"
remote_url="https://github.com/jxc761/tools.git"

git remote add "${remote_name}" "${remote_url}"
git fetch "${remote_name}"

# check it out into its own branch and switch to it
branch_name="tools_branch"
git checkout -b "${branch_name}" "${remote_name}/master"

# switch to master branch
git checkout master

# pull the branch into the subdirectory of the master branch of the main project:
prefix="tools/"
git read-tree --prefix=${prefix} -u "${branch_name}"

# if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:
git checkout "${branch_name}"
git pull

# then merge the updated subtree to the master branch
git checkout master
git merge --squash -s subtree --no-commit ${branch_name}
======

# if the upstream of subtree has been updated, we can using following scripts to update
# make the reference to the subtree project
remote_name="tools_remote"
remote_url="https://github.com/jxc761/tools.git"
git remote add "${remote_name}" "${remote_url}" 

git subtree pull --prefix=tools ${remote_name} master 


# refers:
# git subtree操作理解: http://tomorrow-also-bad.blog.163.com/blog/static/203002244201392391330831/
# git 进阶: http://havee.me/linux/2012-07/the-git-advanced-subtree.html
