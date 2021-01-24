#include "protheus.ch"

/*
=====================================================================================
Programa............: MT103Fim
Autor...............: Mauricio Gresele
Data................: 18/10/2016 
Descricao / Objetivo: Ponto de entrada no final da gravacao do documento de entrada
Doc. Origem.........: Financeiro - CRE34
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
10/07/2020 - Paulo da Mata - RTASK0010971 - Recriação para PRD em 13/07/2020
*/
User function MT103Fim()

	If FindFunction("U_MGFFIN82")
		U_MGFFIN82()
	EndIf

	If FindFunction("U_MGFFIN34")
		U_MGFFIN34(ParamIxb)
	EndIf

	If FindFunction("U_MGFTAE06")
		If PARAMIXB[2] == 1 .AND. ( PARAMIXB[1] == 3 .OR. PARAMIXB[1] == 4 .OR. PARAMIXB[1] == 20) 
			U_MGFTAE06(1)
		EndIf
	EndIf
	
	If FindFunction("U_MGFTAE12")
		If PARAMIXB[2] == 1 .AND. ( PARAMIXB[1] == 3 .OR. PARAMIXB[1] == 4 .OR. PARAMIXB[1] == 20) 
			U_MGFTAE12(1)
		EndIf
	EndIf

	If FindFunction("U_MGFEIC05")
		If PARAMIXB[2] == 1 .AND. ( PARAMIXB[1]==3 .OR. PARAMIXB[1] == 4 .OR. PARAMIXB[1] == 20) 
			//U_MGFEIC05(1)
		EndIf
	EndIf               

	If FindFunction("U_MGFRCTRC")
		U_MGFRCTRC()
	EndIf               
	
	If FindFunction("U_CTB32FIM")
		U_CTB32FIM()
	EndIf

	// Paulo da Mata - 23/06/2020 - Só passa por aqui, no ato da entrada da note, via importação do CTE	
	If Isincallstack('GFEA118') .Or. Isincallstack('GFEA065')

		// Paulo da Mata - 15/04/2020 - Inclui a data de vencimento do CTE
		If FindFunction("U_MGFGFE13")
			U_MGFGFE13()
		EndIf

	EndIf	

	If FindFunction("U_MGFUS103")
		If PARAMIXB[2] == 1 .AND. ( PARAMIXB[1] == 3 .OR. PARAMIXB[1] == 4 .OR. PARAMIXB[1] == 20) 
			U_MGFUS103()
		EndIf
	EndIf
	
	If FindFunction("U_MGFEST38")
		If PARAMIXB[2] == 1 .AND. ( PARAMIXB[1] == 3 .OR. PARAMIXB[1] == 4 ) 
			U_MGFEST38()
		EndIf
	EndIf

	// Funï¿½ï¿½o para finalizar a RAMI
	If FindFunction("U_MGFCRM49")
		If PARAMIXB[2] == 1 // Se o usuario confirmou a operaï¿½ï¿½o de gravaï¿½ï¿½o da NFECODIGO DE APLICAï¿½ï¿½O DO USUARIO
			If PARAMIXB[1] == 3 // 3:Inclusï¿½o, 5: Estorno de Classificaï¿½ï¿½o
				U_MGFCRM49() // 2 - Gera a NCC para o cliente no valor do Documento de Entrada. 			
			EndIf
		EndIf
	EndIf	
	
	//GAP358, Natanael: Localiza na SA1 o registro que possui o mesmo CNPJ do Fornecedor (SA2) informado no Documento de Entrada de complemento de ICMS e incluirï¿½ uma NCC para esse cliente.
	If FindFunction("U_MGFFIS36") .AND. IsInCallStack("MATA103")
		If PARAMIXB[2] == 1 // Se o usuario confirmou a operaï¿½ï¿½o de gravaï¿½ï¿½o da NFECODIGO DE APLICAï¿½ï¿½O DO USUARIO
			If PARAMIXB[1] == 3 // 3:Inclusï¿½o, 5: Estorno de Classificaï¿½ï¿½o
			   U_MGFFIS36(2) // 2 - Gera a NCC para o cliente no valor do Documento de Entrada.
			EndIf
		EndIf
	EndIf

	// gravacao de campos da aba dados adicionais-GFE
	If FindFunction("U_A103CmpAdic") .AND. IsInCallStack("MATA103")
		//U_A103CmpAdic()
	EndIf	

	If FindFunction( "U_MGFFATAR" )
		U_MGFFATAR()
	EndIf

return
