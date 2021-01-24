#ifdef SPANISH
	#define STR0001 "Sucursal+Referencia"
	#define STR0002 "Sucursal"
	#define STR0003 "Referencia......:"
	#define STR0004 "De/A Empresas Mensaje Unico"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Empresa/Sucursal Protheus no existente"
	#define STR0010 "Informe un valor valido."
	#define STR0011 "Configuracion ya registrada"
#else
	#ifdef ENGLISH
		#define STR0001 "Branch+Reference"
		#define STR0002 "Branch"
		#define STR0003 "Reference"
		#define STR0004 "From/To Companies Single Message"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Protheus Company/Branch does not exist."
		#define STR0010 "Enter a valid value."
		#define STR0011 "Configuration already registered."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Sucursal+Referência", "Filial+Referência" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Sucursal", "Filial" )
		#define STR0003 "Referência"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "De/Para Empresas Mensagem Única", "De/Para Empresas Mensagem Unica" )
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Empresa/Sucursal Protheus não existente", "Empresa/Filial Protheus não existente" )
		#define STR0010 "Informe um valor válido."
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Configuração já registada", "Configuracao já cadastrada" )
	#endif
#endif
