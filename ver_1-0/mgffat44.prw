#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFFAT44
Autor....:              Atilio Amarilla
Data.....:              21/07/2017
Descricao / Objetivo:   Web Service PROTHEUS x Taura - Seguro RCTRC
=====================================================================================
*/

// Movimentos de Producao - Estrutura de dados. Retorno de RCTRC
WSSTRUCT MGFFAT44RequisRCTRC
	WSDATA NumeroNota  	AS string
	WSDATA SerieNota  	AS string
	WSDATA FilialNota	AS string
	WSDATA MSGRetorno	AS string OPTIONAL
	WSDATA Protocolo	AS string OPTIONAL
	WSDATA DataHora		AS string OPTIONAL
	WSDATA Averbacao	AS string OPTIONAL
	WSDATA CNPJSeguradora	AS string OPTIONAL
	WSDATA NomeSeguradora	AS string OPTIONAL
	WSDATA NumeroApolice	AS string OPTIONAL

ENDWSSTRUCT

// Movimentos de Producao - Estrutura de dados.  Retorno de RCTRC
WSSTRUCT MGFFAT44RetornoRCTRC
	WSDATA STATUS	AS String
	WSDATA MSG	AS String
ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Seguro RCTRC.				                       *
***************************************************************************/
WSSERVICE MGFFAT44 DESCRIPTION "Integracao Protheus x TAURA - Seguro RCTRC" NameSpace "http://totvs.com.br/MGFFAT44.apw"

	// Passagem dos parametros de entrada. Bloqueio de Estoque
	WSDATA MGFFAT44ReqRCTRC AS MGFFAT44RequisRCTRC
	// Estoque - Retorno (array). Bloqueio de Estoque
	WSDATA MGFFAT44RetRCTRC AS MGFFAT44RetornoRCTRC

	WSMETHOD RetornoRCTRC DESCRIPTION "Integracao Protheus x Taura - Bloqueio de Estoque"
	
ENDWSSERVICE

/************************************************************************************
** Metodo RetornoRCTRC
** Grava dados de retorno de Seguro RCTRC - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetornoRCTRC WSRECEIVE	MGFFAT44ReqRCTRC WSSEND MGFFAT44RetRCTRC WSSERVICE MGFFAT44
	
	Local aRetFuncao := {}
	Local lReturn	:= .T.
	
	aRetFuncao	:= MGFFAT44(	{	::MGFFAT44ReqRCTRC:NumeroNota		,;
	::MGFFAT44ReqRCTRC:SerieNota		,;
	::MGFFAT44ReqRCTRC:FilialNota		,;
	::MGFFAT44ReqRCTRC:MSGRetorno		,;
	::MGFFAT44ReqRCTRC:Protocolo		,;
	::MGFFAT44ReqRCTRC:DataHora			,;
	::MGFFAT44ReqRCTRC:Averbacao		,;
	::MGFFAT44ReqRCTRC:CNPJSeguradora	,;
	::MGFFAT44ReqRCTRC:NumeroApolice	,;
	::MGFFAT44ReqRCTRC:NomeSeguradora	} )	// Passagem de parametros para rotina

	
	
	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFAT44RetRCTRC :=  WSClassNew( "MGFFAT44RetornoRCTRC" )
	::MGFFAT44RetRCTRC:STATUS	:= aRetFuncao[1][1]
	::MGFFAT44RetRCTRC:MSG	:= aRetFuncao[1][2]

//::MGFFAT44ReqRCTRC := Nil
//DelClassINTF()
	
Return lReturn

Static Function MGFFAT44( aParam )

Local aRetorno := {}
Local cMsg     := "Nota/Serie nao localizada: "+AllTrim(aParam[1])+"/"+AllTrim(aParam[2])
Local cErro    := '2'

RpcSetType(3)
RpcSetEnv( "01" , aParam[3] , Nil, Nil, "EST", Nil )//, aTables )

aParam[1]	:= Stuff( Space( TamSX3("ZBS_NUM")[1] ) , 1 , Len(AllTrim(aParam[1])) , AllTrim(aParam[1]) ) 
aParam[2]	:= Stuff( Space( TamSX3("ZBS_SERIE")[1] ) , 1 , Len(AllTrim(aParam[2])) , AllTrim(aParam[2]) )

	dbSelectArea("ZBS")
	dbSetOrder(1) //ZBS->FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_OPER
	If ZBS->( dbSeek( aParam[3] + aParam[1] + aParam[2] + "2" ) )
	
		_ni := 1
		_catual := aParam[3] + aParam[1] + aParam[2] + "2"

		//Atualiza primeiro registro que encontrar e apaga possíveis registros duplicados
		Do while ZBS->ZBS_FILIAL+ZBS->ZBS_NUM+ZBS->ZBS_SERIE+ZBS->ZBS_OPER == _catual
	
			If _ni == 1

				_ni++

				RecLock("ZBS",.F.)
				ZBS->ZBS_DTHRWS := aParam[6] 
				ZBS->ZBS_RETWS	:= IIF((!Empty(aParam[5]) .AND. Alltrim(aParam[5]) != 'null' ),aParam[5],aParam[4])
				ZBS->ZBS_AVERBA	:= aParam[7]
				ZBS->ZBS_CNPJSE := aParam[8]
				ZBS->ZBS_NUMAPO := aParam[9] 
				ZBS->ZBS_NSEGUR := aParam[10] 
		
				If Empty(aParam[5]) .OR. Alltrim(aParam[5]) == 'null' // Erro - Sem Protocolo
					ZBS->ZBS_STATUS	:= "N"
					cErro    := '2'
					cMsg     := SUBSTR(aParam[4],1,TamSX3("Z1_ERRO")[1])
				Else
					cErro    := '1'
					cMsg     := 'Cancelamento da Averbacao efetuada com Sucesso'
					ZBS->ZBS_STATUS	:= "S"                  
				EndIf
				ZBS->(  msUnlock() )
				aRetorno	:= {{"1","Registro atualizado"}}
			
			Else

				RecLock("ZBS",.F.)
				ZBS->(Dbdelete())
				ZBS->(  msUnlock() )	

			EndIf

			ZBS->(Dbskip())

		Enddo
			
	Else
		ZBS->(DbGotop())
		If ZBS->( dbSeek( aParam[3] + aParam[1] + aParam[2] + "1"  ) )
		
			_ni := 1
			_catual := aParam[3] + aParam[1] + aParam[2] + "1"

			//Atualiza primeiro registro que encontrar e apaga possíveis registros duplicados
			Do while ZBS->ZBS_FILIAL+ZBS->ZBS_NUM+ZBS->ZBS_SERIE+ZBS->ZBS_OPER == _catual
		
				If _ni == 1

					_ni++

					RecLock("ZBS",.F.)
					ZBS->ZBS_DTHRWS := aParam[6] 
					ZBS->ZBS_RETWS	:= IIF((!Empty(aParam[5]) .AND. Alltrim(aParam[5]) != 'null' ),aParam[5],aParam[4])
					ZBS->ZBS_AVERBA	:= aParam[7]
					ZBS->ZBS_CNPJSE := aParam[8]
					ZBS->ZBS_NUMAPO := aParam[9] 
					ZBS->ZBS_NSEGUR := aParam[10] 
					If Empty(Alltrim(aParam[5])) .OR. Alltrim(aParam[5]) == 'null' // Erro - Sem Protocolo
						ZBS->ZBS_STATUS	:= "N"
						cErro    := '2'
						cMsg     := SUBSTR(aParam[4],1,TamSX3("Z1_ERRO")[1])
					Else
						cErro    := '1'
						cMsg     := 'Averbacao efetuada com Sucesso'
						ZBS->ZBS_STATUS	:= "S"
					EndIf
					ZBS->(  msUnlock() )
					aRetorno	:= {{"1","Registro atualizado"}}

				Else

					RecLock("ZBS",.F.)
					ZBS->(Dbdelete())
					ZBS->(  msUnlock() )	

				Endif

				ZBS->(Dbskip())

			Enddo
			
		Else	
			aRetorno	:= {{"2","Nota/Serie nao localizada: "+AllTrim(aParam[1])+"/"+AllTrim(aParam[2])}}
		EndIf

	EndIf

	U_MGFMONITOR( aParam[3]   ,;
			      cErro,;
			      '002',; //cCodint
		          '002',;//cCodtpint
				  cMsg,;
			      AllTrim(aParam[1])+"/"+AllTrim(aParam[2])  ,;
		          '0' ,;//cTempo
		          '')


Return aRetorno
