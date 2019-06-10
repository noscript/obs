#!/bin/bash -e

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename $0) <path to home project>" >&2
  exit 1
fi

HOME_PROJECT=$1

cd $(dirname $0)
find . -name '_service' -not -path "./_template/*" | xargs -I{} bash -x -c 'cp {} "'$HOME_PROJECT'/{}"'