#!/bin/bash
#SBATCH -J dzx
#SBATCH -N 1
#SBATCH -o /home/yh/dzx/work/BioNLP/EntityAnnotation/out.txt
#SBATCH -e /home/yh/dzx/work/BioNLP/EntityAnnotation/err.txt
bash pubtator.sh