library(shiny)
source("constructPortfolio.R")

covMatrix <- matrix()
histReturns <- c()
assetClasses <- c("US Bonds", "Int'l Bonds", "US Large Growth","US Large Value", "US Small Growth", 
            "US Small Value", "Intl Dev Equity", "Intl Emerg Equity")
numViews = 1
#names(assetClasses) <- seq(1:length(assetClasses))

shinyServer(function(input, output, clientData, session) {

  #--------------------------------- Output da Tab de Descrição ----------------------------------------
  output$cMat <- renderTable({
    # Matriz de covariância padrão
    covMatrix <<- matrix(c(0.001005,0.001328,-0.000579,-0.000675,0.000121,0.000128,-0.000445,-0.000437,
                           0.001328,0.007277,-0.001307,-0.00061,-0.002237,-0.000989,0.001442,-0.001535,
                           -0.000579,-0.001307,0.059852,0.027588,0.063497,0.023036,0.032967,0.048039,
                           -0.000675,-0.00061,0.027588,0.029609,0.026572,0.021465,0.020697,0.029854,
                           0.000121,-0.002237,0.063497,0.026572,0.102488,0.042744,0.039943,0.065994,
                           0.000128,-0.000989,0.023036,0.021465,0.042744,0.032056,0.019881,0.032235,
                           -0.000445,0.001442,0.032967,0.020697,0.039943,0.019881,0.028355,0.035064,
                           -0.000437,-0.001535,0.048039,0.029854,0.065994,0.032235,0.035064,0.079958), 
                         byrow = TRUE, nrow = 8, ncol = 8)
    covMatrix
    
  }, digits = 6 
  )
  
  # Atualiza dados históricos com inputs do usuário 
  output$histReturns <- renderTable({
    histReturns <<- c(input$usBonds, input$intlBonds,
                      input$usLargeG, input$usLargeV,
                      input$usSmallG, input$usSmallV,
                      input$intlDevEq, input$intlEmergEq)
    
    data.frame(
      Asset = c("US Bonds", "Int'l Bonds", 
                "US Large Growth", "US Large Value", 
                "US Small Growth", "US Small Value",
                "Int'l Dev. Equity", "Intl Emerg Equity"),
      Return = histReturns, stringsAsFactors=FALSE)
  })
  
   

#---------------------------------- Tab da Média-Variância Simples ----------------------------------------
observe({
  histReturns <<- c(input$usBonds, input$intlBonds,
                    input$usLargeG, input$usLargeV,
                    input$usSmallG, input$usSmallV,
                    input$intlDevEq, input$intlEmergEq)
  
  solution <- constructPortfolio(histReturns, covMatrix, input$numRVals)

  list_RVals <- 1:length(solution$RVals)
  names(list_RVals) <- solution$RVals*100
  updateSelectInput(session, "selectRVals", choices = list_RVals) 
  
  # Plot dos pesos
  output$meanVarAlloc <- renderPlot({
    barplot(solution$weights[,as.numeric(input$selectRVals)], ylab = "% do Portfolio", xlab = "Classe de Ativo", main = "Alocação de Portfolio")
  })
  
  # Plot efficient frontier
  output$meanVarFrontier <- renderPlot({
    plot(solution$stdDevs, solution$RVals, type = 'b', xlab = "Risco (Desvio Padrão)", ylab = "Retorno", main = "Efficient Frontier")
  })  
})


#---------------------------------- Tab Modelo Black-Litterman ----------------------------------------
  output$ui <- renderUI({
    switch(input$selectType,
      "relative" = selectInput("newAssetClass", label = "Escolha Outra Classe de Ativos", 
                              choices=assetClasses[-which(assetClasses==input$assetClass)])
    )
  })

  observe({
    updateSelectInput(session, "newAssetClass", choices = assetClasses[-which(assetClasses==input$assetClass)])
  })


#   output$blAlloc <- renderPlot({
#     
#     
#     
#   })

})