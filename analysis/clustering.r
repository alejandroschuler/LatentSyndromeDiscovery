### new sepsis file ###

newsepsis = read.csv("~/DataFiles/BMI212/sepsisnewx.csv", header=F)
newsepsiskeys = read.csv("~/DataFiles/BMI212/sepsisnewkeys.csv", header=F)
nis2010sepsis = read.csv("~/DataFiles/BMI212/NIS2010Sepsis.csv", header=T)

newsepsis[,21] = newsepsiskeys
newsepsis.total = merge(newsepsis, nis2010, by.x="V21", by.y="key")

d.newsepsis = dist(newsepsis.total[,2:21], method="euclidean")
fit.new.sepsis = hclust(d.newsepsis, method="ward.D")
plot(fit.new.sepsis)

cut.new.sepsis = matrix(0, 83186, 19)
for (ii in 2:20) {
  jj = ii-1
  cut.new.sepsis[,jj] = cutree(fit.new.sepsis, k=ii)
}
newsepsis.dataframe = as.data.frame(cut.new.sepsis)

newsepsis.total[,107:125] = cut.new.sepsis
newsepsis.total = merge(newsepsis.total, nis2010sepsis, by.x="V21", by.y="key")

write.table(newsepsis.total, "~/DataFiles/BMI212/newsepsisoutput.csv", sep=",", row.names=F)


### new delirium ###

newdelirium = read.csv("~/DataFiles/BMI212/DeliriumNew.csv", header=F)
deliriumkeys = read.csv("~/DataFiles/BMI212/deliriumkeys.csv", header=F)

newdelirium[,21] = deliriumkeys
newdelirium.total = merge(newdelirium, nis2010, by.x="V21", by.y="key")

d.delirium = dist(newdelirium.total[,2:21], method="euclidean")
fit.new.delirium = hclust(d.delirium, method="ward.D")
plot(fit.new.delirium)
cut.new.delirium = cutree(fit.new.delirium, k=4)

newdelirium.total[,107] = cut.new.delirium

write.table(newdelirium.total, "~/DataFiles/BMI212/newdeliriumoutput.csv", sep=",", row.names=F)

### new data files: base_zeroreg_svd ###

newkeys = read.csv("~/DataFiles/BMI212/newrecordkeys.csv", header=F)
newx = read.csv("~/DataFiles/BMI212/newmodelsx.csv", header=F)
nis2010 = read.csv("~/DataFiles/BMI212/NIS Slim 2010.csv", header=T)

newx[,21] = newkeys
new.total = merge(newx, nis2010, by.x="V21", by.y="key")

d.new = dist(new.total[,2:21], method="euclidean")
fit.new = hclust(d.new, method="ward.D")
plot(fit.new)
cut.new = cutree(fit.new, k=8)
new.total[,107] = cut.new

write.table(new.total, "~/DataFiles/BMI212/newoutput.csv", sep=",", row.names=F)


### new data files: r50_reg_svd ###

newkeys = read.csv("~/DataFiles/BMI212/r50keys.csv", header=F)
newx = read.csv("~/DataFiles/BMI212/r50x.csv", header=F)
nis2010 = read.csv("~/DataFiles/BMI212/NIS Slim 2010.csv", header=T)

newx[,51] = newkeys
new.total = merge(newx, nis2010, by.x="V51", by.y="key")

d.new = dist(new.total[,2:51], method="euclidean")
fit.new = hclust(d.new, method="ward.D")
plot(fit.new)
cut.new = cutree(fit.new, k=6)
new.total[,137] = cut.new

write.table(new.total, "~/DataFiles/BMI212/r50output.csv", sep=",", row.names=F)




install.packages('fingerprint')
library(fingerprint)

deliriumkeys = read.csv("~/DataFiles/BMI212/deliriumkeys.csv", header=F)
nis2010 = read.table("/R-Projects/SRI/NIS_merged_CCS.csv", header=T, stringsAsFactors=F, sep=",", quote="\"", dec=".", fill=T)
nis2010 = nis2010[nis2010$AGE>17,]

nis2010[,2] = ifelse(nis2010[,2]==0, 1, 0)
for (ii in 3:30) {
  nis2010[,ii] = ifelse(nis2010[,ii]==0, 1, 0)
}

for (ii in 37:40) {
  nis2010[,ii] = ifelse(nis2010[,ii]==0, 1, 0)
}

for (ii in 41:45) {
  nis2010[,ii] = ifelse(is.na(nis2010[,ii]), -1, nis2010[,ii])
}
for (ii in 41:558) {
  nis2010[,ii] = ifelse(nis2010[,ii]==0, 1, 0)
}

write.table(nis2010, "/R-Projects/SRI/NIS2010Clean.csv", sep=",", row.names=F)

nis2010 = read.table("/R-Projects/SRI/NIS2010Clean.csv", header=T, sep=",")


# subset to delirium #

delirium.subset = merge(nis2010, deliriumkeys, by.x="KEY", by.y="V1")
delirium.vectors = delirium.subset[,c(2:30, 39:558)]
delrium.vectors = delirium.vectors[delirium.vectors[,1:549]==1,]


tanimoto.table = matrix(0, 38934, 38934)

for (ii in 1:38934) {
  for (jj in 1:38934) {
    tanimoto[ii,jj] = 1-(signature(delirium.vectors[ii,], delirium.vectors[jj,], a="missing", b="missing"))
  }
}


###### HINGE evaluation ####

nis2010 = read.csv("~/DataFiles/BMI212/NIS Slim 2010.csv", header=T)
hingekeys = read.csv("~/DataFiles/BMI212/recordkeyshinge.csv", header=F)
hinge = read.csv("~/DataFiles/BMI212/hingex.csv", header=F)

hinge[,21] = hingekeys
hinge.total = merge(hinge, nis2010, by.x="V21", by.y="key")

d = dist(hinge.total[,2:21], method="euclidean")
fit = hclust(d, method="ward.D")
plot(fit)
cut.hinge = cutree(fit, k=8)
hinge.total[,107] = cut.hinge

write.table(hinge.total, "~/DataFiles/BMI212/hingeoutput.csv", sep=",", row.names=F)


###### QUAD evaluation ####

nis2010 = read.csv("~/DataFiles/BMI212/NIS Slim 2010.csv", header=T)
quadkeys = read.csv("~/DataFiles/BMI212/recordkeysquad.csv", header=F)
quad = read.csv("~/DataFiles/BMI212/quadsvdx.csv", header=F)

quad[,21] = quadkeys
quad.total = merge(quad, nis2010, by.x="V21", by.y="key")

dquad = dist(quad.total[,2:21], method="euclidean")
fit.quad = hclust(dquad, method="ward.D")
plot(fit.quad)
cut.quad = cutree(fit.quad, k=6)
quad.total[,107] = cut.quad

write.table(quad.total, "~/DataFiles/BMI212/quadoutput.csv", sep=",", row.names=F)




### 





delirium = read.csv("~/DataFiles/BMI212/deliriumfile.csv", header=F)




delirium = read.csv("~/DataFiles/BMI212/deliriumfile.csv", header=F)

d = dist(delirium[,1:9], method="euclidean")
fit = hclust(d, method="complete")

plot(fit)

nis2010 = read.csv("~/DataFiles/BMI212/NIS Slim 2010.csv", header=T)
nis2010sepsis = read.csv("~/DataFiles/BMI212/NIS2010Sepsis.csv", header=T)


sepsis = read.csv("~/DataFiles/BMI212/sepsisx.csv", header=F)
sepsiskeys = read.csv("~/DataFiles/BMI212/sepsiskeys.csv", header=F)
sepsis = as.data.frame(t(sepsis))
sepsis[,10] = sepsiskeys
colnames(sepsis)[10] = "key2"

sepsis.total = merge(sepsis, nis2010sepsis, by.x="key2", by.y="key")
sepsis.complete = merge(sepsis.total, nis2010, by.x="key2", by.y="key")

sepsis.total2 = sepsis.complete
d = dist(sepsis.total2[,2:10], method="euclidean")
fitsepsis = hclust(d, method="ward.D")
plot(fitsepsis)
cut.sepsis = cutree(fitsepsis, k=8)
sepsis.total2[,97] = cut.sepsis

sepsis.table = table(sepsis.total2$sepsis, sepsis.total2$V97)
prop.table(sepsis.table,1)
prop.table(sepsis.table,2)

write.table(sepsis.total2, "~/DataFiles/BMI212/sepsisoutput.csv", sep=",", row.names=F)

sepsis.total3 = sepsis.total
d2 = dist(sepsis.total3[,2:10], method="manhattan")
fitsepsis2 = hclust(d, method="ward.D")
plot(fitsepsis)
cut.sepsis2 = cutree(fitsepsis2, k=10)
sepsis.total3[,12] = cut.sepsis2

sepsis.table2 = table(sepsis.total3$sepsis, sepsis.total3$V12)
prop.table(sepsis.table2,1)
prop.table(sepsis.table2,2)


sepsis.total4 = sepsis.total
d3 = dist(sepsis.total4[,2:10], method="euclidean")
fitsepsis3 = hclust(d, method="complete")
plot(fitsepsis3)
cut.sepsis3 = cutree(fitsepsis3, k=10)
sepsis.total4[,12] = cut.sepsis3

sepsis.total2 = sepsis.total
sepsis.total2[,12] = cut.sepsis2

sepsis.table3 = table(sepsis.total4$sepsis, sepsis.total4$V12)
prop.table(sepsis.table3,1)
prop.table(sepsis.table3,2)


sepsis.total5 = sepsis.total
kcsepsis = kmeans(sepsis.total5[,2:10], 8)
sepsis.total5[,12] = kcsepsis[[1]]
sepsis.table4 = table(sepsis.total5$sepsis, sepsis.total5$V12)
prop.table(sepsis.table4,1)
prop.table(sepsis.table4,2)


## delirium data ##

delirium.total = merge(delirium, nis2010, by.x="V10", by.y="key")
dist.delirium = dist(delirium.total[,2:10], method="euclidean")

fitdelirium = hclust(dist.delirium, method="ward.D")
plot(fitdelirium)
cut.delirium = cutree(fitdelirium, k=3)
delirium.total[,96] = cut.delirium

write.table(delirium.total, "~/DataFiles/BMI212/deliriumoutput.csv", sep=",", row.names=F)


## delirium data, version 2 ##
delirium2 = read.csv("~/DataFiles/BMI212/deliriumx2.csv", header=F)
deliriumkeys = read.csv("~/DataFiles/BMI212/deliriumkeys.csv", header=F)

delirium2[,10] = deliriumkeys

delirium.total2 = merge(delirium2, nis2010, by.x="V10", by.y="key")

write.table(delirium.total2, "~/DataFiles/BMI212/deliriumoutput2.csv", sep=",", row.names=F)
