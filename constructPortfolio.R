# Projeto - Otimização de Portfólio

# Esse é aplicativo RStudio Shiny que constrói eficientes portfólios com base em um modelo de média-variância simples 
# e um modelo Black-Litterman (módulo não concluído). O aplicativo exibe porcentagens a serem alocadas para cada classe de ativos (assets).

# O Modelo BL combina a opinião dos investidores sobre classes de ativos no modelo de otimização de portfólio.

# Esse aplicativo foi construído em módulos. Você pode expandí-lo e agregar mais módulos e outros tipos de análises
# Para esse aplicativo, consideramos ativos americanos, por ser mais fácil encontrar documentação sobre esses ativos

library(quadprog)

# Função do módulo de construção de portfólio
constructPortfolio <- function(histReturns, covMatrix, numRVals)
{
  # Obtém a quantidade de assets
  numAssets = length(histReturns)
  
  # Variáveis
  weights = matrix(0, numAssets, numRVals)
  stdDevs = NULL
   
  # Retorno histórico
  Returns <- histReturns * 0.01
  
  # 10 taxas de retorno desejadas
  RVals = seq(min(Returns), max(Returns), length.out = numRVals)
  
  
  # Define e reolve problema de otimização com solve.QP
  Dmat <- 2*covMatrix
  dvec <- rep(0,numAssets) 
  
  # Matriz de constraints
  Amat <- matrix(cbind(rep(1,numAssets), rep(-1,numAssets), Returns, diag(numAssets)), nrow=numAssets)  
  
  for(i in 1:length(RVals)) 
    {
      bvec <- c(1,-1,RVals[i], rep(0,numAssets))
      
      # Resolvendo programação quadrática
      solution <- solve.QP(Dmat,dvec,Amat,bvec)
      
      # Obtém desvio padrão e peso do portfólio em cada iteração
      stdDevs[i] <- sqrt(solution$value)
      weights[,i] <- solution$solution
    }
  
  finalSolution <- matrix(weights, nrow=numAssets, ncol=length(RVals))
  
  # Retorna os pesos de cada classe de asset e portfólio 
  return(list(weights = finalSolution, stdDevs = stdDevs, RVals = RVals))
}




