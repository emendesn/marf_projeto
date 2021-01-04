#ifdef SPANISH
	#define STR0001 "¿Desea Actualizar el Login del Archivo de Viaje, para las Rendiciones de Cuentas ?"
	#define STR0002 "Atencion"
	#define STR0003 "Actualizando Login, Espere..."
	#define STR0004 "¡Actualizacion del Login, finalizada con exito !"
#else
	#ifdef ENGLISH
		#define STR0001 "Do you want to update Login of Trips File, for rendering of accounts?"
		#define STR0002 "Attention"
		#define STR0003 "Updating Login, Wait..."
		#define STR0004 "Login update successfully concluded!"
	#else
		Static STR0001 := "Deseja Atualizar o Login do Cadastro de Viagem, para as Prestações de Contas ?"
		#define STR0002  "Atenção"
		Static STR0003 := "Atualizando Login, Aguarde..."
		Static STR0004 := "Atualização do Login, Concluida com Sucesso !"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Deseja actualizar o login do registo de viagem para as prestações de contas ?"
			STR0003 := "A actualizar Login, Aguarde..."
			STR0004 := "Actualização do login concluída com successo !"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Deseja actualizar o login do registo de viagem para as prestações de contas ?"
			STR0003 := "A actualizar Login, Aguarde..."
			STR0004 := "Actualização do login concluída com successo !"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
