# setwd("E:\\Estagio\\Scripts R\\Retenção Realizada")



# PACOTES ===========================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, tidyverse)


# Função para formatar arquivo das OBs:
Format_Retenção <- function(Retenção, CNPJ){
  
  
  # Manipulando mensagens:
  tryCatch(			 
    
    
    # Especificando expressão:
    expr = {	
      
      
      # MANIPULAÇÃO DE DADOS =============================================================================================
      
      # Importando arquivo de dados:
      Retenção <- import(Retenção)
      
      # Importando arquivo com CNPJs:
      CNPJ <- import(CNPJ)
      
      
      # Removendo algumas linhas e colunas, e reorgarnizando rownames:
      Retenção <- Retenção[-c(1:16), -c(3, 5, 7, 9, 11, 13)]; rownames(Retenção) <- NULL
      
      
      # Renomeando colunas:
      names(Retenção) <- c("UG/Gestão", "Retenção", "Imposto", "Nota Empenho", "Credor", "Favorecido", "Valor Retido", "Situação")
      
      
      # Organizando dados:
      Retenção <- Retenção %>% 
        
        filter(!is.na(Retenção)) %>% 
        
        mutate(`Valor Retido` = round(as.numeric(`Valor Retido`), 2)) %>% 
        
        left_join(CNPJ, by = c("Favorecido" = "Código"))
      
      
      # Notificacao de sucesso:
      report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")
      
      
      return(Retenção)
      
      
    }, # Fim do sucesso
    
    
    # Especificando menssagem de erro:
    error = function(e){ report_failure("Erro!", "Verifique se você selecionou a Retenção Realizada e se ela está em formato XLS. Além disso, verifique se você selecionou corretamente a planilha com CNPJs.")} ) # Fim do erro
  
  
  # EXPORTANDO DADOS =================================================================================================
  
  # export(list(Retenção = Retenção), paste0("Retenção - ", Retenção$`UG/Gestão`[1], ".xlsx"))
  
}


# a <- Format_Retenção("162011.xls", "CNPJs.xlsx")

