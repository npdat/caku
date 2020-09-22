#!/bin/bash

# GET INPUT VARIABLES
while getopts "a:b:c:" option
do
    case "${option}" in
    a) AppId=${OPTARG};;
    b) AppleBundleId=${OPTARG};;
    c) AppleDisplayName=${OPTARG};;
    
esac
done

# if [[ $AppId = "" ]]
#     then
#     echo "You must enter the appId, by using the -a flag"
#     exit 1
# else 
#     echo "Your AppId is: ${AppId}"
# fi

# File Paths
project_dir=`pwd`/ios/TEST

echo "PROJECT DIRECTORY $project_dir"

# Configuration
workspace="TEST.xcodeproj/project.xcworkspace"
scheme="TEST"
info_plist="$project_dir/Info.plist"

echo "PROJECT DIRECTORY $info_plist"

function set_environment() {

    #extract settings from the Info.plist file
    info_plist_domain=$(ls "$info_plist" | sed -e 's/\.plist//')
    echo "Info plist domain = $info_plist"

    bundle_identifier=$(defaults read "$info_plist_domain" CFBundleIdentifier)
    /usr/libexec/PlistBuddy -c Print:CFBundleIdentifier: "$info_plist"

    # update bundle identifier, app version and build number
    /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $AppleBundleId" "$info_plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $AppleDisplayName" "$info_plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleName $AppId" "$info_plist"

    bundle_identifier=$(defaults read "$info_plist_domain" CFBundleIdentifier)
    echo "Environment set to $bundle_identifier"

}

echo
echo "**** Set Environment"
set_environment
echo