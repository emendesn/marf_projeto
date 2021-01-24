#ifdef SPANISH
	#define STR0001 "Este gasto esta vinculado al valor por kilometraje (parametro MV_KMI grabado en la solicitud), �desea calcular el total por este factor?"
	#define STR0002 "Este gasto esta vinculado al valor por kilometraje (parametro MV_KMI), �desea calcular el total por este factor?"
	#define STR0003 "�Gasto no Registrado !"
	#define STR0004 "Atencion"
#else
	#ifdef ENGLISH
		#define STR0001 "This expense is linked to the value per kilometers run (parameter MV_KMI saved in the request), do you wish to calculate the total amount by this factor?"
		#define STR0002 "This expense is linked to the value per kilometers run (parameter MV_KMI), do you wish to calculate the total amount by this factor?"
		#define STR0003 "Expense not registered !"
		#define STR0004 "Attention"
	#else
		Static STR0001 := "Esta despesa est� vinculada ao valor por quilometragem (par�metro MV_KMI gravado na solicita��o), deseja calcular o total por este fator?"
		#define STR0002  "Esta despesa est� vinculada ao valor por quilometragem (par�metro MV_KMI), deseja calcular o total por este fator?"
		Static STR0003 := "Despesa n�o Cadastrada !"
		#define STR0004  "Aten��o"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Esta despesa est� vinculada ao valor por quilometragem (par�metro MV_KMI gravado na solicita��o), deseja calcular o total por este factor?"
			STR0003 := "Despesa n�o registada !"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Esta despesa est� vinculada ao valor por quilometragem (par�metro MV_KMI gravado na solicita��o), deseja calcular o total por este factor?"
			STR0003 := "Despesa n�o registada !"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
