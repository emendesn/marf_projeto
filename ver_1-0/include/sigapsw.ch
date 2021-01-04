#ifdef SPANISH
	#define STR0001 "Espere, convirtiendo archivo de Contrasenas..."
	#define STR0002 "Administradores"
	#define STR0003 "Contrasena informada debe contener letras y numeros. Por favor, informe una nueva contrasena."
	#define STR0004 "Archivo de contrasenas actualizandose por otra instancia"
	#define STR0005 "No fue posible asociar usuario."
	#define STR0006 "No fue posible remover"
	#define STR0007 "Espere, modificando estructura del archivo de usuarios..."
	#define STR0008 "¡Archivo de usuario en mantenimiento por otra instancia! Intente nuevamente."
#else
	#ifdef ENGLISH
		#define STR0001 "Wait, converting Passwords file..."
		#define STR0002 "Administrators "
		#define STR0003 "Password entered must contain letters and numbers. Please, enter a new password."
		#define STR0004 "Password file is being updated by another instance"
		#define STR0005 "User could not be associated."
		#define STR0006 "Removal was not possible"
		#define STR0007 "Wait, changing user structure file..."
		#define STR0008 "User file is maintenance by another instance! Try again."
	#else
		Static STR0001 := "Aguarde, convertendo arquivo de Senhas..."
		#define STR0002  "Administradores"
		Static STR0003 := "Senha informada deve conter letras e números. Por favor, informe uma nova senha."
		Static STR0004 := "Arquivo de senhas sendo atualizado por outra instância"
		Static STR0005 := "Não foi possível associar usuário."
		Static STR0006 := "Não foi possível remover"
		Static STR0007 := "Aguarde, alterando estrutura do arquivo de usuários..."
		Static STR0008 := "Arquivo de usuário em manutenção por outra instância! Tente novamente."
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Aguarde, A Converter Ficheiro De Palavras-passe..."
			STR0003 := "Palavra-passe escrita deve conter letras e números. por favor, introduza uma nova palavra-passe."
			STR0004 := "Arquivo de palavras passe sendo actualizado por outra instância."
			STR0005 := "Não foi possível associar o utilizador."
			STR0006 := "Não foi possível remover."
			STR0007 := "Aguarde, a alterar a estructura do registo do utilizador..."
			STR0008 := "Registo do utilizador em manutenção por outra instância! Tente novamente."
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
