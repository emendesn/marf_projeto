#ifdef SPANISH
	#define STR0001 "solo visualizacion"
	#define STR0002 "Tasa negociada"
	#define STR0003 "Retencion"
	#define STR0004 "Pror.Imp."
	#define STR0005 "Prorrateo de Impuestos financieros"
	#define STR0006 "Vencimiento"
	#define STR0007 "Numero maximo de cuotas: "
	#define STR0008 "Cuotas de la condicion de pago. "
	#define STR0009 "Valor no anadido"
	#define STR0010 "Mas Inf."
	#define STR0011 "Total ( Flete+Gastos)"
	#define STR0012 "¡Existen pedidos vinculados a este proveedor! Esta informacion se borrara. ¿Desea continuar?"
	#define STR0013 "Salir"
	#define STR0014 "Continua"
	#define STR0015 "Numero"
	#define STR0016 "Emision"
	#define STR0017 "Hora de la emision"
	#define STR0018 "Valor de credito"
	#define STR0019 "Numero RPS"
	#define STR0020 "Cod. Verificacion"
	#define STR0021 "Mens.Estandar"
	#define STR0022 "Cod.Transp"
	#define STR0023 "Placa"
	#define STR0024 "Especie 1"
	#define STR0025 "Volumen 1"
	#define STR0026 "Especie 2"
	#define STR0027 "Volumen 2"
	#define STR0028 "Especie 3"
	#define STR0029 "Volumen 3"
	#define STR0030 "Especie 4"
	#define STR0031 "Volumen 4"
	#define STR0032 "Clave NFE"
	#define STR0033 "Valor de peaje"
	#define STR0034 "Peso bruto"
	#define STR0035 "Peso neto"
	#define STR0036 "Provee Retiro"
	#define STR0037 "Provee Entrega"
	#define STR0038 "Tp. Flete"
	#define STR0039 "Tipo e-Ct"
	#define STR0040 "Modalidad"
	#define STR0041 "Nº AIDF"
	#define STR0042 "Ano AIDF"
	#define STR0043 "Mas Inf."
	#define STR0044 "Mun. Incid. ISS:"
	#define STR0045 "Vehiculo 1"
	#define STR0046 "Vehiculo 2"
	#define STR0047 "Vehiculo 3"
	#define STR0048 "Datos del Municipio:"
	#define STR0049 "Est/Prov/Reg:"
	#define STR0050 "Codigo Mun:"
	#define STR0051 "Desc. Mun:"
	#define STR0052 "Ded Serv:"
	#define STR0053 "ISS Calculado:"
	#define STR0054 "Valores de los servicios:"
	#define STR0055 "Servicios"
	#define STR0056 "Materiales:"
	#define STR0057 "B. Calculo:"
	#define STR0058 "Val. ISS:"
	#define STR0059 "INSS Calculado:"
	#define STR0060 "Valor de servicio:"
	#define STR0061 "Cobrado:"
	#define STR0062 "Servicios:"
	#define STR0063 "B. Calculo:"
	#define STR0064 "Val. INSS"
#else
	#ifdef ENGLISH
		#define STR0001 "Read-only"
		#define STR0002 "Negotiated Fee"
		#define STR0003 "Retention"
		#define STR0004 "Tax App."
		#define STR0005 "Finance Tax Apportionment"
		#define STR0006 "Due Date"
		#define STR0007 "Maximum number of installments: "
		#define STR0008 "Payment term installments: "
		#define STR0009 "Value not Applied"
		#define STR0010 "More Inf."
		#define STR0011 "Total ( Freight+Expenses)"
		#define STR0012 "There are orders related to this supplier! This information will be deleted. Continue?"
		#define STR0013 "Quit"
		#define STR0014 "Continue"
		#define STR0015 "Number"
		#define STR0016 "Issue"
		#define STR0017 "Issue Time"
		#define STR0018 "Credit Value"
		#define STR0019 "RPS Number"
		#define STR0020 "Checking code"
		#define STR0021 "Standard Msg."
		#define STR0022 "Transp. Code"
		#define STR0023 "License Plate"
		#define STR0024 "Species 1"
		#define STR0025 "Volume 1"
		#define STR0026 "Species 2"
		#define STR0027 "Volume 2"
		#define STR0028 "Species 3"
		#define STR0029 "Volume 3"
		#define STR0030 "Species 4"
		#define STR0031 "Volume 4"
		#define STR0032 "NFE Key"
		#define STR0033 "Toll Value"
		#define STR0034 "Gross Weight"
		#define STR0035 "Net Weight"
		#define STR0036 "Supplier withdrawal"
		#define STR0037 "Delivery Supplier"
		#define STR0038 "Tp. Freight"
		#define STR0039 "Ct-e Type"
		#define STR0040 "Modality"
		#define STR0041 "AIDF No."
		#define STR0042 "AIDF Year"
		#define STR0043 "More Inf."
		#define STR0044 "ISS Incid. City:"
		#define STR0045 "Vehicle 1"
		#define STR0046 "Vehicle 2"
		#define STR0047 "Vehicle 3"
		#define STR0048 "City data:"
		#define STR0049 "State:"
		#define STR0050 "City Code:"
		#define STR0051 "Desc. City"
		#define STR0052 "Serv Ded:"
		#define STR0053 "Calculated ISS:"
		#define STR0054 "Service Value:"
		#define STR0055 "Services"
		#define STR0056 "Material:"
		#define STR0057 "Calculation B.:"
		#define STR0058 "Val. ISS:"
		#define STR0059 "Calculated INSS:"
		#define STR0060 "Service Value:"
		#define STR0061 "Collected:"
		#define STR0062 "Services:"
		#define STR0063 "Calculation B.:"
		#define STR0064 "Val. INSS:"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "somente visualizacao" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Taxa Negociada" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Retencao" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Rat.Imp." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Rateio de Impostos Financeiros" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Vencimento" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Número máximo de parcelas: " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Parcelas da condição de pagamento: " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Valor não Agregado" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Mais Inf." )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Total ( Frete+Despesas)" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Existem pedidos relacionados a este fornecedor! Estas informações serão apagadas. Deseja Continuar?" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Abandona" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Continua" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "Número" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Emissão" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Hora da emissão" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Valor Crédito" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Número RPS" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Cód. verificação" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Mens.Padrão" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Cod.Transp" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Placa" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Especie 1" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Volume 1" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Especie 2" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Volume 2" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Especie 3" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Volume 3" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Especie 4" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Volume 4" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Chave NFE" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Valor do Pedagio" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Peso Bruto" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Peso Liquido" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Fornec Retirada" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Fornec Entrega" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Tp. Frete" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Tipo Ct-e" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Modalidade" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Num AIDF" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Ano AIDF" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Mais Inf." )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Mun. Incid. ISS:" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Veículo 1" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Veículo 2" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Veículo 3" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", , "Dados do Município:" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", , "UF:" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", , "Codigo Mun:" )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", , "Desc. Mun:" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", , "Ded Serv:" )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", , "ISS Apurado:" )
		#define STR0054 If( cPaisLoc $ "ANG|PTG", , "Valor dos Servicos:" )
		#define STR0055 If( cPaisLoc $ "ANG|PTG", , "Serviços" )
		#define STR0056 If( cPaisLoc $ "ANG|PTG", , "Materiais:" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", , "B. Cálculo:" )
		#define STR0058 If( cPaisLoc $ "ANG|PTG", , "Val. ISS:" )
		#define STR0059 If( cPaisLoc $ "ANG|PTG", , "INSS Apurado:" )
		#define STR0060 If( cPaisLoc $ "ANG|PTG", , "Valor Serviço:" )
		#define STR0061 If( cPaisLoc $ "ANG|PTG", , "Recolhido:" )
		#define STR0062 If( cPaisLoc $ "ANG|PTG", , "Servicos:" )
		#define STR0063 If( cPaisLoc $ "ANG|PTG", , "B. Cálculo:" )
		#define STR0064 If( cPaisLoc $ "ANG|PTG", , "Val. INSS:" )
	#endif
#endif
