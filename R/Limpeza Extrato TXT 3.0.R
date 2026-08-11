# ORGANIZANDO EXTRATO BANCÁRIO ==============================================================================================================================

# Tratar pdf do Extrato ----------------------------------------------------------------------------------------------

Extrair_Extrato <- function(EXTRATO){
  
  
  # Manipulando mensagens:
  tryCatch(			 
    
    
    # Especificando expressão:
    expr = {	
  
      
  # Importando dados:
  TXT <- import(EXTRATO, sep = "\t", col.names = "Dados", encoding = "Latin-1")
  
  
  # Pegando a numeracao da ultima linha (da tabela):
  ultima.linha <- TXT %>% mutate(linha = row_number()) %>%
    filter(str_detect(Dados, "S A L D O")) %>% pull()
  
  
  # Terminando filtragem dos dados:
  TXT <- TXT %>% slice(14:(ultima.linha-1))
  
  
  # Filtros Especiais ------------------------------------------------------------------------------------------------
  
  # Identificando linhas quebradas:
  linhas.in <- which(nchar(TXT$Dados) < 124)
  
  # Inserindo primeiras descricoes:
  TXT$Histórico <- str_sub(TXT$Dados, 58, 89)
  
  # Concatenando Descricao:
  Filtro.Histórico <- paste(str_sub(TXT$Dados[linhas.in - 1], 58, 89), "-", str_extract(TXT$Dados[linhas.in], "[A-Za-z].*"))
  
  # Inserindo descricoes restantes:
  TXT$Histórico[linhas.in - 1] <- Filtro.Histórico
  
  # Removendo linhas incompletas:
  TXT <- TXT[!(seq_along(TXT$Histórico) %in% linhas.in), ]
  
  
  # Filtro para organizar Valor:
  TXT <- TXT %>% mutate(Valor = ifelse(!str_detect(str_sub(Dados, 112, 127), ","),
                                       str_sub(Dados, 112, 129),
                                       str_sub(Dados, 112, 127)))
  
  # Filtros Normais --------------------------------------------------------------------------------------------------
  
  # Criando colunas:
  TXT <- TXT %>% mutate(Índice         = seq(1, nrow(.), 1),              # Índice
                        `Dt. Movimento` = str_sub(Dados, 1, 10),          # Data Movimento
                        `Dt. Balancete` = str_sub(Dados, 15, 25),         # Data Balancelete
                        `Ag. Origem`    = str_sub(Dados, 33, 37),         # Agencia de origem
                        Lote            = str_sub(Dados, 47, 52),         # Lote
                        Documento       = str_sub(Dados, 91, 112),        # Documento
                        `Tipo Valor`    = str_sub(Dados, 128, 128),       # C ou D
                        Saldo           = str_sub(Dados, 129, 143),       # Saldo
                        `Tipo Saldo`    = str_sub(Dados, 145, 145)) %>%   # C ou D
    select(4:8, 2, 9, 3, 10:12)
  
  
  # Formatacoes Finais -----------------------------------------------------------------------------------------------
  
  # Retirando espacos excessivos:
  TXT <- sapply(TXT, function(x){ str_squish(x) }) %>% as.data.frame()
  
  
  # Colocando virgula onde nao tem:
  TXT <- TXT %>% mutate(Valor = ifelse(!str_detect(Valor, ","), 
                                       paste0(str_sub(Valor, 1, (nchar(Valor) - 2)), ",", str_sub(Valor, -2)), Valor))
  
  
  # Ajustando coluna Tipo Valor:
  TXT <- TXT %>% mutate(`Tipo Valor` = ifelse(str_detect(`Tipo Valor`, "[0-9]"), "*", `Tipo Valor`))
  
  
  # Convertendo colunas para formato numerico:
  TXT <- TXT %>% mutate_at(vars(Índice, `Ag. Origem`, Lote, Valor, Saldo), ~ as.numeric(gsub(",", ".", gsub("\\.", "", .))))
  
  
  # Notificacao de sucesso:
  report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")
  
  
  return(TXT)
  
  
  }, # Fim do sucesso
  
  
  # Especificando menssagem de erro:
  error = function(e){ report_failure("Erro!", "Verifique se você selecionou o Extrato Bancário da Conta Corrente se ele está em formato TXT.")} ) # Fim do erro

    
}

