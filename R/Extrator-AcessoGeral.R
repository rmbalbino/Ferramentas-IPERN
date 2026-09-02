iniciar_sistema <- function(
    url_sistema,
    timeout = 60,
    intervalo = 0.1
) {

  b <- chromote::ChromoteSession$new(
    args = c(
      "--no-sandbox",
      "--disable-dev-shm-usage"
    )
  )

  b$view()

  b$Page$navigate(
    url_sistema
  )


  inicio <- Sys.time()


  repeat {

    login_pronto <- try(
      b$Runtime$evaluate(
        '
        (function() {

          var frame =
            document.querySelector("iframe");

          if (
            !frame ||
            !frame.contentDocument
          ) {
            return false;
          }

          var doc =
            frame.contentDocument;


          var usuario =
            doc.querySelector(
              "input[placeholder=\'Usuário\']"
            );

          var senha =
            doc.querySelector(
              "input[placeholder=\'Senha\']"
            );


          return (
            usuario !== null &&
            senha !== null
          );

        })()
        ',
        returnByValue = TRUE
      )$result$value,
      silent = TRUE
    )


    if (
      !inherits(
        login_pronto,
        "try-error"
      ) &&
      isTRUE(login_pronto)
    ) {
      break
    }


    tempo <- as.numeric(
      difftime(
        Sys.time(),
        inicio,
        units = "secs"
      )
    )


    if (tempo >= timeout) {
      stop(
        "Tempo excedido aguardando a tela de login do sistema."
      )
    }


    Sys.sleep(
      intervalo
    )
  }


  b
}




# 1. FUNÇÕES DE NAVEGAÇÃO ====================

digitar_como_teclado <- function(session, seletor_input, texto) {

  for (caractere in strsplit(texto, "")[[1]]) {

    script <- sprintf(
      '
      (function() {

        var frame = document.querySelector("iframe");
        var doc = frame.contentDocument;

        var el = doc.querySelector("%s");

        el.focus();

        var nativeSetter =
          Object.getOwnPropertyDescriptor(
            window.HTMLInputElement.prototype,
            "value"
          ).set;

        nativeSetter.call(
          el,
          el.value + "%s"
        );

        el.dispatchEvent(
          new KeyboardEvent(
            "keydown",
            { key: "%s", bubbles: true }
          )
        );

        el.dispatchEvent(
          new Event(
            "input",
            { bubbles: true }
          )
        );

        el.dispatchEvent(
          new KeyboardEvent(
            "keyup",
            { key: "%s", bubbles: true }
          )
        );

      })()
      ',
      seletor_input,
      caractere,
      caractere,
      caractere
    )

    session$Runtime$evaluate(
      script
    )

    Sys.sleep(0.05)
  }
}




digitar_como_teclado_direto <- function(
    session,
    id_campo,
    texto
) {

  session$Runtime$evaluate(
    sprintf(
      'document.getElementById("%s").value = ""',
      id_campo
    )
  )

  for (caractere in strsplit(texto, "")[[1]]) {

    script <- sprintf(
      '
      (function() {

        var el =
          document.getElementById("%s");

        el.focus();

        var nativeSetter =
          Object.getOwnPropertyDescriptor(
            window.HTMLInputElement.prototype,
            "value"
          ).set;

        nativeSetter.call(
          el,
          el.value + "%s"
        );

        el.dispatchEvent(
          new KeyboardEvent(
            "keydown",
            { key: "%s", bubbles: true }
          )
        );

        el.dispatchEvent(
          new Event(
            "input",
            { bubbles: true }
          )
        );

        el.dispatchEvent(
          new KeyboardEvent(
            "keyup",
            { key: "%s", bubbles: true }
          )
        );

      })()
      ',
      id_campo,
      caractere,
      caractere,
      caractere
    )

    session$Runtime$evaluate(
      script
    )

    Sys.sleep(0.03)
  }


  session$Runtime$evaluate(
    sprintf(
      '
      document
        .getElementById("%s")
        .dispatchEvent(
          new Event(
            "blur",
            { bubbles: true }
          )
        )
      ',
      id_campo
    )
  )
}




selecionar_select_por_texto <- function(
    session,
    id,
    texto
) {

  resultado <- session$Runtime$evaluate(
    sprintf(
      '
      (function() {

        var el =
          document.getElementById("%s");

        if (!el) {
          return "Campo não encontrado";
        }

        var opcao =
          Array.from(el.options).find(
            function(opt) {
              return (
                opt.text.trim() === "%s"
              );
            }
          );

        if (!opcao) {
          return "Opção não encontrada";
        }

        el.value =
          opcao.value;

        el.dispatchEvent(
          new Event(
            "change",
            { bubbles: true }
          )
        );

        return opcao.text.trim();

      })()
      ',
      id,
      texto
    ),
    returnByValue = TRUE
  )$result$value

  resultado
}




fazer_login <- function(
    b,
    usuario,
    senha
) {

  b$Runtime$evaluate(
    '
    (function() {

      var frame =
        document.querySelector("iframe");

      var doc =
        frame.contentDocument;

      doc.querySelector(
        "input[placeholder=\'Usuário\']"
      ).value = "";

      doc.querySelector(
        "input[placeholder=\'Senha\']"
      ).value = "";

    })()
    '
  )


  digitar_como_teclado(
    b,
    "input[placeholder='Usuário']",
    usuario
  )


  digitar_como_teclado(
    b,
    "input[placeholder='Senha']",
    senha
  )


  b$Runtime$evaluate(
    '
  (function() {

    var frame =
      document.querySelector("iframe");

    var doc =
      frame.contentDocument;

    doc.querySelector(
      "input[placeholder=\'Senha\']"
    ).focus();

  })()
  '
  )

  Sys.sleep(0.3)


  b$Input$dispatchKeyEvent(
    type = "keyDown",
    key = "Tab",
    code = "Tab",
    windowsVirtualKeyCode = 9
  )

  b$Input$dispatchKeyEvent(
    type = "keyUp",
    key = "Tab",
    code = "Tab",
    windowsVirtualKeyCode = 9
  )

  Sys.sleep(1)


  resultado <- b$Runtime$evaluate(
    '
    (function() {

      var frame =
        document.querySelector("iframe");

      var doc =
        frame.contentDocument;

      var botao = Array.from(
        doc.querySelectorAll("button")
      ).find(
        function(el) {
          return el.innerText
            .trim()
            .includes("Acessar");
        }
      );

      if (!botao) {
        return "Botão Acessar não encontrado";
      }

      botao.click();

      return "Clique realizado";

    })()
    ',
    returnByValue = TRUE
  )$result$value


  if (resultado != "Clique realizado") {
    stop(resultado)
  }

  Sys.sleep(5)

  invisible(TRUE)
}




selecionar_exercicio <- function(
    session,
    exercicio
) {

  resultado <- session$Runtime$evaluate(
    sprintf(
      '
      (function() {

        var frame =
          document.querySelector("iframe");

        var doc =
          frame
            ? frame.contentDocument
            : document;

        var combo =
          doc.getElementById(
            "cboExercicio"
          );

        if (!combo) {
          return "Combobox de exercício não encontrado";
        }

        var opcoes = Array.from(
          combo.querySelectorAll(
            "ul.dropdown-menu li a"
          )
        );

        var opcao =
          opcoes.find(function(el) {

            return (
              (el.innerText || "")
                .trim() === "%s"
            );

          });

        if (!opcao) {
          return "Exercício não encontrado";
        }

        setTimeout(function() {
          opcao.click();
        }, 50);

        return "Exercício selecionado";

      })()
      ',
      exercicio
    ),
    returnByValue = TRUE
  )$result$value


  if (
    resultado !=
    "Exercício selecionado"
  ) {
    stop(resultado)
  }


  Sys.sleep(3)


  # Verifica se o próprio portal mudou de exercício
  frame_tree <-
    session$Page$getFrameTree()$frameTree

  url_iframe <-
    frame_tree$childFrames[[1]]$frame$url


  if (
    grepl(
      paste0("SIGEF", exercicio),
      url_iframe,
      fixed = TRUE
    )
  ) {

    return(session)
  }


  stop(
    paste0(
      "O exercício ",
      exercicio,
      " não foi carregado."
    )
  )
}




localizar_popup <- function(b, trecho_url) {

  alvos <-
    b$Target$getTargets()$targetInfos

  encontrados <- Filter(
    function(x) {
      grepl(
        trecho_url,
        x$url,
        fixed = TRUE
      )
    },
    alvos
  )

  if (length(encontrados) == 0) {
    stop(
      paste(
        "Popup não encontrado:",
        trecho_url
      )
    )
  }

  encontrados[[1]]
}




aguardar_condicao <- function(
    session,
    script,
    timeout = 10,
    intervalo = 0.05
) {

  inicio <- Sys.time()

  repeat {

    resultado <- session$Runtime$evaluate(
      script,
      returnByValue = TRUE
    )$result$value


    if (isTRUE(resultado)) {
      return(invisible(TRUE))
    }


    if (
      as.numeric(
        difftime(
          Sys.time(),
          inicio,
          units = "secs"
        )
      ) >= timeout
    ) {
      stop(
        "Tempo excedido aguardando o carregamento."
      )
    }


    Sys.sleep(
      intervalo
    )
  }
}




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
