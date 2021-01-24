#ifdef SPANISH
	#define STR0001 "Error creando Deposito"
	#define STR0002 "Atencion"
	#define STR0003 "Error Abriendo Deposito"
	#define STR0004 "Archivo "
	#define STR0005 " no existe."
	#define STR0006 "Error abriendo archivo: "
	#define STR0007 "Entrada "
	#define STR0008 " ya existe. �Regraba?"
	#define STR0009 "Error Creando archivo temporal."
	#define STR0010 "Error creando archivo: "
	#define STR0011 "No es posible incluir un bitmap mayor que 900 Kilobytes. Por favor escoja uno de menor tama�o."
	#define STR0012 "No es posible leer un bitmap mayor que 900 Kilobytes. Por favor utilice un bitmap con menor tama�o"
	#define STR0013 "El archivo elejido no es un Bitmap/Jpeg valido, o esta corrompido. Por favor, elija otro para insertar en el Deposito"
	#define STR0014 "Actualizando el repositorio de objetos. Espere..."
#else
	#ifdef ENGLISH
		#define STR0001 "Error Creating Repository"
		#define STR0002 "Attention"
		#define STR0003 "Error Opening Repository"
		#define STR0004 "File "
		#define STR0005 " does not exist."
		#define STR0006 "Error opening file: "
		#define STR0007 "Entry "
		#define STR0008 " already exists, Overwrite?"
		#define STR0009 "Error Creating temporary file."
		#define STR0010 "Error creating file: "
		#define STR0011 "Unable to insert bitmaps greater than 900 Kilobytes. Please select a smaller file."
		#define STR0012 "Unable to read bitmaps greater than 900 Kilobytes. Please use a smaller bitmap file"
		#define STR0013 "The choosen file isn�t a valid Bitmap/Jpeg, or it�s corrupted. Please choose another one to insert on the Repository"
		#define STR0014 "Updating object repository. wait..."
	#else
		Static STR0001 := "Erro Criando Reposit�rio"
		#define STR0002  "Aten��o"
		Static STR0003 := "Erro Abrindo Reposit�rio"
		Static STR0004 := "Arquivo "
		#define STR0005  " n�o existe."
		Static STR0006 := "Erro abrindo arquivo: "
		#define STR0007  "Entrada "
		Static STR0008 := " j� existe, Regrava?"
		Static STR0009 := "Erro Criando arquivo tempor�rio."
		Static STR0010 := "Erro criando arquivo: "
		Static STR0011 := "N�o � poss�vel incluir um bitmap maior que 900 Kilobytes. Por favor escolha um de menor tamanho."
		Static STR0012 := "N�o � poss�vel ler um bitmap maior que 900 Kilobytes. Por favor utilize um bitmap com menor tamanho"
		Static STR0013 := "O arquivo escolhido n�o � do tipo Bitmap/Jpeg, ou esta corrompido. Por favor escolha outro arquivo para inserir no reposit�rio"
		Static STR0014 := "Atualizando o reposit�rio de objetos. aguarde..."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Erro A Criar Reposit�rio"
			STR0003 := "Erro A Abrir Reposit�rio"
			STR0004 := "Ficheiro "
			STR0006 := "Erro a abrir ficheiro: "
			STR0008 := " J� Existe, Re-grava?"
			STR0009 := "Erro a criar ficheiro tempor�rio."
			STR0010 := "Erro a criar ficheiro: "
			STR0011 := "N�o � poss�vel incluir um bitmap maior que 900 kilobytes. por favor escolha um de menor tamanho."
			STR0012 := "N�o � poss�vel ler um bitmap maior que 900 kilobytes. por favor utilize um bitmap com menor tamanho"
			STR0013 := "O ficheiro escolhido n�o � do tipo bitmap/jpeg, ou est� corrompido. por favor escolha outro ficheiro para inserir no reposit�rio"
			STR0014 := "A actualizar o reposit�rio de objectos. Aguarde..."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
