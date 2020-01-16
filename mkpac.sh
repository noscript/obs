#!/bin/bash -e

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename $0) PACKAGE_NAME [GIT_URL]" >&2
  exit 1
fi

PACKAGE_NAME=$1
GIT_URL=$2
TEMPLATED_FILES="debian.* _service *.dsc"

cd $(dirname $0)
cp -r _template $PACKAGE_NAME
pushd $PACKAGE_NAME >/dev/null

sed -i "s/TEMPLATE_NAME/$PACKAGE_NAME/g" $TEMPLATED_FILES
mv TEMPLATE_NAME.dsc $PACKAGE_NAME.dsc

if [[ ! -z "$GIT_URL" ]]; then
  sed -i "s#GIT_URL#$GIT_URL#g" $TEMPLATED_FILES
else
  sed -i "s#GIT_URL#https://github.com/$PACKAGE_NAME/$PACKAGE_NAME#g" $TEMPLATED_FILES
  echo "Update git url:"
  grep "https://github.com/$PACKAGE_NAME/$PACKAGE_NAME" $TEMPLATED_FILES
fi

popd >/dev/null

git add $PACKAGE_NAME

osc mkpac $PACKAGE_NAME
osc add $PACKAGE_NAME/_service
