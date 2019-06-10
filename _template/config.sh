#!/bin/bash -e

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename $0) <name>" >&2
  exit 1
fi

NEW_NAME=$1

cd $(dirname $0)
mkdir -p ../$NEW_NAME
cp $(ls -I config.sh) ../$NEW_NAME
cd ../$NEW_NAME

sed -i "s/TEMPLATE_NAME/$NEW_NAME/g" debian.* _service *.dsc
mv TEMPLATE_NAME.dsc $NEW_NAME.dsc

echo "Update git url:"
grep "https://github.com/$NEW_NAME/$NEW_NAME" *
