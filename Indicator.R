install.packages('indicspecies') 

library(indicspecies)  

#groups 

group<-colnames(df)#you need to assign groups. Indicspecies looks for ASV based on groups that you assign 

meta<-MAP$division  

write.csv(group, 'group.csv', col.names = FALSE) #to assign groups 

write.csv(meta, 'meta.csv',col.names = FALSE) #to know what groups are  
#assigning groups was done in excel.... sorry :( Basically I use the meta file to know who is who and assigned numbers to my designated groups in the group files
#You  just need to somehow tell indicspecies what counts as a site 

val<-group$Value 

val<-as.vector(val) #your groups assignment must be a vector and numeric  

#working file is named df 

df<-asv[rowSums(asv[])>0,]#remove any zeros 

dim(df) 

df<-df[rowSums(df[])>20000,] #filter it down to make less computationally demanding 

dim(df) 

tdf<-t(df)#transpose for analysis  

#name<-group$Division 

#iva<-indval(df, group$Value) 

inv<-multipatt(tdf, val, func = 'IndVal.g', control = how(nperm = 9999), print.perm = TRUE) #indicator species code  


