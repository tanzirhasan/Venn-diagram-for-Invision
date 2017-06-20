library(shiny) 
library(eulerr) 
 

shinyServer(function(input, output, session) { 
inserted <- c() 

##  
data_set <- read.csv("output_new.csv", header = TRUE)
data_set

data_set$visit.Type <- factor(rep("OutPatient",nrow(data_set) ), levels = c("OutPatient", "InPatient", "Ed","OutPatients and ED","InPatients and ED", "InPatients and OutPatient","InPatients,OutPatient & ED" ))

data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "N" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients and OutPatient" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "N","Ed" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "N" & data_set$OutpatientActivity == "Y","OutPatients and ED" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "N","InPatients and ED" ,data_set$visit.Type)
data_set$visit.Type <- ifelse(data_set$EDActivity == "Y" & data_set$InpatientActivity == "Y" & data_set$OutpatientActivity == "Y","InPatients,OutPatient & ED" ,data_set$visit.Type)

vd  <-euler(c(ED= data_set$N_Pts[4], 
              INPT= data_set$N_Pts[2], 
              OUTPT= data_set$N_Pts[1], 
              "ED&INPT"= data_set$N_Pts[6], 
              "INPT&OUTPT"= data_set$N_Pts[3], 
              "ED&OUTPT"= data_set$N_Pts[5],
              "ED&INPT&OUTPT"=data_set$N_Pts[7] ))
##

 
  
plot(vd,key=TRUE,fill_opacity = 0.8, counts =TRUE)
   
    
  
  
  
    # Download the plot 
    output$download_plot <- downloadHandler( 
        filename = function(){ 
             paste0("euler-", Sys.Date(), ".", input$savetype) 
           }, 
        content = function(file) { 
            switch(input$savetype, 
                                    pdf = pdf(file), 
                                    png = png(file, type = "cairo", width = 648, height = 648)) 
             print(euler_plot()) 
            dev.off() 
           } 
       ) 
   }) 
