library(shiny)


shinyUI(navbarPage("Otimização de Portfolio",
             
  tabPanel("Descrição da App",
    sidebarLayout(
      sidebarPanel(
          p("Este aplicativo constrói eficientes portfólios contendo 8 classes de ativos com base em dois modelos:
            Um modelo de otimização da média-variância simples e um modelo Black-Litterman (BL) que
            é baseado nas crenças dos investidores sobre os retornos nas classes de ativos. As saídas finais são percentagens
            de cada ativo que você deve alocar nas carteiras para obter o nível mínimo de risco para um
            retorno desejado. As fronteiras eficientes para ambos os modelos são traçadas para comparação."),
          br(),
          p("Os retornos históricos para cada classe de ativos são especificados na guia pressupostos e 
            incluídos também na Matriz de covariância usada para calcular os pesos ótimos da carteira."),
          br(),
          helpText("Você pode optar por ajustar os retornos históricos. Os valores estão em percentagens."),
          numericInput("usBonds", label = strong("US Bonds"), min=0, max=100, value = .08),
          numericInput("intlBonds", label = strong("Intl Bonds"), min=0, max=100, value = .067),
          numericInput("usLargeG", label = strong("US Large Growth"), min=0, max=100, value = 6.41),
          numericInput("usLargeV", label = strong("US Large Value"), min=0, max=100, value = 4.08),
          numericInput("usSmallG", label = strong("US Small Growth"), min=0, max=100, value = 7.43),
          numericInput("usSmallV", label = strong("US Small Value"), min=0, max=100, value = 3.70),
          numericInput("intlDevEq", label = strong("Intl Dev Equity"), min=0, max=100, value = 4.80),
          numericInput("intlEmergEq", label = strong("Intl Emerg Equity"), min=0, max=100, value = 6.60)
          
      ),
      mainPanel(
        tabsetPanel(type="tabs",
          tabPanel("Suposições de Entrada",        
            h4("Matriz de Covariância de Excessos de Retorno"),
              tableOutput("cMat"),
            
            h4("Retornos históricos de classes de ativos"),
            tableOutput("histReturns")
          
          ),
          tabPanel("Modelo Black-Litterman"))
        )
  )
  ),  
                                
  tabPanel("Modelo Média-Variância",
    sidebarLayout(
      sidebarPanel(
        
      ),
             
      mainPanel(
        numericInput("numRVals", label = strong("Quantas Taxas de Retorno Você quer Simular?"), min = 0, max = 500, value = 5),
        selectInput("selectRVals", label = "Especifique a Taxa de Retorno", c("label 1" = "option1")),
        plotOutput("meanVarAlloc"),
        plotOutput("meanVarFrontier")
        )
          )),
  
  tabPanel("Modelo Black-Litterman",
    sidebarLayout(
      sidebarPanel(
        
        ),
      mainPanel(
         numericInput("tau", label = "Especifique o índice τ", min = 0, max = 500, value = 2.5),
         selectInput("selectType", label = "A sua opinião é absoluta ou relativa?", choices=list("absolute","relative")),
         selectInput("assetClass", label = "Escolha uma classe de ativo", 
                     choices = c("US Bonds", "Int'l Bonds", "US Large Growth","US Large Value",  
                               "US Small Growth", "US Small Value", "Intl Dev Equity", "Intl Emerg Equity")),
         numericInput("viewInput", label = "A sua avaliação sobre esta classe de ativos", min = 0, max = 100, value = 4.1),
         uiOutput("ui"),
         
        plotOutput("blAlloc")
        )
      )                 
  )
  )
)