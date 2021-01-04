#ifdef SPANISH
	#define STR0001 "Creando tabla "
	#define STR0002 "Hay diferencias entre la estructura fisica y logica"
	#define STR0003 "Copiando tabla "
	#define STR0004 " para "
	#define STR0005 "Total de registros: "
	#define STR0006 "Copia efectuada en "
	#define STR0007 "Creando estructura actualizada para "
	#define STR0008 "Actualizando registros a partir de "
	#define STR0009 " OK. Actualizacion efectuada en "
	#define STR0010 "Configurar la clave INSTANCENAME, en la seccion de Enviroment y Job."
	#define STR0011 "Clave INSTANCENAME no configurada."
	#define STR0012 "Error gravando registro para la nueva columna "
	#define STR0013 "Atencion, la clave INSTANCENAME debe configurarse."
#else
	#ifdef ENGLISH
		#define STR0001 "Creating table "
		#define STR0002 "There are differences between physical and logical structure."
		#define STR0003 "Copying table "
		#define STR0004 " to "
		#define STR0005 "Total of records: "
		#define STR0006 "Copy made in "
		#define STR0007 "Creating structure updated for "
		#define STR0008 "Updating records from "
		#define STR0009 " OK Update made in "
		#define STR0010 "Configure the INSTANCENAME key, in the section of Environment and Job."
		#define STR0011 "INSTANCENAME key not configured."
		#define STR0012 "Error while saving record for the new column "
		#define STR0013 "Attention. INSTANCENAME key must be configured."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A criar tabela ", "Criando tabela " )
		#define STR0002 "H� diferen�as entre a estrutura f�sica e l�gica"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "A copiar tabela ", "Copiando tabela " )
		#define STR0004 " para "
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Total de registos: ", "Total de registros: " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "C�pia efectuada em ", "C�pia efetuada em " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "A criar estrutura actualizada para ", "Criando estrutura atualizada para " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "A actualizar registos a partir de ", "Atualizando registros a partir de " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " OK. Actualiza��o efectuada em ", " OK. Atualiza��o efetuada em " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Configurar a chave INSTANCENAME, na sec��o de Enviroment e Job.", "Configurar a chave INSTANCENAME, na se��o de Enviroment e Job." )
		#define STR0011 "Chave INSTANCENAME n�o configurada."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Erro ao gravar registo para a nova coluna ", "Erro gravando registro para a nova coluna " )
		#define STR0013 "Aten��o, a chave INSTANCENAME deve ser configurada."
	#endif
#endif
