# setwd(r"(H:\Estagio\Scripts R\IPERN\Conciliador\FIcha Razão)")


Conc_Raz <- function(MesAno, Tipo.Conciliacao, Razao){


      # Organizando inputs:
      MesAno <- paste0(month(MesAno), "/", year(MesAno))
      Razao <- Extrair_Razao(Razao)


      # Filtragens e modificacoes necessarias ----------------------------------------------------------------------------

      # Cria Razao filtrado D e colunas para identificar a quantidade de vezes que valores aparecem:
      RazaoD <- Razao %>% filter(`Tipo Movimento` == "D") %>% group_by(Movimento) %>% mutate(Frequencia = row_number())


      # Preparando Razaoc:
      RazaoC1 <- Razao %>% filter(`Tipo Movimento` == "C")

      # Criando coluna de frequencia correta para RazaoC:
      RazaoC2 <- RazaoC1 %>%
        group_by(`Documento Contábil`) %>% summarise(Somatorio = round(sum(Movimento), 2)) %>%
        group_by(Somatorio) %>% mutate(Frequencia = row_number())

      # Adicionando frequencia correta e criando RazaoC:
      RazaoC <- RazaoC1 %>% left_join(RazaoC2, by = "Documento Contábil") %>%
        select(-Somatorio) %>% rename_all(~sub("\\.x$", "", .))


      # Somatorio de OBs repetidas (C do Razao):
      RazaoCSoma <- RazaoC %>%
        group_by(`Documento Contábil`) %>%
        mutate(`Índice Razao` = row_number(),
               `Índice Razao` = ifelse(min(Índice) == max(Índice),
                                       as.character(Índice),
                                       paste(min(Índice), max(Índice), sep = "-")),
               Valor = round(sum(Movimento), 2))


      # Somatorio de OBs repetidas e sumarizando-as (C do Razao):
      RazaoCSoma2 <- RazaoCSoma %>%
        summarise(Índice = unique(`Índice Razao`), Valor = unique(Valor)) %>%
        group_by(Valor) %>% mutate(Frequencia = row_number()) #%>% select(-`Documento Contábil`)


      # Razao para conciliacoes onde o somatorio e desnecessario:
      RazaoCIND <- RazaoC1 %>% group_by(Movimento) %>% mutate(Frequencia = row_number())



      # Conciliacao do Razao ---------------------------------------------------------------------------------------------

      if(Tipo.Conciliacao == "Avançado"){


        # Concilia D do Razao com o C do Extrato:
        Conciliacao.01A <- RazaoD %>%

          left_join(RazaoCSoma2, by = c("Frequencia", "Movimento" = "Valor")) %>%

          mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Movimento, NA),
                 `Índice Conciliação 2` = ifelse(!is.na(Índice.y), as.character(Índice.x), NA)) %>%

          rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice.y") %>%

          select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento,
                 `Tipo Movimento`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Índice Conciliação 2`, `Valor Conciliação`)


        # Concilia C do Razao com o D do Razao:
        Conciliacao.02A <- RazaoCSoma %>%

          left_join(Conciliacao.01A, by = c("Índice Razao" = "Índice Conciliação", "Valor" = "Valor Conciliação")) %>%

          mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Valor, NA)) %>%

          rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice Conciliação 2") %>%

          select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento,
                 `Tipo Movimento`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Valor Conciliação`)


        Conciliacao.final <- Conciliacao.01A %>% select(-`Índice Conciliação 2`) %>% bind_rows(Conciliacao.02A) %>% arrange(Índice)



      } else if(Tipo.Conciliacao == "Simples"){


        # Concilia D do Razao com o C do Extrato:
        Conciliacao.01S <- RazaoD %>%

          left_join(RazaoCIND, by = c("Frequencia", "Movimento")) %>%

          mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Movimento, NA)) %>%

          rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice.y") %>%

          select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento,
                 `Tipo Movimento`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Valor Conciliação`)



        # Concilia C do Razao com o D do Razao:
        Conciliacao.02S <- RazaoCIND %>%

          left_join(RazaoD, by = c("Frequencia", "Movimento")) %>%

          mutate(`Valor Conciliação` = ifelse(!is.na(Índice.y), Movimento, NA)) %>%

          rename_all(~sub("\\.x$", "", .)) %>% rename("Índice Conciliação" = "Índice.y") %>%

          select(Índice, Data, `Unidade Gestora`, Gestão, `Documento Contábil`, Evento, Movimento,
                 `Tipo Movimento`, Saldo, `Tipo Saldo`, `Índice Conciliação`, `Valor Conciliação`)


        Conciliacao.final <- Conciliacao.01S %>% bind_rows(Conciliacao.02S) %>% arrange(Índice)


      }



      # Exportando arquivos ----------------------------------------------------------------------------------------------

      # Guardando planilhas numa lista:
      Planilhas <- list(`Ficha Razão` = Conciliacao.final)


      return(Planilhas)

}

