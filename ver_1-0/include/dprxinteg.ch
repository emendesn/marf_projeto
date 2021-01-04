#ifdef SPANISH
	#define STR0001 "Tabla "
	#define STR0002 " no se creo. Operacion abortada."
	#define STR0003 " posee acceso "
	#define STR0004 "�Actualizacion concluida!"
	#define STR0005 "Modificaciones"
	#define STR0006 "El archivo no puede ser mayor a 1048575 bytes "
	#define STR0007 "Modificaciones realizadas: "
	#define STR0008 " - CF: "
	#define STR0009 "Componente - "
	#define STR0010 " - Cant : "
	#define STR0011 " - Lista de Componentes: "
	#define STR0012 "Alternativo - "
	#define STR0013 "Operacion - "
	#define STR0014 " - Procedimiento: "
	#define STR0015 " - Preparacion: "
	#define STR0016 "Alternativa - "
	#define STR0017 "Hay diferencia de exclusividad/compartir entre las tablas SG1 y SCK"
	#define STR0018 "**Se encontro un problema impeditivo en la estructura en los campos, de la empresa "
	#define STR0019 " y sucursal "
	#define STR0020 ", y la carga no se debe efectuar. Se genero un archivo de log"
	#define STR0021 "Se encontraron diferencias entre la estructura en los campos, de la empresa "
	#define STR0022 ", de la carga y se genero un archivo de log"
	#define STR0023 "El campo "
	#define STR0024 ", de la empresa "
	#define STR0025 ", no se encontro en ninguna de las tablas informadas en el array aTabComp, verifique si la tabla est� realmente informada o el nombre del campo se digito correctamente."
	#define STR0026 "  ****** I M P E D I T I V O ******"
	#define STR0027 "Los siguientes campos, de la empresa '"
	#define STR0028 ", se deben estandarizar, "
	#define STR0029 " y "
	#define STR0030 ". Sus respectivas estructuras son:"
	#define STR0031 "Tipo"
	#define STR0032 "Tamano(Entero)"
	#define STR0033 "Tamano(Decimal)"
	#define STR0034 "en la carpeta raiz del Protheus con las diferencias."
	#define STR0035 "en la carpeta raiz del Protheus, aunque los mismos no impactaran en la carga."
	#define STR0036 "Hay diferencia de exclusividad/uso compartido entre las tablas SC5 y DGC"
	#define STR0037 "Hay diferencia de exclusividad/uso compartido entre las tablas SCK y DGC"
	#define STR0038 "Hay diferencia de exclusividad/uso compartido entre las tablas SC2 y DGH"
#else
	#ifdef ENGLISH
		#define STR0001 "Table "
		#define STR0002 " not created, Operation aborted."
		#define STR0003 " has access "
		#define STR0004 "Update completed!"
		#define STR0005 "Changes"
		#define STR0006 "file cannot be bigger than 1048575 bytes "
		#define STR0007 "Changes performed: "
		#define STR0008 " - CF: "
		#define STR0009 "Component - "
		#define STR0010 " - Amt. "
		#define STR0011 " - Component List: "
		#define STR0012 "Alternative - "
		#define STR0013 "Operation - "
		#define STR0014 " - Script: "
		#define STR0015 " - Preparation: "
		#define STR0016 "Alternative - "
		#define STR0017 "Exclusivity/sharing differences between tables SG1 and SCK found"
		#define STR0018 "**An obstacle problem has been found in fields of the structure of the company "
		#define STR0019 " and branch "
		#define STR0020 ", and the load cannot be carried out. A log file (validfields.log) was generated in the source folder of Protheus with the differences."
		#define STR0021 "Differences were found between the structure in fields of the company "
		#define STR0022 ", da carga e foi gerado um arquivo de log(validfields.log) na pasta raiz do Protheus, por�m os mesmos n�o impactaram na carga."
		#define STR0023 "The field "
		#define STR0024 ", the company "
		#define STR0025 ", not found in any of the tables informed in the aTabComp array, check if the table is really informed or the name of the file was entered correctly."
		#define STR0026 "  ****** I M P E D I M E N T ******"
		#define STR0027 "The following fields of the company '"
		#define STR0028 ", must be standardized, "
		#define STR0029 " and "
		#define STR0030 ". Respective structures are:"
		#define STR0031 "Type"
		#define STR0032 "Size(Whole)"
		#define STR0033 "Size(Decimal)"
		#define STR0034 "in the source folder of Protheus with differences."
		#define STR0035 "in the source folder of Protheus, but they will not impact the load."
		#define STR0036 "Exclusivity/sharing differences between tables SC5 and DGC found"
		#define STR0037 "Exclusivity/sharing differences between tables SCK and DGC found"
		#define STR0038 "Exclusivity/sharing differences between tables SC2 and DGH found"
	#else
		#define STR0001 "Tabela "
		#define STR0002 " n�o foi criada. Opera��o abortada."
		#define STR0003 " possui acesso "
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Actualiza��o conclu�da.", "Atualiza��o conclu�da!" )
		#define STR0005 "Altera��es"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "O ficheiro n�o pode ser maior que 1048575 bytes ", "arquivo nao pode ser maior que 1048575 bytes " )
		#define STR0007 "Altera��es feitas: "
		#define STR0008 " - CF: "
		#define STR0009 "Componente - "
		#define STR0010 " - Qtd : "
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " - Lista de componentes: ", " - Lista de Componentes: " )
		#define STR0012 "Alternativo - "
		#define STR0013 "Opera��o - "
		#define STR0014 " - Roteiro: "
		#define STR0015 " - Prepara��o: "
		#define STR0016 "Alternativa - "
		#define STR0017 "H� diferen�a de exclusividade/compartilhamento entre as tabelas SG1 e SCK"
		#define STR0018 "**Foi encontrado um problema impeditivo na estrutura nos campos, da empresa "
		#define STR0019 " e filial "
		#define STR0020 ", e a carga n�o pode ser efetuada. Foi gerado um arquivo de log"
		#define STR0021 "Foram encontrado diferen�as entre a estrutura nos campos, da empresa "
		#define STR0022 ", da carga e foi gerado um arquivo de log"
		#define STR0023 "O campo "
		#define STR0024 ", da empresa "
		#define STR0025 ", n�o foi encontrado em nenhuma das tabelas informadas no array aTabComp, verificar se a tabela est� realmente informada ou o nome do campo foi digitado corretamente."
		#define STR0026 "  ****** I M P E D I T I V O ******"
		#define STR0027 "Os seguintes campos, da empresa '"
		#define STR0028 ", devem ser padronizados, "
		#define STR0029 " e "
		#define STR0030 ". Suas respectivas estruturas s�o:"
		#define STR0031 "Tipo"
		#define STR0032 "Tamanho(Inteiro)"
		#define STR0033 "Tamanho(Decimal)"
		#define STR0034 "na pasta raiz do Protheus com as diferen�as."
		#define STR0035 "na pasta raiz do Protheus, por�m os mesmos n�o impactar�o na carga."
		#define STR0036 "H� diferen�a de exclusividade/compartilhamento entre as tabelas SC5 e DGC"
		#define STR0037 "H� diferen�a de exclusividade/compartilhamento entre as tabelas SCK e DGC"
		#define STR0038 "H� diferen�a de exclusividade/compartilhamento entre as tabelas SC2 e DGH"
	#endif
#endif
