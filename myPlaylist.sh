#! /bin/zsh
echo "Welcome to Playlist Finder? How many songs do you want in Library?"
read nSongs
rm songs/*
for i in $(seq 1 $nSongs)
do
mins=$(($RANDOM%10))
secs=$(($RANDOM%60))
touch "songs/"$mins"_"$secs".mp3"
done
echo "Here are your songs?"
ls songs/
echo "How long do you wanna run?"
read runMins runSecs
# Storing times of all songs in a file
rm times.txt
ls songs/ | awk -F. '{print $1}' | awk -F_ '{print $1*60+$2}'>times.txt
targetTime=$(($runMins*60+runSecs))
declare -a dp=()


# Declaring dp array
dp_size=$((($targetTime+1)*$nSongs))
for i in $(seq 1 $dp_size)
do
dp+=(0)
done

# Initialising the dp array
for i in $(seq 1 $nSongs)
do
dp[i]=1
done
time0=$(head -1 times.txt)
if [[ $time0 -le $targetTime ]]
then
dp[(($nSongs*$time0+1))]=1
fi

#Calculating dp

for i in $(seq 1 $targetTime)
do
for j in $(seq 2 $nSongs)
do
dp[(($i*$nSongs+$j))]=$dp[(($i*$nSongs+$j-1))]
trtime=$(head "-$j" times.txt | tail -1)
if [[ $trtime -le $targetTime ]]
then
if [[ $dp[((($i-$trtime)*$nSongs+$j-1))] -eq 1 ]]
then
dp[(($i*$nSongs+$j))]=1
# dp[(($i*$nSongs+$j))]=$(( $dp[(($i*$nSongs+$j))] || $dp[((($i-$trtime)*$nSongs+$j))] ))
fi
fi
done
done
if [[ $dp[(( $nSongs*($targetTime+1) ))] -ne 1 ]]
then
echo "Sorry cannot create a playlist, unable to find suitable combination."
else
finarr=()
curVal=$targetTime
for i in $(seq $nSongs 1)
do
if [[ $curVal -eq 0 ]]
then
break
fi
timi=$(head "-$i" times.txt | tail -1)
if [[ $i -eq 1 ]]
then
finarr+=($timi)
else
if [[ $dp[(($curVal*$nSongs+$i-1))] -eq 1 ]]
then
continue
fi
finarr+=($timi)
curVal=$(($curVal-$timi))
fi
done
echo "Here are your songs enjoy"
for sng in $finarr
do
z=$(($sng/60))
ss=$(( $sng % 60 ))
echo $z"_"$ss".mp3"
done
fi
#python3 findFiles.py $runMins $runSecs

