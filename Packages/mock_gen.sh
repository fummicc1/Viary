dir=$(realpath $(dirname $0))
echo $dir

for path in $(ls $dir); do
path=$(realpath $path)
if [ ! -d $path ];then
    continue;
fi
echo "$path"
mockolo -s $path -d $path/Mock.swift
done
