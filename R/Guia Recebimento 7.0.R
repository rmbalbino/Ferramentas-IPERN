# PACOTES ============================================================================================================

# install.packages("pacman")
# pacman::p_load(rio, tidyverse)
# 
# setwd(r"(X:\Contabilidade\ATUARIA\Guias Recebimento\2023\GRs Baixadas)")
# setwd(r"(D:\Estagio\Scripts R\IPERN\Testes para Arrecadado\Guia Recebimento\Guia Recebimento 2020\Baixadas)")
# setwd(r"(D:\Material de Estudos\IPERN\Scripts R\Guias de Recebimento)")


# EXTRAIR PLANILHA ===================================================================================================

# Função para formatar arquivo das OBs:
Format_GR <- function(GR, CLASSIFICAÇÃO = NULL, ÓRGÃOS = NULL, Savedir){


  # Manipulando mensagens:
  tryCatch(


    # Especificando expressão:
    expr = {


# MANIPULAÇÃO DE DADOS =============================================================================================

# Importando arquivos:
GR <- import(GR)
# 
# GR <- import("12 - GR DEZEMBRO.xls")
# GR <- import("GR 05-2020.xls")


# Criando coluna UG/Gestão:
GR <- GR %>% mutate(UG = if_else(str_detect(...1, "Unidade Gestora"), ...3, NA), 
                    Gestão = if_else(str_detect(...1, "Gestão"), ...3, NA)) %>% 
  
  fill(Gestão, .direction = "up") %>% 
  
  mutate(`UG/Gestão` = if_else(!is.na(UG), paste0(UG, "-", Gestão), UG)) %>% 
  
  fill(`UG/Gestão`)


# Identificando primeira linha em que aparece GR e subtraindo 1:
nGR <- which(str_detect(GR[, 1], "GR"))[1] - 1


# Removendo algumas linhas e colunas, e reorgarnizando rownames:
GR <- GR[-c(1:nGR), -c(6, 9:11)]#; rownames(GR) <- NULL


# Renomeando colunas:
names(GR) <- c("GR", "Evento", "Banco/Data", "Recolhedor", "Classificação", "Fonte Recurso", "Valor", "UG/Gestão")


# Formatando dados:
GR <- GR %>% 
  
  mutate(`Inscrição` = if_else(!is.na(Evento) & nchar(`Banco/Data`) > 11, `Banco/Data`, NA), 
         
         `Data Referência` = ifelse(!is.na(GR), `Banco/Data`, NA), 
         
         `Data Referência` = as.Date(as.numeric(`Data Referência`), origin = "1899-12-30"), 
         
         # `Data Referência` = format(`Data Referência`, "%d/%m/%Y"), 
         
         Recolhedor = if_else(!is.na(GR) & is.na(Recolhedor), "VAZIO", Recolhedor), 
         
         `Fonte Recurso` = ifelse(str_sub(Evento, 1, 1) == "8", `Fonte Recurso`, NA), 
         
         Valor = round(as.numeric(Valor), 2), Valor = ifelse(str_sub(Evento, 1, 1) == "8", Valor, NA), 
         
         Competência = as.Date(format(`Data Referência`, "%Y-%m-01")), 
         
         
  ) %>% 
  
  fill(Competência, GR, Evento, `UG/Gestão`, Recolhedor, `Inscrição`, `Data Referência`) %>% 
  
  select(Competência, `UG/Gestão`, Recolhedor, 
         `Inscrição`, GR, Evento, Classificação, `Data Referência`, `Fonte Recurso`, Valor) %>% 
  
  filter(!is.na(Valor)) %>% group_by(GR) %>% mutate(`GR Valor` = round(sum(Valor), 2)) %>% 
  
  
  mutate(Recolhedor = if_else(Recolhedor == "VAZIO", NA, Recolhedor), 
         
         # Coluna para Estorno estonos no excel:
         Estorno = if_else(str_detect(Evento, "E"), "Sim", NA), 
         
         GR = if_else(nchar(GR) > 12, str_sub(GR, -12), GR)) %>% 
  
  arrange(GR) %>% rowid_to_column("Índice")




# Retirando GRs estornadas:
GR_sem_Estornos <- GR %>% 
  
  filter(!str_detect(Evento, "E")) %>% arrange(rev(Índice)) %>% 
  
  group_by(`UG/Gestão`, Recolhedor, Inscrição, Evento, Classificação, `Data Referência`, `Fonte Recurso`, Valor, `GR Valor`) %>% 
  
  mutate(Frequência = row_number())


# Apenas GRs estornadas:
GR_Estono <- GR %>% 
  
  filter(str_detect(Evento, "E")) %>% mutate(Evento2 = str_remove(Evento, " E")) %>% 
  
  group_by(`UG/Gestão`, Recolhedor, Inscrição, Evento, Classificação, `Data Referência`, `Fonte Recurso`, Valor, `GR Valor`) %>% 
  
  mutate(Frequência = row_number())


# GRs lançadas erradas:
GR_Errada <- GR_sem_Estornos %>% 
  
  left_join(GR_Estono, by = c("UG/Gestão", "Recolhedor", "Inscrição", "Evento" = "Evento2", 
                              "Classificação", "Data Referência", "Fonte Recurso", "Valor", "GR Valor", "Frequência")) %>% 
  
  ungroup() %>% select(Índice.x, Estorno.y) %>% rename_all(~ str_remove(.x, "\\.(x|y)$")) %>% filter(Estorno == "Sim")



# GRs corretas
GR_Final <- GR %>% left_join(GR_Errada, by = c("Índice")) %>% 
  
  mutate(Estorno = coalesce(Estorno.y, Estorno.x)) %>% select(-c(Estorno.y, Estorno.x))



# GRs estornadas que não foram conciliadas:
Estorno_nao_Conciliado <- GR_Final %>% ungroup() %>% 
  
  filter(Estorno == "Sim") %>% select(-c(Índice, GR, Evento)) %>% 
  
  group_by(across(everything())) %>% filter(n() == 1) %>% ungroup()



GR_Final2 <- GR_Final %>% left_join(Estorno_nao_Conciliado, 
                                    by = c("Competência", "UG/Gestão", "Recolhedor", "Inscrição", "Classificação", 
                                           "Data Referência", "Fonte Recurso", "Valor", "GR Valor")) %>% 
  
  rename(Análise = Estorno.y, Estorno = Estorno.x) %>% 
  
  mutate(Análise = if_else(!str_detect(Evento, " E"), NA, Análise), 
         Valor = if_else(str_detect(Evento, "E"), Valor * (-1), Valor), 
         `GR Valor` = if_else(str_detect(Evento, "E"), `GR Valor` * (-1), `GR Valor`), 
         Observação = NA)




# Saber se o somatório dos valores estornados e dos considerados errados são iguais:

Total_Estornado <- GR_Final2 %>% ungroup() %>% filter(Estorno == "Sim", str_detect(Evento, "E")) %>% select(Valor) %>% sum()

Total_Considerado_Errado <- GR_Final2 %>% ungroup() %>% filter(Estorno == "Sim", !str_detect(Evento, "E")) %>% select(Valor) %>% sum()



Frase = paste("O somatório dos valores estornados + valores considerados errados resulta em", Total_Estornado + Total_Considerado_Errado)



# Recomendações de uso:
Aviso <- data.frame(Atenção = c(
  
  "", 
  
  "• A coluna 'Competência' é baseada na data de referência.", 
  
  "", 
  
  "• GRs estornadas:", 
  
  "    Apresentam valores negativos;", 
  
  "    São identificadas na coluna 'Estorno' junto aos seus pares, resultando em soma 0;", 
  
  "    Para lançamentos duplicados, o lançamento que é compreendido como errado é o segundo.", 
  
  "    O SIGEF pode fazer uma GR automática e, em alguns casos, o estorno pode ter Evento diferente. Nesse caso, não haverá identificação automática na coluna 'Estorno';", 
  
  "    Quando a soma for diferente de 0, existirão GRs identificadas na coluna 'Análise';",
  
  "    Para remover GRs erradas do seu somatório, você pode: simplesmente fazer o somatório sem considerar quais GRs estão erradas ou identificar cada uma e adicionar 'Sim' na coluna 'Estorno', para filtrar as vazias e realizar o somátório.", 
  
  "", 
  
  Frase))



# GRs com aviso na segunda aba:
GR_Lista <- list(GR_Final2, Aviso)




# Notificacao de sucesso:
report_success("Organização Finalizada!", "Agora selecione a pasta de sua preferência para baixar o arquivo e utilizá-lo em suas atividades.")


  return(GR_Lista)


}, # Fim do sucesso


# Especificando menssagem de erro:
error = function(e){ report_failure("Erro!", "Verifique se você selecionou a Guia Recebimento e se ela está em formato XLS.")} ) # Fim do erro
# 
# EXPORTANDO DADOS =================================================================================================
# 
# export(list(GRs = GR), paste0(Diretorio, "/Guias Recebimento ", format(Sys.time(), "%d-%m-%Y %Hh%Mm%Ss"), ".xlsx"))
# export(Tabela, "Mytest.xlsx")
# 
}


# a <- Format_GR("Relatorio_21122023103341.xls", "Classificação.xlsx", "Órgãos.xlsx")
# a <- Format_GR("Relatorio_21122023103341.xls")
