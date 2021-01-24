#ifdef SPANISH
	#define STR0001 "Imprimiendo DAV"
	#define STR0002 "Documento Auxiliar de Venta - DAV"
	#define STR0003 "DOCUMENTO AUXILIAR DE VENTA - PRESUPUESTO"
	#define STR0004 "NO ES DOCUMENTO FISCAL - NO ES VALIDO COMO RECIBO NI COMO GARANTIA DE MERCADERIA"
	#define STR0005 " NO COMPRUEBA PAGO"
	#define STR0006 "Identificacion del Establecimiento Emisor "
	#define STR0007 "Denominacion: "
	#define STR0008 "Identificacion del Destinatario"
	#define STR0009 "Nombre: "
	#define STR0010 "CNPJ/CPF: "
	#define STR0011 "N� del Documento: "
	#define STR0012 "N� del Documento Fiscal: "
	#define STR0013 "Item:"
	#define STR0014 "Codigo"
	#define STR0015 "Descripcion"
	#define STR0016 "Cant."
	#define STR0017 "U.M."
	#define STR0018 "Vlr.Unit."
	#define STR0019 "Vlr.Desc."
	#define STR0020 "Vlr.Total"
	#define STR0021 "Se prohibe la autenticacion de este documento"
	#define STR0022 "Conforme previsto en el ACTO COTEPE/ICMS 14, DEL 16 DE MARZO DE 2011, se prohibe la reimpresion del DAV"
	#define STR0023 "Ya se emitio Comprobante Fiscal para esta cuenta, se prohibe la impresion del DAV"
	#define STR0024 "Aguarde. Abriendo la Impresora Fiscal..."
	#define STR0025 "Aguarde. Cerrando la Impresora Fiscal..."
	#define STR0026 "ORDEN DE SERVICIOS (DAV-OS)"
	#define STR0027 "DAV-OS Origen: "
	#define STR0028 "DAV Anulada. Impresion no permitida"
	#define STR0029 "Punto de entrada LJR210DAV compilado de forma indebida. Retorno esperado:Array."
#else
	#ifdef ENGLISH
		#define STR0001 "Printing DAV"
		#define STR0002 "Assistant sales document - DAV"
		#define STR0003 "ASSISTANT SALES DOCUMENT - BUDGET"
		#define STR0004 "IT IS NOT A TAX DOCUMENT - NOT VALID AS RECEIPT AND AS GOOD GUARANTEE"
		#define STR0005 " IT IS NOT A PAYMENT RECEIPT"
		#define STR0006 "Issuer Establishment Identification"
		#define STR0007 "Name: "
		#define STR0008 "Recipient Identification"
		#define STR0009 "Name: "
		#define STR0010 "CNPJ/CPF: "
		#define STR0011 "Document No.: "
		#define STR0012 "Tax Document No: "
		#define STR0013 "Item"
		#define STR0014 "Code"
		#define STR0015 "Description"
		#define STR0016 "Amt."
		#define STR0017 "U.M."
		#define STR0018 "Unit Value"
		#define STR0019 "Discount Value"
		#define STR0020 "Total Value."
		#define STR0021 "The authentication of this document is forbidden"
		#define STR0022 "As due to ACT COTEPE/ICMS 14, OF MARCH 16 OF 2011, the printing of DAV is prohibited"
		#define STR0023 "A Tax Receipt is already issued for this account. The printing of DAV is prohibited."
		#define STR0024 "Wait. Opening Fiscal Printer..."
		#define STR0025 "Wait. Closing Fiscal Printer..."
		#define STR0026 "SERVICE ORDER (DAV-OS)"
		#define STR0027 "DAV-OS Origin: "
		#define STR0028 "Canceled DAV. Printing not allowed"
		#define STR0029 "Entry Point LJR210DAV not properly compiled. Expected feedback: Array."
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "A Imprimir DAV", "Imprimindo DAV" )
		#define STR0002 "Documento Auxiliar de Venda - DAV"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "DOCUMENTO AUXILIAR DE VENDA - OR�AMENTO", "DOCUMENTO AUXILIAR DE VENDA - ORCAMENTO" )
		#define STR0004 "N�O � DOCUMENTO FISCAL - N�O � VALIDO COMO RECIBO E COMO GARANTIA DE MERCADORIA"
		#define STR0005 " N�O COMPROVA PAGAMENTO"
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Identifica��o do Estabelecimento Emitente", "Identificacao do Estabelecimento Emitente" )
		#define STR0007 "Denomina��o: "
		#define STR0008 "Identificacao do Destinat�rio"
		#define STR0009 "Nome: "
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Nr.Contribuinte: ", "CNPJ/CPF: " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Nr. do Documento: ", "N� do Documento: " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Nr. do Documento Fiscal: ", "N� do Documento Fiscal: " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Elem.", "Item" )
		#define STR0014 "C�digo"
		#define STR0015 "Descri��o"
		#define STR0016 "Quant."
		#define STR0017 "U.M."
		#define STR0018 "Vlr.Unit."
		#define STR0019 "Vlr.Desc."
		#define STR0020 "Vlr.Total"
		#define STR0021 "� vedada a autentica��o deste documento"
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Conforme previsto no ACTO COTEPE/ICMS 14, DE 16 DE MAR�O DE 2011, � vedada a reimpress�o do DAV", "Conforme previsto no ATO COTEPE/ICMS 14, DE 16 DE MAR�O DE 2011, � vedada a reimpress�o do DAV" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "J� foi emitido Cup�o Fiscal para essa conta, � vedada a impress�o do DAV", "J� foi emitido Cupom Fiscal para essa conta, � vedada a impress�o do DAV" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Aguarde. A abrir a impressora fiscal...", "Aguarde. Abrindo a Impressora Fiscal..." )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Aguarde. A fechar a impressora fiscal...", "Aguarde. Fechando a Impressora Fiscal..." )
		#define STR0026 "ORDEM DE SERVI�O (DAV-OS)"
		#define STR0027 "DAV-OS Origem: "
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "DAV cancelada. Impress�o n�o permitida", "DAV Cancelada. Impress�o n�o permitida" )
		#define STR0029 "Ponto de Entrada LJR210DAV compilado de forma indevida. Retorno esperado:Array."
	#endif
#endif
