#INCLUDE 'PROTHEUS.CH'

/*
===========================================================================================
Programa.:              MGFCOM80
Autor....:              Totvs
Data.....:              Marco/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada MT100TOK
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFCOM80()
/*
Local lRet := .T.
Local cAlias := ParamIxb[1]
Local nRecno := ParamIxb[2]
Local nOpcao := ParamIxb[3]
Local cFunc := ParamIxb[4]

If cAlias == "SF1" .and. Upper(cFunc) == Upper("A103NFISCAL") .and. FunName() == "MATA103" .and. nOpcao == 3
	If !GetMv("MGF_NFEINC",,.T.)
		lRet := .F.
		ApMsgStop("Essa opcao nao deve ser executada pela Marfrig."+CRLF+;
		"Inclua o documento pela rotina de Pr�-nota de entrada.")
	Endif	
Endif	
*/

Local lRet := .T.

If !l103Auto
	If !GetMv("MGF_NFEINC",,.T.)
		If INCLUI
			If cTipo == "N"
				If cModulo != "GFE" .and. !isInCallStack("U_MGFEEC68")
					lRet := .F.
					ApMsgStop("Inclusao de Documento tipo 'Normal' nao permitida."+CRLF+;
					"Inclua o documento pela rotina de Pr�-nota de entrada.")
				Endif	
			Endif
//        Else
//            /*-------------------------------------------------------------------------+
//            | Validacao para que o usuario confirme todos os armazens/locais dos itens |
//            | do Documento de Entrada ( johnny.osugi@totvspartners.com.br ).           |
//            +-------------------------------------------------------------------------*/
//            If .not. MsgYesNo( OEMToANSI( "Confirmar todos os armaz�ns dos itens?" ), OEMToANSI( 'Atencao aos Armaz�ns!' ) )
//               lRet := .F.
//            EndIf

		Endif	
	Endif		
Endif	
	
Return(lRet)