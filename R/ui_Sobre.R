fui_Sobre <- function(){
  
  nav_panel(title = "Sobre", # Título da aba
            
            
            br(),
            
            # titlePanel(h5("Desenvolvedores", style = "background-color: firebrick; opacity: 0.2; padding-left: 15px;")),
            
            strong("Desenvolvedores", style = "font-size:18.5px;"),
            
            p(strong("Renan Balbino:"), "Estudante de Ciências Atuariais na UFRN com previsão de conclusão em 2025, e estagiário no Instituto de Previdência dos Servidores do RN desde fevereiro de 2023. Meu foco está nas áreas de Seguro, Previdência e Análise de Dados, com especial ênfase em Programação, usando principalmente a linguagem R."),
            
            p(strong("Suélio Júnior:"), "Estudante de bacharel em Ciências Atuariais na UFRN com previsão de conclusão para 2025, e estagiário no Instituto de Previdência dos Servidores do RN desde Junho de 2023. Meu foco está nas áreas de Seguro, Previdência, mercado financeiro e Análise de Dados, com  utilização de programação, usando principalmente a linguagem R."),
            
            
            
            br(),
            
            
            
            strong("Créditos", style = "font-size:18.5px;"),
            
            p(strong("Renan Balbino:"), "Interface do programa, Almoxarifado, Guia Recebimento, Extrato Bancário, Ficha Razão, Ordem Bancária, Retenção Realizada."),
            
            p(strong("Suélio Júnior:"), "Controle Pagamentos."),
            
            
            br(),
            
            
            strong("Contatos", style = "font-size:18.5px;"),
            
            layout_columns(col_widths = c(2, 2, 2, 2),
                           
                           strong("Renan Balbino:"),
                           
                           actionButton(inputId = "E-mail", label = "E-mail", icon = icon("envelope"),
                                        onclick ="window.open('mailto:renan.dmbalbino@gmail.com', '_blank')",
                                        style = "padding:4px; font-size:80%; width:100px; position:relative; right:calc(20%);") %>%
                             tooltip("renan.dmbalbino@gmail.com"),
                           
                           actionButton(inputId = "Linkedin", label = "Linkedin", icon = icon("linkedin"),
                                        onclick ="window.open('https://br.linkedin.com/in/renan-de-melo-balbino', '_blank')",
                                        style = "padding:4px; font-size:80%; width:100px; position:relative; right:calc(50%);") %>%
                             tooltip("https://br.linkedin.com/in/renan-de-melo-balbino"),
                           
                           actionButton(inputId = "Github", label = "Github", icon = icon("github"),
                                        style = "padding:4px; font-size:80%; width:100px; position:relative; right:calc(80%);",
                                        onclick ="window.open('https://github.com/Renan-Balbino', '_blank')") %>%
                             tooltip("https://github.com/Renan-Balbino")),
            
            
            
            layout_columns(col_widths = c(2, 2, 2),
                           
                           strong("Suélio Júnior:"),
                           
                           actionButton(inputId = "E-mail", label = "E-mail", icon = icon("envelope"),
                                        onclick ="window.open('mailto:sueliojunior4@gmail.com', '_blank')",
                                        style = "padding:4px; font-size:80%; width:100px; position:relative; right:calc(20%);") %>%
                             tooltip("sueliojunior4@gmail.com"),
                           
                           actionButton(inputId = "Linkedin", label = "Linkedin", icon = icon("linkedin"),
                                        onclick ="window.open('https://www.linkedin.com/in/su%C3%A9lio-j%C3%BAnior-734675178/', '_blank')",
                                        style = "padding:4px; font-size:80%; width:100px; position:relative; right:calc(50%);") %>%
                             tooltip("https://www.linkedin.com/in/su%C3%A9lio-j%C3%BAnior-734675178/")),
            
            
            
  ) # nav_panel
  
}