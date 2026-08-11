fui_FolhasPagamento <- function(){
  
  nav_panel(title = "Folhas de Pagamento", # Título da aba
            
            
            # br(),
            
            # Inputs:
            layout_columns(col_widths = c(-1, 4, 6, -1),
                           
                           # dateInput(inputId = "MesAnoFDP", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           radioButtons(inputId = "BotaoFDPTipo", label = strong("São Folhas de Décimo Terceiro?"),
                                        choices = c("Não", "Sim"), inline = T),
                           
                           radioButtons(inputId = "BotaoFDPClasse", label = strong("Tipo de PDF"),
                                        choices = c("Normal", "REL04 Escaneado", "REL02 Escaneado"), inline = T)
                           
            ),
            
            br(),
            
            
            layout_columns(col_widths = c(-2, 2, -1, 5, -2),
                           
                           dateInput(inputId = "MesAnoFDP", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoARQFDP", label = strong("Selecione as Folhas de Pagamento"),
                                     buttonLabel = "Procurar...", placeholder = "", multiple = T, accept = ".pdf"),
                           
                           # radioButtons(inputId = "BotaoFDPTipo", label = strong("São Folhas de Décimo Terceiro?"), choices = c("Não", "Sim"))
            ),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarFDP", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoFDP", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadFDP",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
            
  )
  
}
