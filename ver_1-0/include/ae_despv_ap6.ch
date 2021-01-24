#ifdef SPANISH
	#define STR0001 "Rendicion de Cuentas"
	#define STR0002 "Busqueda"
	#define STR0003 "Visualiza"
	#define STR0004 "Gastos"
	#define STR0005 "Suelto"
	#define STR0006 "Aprobar"
	#define STR0007 "Cierre"
	#define STR0008 "Aprob.Atraso"
	#define STR0009 "Mantenimiento"
	#define STR0010 "Imprime"
	#define STR0011 "Leyenda"
	#define STR0012 "Anular"
	#define STR0013 "Realmente desea anular la prestacion de cuentas suelta?"
	#define STR0014 "Este registro no es un gasto suelto."
	#define STR0015 "Borrar"
	#define STR0016 "Realmente desea anular la prestacion de cuentas suelta?"
	#define STR0017 "Esta solicitud ya esta anulada, realmente desea borrarla?"
	#define STR0018 "�El titulo generado en la inclusion de la prestacion de cuentas esta dado de baja!"
	#define STR0019 "La cuota no se podra anular mientras el titulo este dado de baja."
	#define STR0020 "La cuota no se podra borrar mientras el titulo este dado de baja."
#else
	#ifdef ENGLISH
		#define STR0001 "Rendering of accounts"
		#define STR0002 "Search"
		#define STR0003 "View"
		#define STR0004 "Expenses"
		#define STR0005 "Detached"
		#define STR0006 "Release"
		#define STR0007 "Closing"
		#define STR0008 "Delay Release"
		#define STR0009 "Maintenance"
		#define STR0010 "Print"
		#define STR0011 "Caption"
		#define STR0012 "Cancel"
		#define STR0013 "Do you really wish to cancel the separate settlement of accounts? "
		#define STR0014 "This record is not a spare expense."
		#define STR0015 "Delete"
		#define STR0016 "Do you really wish to delete the separate settlement of accounts? "
		#define STR0017 "This request is already cancelled. Do you really wish to delete it?"
		#define STR0018 "O t�tulo gerado na inclus�o da presta��o de contas est� baixado!"
		#define STR0019 "A presta��o n�o poder� ser cancelada enquanto o t�tulo estiver baixado."
		#define STR0020 "A presta��o n�o poder� ser exclu�da enquanto o t�tulo estiver baixado."
	#else
		#define STR0001 "Presta��o de Contas"
		#define STR0002 "Pesquisa"
		#define STR0003 "Visualiza"
		#define STR0004 "Despesas"
		#define STR0005 "Avulso"
		#define STR0006 "Liberar"
		#define STR0007 "Fechamento"
		#define STR0008 "Lib.Atraso"
		#define STR0009 "Manuten��o"
		#define STR0010 "Imprime"
		#define STR0011 "Legenda"
		#define STR0012 "Cancelar"
		#define STR0013 "Deseja realmente cancelar a presta��o de contas avulsa?"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Este registo n�o trata-se de uma despesa avulsa.", "Este registro nao trata-se de uma despesa avulsa." )
		#define STR0015 "Excluir"
		#define STR0016 "Deseja realmente excluir a presta��o de contas avulsa?"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Esta solicita��o j� est� cancelada. Deseja realmente exclu�-la?", "Esta solicita�ao ja esta cancelada deseja realmente exclui-la?" )
		#define STR0018 "O t�tulo gerado na inclus�o da presta��o de contas est� baixado!"
		#define STR0019 "A presta��o n�o poder� ser cancelada enquanto o t�tulo estiver baixado."
		#define STR0020 "A presta��o n�o poder� ser exclu�da enquanto o t�tulo estiver baixado."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0012 := "Cancelar"
			STR0013 := "Deseja realmente cancelar a presta��o de contas avulsa?"
			STR0014 := "Este registro nao trata-se de uma despesa avulsa."
			STR0015 := "Excluir"
			STR0016 := "Deseja realmente excluir a presta��o de contas avulsa?"
			STR0017 := "Esta solicita�ao ja esta cancelada deseja realmente exclui-la?"
		ElseIf cPaisLoc == "PTG"
			STR0012 := "Cancelar"
			STR0013 := "Deseja realmente cancelar a presta��o de contas avulsa?"
			STR0014 := "Este registro nao trata-se de uma despesa avulsa."
			STR0015 := "Excluir"
			STR0016 := "Deseja realmente excluir a presta��o de contas avulsa?"
			STR0017 := "Esta solicita�ao ja esta cancelada deseja realmente exclui-la?"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
