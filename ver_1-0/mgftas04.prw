#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

#define CRLF chr(13) + chr(10)

Static _aErr

/*
=====================================================================================
Programa............: MGFTAS04
Autor...............: Mauricio Gresele
Data................: 22/11/2016 
Descricao / Objetivo: Integração Protheus-Taura, para recebimento do Trecho de Itinerário
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
WSSTRUCT TRECHOITINERARIO
	WSDATA Filial			as String
	WSDATA Emissor			as String
	WSDATA Serie_Nota		as String
	WSDATA Num_Nota			as String
	WSDATA Transportador	as String 
	WSDATA Cid_Destino		as String 
ENDWSSTRUCT

WSSTRUCT WSTAS04RETORNO
	WSDATA Status			as String
	WSDATA Msg				as String
ENDWSSTRUCT

WSSERVICE MGFTAS04 DESCRIPTION "Inclusão do Trecho de Itinerário" NameSpace "http://www.totvs.com.br/MGFTAS04"
	WSDATA Dados			as TRECHOITINERARIO
	WSDATA Retorno			as WSTAS04RETORNO

	WSMETHOD IncluiTrechoItinerario DESCRIPTION "Inclusão do Trecho de Itinerário"	
ENDWSSERVICE

WSMETHOD IncluiTrechoItinerario WSRECEIVE Dados WSSEND Retorno WSSERVICE MGFTAS04

//Local aArea := {SM0->(GetArea()),GetArea()}
Local aRet := {}
Local cEmpSav := ""
Local cFilSav := ""
Local lContinua := .T.
Local aRetEmpFil := {}

Local bError := ErrorBlock( { |oError| MyError( oError ) } )

//RpcClearEnv()
//RpcSetType(3)
	
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" // TABLES

cEmpSav := cEmpAnt
cFilSav := cFilAnt

//::Retorno := WSClassNew("WSTAS04RETORNO")

// valida todos os campos obrigatorios
If lContinua
	aRet := VldObrCampos(Dados)
	If Len(aRet) > 0
		If !aRet[1]
			//::Retorno:Status := IIf(aRet[1],"1","2")
			//::Retorno:Msg := aRet[2]
			aRet[1] := IIf(aRet[1],"1","2")
			lContinua := .F.
		Endif	
	Endif	
Endif	

// valida empresa e filial
If lContinua
	//cEmpAnt := Subs(Dados:Filial,1,2) *** VOLTAR DEPOIS
	//cFilAnt := Subs(Dados:Filial,3) *** VOLTAR DEPOIS
	cEmpAnt := Subs(Dados:Filial,1,2)
	cFilAnt := Subs(Dados:Filial,1,6)
	
	aRetEmpFil := U_WSEmpFil(cEmpAnt,cFilAnt)
	lContinua := aRetEmpFil[1]
	If !lContinua
		aRet := {}
		aAdd(aRet,"2")
	   	aAdd(aRet,aRetEmpFil[2][2])
	Endif
Endif
	
/*
// valida empresa e filial
If lContinua
	If Select("SM0") > 0
		SM0->(dbSetOrder(1))
		If SM0->(!dbSeek(cEmpAnt+cFilAnt))
			::Retorno:Status := "2"
			::Retorno:Msg := "Empresa/Filial não encontrada, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota
			
			Return(.T.)
		Endif	
	Endif
Endif
*/
	
If lContinua		

	BEGIN SEQUENCE
	
	aRet := WSTAS04Mnt(Dados)
	If Len(aRet) > 0
		//::Retorno:Status := IIf(aRet[1],"1","2")
		//::Retorno:Msg := aRet[2]
		aRet[1] := IIf(aRet[1],"1","2")
	Endif	
	
	RECOVER
		
		Conout('Problema Ocorreu as Horas: ' + TIME() )
	
	END SEQUENCE		

	ErrorBlock( bError )
	
Endif	

If ValType(_aErr) == 'A'
	aRet := _aErr
EndIf

// retorno
::Retorno := WSClassNew("WSTAS04RETORNO")
If Len(aRet) > 0
	::Retorno:Status := aRet[1]
	::Retorno:Msg := aRet[2]
Else
	::Retorno:Status := "2"
	::Retorno:Msg := "Erro"
Endif	

//aEval(aArea,{|x| RestArea(x)})

cEmpAnt := cEmpSav
cFilAnt := cFilSav

//RESET ENVIRONMENT	

Return(.T.)


// rotina de execucao dos eventos de manutencao do trecho do itinerario
Static Function WSTAS04Mnt(Dados)

Local aRet := {}

aRet := WSTAS04Inc(Dados)

Return(aRet)


// rotina de inclusao do trecho de itinerario
Static Function WSTAS04Inc(Dados) 

Local lContinua := .T.
Local aRet := {}
Local cMens := ""

// valida campos enviados
aRet := VldCampos(Dados)
lContinua := aRet[1]
If lContinua

	Begin Transaction 
		
	aRet := IncTrecho(Dados)
	lContinua := aRet[1]
	If !lContinua
		DisarmTransaction()
	Endif			
			
	End Transaction

	MsUnLockAll()
Endif			
	
If Len(aRet) == 0
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)
	Conout(cMens)
Endif	

Return(aRet)


// processo inclusao do trecho de itinerario
Static Function IncTrecho(Dados)

Local aRet := {}
Local aGWU := {}
Local cCidade := ""

aGWU := BuscaSeq(Dados)

GWU->(RecLock("GWU",.T.))
GWU->GWU_FILIAL := xFilial("GWU")
GWU->GWU_CDTPDC := "NFS"
GWU->GWU_EMISDC := Dados:Emissor
GWU->GWU_SEQ := aGWU[1]
GWU->GWU_SERDC := Dados:Serie_Nota
GWU->GWU_NRDC := Dados:Num_Nota
GWU->GWU_CDTRP := Dados:Transportador
GWU->GWU_NRCIDD := Subs(Dados:Cid_Destino,3,7)
GWU->GWU_PAGAR := "1"
GWU->GWU_SDOC := Dados:Serie_Nota
GWU->(MsUnLock())

// verifica se existe trecho anterior, se existir, altera a cidade de destino do trecho anterior, para a cidade da transportadora do novo trecho
If aGWU[2] > 0

	GU3->(dbSetOrder(1))
	If GU3->(dbSeek(xFilial("GU3")+Padr(Dados:Transportador,TamSX3("GU3_CDEMIT")[1])))
		While GU3->(!Eof()) .and. xFilial("GU3")+Padr(Dados:Transportador,TamSX3("GU3_CDEMIT")[1]) == GU3->GU3_FILIAL+GU3->GU3_CDEMIT
			If (GU3->GU3_TRANSP == "1".or. GU3->GU3_AUTON == "1") .and. GU3->GU3_SIT == "1"
				cCidade := GU3->GU3_NRCID
				Exit
			Endif	
			GU3->(dbSkip())
		Enddo		
	Endif
	If !Empty(cCidade)
		GWU->(dbGoto(aGWU[2]))
		If GWU->(Recno()) == aGWU[2]
			GWU->(RecLock("GWU",.F.))
			GWU->GWU_NRCIDD := cCidade
			GWU->(MsUnLock())
		Endif
	Endif
Endif			
							
aAdd(aRet,.T.)
aAdd(aRet,"Trecho de Itinerário incluído com sucesso, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota)
 
Return(aRet)  


// rotina de busca da proxima sequencia do techo de itinerario
Static Function BuscaSeq(Dados)

Local aArea := {GetArea()}
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local aRet := {}

cQ := "SELECT GWU_SEQ,R_E_C_N_O_ GWU_RECNO "
cQ += "FROM "+RetSqlName("GWU")+" GWU "
cQ += "WHERE "
cQ += "GWU.D_E_L_E_T_ <> '*' "
cQ += "AND R_E_C_N_O_ = "
cQ += "		( "
cQ += "		SELECT R_E_C_N_O_ "
cQ += "		FROM "+RetSqlName("GWU")+" GWU1 "
cQ += "		WHERE "
cQ += "		GWU1.D_E_L_E_T_ <> '*' "
cQ += "		AND GWU1.GWU_FILIAL = '"+Dados:Filial+"' "
cQ += "		AND GWU1.GWU_CDTPDC = 'NFS' "
cQ += "		AND GWU1.GWU_EMISDC = '"+Dados:Emissor+"' "
cQ += "		AND GWU1.GWU_SERDC = '"+Dados:Serie_Nota+"' "
cQ += "		AND GWU1.GWU_NRDC = '"+Dados:Num_Nota+"' "
cQ += "		AND GWU1.GWU_SEQ = "
cQ += "			( "
cQ += "			SELECT MAX(GWU_SEQ) GWU_SEQ "
cQ += "			FROM "+RetSqlName("GWU")+" GWU2 "
cQ += "			WHERE "
cQ += "			GWU2.D_E_L_E_T_ <> '*' "
cQ += "			AND GWU2.GWU_FILIAL = '"+Dados:Filial+"' "
cQ += "			AND GWU2.GWU_CDTPDC = 'NFS' "
cQ += "			AND GWU2.GWU_EMISDC = '"+Dados:Emissor+"' "
cQ += "			AND GWU2.GWU_SERDC = '"+Dados:Serie_Nota+"' "
cQ += "			AND GWU2.GWU_NRDC = '"+Dados:Num_Nota+"' "
cQ += "			) "
cQ += "		) "

cQ := ChangeQuery(cQ)
//MemoWrite("mgftas04.sql",cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	aAdd(aRet,(cAliasTrb)->GWU_SEQ)
	aAdd(aRet,(cAliasTrb)->GWU_RECNO)
Endif

(cAliasTrb)->(dbCloseArea()) 

If Len(aRet) > 0
	aRet[1] := Soma1(aRet[1])
Else
	aAdd(aRet,StrZero(1,TamSX3("GWU_SEQ")[1]))
	aAdd(aRet,0)	
Endif

aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// valida os campos obrigatorios
Static Function VldObrCampos(Dados)

Local nCnt := 0
Local bBlock := {|x| Empty(x)}
Local aRet := {}
Local lContinua := .T.
Local cCampo := ""
Local cMens := ""
Local aDados := {}

If lContinua
	If Eval(bBlock,Dados:Filial)
		lContinua := .F.
		cCampo := "Filial"
	Endif
Endif	

If lContinua
	If Eval(bBlock,Dados:Emissor)
		lContinua := .F.
		cCampo := "Emissor"
	Endif
Endif	

If lContinua
	If Eval(bBlock,Dados:Serie_Nota)
		lContinua := .F.
		cCampo := "Serie_Nota"
	Endif
Endif	
	
If lContinua
	If Eval(bBlock,Dados:Num_Nota)
		lContinua := .F.
		cCampo := "Num_Nota"
	Endif
Endif	
	
If lContinua
	If Eval(bBlock,Dados:Transportador)
		lContinua := .F.
		cCampo := "Transportador"
	Endif
Endif	

If lContinua
	If Eval(bBlock,Dados:Cid_Destino)
		lContinua := .F.
		cCampo := "Cid_Destino"
	Endif	
Endif		
	
If !lContinua
	cMens := "Campo obrigatório não enviado, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota+", Campo: "+cCampo
Endif	

aRet := {}
aAdd(aRet,lContinua)
aAdd(aRet,cMens)

Return(aRet)				


// valida conteudo dos campos
Static Function VldCampos(Dados)

Local aRet := {}
Local lContinua := .T.
Local cMens := ""
Local lAchouTransp := .F.

GU3->(dbSetOrder(1))
SF2->(dbSetOrder(1))
GU7->(dbSetOrder(1))

If lContinua
	If !Empty(Dados:Emissor) .and. GU3->(!dbSeek(xFilial("GU3")+Padr(Dados:Emissor,TamSX3("GU3_CDEMIT")[1])))
		lContinua := .F.
		cMens := "Emissor não cadastrado, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota+", Emissor: "+Dados:Emissor
	Endif	
Endif
	
If lContinua
	If !Empty(Dados:Serie_Nota) .and. !Empty(Dados:Num_Nota) .and. SF2->(!dbSeek(xFilial("SF2")+Padr(Dados:Num_Nota,TamSX3("F2_DOC")[1])+Padr(Dados:Serie_Nota,TamSX3("F2_SERIE")[1])))
		lContinua := .F.
		cMens := "Nota de saída não cadastrada, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota
	Endif
Endif	
		
If lContinua
	If !Empty(Dados:Transportador) .and. GU3->(dbSeek(xFilial("GU3")+Padr(Dados:Transportador,TamSX3("GU3_CDEMIT")[1])))
		While GU3->(!Eof()) .and. xFilial("GU3")+Padr(Dados:Transportador,TamSX3("GU3_CDEMIT")[1]) == GU3->GU3_FILIAL+GU3->GU3_CDEMIT
			If (GU3->GU3_TRANSP == "1".or. GU3->GU3_AUTON == "1") .and. GU3->GU3_SIT == "1"
				lAchouTransp := .T.
				Exit
			Endif
			GU3->(dbSkip())
		Enddo		
	Endif
	If !lAchouTransp
		lContinua := .F.
		cMens := "Transportador não cadastrado, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota+", Transportador: "+Dados:Transportador
	Endif	
Endif	

If lContinua
	If !Empty(Dados:Cid_Destino) .and. GU7->(dbSeek(xFilial("GU7")+Padr(Subs(Dados:Cid_Destino,3,7),TamSX3("GU7_NRCID")[1]))) .and. GU7->GU7_SIT == "1"
		// validou ok
	Else
		lContinua := .F.
		cMens := "Cidade Destino não cadastrada, Filial: "+Dados:Filial+", Série: "+Dados:Serie_Nota+", Nota: "+Dados:Num_Nota+", Cidade: "+Dados:Cid_Destino
	Endif
Endif	

aAdd(aRet,lContinua)
aAdd(aRet,cMens)

Return(aRet)


Static Function MyError(oError)

Local nQtd := MLCount(oError:ERRORSTACK)
Local ni
Local cEr := ''
	
nQtd := IIF(nQtd > 4,4,nQtd) //Retorna as 4 linhas 
	
For ni:=1 to nQTd
	cEr += MemoLine(oError:ERRORSTACK,,ni)
Next ni
	
Conout( oError:Description + " - Deu Erro" )
_aErr := {'2',cEr}
BREAK

Return(.T.)



// Valida a existencia da Empresa e Filial 
User Function WSEmpFil(cEmp,cFil)

Local cEnvSrv := GetEnvServer()
Local cLocalFiles := Upper(GetPvProfString(cEnvSrv,"LocalFiles","ADS",GetADV97()))
Local cDir := Upper(GetPvProfString(cEnvSrv,"StartPath","",GetADV97())) //GetSrvProfString("StartPath","")
Local lRet := .F.
Local aErro := {"",""}
Local lFecha := .F.
Local aAreaSM0

Default cEmp := "99"
Default cFil := ""

If Select("SM0") == 0	
	OpenSm0(cEmp,.T.)
	If Select("SM0") > 0
		lRet := .T.
	Else
		aErro := {"Erro na abertura de tabelas","Erro na abertura da tabela SM0"}			
	Endif
	lFecha := .T.
Else
	aAreaSM0 := SM0->(GetArea())
	lRet := .T.	
Endif
SM0->(dbSetOrder(1))
If lRet .and. SM0->(!dbSeek(cEmp+Padr(cFil,12)))
	lRet := .F.
	aErro := {"Erro de Parametros","Empresa ou Filial não encontrada"}
Endif	 	

If lFecha
	SM0->(dbCloseArea())
Endif	

If aAreaSM0 != Nil
	SM0->(RestArea(aAreaSM0))
Endif
	
Return({lRet,aErro})