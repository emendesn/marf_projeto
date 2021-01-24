#ifdef SPANISH
	#define STR0001 "Visualizar Parametro - "
	#define STR0002 "Nuevo Parametro"
	#define STR0003 "Editar Parametro - "
	#define STR0004 "Borrar Parametro - "
	#define STR0005 "Sucursal"
	#define STR0006 "Tipo"
	#define STR0007 "Cont. Por"
	#define STR0008 "Descripcion"
	#define STR0009 "Cont.Descripc"
	#define STR0010 "Desc. Esp."
	#define STR0011 "Desc. Ingles"
	#define STR0012 "Informaciones"
	#define STR0013 "Descripcion"
	#define STR0014 "Nombre de Var."
	#define STR0015 "1=Caracter;2=Numerico;3=Logico;4=Fecha;5=Memo"
	#define STR0016 "Parametro no modificable en la version Pyme."
	#define STR0017 "Cont. Ing"
	#define STR0018 "Cont. Esp"
#else
	#ifdef ENGLISH
		#define STR0001 "View Parameter - "
		#define STR0002 "New Parameter"
		#define STR0003 "Edit Parameter - "
		#define STR0004 "Delete Parameter - "
		#define STR0005 "Branch"
		#define STR0006 "Type"
		#define STR0007 "Cont. Per"
		#define STR0008 "Description"
		#define STR0009 "Descrip.Cont."
		#define STR0010 "Desc. Span."
		#define STR0011 "Desc. Engl."
		#define STR0012 "Informations"
		#define STR0013 "Description"
		#define STR0014 "Var. Name"
		#define STR0015 "1=Character;2=Numeric;3=Logical;4=Date;5=Memo"
		#define STR0016 "Parameter cannot be edited in Pyme version."
		#define STR0017 "Cont. Eng"
		#define STR0018 "Cont. Spa"
	#else
		Static STR0001 := "Visualizar Parametro - "
		Static STR0002 := "Novo Parametro"
		Static STR0003 := "Editar Parametro - "
		Static STR0004 := "Excluir Parametro - "
		#define STR0005  "Filial"
		#define STR0006  "Tipo"
		#define STR0007  "Cont. Por"
		Static STR0008 := "Descricao"
		Static STR0009 := "Cont.Descric"
		#define STR0010  "Desc. Esp."
		Static STR0011 := "Desc. Ingles"
		Static STR0012 := "Informacoes"
		Static STR0013 := "Descricao"
		Static STR0014 := "Nome da Var."
		Static STR0015 := "1=Caracter;2=Numérico;3=Lógico;4=Data;5=Memo"
		Static STR0016 := "Parametro nao alteravel na versao Pyme."
		#define STR0017  "Cont. Ing"
		#define STR0018  "Cont. Esp"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Visualizar parâmetro - "
			STR0002 := "Novo Parâmetro"
			STR0003 := "Editar parâmetro - "
			STR0004 := "Excluir parâmetro - "
			STR0008 := "Descrição"
			STR0009 := "Cont.descric"
			STR0011 := "Desc. Inglês"
			STR0012 := "Informações"
			STR0013 := "Descrição"
			STR0014 := "Nome Da Var."
			STR0015 := "1=caracter;2=numérico;3=lógico;4=data;5=memo"
			STR0016 := "Parâmetro Não Alterável Na Versão Pyme."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
