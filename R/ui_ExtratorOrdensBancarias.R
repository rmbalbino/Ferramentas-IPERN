PainelExtratorOBs <- function() {

  div(
    class = "ferramenta-conteudo",

    # CABEÇALHO ─────────────────────────────────────────────

    div(
      class = "ferramenta-cabecalho",

      div(
        class = "ferramenta-titulo-linha",

        div(
          h3(
            "Extrator de Ordens Bancárias",
            class = "ferramenta-titulo"
          ),

          p(
            "Extraia Ordens Bancárias de forma automática.",
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
              "1. Informe seu usuário e senha.",
              br(), br(),
              "2. Configure os parâmetros da extração.",
              br(), br(),
              "3. Inicie a extração das Ordens Bancárias.",
              br(), br(),
              "4. Baixe o resultado após a conclusão."
            ),

            placement = "left"
          )
        )
      )
    ),

    # STEPPER ─────────────────────────────────────────────

    StepperFerramenta(
      prefixo = "ExtratorOBs",
      Etapa1 = "Dados pessoais",
      Etapa2 = "Configuração",
      Etapa3 = "Processamento",
      Etapa4 = "Resultado"
    ),

    # DADOS PESSOAIS ──────────────────────────────────────

    layout_columns(
      col_widths = c(-1, 2, 2, -2, 2, 2, -1),
      gap = "12px",

      textInput(
        inputId = "UsuarioExtratorOBs",
        label = strong("Usuário"),
        width = "100%"
      ),

      passwordInput(
        inputId = "SenhaExtratorOBs",
        label = strong("Senha"),
        width = "100%"
      ),

      dateInput(
        inputId = "DataInicioExtratorOBs",
        label = strong("Data inicial"),
        value = Sys.Date(),
        format = "dd/mm/yyyy",
        language = "pt-BR",
        width = "100%"
      ),

      dateInput(
        inputId = "DataTerminoExtratorOBs",
        label = strong("Data final"),
        value = Sys.Date(),
        format = "dd/mm/yyyy",
        language = "pt-BR",
        width = "100%"
      )
    ),

    br(), #br(),

    layout_columns(
      col_widths = c(-1, 2, 2, -1, 2, 3, -1),
      gap = "12px",

      textInput(
        inputId = "UGExtratorOBs",
        label = strong("Unidade Gestora"),
        width = "100%"
      ),

      textInput(
        inputId = "GestaoExtratorOBs",
        label = strong("Gestão"),
        width = "100%"
      ),

      numericInput(
        inputId = "ExercicioExtratorOBs",
        label = strong("Exercício"),
        value = lubridate::year(Sys.Date()),
        min = 2018,
        max = lubridate::year(Sys.Date()),
        width = "100%"
      ),

      textInput(
        inputId = "CNPJExtratorOBs",
        label = strong("Favorecido"),
        value = "08.242.034/0001-02",
        width = "100%"
      )
    ),

    # PROCESSAR ───────────────────────────────────────────

    div(
      class = "acao-centralizada",

      actionButton(
        inputId = "ExecutarExtratorOBs",
        label = tagList(
          bsicons::bs_icon("gear"),
          " Processar"
        ),
        class = "btn-processar"
      )
    ),

    # DOWNLOAD ────────────────────────────────────────────

    div(
      class = "acao-centralizada",

      tags$div(
        id = "DownloadExtratorOBs_wrapper",
        class = "download-desabilitado",

        downloadButton(
          outputId = "DownloadExtratorOBs",
          label = "Baixar arquivo",
          class = "btn-download"
        )
      )
    )
  )
}
