# PACOTES ===========================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, tidyverse)
#
#
# setwd(r"(D:\Material de Estudos\IPERN\Scripts R\Ordens Bancarias)")
# setwd(r"(D:\Estagio\Scripts R\IPERN\Testes para Arrecadado\Ordens Bancárias 2020\Baixadas)")


# Função para formatar arquivo das OBs:
Format_OrdensBancarias <- function(OrdensBancarias, PP_Retenção = NULL, PP_Empenho = NULL, Órgãos = NULL, Savedir){


  # Manipulando mensagens:
  tryCatch(


    # Especificando expressão:
    expr = {


# MANIPULAÇÃO DE DADOS =============================================================================================

# Importando arquivo:
OrdensBancarias <- import(OrdensBancarias)
#
# OrdensBancarias <- import("Relatorio_04012024095451.xls")
# OrdensBancarias <- import("OB 04-2021.xls")


# Removendo algumas colunas:
OrdensBancarias <- OrdensBancarias[, -c(2, 4, 6, 8, 10:11, 13, 15:16, 18:19, 21)]


# Renomeando colunas:
names(OrdensBancarias) <- c("UG/Gestão", "OB", "Data Referência", "Domicílio Bancário Origem",
                            "PP", "Fonte Recurso", "Favorecido", "Domicílio Bancário Destino", "Valor", "Status")


# Removendo algumas linhas e reorgarnizando rownames:
OrdensBancarias <- OrdensBancarias[-c(1:(which(str_detect(OrdensBancarias$`UG/Gestão`, "\\d{6}-\\d{5}"))[1])-1), ]; rownames(OrdensBancarias) <- NULL


# Organizando dados:
OrdensBancarias <- OrdensBancarias %>%

  mutate(`OB Valor` = ifelse(!is.na(OB), Valor, NA), `PP Valor` = ifelse(!is.na(PP), Valor, NA),

         `Data Referência` = as.Date(`Data Referência`, format = "%d/%m/%Y"),

         Referência = as.Date(format(`Data Referência`, "%Y-%m-01"))) %>%

  fill(Referência, `UG/Gestão`, `OB`, `OB Valor`, `Domicílio Bancário Origem`, `Data Referência`, `Valor`, `Status`) %>%

  select(Referência, `UG/Gestão`, `Domicílio Bancário Origem`, `Data Referência`,
         OB, `OB Valor`, PP, `PP Valor`, `Fonte Recurso`, Favorecido, `Domicílio Bancário Destino`, `Status`) %>%

  filter(!is.na(PP)) %>%


  mutate(#`UG/Gestão` = str_replace(`UG/Gestão`, "-", "/"),

         OB = if_else(nchar(OB) > 12, str_sub(OB, -12), OB),

         PP = if_else(nchar(PP) > 12, str_sub(PP, -12), PP),

         `Domicílio Bancário Origem` = str_remove(`Domicílio Bancário Origem`, "\\*[^*]*\\*")) %>%

  arrange(OB, PP) %>% rowid_to_column("Índice")



# Recomendações de uso:
Aviso <- data.frame(

  Atenção = c(
    "",
    "• A coluna 'Referência' é baseada na data de referência."))



# GRs com aviso na segunda aba:
OB_Lista <- list(OrdensBancarias, Aviso)



# Notificacao de sucesso:
report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")


return(OB_Lista)


  }, # Fim do sucesso


# Especificando menssagem de erro:
error = function(e){ report_failure("Erro!", "Verifique se você selecionou as Ordens Bancárias e se elas estão em formato XLS.")} ) # Fim do erro


# EXPORTANDO DADOS =================================================================================================

# export(list(OrdensBancarias = OrdensBancarias, Divergência = Divergência),
#        paste0(Diretorio, "/Ordens Bancárias ", format(Sys.time(), "%d-%m-%Y %Hh%Mm%Ss"), ".xlsx"))

}

# a <- Format_OrdensBancarias("OBs.xls")
# export(a, "Arrecadado2.xlsx")
