#ifdef SPANISH
	#define STR0001 "Archivo de linea no encontrado."
	#define STR0002 "Numeracion ya utilizada para esta serie."
	#define STR0003 "No es posible asiento de envio sin que se informe a la agencia."
	#define STR0004 "Rango informado no disponible en la Matriz para esta serie."
	#define STR0005 "Numero inicial debe ser el primero disponible para esta serie."
	#define STR0006 "Numero final no puede ser mayor que el numero final disponible para esta serie."
	#define STR0007 "No se encontro el envio para esta devolucion."
	#define STR0008 "Rango de numeracion invalida para entrada."
	#define STR0009 "No se puede revertir la entrada.  Hay envios/devoluciones para esta serie."
	#define STR0010 "No se puede revertir envio.  Hay devoluciones para esta serie."
	#define STR0011 "No se puede revertir devolucion. Hay envio para esta devolucion."
	#define STR0012 "No se puede revertir devolucion. No se encontro rango."
	#define STR0013 "Agencia no puede ser vacio para envio/devolucion."
	#define STR0014 "Rango de numeracion no esta disponible para entregarse al tercero."
	#define STR0015 "Rango de numeracion no esta disponible para entregarse al tercero."
	#define STR0016 "Rango de numeracion no esta disponible para entregarse al tercero."
	#define STR0017 "Rango de numeracion no esta mas disponible en la agencia."
	#define STR0018 "No se encontro localidad de origen en este Horario."
	#define STR0019 "Se encontro horario para Localidad de inicio, pero no las SECCIONES."
	#define STR0020 "Esta linea no tiene frecuencia de horario el domingo."
	#define STR0021 "Esta linea no tiene frecuencia de horario el lunes."
	#define STR0022 "Esta linea no tiene frecuencia de horario el martes."
	#define STR0023 "Esta linea no tiene frecuencia de horario el miercoles."
	#define STR0024 "Esta linea no tiene frecuencia de horario el jueves."
	#define STR0025 "Esta linea no tiene frecuencia de horario el viernes."
	#define STR0026 "Esta linea no tiene frecuencia de horario el sabado."
	#define STR0027 "Fecha inicial y fecha final de la vigencia no pueden estar en blanco"
	#define STR0028 "�Desea implantar nuevo trayecto en el recorrido de la Linea?"
	#define STR0029 "Seccion/Linea"
	#define STR0030 "La localidad inicial de la secci�n debe ser igual a la localidad inicial de la linea que se selecciono."
	#define STR0031 "La localidad final de la seccion debe ser igual a la localidad final de la linea seleccionada."
	#define STR0032 "Fecha final de las vigencias registradas no puede ser inferior la fecha inicial, informe una fecha posterior."
#else
	#ifdef ENGLISH
		#define STR0001 "Row Register not found."
		#define STR0002 "Numbering already used for this series."
		#define STR0003 "Remittance transaction not possible without entered Branch."
		#define STR0004 "Entered Range not available on Matrix for this series."
		#define STR0005 "Initial number must the first available for this series."
		#define STR0006 "Final number cannot be greater than final number available for this series."
		#define STR0007 "A remittance for this return was not found."
		#define STR0008 "Numbering range invalid for Inflow."
		#define STR0009 "Entry cannot be reversed. There are remittances/return for this series."
		#define STR0010 "Remittance cannot be reversed. There are returns for this series."
		#define STR0011 "Return cannot be reversed. There are remittances for this return."
		#define STR0012 "Return cannot be reversed. Range not found."
		#define STR0013 "Branch cannot be empty for remittance/return."
		#define STR0014 "Numbering range is not available to be delivered to third party."
		#define STR0015 "Numbering range is not available to be returned to the branch."
		#define STR0016 "Numbering range is not available to be returned by the third party to the branch."
		#define STR0017 "Numbering range is no longer available at the branch."
		#define STR0018 "Origin Location not found on Time."
		#define STR0019 "Time found for Start Location, but not SECTIONS."
		#define STR0020 "This Row has no Time Frequency on Sunday."
		#define STR0021 "This Row has no Time Frequency on Monday."
		#define STR0022 "This Row has no Time Frequency on Tuesday."
		#define STR0023 "This Row has no Time Frequency on Wednesday."
		#define STR0024 "This Row has no Time Frequency on Thursday."
		#define STR0025 "This Row has no Time Frequency on Friday."
		#define STR0026 "This Row has no Time Frequency on Saturday."
		#define STR0027 "Start date and End data validity cannot be blank"
		#define STR0028 "Implement new path on Row trail?"
		#define STR0029 "Section/Row"
		#define STR0030 "Section initial location must be equal to initial location of selected row."
		#define STR0031 "Section final location must be equal to final location of selected row."
		#define STR0032 "End date registered validity cannot be lower than initial date, enter a later date."
	#else
		#define STR0001 "Cadastro de Linha n�o encontrado."
		#define STR0002 "Numera��o j� utilizada para esta s�rie."
		#define STR0003 "N�o � poss�vel lan�amento de Remessa sem informar a Ag�ncia."
		#define STR0004 "Faixa informada n�o dispon�vel na Matriz para esta s�rie."
		#define STR0005 "N�mero inicial deve ser o primeiro dispon�vel para esta s�rie."
		#define STR0006 "N�mero final n�o pode ser maior que o n�mero final dispon�vel para esta s�rie."
		#define STR0007 "N�o foi encontrada a remessa para esta devolu��o."
		#define STR0008 "Faixa de Numera��o inv�lida para Entrada."
		#define STR0009 "Entrada n�o pode ser estornada. Existem remessas/devolu��es para esta s�rie."
		#define STR0010 "Remessa n�o pode ser estornada. Existem devolu��es para esta s�rie."
		#define STR0011 "Devolu��o n�o pode ser estornada. Exite remessa para esta devolu��o."
		#define STR0012 "Devolu��o n�o pode ser estornada. Faixa n�o foi encontrada."
		#define STR0013 "Ag�ncia n�o pode ser vazio para remessa/devolu��o."
		#define STR0014 "Faixa de numera��o n�o est� dispon�vel para ser entregue ao terceiro."
		#define STR0015 "Faixa de numera��o n�o est� dispon�vel para ser devolvida � ag�ncia."
		#define STR0016 "Faixa de numera��o n�o est� dispon�vel para ser devolvido pelo terceiro � ag�ncia."
		#define STR0017 "Faixa de numera��o n�o est� mais dispon�vel na ag�ncia."
		#define STR0018 "Localidade de Origem n�o encontrada neste Hor�rio."
		#define STR0019 "Hor�rio encontrado para Localidade de In�cio mas n�o as SE��ES."
		#define STR0020 "Essa Linha n�o tem Frequ�ncia de Hor�rio no Domingo."
		#define STR0021 "Essa Linha n�o tem Frequ�ncia de Hor�rio na Segunda-Feira."
		#define STR0022 "Essa Linha n�o tem Frequ�ncia de Hor�rio na Ter�a-Feira."
		#define STR0023 "Essa Linha n�o tem Frequ�ncia de Hor�rio na Quarta-Feira."
		#define STR0024 "Essa Linha n�o tem Frequ�ncia de Hor�rio na Quinta-Feira."
		#define STR0025 "Essa Linha n�o tem Frequ�ncia de Hor�rio na Sexta-Feira."
		#define STR0026 "Essa Linha n�o tem Frequ�ncia de Hor�rio no S�bado."
		#define STR0027 "Data Inicial e Data Final da vig�ncia n�o podem estar em branco"
		#define STR0028 "Deseja implantar novo trajeto no percurso da Linha?"
		#define STR0029 "Secao/Linha"
		#define STR0030 "A localidade inicial da se��o deve ser igual a localidade inicial da Linha selecionada."
		#define STR0031 "A localidade final da se��o deve ser igual a localidade final da Linha selecionada."
		#define STR0032 "Data Final das vig�ncias cadastradas n�o pode ser inferior a data inicial, informe uma data posterior."
	#endif
#endif
