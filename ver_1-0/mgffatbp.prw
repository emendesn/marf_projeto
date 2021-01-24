#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} MGFFATBP
Exclusao do titulo de ICMS proprio 

@description
Excluir o titulo de ICMS propr.gerado via cad.regra venda interest.xgrp trib.
Rotina chamada pelo ponto de entrada MS520VLD

@author Cosme Nunes
@since 06/03/2020
@type User Function

@table 
    SF2 - Cabecalho nota fiscal de saida 
    SE2 - Titulo a pagar

@param
    Nao se aplica
    
@return
    Nao se aplica

@menu
    Nao se aplica

@history 
    06/03/2020 - RTASK0010790 - Chamados RITM0023263 - Cosme Nunes
    
/*/ 

/*

***Alterar MS520VLD()

    ***Incluir trecho
		
        //Validacao da exclusao do titulo de ICMS Proprio
		If FindFunction("U_MGFFATBP") .AND. lRet
			lRet := U_MGFFATBP()
		Endif
*/

User Function MGFFATBP()

Local _aArea	:= GetArea()
Local _aAreaSF2	:= SF2->( GetArea() )
Local _aAreaSE2	:= SE2->( GetArea() )
Local _aAreaSE5	:= SE5->( GetArea() )

Local _lMGFATBPB:= SuperGetMV("MGF_FATBPB",.T.,.F.)
Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_FATBP",.F.,''),";") //Rotinas que nao passarao pela validacao
Local _nCnt     := 0

Local _cMVEstado := GetMV("MV_ESTADO")

Local _lRet := .T.

//Verifica se exclui ti­tulo esta habilitado
If !_lMGFATBPB
    Return(.T.)
EndIf

//Verifica rotinas que nao devem passar pela validacao 
For _nCnt := 1 To Len(_aRotExc)
    If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
        Return(.T.)
    EndIf
Next

//Verifica ICMS calculado e venda interestadual
If SF2->F2_VALICM > 0 .And. _cMVEstado <> SF2->F2_EST

    //Posiciona titulo
    SE2->(DBSETORDER(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
    If SE2->(DbSeek( xFilial("SE2")+"ICM"+SF2->F2_DOC+Space(2)+"TX " )) //  

        //Posiciona baixa do titulo
	    SE5->(DBSETORDER(7))//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		If SE5->(Dbseek( xFilial("SE5") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ))

		    MsgInfo("Título de ICMS Próprio com baixas. Não é possível excluir a nota.","Título a Pagar")		
        	_lRet := .F. 
        
        Else

	   		//Exclui titulo de ICMS próprio
            RecLock("SE2",.F.)
            SE2->(dbDelete())
            SE2->(MsUnlock())            
                
        Endif

    Endif
    
EndIf

RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aAreaSF2)
RestArea(_aArea)

Return(_lRet)