# Instalando e carregando pacotes
# pacman::p_load(rio, tidyverse)


# Carregar local do arquivo
# setwd("F:\\Estagio\\Scripts R\\Organizador para Milena")



Format_Plan <- function(ARQUIVOS, NOMES){


      # Funcao de intervalo:
      select_interval <- function(data, col_name) {

        # Encontrar a primeira linha que contenha "CÓD." ou "CÓDIGO" na coluna especificada
        first_row <- which(data[[col_name]] %in% c("CÓD.", "CÓD", "CÓDIGO"))[1]

        if (is.na(first_row)) {
          stop("Nenhuma linha encontrada com 'CÓD.' ou 'CÓDIGO' na coluna especificada.")
        }

        # Encontrar a última linha com texto na coluna especificada com texto
        last_row <- max(which(data[[col_name]] != ""))

        # Selecionar o intervalo do dataframe
        selected_interval <- data[first_row:last_row, ]

        return(selected_interval)
      }



      # Funcao numerica:
      get_numeric_interval <- function(data, col_name) {

        # Transformar a coluna em numerica
        data[[col_name]] <- as.numeric(as.character(data[[col_name]]))

        # Filtrar o dataframe para remover os valores NA (nao numericos) na coluna especificada
        data_filtered <- data[!is.na(data[[col_name]]), ]

        # Encontrar o intervalo de valores
        interval <- range(data_filtered[[col_name]])

        return(data_filtered[data_filtered[[col_name]] >= interval[1] & data_filtered[[col_name]] <= interval[2], ])
      }


      # Filtro dos arquivos:
      FILTRO <- str_detect(NOMES, "FL. PGTO")


      NOMES <- NOMES[FILTRO]        # Filtrando NOMES
      LINHAS <- which(FILTRO)       # Capturando linhas para filtrar ARQUIVOS
      ARQUIVOS <- ARQUIVOS[LINHAS]  # Filtrando ARQUIVOS


      # Lista para armazenar as tabelas processadas:
      tabelas_processadas <- map2(ARQUIVOS, NOMES, function(ARQUIVOS, NOMES) {

        tabela <- import(file = ARQUIVOS) # Importar tabela

        intervalo_1 <- select_interval(tabela, 1) # Pegar a tabela dentro do intervalo

        primeira_linha <- intervalo_1[1, ] # Selecionar a primeira linha

        colnames(intervalo_1) <- primeira_linha # Usar a primeira linha para virar nome das colunas

        intervalo_1 <- intervalo_1[-1, ] # Remover a primeira linha

        intervalo_2 <- get_numeric_interval(intervalo_1, "LÍQUIDO") # Utilizar outro intervalo, neste caso numerico para selecionar o ponto inicial e final da tabela

        tabela_coluna <- select(intervalo_2, 1, 2, 'LÍQUIDO', NL, OB) # Selecionando as colunas da tabela

        names(tabela_coluna) <- c("CODIGO", "CNPJ/INSC", "VALOR LIQUIDO", "NL", "OB") # Renomeando as colunas para ficar padrão

        nome_coluna <- str_remove(NOMES, ".xls|.xlsx")

        tabela_coluna <- mutate(tabela_coluna, FOLHA = nome_coluna) # Definindo o nome da nova coluna

        tabela_coluna$`VALOR LIQUIDO` <- round(tabela_coluna$`VALOR LIQUIDO`, 2) # Arredondando o valor numérico da coluna(VALOR LIQUIDO)

        tabela_coluna <- select(tabela_coluna, 6,1,2,3,4,5) # Colocando a ordem nas colunas





        tabela_coluna$`CNPJ/INSC` <- ifelse(tabela_coluna$`CNPJ/INSC` == "DEVOLUÇÃO DE SALÁRIO", NA, tabela_coluna$`CNPJ/INSC`) # Substituir "DEVOLUÇÃO DE SALÁRIO" por NA na coluna "CNPJ/INSC"
        tabela_coluna$`CNPJ/INSC` <- ifelse(tabela_coluna$`CNPJ/INSC` == "CPF/CNPJ", NA, tabela_coluna$`CNPJ/INSC`) # Substituir "CPF/CNPJ" por NA na coluna "CNPJ/INSC"
        tabela_coluna$`CNPJ/INSC` <- ifelse(tabela_coluna$`CNPJ/INSC` == "CNPJ / CPF", NA, tabela_coluna$`CNPJ/INSC`) # Substituir  por NA na coluna "CNPJ/INSC"
        tabela_coluna$`CNPJ/INSC` <- ifelse(tabela_coluna$`CNPJ/INSC` == "SINDICATO DOS TRABALHADORES DO SERV PUBLICO DA ADM DIRETA", NA, tabela_coluna$`CNPJ/INSC`) # Substituir  por NA na coluna "CNPJ/INSC"


        return(tabela_coluna)


      })


      # Unificar todas as tabelas processadas em uma única tabela:
      tabela_geral <- bind_rows(tabelas_processadas)


      return(tabela_geral)


}


# Saida do arquivo
# arquivo_saida = "Tabela Auxiliar OBs.xlsx"
#
# export(tabela_geral, arquivo_saida, format = "xlsx")

