#ifdef SPANISH
	#define STR0001 "Asientos contables"
	#define STR0002 "Fecha"
	#define STR0003 "Lote"
	#define STR0004 If( cPaisLoc == "ANG", "Poliza", If( cPaisLoc == "EQU", "Poliza", If( cPaisLoc == "HAI", "Poliza", If( cPaisLoc == "MEX", "Poliza", If( cPaisLoc == "PTG", "Poliza", "Doc" ) ) ) ) )
	#define STR0005 "Seleccionando registros..."
	#define STR0006 "Total informado: "
	#define STR0007 "Total registrado: "
	#define STR0008 If( cPaisLoc == "MEX", "Total Cargo: ", "Total Debito: " )
	#define STR0009 If( cPaisLoc == "MEX", "Total Abono: ", "Total Credito: " )
	#define STR0010 If( cPaisLoc == "ANG", "�Debito y Credito no coinciden! �Continua?", If( cPaisLoc == "EQU", "�Debito y Credito no coinciden! �Continua?", If( cPaisLoc == "HAI", "�Debito y Credito no coinciden! �Continua?", If( cPaisLoc == "MEX", "iCargo y Abono no coinciden! �Continua?", If( cPaisLoc == "PTG", "�Debito y Credito no coinciden! �Continua?", "�Debito y Credito diferentes! �Continua?" ) ) ) ) )
	#define STR0011 "�Atencion!"
	#define STR0012 "Descrip. de la entidad: "
	#define STR0013 "Sublote"
	#define STR0014 "Correlativo"
	#define STR0015 "Totales del lote y documento (otras monedas)"
	#define STR0016 "Totales"
	#define STR0017 "Desea realmente borrar todas las lineas ?"
	#define STR0018 "El Sublote no puede quedar en blanco. Por Favor rellenelo."
	#define STR0019 "Inconsistencia Anterior"
	#define STR0020 "Proxima Inconsistencia"
	#define STR0021 "Localizar"
	#define STR0022 "Ninguna inconsistencia "
	#define STR0023 "abajo"
	#define STR0024 "arriba"
	#define STR0025 "Nueva"
	#define STR0026 "Anterior"
	#define STR0027 "Proxima"
	#define STR0028 "Anula"
	#define STR0029 "No se encontro ningun asiento a continuacion"
	#define STR0030 "Igual a"
	#define STR0031 "Diferente de"
	#define STR0032 "Menor que"
	#define STR0033 "Menor o igual a"
	#define STR0034 "Mayor que"
	#define STR0035 "Mayor o igual a"
	#define STR0036 "Contiene la expresion"
	#define STR0037 "No contiene"
	#define STR0038 "Esta contenido en"
	#define STR0039 "No esta contenido en"
	#define STR0040 "Campo:"
	#define STR0041 "Operador:"
	#define STR0042 "Expresion:"
	#define STR0043 "Filtro:"
	#define STR0044 "&Adiciona"
	#define STR0045 "&Limpia Filtro"
	#define STR0046 " Y "
	#define STR0047 " O "
	#define STR0048 "Localizar Anterior"
	#define STR0049 "Localizar Proximo"
	#define STR0050 "Pr�xima"
	#define STR0051 "Replicar el contenido de campo posicionado"
	#define STR0052 "Replicar"
	#define STR0053 "Documento"
	#define STR0054 "Asientos"
	#define STR0055 "Recalculando totales..."
	#define STR0056 "Rec.Totales"
	#define STR0057 "�Para encerrar esta opcion es necesario confirmar o borrar la(s) linea(s) de asiento(s) contable(s)!"
	#define STR0058 "Linea"
	#define STR0059 "Opcion de grabacion"
	#define STR0060 "�Desea grabar como asiento previo?"
	#define STR0061 'La rutina utilizada no es compatible con la rutina actual de vinculo.'
	#define STR0062 'El metodo antiguo de verificacion del vinculo se acciono.'
	#define STR0063 'Por favor, �verifique la posibilidad de actualizar el entorno SIGACTB!'
	#define STR0064 'La rutina utilizada no esta '
	#define STR0065 'compatible con la rutina actual.'
	#define STR0066 'Por favor, actualice el entorno '
	#define STR0067 "La conversion de la moneda resultara en valor fuera del rango de representacion numerica."
	#define STR0068 "Historial"
	#define STR0069 "Ente"
	#define STR0070 " no esta rellenada de acuerdo con el tipo del asiento."
	#define STR0071 "Creando temporario de procesamiento "
	#define STR0072 "Aguarde, archivo en uso por otro usuario "
	#define STR0073 "CTBA105 | Error en la creacion del archivo de trabajo."
	#define STR0074 "No es posible generar asiento previo debido al parametro MV_PRELAN, tambi�n no es posible corregir las inconsistencias debido al parametro MV_ALTLCTO. Verifique la configuracion de los parametros."
	#define STR0075 "Para asiento do tipo debito, no rellenar campos de credito."
	#define STR0076 "Para asientos de tipo cr�dito, no rellenar campos de debito."
	#define STR0077 "Tipo de Saldo invalido"
	#define STR0078 'Seleccionar Monedas'
	#define STR0079 '�Desea seleccionar las monedas en las que se presentaran los valores? Si hace clic en No, se mostrara solo la moneda estandar.'
	#define STR0080 'Si'
	#define STR0081 'No'
	#define STR0082 'Asiento Contable'
	#define STR0083 'Impresion de Contabilizacion Online'
	#define STR0084 'Encabezado'
	#define STR0085 'Asientos'
	#define STR0086 'Imprimir'
	#define STR0087 '(DEB)'
	#define STR0088 '(CRED)'
	#define STR0089 "A conta cont�bil d�bito est� configurada para n�o permitir a gera��o de varia��o cambial. Verifique o cadastro da conta cont�bil ou o valor informado no campo "
	#define STR0090 "A conta cont�bil cr�dito est� configurada para n�o permitir a gera��o de varia��o cambial. Verifique o cadastro da conta cont�bil ou o valor informado no campo "
	#define STR0091 "Filial"
#else
	#ifdef ENGLISH
		#define STR0001 "Accounting Entries"
		#define STR0002 "Date"
		#define STR0003 "Lot"
		#define STR0004 "Doc"
		#define STR0005 "Selecting records..."
		#define STR0006 "Total Entered: "
		#define STR0007 "Total Typed: "
		#define STR0008 "Total Debit: "
		#define STR0009 "Total Credit: "
		#define STR0010 "Debit and Credit do not match!! Continue?"
		#define STR0011 "Attention!!"
		#define STR0012 "Entity Description: "
		#define STR0013 "Sub-Lot"
		#define STR0014 "Correlative"
		#define STR0015 "Lot and document total (other currencies)"
		#define STR0016 "Total"
		#define STR0017 "Do you really want to delete all the rows ?"
		#define STR0018 "Sublot cannot be blank. Please, fill it out.          "
		#define STR0019 "Previous inconsistency "
		#define STR0020 "Next inconsistency    "
		#define STR0021 "Localize "
		#define STR0022 "No inconsistency     "
		#define STR0023 "below "
		#define STR0024 "above"
		#define STR0025 "New "
		#define STR0026 "Previous"
		#define STR0027 "Next   "
		#define STR0028 "Cancel "
		#define STR0029 "No entries found below             "
		#define STR0030 "Equal to"
		#define STR0031 "Different from"
		#define STR0032 "Lower than"
		#define STR0033 "Lower than or Equal to"
		#define STR0034 "Higher than"
		#define STR0035 "Higher than or Equal to"
		#define STR0036 "With the expression"
		#define STR0037 "Does not have"
		#define STR0038 "Is comprised in"
		#define STR0039 "Is not comprised in"
		#define STR0040 "Field:"
		#define STR0041 "Operator:"
		#define STR0042 "Expression"
		#define STR0043 "Filter:"
		#define STR0044 "&Add     "
		#define STR0045 "&Clean Filter"
		#define STR0046 "AND"
		#define STR0047 " OR "
		#define STR0048 "Find previous one "
		#define STR0049 "Find next one    "
		#define STR0050 "Next "
		#define STR0051 "Duplicate positioned field content "
		#define STR0052 "Duplicate"
		#define STR0053 "Document "
		#define STR0054 "Entries "
		#define STR0055 "Recalculating totals..."
		#define STR0056 "Rec.Totals"
		#define STR0057 "To finish this option, confirm or delet the line(s) of the accounting entry(ies)! "
		#define STR0058 "Line"
		#define STR0059 "Saving option"
		#define STR0060 "Do you want to save it as pre-release?"
		#define STR0061 'The routine used is not compatible with current binding routine.'
		#define STR0062 'The old method to check binding was used.'
		#define STR0063 'Check the possibility of updating SIGACTB module!'
		#define STR0064 'The routine used is'
		#define STR0065 'not compatible with current routine.'
		#define STR0066 'Update the module.'
		#define STR0067 "Currency conversion implies in value outside the numerical representation range."
		#define STR0068 "History"
		#define STR0069 "Entity"
		#define STR0070 " is not completed according to the type of entry."
		#define STR0071 "Creating temporary processing "
		#define STR0072 "Wait, file being used by another user "
		#define STR0073 "CTBA105 | Error while creating work file."
		#define STR0074 "Unable to generate Pre-Entry due to parameter MV_PRELAN; also unable to fix the inconsistencies due to parameter MV_ALTLCTO. Check parameter configuration."
		#define STR0075 "For debit type entries, do not complete credit fields."
		#define STR0076 "For credit type entries, do not complete debit fields."
		#define STR0077 "Invalid balance type"
		#define STR0078 'Select Currencies'
		#define STR0079 'Select currencies that are displayed in values? If No, only standard currency is displayed.'
		#define STR0080 'Yes'
		#define STR0081 'No'
		#define STR0082 'Accounting entry'
		#define STR0083 'Online Accounting Printing'
		#define STR0084 'Header'
		#define STR0085 'Entries'
		#define STR0086 'Print'
		#define STR0087 '(DEB)'
		#define STR0088 '(CRED)'
		#define STR0089 "Debit ledger account is set, so that you cannot generate exchange variation. Check the ledger account register or the value entered in the field "
		#define STR0090 "Credit ledger account is set, so that you cannot generate exchange variation. Check ledger account register of value indicated in the field "
		#define STR0091 "Branch"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Lan�amentos Contabil�sticos", "Lancamentos Contabeis" )
		#define STR0002 "Data"
		#define STR0003 "Lote"
		#define STR0004 "Doc"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando registros..." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Total digitado: ", "Total Informado: " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Total digitado: ", "Total Digitado: " )
		#define STR0008 If( cPaisLoc $ "ANG|EQU|HAI", "Total D�bito: ", If( cPaisLoc $ "MEX|PTG", "Total de d�bito: ", "Total Debito: " ) )
		#define STR0009 If( cPaisLoc $ "ANG|EQU|HAI", "Total Cr�dito: ", If( cPaisLoc $ "MEX|PTG", "Total de cr�dito: ", "Total Credito: " ) )
		#define STR0010 If( cPaisLoc $ "ANG|EQU|HAI", "D�bito e Cr�dito n�o conferem! Prossegue?", If( cPaisLoc $ "MEX|PTG", "D�bito E Cr�dito N�o Coincidem!! Prosseguir?", "Debito e Credito nao Conferem!! Prossegue?" ) )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Aten��o!!", "Atencao!!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Descri��o da entidade: ", "Descricao da Entidade: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Sub-lote", "Sub-Lote" )
		#define STR0014 "Correlativo"
		#define STR0015 "Totais do lote e documento (outras moedas)"
		#define STR0016 "Totais"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Deseja realmente apagar todas as linhas ?", "Deseja realmente deletar todas as linhas ?" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "O sublote n�o pode ficar em branco. � favor preench�-lo.", "O Sublote nao pode ficar em branco. Favor preenche-lo." )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", 'INconsist�ncia Anterior', "Inconsistencia Anterior" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", 'PR�xima Inconsist�ncia', "Proxima Inconsistencia" )
		#define STR0021 "Localizar"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Nenhuma inconsist�ncia ", "Nenhuma inconsistencia " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Abaixo", "abaixo" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Acima", "acima" )
		#define STR0025 "Nova"
		#define STR0026 "Anterior"
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Pr�xima", "Proxima" )
		#define STR0028 "Cancela"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Nenhum lan�amento encontrado abaixo", "Nenhum lancamento encontrado abaixo" )
		#define STR0030 "Igual a"
		#define STR0031 "Diferente de"
		#define STR0032 "Menor que"
		#define STR0033 "Menor ou igual a"
		#define STR0034 "Maior que"
		#define STR0035 "Maior ou igual a"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Cont�m a express�o", "Contem a expressao" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "N�o cont�m", "Nao contem" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Est� contido em", "Esta contido em" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "N�o est� contido em", "Nao esta contido em" )
		#define STR0040 "Campo:"
		#define STR0041 "Operador:"
		#define STR0042 If( cPaisLoc $ "ANG|PTG", 'EXpressao:', "Expressao:" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", 'FIltro:', "Filtro:" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", '&Adiciona', "&Adiciona" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", '&Limpa Filtro', "&Limpa Filtro" )
		#define STR0046 " E "
		#define STR0047 If( cPaisLoc $ "ANG|PTG", " ou ", " OU " )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", 'LOcalizar Anterior', "Localizar Anterior" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Localizar Pr�ximo", "Localizar Proximo" )
		#define STR0050 "Pr�xima"
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Replicar o conte�do do campo posicionado", "Replicar o conteudo do campo posicionado" )
		#define STR0052 "Replicar"
		#define STR0053 "Documento"
		#define STR0054 If( cPaisLoc $ "ANG|PTG", "Movimentos", "Lan�amentos" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", "A recalcular totais...", "Recalculando totais..." )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", "Rec.totais", "Rec.Totais" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Para encerrar esta op��o � necess�rio confirmar ou excluir a(s) linha(s) de movimento(s) contabil�stica(s)!", "Para encerrar essa opcao � necess�rio confirmar ou excluir a(s) linha(s) de lan�amento(s) cont�bil!" )
		#define STR0058 "Linha"
		#define STR0059 If( cPaisLoc $ "ANG|PTG", "Op��o de grava��o", "Opcao de gravacao" )
		#define STR0060 If( cPaisLoc $ "ANG|PTG", "Deseja gravar como pr�-lan�amento?", "Deseja gravar como pre-lancamento?" )
		#define STR0061 If( cPaisLoc $ "ANG|PTG", 'O procedimento utilizado est� incompat�vel com o procedimento actual de amarra��o.', 'A rotina utilizada est� incompativel com a rotina atual de amarra��o.' )
		#define STR0062 If( cPaisLoc $ "ANG|PTG", 'O m�todo antigo de verifica��o da amarra��o foi accionado.', 'O metodo antigo de verifica��o da amarra��o foi acionado.' )
		#define STR0063 If( cPaisLoc $ "ANG|PTG", 'Por favor, verifique a possibilidade de actualizar o ambiente SIGACTB.', 'Favor verificar a possibilidade de atualizar o ambiente SIGACTB!' )
		#define STR0064 If( cPaisLoc $ "ANG|PTG", 'O procedimento utilizado est�', 'A rotina utilizada est�' )
		#define STR0065 If( cPaisLoc $ "ANG|PTG", 'incompat�vel com o procedimento actual.', 'incompativel com a rotina atual.' )
		#define STR0066 If( cPaisLoc $ "ANG|PTG", 'Por favor, actualize o ambiente', 'Favor atualizar o ambiente' )
		#define STR0067 "A convers�o da moeda implicar� em valor fora da faixa de representa��o num�rica."
		#define STR0068 "Hist�rico"
		#define STR0069 "Entidade"
		#define STR0070 If( cPaisLoc $ "ANG|PTG", " n�o est� preenchida de acordo com o tipo do lan�amento.", " nao esta preenchida de acordo com o tipo do lan�amento." )
		#define STR0071 If( cPaisLoc $ "ANG|PTG", "A criar tempor�rio de processamento ", "Criando temporario de processamento " )
		#define STR0072 If( cPaisLoc $ "ANG|PTG", "Aguarde, ficheiro em uso por outro utilizador ", "Aguarde, arquivo em uso por outro usu�rio " )
		#define STR0073 If( cPaisLoc $ "ANG|PTG", "CTBA105 | Erro na cria��o do ficheiro de trabalho.", "CTBA105 | Erro na cria��o do arquivo de trabalho." )
		#define STR0074 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel gerar Pr�-lan�amento devido ao par�metro MV_PRELAN; tamb�m n�o � poss�vel corrigir as inconsist�ncias devido ao par�metro MV_ALTLCTO. Verifique a configura��o dos par�metros.", "N�o � poss�vel gerar Pr�-Lan�amento devido ao par�metro MV_PRELAN, tamb�m n�o � poss�vel corrigir as inconsist�ncias devido ao par�metro MV_ALTLCTO. Verifique a configura��o dos par�metros." )
		#define STR0075 "Para lan�amentos do tipo d�bito, n�o preencher campos de cr�dito."
		#define STR0076 "Para lan�amentos do tipo cr�dito, n�o preencher campos de d�bito."
		#define STR0077 "Tipo de Saldo inv�lido"
		#define STR0078 'Selecionar Moedas'
		#define STR0079 'Deseja selecionar as moedas em que ser�o apresentados os valores? Caso clique em N�o, ser� exibida apenas a moeda padr�o.'
		#define STR0080 'Sim'
		#define STR0081 'N�o'
		#define STR0082 'lan�amento Cont�bil'
		#define STR0083 'Impress�o de Contabiliza��o Online'
		#define STR0084 'Cabe�alho'
		#define STR0085 'Lan�amentos'
		#define STR0086 'Imprimir'
		#define STR0087 '(DEB)'
		#define STR0088 '(CRED)'
		#define STR0089 "A conta cont�bil d�bito est� configurada para n�o permitir a gera��o de varia��o cambial. Verifique o cadastro da conta cont�bil ou o valor informado no campo "
		#define STR0090 "A conta cont�bil cr�dito est� configurada para n�o permitir a gera��o de varia��o cambial. Verifique o cadastro da conta cont�bil ou o valor informado no campo "
		#define STR0091 "Filial"
	#endif
#endif
