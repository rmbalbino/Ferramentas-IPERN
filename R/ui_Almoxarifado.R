PainelAlmoxarifado <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────
    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Almoxarifado",
            class = "ferramenta-titulo"
          ),

          p(
            "Organize e consolide os arquivos de almoxarifado.",
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
              "3. Selecione o arquivo do Almoxarifado e a planilha de Descrição."
            ),

            placement = "left"
          )
        )
      )
    ),

    # ETAPAS ─────────────────────────────────────────

    StepperFerramenta("Almoxarifado"),

    # COMPETÊNCIA ─────────────────────────────────────────

    CompetenciaFerramenta ("Almoxarifado"),

    # ARQUIVOS ─────────────────────────────────────────

    div(
      class = "uploads-duplos",

      UploadFerramenta(
        inputId = "BotaoAlmoxarifado",
        classe = "upload-almoxarifado",
        titulo = "Arquivo do Almoxarifado",
        titulo_carregado = "Almoxarifado carregado"
      ),

      UploadFerramenta(
        inputId = "BotaoDescrição",
        classe = "upload-descricao",
        titulo = "Planilha de Descrição",
        titulo_carregado = "Descrição carregada"
      )
    ),

    # PROCESSAR ─────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarAlmoxarifado",
        label = tagList(
          bsicons::bs_icon("gear"),
          " Processar arquivos"
        ),
        class = "btn-processar",
        disabled = TRUE
      )
    ),

    # DOWNLOAD ─────────────────────────────────────────

    div(
      class = "acao-centralizada",

      tags$div(
        id = "DownloadAlmoxarifado_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadAlmoxarifado",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
