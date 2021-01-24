#ifdef SPANISH
	#define STR0001 "Archivo de especificaciones"
	#define STR0002 "Especificaciones"
	#define STR0003 "Entidades"
	#define STR0004 "Adjuntar"
	#define STR0005 "Visualizar adjunto"
	#define STR0006 "Entidades"
	#define STR0007 "Limpiar entidades"
	#define STR0008 "Adjuntar entidad"
	#define STR0009 "Borrar entidad"
	#define STR0010 "Adjuntar registro"
	#define STR0011 "Borrar registro"
	#define STR0012 "Visualizar"
	#define STR0013 "Entidades"
	#define STR0014 "Esta entidad ya pertenece a la estructura."
	#define STR0015 "Problemas al borrar la entidad."
	#define STR0016 "Este registro ya pertenece a la estructura."
	#define STR0017 "Problemas al incluir el registro."
	#define STR0018 "Problemas al borrar el registro."
#else
	#ifdef ENGLISH
		#define STR0001 "Specifications Register"
		#define STR0002 "Specifications"
		#define STR0003 "Entities"
		#define STR0004 "Attach"
		#define STR0005 "View Attachment"
		#define STR0006 "Entities"
		#define STR0007 "Clear Entities"
		#define STR0008 "Attach Entity"
		#define STR0009 "Delete Entity"
		#define STR0010 "Attach Record"
		#define STR0011 "Delete Record"
		#define STR0012 "View"
		#define STR0013 "Entities"
		#define STR0014 "This entity already belongs to the structure."
		#define STR0015 "Errors whiles deleting the entity."
		#define STR0016 "This record already belongs to the structure."
		#define STR0017 "Errors while adding the record."
		#define STR0018 "Errors while deleting the record."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Cadastro de Especificações" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Especificações" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Entidades" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Anexar" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Visualizar Anexo" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Entidades" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Limpar Entidades" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Anexar Entidade" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Excluir Entidade" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Anexar Registro" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Excluir Registro" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Visualizar" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Entidades" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Esta entidade já pertence à estrutura." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Problemas ao excluir a entidade." )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Este registro já pertence à estrutura." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Problemas ao incluir o registro." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Problemas ao excluir o registro." )
	#endif
#endif
