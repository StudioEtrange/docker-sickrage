#!/bin/bash
set -e

_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$_CURRENT_FILE_DIR"

GITHUB_REPO="SiCKRAGETV/SickRage"
RELEASE_NAME_FILTER="v"

# Use github tag instead of github release
USE_TAG_AS_RELEASE=0

# SPECIFIC FUNCTIONS ----------------------------
function update_dockerfile() {
	local path=$1
	local version=$2

	sed -i .bak -e "s,ENV SICKRAGE_VERSION.*,ENV SICKRAGE_VERSION $version," "$path"
	rm -f "$path".bak
}

function update_readme() {
	local path=$1
	local version=$2
	local list="$3"

	sed -i .bak -e "s/latest,.*/latest, $list/" "$path"
	sed -i .bak -e "s/^Current latest tag is version __.*__/Current latest tag is version __"$version"__/" "$path"
	
	rm -f "$path".bak
}


# GENERIC FUNCTIONS ----------------------------
# sort a list of version
# sorted=$(sort_version "1.0.1 1.2.0 1.1.9c 1.1.9a 1.1.10" "DESC")
# echo $sorted ===> 1.2.0 1.1.10 1.1.9a 1.1.9c 1.0.1
function sort_version() {
	local list=$1
	local opt="$2"

	local mode="ASC"
	local separator="."

	local flag_sep=OFF
	for o in $opt; do
		[ "$o" == "ASC" ] && mode=$o
		[ "$o" == "DESC" ] && mode=$o
		[ "$flag_sep" == "ON" ] && separator="$o" && flag_sep=OFF
		[ "$o" == "SEP" ] && flag_sep=ON
	done

	[ "$mode" == "ASC" ] && echo "$list" | tr ' ' '\n' | sort -n -t$separator -k 1,1n -k 2,2n -k 3,3n -k 4,4n -k 5,5n -k 6,6n -k 7,7n | tr '\n' ' '
	[ "$mode" == "DESC" ] && echo "$list" | tr ' ' '\n' | sort -n -r -t$separator -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k 5,5nr -k 6,6nr -k 7,7nr | tr '\n' ' '

}

function github_releases() {
	local max=$1

	local result=""
	local last_page=$(curl -i -sL "https://api.github.com/repos/$GITHUB_REPO/releases" | grep rel=\"last\" | cut -d "," -f 2 | cut -d "=" -f 2 | cut -d ">" -f 1)
	for i in $(seq 1 $last_page); do 
		result="$result $(curl -sL https://api.github.com/repos/$GITHUB_REPO/releases?page=$i | grep tag_name | cut -d '"' -f 4)"
	done

	local sorted
	[ "$max" == "" ] && sorted=$(echo "$(sort_version "$result" "DESC")" | sed -e 's/^ *//' -e 's/ *$//')
	[ ! "$max" == "" ] && sorted=$(echo "$(sort_version "$result" "DESC")" | tr ' ' '\n' | head -n $max | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//' )
	echo "$sorted"
}

function github_tags() {
	local max=$1

	local result=""
	local last_page=$(curl -i -sL "https://api.github.com/repos/$GITHUB_REPO/tags" | grep rel=\"last\" | cut -d "," -f 2 | cut -d "=" -f 2 | cut -d ">" -f 1)
	for i in $(seq 1 $last_page); do 
		result="$result $(curl -sL https://api.github.com/repos/$GITHUB_REPO/tags?page=$i | grep name | cut -d '"' -f 4)"
	done

	local sorted
	[ "$max" == "" ] && sorted=$(echo "$(sort_version "$result" "DESC")" | sed -e 's/^ *//' -e 's/ *$//')
	[ ! "$max" == "" ] && sorted=$(echo "$(sort_version "$result" "DESC")" | tr ' ' '\n' | head -n $max | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//' )
	echo "$sorted"
}













# MAIN ----------------------------
# github tag does not have special char before tag number -- sed regexp can not be empty, so a foo string is used
[ "$USE_TAG_AS_RELEASE" == "1" ] && RELEASE_NAME_FILTER="XXXXXXXX"

echo
echo "******** UPDATE LAST ********"
# Update last release
[ "$USE_TAG_AS_RELEASE" == "1" ] && last_release=$(github_tags 1)
[ ! "$USE_TAG_AS_RELEASE" == "1" ] && last_release=$(github_releases 1)

version_name="$last_release"
version_number=$(echo $version_name | sed -e "s,$RELEASE_NAME_FILTER,,g")
echo " * Process last release $version_name"
echo " ** version number : $version_number"

update_dockerfile "Dockerfile" "$version_name"

echo
echo "******** UPDATE ALL ********"
# Update all releasese
rm -Rf "ver"
[ "$USE_TAG_AS_RELEASE" == "1" ] && releases=$(github_tags)
[ ! "$USE_TAG_AS_RELEASE" == "1" ] && releases=$(github_releases)

for rel in $releases; do
	version_name="$rel"
	version_number=$(echo $version_name | sed -e "s,$RELEASE_NAME_FILTER,,g")
	echo " * Process release $version_name"
	echo " ** version number : $version_number"

	mkdir -p "ver/$version_number"
	cp -f supervisord* "ver/$version_number"
	cp -f Dockerfile "ver/$version_number/Dockerfile"
	update_dockerfile "ver/$version_number/Dockerfile" "$version_name"
	echo
done

echo "******** UPDATE README ********"
list_release=$(echo $releases | sed -e "s,$RELEASE_NAME_FILTER,,g" | sed -e 's/ /\, /g')
last_release_tag=$(echo $last_release | sed -e "s,$RELEASE_NAME_FILTER,,g")

update_readme "README.md" "$last_release_tag" "$list_release"

echo
echo "************************************"
echo " YOU SHOULD NOW ADD MISSING VERSION THROUGH"
echo " Docker Hub WebUI : AUTOMATED BUILD REPOSITORY"




