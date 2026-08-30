PainelRetencaoRealizada <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Retenção Realizada",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e consolide os arquivos de retenções realizadas.",
            class = "ferramenta-descricao"
          )
        ),

        div(
          class = "ferramenta-acoes",

          bslib::tooltip(
            bsicons::bs_icon("person-circle"),
            "Desenvolvedor: Renan Balbino",
            placement = "left"
          ),

          bslib::tooltip(
            bsicons::bs_icon("info-circle"),

            tagList(
              "1. Selecione a competência.",
              br(), br(),
              "2. Confirme a competência utilizando o botão ao lado dela.",
              br(), br(),
              "3. Selecione a Retenção Realizada e a planilha de CNPJs."
            ),

            placement = "left"
          )
        )
      )
    ),


    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta("RR"),


    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta ("RR"),


    # DOIS UPLOADS ─────────────────────────────────────────────

    div(
      class = "uploads-duplos",

      UploadFerramenta(
        inputId = "BotaoRR",
        classe = "upload-rr",
        titulo = "Retenção Realizada",
        titulo_carregado = "Retenção carregada"
      ),

      UploadFerramenta(
        inputId = "BotaoRRCNPJ",
        classe = "upload-rr-cnpj",
        titulo = "Planilha de CNPJs",
        titulo_carregado = "CNPJs carregados"
      )
    ),


    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarRR",
        label = tagList(
          bsicons::bs_icon("gear"),
          " Processar arquivos"
        ),
        class = "btn-processar",
        disabled = TRUE
      )
    ),


    # DOWNLOAD ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      tags$div(
        id = "DownloadRR_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadRR",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
