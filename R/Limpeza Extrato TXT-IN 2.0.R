# install.packages("pacman")
# pacman::p_load(rio, tidyverse)
#
#
# setwd(r"(D:\Material de Estudos\IPERN\Scripts R\Extratos Investimento\Extrato sem resumo)")


# Auxilia na extração das informaçoes no str_extract_all:
Extractor <- function(COLUNA, POSIÇÃO){ sapply(COLUNA, function(x) x[POSIÇÃO]) }


Extrair_Extrato_IN <- function(EXTRATO){


      options(scipen = 999)


      # Importando dados:
      TXT <- import(EXTRATO, sep = "\t", col.names = "Dados", encoding = "Latin-1")

      # TXT <- import("7988 - fundoInvestimentoMensal.txt 30.01.26.txt", sep = "\t", col.names = "Dados", encoding = "Latin-1")
      # TXT <- import("7988 - fundoInvestimentoMensal.txt 05.02.26.txt", sep = "\t", col.names = "Dados", encoding = "Latin-1")
      # TXT <- import("9016 - fundoInvestimentoMensal.txt 30.01.2026.txt", sep = "\t", col.names = "Dados", encoding = "Latin-1")


      # organizando dados:
      TXT <- TXT %>%

        mutate(Agência = if_else(str_detect(Dados, "Agência:"), str_extract(Dados, "\\d+-[a-zA-Z0-9]"), NA), ,

               Conta = if_else(str_detect(Dados, "Conta:"), str_extract(Dados, "\\d+-[a-zA-Z0-9]"), NA),

               Fundo = if_else(str_detect(Dados, "CNPJ"), Dados, NA),

               info = if_else(str_detect(Dados, ",") & str_detect(Dados, "[a-zA-Z]") &
                                str_detect(Dados, "\\d{2}\\/\\d{2}\\/\\d{4}") & !str_detect(Dados, "Projeção para|Projecao para"), Dados, NA),

               Data = str_extract(info, "\\d{2}\\/\\d{2}\\/\\d{4}"),


               Histórico = str_remove_all(info, "\\d{2}\\/\\d{2}\\/\\d{4}"),

               Histórico = str_remove_all(Histórico, "-?\\d{1,3}(\\.\\d{3})*,\\d+"),

               Histórico = str_squish(Histórico),


               # itemNumerico = lengths(str_extract_all(info, "-?\\d{1,3}(\\.\\d{3})*,\\d+")),


               Extração = str_extract_all(Dados, "-?\\d{1,3}(\\.\\d{3})*,\\d+"),


               Valor = Extractor(Extração, 1),

               `Quant. Cotas` = Extractor(Extração, 2),

               `Valor Cota` = if_else(str_detect(Histórico, "SALDO ATUAL"), NA, Extractor(Extração, 3)),

               `Saldo Cotas` = if_else(str_detect(Histórico, "SALDO ATUAL"), Extractor(Extração, 3), Extractor(Extração, 4)),


        ) %>% fill(Agência, Conta, Fundo) %>% filter(!is.na(info)) %>% select(-c(info, Dados, Extração)) %>% rowid_to_column("Índice")



      # Transformando em numérico:
      TXT <- TXT %>% mutate(across(c(Valor, `Quant. Cotas`, `Valor Cota`, `Saldo Cotas`), ~
                                     as.numeric(str_replace_all(str_replace_all(., "\\.", ""), ",", "\\."))) )


      return(TXT)


}

# Extrato <- Extrair_Extrato_IN(EXTRATO = "Extrato BB Investimento 7.988-X - DEZEMBRO - 2023.txt")

# export(Extrato, "teste.xlsx")
