#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"                                                                                                                   

/*
=====================================================================================
Programa............: MGFTAE16
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao TAURA - ENTRADAS
Doc. Origem.........: Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Programa WebService Client Metodo: AvisoChegada
=====================================================================================
*/                                                    

User Function MGFTAE16

Local cJson	     := ""
Local cPostRet   := ""
Local nTimeOut   := 0
Local aHeadOut   := {}
Local cHeadRet   := ""
Local oObjRet    := Nil
Local oItens     := Nil
Local lRet       := .F.
Local nCnt       := 0
Local cQuery     := ''

Private aMatriz     := {"01","010001"}  
Private lIsBlind    :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
Private cCNPJ       := '' 
Private cTipoNF     := ''
Private aSM0        := {}
Private cTransp     := ''
Private cExportacao := ''
Private cCodigo     := ''
Private cLoja       := ''
Private cCodMarfrig := ''
Private nVUNIT      := 0 
Private cUM         := ''

//IF lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
  //	If !LockByName("MGFTAE16")
  //		Conout("JOB j� em Execucao : MGFTAE16 " + DTOC(dDATABASE) + " - " + TIME() )
 //		RpcClearEnv()
  //		Return
 //	EndIf   //"PDWVTDS001/wsIntegracaoTaura/api/v0/AvisoChegada/AvisoChegada"
//EndIF

cURLPost := GetMV('MGF_TAE09',.F.,"http://spdwvtds002/wsintegracaoshape/api/v0/AvisoChegada/AvisoChegada")

//AAdd(aHeadOut,'Content-Type: application/Json')
dbSelectArea('SD2')
SD2->(dbSetOrder(3))
dbSelectArea('SC5')
SD2->(dbSetOrder(1))

conOut("********************************************************************************************************************")
conOut('Inicio do processamento - MGFTAE16 - Aviso de Recebimento - ' + DTOC(dDATABASE) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)

cQuery := " SELECT ZZH_FILIAL,ZZH_AR,ZZH_DOC,ZZH_SERIE,ZZH_OBS,ZZH_CNF,ZZH_FORNEC,ZZH_LOJA,F1_TIPO,F1_FORNECE,F1_LOJA,F1_TRANSP, F1_DTDIGIT F1_EMISSAO,F1_PLACA,F1_TPFRETE,ZZH.R_E_C_N_O_ REGZZH," + CRLF
cQuery += "        CASE WHEN ZZH_STATUS = '0' THEN 'N' ELSE 'S' END DELZZH"  + CRLF
cQuery += " FROM "+RetSQLName("ZZH")+" ZZH, "+RetSQLName("SF1")+" SF1 "  + CRLF
cQuery += " WHERE ( (ZZH_STATUS = '0' AND ZZH.D_E_L_E_T_ = ' ' ) OR (ZZH_STATUS = '9' AND ZZH.D_E_L_E_T_ = '*'))  " + CRLF
cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "  + CRLF
cQuery += "   AND ZZH_FILIAL     = F1_FILIAL  " + CRLF
cQuery += "   AND ZZH_FORNEC     = F1_FORNECE " + CRLF
cQuery += "   AND ZZH_LOJA       = F1_LOJA    " + CRLF
cQuery += "   AND ZZH_DOC        = F1_DOC     " + CRLF
cQuery += "   AND ZZH_SERIE      = F1_SERIE   " + CRLF
cQuery += " UNION"  + CRLF
cQuery += " Select  ZZH_FILIAL,                                                                                              " + CRLF 
cQuery += "         ZZH_AR,                                                                                                  " + CRLF
cQuery += "         ZZH_AR ZZH_DOC,                                                                                          " + CRLF
cQuery += "         '001'ZZH_SERIE,                                                                                          " + CRLF
cQuery += "         ZZH_OBS,                                                                                                 " + CRLF
cQuery += "         ZZH_CNF,                                                                                                 " + CRLF
//cQuery += "         ZZH_DEVCOD," //Adicionado o ao motivo ao item RITM0012774-MOT_DEV
cQuery += "         ZZH_FORNEC,                                                                                              " + CRLF
cQuery += "         ZZH_LOJA,                                                                                                " + CRLF
cQuery += "         'N' F1_TIPO,                                                                                             " + CRLF
cQuery += "         ZZH_FORNEC F1_FORNECE,                                                                                   " + CRLF
cQuery += "         ZZH_LOJA   F1_LOJA,                                                                                      " + CRLF
cQuery += "         DAK_TRANSP F1_TRANSP,                                                                                    " + CRLF
cQuery += "         DAK_DATA   F1_EMISSAO,                                                                                   " + CRLF
cQuery += "         (Select DA3_PLACA                                                                                        " + CRLF
cQuery += "          from "+RetSQLName("DA3")+" x                                                                            " + CRLF
cQuery += "          Where x.D_E_L_E_T_ = ' '                                                                                " + CRLF
cQuery += "            AND DA3_COD = DAK_CAMINH )F1_PLACA,                                                                   " + CRLF
cQuery += "         'C' F1_TPFRETE,                                                                                          " + CRLF
cQuery += "         a.R_E_C_N_O_ REGZZH,                                                                                     " + CRLF
cQuery += "         CASE WHEN ZZH_STATUS = '0' THEN 'N' ELSE 'S' END DELZZH                                                  " + CRLF
cQuery += " FROM "+RetSQLName("ZZH")+" A, "+RetSQLName("DAK")+" B "                                                           + CRLF
cQuery += "  WHERE ( (ZZH_STATUS = '0' AND A.D_E_L_E_T_ = ' ' ) OR (ZZH_STATUS = '9' AND A.D_E_L_E_T_ = '*'))                " + CRLF
cQuery += "    AND b.D_E_L_E_T_ = ' '                                                                                        " + CRLF
cQuery += "    AND SUBSTR(ZZH_AR,1,1) = 'S'                                                                                  " + CRLF
cQuery += "    AND ZZH_FILIAL = DAK_FILIAL                                                                                   " + CRLF
cQuery += "    AND ZZH_DOCMOV = DAK_COD                                                                                      " + CRLF

//ConOut("MGFTAE16 - cQuery ZZH: " + CRLF +cQuery)
//conOut("********************************************************************************************************************"+ CRLF)

If Select("QRY_AR") > 0
	QRY_AR->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_AR",.T.,.F.)
dbSelectArea("QRY_AR")
QRY_AR->(dbGoTop())
While !QRY_AR->(EOF())
	cFilAnt := QRY_AR->ZZH_FILIAL
	cCodigo     := ''
	cLoja       := ''
	cCodMarfrig := ''
	IF QRY_AR->F1_TIPO=='D'
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial('SA1')+ALLTRIM(QRY_AR->F1_FORNECE)+QRY_AR->F1_LOJA))
			cTipoNF  := 'D'
			If Empty(SA1->A1_CGC) 
				cCNPJ       := ''
				cCodMarfrig := SA1->A1_ZCODMGF
				cCodigo     := SA1->A1_COD
				cLoja       := SA1->A1_LOJA
			Else              
			    cCodMarfrig := ''
			    cCNPJ       := Alltrim(SA1->A1_CGC)
				cCodigo     := SA1->A1_COD
				cLoja       := SA1->A1_LOJA
			Endif
		EndIF
	Else
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial('SA2')+ALLTRIM(QRY_AR->F1_FORNECE)+QRY_AR->F1_LOJA))
			If Empty(SA2->A2_CGC) 
				cCNPJ       := ''
				cCodMarfrig := SA2->A2_ZCODMGF
				cCodigo     := SA2->A2_COD
				cLoja       := SA2->A2_LOJA
			Else              
			    cCodMarfrig := ''
			    cCNPJ       := Alltrim(SA2->A2_CGC)
				cCodigo     := SA2->A2_COD
				cLoja       := SA2->A2_LOJA
			Endif
			cTipoNF  := 'T'
			IF SUBSTR(QRY_AR->ZZH_AR,1,1)=='S'
				cTipoNF  := 'D'
			Else
				aSM0 := FWLoadSM0()
				nPos      := ASCAN(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ)})
				IF nPos <> 0
					cTipoNF  := 'R'
				EndIF
			EndIF
		EndIF
	EndIF  
	cExportacao := ''
	cTransp     := ''
	IF !Empty(QRY_AR->F1_TRANSP)
		SA4->(dbSetOrder(1))
		If SA4->(dbSeek(xFilial('SA4')+QRY_AR->F1_TRANSP))
			IF SA4->A4_ZPAIS <> 'BR'
				cExportacao := Alltrim(SA4->A4_ZCODMGF) 
				cTransp     := ''
			ElSE
				cTransp     := Alltrim(SA4->A4_CGC)
				cExportacao := ''
			EndIF
		EndIF
	EndIF
	oAR := Nil
	oAR := AvisoChegada():New()
	oAR:Mestre()
	SD1->(dbSetOrder(1)) //filial, doc, serie, fornec, loja , produto, item
	cQuery := " SELECT *" + CRLF
	cQuery += " FROM "+RetSQLName("ZZI")+" ZZI"  + CRLF
	cQuery += "   WHERE ZZI_FILIAL   = '"+QRY_AR->ZZH_FILIAL+"'"  + CRLF
	cQuery += "   AND ZZI_AR         = '"+QRY_AR->ZZH_AR+"'" + CRLF
	If QRY_AR->DELZZH == "N" + CRLF
		cQuery += " AND ZZI.D_E_L_E_T_ = ' ' " + CRLF
	Elseif QRY_AR->DELZZH == "S"
		cQuery += " AND ZZI.D_E_L_E_T_ = '*' " + CRLF	//AR deletado
	Endif	
	
	If Select("QRY_ARITEM") > 0
		QRY_ARITEM->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)

//	ConOut("MGFTAE16 - cQuery ZZI: " + CRLF + cQuery)
//	conOut("********************************************************************************************************************"+ CRLF)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ARITEM",.T.,.F.)
	dbSelectArea("QRY_ARITEM")
	QRY_ARITEM->(dbGoTop())
	While !QRY_ARITEM->(EOF())
		IF SUBSTR(QRY_AR->ZZH_AR,1,1)=='S'
			nVUNIT      := 1
			cUM         := GetAdvFVal( "SB1", "B1_UM", xFilial('SB1')+QRY_ARITEM->ZZI_PRODUT, 1, "" )
			oAR:Item()
		Else
			IF SD1->(dbSeek(QRY_AR->ZZH_FILIAL+QRY_AR->ZZH_DOC+QRY_AR->ZZH_SERIE+SUBSTR(QRY_AR->ZZH_FORNEC,1,TamSx3('D1_FORNECE')[01])+QRY_AR->ZZH_LOJA+QRY_ARITEM->ZZI_PRODUT+QRY_ARITEM->ZZI_ITEM))
				nVUNIT      := SD1->D1_VUNIT
				cUM         := SD1->D1_UM
				oAR:Item()
			EndIF
		EndIF
		QRY_ARITEM->(dbSkip())                 
	Enddo          
	                                
	oWSAR := MGFINT53():new(cURLPost, oAR ,0, "", "", AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT07")),QRY_AR->ZZH_AR,.F.,.F.,.T. )
   	//MemoWrite("c:\temp\"+FunName()+"_Result_"+StrTran(Time(),":","")+".txt",oWSAR:CDETAILINT)
	//MemoWrite("c:\temp\"+FunName()+"_json_"+StrTran(Time(),":","")+".txt",oWSAR:CJSON)
	StaticCall(MGFTAC01,ForcaIsBlind,oWSAR)
	If oWSAR:lOk .And. oWSAR:nStatus == 1
		cQuery := "UPDATE "
		cQuery += RetSqlName("ZZH")+" "
		cQuery += "SET ZZH_STATUS = '1' "
		cQuery += "WHERE R_E_C_N_O_ = "+Alltrim(Str(QRY_AR->REGZZH))
		IF (TcSQLExec(cQuery) < 0)        
			conOut(TcSQLError())
		EndIF
	Else

	conOut("********************************************************************************************************************")
	conOut('Erro de integracao - MGFTAE16 - Aviso de Recebimento - ' + DTOC(dDATABASE) + " - " + TIME() + CRLF )
	ConOut(oWSAR:cDetailInt + CRLF)
	ConOut("JSON" + CRLF)
	ConOut(oWSAR:cJson + CRLF)
	conOut("********************************************************************************************************************"+ CRLF)                          
	Endif
	QRY_AR->(dbSkip())
EndDo

conOut("********************************************************************************************************************")
conOut('Final do processamento - MGFTAE16 - Aviso de Recebimento - ' + DTOC(dDATABASE) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)

Return 
***************************************************
Class ItensAR       

	Data COD_PED          as String
	Data SEQ_NF           as String
	Data COD_PROD         as String
	Data QUANT            as Float
	Data UNIDADE          as String
	Data PRECO            as Float
	Data COD_PEDCAR       as String
	Data DATA_PEDCAR      as String
	Data IDTIPOPEDCARERP  as String
	Data VOLUMES          as Float      
	Data Num_DI           as String
	Data MOTIVO			  as String                    
	
	Method New()

endclass
Return


*************************************************************************************************************************************************************
Class AvisoChegada

	Data operacao         as String
	Data cod_ped          as String
	Data data_ped         as String
	Data cod_emp          as String
	Data loja             as String
	Data num_nf           as String
	Data data_nf          as String
	Data tipo             as String
	Data obs              as String
	Data status           as Integer
	Data cod_emp_dest     as String
	Data csn_sif          as String
	Data cnpj_transp      as String
	Data serie_nf         as String
	Data placa            as String
	Data cnpj             as String
	Data tipofrete        as String
	Data numeroexportacao as String
	Data numeroexportacao_transp as String
	Data Itens			  as Array 

	Method New()
	Method Mestre()
	Method Item()

endclass
Return
***************************************************
Method New() Class AvisoChegada

Return
***************************************************
Method Mestre() Class AvisoChegada

Local cStringTime := "T00:00:00"
	
::operacao         := IIf(QRY_AR->DELZZH == "N",'1','3')
::cod_ped          := QRY_AR->ZZH_AR
::data_ped         := SUBSTR(QRY_AR->F1_EMISSAO,1,4)+'-'+SUBSTR(QRY_AR->F1_EMISSAO,5,2)+'-'+SUBSTR(QRY_AR->F1_EMISSAO,7,2)+cStringTime//SUBSTR(DTOS(dDatabase),1,4)+'-'+SUBSTR(DTOS(dDatabase),5,2)+'-'+SUBSTR(DTOS(dDatabase),7,2)+cStringTime
::num_nf           := Alltrim(QRY_AR->ZZH_DOC) 
::data_nf          := SUBSTR(QRY_AR->F1_EMISSAO,1,4)+'-'+SUBSTR(QRY_AR->F1_EMISSAO,5,2)+'-'+SUBSTR(QRY_AR->F1_EMISSAO,7,2)+cStringTime
::tipo             := cTipoNF
::obs              := Alltrim(QRY_AR->ZZH_OBS) 	
::status           := '1'
::cod_emp_dest     := QRY_AR->ZZH_FILIAL             
::csn_sif          := Alltrim(QRY_AR->ZZH_CNF)
::serie_nf         := QRY_AR->ZZH_SERIE
::placa            := Alltrim(StrTran(StrTran(StrTran(QRY_AR->F1_PLACA," ",""),"-",""),".",""))
::tipofrete        := Alltrim(QRY_AR->F1_TPFRETE)
::cod_emp          := cCodigo
::loja             := cLoja
::numeroexportacao := cCodMarfrig
::cnpj             := Alltrim(cCNPJ) 
::cnpj_transp             := cTransp              	
::numeroexportacao_transp := cExportacao

::Itens	:= {}

Return()
***************************************************

Method Item() Class AvisoChegada

Local cStringTime := "T00:00:00"     
Local cDtPedCar   := "1900-01-01"           
Local cCodPedCar  := ''                  
Local cTipoPed    := ''

aAdd(::Itens,WSClassNew( "ItensAR")) 

IF QRY_AR->F1_TIPO=='D'
    IF !Empty(SD1->D1_NFORI)                   
        SD2->(dbSetOrder(3))
        IF SD2->(dbSeek(SD1->D1_FILIAL+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI))
            IF SC5->(dbSeek(SD1->D1_FILIAL+SD2->D2_PEDIDO))
            	cCodPedCar  := SD2->D2_PEDIDO
                cDtPedCar   := Subs(dTos(SC5->C5_EMISSAO),1,4)+"-"+Subs(dTos(SC5->C5_EMISSAO),5,2)+"-"+Subs(dTos(SC5->C5_EMISSAO),7,2)
                cTipoPed    := SC5->C5_ZTIPPED
            EndIF
        EndIF
    EndIF     
EndIF
::Itens[Len(::Itens)]:COD_PED     := QRY_AR->ZZH_AR
::Itens[Len(::Itens)]:SEQ_NF      := QRY_ARITEM->ZZI_ITEM
::Itens[Len(::Itens)]:COD_PROD    := Alltrim(QRY_ARITEM->ZZI_PRODUT)
::Itens[Len(::Itens)]:QUANT 	  := QRY_ARITEM->ZZI_QNF
::Itens[Len(::Itens)]:UNIDADE 	  := cUM
::Itens[Len(::Itens)]:PRECO 	  := nVUNIT
::Itens[Len(::Itens)]:COD_PEDCAR  := cCodPedCar
::Itens[Len(::Itens)]:DATA_PEDCAR := cDtPedCar+cStringTime
::Itens[Len(::Itens)]:IDTIPOPEDCARERP := cTipoPed
::Itens[Len(::Itens)]:VOLUMES     := QRY_ARITEM->ZZI_QNF //SD1->D1_ZVOL
::Itens[Len(::Itens)]:NUM_DI      := ""
::Itens[Len(::Itens)]:MOTIVO      := QRY_ARITEM->ZZI_CODJUS         

Return()
***************************************************

		/*cJson := fwJsonSerialize(oAR,.F.,.T.)
		MemoWrite("MGFTAE16"+StrTran(Time(),":","")+".txt",cJson)
		//MemoWrite("C:\TEMP\MGFTAE16"+StrTran(Time(),":","")+".txt",cJson)
		alert(cjson)
		cPostRet := httpPost(cURLPost,,cJson,nTimeOut,aHeadOut,@cHeadRet)
		alert(cpostret)
		alert(cheadret)
		MemoWrite("c:\temp\MGFTAE16"+StrTran(Time(),":","")+".txt",oAR:cJson)
		IF !Empty(cPostRet)
			// sucesso
			fwJsonDeserialize(cPostRet,@oObjRet)
			If .T. //oObjRet???
				// sucesso
				lRet := .T.
			Else
				// erro
			Endif
		Else
			// erro
		Endif
		  */

