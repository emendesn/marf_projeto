#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa.:              MGFTAP11
Autor....:              Atilio Amarilla
Data.....:              24/11/2016
Descricao / Objetivo:   Integracao PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Integracao Quantidades do Armazem Produtivo (02)
						Envia ao Taura os produtos transferidos ao Armazem Produtivo
						16/02/2017 - Considera diversos armaz�ns
=====================================================================================
*/

User Function MGFTAP11()
	
	Local cArmPrd, cUpd, cQry, __cNewArea, cTimeIni
	Local cFaile		:= GetSrvProfString("Startpath","")+"MGFTAP11.TXT"
	Local dDatIni
	
	If IsInCallStack("U_MA261D3") .Or. IsInCallStack("U_MA260D3")
		cArmPrd	:= GetMv("MGF_TAP11A",,"02/04/06/")
		If  SD3->D3_TM == "499" .And. SD3->D3_LOCAL $ cArmPrd .And. GetMv("MGF_TAP11E",,.T.) // Desabilitar chamada via PE MA260SD3 e MA261SD3
			MGFTAP1101()
		EndIf
	Else
		/*
		����������������������������������������������������������������������������������������������������������Ŀ
		� Controle de semaforo - Nao permitir execucao de mais de uma inst�ncia:                                   |
		������������������������������������������������������������������������������������������������������������
		*/
		nHdFaile := fCreate( cFaile )
		
		If nHdFaile == -1
			ConOut("## MGFTAP11 Ativo [MGFTAP11.TXT] Kill... ##")
			Return
		EndIf
		
		/*
		����������������������������������������������������������������������������������������������������������Ŀ
		� Preparacao do Ambiente.                                                                                  |
		������������������������������������������������������������������������������������������������������������
		*/
		//RpcSetType(3) 		// Seta job para nao consumir licen�as
		
		//RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )//, aTables )

		If Select("SX3")==0

			lSetEnv	:= .T.
	
			RpcSetEnv( "01" , "010001" , Nil, Nil, "EST" ) //, Nil , aTables )

		Else

			lSetEnv	:= .F.

		EndIf
		
		
		dbSelectArea("SD3")
		
		cArmPrd	:= GetMv("MGF_TAP11A",,"02/04/06/")
		dDatIni	:= GetMv("MGF_TAP11F",,STOD("20170614")) 	 // Data Inicio - Referencia para Averba��o RCTRC
		__cNewArea := GetNextAlias()
		/*
		����������������������������������������������������������������������������������������������������������Ŀ
		� Update D3_ZTAPINT = 'P'. Marcar registros a processar													   |
		������������������������������������������������������������������������������������������������������������
		*/
		cUpd := "UPDATE "+RetSqlName("SD3")+" "+CRLF
		cUpd += "SET D3_ZTAPINT = 'P' "+CRLF
		cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cUpd += "	AND D3_ZTAPINT = ' ' "+CRLF
		cUpd += "	AND D3_EMISSAO >= '"+DTOS(dDatIni)+"' "+CRLF
		cUpd += "	AND D3_TM = '499' "+CRLF
		cUpd += "	AND D3_CF = 'DE4' "+CRLF
		If "ORACLE" $ TcGetDB()
			cUpd += "	AND INSTR('"+cArmPrd+"',D3_LOCAL) > 0 "+CRLF
		Else
			cUpd += "	AND CHARINDEX(D3_LOCAL,'"+cArmPrd+"') > 0 "+CRLF
		EndIf
		
		//MemoWrit( "UPD-MGFTAP11-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , cUpd )
		/*
		If TcSqlExec( cUpd ) == 0
			If "ORACLE" $ TcGetDB()
				TcSqlExec( "COMMIT" )
			EndIf
		EndIf
		*/
		
		cQry := "SELECT SD3.R_E_C_N_O_ D3_RECNO "+CRLF
		cQry += "FROM "+RetSqlName("SD3")+" SD3 "+CRLF
		cQry += "WHERE D_E_L_E_T_ = ' ' "+CRLF
		cQry += "	AND D3_ZTAPINT = 'P' "+CRLF // IN (' ','P') "+CRLF
		cQry += "	AND D3_EMISSAO >= '"+DTOS(dDatIni)+"' "+CRLF
		cQry += "	AND D3_TM = '499' "+CRLF
		cQry += "	AND D3_CF = 'DE4' "+CRLF
		If "ORACLE" $ TcGetDB()
			cQry += "	AND INSTR('"+cArmPrd+"',D3_LOCAL) > 0 "+CRLF
		Else
			cQry += "	AND CHARINDEX(D3_LOCAL,'"+cArmPrd+"') > 0 "+CRLF
		EndIf
		cQry += "ORDER BY 1 "
		
		//MemoWrit( "SELE-MGFTAP11-1-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , cQry )
		
		nRegPrc	:= U_zMontaView( cQry, __cNewArea )
		
		//ConOut( nRegPrc )
		
		If nRegPrc > 0
			While !( __cNewArea )->( eof() )
				SD3->( dbGoTo( ( __cNewArea )->D3_RECNO ) )
				
				cTimeIni	:= Time()
				
				MGFTAP1101()
				
				//Conout("## MGFTAP11 D3_NUMSEQ: "+SD3->D3_NUMSEQ+" - TOTAL: " + ElapTime(cTimeIni,Time())+" ##")
				( __cNewArea )->( dbSkip() )
			EndDo
		EndIf
		
		dbSelectArea( __cNewArea )
		dbCloseArea()
		
		Fclose( nHdFaile )
		/*
		����������������������������������������������������������������������������������������������������������Ŀ
		� Finalizacao do Ambiente.                                                                                 |
		������������������������������������������������������������������������������������������������������������
		*/
		If .F. // lSetEnv
			RpcClearEnv()
		EndIf
		
	EndIf
	
Return

//-------------------------------------------------------------------
//-------------------------------------------------------------------
Static Function MGFTAP1101()
	
	Local cJson			:= ""
	Local cURLPost		:= GetMv("MGF_TAP11B",,"http://spdwvtds002/wsintegracaoShape/api/v0/RequisicaoEstoque")
	Local cCodInt		:= GetMv("MGF_TAP11C",,"001")
	Local cTipInt		:= GetMv("MGF_TAP11D",,"001")
	local oWSTrabsfer	:= nil
	
	Private oTransfer		:= nil
	
	oTransfer := nil
	oTransfer := Transfer():new()
	
	oTransfer:SetTransfer()
	
	cJson := fwJsonSerialize(oTransfer, .F., .T.)
	//ConOut(cJson)
	//MakeDir("\JSON\")
	//memoWrite("\JSON\RequisicaoEstoque-"+DTOS(Date())+StrTran(Time(),":")+".json", cJson)
	
	oWSTransfer := nil
	oWSTransfer := MGFINT23():new(cURLPost, oTransfer /*oObjToJson*/, SD3->( Recno() ) /*nKeyRecord*/, "SD3" /*cTblUpd*/, "D3_ZTAPINT" /*cFieldUpd*/, cCodInt /*cCodint*/, cTipInt /*cCodtpint*/, SD3->D3_NUMSEQ /*cChave*/)
	oWSTransfer:SendByHttpPost()
	
Return

/*
Classe de Transferencia (Movimenta��es)
*/
Class Transfer
	Data ApplicationArea	as ApplicationArea
	
	Data FILIAL				as String
	Data PRODUTO			as Integer
	Data QUANTIDADE			as Float
	Data UNIDADEMEDIDA		as String
	Data DATAVALIDADE		as String
	Data LOTECTL			as String
	Data LOCALARMAZENAGEM	as String
	
	
	Method New()
	Method SetTransfer()
return

/*
Construtor
*/
method New() class Transfer
	Self:ApplicationArea	:= ApplicationArea():new()
return

/*
Carrega o objeto
*/
Method SetTransfer() Class Transfer
	
	Self:FILIAL				:= SD3->D3_FILIAL
	Self:PRODUTO			:= SD3->D3_COD
	Self:QUANTIDADE			:= SD3->D3_QUANT
	Self:UNIDADEMEDIDA		:= SD3->D3_UM
	Self:DATAVALIDADE		:= Trans( IIF(!Empty(SD3->D3_LOTECTL),DTOS( SD3->D3_DTVALID ),"20491231") , "@R 9999-99-99" )+"T00:00:00"
	Self:LOTECTL			:= SD3->D3_LOTECTL
	Self:LOCALARMAZENAGEM	:= SD3->D3_LOCAL
	
Return
