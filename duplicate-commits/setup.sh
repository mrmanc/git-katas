#!/usr/bin/env bash

# Include utils
source ../utils/utils.sh

rm -rf exercise-remote.git
git -c init.defaultBranch="$DEFAULT_BRANCH" init --bare exercise-remote.git

make-exercise-repo

git remote add origin ../exercise-remote.git

echo "Hello" > file.txt
git add .
git commit -am "Say hello"
echo "Hello wolrd" > file.txt
git commit -am "Say hello world"
git push --set-upstream origin $DEFAULT_BRANCH
git checkout -b feature
echo "Shiny" > feature.txt
git add .
git commit -am "Start new feature"
echo "happy" >> feature.txt
git commit -am "Continue feature"
git push --set-upstream origin feature
git checkout master
echo "Hello world" > file.txt
git commit -am "Fix urgent typo"
git push
git checkout feature
git rebase $DEFAULT_BRANCH
echo "people" >> feature.txt
git commit -am "Complete feature"
echo "ℹ️  Attempting to push."
git push # fails
echo "ℹ️  The push failed. Feature branch commits were recreated when the branch was rebased onto master, so origin/feature and feature have diverged. Git suggests pulling changes down, but this will confuse the history. This is what the history looks like now:"
git --no-pager log --oneline --decorate --all --graph
echo "ℹ️  Pulling changes down as git suggested."
git pull
echo "ℹ️  Notice that the log now shows a duplicate urgent fix commit on the feature branch."
git --no-pager log --oneline --decorate --all --graph
git push # works
git checkout master
git merge feature -m "Merge feature into master"
git push
#git --no-pager log --oneline --decorate --all --graph
echo "ℹ️  After merging feature into master, the duplicate urgent fix commit shows in the log for master:"
git --no-pager log --oneline --no-decorate