import glob
import re
import os
import pathlib
import datetime
import time
import platform
import matplotlib.pyplot as plt
import numpy as np

for i in range(9, 18):
    v2 = glob.glob('../0331v2Data/' + str(i) + '/jpg/*.jpg')
    # v3 = glob.glob('../0331v3Data/' + str(i) + '/depth/*.png')
    if len(v2) != 0:
        v2.sort()
        sf = os.path.getmtime(v2[0])
        ff = os.path.getmtime(v2[-1])
        dt_sf = datetime.datetime.fromtimestamp(sf)
        dt_ff = datetime.datetime.fromtimestamp(ff)
        print('----------------------')
        print(i)
        print(dt_sf)
        print(dt_ff)
        print('----------------------')
    else:
        print('----------------------')
        print(i)
        print(0)
        print('----------------------')
