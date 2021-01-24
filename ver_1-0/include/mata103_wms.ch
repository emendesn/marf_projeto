#ifdef SPANISH
	#define STR0001 "El campo"
	#define STR0002 "debe completarse"
	#define STR0003 "si se utiliza la integracion con el modulo de WMS."
	#define STR0004 "(Item numero"
	#define STR0005 "del Documento)"
	#define STR0006 "Los campos"
	#define STR0007 "deben completarse"
	#define STR0008 "Solo pueden utilizarse Servicios de WMS del tipo Entrada."
	#define STR0009 " no se encontro."
	#define STR0010 "La Direccion "
	#define STR0011 " no se encontro."
	#define STR0012 "La Estructura fisica de la direccion "
	#define STR0013 "Solo pueden utilizarse Direcciones pertenecientes a Estructuras fisicas del tipo BOX/DOCA."
	#define STR0014 "El documento no puede clasificarse porque tiene servicios de Verificacion WMS pendientes."
	#define STR0015 "SIGAWMS"
#else
	#ifdef ENGLISH
		#define STR0001 "The field"
		#define STR0002 "it must be filled in"
		#define STR0003 "when the integration to the WMS module is used."
		#define STR0004 "(Item number"
		#define STR0005 "of the Document)"
		#define STR0006 "The fields"
		#define STR0007 "must be completed"
		#define STR0008 "Only WMS services of the Inbound type can be used."
		#define STR0009 " not found."
		#define STR0010 "Address "
		#define STR0011 " not found."
		#define STR0012 "Address Physical Structure "
		#define STR0013 "Only Addresses within Physical Structures of the BOX/DOCA type can be used."
		#define STR0014 "Invoice cannot be classified because has pending WMS Conference services."
		#define STR0015 "SIGAWMS"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "O campo" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "deve ser preenchido" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "quando se utiliza a integracao com o modulo de WMS." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "(Item numero" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "do Documento)" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Os campos" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "devem ser preenchidos" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Somente Servicos de WMS do tipo Entrada podem ser utilizados." )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , " nao foi encontrado." )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "O Endereco " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , " nao foi encontrada." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "A Estrutura Fisica do Endereco " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Somente Enderecos pertencentes a Estruturas Fisicas do tipo BOX/DOCA podem ser utilizados." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Documento nao pode ser classificado porque possui servicos de Conferencia WMS pendentes." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "SIGAWMS" )
	#endif
#endif
