#ifdef SPANISH
	#define STR0001 "Buscar"
	#define STR0002 "Visualizar"
	#define STR0003 "Incluir"
	#define STR0004 "Modificar"
	#define STR0005 "Borrar"
	#define STR0006 "Registro de Segmentos"
	#define STR0007 "Visiones"
	#define STR0008 "Grup.Usuarios"
	#define STR0009 "Usuarios"
	#define STR0010 "Departamentos"
	#define STR0011 "Grup.Documentos"
	#define STR0012 "Externos"
	#define STR0013 "Empleados"
	#define STR0014 "Materias"
	#define STR0015 "Cargar"
	#define STR0016 "Rutina no configurada para utilizacion. Verifique el parametro MV_ACVISIB a trav�s del SIGACFG."
	#define STR0017 "Calc"
	#define STR0018 "Calculadora "
	#define STR0019 "Spool"
	#define STR0020 "Ayuda"
	#define STR0021 "Carga todos los datos del registro en la carpeta correspondiente"
	#define STR0022 "Imposible generar el numero del segmento correctamente. Archivo SXE/SXF corrupto. Entre en contacto con el administrador del sistema."
	#define STR0023 "Ok - <Ctrl-O>"
	#define STR0024 "Anular - <Ctrl-X>"
	#define STR0025 "Ok"
	#define STR0026 "Anular"
	#define STR0027 "Segmento"
	#define STR0028 "Atencion"
	#define STR0029 "�Todos los datos de la carpeta Visiones deben completarse!"
	#define STR0030 "�Ya se informo este Item anteriormente!"
	#define STR0031 "�Infome usuarios o grupos de usuarios para completar la operacion!"
	#define STR0032 "No esta disponible funcionalidad para la pagina"
	#define STR0033 "Desea realmente sobrescribir los datos de la p�gina"
	#define STR0034 "Si"
	#define STR0035 "No"
	#define STR0036 "�Existen informaciones duplicadas en carpeta Visiones!"
	#define STR0037 "El  registro podra ser efectuado sin embargo la visibilidad aun se encuentra desactivada, despues de la configuracion verifique el parametro MV_ACVISIB  a traves del SIGACFG."
#else
	#ifdef ENGLISH
		#define STR0001 "Search"
		#define STR0002 "View"
		#define STR0003 "Add"
		#define STR0004 "Edit"
		#define STR0005 "Delete"
		#define STR0006 "Segments File"
		#define STR0007 "View"
		#define STR0008 "Users Group"
		#define STR0009 "Users"
		#define STR0010 "Departments"
		#define STR0011 "Documents Group"
		#define STR0012 "External"
		#define STR0013 "Employees"
		#define STR0014 "Subjects"
		#define STR0015 "Load"
		#define STR0016 "Routine not configured for use. Check the parameter MV_ACVISIB through SIGACFG."
		#define STR0017 "Calc"
		#define STR0018 "Calculator  "
		#define STR0019 "Spool"
		#define STR0020 "Help"
		#define STR0021 "Load all the data of the file in the corresponding folder"
		#define STR0022 "Cannot generate the segment number correctly. File SXE/SXF corrupted. Refer to the system administrator."
		#define STR0023 "OK - <Ctrl-O>"
		#define STR0024 "Cancel - <Ctrl-X>"
		#define STR0025 "OK"
		#define STR0026 "Cancel"
		#define STR0027 "Segment"
		#define STR0028 "Warning"
		#define STR0029 "All the data of the Views folder must be entered!"
		#define STR0030 "Item already entered!"
		#define STR0031 "Enter the users or group of users to complete the operation!"
		#define STR0032 "Funcionality necessary for the page"
		#define STR0033 "Do you want to overwrite the data of the page?  "
		#define STR0034 "Yes"
		#define STR0035 "No"
		#define STR0036 "There are duplicated information in Views folder!"
		#define STR0037 "It is possible to register but visualing it is still disabled; after configuring it, check the parameter MV_ACVISIB o MV_ACVISIB atrav�s do SIGACFG.      "
	#else
		#define STR0001 "Pesquisar"
		#define STR0002 "Visualizar"
		#define STR0003 "Incluir"
		#define STR0004 "Alterar"
		#define STR0005 "Excluir"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo De Segmentos", "Cadastro de Segmentos" )
		#define STR0007 "Vis�es"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Grup.utilizadores", "Grup.Usu�rios" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Utilizadores", "Usu�rios" )
		#define STR0010 "Departamentos"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Grup.documentos", "Grup.Documentos" )
		#define STR0012 "Externos"
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Empregados", "Funcion�rios" )
		#define STR0014 "Disciplinas"
		#define STR0015 "Carregar"
		#define STR0016 "Rotina n�o configurada para utiliza��o. Verifique o par�metro MV_ACVISIB atrav�s do SIGACFG."
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "C�lc", "Calc" )
		#define STR0018 "Calculadora "
		#define STR0019 "Spool"
		#define STR0020 "Ajuda"
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Carregar todos os dados do registo na pasta correspondente", "Carrega todos os dados do cadastro na pasta correspondente" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Imposs�vel criar o n�mero do segmento correctamente. ficheiro sxe/sxf corrompido. entrar em contacto com o administrador do sistema.", "Imposs�vel gerar o n�mero do segmento corretamente. Arquivo SXE/SXF corrompido. Entre em contato com o administrador do sistema." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Ok - <ctrl-o>", "Ok - <Ctrl-O>" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Cancelar - <ctrl-x>", "Cancelar - <Ctrl-X>" )
		#define STR0025 "Ok"
		#define STR0026 "Cancelar"
		#define STR0027 "Segmento"
		#define STR0028 "Aten��o"
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Todos os dados da pasta vis�es t�m ser prenchidos!", "Todos os dados da pasta Vis�es precisam ser prenchidos!" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Item j� indicado anteriormente!", "Item j� informado anteriormente!" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Indicar utilizadores ou grupos de utilizadores para completar a opera��o!", "Infome usu�rios ou grupos de usu�rios para completar a opera��o!" )
		#define STR0032 "Funcionalidade indispon�vel para a p�gina"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Deseja realmente escrever por cima dos dados da p�gina", "Deseja realmente sobrescrever os dados da p�gina" )
		#define STR0034 "Sim"
		#define STR0035 "N�o"
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Existem informa��es duplicadas no pasta vis�es!", "Existem informa��es duplicadas no pasta Vis�es!" )
		#define STR0037 "O cadastro poder� ser efetuado por�m a visibilidade ainda se encontra desativada, ap�s a configura��o verifique o par�metro MV_ACVISIB atrav�s do SIGACFG."
	#endif
#endif