#ifdef SPANISH
	#define STR0001 "Update UPDCOM30"
	#define STR0002 "Creacion de campo F1_ORIGEM para determinar origen del Documento de Entrada."
	#define STR0003 "Proseguimiento del ajuste de cada tabla:"
	#define STR0004 "Atencion: para que pueda realizarse el ajuste, �NINGUN usuario puede estar utilizando el sistema!"
	#define STR0005 "La rutina de actualizacion creara el campo F1_ORIGEM que se utilizara inicialmente para integracion con SIGAGFE, pero posteriormente podra ser utilizado por otras rutinas/modulos."
	#define STR0006 "Antes de que se inicie la actualizacion, usted debe leer y aceptar los terminos y las condiciones a continuacion. Despues de aceptarlos, puede continuar con la actualizacion."
	#define STR0007 "ATENCION:"
	#define STR0008 "Este update tiene como objetivo crear el campo F1_ORIGEM."
	#define STR0009 "Con ese nuevo campo creado en el diccionario, sera posible determinar cual es la rutina generadora del Documento de Entrada."
	#define STR0010 "�SIGAMAT.EMP con problemas!"
	#define STR0011 "SIGACOM - Update"
	#define STR0012 "Anular"
	#define STR0013 "Avanzar"
	#define STR0014 "&Finalizar"
	#define STR0015 "�Bienvenido!"
	#define STR0016 "�Lea atentamente!"
	#define STR0017 "Si, lei y acepto el termino mencionado anteriormente."
	#define STR0018 "Codigo"
	#define STR0019 "Empresa"
	#define STR0020 "Actualizaciones Realizadas:"
	#define STR0021 "Ejecucion del ajuste"
	#define STR0022 "�Ajuste finalizado!"
	#define STR0023 "�Ajuste de las tablas finalizado!"
	#define STR0024 "Seleccione la empresa"
	#define STR0025 "&Grabar Log"
	#define STR0026 "�SIGAMAT.EMP en uso!"
	#define STR0027 "Ejecutando compatibilizador para la empresa: "
	#define STR0028 "Inicializando entorno para la empresa "
	#define STR0029 "Espere..."
	#define STR0030 ">> Ajuste iniciado el "
	#define STR0031 ", a las "
	#define STR0032 "LOG del update "
	#define STR0033 "UPDCOM30"
	#define STR0034 "Empresa: "
	#define STR0035 "Resultado final de ejecucion del UPD:"
	#define STR0036 "Actualizando el archivo "
	#define STR0037 "Actualizando estructura del banco de datos"
	#define STR0038 "Se actualizo la estructura fisica de los archivos:"
	#define STR0039 "Actualizando estructura fisica del archivo "
	#define STR0040 "Error al actualizar la estructura fisica del archivo "
	#define STR0041 "Ajuste realizado en las tablas de la sucursal"
	#define STR0042 "Espere... Finalizando entorno de la empresa "
	#define STR0043 "Archivos de Log (*.LOG) |*.log|"
	#define STR0044 "Este LOG se grabo automaticamente como "
	#define STR0045 " en el directorio de los SXs."
	#define STR0046 "La extension .LOG se agrego al archivo, que se grabo del directorio elegido ("
	#define STR0047 "Actualizando la estructura del archivo "
	#define STR0048 "Actualizada la estructura del archivo: "
#else
	#ifdef ENGLISH
		#define STR0001 "Update UPDCOM30"
		#define STR0002 "Creation of the field F1_ORIGEM to define the Inflow Document origin."
		#define STR0003 "Progress of each table adjustment:"
		#define STR0004 "Attention: To make the adjustment, NO user can use the system!"
		#define STR0005 "The update routine will create the field F1_ORIGEM that will be used initially for the integration with SIGAGFE, but later it can be used by other routines/modules."
		#define STR0006 "Before starting the update, you must read and accept the following terms and conditions. Once you accept them, you can proceed with the update."
		#define STR0007 "WARNING:"
		#define STR0008 "This purpose of this update is to create field F1_ORIGEM."
		#define STR0009 "With this field created in the dictionary, it will be possible to define the routine generating the Inflow Document."
		#define STR0010 "SIGAMAT.EMP with problems!"
		#define STR0011 "SIGACOM - Update"
		#define STR0012 "Cancel"
		#define STR0013 "Next"
		#define STR0014 "&Finish"
		#define STR0015 "Welcome!"
		#define STR0016 "Read it carefully!"
		#define STR0017 "Yes, I have read and accepted the term above."
		#define STR0018 "Code"
		#define STR0019 "Company"
		#define STR0020 "Updates made:"
		#define STR0021 "Running adjustment"
		#define STR0022 "Adjustment completed!"
		#define STR0023 "Table adjustment completed!"
		#define STR0024 "Select company"
		#define STR0025 "&Save Log"
		#define STR0026 "SIGAMAT.EMP in use!"
		#define STR0027 "Running compatibility program for the company: "
		#define STR0028 "Starting environment for the company "
		#define STR0029 "Wait..."
		#define STR0030 ">> Adjustment started on "
		#define STR0031 ", at "
		#define STR0032 "Update LOG "
		#define STR0033 "UPDCOM30"
		#define STR0034 "Company: "
		#define STR0035 "Final result of UPD execution:"
		#define STR0036 "Updating file "
		#define STR0037 "Updating database structure"
		#define STR0038 "File physical structure updated:"
		#define STR0039 "Updating file physical structure "
		#define STR0040 "Failure to update file physical structure "
		#define STR0041 "Adjustment made in branch tables"
		#define STR0042 "Wait... Finishing Company Environment "
		#define STR0043 "Log files (*.LOG) |*.log|"
		#define STR0044 "This LOG was automatically saved as "
		#define STR0045 " in SXs directory."
		#define STR0046 "Extension .LOG was added to file which was saved from directory chosen ("
		#define STR0047 "Updating file structure "
		#define STR0048 "File structure updated: "
	#else
		#define STR0001 "Update UPDCOM30"
		#define STR0002 "Cria��o de campo F1_ORIGEM para determinar origem do Documento de Entrada."
		#define STR0003 "Andamento do ajuste de cada tabela:"
		#define STR0004 "Aten��o: para que o ajuste possa ser efetuado NENHUM usu�rio pode estar utilizando o sistema!"
		#define STR0005 "A rotina de atualiza��o ir� criar o campo F1_ORIGEM que ser� utilizado inicialmente para integra��o com SIGAGFE, por�m posteriormente poder� ser utilizado por outras rotinas/m�dulos."
		#define STR0006 "Antes de iniciar a atualiza��o, voc� deve ler e aceitar os termos e as condi��es a seguir. Ap�s aceit�-los, voc� pode prosseguir com a atualiza��o."
		#define STR0007 "ATEN��O:"
		#define STR0008 "Este update tem como objetivo criar o campo F1_ORIGEM."
		#define STR0009 "Com esse novo campo criado no dicion�rio, ser� poss�vel determinar qual a rotina geradora do Documento de Entrada."
		#define STR0010 "SIGAMAT.EMP com problemas!"
		#define STR0011 "SIGACOM - Update"
		#define STR0012 "Cancelar"
		#define STR0013 "Avancar"
		#define STR0014 "&Finalizar"
		#define STR0015 "Bem-Vindo!"
		#define STR0016 "Leia com atencao!"
		#define STR0017 "Sim, li e aceito o termo acima."
		#define STR0018 "C�digo"
		#define STR0019 "Empresa"
		#define STR0020 "Atualiza��es Realizadas:"
		#define STR0021 "Execucao do ajuste"
		#define STR0022 "Ajuste finalizado!"
		#define STR0023 "Ajuste das tabelas finalizado!"
		#define STR0024 "Selecione a empresa"
		#define STR0025 "&Salvar Log"
		#define STR0026 "SIGAMAT.EMP em uso!"
		#define STR0027 "Executando compatibilizador para a empresa: "
		#define STR0028 "Inicializando ambiente para a empresa "
		#define STR0029 "Aguarde..."
		#define STR0030 ">> Ajuste iniciado em "
		#define STR0031 ", as "
		#define STR0032 "LOG do update "
		#define STR0033 "UPDCOM30"
		#define STR0034 "Empresa: "
		#define STR0035 "Resultado final da execu��o do UPD:"
		#define STR0036 "Atualizando o arquivo "
		#define STR0037 "Atualizando estrutura do banco de dados"
		#define STR0038 "Atualizada a estrutura f�sica dos arquivos:"
		#define STR0039 "Atualizando estrutura f�sica do arquivo "
		#define STR0040 "Falha ao atualizar a estrutura f�sica do arquivo "
		#define STR0041 "Ajuste feito nas tabelas da filial"
		#define STR0042 "Aguarde... Finalizando Ambiente da Empresa "
		#define STR0043 "Arquivos de Log (*.LOG) |*.log|"
		#define STR0044 "Este LOG foi salvo automaticamente como "
		#define STR0045 " no diretorio dos SXs."
		#define STR0046 "A extencao '.LOG' foi adicionada ao arquivo, que foi salvo do diretorio escolhido ("
		#define STR0047 "Atualizando a estrutura do arquivo "
		#define STR0048 "Atualizada a estrutura do arquivo: "
	#endif
#endif