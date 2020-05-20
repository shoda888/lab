import glob
import re
import os
import pathlib
import datetime
import time
import platform
import matplotlib.pyplot as plt
import numpy as np

trial = {9: "backfront1", 10: "backback1", 11: "frontfront1", 
        12: "backfront2", 13: "backback2", 14: "frontfront2", 
        15: "backfront3", 16: "backback3", 17: "frontfront3"}

bfv2period = []
bfv3period = []
bflabels = [trial[9], trial[12], trial[15]]
bbv2period = []
bbv3period = []
bblabels = [trial[10], trial[13], trial[16]]
ffv2period = []
ffv3period = []
fflabels = [trial[11], trial[14], trial[17]]
left = np.arange(len(bflabels))  # numpyで横軸を設定
width = 0.3

for i in range(9, 18):
    v2 = glob.glob('../0331v2Data/' + str(i) + '/jpg/*.jpg')
    v3 = glob.glob('../0331v3Data/' + str(i) + '/depth/*.png')
    if len(v2) != 0:
        v2.sort()
        sf = os.path.getmtime(v2[0])
        ff = os.path.getmtime(v2[-1])
        dt_sf = datetime.datetime.fromtimestamp(sf)
        dt_ff = datetime.datetime.fromtimestamp(ff)
        if i % 3 == 0:
            bfv2period.append((dt_ff - dt_sf).total_seconds())
        elif i % 3 == 1:
            bbv2period.append((dt_ff - dt_sf).total_seconds())
        else:
            ffv2period.append((dt_ff - dt_sf).total_seconds())
    else:
        if i % 3 == 0:
            bfv2period.append(0)
        elif i % 3 == 1:
            bbv2period.append(0)
        else:
            ffv2period.append(0)
    if len(v3) != 0:
        v3.sort()
        sf = os.path.getmtime(v3[0])
        ff = os.path.getmtime(v3[-1])
        dt_sf = datetime.datetime.fromtimestamp(sf)
        dt_ff = datetime.datetime.fromtimestamp(ff)
        if i % 3 == 0:
            bfv3period.append((dt_ff - dt_sf).total_seconds())
        elif i % 3 == 1:
            bbv3period.append((dt_ff - dt_sf).total_seconds())
        else:
            ffv3period.append((dt_ff - dt_sf).total_seconds())
    else:
        if i % 3 == 0:
            bfv3period.append(0)
        elif i % 3 == 1:
            bbv3period.append(0)
        else:
            ffv3period.append(0)

print(bfv2period)
print(bfv3period)
print(bbv2period)
print(bbv3period)
print(ffv2period)
print(ffv3period)

p1 = plt.bar(left, bfv2period, color='r', width=width, align='center')
p2 = plt.bar(left+width, bfv3period, color='b', width=width, align='center')
plt.xticks(left + width/2, bflabels)
plt.title("Detected period by kinect v2 and v3")
plt.xlabel("Trial")
plt.ylabel("Detected period (s)")
plt.legend((p1[0], p2[0]), ("v2", "v3"), loc='lower right', fontsize=18)
plt.show()

p1 = plt.bar(left, bbv2period, color='r', width=width, align='center')
p2 = plt.bar(left+width, bbv3period, color='b', width=width, align='center')
plt.xticks(left + width/2, bblabels)
plt.title("Detected period by kinect v2 and v3")
plt.xlabel("Trial")
plt.ylabel("Detected period (s)")
plt.legend((p1[0], p2[0]), ("v2", "v3"), loc='lower right', fontsize=18)
plt.show()

p1 = plt.bar(left, ffv2period, color='r', width=width, align='center')
p2 = plt.bar(left+width, ffv3period, color='b', width=width, align='center')
plt.xticks(left + width/2, fflabels)
plt.title("Detected period by kinect v2 and v3")
plt.xlabel("Trial")
plt.ylabel("Detected period (s)")
plt.legend((p1[0], p2[0]), ("v2", "v3"), loc='lower right', fontsize=18)
plt.show()