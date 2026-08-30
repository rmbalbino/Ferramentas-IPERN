ServerExtratoBancario <- function(
    input,
    session,
    CompetenciaConfirmadaExtrato,
    DownloadLiberadoExtrato,
    ArquivoSelecionadoExtrato
) {

  observeEvent(input$ConfirmarCompetenciaExtrato, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaExtrato()
    )

    CompetenciaConfirmadaExtrato(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_extrato",
      list(
        confirmada = NovoEstado
      )
    )

    TemExtrato <- isTRUE(
      ArquivoSelecionadoExtrato()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_extrato",
        list(
          etapa = if (TemExtrato) 3 else 2
        )
      )

    } else {

      DownloadLiberadoExtrato(FALSE)
      ArquivoSelecionadoExtrato(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarExtrato",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_extrato",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_extrato",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemExtrato <- isTRUE(
      ArquivoSelecionadoExtrato()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaExtrato()
    )

    updateActionButton(
      session = session,
      inputId = "ExecutarExtrato",
      disabled = !(CompetenciaOK && TemExtrato)
    )

    session$sendCustomMessage(
      "estado_upload_extrato",
      list(
        carregado = TemExtrato
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_extrato",
        list(
          etapa = if (TemExtrato) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_extrato",
      list(
        liberado = isTRUE(
          DownloadLiberadoExtrato()
        )
      )
    )

  })


  observeEvent(
    input$BotaoExtrato,
    {

      DownloadLiberadoExtrato(FALSE)

      TemExtrato <- !is.null(input$BotaoExtrato) &&
        NROW(input$BotaoExtrato) > 0

      ArquivoSelecionadoExtrato(
        TemExtrato
      )

      session$sendCustomMessage(
        "estado_upload_extrato",
        list(
          carregado = TemExtrato
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaExtrato()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarExtrato",
        disabled = !(CompetenciaOK && TemExtrato)
      )

    },
    ignoreInit = TRUE
  )

}

ProcessarExtratoBancario <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoExtrato
) {

  observeEvent(input$ExecutarExtrato, {

    updateActionButton(
      session = session,
      inputId = "ExecutarExtrato",
      disabled = TRUE
    )

    DownloadLiberadoExtrato(FALSE)

    session$sendCustomMessage(
      "etapa_extrato",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoExtrato,
        Função = ExtrairExtratoGeral(
          input$BotaoExtrato$datapath
        )
      )

      DownloadLiberadoExtrato(TRUE)

      session$sendCustomMessage(
        "etapa_extrato",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoExtrato(FALSE)

      session$sendCustomMessage(
        "etapa_extrato",
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
        inputId = "ExecutarExtrato",
        disabled = FALSE
      )

    })

  })

}
