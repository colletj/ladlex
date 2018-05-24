#!/bin/bash


#script -c "time for file in \`ls [a-z][a-z][a-z]\`; do cat \$file | ./pre-proc > raw_seq/\$file.seq & done" preprocess.log;
#time for file in `ls [a-z][a-z][a-z]`; do cat $file | ./pre-proc > raw_seq/$file.seq & done; wait;

script -c "for file in \`ls [a-z][a-z][a-z]\`; do cat \$file | ./pre-proc > raw_seq/\$file.seq & done; wait;" preprocess.log
script -c "for file in \`ls raw_seq/*.seq \`; do cat \$file | uniq -c > \$file.unique & done; wait;" uniq.log
echo "done"
