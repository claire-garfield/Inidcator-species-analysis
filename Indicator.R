install.packages('indicspecies')
library(indicspecies)


#groups
group<-colnames(df)#you need to assign groups. Indicspecies looks for ASV based on groups that you assign
meta<-MAP$division 
write.csv(group, 'group.csv', col.names = FALSE) #to assign groups
write.csv(meta, 'meta.csv',col.names = FALSE) #to know what groups are 
val<-group$Value
val<-as.vector(val) 

#working file is named df
df<-asv[rowSums(asv[])>0,]#remove any zeros
dim(df)
df<-df[rowSums(df[])>20000,] #filter it down to make less computationally demanding
dim(df)
tdf<-t(df)#transpose for analysis

#name<-group$Division
#iva<-indval(df, group$Value)
inv<-multipatt(tdf, val, func = 'IndVal.g', control = how(nperm = 9999), print.perm = TRUE) #indicator species code 
#https://stats.stackexchange.com/questions/370724/indiscpecies-multipatt-and-overcoming-multi-comparrisons
summary(inv)

inv$sign #use for plot


#asv that have significant p value, irrespective of group
library(dplyr)
AS<-left_join(asv.significant, rownames_to_column(tax, var = 'ASV'))

d<-rownames(AS)
write.csv(d, 'labeled.csv')
write.csv(A, 'A.csv')

asv.significant  <- inv$sign %>% dplyr::filter(p.value < 0.05) %>% #rownames_to_column(var = 'ASV')
  rownames()
AS = AS %>% unite("rename", ASV, Genus, sep = ":", remove = F) %>% column_to_rownames(var = "rename")
df[asv.significant, tax]
AS2 = A[match(rownames(A), rownames(AS))]

#my.pallette<-brewer.pal(name = 'PuBuGn', n = 3)



gplots::heatmap.2(as.matrix(df[asv.significant,]),trace='none',scale='row',ColSideColors = col1[meta])
gplots::heatmap.2(as.matrix(inv$A[asv.significant,1:7]),trace='none', xlab = 'Algal Division',
                  col = my.pallette)
gplots::heatmap.2(as.matrix(inv$B[asv.significant,1:7]),trace='none')

par(cex.main=1, cex.lab=0.5, cex.axis=0.5)

q<-gplots::heatmap.2(A, trace = 'none',xlab = 'Algal Division', margins=c(10,5), lwid = c(5,15), lhei = c(5,15)) 
summary(inv)
q


