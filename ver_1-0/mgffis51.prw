#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS51 - Funcao chamado pelo PE MTA103OK
Validacao customizacao TES inteligente com base no campo criado D1_ZCLASFI
@author Rafael Garcia de Melo
@since 01/10/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS51()

	Local lRet	:= .T.

	If FunName() == "MATA103"
		if ALLTRIM(CESPECIE) $ GETMV("MGF_TPNFTE") .and. (C103TP =='N' .OR. C103TP =='B' .OR. CTIPO =='N' .OR. CTIPO =='B');
			.AND. CFORMUL == 'N' 
			if alltrim(GDFIELDGET("D1_ZCLASFI",n))<>''
				if substr(GDFIELDGET("D1_ZCLASFI",n),2,2)<> substr(GDFIELDGET("D1_CLASFIS",n),2,2)
					alert("Campos CST e Sit Trib divergentes, nao e possivel continuar ")
					lRet:=.f.
				endif
				if SUBSTR(GDFIELDGET("D1_ZCLASFI",N),1,1)<>SUBSTR(GDFIELDGET("D1_CLASFIS",N),1,1) .AND. lRet
					GDFIELDPUT("D1_CLASFIS",GDFIELDGET("D1_ZCLASFI",N),N)
					MAFISREF("IT_CLASFIS","MT100",GDFIELDGET("D1_ZCLASFI",N))                                                                                    
				endif
			else
				alert("Preenchimento obrigatorio do campo CST")
				lRet:= .f.
			endif
		ENDIF
	EndIf

Return lRet

USER FUNCTION XFIS51()//validacao de gatilho no campo de tipo de operacao no documento de entrada(MATA103)
lret:= .t.

If FunName() == "MATA103"
	if ALLTRIM(CESPECIE) $ GETMV("MGF_TPNFTE") .and. (C103TP =='N' .OR. C103TP =='B' .OR. CTIPO =='N' .OR. CTIPO =='B');
		.AND. CFORMUL == 'N' 
		if alltrim(GDFIELDGET("D1_ZCLASFI",n))==''
			Alert("Pra esse tipo de nota obrigatorio preenchimento do CST")
			lret:=.f.
			GDFIELDPUT("D1_TES","",N)
		ENDIF
	endif
EndIf

return lret

USER FUNCTION XFIS512()//validacao campo tes (X3_WHEN) no documento de entrada(MATA103)
lRet:=.t.

If FunName() == "MATA103"
	if ALLTRIM(CESPECIE) $ GETMV("MGF_TPNFTE") .and.  (C103TP =='N' .OR. C103TP =='B' .OR. CTIPO =='N' .OR. CTIPO =='B');
		.AND. CFORMUL == 'N' 
		lRet:= .f.
	endif
EndIf

return lRet	

USER FUNCTION XFIS513()//validacao campo D1_ZCLASFI (X3_WHEN) no documento de entrada(MATA103)
lRet:=.F.

If FunName() == "MATA103"
	if ALLTRIM(CESPECIE) $ GETMV("MGF_TPNFTE") .and.  (C103TP =='N' .OR. C103TP =='B' .OR. CTIPO =='N' .OR. CTIPO =='B');
		.AND. CFORMUL == 'N' 
		lRet:= .T.
	endif
EndIf

return lRet	