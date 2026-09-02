// ALMOXARIFADO

Shiny.addCustomMessageHandler(
      'estado_competencia_almoxarifado',
      function(msg) {

        const uploads = document.querySelectorAll(
          '.upload-almoxarifado, .upload-descricao'
        );

        const botao =
          document.getElementById(
            'ConfirmarCompetenciaAlmoxarifado'
          );

        uploads.forEach(function(area) {

          if (msg.confirmada) {
            area.classList.remove('upload-bloqueado');
          } else {
            area.classList.add('upload-bloqueado');
          }

        });

        if (botao) {

          if (msg.confirmada) {
            botao.classList.add(
              'competencia-confirmada'
            );
          } else {
            botao.classList.remove(
              'competencia-confirmada'
            );
          }

        }

      }
    );

Shiny.addCustomMessageHandler(
      'etapa_almoxarifado',
      function(msg) {

        const etapas = [
          document.getElementById('EtapaAlmoxarifado1'),
          document.getElementById('EtapaAlmoxarifado2'),
          document.getElementById('EtapaAlmoxarifado3'),
          document.getElementById('EtapaAlmoxarifado4')
        ];

        const linhas = document.querySelectorAll(
          '#StepperAlmoxarifado .etapa-linha'
        );

        if (etapas.some(x => !x)) return;

        etapas.forEach(function(etapa, indice) {

          etapa.classList.remove(
            'etapa-ativa',
            'etapa-concluida'
          );

          const numero = etapa.querySelector('.etapa-numero');

          if (indice + 1 < msg.etapa) {

            etapa.classList.add('etapa-concluida');

            if (numero) {
              numero.textContent = '✓';
            }

          } else {

            if (numero) {
              numero.textContent = String(indice + 1);
            }
          }

          if (indice + 1 === msg.etapa) {
            etapa.classList.add('etapa-ativa');
          }

        });

        linhas.forEach(function(linha, indice) {

          linha.classList.remove(
            'etapa-linha-concluida'
          );

          if (indice < msg.etapa - 1) {
            linha.classList.add(
              'etapa-linha-concluida'
            );
          }

        });

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_almoxarifado',
      function(msg) {

        const area =
          document.querySelector('.upload-almoxarifado');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_descricao',
      function(msg) {

        const area =
          document.querySelector('.upload-descricao');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_download_almoxarifado',
      function(msg) {

        const wrapper =
          document.getElementById(
            'DownloadAlmoxarifado_wrapper'
          );

        if (!wrapper) return;

        if (msg.liberado) {

          wrapper.classList.remove(
            'download-desabilitado'
          );

          wrapper.classList.add(
            'download-liberado'
          );

        } else {

          wrapper.classList.remove(
            'download-liberado'
          );

          wrapper.classList.add(
            'download-desabilitado'
          );

        }

      }
    );



// CONCILIADOR CONTA CORRENTE 7988X

Shiny.addCustomMessageHandler(
  "estado_competencia_conciliador_conta_corrente",
  function(msg) {

    const botao =
      document.getElementById(
        "ConfirmarCompetenciaConciliadorContaCorrente"
      );

    const uploads =
      document.querySelectorAll(
        ".upload-conciliador-conta-corrente-extrato, .upload-conciliador-conta-corrente-razao"
      );

    if (botao) {

      if (msg.confirmada) {
        botao.classList.add(
          "competencia-confirmada"
        );
      } else {
        botao.classList.remove(
          "competencia-confirmada"
        );
      }
    }

    uploads.forEach(function(upload) {

      if (msg.confirmada) {
        upload.classList.remove(
          "upload-bloqueado"
        );
      } else {
        upload.classList.add(
          "upload-bloqueado"
        );
      }
    });
  }
);


Shiny.addCustomMessageHandler(
  "estado_upload_conciliador_conta_corrente_extrato",
  function(msg) {

    const upload =
      document.querySelector(
        ".upload-conciliador-conta-corrente-extrato"
      );

    if (!upload) return;

    upload.classList.remove(
      "upload-carregando"
    );

    if (msg.carregado) {
      upload.classList.add(
        "upload-carregado"
      );
    } else {
      upload.classList.remove(
        "upload-carregado"
      );
    }
  }
);


Shiny.addCustomMessageHandler(
  "estado_upload_conciliador_conta_corrente_razao",
  function(msg) {

    const upload =
      document.querySelector(
        ".upload-conciliador-conta-corrente-razao"
      );

    if (!upload) return;

    upload.classList.remove(
      "upload-carregando"
    );

    if (msg.carregado) {
      upload.classList.add(
        "upload-carregado"
      );
    } else {
      upload.classList.remove(
        "upload-carregado"
      );
    }
  }
);


Shiny.addCustomMessageHandler(
  "estado_download_conciliador_conta_corrente",
  function(msg) {

    const wrapper =
      document.getElementById(
        "DownloadConciliadorContaCorrente_wrapper"
      );

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );
    }
  }
);


Shiny.addCustomMessageHandler(
  "etapa_conciliador_conta_corrente",
  function(msg) {

    const etapaAtual = msg.etapa;

    for (let i = 1; i <= 4; i++) {

      const etapa =
        document.getElementById(
          "EtapaConciliadorContaCorrente" + i
        );

      if (!etapa) continue;

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      if (i < etapaAtual) {
        etapa.classList.add(
          "etapa-concluida"
        );
      }

      if (i === etapaAtual) {
        etapa.classList.add(
          "etapa-ativa"
        );
      }
    }
  }
);



// CONTROLE INVESTIMENTOS

Shiny.addCustomMessageHandler(
      'estado_competencia_investimento',
      function(msg) {

        const uploads = document.querySelectorAll(
          '.upload-investimento, .upload-artigos'
        );

        const botao =
          document.getElementById(
            'ConfirmarCompetenciaInvestimento'
          );

        uploads.forEach(function(area) {

          if (msg.confirmada) {
            area.classList.remove('upload-bloqueado');
          } else {
            area.classList.add('upload-bloqueado');
          }

        });

        if (botao) {

          if (msg.confirmada) {
            botao.classList.add(
              'competencia-confirmada'
            );
          } else {
            botao.classList.remove(
              'competencia-confirmada'
            );
          }

        }

      }
    );

Shiny.addCustomMessageHandler(
      'etapa_investimento',
      function(msg) {

        const etapas = [
          document.getElementById('EtapaInvestimento1'),
          document.getElementById('EtapaInvestimento2'),
          document.getElementById('EtapaInvestimento3'),
          document.getElementById('EtapaInvestimento4')
        ];

        const linhas = document.querySelectorAll(
          '#StepperInvestimento .etapa-linha'
        );

        if (etapas.some(x => !x)) return;

        etapas.forEach(function(etapa, indice) {

          etapa.classList.remove(
            'etapa-ativa',
            'etapa-concluida'
          );

          const numero = etapa.querySelector('.etapa-numero');

          if (indice + 1 < msg.etapa) {
            etapa.classList.add('etapa-concluida');

            if (numero) {
              numero.textContent = '✓';
            }

          } else {

            if (numero) {
              numero.textContent = String(indice + 1);
            }
          }

          if (indice + 1 === msg.etapa) {
            etapa.classList.add('etapa-ativa');
          }
        });

        linhas.forEach(function(linha, indice) {

          linha.classList.remove(
            'etapa-linha-concluida'
          );

          if (indice < msg.etapa - 1) {
            linha.classList.add(
              'etapa-linha-concluida'
            );
          }
        });

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_investimento',
      function(msg) {

        const area =
          document.querySelector('.upload-investimento');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_artigos',
      function(msg) {

        const area =
          document.querySelector('.upload-artigos');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_download_investimento',
      function(msg) {

        const wrapper =
          document.getElementById(
            'DownloadInvestimento_wrapper'
          );

        if (!wrapper) return;

        if (msg.liberado) {

          wrapper.classList.remove(
            'download-desabilitado'
          );

          wrapper.classList.add(
            'download-liberado'
          );

        } else {

          wrapper.classList.remove(
            'download-liberado'
          );

          wrapper.classList.add(
            'download-desabilitado'
          );

        }

      }
    );



// CONTROLE PAGAMENTOS

Shiny.addCustomMessageHandler(
  "estado_competencia_cp",
  function(msg) {

    const botao =
      document.getElementById("ConfirmarCompetenciaCP");

    const upload =
      document.querySelector(".upload-cp");

    if (botao) {

      if (msg.confirmada) {
        botao.classList.add("competencia-confirmada");
      } else {
        botao.classList.remove("competencia-confirmada");
      }

    }

    if (upload) {

      if (msg.confirmada) {
        upload.classList.remove("upload-bloqueado");
      } else {
        upload.classList.add("upload-bloqueado");
      }

    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_upload_cp",
  function(msg) {

    const upload =
      document.querySelector(".upload-cp");

    if (!upload) return;

    upload.classList.remove("upload-carregando");

    if (msg.carregado) {
      upload.classList.add("upload-carregado");
    } else {
      upload.classList.remove("upload-carregado");
    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_download_cp",
  function(msg) {

    const wrapper =
      document.getElementById("DownloadCP_wrapper");

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );

    }

  }
);

Shiny.addCustomMessageHandler(
  "etapa_cp",
  function(msg) {

    const etapas = [
      document.getElementById("EtapaCP1"),
      document.getElementById("EtapaCP2"),
      document.getElementById("EtapaCP3"),
      document.getElementById("EtapaCP4")
    ];

    const linhas =
      document.querySelectorAll(
        "#StepperCP .etapa-linha"
      );

    if (etapas.some(x => !x)) return;

    etapas.forEach(function(etapa, indice) {

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      const numero =
        etapa.querySelector(".etapa-numero");

      if (indice + 1 < msg.etapa) {

        etapa.classList.add(
          "etapa-concluida"
        );

        if (numero) {
          numero.textContent = "✓";
        }

      } else {

        if (numero) {
          numero.textContent =
            String(indice + 1);
        }

      }

      if (indice + 1 === msg.etapa) {
        etapa.classList.add("etapa-ativa");
      }

    });

    linhas.forEach(function(linha, indice) {

      linha.classList.remove(
        "etapa-linha-concluida"
      );

      if (indice < msg.etapa - 1) {
        linha.classList.add(
          "etapa-linha-concluida"
        );
      }

    });

  }
);



// EXTRATO BANCÁRIO

Shiny.addCustomMessageHandler(
  "estado_competencia_extrato",
  function(msg) {

    const botao =
      document.getElementById(
        "ConfirmarCompetenciaExtrato"
      );

    const upload =
      document.querySelector(".upload-extrato");

    if (botao) {

      if (msg.confirmada) {
        botao.classList.add(
          "competencia-confirmada"
        );
      } else {
        botao.classList.remove(
          "competencia-confirmada"
        );
      }

    }

    if (upload) {

      if (msg.confirmada) {
        upload.classList.remove(
          "upload-bloqueado"
        );
      } else {
        upload.classList.add(
          "upload-bloqueado"
        );
      }

    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_upload_extrato",
  function(msg) {

    const upload =
      document.querySelector(".upload-extrato");

    if (!upload) return;

    upload.classList.remove("upload-carregando");

    if (msg.carregado) {
      upload.classList.add("upload-carregado");
    } else {
      upload.classList.remove("upload-carregado");
    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_download_extrato",
  function(msg) {

    const wrapper =
      document.getElementById(
        "DownloadExtrato_wrapper"
      );

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );

    }

  }
);

Shiny.addCustomMessageHandler(
  "etapa_extrato",
  function(msg) {

    const etapas = [
      document.getElementById("EtapaExtrato1"),
      document.getElementById("EtapaExtrato2"),
      document.getElementById("EtapaExtrato3"),
      document.getElementById("EtapaExtrato4")
    ];

    const linhas =
      document.querySelectorAll(
        "#StepperExtrato .etapa-linha"
      );

    if (etapas.some(x => !x)) return;

    etapas.forEach(function(etapa, indice) {

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      const numero =
        etapa.querySelector(".etapa-numero");

      if (indice + 1 < msg.etapa) {

        etapa.classList.add(
          "etapa-concluida"
        );

        if (numero) {
          numero.textContent = "✓";
        }

      } else {

        if (numero) {
          numero.textContent =
            String(indice + 1);
        }

      }

      if (indice + 1 === msg.etapa) {
        etapa.classList.add(
          "etapa-ativa"
        );
      }

    });

    linhas.forEach(function(linha, indice) {

      linha.classList.remove(
        "etapa-linha-concluida"
      );

      if (indice < msg.etapa - 1) {
        linha.classList.add(
          "etapa-linha-concluida"
        );
      }

    });

  }
);



//FICHA RAZÃO

Shiny.addCustomMessageHandler(
  "estado_competencia_razao",
  function(msg) {

    const botao =
      document.getElementById("ConfirmarCompetenciaRazao");

    const upload =
      document.querySelector(".upload-razao");

    if (botao) {

      if (msg.confirmada) {
        botao.classList.add("competencia-confirmada");
      } else {
        botao.classList.remove("competencia-confirmada");
      }

    }

    if (upload) {

      if (msg.confirmada) {
        upload.classList.remove("upload-bloqueado");
      } else {
        upload.classList.add("upload-bloqueado");
      }

    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_upload_razao",
  function(msg) {

    const upload =
      document.querySelector(".upload-razao");

    if (!upload) return;

    upload.classList.remove("upload-carregando");

    if (msg.carregado) {
      upload.classList.add("upload-carregado");
    } else {
      upload.classList.remove("upload-carregado");
    }

  }
);

Shiny.addCustomMessageHandler(
  "estado_download_razao",
  function(msg) {

    const wrapper =
      document.getElementById("DownloadRazao_wrapper");

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );

    }

  }
);

Shiny.addCustomMessageHandler(
  "etapa_razao",
  function(msg) {

    const etapas = [
      document.getElementById("EtapaRazao1"),
      document.getElementById("EtapaRazao2"),
      document.getElementById("EtapaRazao3"),
      document.getElementById("EtapaRazao4")
    ];

    const linhas =
      document.querySelectorAll(
        "#StepperRazao .etapa-linha"
      );

    if (etapas.some(x => !x)) return;

    etapas.forEach(function(etapa, indice) {

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      const numero =
        etapa.querySelector(".etapa-numero");

      if (indice + 1 < msg.etapa) {

        etapa.classList.add(
          "etapa-concluida"
        );

        if (numero) {
          numero.textContent = "✓";
        }

      } else {

        if (numero) {
          numero.textContent =
            String(indice + 1);
        }

      }

      if (indice + 1 === msg.etapa) {
        etapa.classList.add("etapa-ativa");
      }

    });

    linhas.forEach(function(linha, indice) {

      linha.classList.remove(
        "etapa-linha-concluida"
      );

      if (indice < msg.etapa - 1) {
        linha.classList.add(
          "etapa-linha-concluida"
        );
      }

    });

  }
);


// CONCILIADOR FICHA RAZÃO

Shiny.addCustomMessageHandler(
  "estado_competencia_conciliador_ficha_razao",
  function(msg) {

    const botao =
      document.getElementById(
        "ConfirmarCompetenciaConciliadorFichaRazao"
      );

    const upload =
      document.querySelector(
        ".upload-conciliador-ficha-razao"
      );

    if (botao) {

      if (msg.confirmada) {
        botao.classList.add(
          "competencia-confirmada"
        );
      } else {
        botao.classList.remove(
          "competencia-confirmada"
        );
      }
    }

    if (upload) {

      if (msg.confirmada) {
        upload.classList.remove(
          "upload-bloqueado"
        );
      } else {
        upload.classList.add(
          "upload-bloqueado"
        );
      }
    }
  }
);


Shiny.addCustomMessageHandler(
  "estado_upload_conciliador_ficha_razao",
  function(msg) {

    const upload =
      document.querySelector(
        ".upload-conciliador-ficha-razao"
      );

    if (!upload) return;

    upload.classList.remove(
      "upload-carregando"
    );

    if (msg.carregado) {
      upload.classList.add(
        "upload-carregado"
      );
    } else {
      upload.classList.remove(
        "upload-carregado"
      );
    }
  }
);


Shiny.addCustomMessageHandler(
  "estado_download_conciliador_ficha_razao",
  function(msg) {

    const wrapper =
      document.getElementById(
        "DownloadConciliadorFichaRazao_wrapper"
      );

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );
    }
  }
);


Shiny.addCustomMessageHandler(
  "etapa_conciliador_ficha_razao",
  function(msg) {

    const stepper =
      document.getElementById(
        "StepperConciliadorFichaRazao"
      );

    if (!stepper) return;

    const etapaAtual = msg.etapa;

    for (let i = 1; i <= 4; i++) {

      const etapa =
        document.getElementById(
          "EtapaConciliadorFichaRazao" + i
        );

      if (!etapa) continue;

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      if (i < etapaAtual) {
        etapa.classList.add(
          "etapa-concluida"
        );
      }

      if (i === etapaAtual) {
        etapa.classList.add(
          "etapa-ativa"
        );
      }
    }
  }
);


// FOLHAS DE PAGAMENTO

Shiny.addCustomMessageHandler("estado_competencia_fdp", function(msg) {

  const botao = document.getElementById("ConfirmarCompetenciaFDP");
  const upload = document.querySelector(".upload-fdp");

  if (botao) {

    if (msg.confirmada) {
      botao.classList.add("competencia-confirmada");
    } else {
      botao.classList.remove("competencia-confirmada");
    }

  }

  if (upload) {

    if (msg.confirmada) {
      upload.classList.remove("upload-bloqueado");
    } else {
      upload.classList.add("upload-bloqueado");
    }

  }

});


$(document).on("change", ".upload-input-real input[type='file']", function() {

  const upload = this.closest(".upload-dropzone");

  if (!upload) return;

  upload.classList.remove("upload-carregado");
  upload.classList.add("upload-carregando");

});


Shiny.addCustomMessageHandler("estado_upload_fdp", function(msg) {

  const upload = document.querySelector(".upload-fdp");

  if (!upload) return;

  upload.classList.remove("upload-carregando");

  if (msg.carregado) {
    upload.classList.add("upload-carregado");
  } else {
    upload.classList.remove("upload-carregado");
  }

});


Shiny.addCustomMessageHandler("estado_download_fdp", function(msg) {

  const wrapper = document.getElementById("DownloadFDP_wrapper");

  if (!wrapper) return;

  if (msg.liberado) {
    wrapper.classList.remove("download-desabilitado");
    wrapper.classList.add("download-liberado");
  } else {
    wrapper.classList.remove("download-liberado");
    wrapper.classList.add("download-desabilitado");
  }

});


Shiny.addCustomMessageHandler("etapa_fdp", function(msg) {

  const stepper = document.getElementById("StepperFDP");

  if (!stepper) return;

  const etapaAtual = msg.etapa;

  for (let i = 1; i <= 4; i++) {

    const etapa = document.getElementById("EtapaFDP" + i);

    if (!etapa) continue;

    etapa.classList.remove(
      "etapa-ativa",
      "etapa-concluida"
    );

    if (i < etapaAtual) {
      etapa.classList.add("etapa-concluida");
    }

    if (i === etapaAtual) {
      etapa.classList.add("etapa-ativa");
    }

  }

});



// GUIA RECEBIMENTO

Shiny.addCustomMessageHandler("estado_competencia_gr", function(msg) {

  const botao = document.getElementById("ConfirmarCompetenciaGR");
  const upload = document.querySelector(".upload-gr");

  if (botao) {

    if (msg.confirmada) {
      botao.classList.add("competencia-confirmada");
    } else {
      botao.classList.remove("competencia-confirmada");
    }

  }

  if (upload) {

    if (msg.confirmada) {
      upload.classList.remove("upload-bloqueado");
    } else {
      upload.classList.add("upload-bloqueado");
    }

  }

});

Shiny.addCustomMessageHandler("estado_upload_gr", function(msg) {

  const upload = document.querySelector(".upload-gr");

  if (!upload) return;

  upload.classList.remove("upload-carregando");

  if (msg.carregado) {
    upload.classList.add("upload-carregado");
  } else {
    upload.classList.remove("upload-carregado");
  }

});

Shiny.addCustomMessageHandler("estado_download_gr", function(msg) {

  const wrapper = document.getElementById("DownloadGR_wrapper");

  if (!wrapper) return;

  if (msg.liberado) {
    wrapper.classList.remove("download-desabilitado");
    wrapper.classList.add("download-liberado");
  } else {
    wrapper.classList.remove("download-liberado");
    wrapper.classList.add("download-desabilitado");
  }

});

Shiny.addCustomMessageHandler("etapa_gr", function(msg) {

  const etapaAtual = msg.etapa;

  for (let i = 1; i <= 4; i++) {

    const etapa = document.getElementById("EtapaGR" + i);

    if (!etapa) continue;

    etapa.classList.remove(
      "etapa-ativa",
      "etapa-concluida"
    );

    if (i < etapaAtual) {
      etapa.classList.add("etapa-concluida");
    }

    if (i === etapaAtual) {
      etapa.classList.add("etapa-ativa");
    }

  }

});



// ORDERNS BANCARIAS

Shiny.addCustomMessageHandler('estado_upload_ob', function(msg) {

      const area = document.querySelector('.upload-dropzone');

      if (!area) return;
	  
	  area.classList.remove("upload-carregando");

      if (msg.carregado) {
        area.classList.add('upload-carregado');
      } else {
        area.classList.remove('upload-carregado');
      }

    });

Shiny.addCustomMessageHandler(
      'estado_download_ob',
      function(msg) {

        const wrapper =
          document.getElementById('DownloadOB_wrapper');

        if (!wrapper) return;

        if (msg.liberado) {

          wrapper.classList.remove(
            'download-desabilitado'
          );

          wrapper.classList.add(
            'download-liberado'
          );

        } else {

          wrapper.classList.remove(
            'download-liberado'
          );

          wrapper.classList.add(
            'download-desabilitado'
          );

        }

      }
    );

Shiny.addCustomMessageHandler(
      'etapa_ob',
      function(msg) {

        const etapas = [
          document.getElementById('EtapaOB1'),
          document.getElementById('EtapaOB2'),
          document.getElementById('EtapaOB3'),
          document.getElementById('EtapaOB4')
        ];

        const linhas = document.querySelectorAll(
          '#StepperOB .etapa-linha'
        );

        if (etapas.some(x => !x)) return;

        etapas.forEach(function(etapa, indice) {

          etapa.classList.remove(
            'etapa-ativa',
            'etapa-concluida'
          );

          const numero =
            etapa.querySelector('.etapa-numero');

          if (indice + 1 < msg.etapa) {

            etapa.classList.add(
              'etapa-concluida'
            );

            if (numero) {
              numero.textContent = '✓';
            }

          } else {

            if (numero) {
              numero.textContent =
                String(indice + 1);
            }

          }

          if (indice + 1 === msg.etapa) {
            etapa.classList.add('etapa-ativa');
          }

        });

        linhas.forEach(function(linha, indice) {

          linha.classList.remove(
            'etapa-linha-concluida'
          );

          if (indice < msg.etapa - 1) {
            linha.classList.add(
              'etapa-linha-concluida'
            );
          }

        });

      }
    );

Shiny.addCustomMessageHandler(
      'estado_competencia_ob',
      function(msg) {

        const area =
          document.querySelector('.upload-dropzone');

        const botao =
          document.getElementById('ConfirmarCompetenciaOB');

        if (area) {

          if (msg.confirmada) {
            area.classList.remove('upload-bloqueado');
          } else {
            area.classList.add('upload-bloqueado');
          }

        }

        if (botao) {

          if (msg.confirmada) {
            botao.classList.add('competencia-confirmada');
          } else {
            botao.classList.remove('competencia-confirmada');
          }

        }

      }
    );



// EXTRAIR ORDENS BANCARIAS

// EXTRATOR DE ORDENS BANCÁRIAS

Shiny.addCustomMessageHandler(
  "etapa_extrator_obs",
  function(msg) {

    const etapas = [
      document.getElementById("EtapaExtratorOBs1"),
      document.getElementById("EtapaExtratorOBs2"),
      document.getElementById("EtapaExtratorOBs3"),
      document.getElementById("EtapaExtratorOBs4")
    ];

    const linhas = document.querySelectorAll(
      "#StepperExtratorOBs .etapa-linha"
    );

    if (etapas.some(x => !x)) return;

    etapas.forEach(function(etapa, indice) {

      etapa.classList.remove(
        "etapa-ativa",
        "etapa-concluida"
      );

      const numero =
        etapa.querySelector(".etapa-numero");

      if (indice + 1 < msg.etapa) {

        etapa.classList.add(
          "etapa-concluida"
        );

        if (numero) {
          numero.textContent = "✓";
        }

      } else {

        if (numero) {
          numero.textContent =
            String(indice + 1);
        }
      }

      if (indice + 1 === msg.etapa) {
        etapa.classList.add(
          "etapa-ativa"
        );
      }
    });

    linhas.forEach(function(linha, indice) {

      linha.classList.remove(
        "etapa-linha-concluida"
      );

      if (indice < msg.etapa - 1) {
        linha.classList.add(
          "etapa-linha-concluida"
        );
      }
    });
  }
);

Shiny.addCustomMessageHandler(
  "estado_download_extrator_obs",
  function(msg) {

    const wrapper =
      document.getElementById(
        "DownloadExtratorOBs_wrapper"
      );

    if (!wrapper) return;

    if (msg.liberado) {

      wrapper.classList.remove(
        "download-desabilitado"
      );

      wrapper.classList.add(
        "download-liberado"
      );

    } else {

      wrapper.classList.remove(
        "download-liberado"
      );

      wrapper.classList.add(
        "download-desabilitado"
      );
    }
  }
);

// MÁSCARAS - EXTRATOR DE OBS

$(document).on(
  "input",
  "#UsuarioExtratorOBs",
  function() {

    let valor = this.value
      .replace(/\D/g, "")
      .slice(0, 11);

    valor = valor
      .replace(/(\d{3})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d{1,2})$/, "$1-$2");

    this.value = valor;
  }
);


$(document).on(
  "input",
  "#UGExtratorOBs",
  function() {

    this.value = this.value
      .replace(/\D/g, "")
      .slice(0, 6);
  }
);


$(document).on(
  "input",
  "#GestaoExtratorOBs",
  function() {

    this.value = this.value
      .replace(/\D/g, "")
      .slice(0, 5);
  }
);



// RETENCAO REALIZADA

Shiny.addCustomMessageHandler(
      'estado_competencia_rr',
      function(msg) {

        const uploads = document.querySelectorAll(
          '.upload-rr, .upload-rr-cnpj'
        );

        const botao =
          document.getElementById('ConfirmarCompetenciaRR');

        uploads.forEach(function(area) {

          if (msg.confirmada) {
            area.classList.remove('upload-bloqueado');
          } else {
            area.classList.add('upload-bloqueado');
          }

        });

        if (botao) {

          if (msg.confirmada) {
            botao.classList.add('competencia-confirmada');
          } else {
            botao.classList.remove('competencia-confirmada');
          }

        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_rr',
      function(msg) {

        const area = document.querySelector('.upload-rr');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'estado_upload_rr_cnpj',
      function(msg) {

        const area = document.querySelector('.upload-rr-cnpj');

        if (!area) return;
		
		area.classList.remove("upload-carregando");

        if (msg.carregado) {
          area.classList.add('upload-carregado');
        } else {
          area.classList.remove('upload-carregado');
        }

      }
    );

Shiny.addCustomMessageHandler(
      'etapa_rr',
      function(msg) {

        const etapas = [
          document.getElementById('EtapaRR1'),
          document.getElementById('EtapaRR2'),
          document.getElementById('EtapaRR3'),
          document.getElementById('EtapaRR4')
        ];

        const linhas = document.querySelectorAll(
          '#StepperRR .etapa-linha'
        );

        if (etapas.some(x => !x)) return;

        etapas.forEach(function(etapa, indice) {

          etapa.classList.remove(
            'etapa-ativa',
            'etapa-concluida'
          );

          const numero =
            etapa.querySelector('.etapa-numero');

          if (indice + 1 < msg.etapa) {

            etapa.classList.add(
              'etapa-concluida'
            );

            if (numero) {
              numero.textContent = '✓';
            }

          } else {

            if (numero) {
              numero.textContent =
                String(indice + 1);
            }

          }

          if (indice + 1 === msg.etapa) {
            etapa.classList.add('etapa-ativa');
          }

        });

        linhas.forEach(function(linha, indice) {

          linha.classList.remove(
            'etapa-linha-concluida'
          );

          if (indice < msg.etapa - 1) {
            linha.classList.add(
              'etapa-linha-concluida'
            );
          }

        });

      }
    );

Shiny.addCustomMessageHandler(
      'estado_download_rr',
      function(msg) {

        const wrapper =
          document.getElementById('DownloadRR_wrapper');

        if (!wrapper) return;

        if (msg.liberado) {

          wrapper.classList.remove(
            'download-desabilitado'
          );

          wrapper.classList.add(
            'download-liberado'
          );

        } else {

          wrapper.classList.remove(
            'download-liberado'
          );

          wrapper.classList.add(
            'download-desabilitado'
          );

        }

      }
    );
