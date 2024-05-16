#!/bin/bash

datetime=$(date '+%Y%m%d%H%M%S')
git tag "$datetime"
git push origin "$datetime"