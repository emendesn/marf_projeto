#ifdef SPANISH
	#define STR0001 "Necesario actualizar paquete de la TISS 2.2 para utilizar esta funcionalidad."
#else
	#ifdef ENGLISH
		#define STR0001 "Update TISS 2.2 package to use this functionality."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "É necessário actualizar pacote da TISS 2.2 para utilizar esta funcionalidade.", "Necessário atualizar pacote da TISS 2.2 para se utilizar esta funcionalidade." )
	#endif
#endif
