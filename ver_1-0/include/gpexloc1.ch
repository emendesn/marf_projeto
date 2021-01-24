#ifdef SPANISH
	#define STR0001 "El Digito identificador "
	#define STR0002 "informado en el codigo NIF no es valido"
	#define STR0003 "El codigo NIF informado no es valido. ¿Este codigo sera aceptado?"
	#define STR0004 "Atencion"
	#define STR0005 "¡Numero  de curp invalido! ¿Desea mantener el numero  definido?"
	#define STR0006 "¡No fue posible validar el numero de RFC!"
	#define STR0007 "¡Numero  del rfc invalido! ¿Desea mantener el numero  definido?"
	#define STR0008 "¡Numero de CUIL existe! ¿Desea mantener el numero definido?"
	#define STR0009 "Borrar el calculo del (de los) siguiente(s) procedimiento(s):"
	#define STR0010 If( cPaisLoc == "ANG", "Para la Sucursal/Colaborador:", If( cPaisLoc == "CHI", "Para a Filial/Funcionário:", If( cPaisLoc == "COL", "Para a Filial/Funcionário:", If( cPaisLoc == "COS", "Para a Filial/Funcionário:", If( cPaisLoc == "DOM", "Para a Filial/Funcionário:", If( cPaisLoc == "EQU", "Para a Filial/Funcionário:", If( cPaisLoc == "EUA", "Para a Filial/Funcionário:", If( cPaisLoc == "HAI", "Para a Filial/Funcionário:", If( cPaisLoc == "MEX", "Para a Filial/Funcionário:", If( cPaisLoc == "PAD", "Para a Filial/Funcionário:", If( cPaisLoc == "PAN", "Para a Filial/Funcionário:", If( cPaisLoc == "PAR", "Para a Filial/Funcionário:", If( cPaisLoc == "PER", "Para a Filial/Funcionário:", If( cPaisLoc == "POR", "Para a Filial/Funcionário:", If( cPaisLoc == "PTG", "Para a Filial/Colaborador:", If( cPaisLoc == "SAL", "Para a Filial/Funcionário:", If( cPaisLoc == "TRI", "Para a Filial/Funcionário:", If( cPaisLoc == "URU", "Para a Filial/Funcionário:", If( cPaisLoc == "VEN", "Para a Filial/Funcionário:", "Para la Sucursal/Empleado:" ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
#else
	#ifdef ENGLISH
		#define STR0001 "The identifier Digit "
		#define STR0002 "entered in NIF code is not valid"
		#define STR0003 "Entered NIF code is not valid. Is this code accepted?"
		#define STR0004 "Attention"
		#define STR0005 "Invalid curp  number !! keep the defined number?"
		#define STR0006 "Unable to validate the RFC number!"
		#define STR0007 "Invalid  rfc number !! keep the defined  number?"
		#define STR0008 "CUIL Number already exists! Keep the defined number?"
		#define STR0009 "Delete calculation of the following routes:"
		#define STR0010 "For the Branch/Employee:"
	#else
		#define STR0001 "O Dígito identificador "
		#define STR0002 "informado no código NIF não é válido"
		#define STR0003 "O código NIF informado não é válido. Este código será aceito?"
		#define STR0004 "Atenção"
		#define STR0005 "Número  do curp inválido !! deseja manter o número  definido?"
		#define STR0006 "Não foi possível validar o número de RFC!"
		#define STR0007 "Número  do rfc inválido !! deseja manter o número  definido?"
		#define STR0008 "Número de CUIL já existe! Deseja manter o número definido?"
		#define STR0009 "Apagar o cálculo do(s) seguinte(s) roteiro(s):"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Para a Filial/Colaborador:", "Para a Filial/Funcionário:" )
	#endif
#endif
