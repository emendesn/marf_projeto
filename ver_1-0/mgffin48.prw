#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN48
Autor....:              Atilio Amarilla
Data.....:              08/01/2017
Descricao / Objetivo:   Retorno CNAB - Tratamento de rejeicao de remessa/recompra FIDC
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              
Obs......:              Transacoes referentes a Banco/Carteira FIDC
						Chamado por PE FA200REJ
=====================================================================================
*/

User Function MGFFIN48()
	
	Local cAlias, aAreaSEA
	Local cCart	:= "R"
	Local aArea	:= GetArea()
	
	Local cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
	Local aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
	Local cAgeFIDC, cCtaFIDC

	// GDN - 28/08/2018 - Ajuste para tratar o Banco e 
	// definir qual parametro considerar para FIDC
	Do Case
		Case cBanco = '237'
			 cBcoFIDC	:= GetMv("MGF_FIN44A",,"237/123/12345/001")		// Banco FIDC
		Otherwise
			 cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
	EndCase
	
	aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
	
	cBcoFIDC	:= aBcoFIDC[1]
	cAgeFIDC	:= Stuff( Space( TamSX3("A6_AGENCIA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[2])) , Alltrim(aBcoFIDC[2]) )
	cCtaFIDC	:= Stuff( Space( TamSX3("A6_NUMCON")[1] ) , 1 , Len(AllTrim(aBcoFIDC[3])) , Alltrim(aBcoFIDC[3]) )
	cSubFIDC	:= Stuff( Space( TamSX3("EE_SUBCTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[4])) , Alltrim(aBcoFIDC[4]) )
	
	/*
	FIDC - Baixa pelo valor do titulo, sem considerar valores de desconto, juros,...
	*/
	If cBanco == cBcoFIDC .And. AllTrim(cOcorr) == "03"
		
		dbSelectArea("SEA")
		aAreaSEA	:= SEA->( GetArea() )
		dbSetOrder(2)
		
		cAlias	:= GetNextAlias()
		
		//������������������������������������Ŀ
		//� Verifica se �ltimo do titulo ativo �
		//��������������������������������������
		BeginSQL Alias cAlias
			
			SELECT ZA8.R_E_C_N_O_ ZA8_RECNO, ZA7.R_E_C_N_O_ ZA7_RECNO, ZA8.*, ZA7.*
			FROM %table:ZA8% ZA8
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS = '2'
				AND ZA7_DATA <> '        '
			WHERE ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = %Exp:SE1->E1_FILIAL%
				AND ZA8_PREFIX = %Exp:SE1->E1_PREFIXO%
				AND ZA8_NUM    = %Exp:SE1->E1_NUM%
				AND ZA8_PARCEL = %Exp:SE1->E1_PARCELA%
				AND ZA8_TIPO   = %Exp:SE1->E1_TIPO%
				AND ZA8_STATUS IN ('1','2')
			ORDER BY 1 DESC
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		If !Empty( ( cAlias )->ZA8_NUMBOR )
			
			If ( cAlias )->ZA7_TIPO == "1"
				
				If SEA->( dbSeek( xFilial("SEA")+SE1->(E1_NUMBOR+cCart+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) ) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
					
					RecLock("SEA",.F.)
					SEA->EA_NUMBOR	:= ( cAlias )->ZA8_NUMBOR
					SEA->EA_DATABOR	:= STOD( ( cAlias )->ZA8_DATBOR )
					SEA->EA_PORTADO := ( cAlias )->ZA8_BANCO
					SEA->EA_AGEDEP	:= ( cAlias )->ZA8_AGENCI
					SEA->EA_NUMCON	:= ( cAlias )->ZA8_CONTA
					SAE->( msUnlock() )
					
				EndIf
				
				
				RecLock("SE1",.F.)
				SE1->E1_NUMBOR	:= ( cAlias )->ZA8_NUMBOR
				SE1->E1_DATABOR	:= STOD( ( cAlias )->ZA8_DATBOR )
				SE1->E1_PORTADO := ( cAlias )->ZA8_BANCO
				SE1->E1_AGEDEP	:= ( cAlias )->ZA8_AGENCI
				SE1->E1_CONTA	:= ( cAlias )->ZA8_CONTA
				SE1->( msUnlock() )
				
			Else
				
				ZA8->( dbSetOrder(1) ) //ZA8_FILIAL+ZA8_CODREM+ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO
				ZA7->( dbSetOrder(1) ) //ZA7_FILIAL+ZA7_CODREM
				
				If ZA8->( dbSeek( ( cAlias )->(ZA8_FILIAL+ZA8_NUMBOR+ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO) ) ) // ZA8_FILIAL+ZA8_CODREM+ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO
					
					If ZA7->( dbSeek( ZA8->(ZA8_FILIAL+ZJOA8_CODREM) ) )
						
						If SEA->( dbSeek( xFilial("SEA")+SE1->(E1_NUMBOR+cCart+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) ) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
							
							RecLock("SEA",.F.)
							SEA->EA_NUMBOR	:= ZA7->ZA7_NUMBOR
							SEA->EA_DATABOR	:= STOD(( cAlias )->ZA8_DATBOR)
							SEA->EA_PORTADO := ( cAlias )->ZA8_BANCO
							SEA->EA_AGEDEP	:= ( cAlias )->ZA8_AGENCI
							SEA->EA_NUMCON	:= ( cAlias )->ZA8_CONTA
							SAE->( msUnlock() )
							
						EndIf
						
						RecLock("SE1",.F.)
						SE1->E1_NUMBOR	:= ZA7->ZA7_NUMBOR
						SE1->E1_DATABOR	:= STOD( ( cAlias )->ZA8_DATBOR )
						SE1->E1_PORTADO := ( cAlias )->ZA8_BANCO
						SE1->E1_AGEDEP	:= ( cAlias )->ZA8_AGENCI
						SE1->E1_CONTA	:= ( cAlias )->ZA8_CONTA
						SE1->( msUnlock() )
						
						RecLock("ZA8",.F.)
						ZA8->ZA8_STATUS	:= "2" // Confirmado
						ZA8->( msUnlock() )
						
					EndIf
				EndIf
			EndIf

			ZA8->( dbGoTo( ( cAlias )->ZA8_RECNO ) )
			
			RecLock("ZA8",.F.)
			ZA8->ZA8_STATUS	:= "4" // Rejeitado
			ZA8->ZA8_MOTREJ	:= SEB->EB_MOTBAN // cMotivo
			ZA8->ZA8_DATREJ	:= Date()
			ZA8->( msUnlock() )
				
		EndIf

		RestArea( aAreaSEA )
		
		( cAlias )->(dbCloseArea())
		
	EndIf
	
	RestArea( aArea )	

Return
