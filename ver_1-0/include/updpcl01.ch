#ifdef SPANISH
	#define STR0001 "¿Desea actualizar los campos de la tabla SL2 y SLR? ¡Esta rutina debe utilizarse en modo exclusivo ! ¡Haga un backup de la Base de Datos antes de la actualizacion para eventuales fallas de actualizacion !"
	#define STR0002 "¡Atencion!"
	#define STR0003 "Actualizando Base de Datos"
	#define STR0004 "Campo L2_SEGUM no se creo en la tabla SL2, por favor ejecutar los pasos definidos en el boletin tecnico Generacion de Titulos por Cobrar"
	#define STR0005 "Campo L2_SEGUM registrado"
	#define STR0006 "Campo L2_SEGUM registrado"
	#define STR0007 "Procesando"
	#define STR0008 "Espere, actualizando base de datos"
	#define STR0009 "Proceso finalizado"
	#define STR0010 "¡No fue posible la apertura de la tabla de empresas de forma exclusiva!"
#else
	#ifdef ENGLISH
		#define STR0001 "Do you want to update fields of table SL2 and SLR? This routine must be used in Exclusive Mode! Make a backup of the database before update, in case of any failures in the process!"
		#define STR0002 "Attention!"
		#define STR0003 "Updating database"
		#define STR0004 "When L2_SEGUM was not created in table SL2, please follow the steps defined in technical newsletter Generation of Receivable Bills."
		#define STR0005 "The field L2_SEGUM is already registered."
		#define STR0006 "The field LR_SEGUM is already registered."
		#define STR0007 "Processing"
		#define STR0008 "Wait, updating database"
		#define STR0009 "The process is finished."
		#define STR0010 "Table of companies could not be opened in exclusive mode!"
	#else
		Static STR0001 := "Deseja atualizar os campos da tabela SL2 e SLR? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup da Base de Dados antes da atualização para eventuais falhas de atualização !"
		Static STR0002 := "Atencao!"
		Static STR0003 := "Atualizando Base de Dados"
		Static STR0004 := "Campo L2_SEGUM nao foi criado na tabela SL2, favor executar os passos definidos no boletim tecnico Geração de Títulos a Receber"
		Static STR0005 := "Campo L2_SEGUM ja cadastrado"
		Static STR0006 := "Campo LR_SEGUM ja cadastrado"
		Static STR0007 := "Processando"
		Static STR0008 := "Aguarde, atualizando base de dados"
		#define STR0009  "Processo finalizado"
		Static STR0010 := "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Deseja actualizar os campos das tabelas SL2 e SLR? Esta rotina deverá ser utilizada em modo exclusivo! Faça um backup dos dicionários e da base de dados antes da actualização para eventuais falhas!"
			STR0002 := "Atenção!"
			STR0003 := "A Actualizar Base de Dados"
			STR0004 := "Campo L2_SEGUM nao foi criado na tabela SL2, favor executar os passos definidos no boletim técnico Geração de Títulos a Receber"
			STR0005 := "Campo L2_SEGUM já cadastrado"
			STR0006 := "Campo LR_SEGUM já cadastrado"
			STR0007 := "A Processar"
			STR0008 := "Aguarde, a actualizar base de dados"
			STR0010 := "Não foi possível a abertura da tabela de empresas de forma exclusiva!"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF

