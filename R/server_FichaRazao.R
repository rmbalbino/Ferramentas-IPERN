ServerFichaRazao <- function(
    input,
    session,
    CompetenciaConfirmadaRazao,
    DownloadLiberadoRazao,
    ArquivoSelecionadoRazao
) {

  observeEvent(input$ConfirmarCompetenciaRazao, {

    NovoEstado <- !isTRUE(
      CompetenciaConfirmadaRazao()
    )

    DownloadLiberadoRazao(FALSE)

    CompetenciaConfirmadaRazao(
      NovoEstado
    )

    session$sendCustomMessage(
      "estado_competencia_razao",
      list(
        confirmada = NovoEstado
      )
    )

    TemRazao <- isTRUE(
      ArquivoSelecionadoRazao()
    )

    if (NovoEstado) {

      session$sendCustomMessage(
        "etapa_razao",
        list(
          etapa = if (TemRazao) 3 else 2
        )
      )

    } else {

      DownloadLiberadoRazao(FALSE)
      ArquivoSelecionadoRazao(FALSE)

      updateActionButton(
        session = session,
        inputId = "ExecutarRazao",
        disabled = TRUE
      )

      session$sendCustomMessage(
        "estado_upload_razao",
        list(
          carregado = FALSE
        )
      )

      session$sendCustomMessage(
        "etapa_razao",
        list(
          etapa = 1
        )
      )

    }

  })


  observe({

    TemRazao <- isTRUE(
      ArquivoSelecionadoRazao()
    )

    CompetenciaOK <- isTRUE(
      CompetenciaConfirmadaRazao()
    )

    updateActionButton(
      session = session,
      inputId = "ExecutarRazao",
      disabled = !(CompetenciaOK && TemRazao)
    )

    session$sendCustomMessage(
      "estado_upload_razao",
      list(
        carregado = TemRazao
      )
    )

    if (CompetenciaOK) {

      session$sendCustomMessage(
        "etapa_razao",
        list(
          etapa = if (TemRazao) 3 else 2
        )
      )
    }
  })


  observe({

    session$sendCustomMessage(
      "estado_download_razao",
      list(
        liberado = isTRUE(
          DownloadLiberadoRazao()
        )
      )
    )
  })


  observeEvent(
    input$BotaoRazao,
    {

      DownloadLiberadoRazao(FALSE)

      TemRazao <- !is.null(input$BotaoRazao) &&
        NROW(input$BotaoRazao) > 0

      ArquivoSelecionadoRazao(
        TemRazao
      )

      session$sendCustomMessage(
        "estado_upload_razao",
        list(
          carregado = TemRazao
        )
      )

      CompetenciaOK <- isTRUE(
        CompetenciaConfirmadaRazao()
      )

      updateActionButton(
        session = session,
        inputId = "ExecutarRazao",
        disabled = !(CompetenciaOK && TemRazao)
      )

      if (CompetenciaOK) {

        session$sendCustomMessage(
          "etapa_razao",
          list(
            etapa = if (TemRazao) 3 else 2
          )
        )

      }

    },
    ignoreInit = TRUE
  )

}



ProcessarFichaRazao <- function(
    input,
    session,
    ObservFunction,
    DownloadLiberadoRazao
) {

  observeEvent(input$ExecutarRazao, {

    updateActionButton(
      session = session,
      inputId = "ExecutarRazao",
      disabled = TRUE
    )

    DownloadLiberadoRazao(FALSE)

    session$sendCustomMessage(
      "etapa_razao",
      list(
        etapa = 3
      )
    )

    tryCatch({

      ObservFunction(
        MesAno = input$MesAnoRazao,
        Função = Extrair_Razao(
          input$BotaoRazao$datapath
        )
      )

      DownloadLiberadoRazao(TRUE)

      session$sendCustomMessage(
        "etapa_razao",
        list(
          etapa = 4
        )
      )

      shinybusy::report_success(
        "Organização finalizada!",
        "O arquivo foi processado com sucesso e está pronto para download."
      )

    }, error = function(e) {

      DownloadLiberadoRazao(FALSE)

      session$sendCustomMessage(
        "etapa_razao",
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
        inputId = "ExecutarRazao",
        disabled = FALSE
      )
    })
  })
}
