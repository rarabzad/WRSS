rm(list=ls())
load(url("http://up2www.com/uploads/c7e0zarrineh.mp3"))
library(WRSS)


Q<-zarrineh$bukan$timeSeries[,1]
R<-zarrineh$bukan$timeSeries[,3]
D<-zarrineh$bukan$timeSeries[,4]
A<-zarrineh$bukan$timeSeries[,5]

discharge<-Q
target   <-R+D+A

rippl(discharge,target)