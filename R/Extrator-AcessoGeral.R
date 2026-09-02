acessar_sistema <- function(
    usuario,
    senha,
    exercicio,
    url_sistema = Sys.getenv("URL_BASE")
) {
  
  # 1. ENCERRAR NAVEGADOR ANTERIOR ====================
  
  browser_anterior <-
    chromote::default_chromote_object()
  
  if (
    !is.null(browser_anterior) &&
    browser_anterior$is_alive()
  ) {
    
    try(
      browser_anterior$close(),
      silent = TRUE
    )
  }
  
  
  # 2. INICIAR SISTEMA ====================
  
  b <- iniciar_sistema(
    url_sistema
  )
  
  
  # 3. LOGIN ====================
  
  fazer_login(
    b,
    usuario,
    senha
  )
  
  
  # 4. EXERCÍCIO ====================
  
  b <- selecionar_exercicio(
    b,
    exercicio
  )
  
  
  if (
    as.integer(exercicio) < 2021
  ) {
    Sys.sleep(15)
  } else {
    Sys.sleep(3)
  }
  
  
  b
}
