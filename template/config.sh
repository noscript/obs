#!/bin/sh -e

if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) <name>" >&2
  exit 1
fi

NEW_NAME=$1

sed -i "s/TEMPLATE_NAME/$NEW_NAME/g" debian.* _service *.dsc
git mv TEMPLATE_NAME.dsc $NEW_NAME.dsc

echo "Update git url:"
grep "https://github.com/$NEW_NAME/$NEW_NAME" *

rm -f config.sh
