#ifdef SPANISH
	#define STR0001 "Eligiendo Registros..."
	#define STR0002 "El impuesto "
	#define STR0003 " compone otra categoria. Por favor, para continuar con el proceso, arregle el parametro. "
	#define STR0004 "�Atencion! El pto de vta no es valido. �Tiene que estar entre 0001 y 9998!"
	#define STR0005 "Informe el Pto de Vta con 4 posiciones "
	#define STR0006 "y que estea incluido entre 0001 y  "
	#define STR0007 "9998, segun lo descrito en el layout.   "
	#define STR0008 "Informe el Pto de Vta"
	#define STR0009 "Informe cual archivo se generara:       "
	#define STR0010 "1 - Venta de bienes                   "
	#define STR0011 "2 - Prestac. de Servic."
	#define STR0012 "Tipo Generac"
	#define STR0013 "1 - Ventas"
	#define STR0014 "Codigos de impuestos que representan IVA."
	#define STR0015 "Imptos. Liquidados (IVA)"
	#define STR0016 "Codigos de impuestos que representan RNI."
	#define STR0017 "o no categorizados                     "
	#define STR0018 "Impuestos RNI o no categ."
	#define STR0019 "Codigos de impuestos que representan IB. "
	#define STR0020 "Ingresos Brutos"
	#define STR0021 "Codigos de impuestos que representan "
	#define STR0022 "la cobranza del IVA u otros pagos "
	#define STR0023 "referentes a Impuestos Nacionales.        "
	#define STR0024 "Imptos. Cobrab. o Nacionales"
	#define STR0025 "Codigos de impuestos que representan los "
	#define STR0026 "Impuestos Municipales.                  "
	#define STR0027 "Impuestos Municip."
	#define STR0028 "Codigos de impuestos que representan los "
	#define STR0029 "Impuestos Internos.                      "
	#define STR0030 "Impuestos Intern."
	#define STR0031 "Aqui se define, si es necesario volver a  "
	#define STR0032 "generar el archivo para documentos que "
	#define STR0033 "se enviaron, pero aun no se recibio"
	#define STR0034 "la resp. (retorno) de la AFIP. "
	#define STR0035 "Gen. Nvo. Arch."
	#define STR0036 "Si se selecc. la opcion 'No', el campo   "
	#define STR0037 " 'Fecha del comprobante' se rellenara con "
	#define STR0038 "ceros, sino, con la fecha de"
	#define STR0039 "emision de la factura              "
	#define STR0040 "Informe Fchs."
	#define STR0041 "1 - Si"
	#define STR0042 "2 - No"
#else
	#ifdef ENGLISH
		#define STR0001 "Selecting records ...    "
		#define STR0002 "The tax   "
		#define STR0003 " is a part of another category. Please, correct the parameter if you wish to continue.           "
		#define STR0004 "Attention!! Point of sale is not valid. It must be between 0001 and 9998!"
		#define STR0005 "Indicate Point of Sales with 4 positions "
		#define STR0006 "and that is between 0001 and  "
		#define STR0007 "9998, as described in the layout.      "
		#define STR0008 "Indicate Point of Sales"
		#define STR0009 "Indicate which file will be generated:       "
		#define STR0010 "1 - Assets sales                     "
		#define STR0011 "2 - Service rendering"
		#define STR0012 "Generation Type"
		#define STR0013 "1 - Sales"
		#define STR0014 "Tax codes that represent IVA. "
		#define STR0015 "Settled Taxes (IVA)"
		#define STR0016 "Tax codes that represent RNI. "
		#define STR0017 "or not categorized                     "
		#define STR0018 "RNI taxes or not categ."
		#define STR0019 "Tax codes that represent IB.  "
		#define STR0020 "Ingressos Brutos (taxes)"
		#define STR0021 "Tax codes that represent  "
		#define STR0022 "IVA perception or other payments "
		#define STR0023 "referring to National Taxes.          "
		#define STR0024 "Taxes Percep. or National"
		#define STR0025 "Tax codes that represent   "
		#define STR0026 "City Taxes.                     "
		#define STR0027 "City Taxes"
		#define STR0028 "Tax codes that represent   "
		#define STR0029 "Internal Taxes.                       "
		#define STR0030 "Internal Taxes"
		#define STR0031 "Here the necessity of   "
		#define STR0032 "generating the file for documents already "
		#define STR0033 "sent, but without"
		#define STR0034 "an answer (return) from AFIP is defined.  "
		#define STR0035 "Regenerate File"
		#define STR0036 "If the option 'No' is selected, the field   "
		#define STR0037 "'Receipt Date' will be filled with  "
		#define STR0038 "zeros, otherwise with the date of   "
		#define STR0039 "invoice issue              "
		#define STR0040 "Indicate Dates"
		#define STR0041 "1 - Yes"
		#define STR0042 "2 - No"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0002 "O imposto "
		#define STR0003 If( cPaisLoc $ "ANG|PTG", " est� a compor uma outra categoria. por favor, para continuar com o processo, corrija o par�metro.", " esta compondo uma outra categoria. Por favor, para continuar com o processo, acerte o parametro." )
		#define STR0004 "Aten��o!! O ponto de venda n�o � v�lido. Tendo que estar entre 0001 e 9998!"
		#define STR0005 "Informe o Ponto de Venda com 4 posi��es "
		#define STR0006 "e que esteja compreendido entre 0001 e  "
		#define STR0007 "9998, conforme descrito no layout.      "
		#define STR0008 "Informe o Ponto de Venda"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Informe qual ficheiro ser� criado:       ", "Informe qual arquivo ser� gerado:       " )
		#define STR0010 "1 - Venda de bens                     "
		#define STR0011 "2 - Presta��o de Servi�os"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Tipo Cria��o", "Tipo Gera��o" )
		#define STR0013 "1 - Vendas"
		#define STR0014 "C�digos de impostos que representam IVA. "
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Impostos Liquidados (IVA)", "Impostos Liquidado (IVA)" )
		#define STR0016 "C�digos de impostos que representam RNI. "
		#define STR0017 "ou n�o categorizados                     "
		#define STR0018 "Impostos RNI ou n�o categ."
		#define STR0019 "C�digos de impostos que representam IB.  "
		#define STR0020 "Ingressos Brutos"
		#define STR0021 "C�digos de impostos que representam  "
		#define STR0022 "a percep��o do IVA ou outros pagamentos "
		#define STR0023 "referentes a Impostos Nacionais.          "
		#define STR0024 "Impostos Percep. ou Nacionais"
		#define STR0025 "C�digos de impostos que representam os   "
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Impostos do Concelho.                     ", "Impostos Municipais.                     " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Impostos do Concelho", "Impostos Municipais" )
		#define STR0028 "C�digos de impostos que representam os   "
		#define STR0029 "Impostos Internos.                       "
		#define STR0030 "Impostos Internos"
		#define STR0031 "Aqui se define, se � necess�rio voltar a  "
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "criar o ficheiro para documentos que j� ", "gerar o arquivo para documentos que j� " )
		#define STR0033 "foram enviados,  mas que ainda n�o recebeu"
		#define STR0034 "a resposta (retorno) da AFIP.  "
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Criar novamente ficheiro", "Regerar Arquivo" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Se � seleccionada a op��o 'N�o', o campo   ", "Se � selecionada a op��o 'N�o', o campo   " )
		#define STR0037 "'Data do comprovante' ser� preenchido com  "
		#define STR0038 "zeros, do contr�rio, com a data de   "
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "emiss�o da factura fiscal              ", "emiss�o da nota fiscal              " )
		#define STR0040 "Informe Datas"
		#define STR0041 "1 - Sim"
		#define STR0042 "2 - N�o"
	#endif
#endif
