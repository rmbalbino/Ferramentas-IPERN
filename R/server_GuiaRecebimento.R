ServerGuiaRecebimento <- function(
    input,
    session,
    CompetenciaConfirmadaGR,
    DownloadLiberadoGR,
    ArquivoSelecionadoGR
) {

  observeEvent(input$ConfirmarCompetenciaGR, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaGR()
    )

    CompetenciaConfirmadaGR(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_gr",
      list(
        confirmada = NovoEstado
      )
    )

    TemGR <- isTRUE(
      ArquivoSelecionadoGR()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_gr",
        list(
          etapa = if (TemGR) 3 else 2
        )
      )

    } else {

      DownloadLiberadoGR(FALSE)
      ArquivoSelecionadoGR(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarGR",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_gr",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_gr",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemGR <- isTRUE(
      ArquivoSelecionadoGR()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaGR()
    )

    updateActionButton(
      session = session,
      inputId = "ExecutarGR",
      disabled = !(CompetenciaOK && TemGR)
    )

    session$sendCustomMessage(
      "estado_upload_gr",
      list(
        carregado = TemGR
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_gr",
        list(
          etapa = if (TemGR) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_gr",
      list(
        liberado = isTRUE(
          DownloadLiberadoGR()
        )
      )
    )

  })


  observeEvent(
    input$BotaoGR,
    {

      DownloadLiberadoGR(FALSE)

      TemGR <- !is.null(input$BotaoGR) &&
        NROW(input$BotaoGR) > 0

      ArquivoSelecionadoGR(
        TemGR
      )

      session$sendCustomMessage(
        "estado_upload_gr",
        list(
          carregado = TemGR
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaGR()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarGR",
        disabled = !(CompetenciaOK && TemGR)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarGuiaRecebimento <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoGR
) {

  observeEvent(input$ExecutarGR, {

    updateActionButton(
      session = session,
      inputId = "ExecutarGR",
      disabled = TRUE
    )

    DownloadLiberadoGR(FALSE)

    session$sendCustomMessage(
      "etapa_gr",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoGR,
        Função = Format_GR(
          input$BotaoGR$datapath
        )
      )

      DownloadLiberadoGR(TRUE)

      session$sendCustomMessage(
        "etapa_gr",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoGR(FALSE)

      session$sendCustomMessage(
        "etapa_gr",
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
        inputId = "ExecutarGR",
        disabled = FALSE
      )

    })

  })

}
