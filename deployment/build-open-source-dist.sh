#!/bin/bash
#
# This assumes all of the OS-level configuration has been completed and git repo has already been cloned
#
# This script should be run from the repo's deployment directory
# cd deployment
# ./build-s3-dist.sh solution-name
#
# Paramenters:
#  - solution-name: name of the solution for consistency

# Check to see if input has been provided:
if [ -z "$1" ]; then
    echo "Please provide the trademark approved solution name for the open source package."
    echo "For example: ./build-s3-dist.sh trademarked-solution-name"
    exit 1
fi

set -e # Just in case - lots of rm -rf

# Get reference for all important folders
source_template_dir="$PWD"
dist_dir="$source_template_dir/open-source"
dist_template_dir="$dist_dir/deployment"
source_dir="$source_template_dir/../source"

echo "------------------------------------------------------------------------------"
echo "[Init] Clean old open-source folder"
echo "------------------------------------------------------------------------------"
echo "rm -rf $dist_dir"
rm -rf $dist_dir
echo "mkdir -p $dist_dir"
mkdir -p $dist_dir
echo "mkdir -p $dist_template_dir"
mkdir -p $dist_template_dir

echo "------------------------------------------------------------------------------"
echo "[Packing] Templates"
echo "------------------------------------------------------------------------------"
echo "cp $source_template_dir/*.template $dist_template_dir/"
cp $source_template_dir/*.template $dist_template_dir/
echo "copy yaml templates and rename"
cp $source_template_dir/*.yaml $dist_template_dir/
cd $dist_template_dir
# Rename all *.yaml to *.template
for f in *.yaml; do
    mv -- "$f" "${f%.yaml}.template"
done
echo "copy deployment shell scripts"
cp $source_template_dir/*.sh $dist_template_dir/

echo "------------------------------------------------------------------------------"
echo "[Packing] Build Script"
echo "------------------------------------------------------------------------------"
echo "cp $source_template_dir/build-s3-dist.sh $dist_template_dir"
cp $source_template_dir/build-s3-dist.sh $dist_template_dir
#echo "cp $source_template_dir/run-unit-tests.sh $dist_template_dir"
#cp $source_template_dir/run-unit-tests.sh $dist_template_dir

echo "------------------------------------------------------------------------------"
echo "[Packing] Source Folder"
echo "------------------------------------------------------------------------------"
echo "cp -r $source_dir $dist_dir"
cp -r $source_dir $dist_dir
echo "cp $source_template_dir/../LICENSE.txt $dist_dir"
cp $source_template_dir/../LICENSE.txt $dist_dir
echo "cp $source_template_dir/../NOTICE.txt $dist_dir"
cp $source_template_dir/../NOTICE.txt $dist_dir
echo "cp $source_template_dir/../README.md $dist_dir"
cp $source_template_dir/../README.md $dist_dir
echo "cp $source_template_dir/../CODE_OF_CONDUCT.md $dist_dir"
cp $source_template_dir/../CODE_OF_CONDUCT.md $dist_dir
echo "cp $source_template_dir/../CONTRIBUTING.md $dist_dir"
cp $source_template_dir/../CONTRIBUTING.md $dist_dir
echo "cp $source_template_dir/../CHANGELOG.md $dist_dir"
cp $source_template_dir/../CHANGELOG.md $dist_dir

echo "------------------------------------------------------------------------------"
echo "[Packing] Clean dist, node_modules and bower_components folders"
echo "------------------------------------------------------------------------------"
echo "find $dist_dir -iname "node_modules" -type d -exec rm -r "{}" \; 2> /dev/null"
find $dist_dir -iname "node_modules" -type d -exec rm -r "{}" \; 2> /dev/null
echo "find $dist_dir -iname "tests" -type d -exec rm -r "{}" \; 2> /dev/null"
find $dist_dir -iname "tests" -type d -exec rm -r "{}" \; 2> /dev/null
echo "find $dist_dir -iname "dist" -type d -exec rm -r "{}" \; 2> /dev/null"
find $dist_dir -iname "dist" -type d -exec rm -r "{}" \; 2> /dev/null
echo "find $dist_dir -iname "bower_components" -type d -exec rm -r "{}" \; 2> /dev/null"
find $dist_dir -iname "bower_components" -type d -exec rm -r "{}" \; 2> /dev/null
echo "find ../ -type f -name 'package-lock.json' -delete"
find $dist_dir -type f -name 'package-lock.json' -delete

echo "------------------------------------------------------------------------------"
echo "[Packing] Create GitHub (open-source) zip file"
echo "------------------------------------------------------------------------------"
echo "cd $dist_dir"
cd $dist_dir
echo "zip -q -r9 ../$1.zip *"
zip -q -r9 ../$1.zip *
echo "Clean up open-source folder"
echo "rm -rf *"
rm -rf *
echo "mv ../$1.zip ."
mv ../$1.zip .
echo "Completed building $1.zip dist"
