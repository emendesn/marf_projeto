#ifdef SPANISH
	#define STR0001 "Gerenciador de graficos"
	#define STR0002 "Modificar"
	#define STR0003 "Modificar"
	#define STR0004 "Borrar"
	#define STR0005 "Borrar"
	#define STR0006 "Definir como estandar..."
	#define STR0007 "Definir como estandar..."
	#define STR0008 "Gerenciador de graficos"
	#define STR0009 "�Seleccione un grafico por vez para modificar!"
	#define STR0010 "�Seleccione uno de los graficos para modificarlo!"
	#define STR0011 "Confirmacion"
	#define STR0012 "�Realmente desea borrar el(los) gr�fico(s) seleccionados?"
	#define STR0013 "�Seleccione uno de los graficos para borrarlo!"
	#define STR0014 " definido como estandar."
	#define STR0015 "Grafico "
	#define STR0016 " como estandar."
	#define STR0017 "Error en la definicion del grafico "
	#define STR0018 "�Solamente un grafico puede seleccionarse como estandar de la rutina!"
	#define STR0019 "�Seleccione uno de los graficos para definirlo como estandar!"
	#define STR0020 "Restaura estandar"
	#define STR0021 "�Desea restaurar el grafico estandar en la apertura del browser?"
	#define STR0022 "Restaurado con exito"
#else
	#ifdef ENGLISH
		#define STR0001 "Chart Manager"
		#define STR0002 "Change"
		#define STR0003 "Change"
		#define STR0004 "Delete"
		#define STR0005 "Delete"
		#define STR0006 "Set as default..."
		#define STR0007 "Set as default..."
		#define STR0008 "Chart Manager"
		#define STR0009 "Select a chart at a time to change it!"
		#define STR0010 "Select one of the charts to change!"
		#define STR0011 "Confirmation"
		#define STR0012 "Do you really want to delete the charts selected?"
		#define STR0013 "Select one of the charts to delete!"
		#define STR0014 " set as default."
		#define STR0015 "Chart "
		#define STR0016 " as default."
		#define STR0017 "Error while setting the chart "
		#define STR0018 "Only one chart can be selected as default in the routine!"
		#define STR0019 "Select one of the charts to set as default!"
		#define STR0020 "Restore standard"
		#define STR0021 "Do you want to restore the default view in the browser opening?"
		#define STR0022 "Successfully restored."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Gerenciador de Gr�ficos" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Alterar" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Excluir" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Definir como padr�o" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Definir como padr�o" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Gerenciador de gr�ficos" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Selecione um gr�fico por vez para alterar!" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Selecione um dos gr�ficos para alterar!" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Confirma��o" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Deseja, realmente, excluir o(s) gr�ficos(�es) selecionados?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Selecione um dos gr�ficos para excluir!" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , " definido como padr�o." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Gr�fico " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , " como padr�o." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Erro na defini��o do gr�fico " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Somente um gr�fico pode ser selecionado como padr�o da rotina!" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Selecione um dos gr�ficos para definir como padr�o!" )
		#define STR0020 "Restaurar padr�o"
		#define STR0021 "Deseja restaurar o gr�fico padr�o na abertura do browser?"
		#define STR0022 "Restaurado com sucesso"
	#endif
#endif
