#!/bin/sh
set -e

### Init directories
export source=$(dirname $(readlink -f $0))
export feature=$(basename $source)
export target=/usr/local/share/$feature
echo "Activating feature <$feature>..."
mkdir -p $target

### For each json file starting with _ in the feature directory, copy it to the target directory
echo "Copying json files to $target..."
find $source -type f -name "_*.json" | while read file; do
    cp $file $target/$(basename $file)
    echo "Copied $file => $target/$(basename $file)"
done

### For each sh scrrip starting with _ in the feature directory, copy it to the target directory
echo "Copying scripts to $target..."
find $source -type f -name "_*.sh" | while read script; do
    name=$(basename $script)
    cp $script $target/$name
    chmod +x $target/$name
    echo "Copied script $script => $target/$name"
done

### Copy the config script to the target directory and create a git alias for it
cp $source/configure*.sh $target
chmod +x $target/configure*.sh

### Create git alias to configure behaviors in current repository
git config --system alias.init-${feature%_*} "!sh -c '$target/configure.sh' - "

### Call all the install-xxx scripts in the feature directory
echo "Calling all install scripts in $source..."
find $source -type f -name "install-*.sh" | while read script; do
    echo "Calling $script..."
    sh $script
done
