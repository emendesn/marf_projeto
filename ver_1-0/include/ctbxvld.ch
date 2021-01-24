#ifdef SPANISH
	#define STR0001 "Fecha del asiento mayor que la fecha final de existencia del ente"
	#define STR0002 "Moneda"
	#define STR0003 "Fecha"
	#define STR0004 "bloqueada"
	#define STR0005 "Verifique bloqueo(s) o seleccione moneda(s) y rango de fecha no bloqueados."
	#define STR0006 "Registro de Monedas."
	#define STR0007 "Existen fechas bloqueadas en el periodo para la(s) moneda(s) seleccionadas."
	#define STR0008 "Visualizar?"
	#define STR0009 "Registro de Cambio de Monedas"
	#define STR0010 "Verifique bloqueo(s) o seleccione moneda(s) y rango de fecha no bloqueados."
	#define STR0011 "Monedas con Fechas Bloqueadas - "
	#define STR0012 "Registro de Cambio de Monedas"
	#define STR0013 "El rango de fechas informado no podra procesarse. "
	#define STR0014 "Verifique el rango de fechas o los calendarios en el rango."
	#define STR0015 ", el periodo "
	#define STR0016 " del calendario "
	#define STR0017 " esta Bloqueado/Encerrado."
	#define STR0018 "No se puede modificar el tipo de asiento 4 para otro tipo. "
	#define STR0019 "Es necesario borrar esa linea e incluir una nueva."
	#define STR0020 "No se puede modificar el tipo de asiento para tipo 5 o 6. "
	#define STR0021 "O todas las cuentas del prorrateo estan en ceros"
	#define STR0022 "Debito"
	#define STR0023 "Credito"
	#define STR0024 "Obligatorio rellenado del siguiente Ente Contable: "
	#define STR0025 "El centro de costo no permite asientos con el Ente: "
	#define STR0026 "El item no permite asiento con el ente "
	#define STR0027 "No se puede modificar/excluir documento generado por el computo de ganancias/perdidas.."
	#define STR0028 "Favor rodar la rutina de reembolso de computo de ganancias/perdidas.."
	#define STR0029 "No se puede utilizar una LP definida como punto de asiento"
	#define STR0030 "No se informo el Plan Gerencial del Libro. Verifique."
	#define STR0031 "�Existe una continuacion de historial vinculada a la linea de asiento anterior!"
	#define STR0032 "No se podra recuperar esta linea, excluya primero el historial de la siguiente linea para continuar."
	#define STR0033 "No sera posible restaurar esta continuacion de historial. La secuencia de asiento anterior (linea anterior) es diferente de la secuencia de esta linea."
	#define STR0034 "Para restaurar esta continuacion de historial es necesario estar restaurando el registro de Debito o Credito borrado."
	#define STR0035 "�Ya existe un periodo de vigencia con la fecha informada!"
	#define STR0036 "�La fecha final del periodo no puede ser menor que la inicial!"
	#define STR0037 "�Atencion!"
	#define STR0038 "Utilice el historial inteligente solamente en la ultima linea o por medio del Registro Manual"
	#define STR0039 "Numero de lineas de prorrateo excede la cantidad maxima de lineas permitida por documento."
	#define STR0040 "Tipo de saldo no valido para esta opera��o!"
	#define STR0041 "Cuenta no encontrada en el registro de empleado"
	#define STR0042 'Tipo de saldo: "'
	#define STR0043 '" bloqueado para la moneda: "'
	#define STR0044 '" en este periodo. Verifique el estatus del vinculo Moneda vs. Calendario vs. Tp. Saldo.'
	#define STR0045 "Atencion"
	#define STR0046 "Usuario esta configurado para efectuar movimiento independiente del Control Contable."
	#define STR0047 "Cta Debito: "
	#define STR0048 "Cta Credito: "
	#define STR0049 " no esta activa en la rutina de Controles Contables"
	#define STR0050 "no esta configurada para aceptar registros manuales. "
	#define STR0051 "Lote/Sublote no esta vinculado con la cuenta contable. "
	#define STR0052 "Diario no esta vinculado con la cuenta contable. "
	#define STR0053 "La Cuenta Contable no esta vinculada al archivo de Control Contable."
	#define STR0054 "El codigo del libro contable informado es invalido."
	#define STR0055 "El Libro Contable informado no se configuro con una Vision de Gestion. Verifique sus configuraciones."
	#define STR0056 "Operacion bloqueada. El asiento contable esta procesandose por el reprocesamiento de saldo en cola."
	#define STR0057 "Linea"
	#define STR0058 "No es posible seleccionar este centro de costo."
	#define STR0059 "Valor maximo permitido en el asiento: 999.999.999,99. La linea "
	#define STR0060 " del asiento se debe corregir."
	#define STR0061 "A data de fim de exist�ncia n�o pode ser menor que a data de inicio de exist�ncia"
	#define STR0062 "Conta localizada no cadastro de amarra��es (Tratamento por Exce��o)"
	#define STR0063 "Utilice solamente el historial inteligente en la ultima linea o por medio del Asto. Manual"
	#define STR0064 "�Atencion!"
	#define STR0065 "Calendario contable bloqueado. Verifique el proceso."
	#define STR0066 "No existe este historial registrado. Verifique"
	#define STR0067 "No se permite utilizar la visi�n de gesti�n y el plan referencial en la misma Config. Libro."
	#define STR0068 "Versi�n sin informar. Es obligatorio informar el plan referencial y la versi�n."
	#define STR0069 "Plan referencial no informado. Cumplimentaci�n obligatoria del plan referencial y versi�n."
	#define STR0070 "Plan referencial/versi�n no registrado."
	#define STR0071 "No se permite utilizar el plan referencial que tenga m�s de una cuenta referencial vinculada a una misma cuenta contable."
#else
	#ifdef ENGLISH
		#define STR0001 "Entry date after final date of entity existence."
		#define STR0002 "Currency"
		#define STR0003 "Date"
		#define STR0004 "blocked"
		#define STR0005 "Check blockage(s) or select currency(ies) and date interval not blocked."
		#define STR0006 "Currency Register"
		#define STR0007 "There are dates blocked in the period for currency(ies) selected."
		#define STR0008 "View?"
		#define STR0009 "Register of Currency Exchange"
		#define STR0010 "Check blockage(s) or select currency(ies) and date interval not blocked."
		#define STR0011 "Currencies with Dates Blocked - "
		#define STR0012 "Register of Currency Exchange"
		#define STR0013 "Date interval indicated cannot be processed. "
		#define STR0014 "Check date interval or calendars in the interval."
		#define STR0015 ", period "
		#define STR0016 " of calendar "
		#define STR0017 " is Blocked/Closed."
		#define STR0018 "Entry 4 cannot be changed to another type. "
		#define STR0019 "This row must be deleted and a new one must be added."
		#define STR0020 "Type of entry cannot be changed to type 5 or 6. "
		#define STR0021 "Or all apportionment accounts will be zeroed."
		#define STR0022 "Debit"
		#define STR0023 "Credit"
		#define STR0024 "Filling out the following Accounting Entity is mandatory: "
		#define STR0025 "Cost center does not allow entries with the Entity: "
		#define STR0026 "The item does not enable entry with the entity. "
		#define STR0027 "Document generated by calculation of profits/losses cannot be changed/deleted."
		#define STR0028 "Please, run the routine of reversal of profit/loss calculation."
		#define STR0029 "An LP defined as point of entry cannot be used."
		#define STR0030 "Book Management Plan was not indicated. Check it out"
		#define STR0031 "There is a history continuation related to the previous entry row!"
		#define STR0032 "This row cannot be recovered. You must first delete history of the row below so you can continue."
		#define STR0033 "You cannot recover this history continuation. The previous entry sequence (row above) is different from the sequence of this row."
		#define STR0034 "To recover this history continuation you must restore the Debit or Credit record deleted."
		#define STR0035 "There is a period using the date entered!"
		#define STR0036 "Final date cannot be smaller than initial date. "
		#define STR0037 "Attention!"
		#define STR0038 "Only use intelligent history in the last row or through Manual Entry"
		#define STR0039 "Number of apportionment rows exceeds the maximum number of rows allowed per document."
		#define STR0040 "Balance type not valid for this operation!"
		#define STR0041 "Account not found in Binding Register."
		#define STR0042 'Balance Type: "'
		#define STR0043 '" blocked for Currency: "'
		#define STR0044 '" in this period. Check binding Currency x Calendar x Balance Type status.'
		#define STR0045 "Attention"
		#define STR0046 "User set to perform transaction irrespective of Accounting Control."
		#define STR0047 "Debit Acc.: "
		#define STR0048 "Credit Acc.: "
		#define STR0049 " is not activated in Accounting Controls routine"
		#define STR0050 "is not set to accept manual entries. "
		#define STR0051 "Batch/Sub-Batch is not linked to ledger account. "
		#define STR0052 "Journal is not linked to ledger account. "
		#define STR0053 "Ledger account is not linked to Accounting Control register."
		#define STR0054 "Accounting record code is invalid."
		#define STR0055 "Accounting Record is not set as Managerial View. Check configurations."
		#define STR0056 "Operation Blocked. The accounting transaction is being processed by the balance reprocessing in queue."
		#define STR0057 "Row"
		#define STR0058 "It was not possible to select this cost center."
		#define STR0059 "Maximum allowed value on transaction: 999,999,999.99. Row "
		#define STR0060 " from transaction must be corrected."
		#define STR0061 "Existence end date cannot be earlier than the existence start date"
		#define STR0062 "Account located on the bindings record (Treatment by Exception)"
		#define STR0063 "Only use intelligent history in the last row or through Entry Manual"
		#define STR0064 "Attention!!"
		#define STR0065 "Accounting Calendar Blocked. Check the process."
		#define STR0066 "History not registered. Check it"
		#define STR0067 "Unable to use managerial view and referential plan on the same book config."
		#define STR0068 "Version not completed. You must complete the referential plan and version."
		#define STR0069 "Referential plan not completed. You must complete the referential plan and version."
		#define STR0070 "Referential plan /version not registered."
		#define STR0071 "Unable to use referential plan that has more than one referential account associated to a ledger account."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Data do lan�amento maior do que a data final de exist�ncia da entidade", "Data do lancamento maior do que a data final de existencia da entidade" )
		#define STR0002 "Moeda"
		#define STR0003 "Data"
		#define STR0004 "bloqueada"
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Verifique bloqueio(s), ou seleccione moeda(s) e intervalo de data n�o bloqueados.", "Verifique bloqueio(s), ou selecione moeda(s) e intervalo de data n�o bloqueados." )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Registo de Moedas.", "Cadastro de Moedas." )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Existem datas bloqueadas no per�odo para a(s) moeda(s) seleccionadas.", "Existem datas bloqueadas no per�odo para a(s) moeda(s) selecionadas." )
		#define STR0008 "Visualizar ?"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Registo de C�mbio de Moedas", "Cadastro de Cambio de Moedas" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Verifique bloqueio(s), ou seleccione moeda(s) e intervalo de datas n�o bloqueados.", "Verifique bloqueio(s), ou selecione moeda(s) e intervalo de datas n�o bloqueados." )
		#define STR0011 "Moedas com Datas Bloqueadas - "
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Registo de C�mbio de Moedas", "Cadastro de Cambio de Moedas" )
		#define STR0013 "O intervalo de datas informadas n�o poder� ser processado. "
		#define STR0014 "Verifique o intervalo de datas ou os calend�rios no intervalo."
		#define STR0015 If( cPaisLoc $ "ANG|PTG", ", o per�odo ", ", o periodo " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", " do calend�rio ", " do calendario " )
		#define STR0017 " est� Bloqueado/Encerrado."
		#define STR0018 "Nao � poss�vel alterar o tipo de lan�amento 4 para outro tipo. "
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "� necess�rio apagar essa linha e incluir uma nova.", "� necess�rio deletar essa linha e incluir uma nova." )
		#define STR0020 "Nao � poss�vel alterar o tipo de lan�amento para tipo 5 ou 6. "
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Ou todas as contas do rateio est�o zeradas.", "Ou todas as contas do rateio estao zeradas" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "D�bito", "Debito" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Cr�dito", "Credito" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Obrigat�rio preenchimento da seguinte Entidade Cont�bil: ", "Obrigatorio preenchimento da seguinte Entidade Contabil: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "O centro de custo n�o permite lan�amentos com a Entidade: ", "O centro de custo nao permite lancamentos com a Entidade: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "O elemento n�o permite lan�amento com a entidade ", "O item nao permite lancamento com a entidade " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel a altera��o/elimina��o de documento gerado pelo apuro de lucros/perdas..", "Nao � possivel a alteracao/exclusao de documento gerado pela apuracao de lucros/perdas.." )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Favor rodar o procedimento de estorno de apuro de lucros/perdas..", "Favor rodar a rotina de estorno de apuracao de lucros/perdas.." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "N�o � poss�vel utilizar uma LP definida como ponto de lan�amento", "N�o � possivel utilizar uma LP definida como ponto de lan�amento" )
		#define STR0030 "Plano Gerencial do Livro n�o foi informado. Verifique."
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Existe uma continua��o de hist�rico vinculada a linha de lan�amento anterior!", "Existe uma continua��o de historico vinculada a linha de lan�amento anterior!" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "N�o ser� possivel recuperar essa linha, elimine antes o hist�rico da linha abaixo para continuar.", "N�o ser� possivel recuperar essa linha, exclua primeiro o historico da linha abaixo para continuar." )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "N�o ser� poss�vel restaurar essa continua��o de hist�rico. A sequ�ncia de lan�amento anterior (linha acima) � diferente da sequ�ncia dessa linha.", "N�o ser� possivel restaurar essa continua��o de historico. A sequencia de lan�amento anterior (linha acima) � diferente da sequencia dessa linha." )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Para restaurar esta continua��o de hist�rico � necess�rio restaurar o registo de D�bito ou Cr�dito deletado.", "Para restaurar esta continuacao de historico e necessario estar restaurando o registro de Debito ou Credito deletado." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "J� existe um per�odo de vig�ncia com a data informada!", "J� existe um per�odo de vigencia com a data informada!" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "A data final do per�odo n�o pode ser menor que a inicial!", "A data final do periodo nao pode ser menor que a inicial!" )
		#define STR0037 "Aten��o!"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Utilize o hist�rico inteligente somente na �ltima linha ou atrav�s do Lan�. Manual", "Utilize o historico inteligente somente na ultima linha ou atraves do Lanc. Manual" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "N�mero de linhas do rateio excede a quantidade m�xima de linhas permitida por documento.", "Numero de linhas do rateio excede a quantidade maxima de linhas permitida por documento." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Tipo de saldo inv�lido pra essa opera��o.", "Tipo de saldo inv�lido pra essa opera��o!" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Conta n�o localizada no registo de amarra��es.", "Conta n�o localizado no cadastro de amarra��es." )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", 'Tipo de saldo: "', 'Tipo de Saldo: "' )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", '" bloqueado para a moeda: "', '" bloqueado para a Moeda: "' )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", '" neste per�odo. Verifique o estado do v�nculo Moeda X Calend�rio X Tp. Saldo.', '" neste periodo. Verifique o status da amarra��o Moeda X Calend�rio X Tp. Saldo.' )
		#define STR0045 "Aten��o"
		#define STR0046 "Usu�rio est� configurado para efetuar movimenta��o independente do Controle Cont�bil."
		#define STR0047 "Cta Debito: "
		#define STR0048 "Cta Cr�dito: "
		#define STR0049 " n�o est� ativa na rotina de Controles Cont�beis"
		#define STR0050 "n�o est� configurada para aceitar lan�amentos manuais. "
		#define STR0051 "Lote/Sublote n�o est� vinculado com a conta cont�bil. "
		#define STR0052 "Di�rio n�o est� vinculado com a conta cont�bil. "
		#define STR0053 "Conta cont�bil n�o est� vinculada no cadastro de Controle Cont�bil."
		#define STR0054 "O c�digo do livro cont�bil informado � inv�lido."
		#define STR0055 "O Livro Cont�bil informado n�o est� configurado com uma Vis�o Gerencial. Verifique suas configura��es."
		#define STR0056 "Opera��o Bloqueada. O lan�amento cont�bil est� sendo processado pelo reprocessamento de saldo em fila."
		#define STR0057 "Linha"
		#define STR0058 "N�o � possivel selecionar este centro de custo."
		#define STR0059 "Valor m�ximo permitido no lan�amento: 999.999.999,99. A linha "
		#define STR0060 " do lan�amento deve ser corrigida."
		#define STR0061 "A data de fim de exist�ncia n�o pode ser menor que a data de inicio de exist�ncia"
		#define STR0062 "Conta localizada no cadastro de amarra��es (Tratamento por Exce��o)"
		#define STR0063 "Utilize o historico inteligente somente na ultima linha ou atraves do Lanc. Manual"
		#define STR0064 "Atencao!!"
		#define STR0065 "Calend�rio Cont�bil Bloqueado. Verfique o processo."
		#define STR0066 "N�o existe este historico cadastrado. Verifique"
		#define STR0067 "N�o � permitido utilizar vis�o gerencial e plano referencial na mesma config. livro."
		#define STR0068 "Vers�o n�o preenchida.Obrigat�rio preenchimento do plano referencial e vers�o."
		#define STR0069 "Plano referencial n�o preenchido. Obrigat�rio preenchimento do plano referencial e vers�o."
		#define STR0070 "Plano referencial /vers�o n�o cadastrado."
		#define STR0071 "N�o � permitido utilizar plano referencial que possua mais de uma conta referencial associada a uma mesma conta cont�bil."
	#endif
#endif
