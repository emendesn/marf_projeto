#ifdef SPANISH
	#define STR0001 "¡Ninguna empresa seleccionada!"
	#define STR0002 "Borrando Integridad Referencial"
	#define STR0003 "Integridad Referencial Borrada"
	#define STR0004 "Borrando constraints de la empresa "
	#define STR0005 "Borrando procedures de la empresa "
	#define STR0006 "Borrando tabla de vinculos de la empresa "
	#define STR0007 "Borrando triggers de vinculos de la empresa "
	#define STR0008 "Esa opcion esta disponible apenas para ambiente TOPConnect."
#else
	#ifdef ENGLISH
		#define STR0001 "No company was selected !"
		#define STR0002 "Removing Referential Integrity"
		#define STR0003 "Removed Referential Integrity"
		#define STR0004 "Deleting company constraints "
		#define STR0005 "Deleting company procedures "
		#define STR0006 "Deleting company relationship table "
		#define STR0007 "Deleting company relationship triggers"
		#define STR0008 "This option is available only for TOPConnect environment."
	#else
		Static STR0001 := "Nenhuma empresa selecionada !"
		Static STR0002 := "Removendo Integridade Referencial"
		#define STR0003  "Integridade Referencial Removida"
		Static STR0004 := "Excluindo constraints da empresa "
		Static STR0005 := "Excluindo procedures da empresa "
		Static STR0006 := "Excluindo tabela de relacionamento da empresa "
		Static STR0007 := "Excluindo triggers de relacionamento da empresa "
		Static STR0008 := "Essa opção está disponível apenas para ambiente TOPConnect."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Nenhuma empresa seleccionada !"
			STR0002 := "A Remover Integridade Referencial"
			STR0004 := "A excluir restrições da empresa "
			STR0005 := "A excluir procedimentos da empresa "
			STR0006 := "A excluir tabela de relacionamento da empresa "
			STR0007 := "A excluir gatilhos de relacionamento da empresa "
			STR0008 := "Esta Opção Está Disponível Apenas Para Ambiente Topconnect."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
