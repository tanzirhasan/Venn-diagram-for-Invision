setwd('C:/Users/Tanzir Hasan/Documents/R-project/New_project')

library(venneuler)
library(dplyr)
library(ggplot2)
library(scales)
make_plot <-function(filename){
library(venneuler)
library(dplyr)  
data_set <- read.csv(filename, header = TRUE)




data_set$visit.Type <- factor(rep("OutPatient",nrow(data_set) ), levels = c("OutPatient", "InPatient", "Ed","OutPatients and ED","InPatients and ED", "InPatients and OutPatient","InPatients,OutPatient & ED" ))

data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients and OutPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "N","Ed" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatients and ED" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatients and ED" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients,OutPatient & ED" ,data_set$visit.Type)



data_set <- mutate(data_set, percentage =paste(round(data_set$N_Pts/sum(data_set$N_Pts) * 100,1),"%"))







V <- venneuler(c(ED= data_set$N_Pts[4], 
                      INPT= data_set$N_Pts[2], 
                      OUTPT= data_set$N_Pts[1], 
                      "ED&INPT"= data_set$N_Pts[6], 
                      "INPT&OUTPT"= data_set$N_Pts[3], 
                      "ED&OUTPT"= data_set$N_Pts[5],
                      "ED&INPT&OUTPT"=data_set$N_Pts[7] ))


V$labels <- rep("",length(V$labels))
V$colors <- c(0.1, 0.44, 0.3) 
plot(V, main = 'Venn Diagram of Invision Patient Data- FY 15/16')
text(0.59,0.52,data_set$percentage[5])                          #ED and Outpt
text(0.44,0.55,data_set$percentage[7])                          #All 
text(0.60,0.33,paste("Outpt\n",data_set$percentage[1]))         #Outpt
text(0.30,0.53,paste("Inpt\n",data_set$percentage[2]))          #Inpt
text(0.53,0.68,paste("ED\n",data_set$percentage[4]))            #ED
text(0.37,0.60,data_set$percentage[6])                          #ED and Inpt
text(0.38,0.47,data_set$percentage[3])                          #Inpt and Outpt

}
make_plot("output_new.csv")

#============================================================================================
#install.packages("eulerr")



make_plot2 <-function(filename){
  library(eulerr)
  library(dplyr)  
  data_set <- read.csv(filename, header = TRUE)
  
  
  
  
  data_set$visit.Type <- factor(rep("OutPatient",nrow(data_set) ), levels = c("OutPatient", "InPatient", "Ed","OutPatients and ED","InPatients and ED", "InPatients and OutPatient","InPatients,OutPatient & ED" ))
  
  data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatient" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatient" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients and OutPatient" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "N","Ed" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatients and ED" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatients and ED" ,data_set$visit.Type)
  data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients,OutPatient & ED" ,data_set$visit.Type)
  
  
  
  data_set <- mutate(data_set, percentage =paste(round(data_set$N_Pts/sum(data_set$N_Pts) * 100,1),"%"))
  
  
  
  
  
  
  vd  <-euler(c(ED= data_set$N_Pts[4], 
                INPT= data_set$N_Pts[2], 
                OUTPT= data_set$N_Pts[1], 
                "ED&INPT"= data_set$N_Pts[6], 
                "INPT&OUTPT"= data_set$N_Pts[3], 
                "ED&OUTPT"= data_set$N_Pts[5],
                "ED&INPT&OUTPT"=data_set$N_Pts[7] ))
  
  
  
  
  plot(vd,key=TRUE,fill_opacity = 0.8, counts =TRUE)
  
}
make_plot2("output_new.csv")


#==================================================================================================================================================
setwd('C:/Users/Tanzir Hasan/Documents/R-project/New_project')
#install.packages("combinat")
library(venneuler)
library(dplyr)
library(combinat)
data_set <- read.csv("output_1213.csv", header = TRUE)
colnames(data_set)[-2]
length(colnames(data_set))
variable_list <- colnames(data_set)[-c(1,length(colnames(data_set)))] 
paste(variable_list[1],"&",variable_list[2])

 
for(i in 1:(length(variable_list))){
   print(paste(variable_list[length(variable_list)],"&",variable_list[length(variable_list)-i]))
}

sample(variable_list,2)
for(i in 1:(length(variable_list))){
  sample(variable_list,2)
}
