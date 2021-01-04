#include 'protheus.ch'
#include 'parmtype.ch'

User function MT120GRV()
	
	Local lRet 			:= .T.
	Local cNumPed 		:= PARAMIXB[1]
	Local l120Inc 		:= PARAMIXB[2]
	Local l120Alt 		:= PARAMIXB[3]
	Local l120Del 		:= PARAMIXB[4]
	Local aRecSE2RA 	:= PARAMIXB[5]
	Local nPosCC
	Local nPosZCC
	Local nOpexc := PARAMIXB[1]
		
	Local cCC			:= ''//_XMGFcCC

	if isInCallStack("MATA460")
		return lRet
	endif

	if isInCallStack("MATA460A")
		return lRet
	endif

	if isInCallStack("MATA460B")
		return lRet
	endif	

	if isInCallStack("CNTA120")
		return .T.
	endif
	
	If isInCallStack("U_TAE02_ALT")
   		Return .T.
   	Endif
	// Mercado Eletronico
	if isInCallStack("U_MGFWSC48") .OR. isInCallStack("U_MGFWSC50") 
		return lRet
	endif
         
    if Upper(Alltrim(Funname())) =="MGFTAE02"
		return .T.
	endif

	If Type('_XMGFcCC') <> 'C'
		nPosCC  := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_CC' })
		nPosZCC := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_ZCC' }) 
		
		//Usuado para preencher o CC quando o pedido vem do EEC
		IF IsInCallStack('EECAE100')
			aCols[1,nPosCC]  := EET->EET_ZCCUSTO 
			aCols[1,nPosZCC] := EET->EET_ZCCUSTO
		EndIf 
		
		xCriaPul()
		If !Empty(aCols[1,nPosCC])
			_XMGFcCC := aCols[1,nPosCC]
		Else
			_XMGFcCC := aCols[1,nPosZCC]
		EndIf
	Else
		nPosCC  := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_CC' })
		nPosZCC := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_ZCC' })
		 
		//Usuado para preencher o CC quando o pedido vem do EEC
		IF IsInCallStack('EECAE100')
			aCols[1,nPosCC]  := EET->EET_ZCCUSTO 
			aCols[1,nPosZCC] := EET->EET_ZCCUSTO
		EndIf
	EndIf
	
	If Empty(_XMGFcCC)
		nPosCC  := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_CC' })
		nPosZCC := aScan(aHeader, {|x| Alltrim(x[2]) == 'C7_ZCC' }) 
		If !Empty(aCols[1,nPosCC])
			_XMGFcCC := aCols[1,nPosCC]
		Else
			_XMGFcCC := aCols[1,nPosZCC]
		EndIf
	EndIf
	
	If lRet .and. FindFunction("U_xM8verCC") .and. empty(cCC)
		lRet := U_xM8verCC()
		If !lRet
			If IsBlind()
				Help(" ",1,'DIFFCCUSTO',,'Itens do Pedido com diferentes CENTROS DE CUSTOS.'+CRLF+;
					    'Não é possível conter centros de custos diferentes no mesmo pedido.',1,0)
			Else
				Alert('Itens do Pedido com diferentes CENTROS DE CUSTOS.Não é possível conter centros de custos diferentes no mesmo pedido.')
			EndIf
		EndIf
	EndIf
	
	If lRet .and. FindFunction("U_xM10vGrd")
		cCC := _XMGFcCC
		lRet := U_xM10vGrd(cCC)
		If !lRet
			If IsBlind()
				Help(" ",1,'SEMGRADE',,'Não existe grade para Pedido cadastrado para este CENTRO DE CUSTO..'+CRLF+;
					    'Esse PC não será gravado. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.',1,0)
			Else
				Alert('Não existe grade para Pedido cadastrado para este CENTRO DE CUSTO. Esse PC não será gravado. Entre em contato com o responsável pelo cadastramento da grade e informe esta mensagem.')
			EndIf
		EndIf
	EndIf
    

//MSGALERT("AQUI"+NCOMPR)

	If lRet .and. FindFunction("u_mgf8CkGd")
		u_mgf8CkGd()
	endif
                  
    IF l120Del
       If SC7->C7_ZCANCEL=='S'
				msgalert("Não é possível excluir um Pedido cancelado pelo usuario.")
    	lRet := .F.
       endif
    ENDIF


Return lRet                                                         
    
Static Function xCriaPul()
	Public _XMGFcCC 	:= ''
	Public _XMGFcCON	:= ''
Return