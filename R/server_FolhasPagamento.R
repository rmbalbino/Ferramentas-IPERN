ServerFolhasPagamento <- function(
    input,
    session,
    CompetenciaConfirmadaFDP,
    DownloadLiberadoFDP,
    ArquivoSelecionadoFDP
) {

   observeEvent(input$ConfirmarCompetenciaFDP, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaFDP()
    )

    CompetenciaConfirmadaFDP(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_fdp",
      list(
        confirmada = NovoEstado
      )
    )

    TemFDP <- isTRUE(
      ArquivoSelecionadoFDP()
    )


    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_fdp",
        list(
          etapa = if (TemFDP) 3 else 2
        )
      )

    } else {

      DownloadLiberadoFDP(FALSE)
      ArquivoSelecionadoFDP(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarFDP",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_fdp",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_fdp",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemFDP <- isTRUE(
      ArquivoSelecionadoFDP()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaFDP()
    )

    ArquivosOK <- TemFDP

    updateActionButton(
      session = session,
      inputId = "ExecutarFDP",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_fdp",
      list(
        carregado = TemFDP
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_fdp",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_fdp",
      list(
        liberado = isTRUE(
          DownloadLiberadoFDP()
        )
      )
    )

  })


  observeEvent(
    input$BotaoARQFDP,
    {

      DownloadLiberadoFDP(FALSE)

      TemFDP <- !is.null(input$BotaoARQFDP) &&
        NROW(input$BotaoARQFDP) > 0

      ArquivoSelecionadoFDP(
        TemFDP
      )

      session$sendCustomMessage(
        "estado_upload_fdp",
        list(
          carregado = TemFDP
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaFDP()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarFDP",
        disabled = !(CompetenciaOK && TemFDP)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarFolhasPagamento <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoFDP
) {

  observeEvent(input$ExecutarFDP, {

    updateActionButton(
      session = session,
      inputId = "ExecutarFDP",
      disabled = TRUE
    )

    DownloadLiberadoFDP(FALSE)

    session$sendCustomMessage(
      "etapa_fdp",
      list(
        etapa = 3
      )
    )

    tryCatch({

      if (input$BotaoFDPClasse == "Normal") {

        ObservFunction(
          MesAno = input$MesAnoFDP,
          Função = Ext_FPag(
            input$MesAnoFDP,
            input$BotaoARQFDP$name,
            input$BotaoARQFDP$datapath,
            input$BotaoFDPTipo
          )
        )

      } else if (input$BotaoFDPClasse == "REL04 Escaneado") {

        ObservFunction(
          MesAno = input$MesAnoFDP,
          Função = Ext_FPagS(
            input$MesAnoFDP,
            input$BotaoARQFDP$name,
            input$BotaoARQFDP$datapath,
            input$BotaoFDPTipo
          )
        )

      } else if (input$BotaoFDPClasse == "REL02 Escaneado") {

        ObservFunction(
          MesAno = input$MesAnoFDP,
          Função = Ext_FPagP(
            input$MesAnoFDP,
            input$BotaoARQFDP$name,
            input$BotaoARQFDP$datapath,
            input$BotaoFDPTipo
          )
        )

      }

      DownloadLiberadoFDP(TRUE)

      session$sendCustomMessage(
        "etapa_fdp",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoFDP(FALSE)

      session$sendCustomMessage(
        "etapa_fdp",
        list(
          etapa = 3
        )
      )

      shinybusy::report_failure(
        "Erro durante o processamento",
        conditionMessage(e)
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarFDP",
        disabled = FALSE
      )

    })

  })

}
