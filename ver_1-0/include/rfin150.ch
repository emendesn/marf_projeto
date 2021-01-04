#IFDEF SPANISH
	#define STR0001  "Imprime la posicion de los titulos por pagar, relativos"
	#define STR0002  "a la fecha del sistema."
	#define STR0003  "A Rayas"
	#define STR0004  "Administracion"
	#define STR0005  "Posicion de los Titulos por Pagar"
	#define STR0006  "Codigo-Nombre Proveedor   Prf-Numero           Tp  Modalidad  Fecha de   Vencto     Vencto      Valor Original|        Titulos Vencidos         | Titulos a Vencer | Porta-| Vlr.Interes   Dias   Historial     "
	#define STR0007  "                          Cuota                               Emision    Titulo     Real                      |  Valor Nominal  Valor Corregido |   Valor Nominal  | dor   | o Permanencia Atraso               "
	#define STR0008  "Por Numero"
	#define STR0009  "Por Modalidad"
	#define STR0010  "Por Vencimiento"
	#define STR0011  "Por Banco"
	#define STR0012  "Proveedor"
	#define STR0013  "Por Emision"
	#define STR0014  "Por Cod.Proveedor"
	#define STR0015  "* indica titulo provisional, P indica Saldo Parcial"
	#define STR0016  " - Por Numero"
	#define STR0017  " - Por Modalidad"
	#define STR0018  " - Por Vencimiento"
	#define STR0019  " - Por Emision"
	#define STR0020  " - Por Cod.Proveedor"
	#define STR0021  "Seleccionando Registros..."
	#define STR0022  " - Por Proveedor"
	#define STR0023  " - Analitico"
	#define STR0024  " - Sintetico"
	#define STR0025  "ANULADO POR EL OPERADOR"
	#define STR0026  "S U B  T O T A L ----> "
	#define STR0027  "T O T A L   G E N E R A L ----> "
	#define STR0028  "MOVIMIENTOS"
	#define STR0029  "TITULO"
	#define STR0030  "T O T A L   D E L   M E S ---> "
	#define STR0031  " - Por Banco"
	#define STR0032  "T O T A L   S U C U R S A L --->"
	#define STR0033  "                                                                                                              |        Titulos Vencidos         |Titulos por Vencer|         Vlr. Interes                  (Vencidos+Vencer)"
	#define STR0034  "                                                                                                              |  Valor Nominal  Valor Corregido |   Valor Nominal  |        o Permanencia                       "
	#define STR0035  " en "
	#define STR0036  "Imprimir los tipos"
	#define STR0037  "No imprimir tipos"
#ELSE
	#IFDEF ENGLISH
         #define STR0001  "Print the Payable Bills Status, refering to  base date"
         #define STR0002  "of the System."
         #define STR0003  "Z.Form"
         #define STR0004  "Management"
         #define STR0005  "Bills Payable Situation  "
         #define STR0006  "Code  -Name of Supplier   PRX-Number           Ty  Nature     Date of    Mat. of    Real        Original Value|        Due Bills                | Bills to Mature  | Bearer| Interests or  Delay  History  (Due +to Mature) "
		   #define STR0007  "                          Installment                         Install.   Bill       Matur.                    |  Nominal Value  Adjusted Value  |   Nominal Value  |       |  Permanence   Days                 "
         #define STR0008  "By Number"
         #define STR0009  "By Nature"
         #define STR0010  "By Due Date"
         #define STR0011  "By Bank"
         #define STR0012  "Supplier"
         #define STR0013  "By Issue"
         #define STR0014  "By Cod.Supplier"
         #define STR0015  "* show temporary bill, P shows Partial Bal. "
         #define STR0016  " - By Number"
         #define STR0017  " - By Nature"
         #define STR0018  " - By Due Date"
         #define STR0019  " - By Issue"
         #define STR0020  " - By Cod.Supplier"
         #define STR0021  "Selecting Records..."
         #define STR0022  " - By Supplier"
         #define STR0023  " - Detailed"
         #define STR0024  " - Summarized."
         #define STR0025  "CANCELLED BY THE OPERATOR"
		 #define STR0026  "S U B - T O T A L ----> "
         #define STR0027  "T O T A L               --> "
         #define STR0028  "BILLS"
         #define STR0029  "BILL"
         #define STR0030  "M O N T H  T O T A L  ---> "
         #define STR0031  " - Per Bank"
		 	#define STR0032  "T O T A L   B R A N C H --->"
		 	#define STR0033  "                                                                                                              |           Due Bills             | Bills to Mature  |         Interests or                  (Due+to Mature)  "
		 	#define STR0034  "                                                                                                              |  Nominal Value  Adjust. Value   | Nominal Value    |          Permanence                        "
 		 	#define STR0035  " in "
 		 	#define STR0036  "Print types"
			#define STR0037  "Do not print types"
	#ELSE
		#define STR0001  "Imprime a posicao dos titulos a pagar relativo a data base"
		#define STR0002  "do sistema."
		#define STR0003  "Zebrado"
		#define STR0004  "Administracao"
		#define STR0005  "Posicao dos Titulos a Pagar"
                #define STR0006  "Codigo-Nome do Fornecedor Pr PRF-Numero           Tp  Natureza  Data de   Vencto    Vencto      Valor Original|        Titulos vencidos         | Titulos a vencer | Porta-| Vlr.juros ou  Dias   Historico(Vencidos+Vencer)"
                #define STR0007  "                             Parcela                            Emissao   Titulo    Real                      |  Valor nominal  Valor corrigido |   Valor nominal  | dor   |  permanencia  Atraso               "
		#define STR0008  "Por Numero"
		#define STR0009  "Por Natureza"
		#define STR0010  "Por Vencimento"
		#define STR0011  "Por Banco"
		#define STR0012  "Por Nome Fornecedor"
		#define STR0013  "Por Emissao"
		#define STR0014  "Por Cod.Fornec."
		#define STR0015  "* indica titulo provisorio, P indica Saldo Parcial"
		#define STR0016  " - Por Numero"
		#define STR0017  " - Por Natureza"
		#define STR0018  " - Por Vencimento"
		#define STR0019  " - Por Emissao"
		#define STR0020  " - Por Cod.Fornecedor"
		#define STR0021  "Selecionando Registros..."
		#define STR0022  " - Por Fornecedor"
		#define STR0023  " - Analitico"
		#define STR0024  " - Sintetico"
		#define STR0025  "CANCELADO PELO OPERADOR"
		#define STR0026  "S U B - T O T A L ----> "
		#define STR0027  "T O T A L   G E R A L ----> "
		#define STR0028  "MOVIMENTACOES"
		#define STR0029  "TITULO"
		#define STR0030  "T O T A L   D O  M E S ---> "
		#define STR0031  " - Por Banco"
		#define STR0032  "T O T A L   F I L I A L --->"
		#define STR0033  "                                                                                                              |        Titulos vencidos         | Titulos a vencer |         Vlr.juros ou                  (Vencidos+Vencer)"
		#define STR0034  "                                                                                                              |  Valor nominal  Valor corrigido |   Valor nominal  |          permanencia                       "
		#define STR0035  " em "
		#define STR0036  "Imprimir os tipos"
		#define STR0037  "Nao imprimir tipos"
	#ENDIF
#ENDIF
