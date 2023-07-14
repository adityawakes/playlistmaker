import os,sys,math
songs = os.listdir('songs/')
times = []
# Gets time for all the songs
for song in songs:
    time1 = song.split('.')[0]
    times.append(int(time1.split('_')[0])*60+int(time1.split('_')[1]))

targetsum = int(sys.argv[1])*60 + int(sys.argv[2])
n = len(songs)
dp=[[0 for i in range(n)] for i in range(targetsum+1)]
# Initialising the  dp
for i in range(n):
    dp[0][i]=1

if times[0]<=targetsum:
    dp[times[0]][0]=1
    
# Calculating dp
for i in range(targetsum+1):
    for j in range(n):
        if j==0:
            continue
        dp[i][j]=dp[i][j-1]
        if i>=times[j]:
            dp[i][j]=(dp[i][j] or dp[i-times[j]][j-1])

if dp[targetsum][n-1] !=1 :
    print("Sorry cannot create a playlist, unable to find suitable combination.")
    exit()

ansTimes = []
curVal = targetsum
# Finding songs by backtracing
for i in range(n, -1, -1):
    if curVal==0:
        break
    if i==0:
        ansTimes.append(times[0])
        continue
    if dp[curVal][i-1]:
        continue
    ansTimes.append(times[i])
    curVal-=times[i]
#Getting songs
print("Here are your songs! Enjoy!!")
for time in ansTimes:
    print(f'{math.floor(time/60)}_{time % 60}.mp3')