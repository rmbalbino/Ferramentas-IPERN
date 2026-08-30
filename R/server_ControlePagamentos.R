ServerControlePagamentos <- function(
    input,
    session,
    CompetenciaConfirmadaCP,
    DownloadLiberadoCP,
    ArquivoSelecionadoCP
) {

  observeEvent(input$ConfirmarCompetenciaCP, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaCP()
    )

    CompetenciaConfirmadaCP(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_cp",
      list(
        confirmada = NovoEstado
      )
    )

    TemCP <- isTRUE(
      ArquivoSelecionadoCP()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_cp",
        list(
          etapa = if (TemCP) 3 else 2
        )
      )

    } else {

      DownloadLiberadoCP(FALSE)
      ArquivoSelecionadoCP(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarCP",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_cp",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_cp",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemCP <- isTRUE(
      ArquivoSelecionadoCP()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaCP()
    )

    updateActionButton(
      session = session,
      inputId = "ExecutarCP",
      disabled = !(CompetenciaOK && TemCP)
    )

    session$sendCustomMessage(
      "estado_upload_cp",
      list(
        carregado = TemCP
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_cp",
        list(
          etapa = if (TemCP) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_cp",
      list(
        liberado = isTRUE(
          DownloadLiberadoCP()
        )
      )
    )

  })


  observeEvent(
    input$BotaoCP,
    {

      DownloadLiberadoCP(FALSE)

      TemCP <- !is.null(input$BotaoCP) &&
        NROW(input$BotaoCP) > 0

      ArquivoSelecionadoCP(
        TemCP
      )

      session$sendCustomMessage(
        "estado_upload_cp",
        list(
          carregado = TemCP
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaCP()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarCP",
        disabled = !(CompetenciaOK && TemCP)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarControlePagamentos <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoCP
) {

  observeEvent(input$ExecutarCP, {

    updateActionButton(
      session = session,
      inputId = "ExecutarCP",
      disabled = TRUE
    )

    DownloadLiberadoCP(FALSE)

    session$sendCustomMessage(
      "etapa_cp",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoCP,
        Função = Format_Plan(
          input$BotaoCP$datapath,
          input$BotaoCP$name
        )
      )

      DownloadLiberadoCP(TRUE)

      session$sendCustomMessage(
        "etapa_cp",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoCP(FALSE)

      session$sendCustomMessage(
        "etapa_cp",
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
        inputId = "ExecutarCP",
        disabled = FALSE
      )

    })

  })

}
