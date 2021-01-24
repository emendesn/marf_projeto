#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFFIN87
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descricao / Objetivo: Tipo de Valor do Contas a Pagar
Doc. Origem.........: MIT044- CAP016 - Tipo de Valor
Solicitante.........: Cliente - Mauricio CAP
Uso.................: Marfrig
Obs.................: Pontos de Entrada
                      1 = F040ALT - Para atualizar o valor Acrescimo e Decrescimo
                      2 = F050B01 - Para exclusão da ZDS na exclusão do Titulo
                      3 = CTBGRV  - Para marcar o campo CT2_DTCV3 em Branco
                      4 = DPCTB102GR - Para marcar os Flags como N na Exclusão
                      5 = ANCTB102GR - Para marcar os Flags como N na Exclusão do Lote
                      MGFFINCTB - Função que gera a movimentação.
=====================================================================================
*/
User Function MGFFIN87(nTipo,nOpc,dDatalanc,cLoteP,cSubLote,cDoc)
Local cLoteCTB	 := Alltrim(GetMV('MGF_FIN87A',.F.,"000230"))
Local cQuery     := ''
      
IF nTipo  == 1
	aRet := U_MFIN88SUM()
	Reclock("SE2",.F.)
	SE2->E2_DECRESC  := aRet[02] + SE2->E2_ZVARPA
	SE2->E2_ACRESC   := aRet[01] + SE2->E2_ZVARAT
	IF SE2->E2_VALOR == SE2->E2_SALDO
		SE2->E2_SDDECRE := aRet[02] + SE2->E2_ZVARPA
		SE2->E2_SDACRES := aRet[01] + SE2->E2_ZVARAT
	EndIF
	SE2->(MsUnlock())
ELSEIF nTipo == 2 .AND. !INCLUI .AND. !ALTERA
	ZDS->(dbSetOrder(1))
	ZDS->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	While ZDS->(!Eof()) .And.;
		SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
		ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA )
		
		Reclock("ZDS",.F.)
		ZDS->(dbDelete())
		ZDS->(MsUnlock())
		ZDS->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	End
ELSEIF nTipo == 3
	IF (nOpc == 3 .OR. nOpc == 4 ) .And. (Alltrim(cLoteP) =='MGFFIN87' .OR. isInCallStack("U_MGFFINCTB") ) //.OR. isInCallStack("U_MGFFIN88") ) //Alltrim(cLoteP)== Alltrim(cLoteCTB)
		CT2->CT2_DTCV3 = CTOD('  /  /  ')
	EndIF
ELSEIF nTipo == 4
	IF nOpc == 5 .And. Alltrim(cLoteP)== Alltrim(cLoteCTB)
		dbSelectArea('ZDS')
		ZDS->(dbSetOrder(1))
		dbSelectArea("TMP")
		TMP->(dbGotop())
		While TMP->(!Eof())
			If !TMP->CT2_FLAG 
				ZDS->(dbSeek(Alltrim(TMP->CT2_KEY)))
				While ZDS->(!Eof()) .And.  ;
					Alltrim(ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA)) == Alltrim(TMP->CT2_KEY)
					Reclock("ZDS",.F.)
					If TMP->CT2_LP == '231'
						ZDS->ZDS_LAE    := 'N'
					Else
						ZDS->ZDS_LA     := 'N'
					EndIF
					ZDS->(MsUnlock())
					ZDS->(dbSkip())
				End
			EndIf
			TMP->(dbSkip())
		EndDo
	EndIF
ELSEIF nTipo == 5
	IF nOpc == 5  .And. Empty(cLoteP)
		dbSelectArea('ZDS')
		ZDS->(dbSetOrder(1))
		dbSelectArea("TMP")
		TMP->(dbGotop())
		While TMP->(!Eof())
			If !TMP->CT2_FLAG 
			    CT2->(dbGoTo(TMP->CT2_RECNO)) 
			    IF Alltrim(CT2->CT2_LOTE) == Alltrim(cLoteCTB)
					ZDS->(dbSeek(Alltrim(TMP->CT2_KEY)))
					While ZDS->(!Eof()) .And.  ;
						Alltrim(ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA)) == Alltrim(TMP->CT2_KEY)
						Reclock("ZDS",.F.)
						If TMP->CT2_LP == '231'
							ZDS->ZDS_LAE    := 'N'
						Else
							ZDS->ZDS_LA     := 'N'
						EndIF
						ZDS->(MsUnlock())
						ZDS->(dbSkip())
					End
			    EndIF
			EndIf
			TMP->(dbSkip())
		EndDo
	EndIF

EndIF
Return          
/*
=====================================================================================
Programa............: MGFFINCTB
Autor...............: Marcelo Carneiro
Data................: 12/03/2018
Descrição / Objetivo: Realiza Contabilização dos Rateios de Tipo de Valor
Doc. Origem.........: FIN - Tipo de Valor
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MGFFINCTB()

Private aParamBox := {} 
Private aRet      := {}
Private aSimNao   := {'Sim','Não'}           

AAdd(aParamBox, {2, "Monstra Lançamentos:"	,1,aSimNao , 050	, , .F.	})
AAdd(aParamBox, {1, "Dt.Inicio:"	    ,CTOD('  /  /  ')                     , "@!",,      ,, 050	, .T.	})
AAdd(aParamBox, {1, "Dt.Fim:"	        ,CTOD('  /  /  ')                     , "@!",,      ,, 050	, .T.	})
AAdd(aParamBox, {1, "Filial de:"       	,Space(tamSx3("A2_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
AAdd(aParamBox, {1, "Filial Até:"      	,Space(tamSx3("A2_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
IF ParamBox(aParambox, "Gera Contabilização por Tipo de Valor"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	IF VALTYPE(MV_PAR01) == 'C'
		IF MV_PAR01 == 'Sim'     
		    MV_PAR01 := 1 
		Else
		    MV_PAR01 := 2 
		EndIF
	EndIF
	
	Processa( {|| Contab_TP() },'Aguarde...', 'Gerando Lote Contabil',.F. )
	
EndIF

Return
*****************************************************************************************************************************************
Static Function Contab_TP()

Local aCT5		  := {}
Local lExibeLcto  := IIF(MV_PAR01 == 1 ,.T.,.F.)
Local cLoteCTB	  := Alltrim(GetMV('MGF_FIN87A',.F.,"000230"))         
Local cArqCTB	  := ""
Local nTotalLcto  := 0
Local cRel        := ''
Local dxDt		  := dDataBase
Local aFlagCTB    := {}
Local cQuery      := ''
Local cLP         := ''
Local aZDS        := {} 
Local aFil        := {}
Local nI          := 0                                     
Local nPos        := 0 
Local cChave      := ''
Local cbkFIL      := cFilAnt
Local dDtHav      := ''
Local lTempRet    := .F.
Local aERROS      := {}
Local lRet        := .T.

ZDR->(dbSetOrder(1))
ZDS->(dbSetOrder(1))
SA2->(dbSetOrder(1))


cQuery += " Select Distinct                                                                                                                "
cQuery += "        E5_FILIAL,                                                                                                              "
cQuery += "        E5_DATA,                                                                                                                "
cQuery += "        CASE   WHEN E5_TIPODOC = 'ES'   THEN '231'                                                                              "
cQuery += "               WHEN E5_DOCUMEN = ' ' OR RTRIM(LTRIM(E5_MOTBX)) in ('PCC','LIQ','IRF') OR E5_ORIGEM like '%FINA080%' THEN '230'  "
cQuery += "        ELSE  '232'                                                                                                             "
cQuery += "        END LP,                                                                                                                 "
cQuery += "        ZDS.R_E_C_N_O_ RECZDS                                                                                                   "
cQuery += " from "+RetSQLName("SE5")+" SE5, "+RetSQLName("SE2")+" SE2 , "+RetSQLName("ZDS")+" ZDS                                                                                       "
cQuery += " Where SE5.D_E_L_E_T_ = ' '                                                                                                     "
cQuery += "   AND SE2.D_E_L_E_T_ = ' '                                                                                                     "
cQuery += "   AND ZDS.D_E_L_E_T_ = ' '                                                                                                     "
cQuery += "   AND E5_DATA        >= '"+DTOS(MV_PAR02)+"'                                                                                             "
cQuery += "   AND E5_DATA        <= '"+DTOS(MV_PAR03)+"'                                                                                             "
IF !Empty(MV_PAR04)
	cQuery += "   AND E5_FILIAL      >= '"+MV_PAR04+"'                                                                                             "
EndIF
IF !Empty(MV_PAR05)
	cQuery += "   AND E5_FILIAL      <= '"+MV_PAR05+"'                                                                                             "
EndIF
cQuery += "   AND E5_FILIAL      = E2_FILIAL                                                                                               "
cQuery += "   AND E5_PREFIXO     = E2_PREFIXO                                                                                              "
cQuery += "   AND E5_NUMERO      = E2_NUM                                                                                                  "
cQuery += "   AND E5_PARCELA     = E2_PARCELA                                                                                              "
cQuery += "   AND E5_TIPO        = E2_TIPO                                                                                                 "
cQuery += "   AND E5_CLIFOR      = E2_FORNECE                                                                                              "
cQuery += "   AND E5_LOJA        = E2_LOJA                                                                                                 "
cQuery += "   AND E2_FILIAL      = ZDS_FILIAL                                                                                              "
cQuery += "   AND E2_PREFIXO     = ZDS_PREFIX                                                                                              "
cQuery += "   AND E2_NUM         = ZDS_NUM                                                                                                 "
cQuery += "   AND E2_PARCELA     = ZDS_PARCEL                                                                                              "
cQuery += "   AND E2_TIPO        = ZDS_TIPO                                                                                                "
cQuery += "   AND E2_FORNECE     = ZDS_FORNEC                                                                                              "
cQuery += "   AND E2_LOJA        = ZDS_LOJA                                                                                                "
cQuery += "   AND (E5_VLACRES	 > 0  OR E5_VLDECRE > 0 )                                                                                  "
cQuery += "   AND E5_SITUACA     <> 'C'	                                                                                                   "
cQuery += "   ORDER BY 1,3,2 "
If Select("QRY_ZDS") > 0
	QRY_ZDS->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)       
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZDS",.T.,.F.)
dbSelectArea("QRY_ZDS")
QRY_ZDS->(dbGoTop())
While QRY_ZDS->(!EOF())
	ZDS->(dbGoTo(QRY_ZDS->RECZDS))
	IF (QRY_ZDS->LP == '231' .AND. ZDS->ZDS_LAE=='N') .OR. (QRY_ZDS->LP <> '231' .AND. ZDS->ZDS_LA=='N') 
	   AAdd(aZDS,{QRY_ZDS->RECZDS,QRY_ZDS->LP,QRY_ZDS->E5_DATA,QRY_ZDS->E5_FILIAL+QRY_ZDS->LP+QRY_ZDS->E5_DATA})
	EndIF
	IF AScan(aFil,{|x|  x[3] == QRY_ZDS->E5_FILIAL+QRY_ZDS->E5_DATA })  == 0
	    AAdd(aFil,{QRY_ZDS->E5_FILIAL,QRY_ZDS->E5_DATA,QRY_ZDS->E5_FILIAL+QRY_ZDS->E5_DATA})
	EndIF
	QRY_ZDS->(DbSkip())
End                     
IF Len(aZDS) == 0 
     msgAlert('Sem registros para contabilizar')
Else
	//Percorre Array, e verifica como esta o calendario para essas filiais e datas
	For ni := 1  To Len(aFil)
		
		cFilAnt  := aFil[ni,1]//Filial
		
		SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
		SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
		
		dDtHav 	 := STOD(aFil[ni,2]) //Pega Data
		lTempRet := U_XXVlDtCal(dDtHav,dDtHav) //Realiza Validação do Periodo
		
		If !lTempRet
			AADD(aERROS,'Filial: ' + aFil[ni,1] + ', Data: ' + dToC(dDtHav))
			lRet := .F.
		EndIf
		
	Next ni
	
	//Verifica se Gerou erros e apresenta as filiais e datas que estão com datas em calendarios INDISPONIVEIS
	If Len(aERROS) > 0
		For ni := 1 to Len(aERROS)
			cErros += aERROS[ni]
		Next ni
		AVISO('Periodo Bloqueado',cErros,{'OK'},3)
	EndIf
	
	IF 	lRet
		For nI := 1 To Len(aZDS)        
		    ZDS->(dbGoTo(aZDS[nI,01]))
			ZDR->(dbSeek(xFilial('ZDR')+ZDS->ZDS_COD))
			SA2->(dbSeek(xFilial('SA2')+ZDS->ZDS_FORNEC+ZDS->ZDS_LOJA))
			cRel := CtRelation(aZDS[nI,02])
			IF cChave <> aZDS[nI,04]
				IF nI == 1 
				   cFilAnt := SubStr(aZDS[nI,04],1,6)
				Else                         
					RodaProva(nHeadProv,nTotalLcto)
					cA100Incl(cArqCTB,nHeadProv,1,cLoteCTB,lExibeLcto,.F.,,dxDt,,@aFlagCTB)

					nTotalLcto  := 0
					cFilAnt := SubStr(aZDS[nI,04],1,6)
					ZDS->(dbGoTo(aZDS[nI,01]))
					ZDR->(dbSeek(xFilial('ZDR')+ZDS->ZDS_COD))
					SA2->(dbSeek(xFilial('SA2')+ZDS->ZDS_FORNEC+ZDS->ZDS_LOJA))
					cRel := CtRelation(aZDS[nI,02])
				EndIF                                              
				aCT5     := {}       
				dxDt     := STOD(aZDS[nI,03])
				cLP      := aZDS[nI,02]
				cChave   := aZDS[nI,04]
				aFlagCTB := {}
				nHeadProv  := HeadProva(cLoteCTB,"MGFFIN87",Substr(cUsuario,7,6),@cArqCTB)
			EndIF       
			IF aZDS[nI,02] == '231'
				AADD(aFlagCTB,{"ZDS_LAE",'S',"ZDS",ZDS->(Recno()),0,0,0})
			Else
				AADD(aFlagCTB,{"ZDS_LA",'S',"ZDS",ZDS->(Recno()),0,0,0})
			EndIF
			nTotalLcto += DetProva(nHeadProv,cLP,"MGFFIN87",cLoteCTB,,,,,@cRel,@aCT5,,@aFlagCTB)
		Next nI
		RodaProva(nHeadProv,nTotalLcto)
		cA100Incl(cArqCTB,nHeadProv,1,cLoteCTB,lExibeLcto,.F.,,dxDt,,@aFlagCTB)
	EndIF	
EndIF

cFilAnt := cbkFIL     

Return


