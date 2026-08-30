PainelControlePagamentos <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Controle de Pagamentos",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e processe os arquivos utilizados no controle de pagamentos.",
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
              "3. Selecione os arquivos utilizados no Controle de Pagamentos."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta("CP"),

    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta("CP"),

    # UPLOAD ─────────────────────────────────────────────

    UploadFerramenta(
      inputId = "BotaoCP",
      classe = "upload-cp",
      titulo = "Arquivos do Controle de Pagamentos",
      titulo_carregado = "Arquivos carregados",
      multiple = TRUE
    ),

    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarCP",
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
        id = "DownloadCP_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadCP",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
