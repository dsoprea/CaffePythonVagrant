#!/bin/bash

cd /caffe
cp Makefile.config.example Makefile.config

# Make it CPU-only.
sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/' Makefile.config

make all
make pycaffe
