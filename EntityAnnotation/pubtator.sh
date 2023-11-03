#! /bin/bash

#BioNLP/work_data/search.results.litcovid.tsv为litcovid的关于covid文献检索结果，包含pmid
#删除开头若干行以#开头的注释行，提取第一列pmid
cat ../work_data/search.results.litcovid.tsv | grep -v '^#' | awk '{print $1}' |uniq > ../work_data/pmid.txt

id_list='../work_data/pmid.txt'

#读取id时跳过pmid.txt第一行列名
while read line
do
    if [ $line != 'pmid' ]
    then
    curl  https://www.ncbi.nlm.nih.gov/research/pubtator-api/publications/export/pubtator?pmids=$line >> ../work_data/abstract_pubtator.txt
    echo >> ../work_data/abstract_pubtator.txt
    fi
    sleep 2
done < $id_list

