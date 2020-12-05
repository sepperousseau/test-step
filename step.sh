#!/bin/bash
set -ex

increment_version() {
 local v=$1
 local count=$2
 local rgx='^((?:[0-9]+\.)*)([0-9]+)($)'
 val=`echo -e "$v" | perl -pe 's/^.*'$rgx'.*$/$2/'`
 echo "$v" | perl -pe s/$rgx.*$'/${1}'`printf %0${#val}s $(($val+$count))`/
}

count=$(git rev-list --count HEAD --first-parent)
version=$(echo $BITRISE_GIT_BRANCH| sed -e 's/.*\///g')

if [[ ${add_commit_count} == 'yes' && $version =~ ^[0-9]+\.[0-9]+ ]]; then
   version=$(increment_version $version $count)
fi

envman add --key GIT_BRANCH_VERSION --value "$version"
