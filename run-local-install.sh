#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Current context is: ${CURRENT_CONTEXT}"
echo "Will uninstall Kubevious now"
read -r -p "Do you want to continue?(y/N) " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        echo "Aborted"
        exit 1;
        ;;
esac

rm -f kubevious-0.0.0.tgz

helm package kubernetes/ --version 0.0.0

helm install \
    --atomic \
    -n kubevious \
    --set mysql.persistence.enabled=false \
    kubevious ./kubevious-0.0.0.tgz