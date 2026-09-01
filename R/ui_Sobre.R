CardDesenvolvedor <- function(
    Nome,
    Formacao,
    Instituicao,
    Email = NULL,
    Linkedin = NULL,
    Github = NULL,
    Orcid = NULL,
    Lattes = NULL
) {

  div(
    class = "py-2",

    h5(
      Nome,
      class = "fw-bold text-primary mb-2"
    ),

    p(
      Formacao,
      class = "fw-bold mb-1 small"
    ),

    p(
      Instituicao,
      class = "text-muted mb-3 small"
    ),

    div(
      class = "d-flex justify-content-center gap-2",

      if (!is.null(Email)) {
        bslib::tooltip(
          tags$a(
            href = paste0("mailto:", Email),
            bsicons::bs_icon("envelope"),
            class = "text-primary"
          ),
          Email
        )
      },

      if (!is.null(Linkedin)) {
        bslib::tooltip(
          tags$a(
            href = Linkedin,
            target = "_blank",
            bsicons::bs_icon("linkedin"),
            class = "text-primary"
          ),
          Linkedin
        )
      },

      if (!is.null(Github)) {
        bslib::tooltip(
          tags$a(
            href = Github,
            target = "_blank",
            bsicons::bs_icon("github"),
            class = "text-primary"
          ),
          Github
        )
      },

      if (!is.null(Orcid)) {
        bslib::tooltip(
          tags$a(
            href = Orcid,
            target = "_blank",
            icon("orcid"),
            class = "text-primary"
          ),
          Orcid
        )
      },

      if (!is.null(Lattes)) {
        bslib::tooltip(
          tags$a(
            href = Lattes,
            target = "_blank",

            tags$img(
              src = "www/lattes.svg?v=3",
              height = "16px"
            )
          ),
          Lattes
        )
      }
    )
  )
}



fui_Sobre <- function() {

  nav_panel(
    title = "Sobre",

    div(
      class = "py-4",

      div(
        class = "mx-auto",
        style = "max-width: 1100px;",


        # SOBRE A FERRAMENTA ─────────────────────────────────────────────

        card(
          class = "border-0 shadow-none",

          card_body(

            # class = "d-flex align-items-center",
            # style = "min-height: 300px;",

            div(
              class = "d-flex align-items-start gap-3",

              span(
                class = "text-primary",

                bsicons::bs_icon(
                  "tools",
                  size = "1.8rem"
                )
              ),

              div(

                h4(
                  "Sobre a ferramenta",
                  class = "mb-3 fw-bold text-primary"
                ),

                p(
                  paste(
                    "As Ferramentas foram desenvolvidas para facilitar e",
                    "padronizar o tratamento de arquivos financeiros e contábeis",
                    "utilizados nas rotinas do Instituto de Previdência dos",
                    "Servidores do Estado do Rio Grande do Norte."
                  ), style = "text-align: justify;"
                ),

                p(
                  paste(
                    "A ferramenta automatiza etapas importantes como leitura,",
                    "validação, transformação e organização dos dados, reduzindo",
                    "retrabalho, minimizando erros manuais e aumentando a",
                    "confiabilidade das informações."
                  ), style = "text-align: justify;"
                ),

                p(
                  paste(
                    "O objetivo é tornar os processos mais ágeis, seguros e",
                    "eficientes, proporcionando mais tempo para atividades de",
                    "análise e gestão."
                  ), style = "text-align: justify;",
                  class = "mb-0"
                )
              )
            )
          ),  #br(),
        ),

        br(),  br(),

        # DESENVOLVEDORES ─────────────────────────────────────────────

        card(
          class = "border-0 shadow-none",

          card_body(

            div(
              class = "d-flex align-items-start gap-3",

              span(
                class = "text-primary",

                bsicons::bs_icon(
                  "people",
                  size = "1.8rem"
                )
              ),

              div(
                class = "flex-grow-1",

                h4(
                  "Desenvolvedores",
                  class = "mb-3 fw-bold text-primary"
                ),

                layout_columns(
                  col_widths = c(4, 4, 4),
                  gap = "24px",
                  fill = FALSE,
                  fillable = FALSE,

                  CardDesenvolvedor(
                    Nome = "Renan Balbino",
                    Formacao = "Ciências Atuariais",
                    Instituicao = "Universidade Federal do Rio Grande do Norte",
                    Email = "rmbalbino@hotmail.com",
                    Github = "https://github.com/rmbalbino",
                    Linkedin = "https://www.linkedin.com/in/rmbalbino",
                    Orcid = "https://orcid.org/0009-0003-7665-9928",
                    Lattes = "http://lattes.cnpq.br/9741799948855362"
                  ),

                  CardDesenvolvedor(
                    Nome = "Suélio Júnior",
                    Formacao = "Ciências Atuariais",
                    Instituicao = "Universidade Federal do Rio Grande do Norte",
                    Email = "sueliojunior4@gmail.com",
                    Github = "https://github.com/Suelio99",
                    Linkedin = "https://www.linkedin.com/in/su%C3%A9lio-j%C3%BAnior-734675178/",
                  ),

                  CardDesenvolvedor(
                    Nome = "Lucas Bezerra",
                    Formacao = "Graduando em Ciências Atuariais",
                    Instituicao = "Universidade Federal do Rio Grande do Norte",
                    Email = "lucas17bezerra@gmail.com",
                    Github = "https://github.com/lucasbezerra12",
                    Linkedin = "https://www.linkedin.com/in/lucas-gustavo-pegado-bezerra-881ab6276",
                  )
                )
              )
            )
          )
        ),

        br(), br(),

        # CONTATO INSTITUCIONAL ─────────────────────────────────────────────

        card(
          class = "shadow-none",

          card_body(

            div(
              class = "d-flex align-items-start gap-3",

              span(
                class = "text-primary",

                bsicons::bs_icon(
                  "bank",
                  size = "1.8rem"
                )
              ),

              div(
                class = "flex-grow-1",

                h4(
                  "Contato institucional",
                  class = "mb-4 fw-bold text-primary"
                ),

                layout_columns(
                  col_widths = c(3, 3, 3, 3),
                  gap = "16px",
                  fill = FALSE,
                  fillable = FALSE,

                  div(
                    class = "d-flex justify-content-center",

                    div(
                      class = "d-flex align-items-center gap-3",

                      span(
                        class = "text-primary",
                        bsicons::bs_icon(
                          "geo-alt-fill",
                          size = "1.4rem"
                        )
                      ),

                      div(
                        class = "small",
                        "Rua Jundiaí, 410 - Tirol",
                        br(),
                        "Natal/RN - CEP 59020-120"
                      )
                    )
                  ),

                  div(
                    class = "d-flex justify-content-center",

                    div(
                      class = "d-flex align-items-center gap-3",

                      span(
                        class = "text-primary",
                        bsicons::bs_icon(
                          "telephone-fill",
                          size = "1.4rem"
                        )
                      ),

                      span(
                        "(84) 3232-2900",
                        class = "small"
                      )
                    )
                  ),

                  div(
                    class = "d-flex justify-content-center",

                    div(
                      class = "d-flex align-items-center gap-3",

                      span(
                        class = "text-primary",
                        bsicons::bs_icon(
                          "envelope-fill",
                          size = "1.4rem"
                        )
                      ),

                      tags$a(
                        "previdenciarn@rn.gov.br",
                        href = "mailto:previdenciarn@rn.gov.br",
                        class = "small text-decoration-none text-reset"
                      )
                    )
                  ),

                  div(
                    class = "d-flex justify-content-center",

                    div(
                      class = "d-flex align-items-center gap-3",

                      span(
                        class = "text-primary",
                        bsicons::bs_icon(
                          "globe2",
                          size = "1.4rem"
                        )
                      ),

                      tags$a(
                        "www.ipe.rn.gov.br",
                        href = "https://www.ipe.rn.gov.br",
                        target = "_blank",
                        class = "small text-decoration-none text-reset"
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
}
