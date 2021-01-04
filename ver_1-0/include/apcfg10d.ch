#ifdef SPANISH
	#define STR0001 "Visualizar Disparador - "
	#define STR0002 "Nuevo Disparador"
	#define STR0003 "Editar Disparador - "
	#define STR0004 "Borrar Disparador - "
	#define STR0005 "Campo"
	#define STR0006 "Secuencia"
	#define STR0007 "Cnt. Dominio"
	#define STR0008 "Tipo"
	#define STR0009 "Regla"
	#define STR0010 "Posiciona"
	#define STR0011 "Alias"
	#define STR0012 "Orden"
	#define STR0013 "Clave"
	#define STR0014 "Condicion"
	#define STR0015 "1=Primario;2=Extranjero;3=Posicion"
	#define STR0016 "1=Si;2=No"
	#define STR0017 "Espere "
	#define STR0018 "Actualizando la estructura del SX7"
#else
	#ifdef ENGLISH
		#define STR0001 "View Trigger - "
		#define STR0002 "New Trigger"
		#define STR0003 "Edit Trigger - "
		#define STR0004 "Delete Trigger - "
		#define STR0005 "Field"
		#define STR0006 "Sequence"
		#define STR0007 "Domain Cnt."
		#define STR0008 "Type"
		#define STR0009 "Rule"
		#define STR0010 "Locate"
		#define STR0011 "Alias"
		#define STR0012 "Order"
		#define STR0013 "Key"
		#define STR0014 "Condition"
		#define STR0015 "1=Primary;2=Foreign;3=Location"
		#define STR0016 "1=Yes;2=No"
		#define STR0017 "Please, wait"
		#define STR0018 "Updating the SX7 structure    "
	#else
		Static STR0001 := "Visualizar Gatilho - "
		#define STR0002  "Novo Gatilho"
		Static STR0003 := "Editar Gatilho - "
		Static STR0004 := "Excluir Gatilho - "
		#define STR0005  "Campo"
		Static STR0006 := "Sequencia"
		Static STR0007 := "Cnt. Dominio"
		#define STR0008  "Tipo"
		#define STR0009  "Regra"
		#define STR0010  "Posiciona"
		Static STR0011 := "Alias"
		#define STR0012  "Ordem"
		#define STR0013  "Chave"
		Static STR0014 := "Condicao"
		Static STR0015 := "1=Primario;2=Estrangeiro;3=Posicionamento"
		Static STR0016 := "1=Sim;2=Não"
		#define STR0017  "Aguarde"
		Static STR0018 := "Atualizando a estrutura do SX7"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Visualizar gatilho - "
			STR0003 := "Editar gatilho - "
			STR0004 := "Excluir gatilho - "
			STR0006 := "Sequência"
			STR0007 := "Cnt. Domínio"
			STR0011 := "Aliás"
			STR0014 := "Condição"
			STR0015 := "1=primário;2=estrangeiro;3=posicionamento"
			STR0016 := "1=sim;2=não"
			STR0018 := "A Actualizar A Estrutura Do Sx7"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
