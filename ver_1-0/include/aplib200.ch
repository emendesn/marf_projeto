#ifdef SPANISH
	#define STR0001 "Sucursal"
	#define STR0002 "La utilizacion del Alias "
	#define STR0003 " solo se permite en archivos de "
	#define STR0004 "trabajo, que no usan ChkFile para apertura."
	#define STR0005 "Nombre de tabla: "
	#define STR0006 " es invalido con Integridad referencial vinculada"
	#define STR0007 "La tabla "
	#define STR0008 " ya esta siendo creada por otro usuario"
	#define STR0009 "El indice unico "
	#define STR0010 " lo esta creando otro usuario, intente nuevamente."
	#define STR0011 "Otro usuario esta creando el indice "
	#define STR0012 "Problema en la clave indice: "
	#define STR0013 "Estructura ausente en el SX3"
	#define STR0014 "No existe indice para ese alias en el SINDEX"
	#define STR0015 "Imposible borrar el archivo de indice"
	#define STR0016 'ATENCION : Este entorno solicita una base de datos homologada.'
	#define STR0017 'El uso de CTREE LOCAL para base de dados principal no se homologa por Microsiga.'
	#define STR0018 'ENTORNO NO HOMOLOGADO'
	#define STR0019 'Microsiga no homologa el uso de ADS LOCAL para base de datos principal.'
	#define STR0020 "Otra estacion esta creando la estructura de la tabla ###, ¿desea esperar?"
#else
	#ifdef ENGLISH
		#define STR0001 "Branch"
		#define STR0002 "The Alias uasage is   "
		#define STR0003 " is only allowed for the working "
		#define STR0004 "files, which do not use the ChkFile during opening."
		#define STR0005 "The new table:   "
		#define STR0006 " is invalid to the linked referential Integrity"
		#define STR0007 "The table"
		#define STR0008 " is already in creation by another user"
		#define STR0009 "The only index "
		#define STR0010 " is in creation by another user, please try again.  "
		#define STR0011 "There is another user creating the index"
		#define STR0012 "Problem with index key:    "
		#define STR0013 "Structure not present in SX3 "
		#define STR0014 "There is no index for this alias in SINDEX"
		#define STR0015 "It is impossible to remove the file from index"
		#define STR0016 'WARNING: This environment requires a CTREE SERVER database.        '
		#define STR0017 'Theuse of CTREE LOCAL for the main database has not been homologated by Microsiga.'
		#define STR0018 'ENVIRONMENT NOT HOMOLOGATED'
		#define STR0019 'Use of LOCAL ADS for the main database is not homologated by Microsiga.'
		#define STR0020 "Another station is creating the structure of table ###. Do you want to wait?"
	#else
		#define STR0001  "Filial"
		Static STR0002 := "A utilizacao do Alias "
		Static STR0003 := " so e permitida em arquivos de "
		Static STR0004 := "trabalho, que nao utilizam a ChkFile para abertura."
		#define STR0005  "Nome da tabela : "
		Static STR0006 := " e invalido com Integridade referencial ligada"
		#define STR0007  "A tabela "
		Static STR0008 := " ja esta sendo criada por outro usuario"
		Static STR0009 := "O indice unico "
		Static STR0010 := " esta em criacao por outro usuario, tente novamente."
		Static STR0011 := "Existe outro usuario criando o indice "
		Static STR0012 := "Problema na chave indice : "
		Static STR0013 := "Estrutura nao presente no SX3"
		Static STR0014 := "Nao existe indice para esse alias no SINDEX"
		Static STR0015 := "Impossivel remover o arquivo de indice"
		Static STR0016 := 'ATENÇÃO : Este ambiente requer um banco de dados homologado.'
		Static STR0017 := 'O uso de CTREE LOCAL para banco de dados principal não é homologado pela Microsiga.'
		Static STR0018 := 'AMBIENTE NÃO HOMOLOGADO'
		#define STR0019  'O uso de ADS LOCAL para banco de dados principal não é homologado pela Microsiga.'
		Static STR0020 := "Outra estação esta criando a estrutura da tabela ###, deseja aguardar?"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "A utilização do aliás "
			STR0003 := " só é permitida em ficheiros de "
			STR0004 := "Trabalho, que não utilizam a chkfile para abertura."
			STR0006 := " é inválido com integridade referencial ligada"
			STR0008 := " já está a ser criada por outro utilizador"
			STR0009 := "O índice único "
			STR0010 := " está em criação por outro utilizador, tente novamente."
			STR0011 := "Existe outro utilizador a criar o índice "
			STR0012 := "Problema na chave índice : "
			STR0013 := "Estrutura Não Presente No Sx3"
			STR0014 := "Não Existe índice Para Este Aliás No Sindex"
			STR0015 := "Impossível remover o ficheiro de índice"
			STR0016 := 'Atenção : este ambiente requer um banco de dados homologado.'
			STR0017 := 'A Utilização De Ctree Local Para Banco De Dados Principal Não é Homologado Pela Microsiga.'
			STR0018 := 'Ambiente Não Homologado'
			STR0020 := "Outra estação está criando a estrutura da tabela ###. Deseja aguardar?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
