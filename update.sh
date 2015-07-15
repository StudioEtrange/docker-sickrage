#!/bin/bash
set -e

_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$_CURRENT_FILE_DIR"

GITHUB_REPO="SiCKRAGETV/SickRage"


function github_releases() {
	local max=$1

	local result=""
	local last_page=$(curl -i -sL "https://api.github.com/repos/$GITHUB_REPO/releases" | grep rel=\"last\" | cut -d "," -f 2 | cut -d "=" -f 2 | cut -d ">" -f 1)
	for i in $(seq 1 $last_page); do 
		result="$result $(curl -sL https://api.github.com/repos/$GITHUB_REPO/releases?page=$i | grep tag_name | cut -d '"' -f 4)"
	done

	local sorted
	[ "$max" == "" ] && sorted=$(echo "$result" | tr ' ' '\n' | sort -r | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//')
	[ ! "$max" == "" ] && sorted=$(echo "$result" | tr ' ' '\n' | sort -r  | head -n $max | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//' )
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
	[ "$max" == "" ] && sorted=$(echo "$result" | tr ' ' '\n' | sort -r | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//')
	[ ! "$max" == "" ] && sorted=$(echo "$result" | tr ' ' '\n' | sort -r  | head -n $max | tr '\n' ' ' | sed -e 's/^ *//' -e 's/ *$//' )
	echo "$sorted"
}



echo "******** UPDATE LAST RELEASE ********"
# Update last release
last_release=$(github_releases 1)
version_name="$last_release"
version_full=$(echo $version_name | tr -d 'v')
version_major=$(echo $version_full | cut -d '.' -f 1)
echo " * Process last release $version_name"
echo " ** major version number : $version_major"
echo " ** full version id : $version_full"

sed -i .bak -e "s/ENV SICKRAGE_VERSION.*/ENV SICKRAGE_VERSION $version_name/" "Dockerfile"
rm -f Dockerfile.bak

echo
echo "******** UPDATE ALL RELEASES ********"
# Update all releasese
releases=$(github_releases)
for rel in $releases; do
	version_name="$rel"
	version_full=$(echo $version_name | tr -d 'v')
	version_major=$(echo $version_full | cut -d '.' -f 1)
	echo " * Process release $version_name"
	echo " ** major version number : $version_major"
	echo " ** full version id : $version_full"

	mkdir -p "$version_full"
	cp -f supervisord* "$version_full"
	cp -f Dockerfile "$version_full/Dockerfile"
	sed -i .bak -e "s/ENV SICKRAGE_VERSION.*/ENV SICKRAGE_VERSION $version_name/" "$version_full/Dockerfile"
	rm -f "$version_full/Dockerfile.bak"
	echo
done

echo "******** UPDATE README ********"
list_release=$(echo $releases | tr -d 'v' | sed -e 's/ /\, /g')
last_release_tag=$(echo $last_release | tr -d 'v')
sed -i .bak -e "s/latest,.*/latest, $list_release/" "README.md"
rm -f "README.md.bak"

sed -i .bak -e "s/^Current latest tag is version \*.*\*/Current latest tag is version \*$last_release_tag\*/" "README.md"
rm -f "README.md.bak"

echo
echo "************************************"
echo " YOU SHOULD NOW ADD MISSING RELEASE TAG THROUGH"
echo " Docker Hub WebUI : AUTOMATED BUILD REPOSITORY"

