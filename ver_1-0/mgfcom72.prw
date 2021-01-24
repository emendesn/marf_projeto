#include "Protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM72
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT094END e outros
=====================================================================================
*/
User Function MGFCOM72()

Local aArea := {SCR->(GetArea()),GetArea()}
Local cDocto := ""
Local lLib := .F.
//Local lContinua := .F.
Local lBlqVal := .F.

// verifica todos os bloqueios desta nota, para liberar ou nao a nota
If Alltrim(SCR->CR_TIPO) == "NF" .and. SCR->CR_FILIAL == SF1->F1_FILIAL .and. Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	
	Begin Transaction 
	
	cDocto := Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(xFilial("SCR")+"NF"+cDocto))
		While SCR->(!Eof()) .and. xFilial("SCR")+"NF"+cDocto == SCR->CR_FILIAL+SCR->CR_TIPO+Subs(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			If "_VALOR_NFE" $ Alltrim(SCR->CR_NUM)
				//lContinua := .T.
				lBlqVal := .T.
				// regrava campos de valores na SCR
				SCR->(RecLock("SCR",.F.))
				SCR->CR_ZVLRTOT := SF1->F1_ZVLRTOT
				SCR->CR_ZVLTOCL := SF1->F1_ZVLTOCL
				SCR->CR_ZVLDIFC := Abs(SF1->F1_ZVLRTOT-SF1->F1_ZVLTOCL)
				SCR->(MsUnLock())
			Endif
			SCR->(dbSkip())
		Enddo
	Endif
	//If lContinua			
		// verifica todos os bloqueios para o documento
		//.T. = Está liberado, .F. = não está liberdado.
		lLib := _MtGLastSCR("NF",cDocto) .and. _MtGLastSCR("NF",cDocto+"_VALOR_NFE") 	
		SF1->(RecLock("SF1",.F.))
		SF1->F1_STATUS := IIf(lLib," ","B")
		SF1->F1_ZBLQVAL := IIf((lBlqVal .and. lLib),"N",IIf((lBlqVal .and. !lLib),"S"," "))
		SF1->(MsUnLock())
	//Endif	
	
	End Transaction
	
Endif

aEval(aArea,{|x| RestArea(x)})
			
Return()


//--------------------------------------------------------------------
/*/{Protheus.doc} MtGLastSCR()
Verifica se todos os niveis de alçada foram liberados
@author Rafael Duram
@Param cTipo:	Tipo do documento
@Param cNum:	Numero do documento
@since 25/09/2015
@version 1.0
@return Ret :=  .T. = Está liberado, .F. = não está liberdado.
/*/
//--------------------------------------------------------------------
Static Function _MtGLastSCR(cTipo,cNum)
Local lRet 		:= .T.
Local cWhere		:= ""

cWhere += " AND CR_NUM = '"+cNum+"' "
cWhere += " AND CR_TIPO = '"+cTipo+"' "
//cWhere += " AND CR_STATUS IN ('01','02','06') " no padrao estah assim
cWhere += " AND CR_STATUS IN ('01','02','06','04') " // inserido status 04 = bloqueio, para considerar bloqueio como status de nao aprovacao tambem

cWhere := '%'+cWhere+'%'

BeginSql Alias "TMPSCR"

	SELECT COUNT(*) AS NREG
	FROM
		%table:SCR% SCR
	WHERE
		SCR.%notDel% AND
		SCR.CR_FILIAL = %xFilial:SCR%
		%Exp:cWhere%
EndSql

lRet := TMPSCR->NREG == 0
TMPSCR->(dbCloseArea())

Return(lRet)
