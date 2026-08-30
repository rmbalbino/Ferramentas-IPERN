ServerAlmoxarifado <- function(
    input,
    session,
    CompetenciaConfirmadaAlmoxarifado,
    DownloadLiberadoAlmoxarifado,
    ArquivoSelecionadoAlmoxarifado,
    ArquivoDescricaoSelecionadoAlmoxarifado
) {

  observeEvent(input$ConfirmarCompetenciaAlmoxarifado, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaAlmoxarifado()
    )

    CompetenciaConfirmadaAlmoxarifado(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_almoxarifado",
      list(
        confirmada = NovoEstado
      )
    )

    TemAlmoxarifado <- isTRUE(
      ArquivoSelecionadoAlmoxarifado()
    )

    TemDescricao <- isTRUE(
      ArquivoDescricaoSelecionadoAlmoxarifado()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_almoxarifado",
        list(
          etapa = if (TemAlmoxarifado && TemDescricao) 3 else 2
        )
      )

    } else {

      DownloadLiberadoAlmoxarifado(FALSE)

      ArquivoSelecionadoAlmoxarifado(FALSE)
      ArquivoDescricaoSelecionadoAlmoxarifado(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarAlmoxarifado",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_almoxarifado",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "estado_upload_descricao",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_almoxarifado",
        list(
          etapa = 1
        )
      )

    }

  })


  observeEvent(input$MesAnoAlmoxarifado, {

    CompetenciaConfirmadaAlmoxarifado(FALSE)
    DownloadLiberadoAlmoxarifado(FALSE)

    updateActionButton(
      session = session,
      inputId = "ExecutarAlmoxarifado",
      disabled = TRUE
    )

    session$sendCustomMessage(
      "estado_competencia_almoxarifado",
      list(
        confirmada = FALSE
      )
    )

    session$sendCustomMessage(
      "etapa_almoxarifado",
      list(
        etapa = 1
      )
    )

  }, ignoreInit = TRUE)


  observe({

    TemAlmoxarifado <- isTRUE(
      ArquivoSelecionadoAlmoxarifado()
    )

    TemDescricao <- isTRUE(
      ArquivoDescricaoSelecionadoAlmoxarifado()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaAlmoxarifado()
    )

    ArquivosOK <- TemAlmoxarifado && TemDescricao

    updateActionButton(
      session = session,
      inputId = "ExecutarAlmoxarifado",
      disabled = !(CompetenciaOK && ArquivosOK)
    )

    session$sendCustomMessage(
      "estado_upload_almoxarifado",
      list(
        carregado = TemAlmoxarifado
      )
    )

    session$sendCustomMessage(
      "estado_upload_descricao",
      list(
        carregado = TemDescricao
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_almoxarifado",
        list(
          etapa = if (ArquivosOK) 3 else 2
        )
      )

    }

  })


  observe({

    session$sendCustomMessage(
      "estado_download_almoxarifado",
      list(
        liberado = isTRUE(
          DownloadLiberadoAlmoxarifado()
        )
      )
    )

  })


  observeEvent(
    input$BotaoAlmoxarifado,
    {

      DownloadLiberadoAlmoxarifado(FALSE)

      TemAlmoxarifado <- !is.null(input$BotaoAlmoxarifado) &&
        NROW(input$BotaoAlmoxarifado) > 0

      ArquivoSelecionadoAlmoxarifado(
        TemAlmoxarifado
      )

      session$sendCustomMessage(
        "estado_upload_almoxarifado",
        list(
          carregado = TemAlmoxarifado
        )
      )

      TemDescricao <- isTRUE(
        ArquivoDescricaoSelecionadoAlmoxarifado()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaAlmoxarifado()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarAlmoxarifado",
        disabled = !(CompetenciaOK && TemAlmoxarifado && TemDescricao)
      )

    },
    ignoreInit = TRUE
  )


  observeEvent(
    input$BotaoDescrição,
    {

      DownloadLiberadoAlmoxarifado(FALSE)

      TemDescricao <- !is.null(input$BotaoDescrição) &&
        NROW(input$BotaoDescrição) > 0

      ArquivoDescricaoSelecionadoAlmoxarifado(
        TemDescricao
      )

      session$sendCustomMessage(
        "estado_upload_descricao",
        list(
          carregado = TemDescricao
        )
      )

      TemAlmoxarifado <- isTRUE(
        ArquivoSelecionadoAlmoxarifado()
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaAlmoxarifado()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarAlmoxarifado",
        disabled = !(CompetenciaOK && TemAlmoxarifado && TemDescricao)
      )

    },
    ignoreInit = TRUE
  )

}



ProcessarAlmoxarifado <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoAlmoxarifado
) {

  observeEvent(input$ExecutarAlmoxarifado, {

    updateActionButton(
      session = session,
      inputId = "ExecutarAlmoxarifado",
      disabled = TRUE
    )

    DownloadLiberadoAlmoxarifado(FALSE)

    session$sendCustomMessage(
      "etapa_almoxarifado",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoAlmoxarifado,
        Função = Format_Almoxarifado(
          input$BotaoAlmoxarifado$datapath,
          input$BotaoDescrição$datapath
        )
      )

      DownloadLiberadoAlmoxarifado(TRUE)

      session$sendCustomMessage(
        "etapa_almoxarifado",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoAlmoxarifado(FALSE)

      session$sendCustomMessage(
        "etapa_almoxarifado",
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
        inputId = "ExecutarAlmoxarifado",
        disabled = FALSE
      )

    })

  })

}
