# install.packages(pacman)
# pacman::p_load(rio, tidyverse, pdftools)


# setwd("E:\\Estagio\\Scripts R\\Almoxarifado")
# setwd("X:\\Contabilidade\\Almoxarifado\\2023\\10 - OUTUBRO")



Format_Almoxarifado <- function(ALMOXARIFADO, DESCRIÇÃO){
  
  
  # Manipulando mensagens:
  tryCatch(			 
    
    
    # Especificando expressão:
    expr = {	
      
      
      # Importando arquivos:
      ALMOXARIFADO <- pdf_text(ALMOXARIFADO)
      
      DESCRIÇÃO <- import(DESCRIÇÃO)
      
      
      # Organização inicial:
      ALMOXARIFADO <- ALMOXARIFADO %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
      
      ALMOXARIFADO <- ALMOXARIFADO %>% mutate(Categoria = str_extract(Dados, "Categoria:(.*)")) %>% fill(Categoria)
      
      # 2 casas decimais:
      options(digits = 2)
      
      
      # Organização parte 01:
      ALMOXARIFADO_2.1 <- ALMOXARIFADO %>% 
        
        mutate(Código = as.numeric(trimws(str_sub(Dados, 1, 10))), 
               
               `Descrição do Material` = str_sub(Dados, 11, 46), 
               
               Outros = str_sub(Dados, 47), Outros = ifelse(str_detect(Outros, "Bombona"), 
                                                            
                                                            str_replace(Outros, "Bombona", "  Bombona"), Outros)) %>% 
        
        select(-1) %>% filter(str_detect(Código, "\\d{5}"))
      
      
      
      # Organização parte 02:
      ALMOXARIFADO_2.2 <- str_split(ALMOXARIFADO_2.1$Outros, "\\s{2,}") %>% data.frame() %>% t() %>% trimws()
      
      
      
      # Renomeando colunas:
      colnames(ALMOXARIFADO_2.2) <- c("Vazio", "Unidade de Medida", "Estoque Mínimo", "Estoque Atual", "Valor Unitário", "Valor Total")
      
      
      # Juntando ALMOXARIFADOS:
      ALMOXARIFADO <- cbind(ALMOXARIFADO_2.1, ALMOXARIFADO_2.2) %>% select(-c(3:5)) %>% 
        mutate(across(c(`Valor Unitário`, `Valor Total`), ~ as.numeric(gsub(",", "\\.", gsub("\\.|R\\$", "", .)))) )
      
      
      # Organizando indice do Rstudio:
      row.names(ALMOXARIFADO) <- NULL
      
      
      # Cruzando ALMOXARIFADO com planilha de DESCRIÇÃO:
      ALMOXARIFADO <- left_join(ALMOXARIFADO, DESCRIÇÃO, by = "Código") %>% select(1:2, 8, 3:7)
      
      
      # Resumindo informações:
      ALMOXARIFADO <- ALMOXARIFADO %>% group_by(Categoria) %>% summarise(Somatório = sum(`Valor Total`))
      
      
      # Notificacao de sucesso:
      report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")
      
      
      return(ALMOXARIFADO)
      
      
    }, # Fim do sucesso
    
    
    # Especificando menssagem de erro:
    error = function(e){ report_failure("Erro!", "Verifique se você selecionou o Almoxarifado e se ele está no formato PDF. Além disso, verifique se selecionou corretamente a planilha de Descrição.")} ) # Fim do erro
  
  
  # export(tabela, "Almoxarifado - 10-2023.xlsx")
  

}

# a <- Format_Almoxarifado("Almoxarifado.pdf", "Desc.xlsx")
