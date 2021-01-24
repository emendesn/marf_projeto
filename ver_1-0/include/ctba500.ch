#ifdef SPANISH
	#define STR0001 "Contabilidad de archivos TXT"
	#define STR0002 "  El  objetivo  de  este  programa  es  generar  los  asientos contables"
	#define STR0003 "Off Line con datos importados de otras fuentes."
	#define STR0004 "ERROR DE LECTURA"
	#define STR0005 "Verifique"
	#define STR0006 "la estructura del archivo TXT"
	#define STR0007 "y los parametros informados."
	#define STR0008 "Diretorio n�o cont�m arquivos .TXT"
	#define STR0009 "Par�metro MV_CTBTRES esta vazio"
	#define STR0010 "Par�metro MV_CTBTERR esta vazio"
	#define STR0011 "Aviso de Processamento de Contabiliza��o TXT"
	#define STR0012 "Ser� processado o arquivo "
	#define STR0013 ". Confirma? "
	#define STR0014 "Ser�o processados os arquivos contidos na pasta interna. Confirma?"
	#define STR0015 "Data Inicio: "
	#define STR0016 "Hora Inicio: "
	#define STR0017 "Data Fim: "
	#define STR0018 "Hora Fim: "
	#define STR0019 " El siguiente procesamiento se ejecut� en el sistema. "
	#define STR0020 " Usu�rio : "
	#define STR0021 "Par�metros "
#else
	#ifdef ENGLISH
		#define STR0001 "TXT File Accounting     "
		#define STR0002 "  The purpose of this program is to generate the Offline Ledger "
		#define STR0003 "Entries with data imported from other sources. "
		#define STR0004 "READING ERROR"
		#define STR0005 "Check "
		#define STR0006 "TXT file structure"
		#define STR0007 "and parameters indicated."
		#define STR0008 "Directory does not have .TXT files"
		#define STR0009 "Parameter MV_CTBTRES is blank"
		#define STR0010 "Parameter MV_CTBTERR is blank"
		#define STR0011 "TXT Accounting Processing Warning"
		#define STR0012 "File is processed "
		#define STR0013 "Do you confirm it? "
		#define STR0014 "The files in the internal folder are processed. Confirm it?"
		#define STR0015 "Start Date: "
		#define STR0016 "Start Time: "
		#define STR0017 "End Date: "
		#define STR0018 "End Time: "
		#define STR0019 " The Following Processing was Run in the System. "
		#define STR0020 " User: "
		#define STR0021 "Parameters "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Contabiliza��o De Ficheiros De Texto", "Contabilizacao de Arquivos TXT" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "  O objetivo deste programa � o de criar lan�amentos contabil�sticos", "  O  objetivo  deste programa  e  o  de  gerar  lancamentos  contabeis" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A partir do ficheiro de texto importado de outros sistemas.", "a partir de arquivo texto importados de outros sistemas." )
		#define STR0004 "ERRO DE LEITURA"
		#define STR0005 "Verifique"
		#define STR0006 "a estrutura do arquivo TXT"
		#define STR0007 "e os par�metros informados."
		#define STR0008 "Diretorio n�o cont�m arquivos .TXT"
		#define STR0009 "Par�metro MV_CTBTRES esta vazio"
		#define STR0010 "Par�metro MV_CTBTERR esta vazio"
		#define STR0011 "Aviso de Processamento de Contabiliza��o TXT"
		#define STR0012 "Ser� processado o arquivo "
		#define STR0013 ". Confirma? "
		#define STR0014 "Ser�o processados os arquivos contidos na pasta interna. Confirma?"
		#define STR0015 "Data Inicio: "
		#define STR0016 "Hora Inicio: "
		#define STR0017 "Data Fim: "
		#define STR0018 "Hora Fim: "
		#define STR0019 " O Seguinte Processamento Foi Executado no Sistema. "
		#define STR0020 " Usu�rio : "
		#define STR0021 "Par�metros "
	#endif
#endif
