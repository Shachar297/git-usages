#!/bin/sh

# ----------------------------------------------------------------

# For this script to be executed and change the commit message :
# 1. A branch name must be set with the jira issue key. (BLP-243-branch name), this must be the anchor for the script.

# After validating the branch name, we check for the last commit message.
# You can print the last commit message with the ```echo $2```

# If the commit message aready contains a jira issue key- there is no need to do anything here.
# If the last commit message does not contain a jira issue key, we change the commit message.
# Notice, Do not push the code via this script (!!!).

# ----------------------------------------------------------------

# In order to check that this script is valid, follow these steps
# 1. Create a branch from a jira issue, the branch name must have the issue key in it.
# 2. go to your local workspace, 
# 3. git fetch 
# 4. git checkout your_branch_name
# touch somefile
# git add . && git commit -m "my commit" && git push
# go to gitlab and check for your commit message or type : 'git log -1 --oneline'

# ----------------------------------------------------------------

echo $0
echo $1
echo $2

BRANCH_NAME=$(git symbolic-ref --short HEAD)
JIRA_ISSUE_KEY_PATTERN='[A-Z]{2,9}-[0-9]{1,9}-'
LAST_COMMIT_MSG=$2
# LAST_COMMIT_MSG="shachar 1111111"
JIRA_ISSUE_KEY=""
NEW_COMMIT_MSG=""

#  Validating branch name.
if ! [[ $BRANCH_NAME =~ $JIRA_ISSUE_KEY_PATTERN ]]; then
    # If did not find jira issue key in branch name, we can not set a commit message
    # The commit message (the new one will be generated), uses the branch name as the issue key.
    echo "-----> Did not find a branch name containts a jira issue"
else
    echo "-----> Found branch name containts a jira issue - branch name : $BRANCH_NAME"
    # Set the issue key variable according to the branch name
    JIRA_ISSUE_KEY=$(echo $BRANCH_NAME | sed -r 's/$JIRA_ISSUE_KEY_PATTERN/g/')
    # Set the new commit message according to the issue key and the lsat commit message
    NEW_COMMIT_MSG="$JIRA_ISSUE_KEY $LAST_COMMIT_MSG"
    if ! [[ $LAST_COMMIT_MSG =~ $JIRA_ISSUE_KEY_PATTERN ]]; then
        
        if [[ $NEW_COMMIT_MSG =~ $JIRA_ISSUE_KEY_PATTERN ]]; then
            echo "Setting new commit message with message : $NEW_COMMIT_MSG"
            echo "$NEW_COMMIT_MSG" >$1
            exit 0;
        fi
    else
        echo "-----> Commit message contains a JIRA key - commit : $LAST_COMMIT_MSG, No need to do anything."
        exit 0;
    fi
fi

exit 0;

