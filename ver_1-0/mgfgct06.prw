#include "protheus.ch"
#include "tbiconn.ch"

User Function x6TGCT()
	Local cError     := ''
	Local aCabec	:= {} //-- Cabecalho para rotina automatica CNTA120
	Local aItem		:= {} //-- Itens para rotina automatica CNTA120
	Local xOldFIl	:= cFilAnt
	
	Private	lMsHelpAuto := .T.
	Private	lMsErroAuto := .F.	
	
	cFilAnt := Alltrim(GetMV('MGF_CT09FI',.F.,"'010001'"))
	
	cDoc := CriaVar("CND_NUMMED")	

	Alert("Entrou: " + cDoc)

	aAdd(aCabec,{"CND_FILIAL",'010001',NIL})
	aAdd(aCabec,{"CND_CONTRA",'000000000000005',NIL})	
	aAdd(aCabec,{"CND_REVISA",'   ',NIL})	
	aAdd(aCabec,{"CND_COMPET",'01/2018',NIL})	
	aAdd(aCabec,{"CND_NUMERO",'000001',NIL})	
	aAdd(aCabec,{"CND_NUMMED",cDoc,NIL})	
	aAdd(aCabec,{"CND_CLIENT",'000002',NIL})  
	aAdd(aCabec,{"CND_LOJACL",'01',NIL})
	aAdd(aCabec,{"CND_FILCTR",'010001',NIL})
	aAdd(aCabec,{"CND_PARCEL",'01',NIL})

	/*If !Empty(CND->( FieldPos( "CND_PARCEL" ) ))		
		aAdd(aCabec,{"CND_PARCEL",(cArqTrb)->CNF_PARCEL,NIL})	
	EndIf*/		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	//³ Executa rotina automatica para gerar as medicoes ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	//CNTA120(aCabec,aItem,3,.F.)		
	MSExecAuto( { |x,y,z| CNTA120( x,y,z ) }, aCabec, aItem, 3 )

	//CNTA120(aCabEC,aItem,6,.F.)	

	If !lMsErroAuto
		ALert("Incluido com sucesso! " + cDoc)		
	Else		
		If (!IsBlind()) // COM INTERFACE GRÁFICA
	         MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
		Alert("Erro na inclusao!")	
	EndIf	
	
	cFilAnt :=  xOldFIl
	
Return


/*
=====================================================================================
Programa.:              mgfgct06
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Gera a medição automática do contrato a partir do faturamento, efetua ajuste das amarrações do contrao x pedido x titulo
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada através do ponto de entrada A410CONS()
=====================================================================================
*/
User Function mgfgct06(aItem,_cChaveSE1)
    Local cError     := ''
	Local _cDoc		:= ""
	Local _cPedido	:= ""
	Local _cArqTrb	:= ""
	Local _cContra	:= ""
	Local _cRevisa	:= ""
	Local _cCliente	:= "" 
	Local _cLoja	:= ""
	Local _cParcel	:= ""
	Local _cPlan	:= ""
	Local _dData	:= date()//Data Atual
	Local _dDataI	:= _dData-0//Data de inicio
	Local _aCabec	:= {}
	Local _aItens	:= {}

	Local aCabCN120	:= {} //-- Cabecalho para rotina automatica CNTA120
	Local aItemCN120:= {} //-- Itens para rotina automatica CNTA120

	local aArea		:= getArea()
	local aAreaSA1	:= SA1->(getArea())

	local _cXOldFil	:= cFilAnt

	Local _xcFil	:= Alltrim(GetMV('MGF_CT09FI',.F.,"'010001'"))
	
	Local cChvCN9	:= ""
	Local cChvCND	:= ""
	
	//private lMsHelpAuto     := .T. // se .t. direciona as mensagens de help para o arq. de log
	private lMsErroAuto     := .F.
	//private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	// rotina especifica de transferencia entre filiais nao deve avaliar as regras
	If IsInCallStack("U_MGFEST01")
		Return(.T.)
	Endif	

	// pedidos do EEC nao deve avaliar as regras
	If IsInCallStack("EECAP100")
		Return(.T.)
	Endif	

	// rotina especifica de copia de pedidos
	If IsInCallStack("U_TSTCOPIA")
		Return(.T.)
	Endif	

	// inclusão de Carga Taura
	If IsInCallStack("GravarCarga") .or. IsInCallStack("U_TAS02EECPA100") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("U_xGravarCarga") .or. IsInCallStack("U_xTAS02EECPA100")
		Return(.T.)
	Endif	

	ConOut(PadC("Rotina Automática para a Medição do Contrato de Compras e Vendas",80))

	DbSelectArea("SC5")
	_cPedido := SC5->C5_NUM
	If !Empty(SC5->C5_ZMDCTR) //.And. Empty(SC5->C5_ZMDPLAN)
		lCNTA120 := .T.
		//cNumMed := CriaVar("CND_NUMMED")
		//Reclock("SC5",.F.)
		//SC5->C5_ZNUMED := cNumMed
		//M->C5_MDNUMED := cNumMed
		//MsUnlock()
	EndIf

	dbSelectArea("CN9")
	dbgoto(Recno())    
	_cCliente:= SC5->C5_CLIENTE
	_cLoja   := SC5->C5_LOJACLI
	_cContra := SC5->C5_ZMDCTR
	_cRevisa := SC5->C5_ZREVIS
	_cParcel := SC5->C5_ZPARCEL
	_cPlan   := SC5->C5_ZMDPLAN
	ConOut("Inicio: "+Time()) 

	//Possiciona no Contrato
	dbSelectArea("CN9")
	CN9->(dbSetOrder(1))//CN9_FILIAL+CN9_NUMERO+CN9_REVISA
	If CN9->(dbSeek(xFilial("CN9",_xcFil) + _cContra + _cRevisa))
		
		cChvCN9	:= _xcFil + _cContra + _cRevisa
		
		_aCabec := {}
		_aItens := {}  

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra parcelas de contratos automaticos ³
		//³ pendentes para a data atual              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cArqTrb := CriaTrab( nil, .F. )     
		cQuery := "SELECT CN9.CN9_FILIAL,CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9_ZTOTDE, CNF.CNF_CONTRA,CNF.CNF_REVISA,CNA.CNA_NUMERO,CNA.CNA_DTINI," + CRLF
		cQuery += "CNA.CNA_CLIENT,CNA.CNA_LOJACL,CNF.CNF_PARCEL,CNF.CNF_COMPET " + CRLF
		cQuery += "FROM "+RetSQLName("CN9") + " CN9 " + CRLF
		cQuery += "LEFT JOIN "+RetSQLName("CNA") + " CNA ON CNA.CNA_FILIAL = '" + _xcFil +"' AND " + CRLF 
		cQuery += "CNA.CNA_CONTRA = CN9.CN9_NUMERO AND CNA.CNA_REVISA = CN9.CN9_REVISA AND CNA.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "LEFT JOIN "+RetSQLName("CNF") + " CNF ON CNF.CNF_FILIAL = '"+ _xcFil + "' AND " + CRLF
		cQuery += "CNF.CNF_CONTRA = CN9.CN9_NUMERO AND CNF.CNF_REVISA = CN9.CN9_REVISA " + CRLF
		cQuery += "AND CNF.CNF_NUMERO = CNA.CNA_CRONOG AND CNF.CNF_SALDO > 0 AND CNF.CNF_PARCEL  = '"+_cParcel+"' AND " + CRLF
		cQuery += "CNF.D_E_L_E_T_ = '' " + CRLF
		cQuery += "WHERE  CN9.CN9_FILIAL = '"+ _xcFil +"' AND " + CRLF
		cQuery += "CN9.CN9_NUMERO = '"+_cContra+"' AND " + CRLF
		cQuery += "CN9.CN9_REVISA = '"+_cRevisa+"' AND " + CRLF
		cQuery += "CN9.CN9_SITUAC = '05'" + "AND " + CRLF
		cQuery += "CNA.CNA_CLIENT = '"+SF2->F2_CLIENTE+"' AND " + CRLF
		cQuery += "CNA.CNA_LOJACL = '"+SF2->F2_LOJA+"'" 

		cQuery := ChangeQuery( cQuery )

		memoWrite( "C:\TEMP\queryGCT.sql", cQuery )

		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), _cArqTrb, .T., .T. )

		DBSelectArea("SA1")
		SA1->(DBSetOrder(1))

		While !(_cArqTrb)->(Eof())

			SA1->( DBGoTop() )
			if SA1->( DBSeek( xFilial("SA1") + (_cArqTrb)->CNA_CLIENT + (_cArqTrb)->CNA_LOJACL ) )
				if SA1->A1_MSBLQL == "1" // BLOQUEADO
					(_cArqTrb)->( DBSkip() )
					loop
				endif
			endif

			cFilAnt := _xcFil 

			_cDoc := CriaVar("CND_NUMMED")
			//_cDoc := GETSX8NUM("CND","CND_NUMMED")
			//_cDoc := CN130NumMd()

			aAdd(aCabCN120, {"CND_FILIAL",cFilAnt,NIL})
			aAdd(aCabCN120, {"CND_FILCTR",cFilAnt,NIL})
			aAdd(aCabCN120, {"CND_CLIENT",(_cArqTrb)->CNA_CLIENT,NIL})  // CNA_CONTRA
			aAdd(aCabCN120, {"CND_LOJACL",(_cArqTrb)->CNA_LOJACL,NIL})  // CNA_REVISA
			aAdd(aCabCN120, {"CND_CONTRA",(_cArqTrb)->CN9_NUMERO,NIL})  // CNA_CONTRA
			aAdd(aCabCN120, {"CND_REVISA",(_cArqTrb)->CN9_REVISA,NIL})  // CNA_REVISA 
			//aAdd(aCabCN120, {"CND_REVISA", "001",NIL})  // CNA_REVISA

			_cDescfin := (_cArqTrb)->CN9_ZTOTDE
			_cDiadesc := (_cArqTrb)->CN9_ZTOTDE

			_cCompet := substr(dtos(dDatabase),5,2)+'/'+substr(dtos(dDatabase),1,4)// MM/AAAA
			aAdd(aCabCN120,{"CND_COMPET",_cCompet,NIL})  //

			AAdd(aCabCN120,{"CND_NUMERO",(_cArqTrb)->CNA_NUMERO,NIL})  // CNA_NUMERO
			AAdd(aCabCN120,{"CND_ZROTIN",'MATA460',NIL})
			aAdd(aCabCN120,{"CND_NUMMED",_cDoc,NIL})
			If !Empty(ALLTRIM(CND->( FieldPos( "CND_PARCEL" ))))
				aAdd(aCabCN120,{"CND_PARCEL",(_cArqTrb)->CNF_PARCEL,NIL})
			Else
				aAdd(aCabCN120,{"CND_PARCEL",'01',NIL})
			EndIf

			aAdd(aCabCN120,{"CND_OBS","Medição automática - Pedido de venda número " + _cPedido +" - Nota: .",NIL}) //Medição gerada automaticamente a partir da inclusão do pedido de venda número ###.
			aAdd(aCabCN120,{"NUMPED",_cPedido,NIL})
			aAdd(aCabCN120,{"CND_SERVIC","1",NIL}) 
			
			BEGIN TRANSACTION
				//lMsHelpAuto     := .T.
				lMsErroAuto     := .F.
				//lAutoErrNoFile  := .T.

				//Executa rotina automatica para gerar as medicoes
				CNTA120(aCabCN120,aItem,3,.F.)
				
				if lMsErroAuto
					DISARMTRANSACTION()
					//ROLLBACKSX8()
					If (!IsBlind()) // COM INTERFACE GRÁFICA
				         MostraErro()
				    Else // EM ESTADO DE JOB
				        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
				
				        ConOut(PadC("Automatic routine ended with error", 80))
				        ConOut("Error: "+ cError)
				    EndIf
					_lToK := .F.
					APmsgalert("Medição do contrato " + allTrim(_cContra) + " não gerada!")
				else
					//CONFIRMSX8()
					DBSelectArea("CND")
					CND->( DBSetOrder(4) ) // CND_FILIAL+CND_NUMMED
					CND->( DBGoTop() )
					cChvCND := _xcFil + _cDoc
					if CND->( DBSeek( _xcFil + _cDoc) )
						recLock("CND", .F.)
						CND->CND_CLIENT := (_cArqTrb)->CNA_CLIENT
						CND->CND_LOJACL := (_cArqTrb)->CNA_LOJACL
						CND->CND_SITUAC := 'E'
						CND_DTFIM 		:= dDataBase
						CND_PEDIDO		:= _cPedido
						CND->( msUnlock() )
					endif

					// comentada em 34/04/18 por gresele, pois foi identificado que esta tela estah ocasionando problema de lock na sb2, pois a durante a geracao da nota de saida
					// esta tela aparece e fica aguardando o usuario confirmar, e se neste momento o taura enviar o carregamento da carga de pedidos, pode ocasionar lock se os 
					// produtos forem concorrentes.
					//APmsgalert("Gerada Medição " + allTrim(_cDoc) + " do contrato " + allTrim(_cContra) )
				endif

			END TRANSACTION

			(_cArqTrb)->(dbSkip())	
		EndDo 
		(_cArqTrb)->(dbCloseArea())
	EndIf
	

	cFilAnt := _cXOldFil

	restArea(aAreaSA1)
	restArea(aArea)

Return(.T.)

User Function xMGCT6MED(cEmp,cFil,cModulo,aCabCN120,aItemCN120,cChvCN9,cChvCND)
	
	Local lPrepEnv  := ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local aInfo		:= {}
	Local ni		:= 0
	Local bError := ErrorBlock( { |oError| MyError( oError ) } )

	Private	lMsHelpAuto := .T.
	Private	lMsErroAuto := .F.

	If ( lPrepEnv )
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cModulo ) TABLES "SA1", "SB1", "SF4", "SZT", "SZV", "SZU", "SE1", "SDE", "CN9", "CND", "CNE","CNA" 
	EndIf	

	BEGIN SEQUENCE

		Conout('Iniciou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME() + ' Modulo: ' + IIF(Valtype(cModulo)=='C',cModulo,''))
		
		dbSelectArea("CNA")
		CNA->(dbSetOrder(1))
		CNA->(dbSeek(cChvCN9))

		dbSelectArea("CND")
		CND->(dbSetOrder(1))
		CND->(dbSeek(cChvCND))
		
		CNTA120(aCabCN120,aItemCN120,6,.F.)
		
		If !lMsErroAuto
			Conout('OK')
		Else
			Conout('NOK')
		EndIf

		Conout('Terminou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())	

		RECOVER
		Conout('Deu Problema na Execução' + ' Horas: ' + TIME() )
	END SEQUENCE

	ErrorBlock( bError )

	If ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

Return .T.

Static Function MyError(oError )
	Conout( oError:Description + "Deu Erro" )
	BREAK
Return Nil