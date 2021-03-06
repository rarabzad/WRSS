###---------- loading data and packages
rm(list=ls())
load(url("http://up2www.com/uploads/c7e0zarrineh.mp3"))

library(WRSS)
library(GA)

###---------- constructing Bukan dam and other dams
Area<-createArea(name='Zerrineh',location='Kurdistan',simulation=list(start='1900-01-01',end='1909-12-01',interval='month'))
Q<-zarrineh$bukan$timeSeries[,1]
E<-zarrineh$bukan$timeSeries[,2]
R<-zarrineh$bukan$timeSeries[,3]
D<-zarrineh$bukan$timeSeries[,4]
A<-zarrineh$bukan$timeSeries[,5]/1000
RC<-zarrineh$bukan$ratingCurve
min<-zarrineh$bukan$capacity[1]$min
max<-zarrineh$bukan$capacity[2]$max
bukan<-createReservoir(name='Bukan',netEvaporation=E,geometry=list(deadStorage=min,capacity=max,storageAreaTable=RC))
River<-createRiver(name='Zarrineh',downstream=bukan,discharge=Q)
R<-createDemandSite(name='Requirement',demandTS=R,suppliers=list(bukan),priority=1)
D<-createDemandSite(name='Domestic',demandTS=D,suppliers=list(bukan),priority=2)
A<-createDemandSite(name='Agriculture',demandTS=A,suppliers=list(bukan),priority=3)
Area<-addObjectToArea(Area,River)
Area<-addObjectToArea(Area,bukan)
Area<-addObjectToArea(Area,R)
Area<-addObjectToArea(Area,D)
Area<-addObjectToArea(Area,A)

###---------- Expand Grid simulation of Bukan dam capacity and irrigatable crop area
Crop<-seq(500,2000,100)
Cap<-seq(500,2000,100)
Rel<-array(NA,c(length(Crop),length(Cap),3))
for (i in 1:length(Crop))
{
    for(j in 1:length(Cap))
    {
        Area$operation$reservoirs[[1]]$operation$geometry$capacity<-Cap[j]
        Area$operation$demands[[3]]$operation$demandTS$demand<-zarrineh$bukan$timeSeries[,5]*Crop[i]/1000
        Rel[i,j,]<-as.vector(risk(sim(Area))[2,])
    }
}

###---------- Plotting results
oask <- devAskNewPage(TRUE)
on.exit(devAskNewPage(oask))
filled.contour(x=Crop,y=Cap,z=Rel[,,1],color.palette=jet.colors,main='Water Requirement',xlab='Crop Area (Ha)',ylab='Capacity (MCM)')
filled.contour(x=Crop,y=Cap,z=Rel[,,2],color.palette=jet.colors,main='Domestic',xlab='Crop Area (Ha)',ylab='Capacity (MCM)')
filled.contour(x=Crop,y=Cap,z=Rel[,,3],color.palette=jet.colors,main='Agriculture',xlab='Crop Area (Ha)',ylab='Capacity (MCM)')
