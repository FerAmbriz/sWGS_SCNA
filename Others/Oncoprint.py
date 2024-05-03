#-----------------------Librerias------------------------
import pandas as pd
import numpy as np
import sys
import os
#------------------------Data------------------------
Input=sys.argv[1]

merge = pd.read_csv(Input+'/merge.csv').drop(['Unnamed: 0'], axis=1)

#---------------------------Oncoprint----------------------
print('--------------------Oncoprint----------------------')

def allgenes2 (df):
	columns = df.columns.values
	columns = df.columns.values
	list2 = []
	list = []
	i=1
	while i < len(columns):
		arr = df[columns[i]].tolist()
		arr2 = df[columns[i+1]].tolist()
		for k in range(len(arr)):
			if arr[k] in list:
				print(arr[k], ' ese valor ya esta')
			else:
				list.append(arr[k])
				list2.append(arr2[k])
		i = i+2
	return list, list2

#----------------------- list de ID----------------------
z = pd.DataFrame(merge.value_counts('ID'))
z.columns = ['f']
z=z.reset_index()
z = z['ID'].tolist()
z = pd.DataFrame(z)
z = z.sort_values(0)
z = z[0].tolist()
#--------------------- Construction df ------------------
print('------------- Construction Oncoprint ------------')

k=[]
tipo =[]
ID = []

for i in z:
	df = merge[merge['ID']==i]
	l, t = allgenes2 (df)

	j=0
	id = []

	while j < len(l):
		id.append(i)
		j = j+1
	
	ID = id+ID
	k=l+k
	tipo = t+tipo

df_bd = pd.DataFrame()
df_bd['ID']=ID

df_bd['All_Genes']=k
df_bd['Tipo']=tipo
df_bd = df_bd.sort_values('All_Genes')

df_bd = df_bd.pivot(index='ID', columns='All_Genes')
df_bd = df_bd.T

df_bd.to_csv('/home/fer/Documents/cfDNA/Oncoprint.csv')
print('')
print('Done')

print('----------------------Input-----------------------')
print('Merge:/home/fer/Documents/cfDNA/all_Interes/All_merge.csv')

print('----------------------Output----------------------')
print('/home/fer/Documents/cfDNA/Oncoprint.csv')
