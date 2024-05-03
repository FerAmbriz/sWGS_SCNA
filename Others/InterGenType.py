#-----------------------Librerias------------------------
import pandas as pd
import numpy as np
import sys
import os

#python InterGenType.py /home/fer/Documents/cfDNA/vcf/vcf_15kb/UEB_0208.tsv .

#------------------------Data------------------------
df_i = pd.read_csv(sys.argv[1], sep='\t')
OutputFilter = sys.argv[2]
ID_i = os.path.basename(sys.argv[1])
ID_i = os.path.splitext(ID_i)[0]

df = pd.read_csv('/home/fer/Documents/Code/cfDNA/ParaFiltrar.csv')

# Filtro
df2 = pd.ExcelFile('/home/fer/Documents/Code/cfDNA/GenesInteres.xls')
# Considerar solo una hoja de excel
df2=df2.parse('a. Gene panel info')

#---------------------DataExtraction-------------------
Oncogenes = df['Oncogenes_Gsea_2018'].array
SupresoresTumor = df ['TumorSuppresor_Gsea_2018'].array
Intogen = df['INTOGEN_2018'].array
Yates = df['Yates_2017'].array
Intogen2020 = df['Intogen_2020'].array
Otro = df2['Unnamed: 0'].array

#----------------------Funciones---------------------
def filter (x, a):
	list  = []
	i=0
	while i<np.size(x):
		if x[i] in a:
			list.append(x[i])
		else:
			list.append('NaN')
		i=i+1
	return list

def Gen (df, p):
	z = pd.DataFrame(filter(df,p))
	z = pd.DataFrame(z.value_counts())
	z.columns = ['f']
	z = z.reset_index()
	z = z[0].tolist()
	return z

def rellenado (list, max):
	i = len(list)
	while i < max:
		list.append('NaN')
		i=i+1
	return list

def type(df, gen):
	for i in range(len(df.SV_start)):
		if gen == df.Gene_name[i]: 
			indx = i
			x =df.iloc[indx]
			k = x[5]
	return k

def iterType(df, list):
	i = 0
	lst = []
	while i < len(list):
		if list[i] != 'NaN':
			lst.append(type(df,list[i]))
		else:
			lst.append('NaN')
		i = i+1
	return lst

def makedf (df, ID):
	dfl= df['Gene_name'].array
	
	a = Gen(dfl, Oncogenes)
	b = Gen(dfl, SupresoresTumor)
	c = Gen(dfl, Intogen)
	d = Gen(dfl, Yates)
	e = Gen(dfl, Intogen2020)
	f = Gen(dfl, Otro)

	x = [(len(a)), (len(b)), (len(c)), (len(d)), (len(e)), (len(f))]
	m = max(x)

	rellenado(a,m)
	rellenado(b,m)
	rellenado(c,m)
	rellenado(d,m)
	rellenado(e,m)
	rellenado(f,m)

	df_bd = pd.DataFrame()
	df_bd['Oncogenes'] = a
	df_bd['SupresoresTumor'] = b
	df_bd['Intogen2018'] = c
	df_bd['Yates'] = d
	df_bd['Intogen2020']= e
	df_bd['Otro']=f
	df_bd=df_bd.drop([0],axis=0)

	k = 0
	lID = []
	while k < len(df_bd['Oncogenes'].tolist()):
		lID.append(ID)
		k=k+1

	df_bd['ID']=lID

	x=df_bd['Oncogenes'].tolist()
	On=iterType(df,x)
	df_bd['OncoType']=On

	l=df_bd['SupresoresTumor'].tolist()
	On=iterType(df,l)
	df_bd['SupreType']=On

	x=df_bd['Intogen2018'].tolist()
	On=iterType(df,x)
	df_bd['Into2018Type']=On

	x=df_bd['Intogen2020'].tolist()
	On=iterType(df,x)
	df_bd['Into2020Type']=On

	x=df_bd['Yates'].tolist()
	On=iterType(df,x)
	df_bd['YatesType']=On

	x=df_bd['Otro'].tolist()
	On=iterType(df,x)
	df_bd['OtroType']=On

	df_bd = df_bd[['ID', 'Oncogenes','OncoType','SupresoresTumor', 'SupreType', 'Intogen2018', 'Into2018Type', 'Intogen2020', 'Into2020Type', 'Yates', 'YatesType', 'Otro', 'OtroType']]

	return df_bd

 
output = makedf(df_i, ID_i)
output.to_csv(OutputFilter+'/'+ID_i+".csv")

print('----------------------Input-----------------------')
print('Dataframe:',sys.argv[1])
print('''Filtros: /home/fer/Documents/Code/cfDNA/ParaFiltrar.csv
	/home/fer/Documents/Code/cfDNA/GenesInteres.xls''' )
print('')
print('----------------------Output----------------------')
print(OutputFilter+'/'+ID_i+".csv")
