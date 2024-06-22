#!/bin/sh
set -e

### For each script starting with _ and ending with .sh, Create a symbolic link to the hook script without _ and sh extension
echo "Configuring hooks..."
for script in $target/_*.sh; do
    hook=$(basename $script | sed -e 's/^_//g' -e 's/.sh$//g')
    ln -sf $script $target/$hook
    echo "Created hook $hook => $script"
done
