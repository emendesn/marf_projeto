#ifdef SPANISH
	#define STR0001 "Rutina"
	#define STR0002 "Sucursal"
	#define STR0003 "Adapter EAI"
	#define STR0004 "Descripcion"
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar"
	#define STR0009 "Schema XML"
	#define STR0010 "Sucursal+Rutina"
	#define STR0011 "Sucursal del sistema"
	#define STR0012 "Rutina que se integrara"
	#define STR0013 "Id.Modelo"
	#define STR0014 "Codigo de identificacion Model"
	#define STR0015 "Descripcion de la Rutina"
	#define STR0016 "Envia"
	#define STR0017 "1=Si"
	#define STR0018 "2=No"
	#define STR0019 "Recibe"
	#define STR0020 "Directorio de destino"
	#define STR0021 "Generado archivo: "
	#define STR0022 "Met�do"
	#define STR0023 "1=S�ncrono"
	#define STR0024 "2=Ass�ncrono"
#else
	#ifdef ENGLISH
		#define STR0001 "Routine"
		#define STR0002 "Branch"
		#define STR0003 "Adapter EAI"
		#define STR0004 "Description"
		#define STR0005 "View"
		#define STR0006 "Add"
		#define STR0007 "Edit"
		#define STR0008 "Delete"
		#define STR0009 "Schema XML"
		#define STR0010 "Branch+Routine"
		#define STR0011 "System branch"
		#define STR0012 "Routine to be integrated"
		#define STR0013 "Model Id."
		#define STR0014 "Model identification code"
		#define STR0015 "Routine description"
		#define STR0016 "Send"
		#define STR0017 "1=Yes"
		#define STR0018 "2=No"
		#define STR0019 "Receive"
		#define STR0020 "Destination directory"
		#define STR0021 "File generated: "
		#define STR0022 "Met�do"
		#define STR0023 "1=S�ncrono"
		#define STR0024 "2=Ass�ncrono"
	#else
		Static STR0001 := "Rotina"
		Static STR0002 := "Filial"
		Static STR0003 := "Adapter EAI"
		Static STR0004 := "Descri��o"
		Static STR0005 := "Visualizar"
		Static STR0006 := "Incluir"
		Static STR0007 := "Alterar"
		Static STR0008 := "Excluir"
		Static STR0009 := "Schema XML"
		Static STR0010 := "Filial+Rotina"
		Static STR0011 := "Filial do sistema"
		Static STR0012 := "Rotina que ser� integrada"
		Static STR0013 := "Id.Modelo"
		Static STR0014 := "C�digo de idenficacao Model"
		Static STR0015 := "Descri��o da rotina"
		Static STR0016 := "Envia"
		Static STR0017 := "1=Sim"
		Static STR0018 := "2=N�o"
		Static STR0019 := "Recebe"
		Static STR0020 := "Diret�rio de destino"
		Static STR0021 := "Gerado arquivo: "
		Static STR0022 := "Met�do"
		Static STR0023 := "1=S�ncrono"
		Static STR0024 := "2=Ass�ncrono"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Rotina"
			STR0002 := "Filial"
			STR0003 := "Adapter EAI"
			STR0004 := "Descri��o"
			STR0005 := "Visualizar"
			STR0006 := "Incluir"
			STR0007 := "Alterar"
			STR0008 := "Excluir"
			STR0009 := "Schema XML"
			STR0010 := "Filial+Rotina"
			STR0011 := "Filial do sistema"
			STR0012 := "Rotina que ser� integrada"
			STR0013 := "Id.Modelo"
			STR0014 := "C�digo de idenficacao Model"
			STR0015 := "Descri��o da rotina"
			STR0016 := "Envia"
			STR0017 := "1=Sim"
			STR0018 := "2=N�o"
			STR0019 := "Recebe"
			STR0020 := "Diret�rio de destino"
			STR0021 := "Gerado arquivo: "
			STR0022 := "Met�do"
			STR0023 := "1=S�ncrono"
			STR0024 := "2=Ass�ncrono"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF