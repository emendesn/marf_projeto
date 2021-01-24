#ifdef SPANISH
	#define STR0001 "Nuevo menu"
	#define STR0002 "La rutina "
	#define STR0003 " ya se agrego al nuevo menu y se encuentra en los items: "
	#define STR0004 "¿Desea continuar?"
	#define STR0005 "Atencion"
	#define STR0006 "No se selecciono ningun grupo para recibir los items."
	#define STR0007 "En este nivel solo se permite agregar los grupos principales."
	#define STR0008 "No se permite agregar items en un item de menu."
	#define STR0009 "Solo se permite incluir cinco niveles en el menu."
	#define STR0010 "Desea borrar todos los items contenidos en "
	#define STR0011 "Este item no puede moverse."
	#define STR0012 "Imposible crear archivo "
#else
	#ifdef ENGLISH
		#define STR0001 "New menu"
		#define STR0002 "Routine "
		#define STR0003 " already added to the new menu and is under items: "
		#define STR0004 "Continue?"
		#define STR0005 "Attention"
		#define STR0006 "No group selected to receive the items."
		#define STR0007 "Only main groups can be added to this level."
		#define STR0008 "Items are not allowed to be added to a menu item."
		#define STR0009 "Only five levels can be added to the menu."
		#define STR0010 "Delete all items contained in "
		#define STR0011 "This item cannot be moved."
		#define STR0012 "Unable to create file "
	#else
		#define STR0001  "Novo Menu"
		#define STR0002  "A rotina "
		#define STR0003  " já foi adicionada ao novo menu e encontra-se nos itens: "
		#define STR0004  "Deseja Continuar?"
		#define STR0005  "Atenção"
		#define STR0006  "Nenhum grupo foi selecionado para receber os itens."
		Static STR0007 := "Só é permitido adicionar os grupos principais nesse nível."
		#define STR0008  "Não é permitido adicionar itens em um item de menu."
		Static STR0009 := "Só é permitido a inclusão de cinco níveis no menu."
		#define STR0010  "Deseja excluir todos os itens contidos em "
		#define STR0011  "Esse item não pode ser movido."
		Static STR0012 := "Não foi possível criar o arquivo "
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0007 := "Sé é permitido adicionar os grupos principais nesse nível."
			STR0009 := "So e permitido a inclusão de cinco niveis no menu."
			STR0012 := "Não foi possivel criar o arquivo "
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
