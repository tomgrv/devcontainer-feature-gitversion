#!/bin/sh
set -e

echo "Activating feature 'gitutils'"

### Install GitFlow
sudo apt-get update
sudo apt-get install -y git-flow dos2unix jq

### Function to linearize json object
linearize_json() {
    jq -r 'paths(scalars) as $p | [($p|join(".")), (getpath($p)|tostring)] | join(" ")' "$1"
}

### Get current directory
feature=$(dirname $(readlink -f $0))

### For each entry in config.json file next to this file, create corresponding git config from key and value.
### if value is an object, parse it as json and create dotted keys
echo "Configuring git..."
linearize_json $feature/dist/config.json | while read key value; do
    git config --system --unset-all $key
    git config --system $key "$value"
    echo "Created config $key => $value" | npx chalk-cli --stdin green
done

### For each entry in alias.json file next to this file, create corresponding git alias from key and value
echo "Configuring aliases..."
jq -r 'keys[]' $feature/dist/alias.json | dos2unix | while read key; do
    value=$(jq -r ".$key" ./dist/alias.json)
    git config --system alias.$key "!sh -c '$value' - "
    echo "Created alias $key => $value" | npx chalk-cli --stdin green
done

### For each script starting with _, create corresponding git alias without _ from script name
echo "Configuring scripts..."
for script in $feature/dist/_*.sh; do
    alias=$(basename $script | sed -e 's/^_//g' -e 's/.sh$//g')
    git config --system alias.$alias "!sh -c '$(readlink -f $script)' - "
    echo "Created alias $alias => $(readlink -f $script)" | npx chalk-cli --stdin green
done
