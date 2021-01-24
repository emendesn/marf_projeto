#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFGFE26
Autor...............: Totvs
Data................: Julho/2018 
Descricao / Objetivo: Rotina para validar o campo GU3_CONICM, colocada no X3_VLDUSER deste campo
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Gravacao de campos do GFE
=====================================================================================
@alterações 21/10/2019 - Henrique Vidal
	a) Adicionado condição : ( Empty(cCNPJ) .or. valtype(cCNPJ) == "U" )  .And. IsInCallStack("MATA050") 
devido estar vindo nula na condição antiga.
    b) A condição antiga foi mantida para não afetar outros possíveis programas.
*/
User Function MGFGFE26(lInt)
// validacao colocada no x3_vlduser do campo gu3_conicm

Local aArea := {GU3->(GetArea()),GetArea()}
Local lRet := .T.
Local cAlias := IIf(lInt,"GU3->","M->")
//Local oModelGU3F
//Local oModel
Local cCNPJ := ""
Local cIE := ""
Local lContinua := .T.

// se estiver com as rotinas de cadastro de fornecedor e transpotadora na pilha e a variavel lInt = .F., 
// apenas retorna .T., senao a variavel lInt vai vir como .F. e a rotina vai tentar validar os campos
// da GFE, que se estiverem errados, nao vao passar pela validacao e tb nao vao conseguir serem alterados
If !lInt .and. (IsInCallStack("MATA020") .or. IsInCallStack("MATA050"))
	lContinua := .F.
Endif	

If lContinua
	// posicionar corretamente a gu3 no caso de integracao, pois nao dah pra garantir que jah vai estar posicionada neste PE
	If lInt
		If IsInCallStack("MATA020")
			cCNPJ := M->A2_CGC
			cIE := M->A2_INSCR
		Endif	
		If IsInCallStack("MATA050")
			cCNPJ := M->A4_CGC
			cIE := M->A4_INSEST
		Endif	

		If ( Empty(cCNPJ) .or. valtype(cCNPJ) == "U" )  .And. IsInCallStack("MATA050") 
			cCNPJ 	:= A4_CGC
			cIE 	:= A4_INSEST
		EndIf		

		GU3->(dbSetOrder(1))
		If GU3->(dbSeek(xFilial("GU3")+cCNPJ))
			GU3->(RecLock("GU3",.F.))
			If Empty(&(cAlias+"GU3_IE")) .or. Alltrim(Upper(&(cAlias+"GU3_IE"))) $ "ISENTO/ISENTA"
				&(cAlias+"GU3_CONICM") := "2"
			Else
				&(cAlias+"GU3_CONICM") := "1"
			Endif	
			&(cAlias+"GU3_IE") := cIE
			GU3->(MsUnLock())
		Else	
			lContinua := .F.
		Endif	
	Endif	
Endif

If lContinua
	If (!lInt .and. (&(cAlias+"GU3_TRANSP") == "1" .or. &(cAlias+"GU3_FORN") == "1")) // somente para transportador ou fornecedor
		If Empty(&(cAlias+"GU3_IE")) .or. Alltrim(Upper(&(cAlias+"GU3_IE"))) $ "ISENTO/ISENTA"
			If &(cAlias+"GU3_CONICM") == "1"
				lRet := .F.
				Help( ,, "Help",, "Campo 'Contrib. Icms' deve ser Não.", 1, 0 )
				//APMsgAlert("Campo 'Contrib. Icms' deve ser Nao.")
				//ShowHelpDlg("Conteúdo inválido",{"Campo 'Contrib. Icms' inválido",""},3,;
				//{"Campo 'Contrib. Icms' deve ser Não.",""},3)
				//oModel := FWLoadModel("GFEA015")		
				//oModel:Activate()
				//oModelGU3F := oModel:GetModel("GFEA015_GU3")
				//oModelGU3F:LoadValue('GU3_CONICM',"2")
				//oModel:Deactivate()
			Endif	
		Else
			If !&(cAlias+"GU3_CONICM") == "1"
				lRet := .F.
				Help( ,, "Help",, "Campo 'Contrib. Icms' deve ser Sim.", 1, 0 )
			Endif	
		Endif	
	Endif			
Endif
	
aEval(aArea,{|x| RestArea(x)})

Return(lRet)