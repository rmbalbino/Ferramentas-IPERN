PainelOrdensBancarias <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        div(
          class = "ferramenta-titulo-linha",

          h3(
            "Ordens Bancárias",
            class = "ferramenta-titulo"
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
                "3. O arquivo precisa estar no formato XLS."
              ),

              placement = "left"
            )
          )
        ),

        p(
          "Organize e consolide arquivos de ordens bancárias.",
          class = "ferramenta-descricao"
        )
      )
    ),


    # ETAPAS ─────────────────────────────────────────────

    StepperFerramenta("OB"),


    # COMPETÊNCIA ─────────────────────────────────────────────

    CompetenciaFerramenta ("OB"),


    # ARQUIVOS ─────────────────────────────────────────────

    div(
      class = "campo-ferramenta",

      UploadFerramenta(
        inputId = "BotaoOB",
        classe = "upload-ob",
        titulo = "Selecione as Ordens Bancárias",
        titulo_carregado = "Arquivos carregados",
        multiple = TRUE,
        tamanho_icone = "2.4rem"
      )
    ),


    # PROCESSAR ─────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarOB",
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
        id = "DownloadOB_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadOB",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
