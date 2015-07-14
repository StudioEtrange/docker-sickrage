#!/bin/bash
set -e

_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$_CURRENT_FILE_DIR"

echo "******** UPDATE LAST RELEASE ********"
# Update last release
last_release=$(curl -sL https://api.github.com/repos/SiCKRAGETV/SickRage/releases | grep tag_name | head -n 1 |  cut -d '"' -f 4 | tr -d '')
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
releases=$(curl -sL https://api.github.com/repos/SiCKRAGETV/SickRage/releases | grep tag_name |  cut -d '"' -f 4 | tr -d '')
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
releases=$(curl -sL https://api.github.com/repos/SiCKRAGETV/SickRage/releases | grep tag_name |  cut -d '"' -f 4 | tr -d 'v' | tr -d '')
for rel in $releases; do
	list_release="$list_release, $rel"
done
sed -i .bak -e "s/latest,.*/latest$list_release/" "README.md"
rm -f "README.md.bak"

echo
echo "************************************"
echo " YOU SHOULD NOW ADD MISSING RELEASE TAG THROUGH"
echo " Docker Hub WebUI : AUTOMATED BUILD REPOSITORY"

