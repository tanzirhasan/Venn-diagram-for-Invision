shinyServer(function(input, output) { 
      
    #This function is repsonsible for loading in the selected file 
    filedata <- reactive({ 
         infile <- input$datafile 
       if (is.null(infile)) { 
            # User has not uploaded a file yet 
             return(NULL) 
          } 
         read.csv(infile$datapath) 
       }) 
      
    
      
     #This previews the CSV data file 
     output$filetable <- renderTable({ 
         filedata() 
       }) 
     
     
     
     
     output$distPlot <- renderPlot({
       # generate bins based on input$bins from ui.R
       df=filedata() 
       make_plot()
       
       
       
     })
     
    #This function is the one that is triggered when the action button is pressed 
     #The function is a geocoder from the ggmap package that uses Google maps geocoder to geocode selected locations 
     make_plot <- reactive({ 
          #if (input$datafile == 0) return(NULL) 
         df=filedata() 
         if (is.null(df)) return(NULL) 
          
         library(venneuler) 
         library(dplyr) 
         df$visit.Type <- factor(rep("OutPatient",nrow(df) ), levels = c("OutPatient", "InPatient", "Ed","OutPatients and ED","InPatients and ED", "InPatients and OutPatient","InPatients,OutPatient & ED" ))
         
         df$visit.Type <- ifelse(df$EDActivity == "N" & df$InpatientActivity == "N" & df$OutpatientActivity == "Y","OutPatient" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "N" & df$InpatientActivity == "Y" & df$OutpatientActivity == "N","InPatient" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "N" & df$InpatientActivity == "Y" & df$OutpatientActivity == "Y","InPatients and OutPatient" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "Y" & df$InpatientActivity == "N" & df$OutpatientActivity == "N","Ed" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "Y" & df$InpatientActivity == "N" & df$OutpatientActivity == "Y","OutPatients and ED" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "Y" & df$InpatientActivity == "Y" & df$OutpatientActivity == "N","InPatients and ED" ,df$visit.Type)
         df$visit.Type <- ifelse(df$EDActivity == "Y" & df$InpatientActivity == "Y" & df$OutpatientActivity == "Y","InPatients,OutPatient & ED" ,df$visit.Type)
         df <- mutate(df, percentage =paste(round(df$N_Pts/sum(df$N_Pts) * 100,1),"%"))
      
         
         V <- venneuler(c(ED= df$N_Pts[4], 
                          INPT= df$N_Pts[2], 
                          OUTPT= df$N_Pts[1], 
                          "ED&INPT"= df$N_Pts[6], 
                          "INPT&OUTPT"= df$N_Pts[3], 
                          "ED&OUTPT"= df$N_Pts[5],
                          "ED&INPT&OUTPT"=df$N_Pts[7] ))
         
         
         V$labels <- rep("",length(V$labels))
         V$colors <- c(0.1, 0.44, 0.3) 
         plot(V, main = 'Venn Diagram of Invision Patient Data- FY %')
         text(0.59,0.52,df$percentage[5])                          #ED and Outpt
         text(0.44,0.55,df$percentage[7])                          #All 
         text(0.60,0.33,paste("Outpt\n",df$percentage[1]))         #Outpt
         text(0.30,0.53,paste("Inpt\n",df$percentage[2]))          #Inpt
         text(0.53,0.68,paste("ED\n",df$percentage[4]))            #ED
         text(0.37,0.60,df$percentage[6])                          #ED and Inpt
         text(0.38,0.47,df$percentage[3])                          #Inpt and Outpt
         
  }) 
     # Download the plot 
     output$download_plot <- downloadHandler( 
       filename = function(){ 
         paste0("Vennuler-", Sys.Date(), ".", input$savetype) 
       }, 
       content = function(file) { 
         switch(input$savetype, 
                pdf = pdf(file), 
                png = png(file, type = "cairo", width = 648, height = 648)) 
         print( make_plot()) 
         dev.off() 
       } 
     )
})
  