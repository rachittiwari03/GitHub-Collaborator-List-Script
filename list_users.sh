#!/bin/bash

set -e
set -o pipefail

API_URL="https://api.github.com"


# GitHub username and personal access token.
# The script reads from the exported username and token from terminal using export username="", export token=""
USERNAME=$username
TOKEN=$token


# User and Repository information
# $1, $2 are the command line arguments
REPO_OWNER=$1
REPO_NAME=$2


# Function to make a GET request to the GitHub API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"
	
	# Send a GET request to the GitHub API with authentication
	# -s option is to supress the progress meter that is normally shown. Basically the progress of data transfer and all.
	# -u is for user authentication	
	curl -s -u "${USERNAME}:${TOKEN}" "${url}"
}


# Function to list users with read access to the repository
function list_users_with_read_access {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	# Fetch the list of collaborators on the repository
	# | jq -r '.[] | select(.permissions.pull == true) | .login': This part of the code pipes (|) the JSON response to jq, which then processes it. 
	# The -r option tells jq to output raw strings instead of JSON-encoded strings.
	# .[]: This jq expression iterates over all elements in an array or all key-value pairs in an object.
	# select(.permissions.pull == true): This filters the elements to only those where the pull field under permissions is true.
	# collaborators="$(...)": Finally, the output from jq, which should be a list of usernames, is stored in the variable $collaborators.
	#collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true and .permissions.admin != true) | .login')"

	# Display the list of collaborators with read access
	# -z test returns true if the length of the string is zero
	if [[ -z "$collaborators" ]]; then
		echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
		echo "$collaborators"
	fi
}


# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
