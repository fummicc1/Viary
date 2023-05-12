base=$(realpath $(dirname $0))

dir[0]=$base/EmotionDetection/Sources/EmotionDetection
dir[1]=$base/LocalDataStore/Sources/LocalDataStore
dir[2]=$base/Repositories/Sources/Repositories
dir[3]=$base/SpeechToText/Sources/SpeechToText

dir[4]=$base/UseCases/ViaryUseCase/Sources/ViaryUseCase


for path in ${dir[@]}; do
path=$(realpath $path)
if [ ! -d $path ];then
    continue;
fi
echo "$path"
mockolo -s $path -d $path/Mock.swift --disable-combine-default-values
done
