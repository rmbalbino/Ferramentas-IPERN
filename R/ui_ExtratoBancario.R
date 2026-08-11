fui_ExtratoBancario <- function(){
  
  nav_panel(title = "Extrato Bancário",    # Título da aba
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-1, 2, 4, 4, -1),
                           
                           dateInput(inputId = "MesAnoExtrato", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoExtratoCC", label = strong("Selecione o Extrato da Conta Corrente"), buttonLabel = "Procurar...", placeholder = ""),
                           
                           fileInput(inputId = "BotaoExtratoIN", label = strong("Selecione o Extrato do Investimento"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarExtrato", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoExtrato", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadExtrato",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
  )
  
}