#!/bin/bash
for dir in `find . -maxdepth 1 -type d | grep masterclass`; do
  cd ${dir}
  if [ ! -f backend.tf ]; then
    ln -s ../backend.tf backend.tf
  fi
  if [ ! -f provider.tf ]; then
    ln -s ../provider.tf provider.tf
  fi
  cd ..
done
