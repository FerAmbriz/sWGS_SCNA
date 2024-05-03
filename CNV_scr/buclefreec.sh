#!/bin/bash

for i in scripts/*.txt;
do
				freec -conf $i
done

