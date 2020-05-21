import pandas as pd

def showtime(x):
    return str(x)[0:4] + '-' + str(x)[4:6] + '-' + str(x)[6:8] + ' ' + str(x)[8:10] +':'+ str(x)[10:12] +':'+ str(x)[12:14] +'.'+ str(x)[14:17]

df = pd.read_csv('0520exData/training/0/pos.csv', header=None)
print(len(df))
time_df = df.iloc[:, 0].map(showtime)
print(len(time_df))
time_df.to_csv('timeindex.csv', header=False, index=False)