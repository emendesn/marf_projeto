#include 'Protheus.ch'
#include "FWMVCDEF.ch"

/*
=====================================================================================
Programa............: MGFEST27
Autor...............: Mauricio Gresele
Data................: 24/05/2017
Descrição / Objetivo: Tratamento para gravacao do campo N1_DESCR
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/     
// ponto de entrada na rotina de cadastro do ativo imobilizado
User Function ATFA012_PE()

Local aArea := {GetArea()}
Local oObj := IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
Local cIdPonto := IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
Local cIdModel := IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
Local lNewReg := IIf(Type("ParamIxb[4]")!="U",ParamIxb[4],.F.)
Local nOpcx := 0
Local uRet := .T.

If oObj == Nil .or. Empty(cIdPonto)
	Return(uRet)
Endif

If cIdPonto == "MODELVLDACTIVE"
nOpcx := oObj:GetOperation()
	If IsInCallStack("MATA240") .or. IsInCallStack("MATA241")
		If nOpcx == MODEL_OPERATION_INSERT
			Est27DescProd(oObj)
		Endif	
	Endif	
EndIf

aEval(aArea,{|x| RestArea(x)})

Return(uRet)                                                                  


Static Function Est27DescProd(oObj)

//Local aArea := {GetArea()}
Local oMdl := Nil
Local oStruct := Nil

// artificio usado apenas para mudar o tamanho do campo N1_DESCRIC temporariamente, pois o campo B1_DESC foi alterado e estah maior que o N1_DESCRIC, e nao se pode
// alterar o tamanho do campo do SN1, entao, muda-se o tamanho do campo do SN1 temporariamente, apenas para a inclusao do ativo, via rotina de movimento
// interno do estoque, sem este tratamento, ocorre erro na gravacao do movimento interno e o ativo fixo nao eh gravado.
oMdl := oObj:GetModel("SN1MASTER")
oStruct := oMdl:GetStruct()
oStruct:SetProperty("N1_DESCRIC",MODEL_FIELD_TAMANHO,TamSX3("B1_DESC")[1])
/*
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))
	oMdl := oObj:GetModel("SN1MASTER")
	oMdl:SetValue('SN1MASTER',"N1_DESCRIC",Subs(SB1->B1_DESC,1,TamSX3("N1_DESCRIC")[1]))
    /*
	SN2->(dbSetOrder(1))
	If SN2->(dbSeek(xFilial("SN2")+SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO))
		// deleta o que jah estiver gravado na SN2 para este item
		While SN2->(!Eof()) .and. xFilial("SN2")+SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO == ;
		SN2->N2_FILIAL+SN2->N2_CBASE+SN2->N2_ITEM+SN2->N2_TIPO
			If SN2->N2_SEQ == SN3->N3_SEQ
				SN2->(RecLock("SN2",.F.))
				SN2->(dbDelete())
				SN2->(MsUnLock())
			Endif
			SN2->(dbSkip())
		Enddo
		// regrava SN2
	Endif
	*/
//Endif
			
//aEval(aArea,{|x| RestArea(x)})

Return()	
					
/*
Static Function AtfItemD1()

Local aArea := {GetArea()}
Local cQ := ""
Local aRet := {}
Local cAliasTrb := GetNextAlias()

cQ := "SELECT R_E_C_N_O_ SD1_RECNO,D1_COD "
cQ += "FROM "+RetSqlName("SD1")+" SD1 "
cQ += "WHERE "
cQ += "D1_FILIAL = '"+xFilial("SD1")+"' "
cQ += "AND D1_SERIE = '"+SN1->N1_NSERIE+"' "
cQ += "AND D1_DOC = '"+SN1->N1_NFISCAL+"' "
cQ += "AND D1_FORNECE = '"+SN1->N1_FORNECE+"' "
cQ += "AND D1_LOJA = '"+SN1->N1_LOJA+"' "
cQ += "AND D1_SERIE = '"+SN1->N1_NSERIE+"' "
cQ += "AND D1_ITEM = '"+SN1->N1_NFITEM+"' "
cQ += "AND SD1.D_E_L_E_T_ <> '*' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	aAdd(aRet,(cAliasTrb)->SD1_RECNO)
	aAdd(aRet,(cAliasTrb)->D1_COD)
Else
	aAdd(aRet,0)
	aAdd(aRet,"")
Endif

(cAliasTrb)->(dbCloseArea()) 

aEval(aArea,{|x| RestArea(x)})	

Return(cRet)
*/	