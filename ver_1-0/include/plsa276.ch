#ifdef SPANISH
	#define STR0001 "Seleccionar"
	#define STR0002 "Copiar"
	#define STR0003 "Atencion"
	#define STR0004 "La fecha de vigencia inicial debe ser mayor que la del ultimo registro grabado."
	#define STR0005 "Dif.p/Unidad"
	#define STR0006 "Dif.p/Espec."
	#define STR0007 "Dif.p/Producto"
	#define STR0008 "Para utilizar esta funcion hay que actualizar la version del pls. Familia BMQ"
	#define STR0009 "Para utilizar esta funcion hay que actualizar la version del pls. Familia BMT"
	#define STR0010 "Dif.Unidad"
	#define STR0011 "Para utilizar esta funcion hay que actualizar la version del pls. Familia BSM"
	#define STR0012 "Para utilizar esta funcion hay que actualizar la version del pls. Familia BSX"
	#define STR0013 "Fecha de Inicio"
	#define STR0014 "Vigencias"
#else
	#ifdef ENGLISH
		#define STR0001 "Select"
		#define STR0002 "Copy"
		#define STR0003 "Attention"
		#define STR0004 "Initial effective date must be later than the date of the last record saved."
		#define STR0005 "Dif.by Unit"
		#define STR0006 "Dif.by Spec."
		#define STR0007 "Dif.by Product"
		#define STR0008 "To use this function, PLS version must be updated. BMQ Family"
		#define STR0009 "To use this function, PLS version must be updated. BMT Family"
		#define STR0010 "Unit Dif."
		#define STR0011 "To use this function, PLS version must be updated. BSM Family"
		#define STR0012 "To use this function, PLS version must be updated. BSX Family"
		#define STR0013 "Initial Date"
		#define STR0014 "Validity"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Seleccionar", "Selecionar" )
		#define STR0002 "Copiar"
		#define STR0003 "Atenção"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "A data de vigência inicial deve ser maior que a do último registo gravado.", "A data de vigência inicial deve ser maior que a do último registro gravado." )
		#define STR0005 "Dif.p/Unidade"
		#define STR0006 "Dif.p/Espec."
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Dif.p/Artigo", "Dif.p/Produto" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Para utilizar esta função deve ser actualizada a versão do pls. Família BMQ", "Para utilizar esta funcao deve ser atualizada a versao do pls. Familia BMQ" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Para utilizar esta função deve ser actualizada a versão do pls. Familia BMT", "Para utilizar esta funcao deve ser atualizada a versao do pls. Familia BMT" )
		#define STR0010 "Dif.Unidade"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Para utilizar esta função deve ser actualizada a versão do pls. Família BSM", "Para utilizar esta funcao deve ser atualizada a versao do pls. Familia BSM" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Para utilizar esta função deve ser actualizada a versão do pls. Família BSX", "Para utilizar esta funcao deve ser atualizada a versao do pls. Familia BSX" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Data de Início", "Data de Inicio" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Vigências", "Vigencias" )
	#endif
#endif
