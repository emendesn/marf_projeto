#ifdef SPANISH
	#define STR0001 "Configuracion del panel de gestion"
	#define STR0002 "Mover arriba"
	#define STR0003 "Mover abajo"
	#define STR0004 "Grabar"
	#define STR0005 "Salir"
	#define STR0006 "Paneles disponibles"
	#define STR0007 "Entorno: "
	#define STR0008 "Orden: "
	#define STR0009 "Habilitado"
	#define STR0010 "Deshabilitado"
	#define STR0011 "Filtros"
	#define STR0012 "Parametros"
#else
	#ifdef ENGLISH
		#define STR0001 "Management dashboard configuration"
		#define STR0002 "Move up"
		#define STR0003 "Move down"
		#define STR0004 "Save"
		#define STR0005 "Exit"
		#define STR0006 "Dashboards available"
		#define STR0007 "Environment: "
		#define STR0008 "Order: "
		#define STR0009 "Enabled"
		#define STR0010 "Disabled"
		#define STR0011 "Filters"
		#define STR0012 "Parameters"
	#else
		Static STR0001 := "Configuração do Painel de Gestão"
		Static STR0002 := "Mover Acima"
		Static STR0003 := "Mover Abaixo"
		Static STR0004 := "Salvar"
		#define STR0005  "Sair"
		#define STR0006  "Painéis Disponíveis"
		#define STR0007  "Ambiente: "
		#define STR0008  "Ordem: "
		Static STR0009 := "Habilitado"
		Static STR0010 := "Desabilitado"
		#define STR0011  "Filtros"
		#define STR0012  "Parâmetros"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Configuração do painel de gestão"
			STR0002 := "Mover Para Cima"
			STR0003 := "Mover Para Baixo"
			STR0004 := "Guardar"
			STR0009 := "Activo"
			STR0010 := "Desactivado"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
