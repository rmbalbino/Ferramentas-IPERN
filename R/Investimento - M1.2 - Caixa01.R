# setwd(r"(E:\Estagio\Scripts R\IPERN\Extratos Investimento\PDFs)")

# PDF <- pdf_text("CAIXA - PRATICO NOVO - Maio.pdf")[[1]]
# PDF <- pdf_text("Extrato CAIXA Conta 321-1 - Aplicação - CAIXA FI BRASIL IDKA IPCA 2A RF LP- DEZEMBRO - 2023.pdf")[[1]]
# PDF <- pdf_text("Extrato CAIXA Conta 321-1 - Aplicação - CAIXA FI BRASIL IDKA IPCA 2A RF LP- OUTUBRO - 2023.pdf")[[1]]


Caixa01_1 <- function(PDF){
  
  
  # Importando dados:
  PDF <- pdf_text(PDF)[[1]] %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  # PDF2 <- PDF %>% str_split("\n") %>% unlist() %>% data.frame(Dados = .)
  
  # Organizando:
  PDF <- PDF %>% 
    
    mutate(FUNDO = ifelse(str_detect(Dados, "CNPJ do"), str_remove(lead(Dados), "\\d{2}\\.\\d{3}.*"), NA), 
           
           
           CONTA = ifelse(str_detect(Dados, "Conta Corrente"), 
                          str_extract(str_extract(lead(Dados, n = 1), "(?<=-\\d{2}).*(?=\\d{2}/\\d{4})"), "\\d{3}-\\d{1}"), NA),
           
           
           CNPJ = ifelse(str_detect(Dados, "CNPJ do"), str_extract(lead(Dados), "\\d{2}\\.\\d{3}\\.\\d{3}\\/\\d{4}-\\d{2}"), NA),
           
           
           across(c(FUNDO, CONTA, CNPJ), ~ str_squish(.)),
           
           
           
           `SALDO ANTERIOR` = ifelse(str_detect(Dados, "Saldo Anterior") & str_detect(Dados, ",\\d{2}D"),
                                     paste0("-", str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),
           
           `SALDO ANTERIOR` = ifelse(str_detect(Dados, "Saldo Anterior") & str_detect(Dados, ",\\d{2}C?"),
                                     str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}"), `SALDO ANTERIOR`),
           
           
           APLICAÇÕES = ifelse(str_detect(Dados, "Aplicações") & str_detect(Dados, ",\\d{2}D"),
                               paste0("-", str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),
           
           APLICAÇÕES = ifelse(str_detect(Dados, "Aplicações") & str_detect(Dados, ",\\d{2}C?"),
                               str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}"), APLICAÇÕES),
           
           
           RESGATES = ifelse(str_detect(Dados, "Resgates") & str_detect(Dados, ",\\d{2}D"),
                             paste0("-", str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),
           
           RESGATES = ifelse(str_detect(Dados, "Resgates") & str_detect(Dados, ",\\d{2}C?"),
                             str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}"), RESGATES),
           
           
           AMORTIZAÇÃO = NA, 
           
           
           `RENTABILIDADE (%)` = ifelse(str_detect(Dados, "No Ano"), str_extract(lead(str_trim(Dados), n = 1), "\\d{1},\\d{2,}-|\\d{1},\\d{2,}"), NA),
           
           `RENTABILIDADE (%)` = ifelse(str_detect(`RENTABILIDADE (%)`, "-"), paste0("-", str_remove(`RENTABILIDADE (%)`, "-")), `RENTABILIDADE (%)`),
           
           
           RENDIMENTO = ifelse(str_detect(Dados, "Rendimento Bruto no Mês") & str_detect(Dados, ",\\d{2}D"),
                               paste0("-", str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),
           
           RENDIMENTO = ifelse(str_detect(Dados, "Rendimento Bruto no Mês") & str_detect(Dados, ",\\d{2}C?"),
                               str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}"), RENDIMENTO),
           
           
           `QTD. DE COTAS` = ifelse(str_detect(Dados, "Saldo Bruto"),
                                    str_extract(Dados, "\\d{1,}\\.\\d{1,},\\d{2,}$"), NA),
           
           
           COTA = ifelse(str_detect(Dados, "No Ano"), str_extract(lead(str_trim(Dados), n = 1), "\\d{1},\\d{2,}$"), NA),
           
           
           PL = NA,
           
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Saldo Bruto") & str_detect(Dados, ",\\d{2}D"),
                                  paste0("-", str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}")), NA),
           
           `SALDO ATUAL` = ifelse(str_detect(Dados, "Saldo Bruto") & str_detect(Dados, ",\\d{2}C?"),
                                  str_extract(Dados, "\\d{1,3}(\\.\\d{3})*,\\d{2}"), `SALDO ATUAL`),
           
           
           across(c(5:14), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))
           
           ) %>% 
    
    select(-Dados) %>% fill(CONTA, `SALDO ANTERIOR`, APLICAÇÕES, RESGATES, AMORTIZAÇÃO, `RENTABILIDADE (%)`, 
                            RENDIMENTO, `QTD. DE COTAS`, COTA, PL, `SALDO ATUAL`, .direction = "up") %>% filter(!is.na(FUNDO))
  
  
  return(PDF)
  
}

# a <- Caixa01_1("CAIXA - PRATICO NOVO - Maio.pdf")
