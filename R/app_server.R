#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server <- function(input, output, session){

  # Dados reativos:
  MesAnoReativo <- reactiveValues(MesAno = NULL)
  DadosReativo  <- reactiveValues(Dados = NULL)



  # Observe Event ---------------------------------------------------------------------------------------------------------------------------------------------


  # Função para resumir código:
  Observ_function <- function(Função, MesAno){


    # Ativando tela de loading:
    show_modal_spinner(spin = "semipolar", color = "#de231a", text = "Aguarde...")


    # Rodando a função:
    Dados <- Função

    # Planilha reativa:
    DadosReativo$Dados <- Dados


    # Finalizando tela de loading:
    remove_modal_spinner()


    # Alterando formato:
    MesAno <- format(MesAno, "%m-%Y")

    # String reativa:
    MesAnoReativo$MesAno <- MesAno


  }


  file_inputs <- reactive({ list(BotaoAlmoxarifado = input$BotaoAlmoxarifado,
                                 BotaoDescrição = input$BotaoDescrição,
                                 BotaoCP = input$BotaoCP,
                                 BotaoExtratoCC = input$BotaoExtratoCC,
                                 BotaoExtratoIN = input$BotaoExtratoIN,
                                 BotaoRazao = input$BotaoRazao,
                                 BotaoGR = input$BotaoGR,
                                 BotaoClassificacao = input$BotaoClassificacao,
                                 BotaoOrgao = input$BotaoOrgao,
                                 BotaoInvestimento = input$BotaoInvestimento,
                                 BotaoArtigos = input$BotaoArtigos,
                                 BotaoOB = input$BotaoOB,
                                 BotaoOR = input$BotaoOR,
                                 BotaoDE = input$BotaoDE,
                                 BotaoRR = input$BotaoRR,
                                 BotaoRRCNPJ = input$BotaoRRCNPJ,
                                 # BotaoORGFDP = input$BotaoORGFDP,
                                 BotaoARQFDP = input$BotaoARQFDP) })



  # Observe the reactive expression
  observe({

    inputs <- file_inputs()

    purrr::map(names(inputs), function(x){

      if (!is.null(inputs[[x]])) {

        session$sendCustomMessage("upload_msg", list(inputId = x, text = "Carregamento completo")) } })

  })


  # Almoxarifado:
  observeEvent(input$ExecutarAlmoxarifado, { Observ_function(MesAno = input$MesAnoAlmoxarifado,
                                                             Função = Format_Almoxarifado(input$BotaoAlmoxarifado$datapath, input$BotaoDescrição$datapath)) })


  # Extrato Bancário:
  observeEvent(input$ExecutarExtrato, {

    if(!is.null(input$BotaoExtratoCC$datapath)){

      Observ_function(MesAno = input$MesAnoExtrato, Função = Extrair_Extrato(input$BotaoExtratoCC$datapath))


    } else{ Observ_function(MesAno = input$MesAnoExtrato, Função = Extrair_Extrato_IN(input$BotaoExtratoIN$datapath)) } })



  # Ficha Razão:
  observeEvent(input$ExecutarRazao, { Observ_function(MesAno = input$MesAnoRazao, Função = Extrair_Razao(input$BotaoRazao$datapath)) })


  # # Folhas de Pagamento:
  # observeEvent(input$ExecutarFDP, { Observ_function(MesAno = input$MesAnoFDP,
  #
  #                                                   Função = Ext_FPag(input$MesAnoFDP,
  #                                                                     input$BotaoARQFDP$name,
  #                                                                     input$BotaoARQFDP$datapath,
  #                                                                     input$BotaoFDPTipo)) })


  # Folhas de Pagamento:
  observeEvent(input$ExecutarFDP, {

    if(input$BotaoFDPClasse == "Normal"){

      Observ_function(MesAno = input$MesAnoFDP,

                      Função = Ext_FPag(input$MesAnoFDP,
                                        input$BotaoARQFDP$name,
                                        input$BotaoARQFDP$datapath,
                                        input$BotaoFDPTipo))

    } else if(input$BotaoFDPClasse == "REL04 Escaneado"){

      Observ_function(MesAno = input$MesAnoFDP,

                      Função = Ext_FPagS(input$MesAnoFDP,
                                         input$BotaoARQFDP$name,
                                         input$BotaoARQFDP$datapath,
                                         input$BotaoFDPTipo))

    } else if(input$BotaoFDPClasse == "REL02 Escaneado"){

      req(input$BotaoARQFDP)

      Observ_function(MesAno = input$MesAnoFDP,

                      Função = Ext_FPagP(input$MesAnoFDP,
                                         input$BotaoARQFDP$name,
                                         input$BotaoARQFDP$datapath,
                                         input$BotaoFDPTipo)) } })


  # Ordens Bancárias:
  observeEvent(input$ExecutarOB, {

    if(!is.null(input$BotaoOR$datapath) & !is.null(input$BotaoDE$datapath)){

      Observ_function(MesAno = input$MesAnoOB, Função = Format_OrdensBancarias(input$BotaoOB$datapath, input$BotaoOR$datapath, input$BotaoDE$datapath))

    } else{ Observ_function(MesAno = input$MesAnoOB, Função = Format_OrdensBancarias(input$BotaoOB$datapath)) } })


  # Controle Pagamento:
  observeEvent(input$ExecutarCP, { Observ_function(MesAno = input$MesAnoCP, Função = Format_Plan(input$BotaoCP$datapath, input$BotaoCP$name)) })


  # Guia Recebimento:
  observeEvent(input$ExecutarGR, {


    if(!is.null(input$BotaoClassificacao$datapath) & !is.null(input$BotaoOrgao$datapath)){

      Observ_function(MesAno = input$MesAnoGR, Função = Format_GR(input$BotaoGR$datapath, input$BotaoClassificacao$datapath, input$BotaoOrgao$datapath))

    } else{ Observ_function(MesAno = input$MesAnoGR, Função = Format_GR(input$BotaoGR$datapath)) } })


  # Investimentos:
  observeEvent(input$ExecutarInvestimento, { Observ_function(MesAno = input$MesAnoInvestimento,
                                                             Função = Extrair_Geral(input$BotaoInvestimento$name, input$MesAnoInvestimento,
                                                                                    input$BotaoInvestimento$datapath, input$BotaoArtigos$datapath)) })


  # Retenção Realizada:
  observeEvent(input$ExecutarRR, { Observ_function(MesAno = input$MesAnoRR, Função = Format_Retenção(input$BotaoRR$datapath, input$BotaoRRCNPJ$datapath)) })



  # Botões de Informação --------------------------------------------------------------------------------------------------------------------------------------

  # Extrato:
  observeEvent(input$InfoExtrato, { report_info("Atenção!", "O arquivo precisa estar no formato TXT. Além disso, só deve ser executado um tipo de Extrato por vez.") })


  # Ficha Razão:
  observeEvent(input$InfoRazao, { report_info("Atenção!", "O arquivo precisa estar no formato PDF.") })


  # Folhas de Pagamento:
  observeEvent(input$InfoFDP, { report_info("Atenção!", "As Folhas de Pagamento devem estar no formato PDF. Além disso, todas as folhas de Décimo Terceiro devem ter 13º em seu nome. Se necessário, execute o aplicativo 'Renomear PDFs 13º' para realizar os ajustes.") })


  # Guia Recebimento:
  observeEvent(input$InfoGR, { report_info("Atenção!", "O arquivo do SIGEF precisa estar no formato XLS. Não é obrigatório selecionar a planilha de Classificação ou Órgãos.") })


  # Controle Investimentos:
  observeEvent(input$InfoInvestimento, { report_info("Atenção!", "Escolha uma pasta e selecione extratos dentro dela. Depois, selecione a planilha com Artigos") })


  # Ordem Bancária:
  observeEvent(input$InfoOB, { report_info("Atenção!", "O arquivo precisa estar no formato XLS. Não é obrigatório selecionar as planilhas de PPs.") })


  # Retenção Realizada:
  observeEvent(input$InfoRR, { report_info("Atenção!", "O arquivo do SIGEF precisa estar no formato XLS. Também não esqueça de selecionar a planilha com CNPJs.") })


  # Controle Pagamentos:
  observeEvent(input$InfoCP, { report_info("Atenção!", "Escolha uma pasta e selecione as planilhas dentro dela.") })


  # Almoxarifado:
  observeEvent(input$InfoAlmoxarifado, { report_info("Atenção!", "O arquivo do Almoxarifado precisa estar no formato PDF. Também não esqueça de selecionar a planilha com a Descrição.") })



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
