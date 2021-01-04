#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"                                                                                                                   

// includes usados no fonte padrao SPEDNFe, manter
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "PARMTYPE.CH"
//

/*
=====================================================================================
Programa............: MGFTAS03
Autor...............: Mauricio Gresele
Data................: 18/11/2016 
Descricao / Objetivo: Integração Protheus-Taura, para envio de Nota de saída
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFTAS03(aParam)

//If IsBlind()
//	StartJob( "U_TAS03", GetEnvServer(), .T., {"01", "010001"} )
//Else


 	RpcSetType(3)
 	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" //aParam[1] FILIAL aParam[2]

	Conout("MGFTAS03 Executando  - "+DTOC(dDATABASE) + " - " + TIME() )

	U_TAS03({"01", "010001"})

	Conout("MGFTAS03 FIM  - "+DTOC(dDATABASE) + " - " + TIME() )

//Endif		

Return()


User Function TAS03(aParam)

//If IsBlind()
//	RpcSetType(3)
 //	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" //aParam[1] FILIAL aParam[2]
//Endif	
//If !LockByName(ProcName())
//	Conout("JOB já em Execução : " + ProcName() + " - "+DTOC(dDATABASE) + " - " + TIME() )
//	If IsBlind()
 //		RpcClearEnv() // Limpa o ambiente, liberando a licença e fechando as conexões
 //	Endif	
//	Return
//EndIf
//conout("MGFTAS03 - Taura - Iniciando integração de Nota de Saida")
//SET DELETE OFF // OBS: processa linhas deletadas
U_TAS03FilNfs()
//SET DELETE ON
//conout("MGFTAS03 - Taura - Finalizando integração de Nota de Saída")
UnLockByName(ProcName())
If IsBlind()
	RESET ENVIRONMENT
Endif	

Return()


// funcao de envio da Nf para o Taura
User Function TAS03EnvNfs(aParam)

Local aArea := {SF2->(GetArea()),GetArea()}
Local cURLEnv  := Alltrim(GetMv("MGF_URLTNF")) // "http://SPDWVTDS001/wsIntegracaoTaura/api/v0/faturamento/GravarNotaSaida"
Local cURLCan  := Alltrim(GetMv("MGF_URLCAN")) // "http://spdwvtds002/wsintegracaoShape/api/v0/Faturamento/CancelarNotaSaida"
Local cURLPost := ''
/*
Local cJson := ""
Local cPostRet := ""
Local nTimeOut := 0//GetMv("")
Local aHeadOut := {}
Local cHeadRet := ""
Local oObjRet := Nil
*/
Local aNfs := aParam[1]
Local cStatus := aParam[2]
Local lRet := .F.
Local nCnt := 0
Local cAliasTrb := GetNextAlias()
Local cQ := ""
//Local oWSNfs := Nil
Local cChave    := ""     
Local cMonitor  := ''

Private oNfs := Nil
Private oWSNfs := Nil

//aadd(aHeadOut,'Content-Type: application/Json')

//SF2->(dbSetOrder(1))
//If SF2->(dbSeek(aNfs[1]+aNfs[2]+aNfs[3]+aNfs[4]+aNfs[5]))
SF2->(dbGoto(aParam[3]))
If SF2->(Recno()) == aParam[3] 
	// 06/11/18 - garantir que nota deletada, seja enviada primeiro como inclusao, apenas para protecao da rotina.
	If cStatus == "C" .and. Empty(SF2->F2_ZTAUINT)
		cStatus := "N"
	Endif	

	If (!SF2->(Deleted()) .and. !Empty(SF2->F2_CHVNFE) .and. SF2->F2_FIMP == "S") .or. (SF2->(Deleted())) // ativas e autorizadas ou deletadas
		cChave := aNfs[2]+aNfs[3]
		cQ := "SELECT D2_FILIAL,D2_PEDIDO,C5_ZTIPPED,F2_CARGA,F2_DOC,F2_SERIE,F2_EMISSAO,F2_CHVNFE,A4_CGC,F2_VALBRUT,D2_CLIENTE,D2_LOJA,D2_TIPO,C5_EMISSAO "
		cQ += "FROM "+RetSqlName("SF2")+" SF2 "
		cQ += "JOIN "+RetSqlName("SD2")+" SD2 "
		//cQ += "ON SD2.D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
		cQ += "ON D2_FILIAL = F2_FILIAL "
		cQ += "AND D2_SERIE = F2_SERIE "
		cQ += "AND D2_DOC = F2_DOC "
		cQ += "AND D2_CLIENTE = F2_CLIENTE "
		cQ += "AND D2_LOJA = F2_LOJA "
		cQ += "AND D2_EMISSAO = F2_EMISSAO "
		cQ += "JOIN "+RetSqlName("SC5")+" SC5 "
		cQ += "ON SC5.D_E_L_E_T_ <> '*' "
		cQ += "AND C5_FILIAL = D2_FILIAL "
		cQ += "AND C5_NUM = D2_PEDIDO "
		//cQ += "AND C5_ZTAUINT = 'S' " // somente envia se o pedido jah foi enviado com sucesso
		cQ += "AND C5_ZTIPPED in ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_	=	' ' AND ZJ_TAURA='S' ) " 
		//cQ += "AND C5_ZTAUFLA = '1' "
		cQ += "LEFT JOIN "+RetSqlName("SA4")+" SA4 "
		cQ += "ON SA4.D_E_L_E_T_ <> '*' "
		cQ += "AND A4_FILIAL = '"+xFilial("SA4")+"' "
		cQ += "AND A4_COD = F2_TRANSP "
		cQ += "WHERE "
		//cQ += "SF2.D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
		//cQ += "F2_FILIAL = '"+aNfs[1]+"' "
		//cQ += "AND F2_SERIE = '"+aNfs[3]+"' "
		//cQ += "AND F2_DOC = '"+aNfs[2]+"' "
		//cQ += "AND F2_CLIENTE = '"+aNfs[4]+"' "
		//cQ += "AND F2_LOJA = '"+aNfs[5]+"' "
		cQ += "SF2.R_E_C_N_O_ = "+Alltrim(Str(SF2->(Recno())))+" "
		cQ += "GROUP BY D2_FILIAL,D2_PEDIDO,C5_ZTIPPED,F2_CARGA,F2_DOC,F2_SERIE,F2_EMISSAO,F2_CHVNFE,A4_CGC,F2_VALBRUT,D2_CLIENTE,D2_LOJA,D2_TIPO,C5_EMISSAO "
		cQ += "ORDER BY D2_FILIAL,D2_PEDIDO "
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)
	
		//MemoWrite("MGFTAS03_1.sql",cQ)
		
		tcSetField(cAliasTrb,"F2_EMISSAO","D")
		tcSetField(cAliasTrb,"F2_VALBRUT","N",TamSx3("F2_VALBRUT")[1],TamSx3("F2_VALBRUT")[2])
		tcSetField(cAliasTrb,"C5_EMISSAO","D")
			
		While (cAliasTrb)->(!Eof())
			
			oNfs := Nil
			oNfs := GravarNotaSaida():New()
			oNfs:GravarNfs(cStatus,cAliasTrb)
	
			IF cStatus <> 'C'                              
			   cURLPost := cURLEnv
			   cMonitor := AllTrim(GetMv("MGF_MONT09"))
			Else 
			   cURLPost := cURLCan                     
			   cMonitor := AllTrim(GetMv("MGF_MONT15"))
			EndIF
			
			oWSNfs := MGFINT53():New(cURLPost,oNfs/*oObjToJson*/,SF2->(Recno())/*nKeyRecord*/,/*cTblUpd*/,/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,cMonitor/*cCodtpint*/,cChave/*cChave*/,.F./*lDeserialize*/,.F.,.T.)
			//oWSNfs:SendByHttpPost()
			StaticCall(MGFTAC01,ForcaIsBlind,oWSNfs)
	
			SF2->(RecLock("SF2",.F.))
			If oWSNfs:lOk 
				IF  oWSNfs:nStatus == 1
					SF2->F2_ZTAUFLA := "1" // processado 
					If Empty(SF2->F2_ZTAUINT)
						SF2->F2_ZTAUINT := "S"
					Endif	
					// 06/11/18 - caso seja o envio da inclusao da nota e neste momento a nota estiver deletada, flega para reenviar a nota, para a exclusao ir para o taura
					If cStatus == "N" .and. SF2->(Deleted())
						SF2->F2_ZTAUREE := "S"
						lReenvia := .T.
					Endif
			   	Else
					SF2->F2_ZTAUFLA := "2" // erro
			   	EndIF
			Endif
			SF2->(MsUnLock())  
	
			//MemoWrite("c:\temp\"+FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt",oWSNfs:CDETAILINT)
	
			/*
			cJson := fwJsonSerialize(oNfs,.F.,.T.)
			If isblind()
				conout(cjson)
			Else
				APMsgAlert(cJson)
			Endif	
			MemoWrite("c:\temp\MGFTAS03"+StrTran(Time(),":","")+".txt",cJson)
	
			cPostRet := httpPost(cURLPost,,cJson,nTimeOut,aHeadOut,@cHeadRet)
			If !isblind()
				APMsgalert(cPostRet)
				APMsgalert(cHeadRet)
			Endif	
	
			SF2->(RecLock("SF2",.F.))
			if !Empty(cPostRet)
				// sucesso
				fwJsonDeserialize(cPostRet,@oObjRet)
				If .T. //oObjRet???
					// sucesso
					lRet := .T.	
					SF2->F2_ZTAUFLA := "1" // processado 
					If Empty(SF2->F2_ZTAUINT)
						SF2->F2_ZTAUINT := "S"
					Endif	
				else
					SF2->F2_ZTAUFLA := "2" // erro
				endif
			else
				SF2->F2_ZTAUFLA := "2" // erro
			endif
			SF2->(MsUnLock())
			
			// U_ENVIAMONITOR()
	        */
			(cAliasTrb)->(dbSkip())
		Enddo
	    (cAliasTrb)->(dbCloseArea())
    Endif
Endif 

aEval(aArea,{|x| RestArea(x)})

Return(lRet)


Class GravarNotaSaida

	Data Filial					as String
	Data Pedido					as String
	Data Tipo_Ped				as String
	Data Ordem_Embarque			as String
	Data Num_Nota				as String
	Data Serie_Nota				as String
	Data Data_Nota				as String
	Data Chave_Nfe				as String
	Data Status					as String
	Data Transportadora			as String
	Data Cliente				as String
	Data ClienteLoja			as String	
	Data Valor_Nota				as Float
	Data DataPedido				as String
	Data ApplicationArea		as ApplicationArea	

	Method New()
	Method GravarNfs()

//Return
EndClass


Method New() Class GravarNotaSaida

::ApplicationArea := ApplicationArea():New()

Return


Method GravarNfs(cStatus,cAliasTrb) Class GravarNotaSaida

Local cStringTime := "T00:00:00"
Local cCliente := ""
Local cLoja := ""

If (cAliasTrb)->D2_TIPO $ ("D/B")
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+(cAliasTrb)->D2_CLIENTE+(cAliasTrb)->D2_LOJA))
		If SA2->(FieldPos("A2_ZCODMGF")) > 0 .and. !Empty(SA2->A2_ZCODMGF) // campo que conterah o codigo do fornecedor no sistema da Marfrig. ***verificar o nome que este campo serah criado
			cCliente := SA2->A2_ZCODMGF
		Else
			cCliente := SA2->A2_COD
			cLoja := SA2->A2_LOJA
		Endif
	Endif			
Else
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+(cAliasTrb)->D2_CLIENTE+(cAliasTrb)->D2_LOJA))
		If SA1->(FieldPos("A1_ZCODMGF")) > 0 .and. !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
			cCliente := SA1->A1_ZCODMGF
		Else
			cCliente := SA1->A1_COD
			cLoja := SA1->A1_LOJA
		Endif
	Endif			
Endif	

::Filial := (cAliasTrb)->D2_FILIAL
::Pedido := Alltrim((cAliasTrb)->D2_PEDIDO)
::Tipo_Ped := Alltrim((cAliasTrb)->C5_ZTIPPED)
::Ordem_Embarque := Alltrim((cAliasTrb)->F2_CARGA)
::Num_Nota := Alltrim((cAliasTrb)->F2_DOC)
::Serie_nota := Alltrim((cAliasTrb)->F2_SERIE)
::Data_Nota := Subs(dTos((cAliasTrb)->F2_EMISSAO),1,4)+"-"+Subs(dTos((cAliasTrb)->F2_EMISSAO),5,2)+"-"+Subs(dTos((cAliasTrb)->F2_EMISSAO),7,2)+cStringTime
::Chave_Nfe := Alltrim((cAliasTrb)->F2_CHVNFE)
::Status := cStatus
::Transportadora := Alltrim((cAliasTrb)->A4_CGC)
::Cliente := Alltrim(cCliente)
::ClienteLoja := Alltrim(cLoja)
::Valor_Nota := (cAliasTrb)->F2_VALBRUT
::DataPedido := Subs(dTos((cAliasTrb)->C5_EMISSAO),1,4)+"-"+Subs(dTos((cAliasTrb)->C5_EMISSAO),5,2)+"-"+Subs(dTos((cAliasTrb)->C5_EMISSAO),7,2)+cStringTime

Return()


// funcao de filtragem das Nfs´s que serao enviados ao Taura
// serah chamada por job
User Function TAS03FilNfs()

Local cQ := ""
Local cEmpSav:= cEmpAnt
Local cFilSav := cFilAnt
Local cAliasTrb := GetNextAlias()
Local nCnt := 0
Local lRet := .F.
Local nRet := 0
Local cIDTaura := GetMV("MGF_IDTSNF",.F.,) // 0000000001
/*
Local lUsaColab	:= UsaColaboracao("1") 
Local cIdEnt := ""
Local cModalidade := ""
Local aNotas := {}
Local cAutoriza := ""
Local cCodAutDPEC := ""
Local cCodRetNFE := ""
Local lContinua := .F.
Local aAreaSM0 := SM0->(GetArea())
Local cGrpEmp := FWGrpCompany() // pegar o grupo neste momento, pois a tabela SM0 jah estah posicionada e a funcao FWGrpCompany() usa o SM0 para obter o grupo de empresas
*/

Private lReenvia := .F.

/*
F2_ZTAUFLA, flags:
1=enviado com sucesso
2=enviado e rejeitado - Erro
*/

If Empty(cIDTaura)
	ConOut("Não encontrado parâmetro 'MGF_IDTSNF'.")
	Return()
Endif

cIDTaura := Soma1(cIDTaura)
PutMV("MGF_IDTSNF",cIDtaura)	

// flega todos as notas selecionadas como "em processamento", para que outro job nao pegue a mesma nota para processar
/*
cQ := "UPDATE "
cQ += RetSqlName("SF2")+" "
cQ += "SET F2_ZTAUID = '"+cIDTaura+"' "
//cQ += "WHERE D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
//cQ += "AND F2_FILIAL = '"+aParam[2]+"' "
cQ += "WHERE (F2_ZTAUFLA = ' ' "
cQ += "OR F2_ZTAUREE = 'S' "
cQ += "OR F2_ZTAUFLA = '2') "
//cQ += "AND F2_CHVNFE <> ' ' "
//cQ += "AND F2_FILIAL = '010008' AND F2_DOC =  '000000007' "
cQ += "AND F2_ZTAUSEM <> 'S' "
// nao enviar registros deletados, que nao tenham sido integrados
//cQ += "AND NOT (D_E_L_E_T_ = '*' "
//cQ += "AND F2_ZTAUINT = ' ') "
//cQ += "AND F2_DAUTNFE <> ' ' "
*/

cQ := "UPDATE "
cQ += RetSqlName("SF2")+" "
cQ += "SET F2_ZTAUID = '"+cIDTaura+"' "
cQ += "WHERE F2_FILIAL || F2_SERIE || F2_DOC || F2_CLIENTE || F2_LOJA || F2_EMISSAO IN "
cQ += "( "
cQ += "(SELECT F2_FILIAL || F2_SERIE || F2_DOC || F2_CLIENTE || F2_LOJA || F2_EMISSAO " 
cQ += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZJ")+" SZJ "
//cQ += "WHERE D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
cQ += "WHERE (F2_ZTAUFLA = ' ' "
cQ += "OR F2_ZTAUREE = 'S' "
cQ += "OR F2_ZTAUFLA = '2') "
cQ += "AND F2_ZTAUSEM <> 'S' "
//cQ += "ON SD2.D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
cQ += "AND D2_FILIAL = F2_FILIAL "
cQ += "AND D2_SERIE = F2_SERIE "
cQ += "AND D2_DOC = F2_DOC "
cQ += "AND D2_CLIENTE = F2_CLIENTE "
cQ += "AND D2_LOJA = F2_LOJA "
cQ += "AND D2_EMISSAO = F2_EMISSAO "
cQ += "AND SC5.D_E_L_E_T_ <> '*' "
cQ += "AND C5_FILIAL = D2_FILIAL "
cQ += "AND C5_NUM = D2_PEDIDO "
cQ += "AND C5_ZTIPPED = ZJ_COD "
cQ += "AND SZJ.D_E_L_E_T_ <> '*' "
cQ += "AND ZJ_FILIAL = '"+xFilial("SZJ")+"' "
cQ += "AND ZJ_TAURA = 'S' "
//cQ += "AND F2_CHVNFE <> ' ' " // validado porteriormente
//cQ += "AND F2_FIMP = 'S' " // validado porteriormente
//cQ += "AND C5_ZTAUINT = 'S' " // somente envia se o pedido jah foi enviado com sucesso )
cQ += "AND F2_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS031",,999))+"') "
cQ += "UNION " // forcar envio de notas deletadas que por algum motivo nao estao sendo enviadas // 12/11/18
cQ += "(SELECT F2_FILIAL || F2_SERIE || F2_DOC || F2_CLIENTE || F2_LOJA || F2_EMISSAO " 
cQ += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZJ")+" SZJ "
cQ += "WHERE SF2.D_E_L_E_T_ = '*' " // OBS: processa soh notas deletadas
cQ += "AND SD2.D_E_L_E_T_ = '*' " // OBS: processa soh notas deletadas
cQ += "AND D2_FILIAL = F2_FILIAL "
cQ += "AND D2_SERIE = F2_SERIE "
cQ += "AND D2_DOC = F2_DOC "
cQ += "AND D2_CLIENTE = F2_CLIENTE "
cQ += "AND D2_LOJA = F2_LOJA "
cQ += "AND D2_EMISSAO = F2_EMISSAO "
cQ += "AND SC5.D_E_L_E_T_ <> '*' "
cQ += "AND C5_FILIAL = D2_FILIAL "
cQ += "AND C5_NUM = D2_PEDIDO "
cQ += "AND C5_ZTIPPED = ZJ_COD "
cQ += "AND SZJ.D_E_L_E_T_ <> '*' "
cQ += "AND ZJ_FILIAL = '"+xFilial("SZJ")+"' "
cQ += "AND ZJ_TAURA = 'S' "
//cQ += "AND C5_ZTAUINT = 'S' " // somente envia se o pedido jah foi enviado com sucesso )
cQ += "AND F2_EMISSAO >= '"+dTos(dDataBase-GetMv("MGF_TAS032",,3))+"' "
cQ += "AND NOT EXISTS "
cQ += "(SELECT 1 "
cQ += "FROM "+RetSqlName("SZ1")+" SZ1 "
cQ += "WHERE SZ1.D_E_L_E_T_ <> '*' "
cQ += "AND Z1_TPINTEG = '015' " // envio de notas deletadas
cQ += "AND F2_FILIAL = Z1_FILIAL "
cQ += "AND Z1_STATUS = '1' " // sucesso no envio
cQ += "AND TRIM(F2_DOC || F2_SERIE) = TRIM(Z1_DOCORI))) "
cQ += ") "

nRet := tcSqlExec(cQ)
If nRet == 0
Else
	ConOut("Problemas na gravação do semáforo da nota de saída, para envio ao Taura.")
	Return()	
EndIf

cQ := "SELECT SF2.R_E_C_N_O_ SF2_RECNO,F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_ZTAUFLA,F2_ZTAUINT,SF2.D_E_L_E_T_ DELET,F2_EMISSAO "
cQ += "FROM "+RetSqlName("SF2")+" SF2 "
cQ += "WHERE "
//cQ += "SF2.D_E_L_E_T_ <> '*' " // OBS: processa notas deletadas
cQ += "F2_ZTAUID = '"+cIDTaura+"' "
cQ += "ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,F2_CLIENTE,F2_LOJA,SF2.D_E_L_E_T_ "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

//MemoWrite("MGFTAS03.sql",cQ)

While (cAliasTrb)->(!Eof())
	lReenvia := .F.

	cEmpAnt := Subs((cAliasTrb)->F2_FILIAL,1,2)
	cFilAnt := Subs((cAliasTrb)->F2_FILIAL,1,6)
	/*
	If Empty((cAliasTrb)->DELET)
		SM0->(dbSetOrder(1)) // posicionar SM0, pois a funcao RetIdEnti le o SM0
		If SM0->(dbSeek(cGrpEmp+cFilAnt))
			If CTIsReady(,,,lUsaColab)
				cIdEnt := RetIdEnti(lUsaColab) //StaticCall(SPEDNFE,GetIdEnt,lUsaColab)                      
		
			    lContinua := .F.
			    aNotas := {}
			    aadd(aNotas,{})
				aadd(Atail(aNotas),.F.)
				aadd(Atail(aNotas),"S")
				aadd(Atail(aNotas),sTod((cAliasTrb)->F2_EMISSAO))
				aadd(Atail(aNotas),(cAliasTrb)->F2_SERIE)
				aadd(Atail(aNotas),(cAliasTrb)->F2_DOC)
				aadd(Atail(aNotas),(cAliasTrb)->F2_CLIENTE)
				aadd(Atail(aNotas),(cAliasTrb)->F2_LOJA)
							
			    aXml := StaticCall(DANFEII,GetXML,cIdEnt,aNotas,@cModalidade)
			
				If !Empty(aXML[1][2])
					If !Empty(aXml[1])
						cAutoriza   := aXML[1][1]
						cCodAutDPEC := aXML[1][5]
						cCodRetNFE	:= aXML[1][9]
						//cCodRetSF3	:= iif ( Empty (cCodAutDPEC),cCodRetNFE,cCodAutDPEC )
						//cMsgSF3		:= iif ( aXML[1][10]<> Nil ,aXML[1][10],"")
					Else
						cAutoriza   := ""
						cCodAutDPEC := ""
						cCodRetNFE	:= ""
						//cCodRetSF3		:= ""
						//cMsgSF3		:= ""
					EndIf
					IF EMPTY(cCodRetNFE)
						APMSGALERT("EMPTY cCodRetNFE")
					ENDIF	
					If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[1][8]) $ "2,5,7") .And. !cCodRetNFE $ RetCodDene()
						lContinua := .T.
					Endif
				Endif
			Endif
		Endif
		SM0->(RestArea(aAreaSM0))
	Else // para notas deletadas, sempre envia a nota para o taura
		lContinua := .T.
	Endif		
		
	If !lContinua
		(cAliasTrb)->(dbSkip())		
		Loop
	Endif	
	*/
	Begin Transaction
	 
	//SF2->(dbGoto((cAliasTrb)->SF2_RECNO))
	//If SF2->(Recno()) == (cAliasTrb)->SF2_RECNO
	//	SF2->(RecLock("SF2",.F.))
	//	SF2->F2_ZTAUSEM := "S"
	//	SF2->(MsUnLock())
	//Endif	
	lRet := U_TAS03EnvNfs({{(cAliasTrb)->F2_FILIAL,(cAliasTrb)->F2_DOC,(cAliasTrb)->F2_SERIE,(cAliasTrb)->F2_CLIENTE,(cAliasTrb)->F2_LOJA},IIf((cAliasTrb)->DELET=="*","C","N"),(cAliasTrb)->SF2_RECNO})
	SF2->(dbGoto((cAliasTrb)->SF2_RECNO))
	If SF2->(Recno()) == (cAliasTrb)->SF2_RECNO
		SF2->(RecLock("SF2",.F.))
		//SF2->F2_ZTAUSEM := ""
		If SF2->F2_ZTAUFLA == "1" .and. !lReenvia // soh tira flag de reenvio se o envio foi com sucesso
			SF2->F2_ZTAUREE := ""
		Endif	
		SF2->(MsUnLock())
	Endif	
	
	End Transaction

	(cAliasTrb)->(dbSkip())
Enddo

(cAliasTrb)->(dbCloseArea())	

cEmpAnt := cEmpSav
cFilAnt := cFilSav

Return()


// rotina chamada pelo ponto de entrada M460FIM
User Function TAS03M460FIM()

Local lTauEnvia := GetMv("MGF_TAUNFS",,.F.)
Local lTauJob := GetMv("MGF_TAUJNS",,.F.)

If lTauEnvia .and. !Empty(SF2->F2_CHVNFE)
	U_TauraEnvia(lTauJob,"xTAS03EnvNfs",{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"N",SF2->(Recno())},.F.)
Endif	

Return()


// rotina chamada pelo ponto de entrada SF2520E
User Function TAS03SF2520E()

Local lTauEnvia := .T. // tem que ser sempre on-line a exclusao
Local lTauJob := .F. // exclusao nao pode ser por job

If (!Empty(SF2->F2_CHVNFE) .and. SF2->F2_ZTAUFLA $ "1/2" .and. SF2->F2_ZTAUINT == "S") .or. (Empty(SF2->F2_CHVNFE) .and. Empty(SF2->F2_ZTAUINT)) // notas com chave, somente as jah enviadas ou notas sem chave, somente as nao enviadas
	/* 06/11/18 - modo sincrono de envio desabilitado, pois estava tendo problema da exclusao da nota ser feita antes do envio da inclusao e a exclusao nao ia nunca ao taura
	If lTauEnvia
		// no caso de envio de exclusao, limpa o campo de flag antes, pois se houver algum problema no envio da exclusao ( que eh on-line via ponto de entrada ),
		// o campo fica em branco e o registro entra na fila para ser enviado por job
		SF2->(RecLock("SF2",.F.))
		SF2->F2_ZTAUFLA := ""
		SF2->(MsUnLock())  
	
		U_TauraEnvia(lTauJob,"xTAS03EnvNfs",{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"C",SF2->(Recno())},.F.)
	Endif	
	*/
	// 06/11/18 - modo assincrino, apenas poe o registro na fila, no retorno da inclusao tb tem um tratamento para enviar a exclusao, caso a nota ainda nao tenha sido enviada ao taura no 
	// momento da exclusao da nota
	SF2->(RecLock("SF2",.F.))
	SF2->F2_ZTAUREE := "S"
	SF2->(MsUnLock())		
Endif

Return()


// rotina complementar a rotina TAS03EnvNfs
// inicia ou nao empresa para enviar dados para o Taura
User Function xTAS03EnvNfs(aParam,lJob,cEmp,cFil)

Local nVezes := 100
Local nCnt := 0
Local lRet := .F.
Local aParam := IIf(Type("ParamIxb")=="U",aParam,ParamIxb)
Local lStart := .F.

Default lJob := .F.

If lJob
	RpcSetType(3)
	lStart := RpcSetEnv(cEmp,cFil,,,"FAT",,/*{"SF2"}*/,,,.T.)
	If !lStart
		Return(lRet) 
	Else // posiciona nota
		//SF2->(dbSetOrder(1))
		//SF2->(dbSeek(xFilial("SF2")+aParam[1]+aParam[2]+aParam[3]+aParam[4]+aParam[5]))
		SF2->(dbGoto(aParam[7]))
		If SF2->(Recno()) != aParam[7] 
			Return(lRet)
		Endif
	Endif
Endif
			
For nCnt:=1 To nVezes
	If !Empty(SF2->F2_ZTAUSEM)
		Loop
	Else
		Exit	
	Endif
Next

If Empty(SF2->F2_ZTAUSEM)

	Begin Transaction
	
	//SF2->(RecLock("SF2",.F.))
	//SF2->F2_ZTAUSEM := "S" // em processamento
	//SF2->(MsUnLock())
	lRet := U_TAS03EnvNfs({{aParam[1],aParam[2],aParam[3],aParam[4],aParam[5]},aParam[6],aParam[7]})
	//SF2->(RecLock("SF2",.F.))
	//SF2->F2_ZTAUSEM := ""
	//SF2->(MsUnLock())
	
	End Transaction
	
Else
	If SF2->(FieldPos("F2_ZTAUREE")) > 0
		SF2->(RecLock("SF2",.F.))
		SF2->F2_ZTAUREE := "S"
		SF2->(MsUnLock())		
	Endif	
Endif	

If lJob
	RpcClearEnv()
Endif
	
Return(lRet)   