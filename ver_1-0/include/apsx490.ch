#ifdef SPANISH
	#define STR0001 "Gera��o de arquivo de marca"
	#define STR0002 "Refer�ncia da marca"
	#define STR0003 "Customizada"
	#define STR0004 "Desenvolvimento"
	#define STR0005 "Produ��o"
	#define STR0006 "Marca"
	#define STR0007 "Destino"
	#define STR0008 "Diret�rio..."
	#define STR0009 "Diret�rio do arquivo..."
	#define STR0010 "Aten��o"
	#define STR0011 "Caminho inv�lido para c�pia do arquivo!"
	#define STR0012 "Tipo de marca"
	#define STR0013 "RPO base"
	#define STR0014 "Paquete de actualizacion"
	#define STR0015 "!Archivo "
	#define STR0016 " creado con exito!"
	#define STR0017 "�Ocurrieron problemas con la creacion del archivo!"
#else
	#ifdef ENGLISH
		#define STR0001 "Generation of brand file"
		#define STR0002 "Brand model"
		#define STR0003 "Customzied"
		#define STR0004 "Development"
		#define STR0005 "Production"
		#define STR0006 "Brand"
		#define STR0007 "Directory"
		#define STR0008 "Directory..."
		#define STR0009 "File Directory..."
		#define STR0010 "Warning"
		#define STR0011 "Invalid path for file copy!"
		#define STR0012 "Type of brand"
		#define STR0013 "RPO basis"
		#define STR0014 "Update pack"
		#define STR0015 "File "
		#define STR0016 " successfully created!"
		#define STR0017 "Problems occurred during the file creation !"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Gera��o de arquivo de marca" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Refer�ncia da marca" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Customizada" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Desenvolvimento" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Produ��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Marca" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Destino" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Diret�rio..." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Diret�rio do arquivo..." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Aten��o" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Caminho inv�lido para c�pia do arquivo!" )
		#define STR0012 "Tipo de marca"
		#define STR0013 "RPO base"
		#define STR0014 "Pacote de atualiza��o"
		#define STR0015 "Arquivo "
		#define STR0016 " criado com sucesso !"
		#define STR0017 "Ocorreram problemas com a cria��o do arquivo !"
	#endif
#endif
