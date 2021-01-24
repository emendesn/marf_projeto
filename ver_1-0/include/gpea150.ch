#ifdef SPANISH
	#define STR0001 "Confirma"
	#define STR0002 "Reescribe"
	#define STR0003 "Salir"
	#define STR0004 "Busqueda"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Listar"
	#define STR0009 "Borrar"
	#define STR0010 "Archivo de Parametros"
	#define STR0011 "Parametro "
	#define STR0012 "Busqueda"
	#define STR0013 "  CAMPO SINDICATO"
	#define STR0014 "  CAMPO ASIST. MEDICA"
	#define STR0015 "  CAMPO TICKET RESTAURANTE"
	#define STR0016 "  CAMPO SEGURO VIDA"
	#define STR0017 "  CAMPO ASIST. MEDICA (2)"
	#define STR0018 "Matricula : "
	#define STR0019 "N� Parametro"
	#define STR0020 "Concepto no registrado"
	#define STR0021 "Para digitar el valor se requiere crear el concepto y el tipo base para el identificador "
	#define STR0022 "La fecha que se esta modificando ya esta cerrada"
	#define STR0023 "Sucursal, mes y ano no pueden modificarse"
	#define STR0024 "Atencion "
	#define STR0025 "Digite el ano en el formato YYYY"
	#define STR0026 "Clave del Registro ya registrada"
	#define STR0027 "Sucursal y Ano no pueden modificarse para registros ya grabados."
	#define STR0028 "Sucursal invalida."
	#define STR0029 "Los contenidos de los campos 'Cierr. Activ.' y 'Fch. Cierr.' son incoherentes. Redefinalos."
	#define STR0030 "No se rellenaron los campos referentes al Programa de  Alimentacion del Trabajador - PAT , 'V. Hasta 5 Min.' y 'V. Sup. 5 Min.'."
	#define STR0031 "Se informo que la empresa no participa del Programa de  Alimentacion del Trabajador - PAT, pero al menos se relleno uno de los campos referentes a este programa."
	#define STR0032 "�Cuando Ano informado, Mes no puede estar en blanco!"
	#define STR0033 "�Cuando Mes informado, Ano no puede estar en blanco!"
	#define STR0034 "Atencion"
	#define STR0035 "Antes de proseguir, es necesario ejecutar los procedimientos del boletin tecnico - Actualizacion para el FAP. "
	#define STR0036 "Ok"
	#define STR0037 "Antes de proseguir, es necesario ejecutar la actualizacion '80-Ajustes en el diccionario - Uruguay', disponible para el entorno SIGAGPE en el compatibilizador RHUPDMOD."
	#define STR0038 "Parametro "
	#define STR0039 "Se imprimira de acuerdo con los parametros solicitados por el"
	#define STR0040 "usuario."
	#define STR0041 "A rayas"
	#define STR0042 "Administracion"
	#define STR0043 "IMPRESION DE PARAMETROS - "
	#define STR0044 " No se permite seleccionar esta Sucursal debido a una restriccion de acceso"
	#define STR0045 "Fecha del bloqueo no debe ser anterior a la fecha del reajuste."
	#define STR0046 "El campo 'Id.Cntb.Sub.' solo podra tener contenido si el campo 'Opt. Simples' es igual a 1"
	#define STR0047 "00 - Sin Informacion (Solo para Empresas sin Vinculos)"
	#define STR0048 "01 - El establecimiento no adopto sistema de control de reloj porque en ningun mes del ano-base tenia mas de 10 trabajadores de CLT activos"
	#define STR0049 "02 - El establecimiento adopto el sistema manual"
	#define STR0050 "03 - El establecimiento adopto el sistema mecanico"
	#define STR0051 "04 - El establecimiento adopto el Sistema de Reloj Electronico - SREP (Resolucion 1.510/2009)"
	#define STR0052 "05 - El establecimiento adopto sistema no electronico alternativo previsto en el art.1� de la Resolucion 373/2011"
	#define STR0053 "06 - El establecimiento adopto sistema electronico alternativo previsto en la Resolucion 373/2011"
	#define STR0054 "Tipo de Reloj Electronico"
	#define STR0055 "Efectue primero el registro de la Fecha informando los campos Mes y Ano."
#else
	#ifdef ENGLISH
		#define STR0001 "OK     "
		#define STR0002 "Retype "
		#define STR0003 "Quit   "
		#define STR0004 "Search "
		#define STR0005 "View   "
		#define STR0006 "Insert "
		#define STR0007 "Edit   "
		#define STR0008 "List   "
		#define STR0009 "Delete "
		#define STR0010 "Parameters File"
		#define STR0011 "Parameter "
		#define STR0012 "Search  "
		#define STR0013 "  UNIONS FIELD    "
		#define STR0014 "  HEALTH INS.FIELD"
		#define STR0015 "  MEAL TICKET FIELD "
		#define STR0016 "  LIFE INSUR. FIELD"
		#define STR0017 "  HEALTH INS.FIELD (2)"
		#define STR0018 "Registration:"
		#define STR0019 "Parameter No."
		#define STR0020 "Funds Not Registered"
		#define STR0021 "Before entering the value, you must create the fund (base type) to the Identifier"
		#define STR0022 "The Date you are trying to modify is already closed"
		#define STR0023 "Branch, Month and Year cannot be modified"
		#define STR0024 "Attention"
		#define STR0025 "Enter the Year (YYYY)"
		#define STR0026 "Register Key already Recorded"
		#define STR0027 "Branch and Year cannot be altered in records already saved."
		#define STR0028 "Invalid branch."
		#define STR0029 "Contents of fields 'Close Active.' and 'Clos. Date' are inconsistent. Redefine them."
		#define STR0030 "The fields relating to the Worker Feeding Program - PAT, 'V. upto 5 min,' and 'V. more than 5 Min.', were not filled in."
		#define STR0031 "It was informed that the company does not participate in the Worker Feeding Program - PAT, but at least one of the fields relating to this program was filled."
		#define STR0032 "When the year is entered, Month can not be blank!"
		#define STR0033 "When the month is entered, Year can not be blank!"
		#define STR0034 "Attention"
		#define STR0035 "Before continuing, you must follow the procedures of technical newsletter - Update for FAP. "
		#define STR0036 "OK"
		#define STR0037 "Before continuing, you must run the update '80-Adjustments in dictionary - Uruguay,' available for SIGAGPE module in the compatibility program RHUPDMOD."
		#define STR0038 "Parameter "
		#define STR0039 "It will be� printed according to parameters requested by the"
		#define STR0040 "user."
		#define STR0041 "Z-form"
		#define STR0042 "Administration"
		#define STR0043 "PRINTING PARAMETERS - "
		#define STR0044 " This Branch cannot be selected due to restriction of access"
		#define STR0045 "Blockage Date should not be prior to the Adjust Date."
		#define STR0046 "The field Sub.Cntb.Id. can only have content if field Simples Opt. is equal to 1"
		#define STR0047 "00 - No Information (Only for Companies with no Relationship)"
		#define STR0048 "01 - Site has not adopted attendance control system, as in any month of the year base has 10 CLT active workers"
		#define STR0049 "02 - Site adopted manual system"
		#define STR0050 "03 - Site adopted mechanical system"
		#define STR0051 "04 - Site adopted Electronic Attendance Control System - SREP (Decree 1.510/2009)"
		#define STR0052 "05 - Site adopted alternative not-electronic system estimated in art. 1 from Decree 373/2011"
		#define STR0053 "06 - Site adopted alternative not-electronic system estimated in Decree 373/2011"
		#define STR0054 "Electronic Attendance Type"
		#define STR0055 "First register Date entering the fields Month and Year."
	#else
		#define STR0001 "Confirma"
		#define STR0002 "Redigita"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0004 "Pesquisa"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Listar"
		#define STR0009 "Excluir"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Registo De Par�metros", "Cadastro de Par�metros" )
		#define STR0011 "Par�metro "
		#define STR0012 "Pesquisa"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "  Campo IRCT", "  CAMPO SINDICATO" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "  Campo Ass. M�dica", "  CAMPO ASS. M�DICA" )
		#define STR0015 "  CAMPO VALE REFEI��O"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "  Campo Seguro Vida", "  CAMPO SEGURO VIDA" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "  campo ass. m�dica (2)", "  CAMPO ASS. M�DICA (2)" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Registo : ", "Matricula : " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Nr. Par�metro", "N� Parametro" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Valor N�o Registado", "Verba Nao Cadastrada" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Para indicar valor ser� necess�rio criar valor, tipo base, para o identificador ", "Para informar valor sera necessario criar verba, tipo base, para o Identificador " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "A data que est� a ser alterada j� est� fechada", "A Data que esta sendo alterada ja esta fechada" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Filial, m�s e ano n�o podem ser alterados", "Filial, Mes e Ano nao podem ser alterados" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Aten��o ", "Atencao " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Introduza Ano No Formato Aaaa", "Informe Ano no formato YYYY" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Chave Do Registo J� Registada", "Chave do Registro ja Cadastrada" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Filial e ano n�o podem ser alterados para registos j� gravados.", "Filial e Ano n�o podem ser alterados para registros j� gravados." )
		#define STR0028 "Filial inv�lida."
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Os Conte�dos Dos Campos 'encerr.activ.' E 'dat.encerr.' Est�o Incoerentes. Por Favor Redefina-os.", "Os conte�dos dos campos 'Encerr.Ativ.' e 'Dat.Encerr.' est�o incoerentes. Redefina-os." )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Os campos referentes ao programa de  alimenta��o do trabalhador - pat , 'v.ate 5 min.' e 'v.aci.5 min.', n�o foram preenchidos.", "Os campos referentes ao Programa de  Alimenta��o do Trabalhador - PAT , 'V.Ate 5 Min.' e 'V.Aci.5 Min.', n�o foram preenchidos." )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Foi indicado que a empresa n�o participa no programa de  alimenta��o do trabalhador - pat, mas pelo menos um dos campos referentes a esse programa foi preenchido.", "Foi informado que a empresa n�o participa do Programa de  Alimenta��o do Trabalhador - PAT, mas pelo menos um dos campos referentes a esse programa foi preenchido." )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Quando se informa o campo Ano, o M�s n�o pode ficar em branco!", "Quando Ano informado, Mes nao pode ficar em branco!" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Quando se informa M�s, o Ano n�o pode ficar em branco!", "Quando Mes informado, Ano nao pode ficar em branco!" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Atencao" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Antes de prosseguir, � necess�rio executar os procedimentos do boletim t�cnico - Actualiza��o para o FAP. ", "Antes de prosseguir, e necessario executar os procedimentos do boletim tecnico - Atualizacao para o FAP. " )
		#define STR0036 "Ok"
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Antes de prosseguir, � necess�rio executar a actualiza��o '80-Ajustes no dicion�rio - Uruguai', dispon�vel para o m�dulo SIGAGPE no compatibilizador RHUPDMOD.", "Antes de prosseguir, � necess�rio executar a atualiza��o '80-Ajustes no dicion�rio - Uruguai', dispon�vel para o m�dulo SIGAGPE no compatibilizador RHUPDMOD." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Par�metro ", "Parametro " )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Ser�impresso de acordo com os par�metros solicitados pelo", "Ser�impresso de acordo com os Parametros solicitados pelo" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "utilizador.", "usu�rio." )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0042 "Administra��o"
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "IMPRESS�O DE PAR�METROS - ", "IMPRESSAO DE PARAMETROS - " )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", " N�o � permitido seleccionar essa Filial devido a uma restric��o de acesso", " N�o � permitido selecionar essa Filial devido restri��o de acesso" )
		#define STR0045 "Data do Bloqueio n�o pode ser anterior � Data do Reajuste."
		#define STR0046 "O campo 'Id.Cntb.Sub.' s� poder� ter conte�do se o campo 'Opt. Simples' for igual a 1"
		#define STR0047 "00 - Sem Informa��o (Somente para Empresas sem V�nculos)"
		#define STR0048 "01 - Estabelecimento n�o adotou sistema de controle de ponto porque em nenhum m�s do ano-base possu�a mais de 10 trabalhadores celetistas ativos"
		#define STR0049 "02 - Estabelecimento adotou sistema manual"
		#define STR0050 "03 - Estabelecimento adotou sistema mec�nico"
		#define STR0051 "04 - Estabelecimento adotou Sistema de Registro Eletr�nico de Ponto - SREP (Portaria 1.510/2009)"
		#define STR0052 "05 - Estabelecimento adotou sistema n�o eletr�nico alternativo previsto no art.1� da Portaria 373/2011"
		#define STR0053 "06 - Estabelecimento adotou sistema eletr�nico alternativo previsto na Portaria 373/2011"
		#define STR0054 "Tipo de Ponto Eletronico"
		#define STR0055 "Efetue primeiro o registro da Data informando os campos Mes e Ano."
	#endif
#endif
