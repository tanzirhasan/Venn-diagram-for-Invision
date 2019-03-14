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
     make_plot <- function(){ 
          #if (input$datafile == 0) return(NULL) 
         df=filedata() 
         library(venneuler) 
         library(dplyr)
        
         if (is.null(df)) return(NULL) 
         if( ncol(df)== 5 ) {  
 
         df$visit.Type <- factor(rep((names(df)[[4]]),nrow(df) ), levels = c((names(df)[[4]]), (names(df)[[3]]), (names(df)[[2]]),paste((names(df)[[4]]),"&",(names(df)[[2]]),sep = ""), paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = ""), paste((names(df)[[3]]),"&",(names(df)[[4]]),sep = ""),paste((names(df)[[3]]),"&",(names(df)[[4]]), "&",(names(df)[[2]]),sep = "") ))
         
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "N" & df[,(names(df)[[3]])] == "N" & df[,(names(df)[[4]])]  == "Y",(names(df)[[4]]) ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "N" & df[,(names(df)[[3]])] == "Y" & df[,(names(df)[[4]])]  == "N",(names(df)[[3]]) ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "N" & df[,(names(df)[[3]])] == "Y" & df[,(names(df)[[4]])]  == "Y",paste((names(df)[[3]]),"&",(names(df)[[4]]),sep = "") ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "N" & df[,(names(df)[[4]])]  == "N",(names(df)[[2]]) ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "N" & df[,(names(df)[[4]])]  == "Y",paste((names(df)[[4]]),"&",(names(df)[[2]]),sep = "") ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "Y" & df[,(names(df)[[4]])]  == "N",paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = "") ,df$visit.Type)
         df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "Y" & df[,(names(df)[[4]])]  == "Y",paste((names(df)[[3]]),"&",(names(df)[[4]]), "&",(names(df)[[2]]),sep = "") ,df$visit.Type)
         
         df <- mutate(df, percentage =paste(round( df[,(names(df)[[5]])]/sum( df[,(names(df)[[5]])]) * 100,1),"%"))
      
         
         #test <- setNames( c(df[4,(names(df)[[5]])],df[2,(names(df)[[5]])],df[1,(names(df)[[5]])],df[6,(names(df)[[5]])],df[3,(names(df)[[5]])],df[5,(names(df)[[5]])],df[7,(names(df)[[5]])]), c( names(df)[[2]],names(df)[[3]],names(df)[[4]],paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = ""),paste((names(df)[[3]]),"&",(names(df)[[4]]),sep = ""),paste((names(df)[[4]]),"&",(names(df)[[2]]),sep = ""),paste((names(df)[[3]]),"&",(names(df)[[4]]), "&",(names(df)[[2]]),sep = "")))
         test <- setNames(df[,5], df[,6])
         V <- venneuler(test)
         
         
         
         
         #V$labels <- rep("",length(V$labels))
         #V$colors <- c(0.1, 0.44, 0.3) 
        # plot(V, main = 'Venn Diagram of Invision Patient Data- FY 15/16')
 #        plot(V, main = sprintf('Venn Diagram of Invision Patient Data- %s', as.character(df[1,1])))
         plot(V, main = input$title) 
         text(0.59,0.42,df$percentage[5])                          #ED and Outpt
         text(0.44,0.45,df$percentage[7])                          #All 
         text(0.60,0.66,paste(df$percentage[1]))         #Outpt
         text(0.30,0.45,paste(df$percentage[2]))          #Inpt
         text(0.53,0.30,paste(df$percentage[4]))            #ED
         text(0.37,0.39,df$percentage[6])                          #ED and Inpt
         text(0.38,0.55,df$percentage[3])                          #Inpt and Outpt
         } 
         if (ncol(df)==4){
           df$visit.Type <- factor(rep((names(df)[[2]]),nrow(df) ), levels = c((names(df)[[2]]), (names(df)[[3]]), paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = ""),"others" ))
           
           df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "N" & df[,(names(df)[[3]])] == "N" ,"others" ,df$visit.Type)
           df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "N" ,(names(df)[[2]]) ,df$visit.Type)
           df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "N" & df[,(names(df)[[3]])] == "Y" , (names(df)[[3]]),df$visit.Type)
           df$visit.Type <- ifelse(df[,(names(df)[[2]])] == "Y" & df[,(names(df)[[3]])] == "Y" ,paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = "") ,df$visit.Type)
           
           
           
           
           df <- mutate(df, percentage =paste(round( df[,(names(df)[[4]])]/sum( df[,(names(df)[[4]])][-1]) * 100,1),"%"))
           
           
           
           
           
           test <- setNames( c(df[2,(names(df)[[4]])],df[3,(names(df)[[4]])],df[4,(names(df)[[4]])]), c( names(df)[[2]],names(df)[[3]],paste((names(df)[[3]]),"&",(names(df)[[2]]),sep = "")))
           test1 <-setNames(df[,4],df[,5])
           test1[-1]
           V1 <- venneuler(test1[-1])
           
           #plot(V1, main = 'Venn Diagram of Invision Patient Data- FY 15/16')
           plot(V1, main = input$title)
           text(0.20,0.55,paste(df$percentage[3]))          #Inpt
           text(0.77,0.55,paste(df$percentage[2]))            #ED
           text(0.40,0.60,df$percentage[4])                  #ED and Inpt
           
         }
  }
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
