#!/bin/bash

###################################
# Author-Debarshi
# Usage- Script retrives all the users from a repo
# Version-v1
# Prerequisite- The github username and api token must be exported in to the program
# The organisation name and the repo name must be passed as arguments while running the program
###################################


# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Function to check if the correct number of arguments is provided
function helper {
    expected_cmd_args=2
    if [ $# -ne $expected_cmd_args ]; then
        echo "Usage: $0 REPO_OWNER REPO_NAME"
        echo "Please provide both the repository owner and the repository name."
        exit 1
    fi
}

# Main script

# Call the helper function to check command-line arguments
helper "$@"

# Check if the username and token are set
if [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
    echo "Error: USERNAME and TOKEN must be provided."
    exit 1
fi

# Proceed with listing users with read access
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
