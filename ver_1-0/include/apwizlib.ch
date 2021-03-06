#ifdef SPANISH
	#define STR0001 "Directorio de carga inicial no encontrado :"
	#define STR0002 "Paquete de Archivos HTTP no encontrado :"
	#define STR0003 "Data WareHouse"
	#define STR0004 "Balanced ScoreCard"
	#define STR0005 "Gestion Educativa"
	#define STR0006 "Terminal del Empleado ( RRHH ONLINE ) "
	#define STR0007 "Portal Protheus"
	#define STR0008 "Protheus 10 Web Services"
	#define STR0009 "WebPrint & WebSpool"
	#define STR0010 "Modulo WEBEX Makira"
	#define STR0011 "Gestion de Encuesta y Resultado"
	#define STR0012 "No fue posible crear el directorio"
	#define STR0013 "Falla al descomprimir el archivo"
	#define STR0014 "para el directorio"
	#define STR0015 "No fue posible crear archivo en el directorio"
	#define STR0016 "Espere ..."
	#define STR0017 "Actualizando Archivo Helps  "
	#define STR0018 "Probs en Archivo de Help--> "
	#define STR0019 "Este campo contiene caracteres invalidos. "
	#define STR0020 "No se permiten caracteres acentuados, espacios y caracteres especiales."
	#define STR0021 "Se aceptaran unicamente caracteres alfanumericos."
	#define STR0022 "S aceptaran tambien los siguientes caracteres : "
	#define STR0023 "Caracter invalido"
	#define STR0024 "Posicion"
	#define STR0025 "Archivo VACIO"
	#define STR0026 "Linea Invalida"
	#define STR0027 "Vacio"
	#define STR0028 "repetido"
	#define STR0029 "creado con suceso"
	#define STR0030 " Campos"
	#define STR0031 "Gestion de Acervos"
	#define STR0032 "Sistema de Gestion de Indicadores"
	#define STR0033 "Gestion de Capital Humano"
	#define STR0034 "Portal del Candidato"
#else
	#ifdef ENGLISH
		#define STR0001 "Initial load directory not found :"
		#define STR0002 "HTTP File Package not found :"
		#define STR0003 "Data WareHouse"
		#define STR0004 "Balanced ScoreCard"
		#define STR0005 "Educational Management"
		#define STR0006 "Employee Terminal ( HR ONLINE ) "
		#define STR0007 "Portal Protheus"
		#define STR0008 "Protheus 10 Web Services"
		#define STR0009 "WebPrint & WebSpool"
		#define STR0010 "Module WEBEX Makira"
		#define STR0011 "Search and Result Management"
		#define STR0012 "It was not possible to create the directory"
		#define STR0013 "Error during the file enclosure"
		#define STR0014 "to the directory"
		#define STR0015 "It was not possible to create a file in the directory"
		#define STR0016 "Wait..."
		#define STR0017 "Updating Help File"
		#define STR0018 "Probs in Help File -> "
		#define STR0019 "This field has invalid characters.      "
		#define STR0020 "Accent marks, spaces and special characters will not be accepted.        "
		#define STR0021 "Only the alphanumeric characters will be accepted."
		#define STR0022 "The following characters will also be accepted:"
		#define STR0023 "Invalid Character"
		#define STR0024 "Status "
		#define STR0025 "EMPTY File   "
		#define STR0026 "Invalid Row   "
		#define STR0027 "Empty"
		#define STR0028 "repeated"
		#define STR0029 "successfully created"
		#define STR0030 " Fileds"
		#define STR0031 "Heritage Management"
		#define STR0032 "Indicator Management System     "
		#define STR0033 "Human capital management"
		#define STR0034 "Candidate portal"
	#else
		Static STR0001 := "Diret�rio de carga inicial n�o encontrado :"
		Static STR0002 := "Pacote de Arquivos HTTP n�o encontrado :"
		Static STR0003 := "Data WareHouse"
		Static STR0004 := "Balanced ScoreCard"
		Static STR0005 := "Gest�o Educacional"
		Static STR0006 := "Terminal do Funcionario ( RH ONLINE ) "
		#define STR0007  "Portal Protheus"
		Static STR0008 := "Protheus 10 Web Services"
		Static STR0009 := "WebPrint & WebSpool"
		Static STR0010 := "M�dulo WEBEX Makira"
		Static STR0011 := "Gest�o de Pesquisa e Resultado"
		Static STR0012 := "N�o foi poss�vel criar o diret�rio"
		Static STR0013 := "Falha na descompacta��o do arquivo"
		Static STR0014 := "para o diret�rio"
		Static STR0015 := "N�o foi poss�vel criar arquivo no diret�rio"
		#define STR0016  "Aguarde..."
		Static STR0017 := "Atualizando Arquivo de Helps"
		Static STR0018 := "Probs no Arquivo de Help -> "
		#define STR0019  "Este campo cont�m caracteres inv�lidos. "
		#define STR0020  "N�o s�o permitidos caracteres acentuados, espa�os e caracteres especiais."
		Static STR0021 := "Ser�o aceitos apenas caracteres alfanum�ricos."
		Static STR0022 := "Ser�o aceitos tamb�m os seguintes caracteres : "
		#define STR0023  "Caracter inv�lido"
		#define STR0024  "Posi��o"
		Static STR0025 := "Arquivo VAZIO"
		#define STR0026  "Linha Inv�lida"
		#define STR0027  "Vazio"
		Static STR0028 := "repetido"
		Static STR0029 := "criado com sucesso"
		#define STR0030  " Campos"
		Static STR0031 := "Gest�o de Acervos"
		Static STR0032 := "Sistema de Gest�o de Indicadores"
		Static STR0033 := "Gest�o do Capital Humano"
		Static STR0034 := "Portal do Candidato"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Direct�rio de carga inicial n�o encontrado :"
			STR0002 := "Pacote de ficheiros http n�o encontrado :"
			STR0003 := "Armaz�m De Dados"
			STR0004 := "Balanced Scorecard"
			STR0005 := "Gest�o educacional"
			STR0006 := "Terminal do empregado ( rh online ) "
			STR0008 := "Protheus 10 Servi�os Web "
			STR0009 := "Webprint & Webspool"
			STR0010 := "M�dulo Webex Makira"
			STR0011 := "Gest�o De Pesquisa E Resultado"
			STR0012 := "N�o foi poss�vel criar o direct�rio"
			STR0013 := "Falha na descompactagem do ficheiro"
			STR0014 := "Para o direct�rio"
			STR0015 := "N�o foi poss�vel criar ficheiro no direct�rio"
			STR0017 := "A Actualizar Ficheiro De Ajudas"
			STR0018 := "Probs no ficheiro de ajuda -> "
			STR0021 := "Ser�o aceites apenas caracteres alfanum�ricos."
			STR0022 := "Ser�o aceites tamb�m os seguintes caracteres : "
			STR0025 := "Ficheiro Vazio"
			STR0028 := "Repetido"
			STR0029 := "Criado com sucesso"
			STR0031 := "Gest�o De Acervos"
			STR0032 := "Sistema De Gest�o De Indicadores"
			STR0033 := "Gest�o Do Capital Humano"
			STR0034 := "Portal Do Candidato"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
