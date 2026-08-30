UploadFerramenta <- function(
    inputId,
    classe,
    titulo,
    titulo_carregado,
    multiple = FALSE,
    tamanho_icone = "2rem"
) {

  div(
    class = paste(
      "upload-dropzone upload-bloqueado",
      classe
    ),

    div(
      class = "upload-dropzone-conteudo",

      div(
        class = "upload-icone upload-icone-inicial",
        bsicons::bs_icon(
          "cloud-arrow-up",
          size = tamanho_icone
        )
      ),

      div(
        class = "upload-icone upload-icone-carregado",
        bsicons::bs_icon(
          "check-circle",
          size = tamanho_icone
        )
      ),

      div(
        class = "upload-dropzone-texto",

        strong(
          class = "upload-texto-inicial",
          titulo
        ),

        span(
          class = "upload-subtexto-inicial",
          "Clique para selecionar"
        ),

        strong(
          class = "upload-texto-carregado",
          titulo_carregado
        ),

        span(
          class = "upload-subtexto-carregado",
          "Clique para substituir"
        ),

        span(
          class = "upload-texto-carregando",
          "Carregando..."
        )
      )
    ),

    div(
      class = "upload-input-real",

      fileInput(
        inputId = inputId,
        label = NULL,
        multiple = multiple,
        width = "100%"
      )
    )
  )
}


StepperFerramenta <- function(

  prefixo,
  Etapa1 = "Competência",
  Etapa2 = "Arquivos",
  Etapa3 = "Processamento",
  Etapa4 = "Resultado") {

  div(
    id = paste0("Stepper", prefixo),
    class = "etapas-processamento",

    div(
      id = paste0("Etapa", prefixo, "1"),
      class = "etapa etapa-ativa",
      div(class = "etapa-numero", "1"),
      span(Etapa1)
    ),

    div(class = "etapa-linha"),

    div(
      id = paste0("Etapa", prefixo, "2"),
      class = "etapa",
      div(class = "etapa-numero", "2"),
      span("Arquivos")
    ),

    div(class = "etapa-linha"),

    div(
      id = paste0("Etapa", prefixo, "3"),
      class = "etapa",
      div(class = "etapa-numero", "3"),
      span("Processamento")
    ),

    div(class = "etapa-linha"),

    div(
      id = paste0("Etapa", prefixo, "4"),
      class = "etapa",
      div(class = "etapa-numero", "4"),
      span("Resultado")
    )
  )
}


CompetenciaFerramenta <- function(Prefixo) {

  div(
    class = "campo-ferramenta",

    div(
      class = "competencia-linha",

      div(
        class = "competencia-input competencia-data",

        dateInput(
          inputId = paste0("MesAno", Prefixo),
          label = NULL,
          value = Sys.Date(),
          format = "mm/yyyy",
          language = "pt-BR",
          width = "100%"
        )
      ),

      actionButton(
        inputId = paste0("ConfirmarCompetencia", Prefixo),
        label = bsicons::bs_icon("check-lg"),
        class = "btn-confirmar-competencia"
      )
    )
  )
}


CardFerramenta <- function(inputId, icone, titulo, descricao) {

  actionLink(
    inputId = inputId,

    label = card(
      class = "card-ferramenta",

      card_body(
        div(
          class = "text-center",

          bsicons::bs_icon(
            icone,
            size = "2rem"
          ),

          h5(titulo),

          p(
            descricao,
            class = "text-muted mb-0"
          )
        )
      )
    ),

    class = "link-card-ferramenta",

    onclick = "
      document
        .querySelectorAll('.card-ferramenta-selecionado')
        .forEach(function(x) {
          x.classList.remove('card-ferramenta-selecionado');
        });

      this
        .querySelector('.card-ferramenta')
        .classList.add('card-ferramenta-selecionado');
    "
  )
}
