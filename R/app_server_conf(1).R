#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server <- function(input, output, session){

  # Dados reativos ----------------------------------------------------------------------
  MesAnoReativo <- reactiveValues(MesAno = NULL)
  DadosReativo  <- reactiveValues(Dados = NULL)

  FerramentaSelecionada <- reactiveVal(NULL)

  CompetenciaConfirmadaAlmoxarifado <- reactiveVal(FALSE)
  DownloadLiberadoAlmoxarifado <- reactiveVal(FALSE)
  ArquivoSelecionadoAlmoxarifado <- reactiveVal(FALSE)
  ArquivoDescricaoSelecionadoAlmoxarifado <- reactiveVal(FALSE)

  CompetenciaConfirmadaInvestimento <- reactiveVal(FALSE)
  DownloadLiberadoInvestimento <- reactiveVal(FALSE)
  ArquivoSelecionadoInvestimento <- reactiveVal(FALSE)
  ArquivoArtigosSelecionadoInvestimento <- reactiveVal(FALSE)

  CompetenciaConfirmadaCP <- reactiveVal(FALSE)
  DownloadLiberadoCP <- reactiveVal(FALSE)
  ArquivoSelecionadoCP <- reactiveVal(FALSE)

  CompetenciaConfirmadaExtrato <- reactiveVal(FALSE)
  DownloadLiberadoExtrato <- reactiveVal(FALSE)
  ArquivoSelecionadoExtrato <- reactiveVal(FALSE)

  CompetenciaConfirmadaRazao <- reactiveVal(FALSE)
  DownloadLiberadoRazao <- reactiveVal(FALSE)
  ArquivoSelecionadoRazao <- reactiveVal(FALSE)

  CompetenciaConfirmadaFDP <- reactiveVal(FALSE)
  DownloadLiberadoFDP <- reactiveVal(FALSE)
  ArquivoSelecionadoFDP <- reactiveVal(FALSE)

  CompetenciaConfirmadaGR <- reactiveVal(FALSE)
  DownloadLiberadoGR <- reactiveVal(FALSE)
  ArquivoSelecionadoGR <- reactiveVal(FALSE)

  CompetenciaConfirmadaOB <- reactiveVal(FALSE)
  DownloadLiberadoOB <- reactiveVal(FALSE)
  ArquivoSelecionadoOB <- reactiveVal(FALSE)

  CompetenciaConfirmadaRR <- reactiveVal(FALSE)
  DownloadLiberadoRR <- reactiveVal(FALSE)
  ArquivoSelecionadoRR <- reactiveVal(FALSE)
  ArquivoCNPJSelecionadoRR <- reactiveVal(FALSE)



# Servidores das Ferramentas ---------------------------------------------------

  ServerAlmoxarifado(input, session, CompetenciaConfirmadaAlmoxarifado,
                     DownloadLiberadoAlmoxarifado, ArquivoSelecionadoAlmoxarifado, ArquivoDescricaoSelecionadoAlmoxarifado)


  ServerControleInvestimentos(input, session, CompetenciaConfirmadaInvestimento,
                              DownloadLiberadoInvestimento, ArquivoSelecionadoInvestimento, ArquivoArtigosSelecionadoInvestimento)


  ServerControlePagamentos(input, session, CompetenciaConfirmadaCP, DownloadLiberadoCP, ArquivoSelecionadoCP)


  ServerExtratoBancario(input, session, CompetenciaConfirmadaExtrato, DownloadLiberadoExtrato, ArquivoSelecionadoExtrato)


  ServerFichaRazao(input, session, CompetenciaConfirmadaRazao, DownloadLiberadoRazao, ArquivoSelecionadoRazao)


  ServerFolhasPagamento(input, session, CompetenciaConfirmadaFDP, DownloadLiberadoFDP, ArquivoSelecionadoFDP)


  ServerGuiaRecebimento(input, session, CompetenciaConfirmadaGR, DownloadLiberadoGR, ArquivoSelecionadoGR)


  ServerOrdensBancarias(input, session, CompetenciaConfirmadaOB, DownloadLiberadoOB, ArquivoSelecionadoOB)


  ServerRetencaoRealizada(input,session, CompetenciaConfirmadaRR,
                          DownloadLiberadoRR, ArquivoSelecionadoRR, ArquivoCNPJSelecionadoRR)



  # Ferramenta Selecionada -----------------------------------------------------

  observeEvent(input$SelecionarAlmoxarifado, {
    FerramentaSelecionada("almoxarifado")
  })

  observeEvent(input$SelecionarExtrato, {
    FerramentaSelecionada("extrato")
  })

  observeEvent(input$SelecionarFichaRazao, {
    FerramentaSelecionada("ficha_razao")
  })

  observeEvent(input$SelecionarFolhas, {
    FerramentaSelecionada("folhas_pagamento")
  })

  observeEvent(input$SelecionarGuia, {
    FerramentaSelecionada("guia_recebimento")
  })

  observeEvent(input$SelecionarOB, {
    FerramentaSelecionada("ordens_bancarias")
  })

  observeEvent(input$SelecionarRetencao, {
    FerramentaSelecionada("retencao_realizada")
  })

  observeEvent(input$SelecionarControlePagamentos, {
    FerramentaSelecionada("controle_pagamentos")
  })

  observeEvent(input$SelecionarControleInvestimentos, {
    FerramentaSelecionada("controle_investimentos")
  })



  observeEvent(
    FerramentaSelecionada(),
    {

      # Almoxarifado:
      CompetenciaConfirmadaAlmoxarifado(FALSE)
      DownloadLiberadoAlmoxarifado(FALSE)
      ArquivoSelecionadoAlmoxarifado(FALSE)
      ArquivoDescricaoSelecionadoAlmoxarifado(FALSE)

      # Controle Investimentos:
      CompetenciaConfirmadaInvestimento(FALSE)
      DownloadLiberadoInvestimento(FALSE)
      ArquivoSelecionadoInvestimento(FALSE)
      ArquivoArtigosSelecionadoInvestimento(FALSE)

      # Controle Pagamentos:
      CompetenciaConfirmadaCP(FALSE)
      DownloadLiberadoCP(FALSE)
      ArquivoSelecionadoCP(FALSE)

      CompetenciaConfirmadaExtrato(FALSE)
      DownloadLiberadoExtrato(FALSE)
      ArquivoSelecionadoExtrato(FALSE)

      CompetenciaConfirmadaRazao(FALSE)
      DownloadLiberadoRazao(FALSE)
      ArquivoSelecionadoRazao(FALSE)

      # Folhas de Pagamento:
      CompetenciaConfirmadaFDP(FALSE)
      DownloadLiberadoFDP(FALSE)
      ArquivoSelecionadoFDP(FALSE)

      CompetenciaConfirmadaGR(FALSE)
      DownloadLiberadoGR(FALSE)
      ArquivoSelecionadoGR(FALSE)

      # Ordens Bancárias:
      CompetenciaConfirmadaOB(FALSE)
      DownloadLiberadoOB(FALSE)
      ArquivoSelecionadoOB(FALSE)

      # Retenção Realizada:
      CompetenciaConfirmadaRR(FALSE)
      DownloadLiberadoRR(FALSE)
      ArquivoSelecionadoRR(FALSE)
      ArquivoCNPJSelecionadoRR(FALSE)

      # Resultado compartilhado:
      MesAnoReativo$MesAno <- NULL
      DadosReativo$Dados <- NULL

    },
    ignoreInit = TRUE
  )



  # Painel de Ferramenta -------------------------------------------------------

  output$PainelFerramenta <- renderUI({

    Ferramenta <- FerramentaSelecionada()

    if (is.null(Ferramenta)) {

      return(
        div(
          class = "painel-sem-ferramenta",

          bsicons::bs_icon(
            "window",
            size = "3rem"
          ),

          h4("Selecione uma ferramenta"),

          p(
            "A aplicação selecionada será exibida neste espaço.",
            class = "text-muted"
          )
        )
      )
    }

    if (identical(Ferramenta, "almoxarifado")) {
      return(
        PainelAlmoxarifado()
      )
    }


    if (identical(Ferramenta, "controle_investimentos")) {
      return(
        PainelControleInvestimentos()
      )
    }


    if (identical(Ferramenta, "controle_pagamentos")) {
      return(
        PainelControlePagamentos()
      )
    }


    if (identical(Ferramenta, "extrato")) {
      return(
        PainelExtratoBancario()
      )
    }


    if (identical(Ferramenta, "ficha_razao")) {
      return(
        PainelFichaRazao()
      )
    }


    if (identical(Ferramenta, "folhas_pagamento")) {
      return(PainelFolhasPagamento())
    }


    if (identical(Ferramenta, "guia_recebimento")) {
      return(
        PainelGuiaRecebimento()
      )
    }


    if (identical(Ferramenta, "ordens_bancarias")) {
      return(
        PainelOrdensBancarias()
      )
    }


    if (identical(Ferramenta, "retencao_realizada")) {
      return(
        PainelRetencaoRealizada()
      )
    }



    # Temporário para as demais ferramentas
    div(
      class = "painel-sem-ferramenta",

      h4("Ferramenta selecionada"),

      p(
        "Esta interface será adicionada na próxima Etapa.",
        class = "text-muted"
      )
    )
  })



  # Processamento --------------------------------------------------------------


  # Função para resumir código:
  Observ_function <- function(Função, MesAno){


    # Ativando tela de loading:
    show_modal_spinner(spin = "semipolar", color = "#de231a", text = "Processando...")

    on.exit(remove_modal_spinner(), add = TRUE)

    # Rodando a função:
    Dados <- Função

    # Planilha reativa:
    DadosReativo$Dados <- Dados


    # Finalizando tela de loading:
    # remove_modal_spinner()


    # Alterando formato:
    MesAno <- format(MesAno, "%m-%Y")

    # String reativa:
    MesAnoReativo$MesAno <- MesAno


    invisible(Dados)

  }



  ProcessarAlmoxarifado(input, session, Observ_function, DownloadLiberadoAlmoxarifado)


  ProcessarExtratoBancario(input, session, Observ_function, DownloadLiberadoExtrato)


  ProcessarFichaRazao(input, session, Observ_function, DownloadLiberadoRazao)


  ProcessarFolhasPagamento(input, session, Observ_function, DownloadLiberadoFDP)


  ProcessarOrdensBancarias(input, session, Observ_function, DownloadLiberadoOB)


  ProcessarControlePagamentos(input, session, Observ_function, DownloadLiberadoCP)


  ProcessarGuiaRecebimento(input, session, Observ_function, DownloadLiberadoGR)


  ProcessarControleInvestimentos(input, session, Observ_function, DownloadLiberadoInvestimento)


  ProcessarRetencaoRealizada(input, session, Observ_function, DownloadLiberadoRR)



  # Download --------------------------------------------------------------------------------------------------------------------------------------------------

  # Botao para baixar Ficha Razão:
  output$DownloadRazao <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Ficha Razão", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Extrato Bancário:
  output$DownloadExtrato <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){
      if(!is.null(input$BotaoExtratoCC$datapath)){ paste0("Extrato Conta Corrente", " - ", MesAnoReativo$MesAno, ".xlsx") }
      else{ paste0("Extrato Investimento", " - ", MesAnoReativo$MesAno, ".xlsx") } },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Guia Recebimento:
  output$DownloadGR <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Guia Recebimento", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Controle Investimentos:
  output$DownloadInvestimento <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Controle Investimentos", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Ordem Bancária:
  output$DownloadOB <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Ordem Bancária", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Retenção Realizada:
  output$DownloadRR <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Retenção Realizada", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Controle Pagamentos:
  output$DownloadCP <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Controle Pagamentos", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # Botao para baixar Almoxarifado:
  output$DownloadAlmoxarifado <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Almoxarifado", " - ", MesAnoReativo$MesAno, ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })



  # # Botao para baixar Folhas de Pagamento:
  # output$DownloadFDP <- downloadHandler(
  #
  #   # Nome do arquivo que sera baixado:
  #   filename = function(){ paste0("Folhas de Pagamento", " - ", if_else(input$BotaoFDPTipo == "Sim", paste0("13-", str_sub(MesAnoReativo$MesAno, -4)), MesAnoReativo$MesAno), ".zip") },
  #
  #   # Exportando arquivo export(arquivo, nome do arquivo):
  #   content = function(file){
  #
  #
  #     path1 <- normalizePath(file.path(tempdir(), paste0("Planilhas Analiticas", " - ", if_else(input$BotaoFDPTipo == "Sim", paste0("13-", str_sub(MesAnoReativo$MesAno, -4)), MesAnoReativo$MesAno), ".xlsx")))
  #     export(DadosReativo$Dados$P1, path1)
  #
  #     path2 <- normalizePath(file.path(tempdir(), paste0("Planilhas INSS", " - ", if_else(input$BotaoFDPTipo == "Sim", paste0("13-", str_sub(MesAnoReativo$MesAno, -4)), MesAnoReativo$MesAno), ".xlsx")))
  #     export(DadosReativo$Dados$P2, path2)
  #
  #     zip(zipfile = file, files = c(path1, path2), extras = '-j')
  #
  #
  #     })



  # Botao para baixar Folhas de Pagamento:
  output$DownloadFDP <- downloadHandler(

    # Nome do arquivo que sera baixado:
    filename = function(){ paste0("Planilhas Analiticas", " - ", if_else(input$BotaoFDPTipo == "Sim", paste0("13-", str_sub(MesAnoReativo$MesAno, -4)), MesAnoReativo$MesAno), ".xlsx") },

    # Exportando arquivo export(arquivo, nome do arquivo):
    content = function(file){ export(DadosReativo$Dados, file) })


}

# runGadget(ui, server, viewer = dialogViewer("", width = 1000, height = 600))

# shinyApp(ui = ui, server = server)
