#ifdef SPANISH
	#define STR0001 "�Nombre del archivo texto?"
	#define STR0002 "Generacion del archivo de bienes a partir del archivo texto "
	#define STR0003 "Se encontraron errores en la importacion... �Desea imprimir?"
	#define STR0004 "Bien no informado"
	#define STR0005 "Familia no informada"
	#define STR0006 "Centro de Costo no informado"
	#define STR0007 "Calendario no informado"
	#define STR0008 "Familia no valida"
	#define STR0009 "Centro de Costo no valido"
	#define STR0010 "Calendario no valido"
	#define STR0011 "Generacion de errores encontrados durante la importacion de bienes para la tabla ST9"
	#define STR0012 "Errores encontrados en la importacion de bienes en el"
	#define STR0013 "Linea    Mensaje                         Contenido"
	#define STR0014 "ANULADO POR EL OPERADOR"
	#define STR0015 "Codigo del bien registrado"
	#define STR0016 "Tipo Modelo no Informado"
	#define STR0017 "Tipo Modelo Invalido"
	#define STR0018 "Categoria de Bien Invalido"
	#define STR0019 "Familia estandar Invalido"
	#define STR0020 "Estructura Invalida"
	#define STR0021 "Cambia Pondera Invalido"
	#define STR0022 "Situacion Mantenimiento Invalido"
	#define STR0023 "Situacion de Bien Invalido"
#else
	#ifdef ENGLISH
		#define STR0001 "Name of the File Text ?"
		#define STR0002 "Generation of Assets File from the Text File"
		#define STR0003 "Errors were found when importingt...Do you want to print?"
		#define STR0004 "Asset not entered"
		#define STR0005 "Family not entered"
		#define STR0006 "Cost Center not entered"
		#define STR0007 "Calendar not entered"
		#define STR0008 "Invalid Family"
		#define STR0009 "Invalid Cost Center"
		#define STR0010 "Invalid Calendar"
		#define STR0011 "Errors Generation found when importing assets to the table ST9"
		#define STR0012 "Errors found when importing assets in the "
		#define STR0013 "Row      Message                         Content "
		#define STR0014 "CANCELLED BY THE OPERATOR"
		#define STR0015 "Asset code is already registered"
		#define STR0016 "Model type not informed"
		#define STR0017 "Invalid Model Type"
		#define STR0018 "Invalid Asset Category"
		#define STR0019 "Invalid Standard family"
		#define STR0020 "Invalid Structure"
		#define STR0021 "Invalid Change Ponder"
		#define STR0022 "Invalid Maintenance Situation"
		#define STR0023 "Invalid Asset Situation"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Nome do arquivo texto ?", "Nome do Arquivo Texto ?" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Cria��o do registo de bens a partir do arquivo texto ", "Geracao do Cadastro de Bens a Partir do Arquivo Texto " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Foram Encontrados Erros Na Importa��o... Deseja Imprimir?", "Foram encontrados erros na importacao... Deseja Imprimir?" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Bem n�o informado", "Bem nao informado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Familia n�o informada", "Familia nao informada" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Centro De Custo N�o Informado", "Centro de Custo nao Informado" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Calendario N�o Informado", "Calendario nao Informado" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Familia Inv�lida", "Familia Invalida" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Centro De Custo Inv�lido", "Centro de Custo Invalido" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Calendario Inv�lido", "Calendario Invalido" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Cria��o De Erros Encontrados Durante A Importa��o De Bens Para A Tabela St9", "Geracao de Erros encontrados durante a importacao de bens para a tabela ST9" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Erros encontrados na importa��o de bens no", "Erros Encontrados na Importacao de Bens no" )
		#define STR0013 "Linha    Mensagem                        Conteudo"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador", "CANCELADO PELO OPERADOR" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "C�digo do bem j� registado", "Codigo do bem ja cadastrado" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Tipo modelo n�o informado", "Tipo Modelo n�o Informado" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Tipo modelo inv�lido", "Tipo Modelo Invalido" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Categoria do bem inv�lida", "Categoria do Bem Inv�lido" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Fam�lia padr�o inv�lida", "Familia padr�o Inv�lido" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Estrutura inv�lida", "Estrutura Inv�lida" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Muda pondera inv�lido", "Muda Pondera Inv�lido" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Situa��o manuten��o inv�lido", "Situa��o Manuten��o Inv�lido" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Situa��o do bem inv�lido", "Situa��o do Bem Inv�lido" )
	#endif
#endif
