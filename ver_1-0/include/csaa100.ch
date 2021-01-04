#ifdef SPANISH
	#define STR0001 "Departamento "
	#define STR0002 "Buscar"
	#define STR0003 "Visualizar"
	#define STR0004 "Incluir"
	#define STR0005 "Modificar"
	#define STR0006 "Borrar"
	#define STR0007 "Salir"
	#define STR0008 "Confirma"
	#define STR0009 "�Cuanto al borrado?"
	#define STR0010 "Seleccionando registros..."
	#define STR0011 "No se puede borrar este departamento."
	#define STR0012 "Verifique los departamentos que lo tienen como"
	#define STR0013 "superior."
	#define STR0014 "La clave de departamento ya existe"
	#define STR0015 "Actualizar visualizaciones"
	#define STR0016 "ATENCION"
	#define STR0017 "No existen visualizaciones por actualizarse"
	#define STR0018 "Salir"
	#define STR0019 "Actualizar departamentos en la tabla de visualizaciones"
	#define STR0020 "Actualizar visualizaciones"
	#define STR0021 "Confirmar"
	#define STR0022 "Anular"
	#define STR0023 "Marca/Desmarca todos"
	#define STR0024 "Codigo"
	#define STR0025 "Descripcion"
	#define STR0026 "Fecha inclusion"
	#define STR0027 "Registro"
	#define STR0028 "�Confirma procesamiento?"
	#define STR0029 "No"
	#define STR0030 "Si"
	#define STR0031 "Los campos de sucursal responsable y matricula responsable estan vinculados. Si los utiliza, ambos deben estar cumplimentados."
#else
	#ifdef ENGLISH
		#define STR0001 "Department"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Insert"
		#define STR0005 "Edit"
		#define STR0006 "Delete"
		#define STR0007 "Quit"
		#define STR0008 "OK"
		#define STR0009 "About deleting?"
		#define STR0010 "Selecting Records..."
		#define STR0011 "This department cannot be excluded."
		#define STR0012 "Check departments that have it as"
		#define STR0013 "superior."
		#define STR0014 "Department key already existing"
		#define STR0015 "Update Views"
		#define STR0016 "ATTENTION"
		#define STR0017 "There are no views to be updated!"
		#define STR0018 "Exit"
		#define STR0019 "Update departments in view table of views"
		#define STR0020 "Update Views"
		#define STR0021 "Confirm"
		#define STR0022 "Cancel"
		#define STR0023 "Check/Uncheck All"
		#define STR0024 "Code"
		#define STR0025 "Description"
		#define STR0026 "Inclusion Date"
		#define STR0027 "Record"
		#define STR0028 "Confirm Processing?"
		#define STR0029 "No"
		#define STR0030 "Yes"
		#define STR0031 "The fields branch in charge and registration in charge are associated. If you use them, they must be filled out."
	#else
		#define STR0001 "Departamento "
		#define STR0002 "Pesquisar"
		#define STR0003 "Visualizar"
		#define STR0004 "Incluir"
		#define STR0005 "Alterar"
		#define STR0006 "Excluir"
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0008 "Confirma"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Quanto � exclus�o?", "Quanto � exclus�o?" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0011 "Este departamento n�o pode ser exclu�do."
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Verifique os departamentos que t�m este como", "Verifique os departamentos que tem este como" )
		#define STR0013 "superior."
		#define STR0014 "Chave de departamento j� existente"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Actualizar vis�es", "Atualizar Vis�es" )
		#define STR0016 "ATEN��O"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "N�o existem vis�es a serem actualizadas.", "N�o existem vis�es a serem atualizadas!" )
		#define STR0018 "Sair"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Actualizar departamentos na tabela de vis�es", "Atualizar Departamentos na Tabela das Vis�es" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Actualizar vis�es", "Atualizar Vis�es" )
		#define STR0021 "Confirmar"
		#define STR0022 "Cancelar"
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Marca/Desmarca todos", "Marca/Desmarca Todos" )
		#define STR0024 "C�digo"
		#define STR0025 "Descri��o"
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Data inclus�o", "Data Inclus�o" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Registo", "Registro" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Confirma processamento?", "Confirma Processamento?" )
		#define STR0029 "N�o"
		#define STR0030 "Sim"
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Os campos de filial respons�vel e matr�cula respons�vel s�o associados. Caso utilize-os, ambos devem estar preenchidos.", "Os campos de filial respons�vel e matricula respons�vel s�o associados. Caso utilize-os, ambos devem estar preenchidos." )
	#endif
#endif
