#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

#define CRLF chr(13) + chr(10)

static _aErr
/*
=====================================================================================
Programa.:              MGFWSS05
Autor....:              Leonardo Kume
Data.....:              13/02/2017
Descricao / Objetivo:   WS para retornar informações 
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
WSSTRUCT CentroCusto
	WSDATA idCentro			as string
	WSDATA cClasse			as string	
	WSDATA cDescricao		as string	
ENDWSSTRUCT

WSSTRUCT Fornecedor
	WSDATA idFornecedor  as string
	WSDATA cNome 		 as string
	WSDATA cCNPJ 		 as string
	WSDATA cTipo		 as string
	WSDATA cEndereco	 as string
	WSDATA cBairro		 as string
	WSDATA cCidade		 as string
	WSDATA cUf			 as string
	WSDATA cTelefone	 as string
	WSDATA cNumBanco	 as string
	WSDATA cNumAgencia	 as string
	WSDATA cNumConta	 as string
ENDWSSTRUCT

WSSTRUCT Empresa
	WSDATA idEmpresa  as String
	WSDATA idFilial	  as String
	WSDATA cDescricao as String
	WSDATA cRazao 	  as String
	WSDATA cCNPJ 	  as String
	WSDATA cCodMun 	  as String
ENDWSSTRUCT

WSSTRUCT TipoDespesa
	WSDATA IdTpDespesa	as string
	WSDATA cNome			as string
ENDWSSTRUCT

WSSTRUCT ItemProd
	WSDATA IdItem		as string
	WSDATA cNome		as string
	WSDATA cUM			as string
ENDWSSTRUCT

WSSTRUCT Cidade
	WSDATA idCidade			as string
	WSDATA cNomeCidade		as string
	WSDATA cEstado			as string
ENDWSSTRUCT

WSSTRUCT Pais
	WSDATA idPais				as string
	WSDATA cNomePais			as string
ENDWSSTRUCT

WSSTRUCT TitulosBordero
	WSDATA dEmissao			as date
	WSDATA idTitulo			as string
	WSDATA nDesconto		as float
	WSDATA nJuros			as float
	WSDATA nValor			as float
	WSDATA nValorNominal	as float
	WSDATA dDataProposta	as date
	WSDATA cSituacao		as string
	WSDATA cBaixada			as string
	WSDATA dVencimento		as date
	WSDATA cCap		   		as string
	WSDATA cNumDocumento	as string
	WSDATA dDataRemessa  	as date
	WSDATA cLoteRemessa		as string
	WSDATA cLotePagamento	as string
	WSDATA cCodFornecedor	as string
	WSDATA cDepBol	   		as string
	WSDATA cSupCap	   		as string
	WSDATA nTotal	   		as float
ENDWSSTRUCT

WSSTRUCT ItemTitulos
	WSDATA idItem			as string
	WSDATA cProduto			as string
	WSDATA nValor			as float
	WSDATA nDesc			as float
ENDWSSTRUCT

WSSTRUCT CondicaoPagto
	WSDATA idCondicao			as string
	WSDATA cDescricao			as string
ENDWSSTRUCT

WSSTRUCT Comprador
	WSDATA idComprador	as string
	WSDATA cNome			as string
ENDWSSTRUCT

WSSTRUCT EmpresaFilial
	WSDATA empresa		as string
	WSDATA filial		as string
ENDWSSTRUCT

WSSERVICE MGFWSS05 DESCRIPTION "Consulta SFA" namespace "http://www.totvs.com.br/MGFWSS02"
	WSDATA centroCusto			as ARRAY OF CentroCusto
	WSDATA fornecedor			as ARRAY OF Fornecedor
	WSDATA empresa				as ARRAY OF Empresa
	WSDATA tipoDespesa			as ARRAY OF TipoDespesa
	WSDATA item					as ARRAY OF ItemProd
	WSDATA cidade				as ARRAY OF Cidade
	WSDATA pais					as ARRAY OF Pais
	WSDATA titulosBordero		as ARRAY OF TitulosBordero
	WSDATA condicaopagto		as ARRAY OF CondicaoPagto
	WSDATA comprador			as ARRAY OF Comprador
	WSDATA empresaFilial		as EmpresaFilial
	WSDATA codigo				as String OPTIONAL
	WSDATA descricao			as String OPTIONAL
	WSDATA vencrea				as date OPTIONAL
	WSDATA emissao				as date OPTIONAL

	WSMETHOD enviaCentroCusto		DESCRIPTION "Envia dados Centro de custo"	
	WSMETHOD enviaFornecedor		DESCRIPTION "Envia dados Fornecedor"	
	WSMETHOD enviaEmpresa			DESCRIPTION "Envia dados Empresa"	
	WSMETHOD enviaTipoDespesa		DESCRIPTION "Envia dados Tipo Despesa"	
	WSMETHOD enviaItem				DESCRIPTION "Envia dados Item"	
	WSMETHOD enviaCidade			DESCRIPTION "Envia dados Cidade"	
	WSMETHOD enviaPais				DESCRIPTION "Envia dados Pais"	
	WSMETHOD enviaTitulosBordero	DESCRIPTION "Envia dados Titulos Bordero"	
	WSMETHOD enviaCondicaopagto		DESCRIPTION "Envia dados Condicao Pagamento"	
	WSMETHOD enviaComprador			DESCRIPTION "Envia dados Comprador"	
ENDWSSERVICE

WSMETHOD enviaCentroCusto WSRECEIVE empresaFilial, codigo, descricao WSSEND centroCusto WSSERVICE MGFWSS05
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaCentroCusto", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT CTT_CUSTO,CTT_CLASSE,CTT_DESC01 "
		cQ += "FROM "+RetSqlName("CTT")+" CTT "
		cQ += "WHERE CTT_FILIAL = '"+xFilial("CTT")+"' "
		If !Empty(Codigo)
			cQ += "AND CTT_CUSTO LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND CTT_DESC01 LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND CTT_BLOQ <> '1' " 
		cQ += "AND CTT.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY CTT_CUSTO "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY CTT_DESC01 "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::centroCusto := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::centroCusto,WSClassNew("CentroCusto"))
			::centroCusto[len(::centroCusto)]:idCentro 		:= (cAliasTrb)->CTT_CUSTO
			::centroCusto[len(::centroCusto)]:cClasse 		:= (cAliasTrb)->CTT_CLASSE
			::centroCusto[len(::centroCusto)]:cDescricao 	:= (cAliasTrb)->CTT_DESC01
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("CTT")
		CTT->(DbSetOrder(1))
		If !Empty(codigo)
			lRet := CTT->(DbSeek(xFilial("CTT")+alltrim(codigo)))
		ElseIf !Empty(descricao)
			CTT->(DbSetOrder(4))
			lRet := CTT->(DbSeek(xFilial("CTT")+alltrim(descricao)))
		EndIf

		::centroCusto := {}
		While !CTT->(Eof()) .And. lRet
			If 	alltrim(CTT->CTT_CUSTO) == alltrim(codigo) .or. ;
				alltrim(CTT->CTT_DESC01) == alltrim(descricao) .or.;
				(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
				aAdd(::centroCusto,WSClassNew( "CentroCusto"))
				::centroCusto[len(::centroCusto)]:idCentro 		:= CTT->CTT_CUSTO
				::centroCusto[len(::centroCusto)]:cClasse 		:= CTT->CTT_CLASSE
				::centroCusto[len(::centroCusto)]:cDescricao 	:= CTT->CTT_DESC01
				CTT->(DbSkip())
			Else
				exit
			EndIf
		EndDo
		*/
		if Len(::centroCusto) == 0
			SetSoapFault("enviaCentroCusto", "Status:2 -Observação: Não há centro de Custo")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaCentroCusto", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaFornecedor WSRECEIVE empresaFilial,codigo,descricao WSSEND fornecedor WSSERVICE MGFWSS05

	Local lRet		:= .T.
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaFornecedor", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT A2_COD,A2_NOME,A2_CGC,A2_TIPO,A2_END,A2_BAIRRO,A2_MUN,A2_EST,A2_TEL,A2_BANCO,A2_AGENCIA,A2_NUMCON "
		cQ += "FROM "+RetSqlName("SA2")+" SA2 "
		cQ += "WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
		If !Empty(Codigo)
			cQ += "AND A2_COD LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND A2_NOME LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND A2_MSBLQL <> '1' " 
		cQ += "AND SA2.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY A2_COD,A2_LOJA "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY A2_NOME "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::fornecedor := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::fornecedor,WSClassNew("Fornecedor"))
			::fornecedor[len(::fornecedor)]:idFornecedor 	:= (cAliasTrb)->A2_COD
			::fornecedor[len(::fornecedor)]:cNome 			:= (cAliasTrb)->A2_NOME
			::fornecedor[len(::fornecedor)]:cCNPJ 			:= (cAliasTrb)->A2_CGC
			::fornecedor[len(::fornecedor)]:cTipo			:= (cAliasTrb)->A2_TIPO
			::fornecedor[len(::fornecedor)]:cEndereco		:= (cAliasTrb)->A2_END	
			::fornecedor[len(::fornecedor)]:cBairro			:= (cAliasTrb)->A2_BAIRRO
			::fornecedor[len(::fornecedor)]:cCidade			:= (cAliasTrb)->A2_MUN	
			::fornecedor[len(::fornecedor)]:cUf				:= (cAliasTrb)->A2_EST	
			::fornecedor[len(::fornecedor)]:cTelefone		:= (cAliasTrb)->A2_TEL
			::fornecedor[len(::fornecedor)]:cNumBanco		:= (cAliasTrb)->A2_BANCO
			::fornecedor[len(::fornecedor)]:cNumAgencia		:= (cAliasTrb)->A2_AGENCIA
			::fornecedor[len(::fornecedor)]:cNumConta		:= (cAliasTrb)->A2_NUMCON
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("SA2")
		DbSetOrder(1)
		If !Empty(codigo)
			lRet := SA2->(DbSeek(xFilial("SA2")+alltrim(codigo)))
		ElseIf !Empty(descricao)
			SA2->(DbSetOrder(2))
			lRet := SA2->(DbSeek(xFilial("SA2")+alltrim(descricao)))
		EndIf
		
		::fornecedor := {}
		While !SA2->(Eof()).And. lRet
			If 	alltrim(SA2->A2_COD) == alltrim(codigo) .or. ;
				alltrim(SA2->A2_NOME) == alltrim(descricao) .or.;
				(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
				aAdd(::fornecedor,WSClassNew( "Fornecedor"))			
				::fornecedor[len(::fornecedor)]:idFornecedor 	:= SA2->A2_COD
				::fornecedor[len(::fornecedor)]:cNome 			:= SA2->A2_NOME
				::fornecedor[len(::fornecedor)]:cCNPJ 			:= SA2->A2_CGC
				::fornecedor[len(::fornecedor)]:cTipo			:= SA2->A2_TIPO
				::fornecedor[len(::fornecedor)]:cEndereco		:= SA2->A2_END		
				::fornecedor[len(::fornecedor)]:cBairro			:= SA2->A2_BAIRRO
				::fornecedor[len(::fornecedor)]:cCidade			:= SA2->A2_MUN	
				::fornecedor[len(::fornecedor)]:cUf				:= SA2->A2_EST	
				::fornecedor[len(::fornecedor)]:cTelefone		:= SA2->A2_TEL
				::fornecedor[len(::fornecedor)]:cNumBanco		:= SA2->A2_BANCO
				::fornecedor[len(::fornecedor)]:cNumAgencia		:= SA2->A2_AGENCIA
				::fornecedor[len(::fornecedor)]:cNumConta		:= SA2->A2_NUMCON
				SA2->(DbSkip())
			Else
				exit
			EndIf
		EndDo
		*/
		if Empty(::fornecedor)
			SetSoapFault("enviaFornecedor", "Status:2 -Observação: Não há Fornecedor")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaFornecedor", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaEmpresa WSRECEIVE empresaFilial, codigo, descricao WSSEND empresa WSSERVICE MGFWSS05
	Local lRet		:= .T.
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaEmpresa", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		If !MPDicInDB()
			//OpenSM0()
			SM0->(DbSetOrder(1))//M0_CODIGO+M0_CODFIL (2+12)
			
			If !Empty(codigo)
				lRet := SM0->(DbSeek(cEmpAnt+alltrim(codigo)))
			ElseIf !Empty(descricao)
				SM0->(DbSetOrder(2))//M0_NOME+M0_FILIAL (40+60)
				lRet := SM0->(DbSeek(alltrim(descricao)))
			EndIf
			
			::empresa := {}
			While !SM0->(Eof())
				If 	alltrim(SM0->M0_CODFIL) == alltrim(codigo) .or. ;
					alltrim(SM0->M0_NOME+SM0->M0_FILIAL) == alltrim(descricao) .or.;
					(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
					
					aAdd(::empresa,WSClassNew("Empresa"))
					::empresa[len(::empresa)]:idEmpresa 	:= SM0->M0_CODIGO
					::empresa[len(::empresa)]:idFilial 		:= SM0->M0_CODFIL
					::empresa[len(::empresa)]:cDescricao	:= SM0->M0_NOME
					::empresa[len(::empresa)]:cRazao 		:= SM0->M0_FILIAL
					::empresa[len(::empresa)]:cCNPJ 		:= SM0->M0_CGC
					::empresa[len(::empresa)]:cCodMun 		:= SM0->M0_CODMUN
					SM0->(DbSkip())
				Else
					Exit
				EndIf
			EndDo
		Else	
			cAliasTrb := GetNextAlias()
	        
			cQ := "SELECT M0_CODIGO,M0_CODFIL,M0_NOME,M0_FILIAL,M0_CGC,M0_CODMUN "
			cQ += "FROM "+MPSysSqlName("SYS_COMPANY")+" SM0 "
			cQ += "WHERE SM0.D_E_L_E_T_ = ' ' "
			If !Empty(Codigo)
				cQ += "AND M0_CODFIL LIKE '%"+Upper(Alltrim(Codigo))+"%' "
			Endif	
			If !Empty(Descricao)
				cQ += "AND (M0_NOME LIKE '%"+Upper(Alltrim(Descricao))+"%' OR M0_FILIAL LIKE '%"+Upper(Alltrim(Descricao))+"%') "
			Endif	
			If !Empty(Codigo) .or. Empty(Descricao)
				cQ += "ORDER BY M0_CODIGO,M0_CODFIL "
			Elseif !Empty(Descricao)
				cQ += "ORDER BY M0_FILIAL "
			Endif
			
			cQ := ChangeQuery(cQ)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
			
			::empresa := {}
			While (cAliasTrb)->(!Eof())
				aAdd(::empresa,WSClassNew("Empresa"))
				::empresa[len(::empresa)]:idEmpresa 	:= (cAliasTrb)->M0_CODIGO
				::empresa[len(::empresa)]:idFilial 		:= (cAliasTrb)->M0_CODFIL
				::empresa[len(::empresa)]:cDescricao	:= (cAliasTrb)->M0_NOME
				::empresa[len(::empresa)]:cRazao 		:= (cAliasTrb)->M0_FILIAL
				::empresa[len(::empresa)]:cCNPJ 		:= (cAliasTrb)->M0_CGC
				::empresa[len(::empresa)]:cCodMun 		:= (cAliasTrb)->M0_CODMUN
				(cAliasTrb)->(dbSkip())
			Enddo
			(cAliasTrb)->(dbCloseArea())	
		Endif	
					
		if Empty(::empresa)
			SetSoapFault("enviaEmpresa", "Status:2 -Observação: Não há Empresa")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaEmpresa", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaTipoDespesa WSRECEIVE empresaFilial WSSEND tipoDespesa WSSERVICE MGFWSS05
	Local lRet		:= .T.
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaTipoDespesa", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT ED_CODIGO,ED_DESCRIC "
		cQ += "FROM "+RetSqlName("SED")+" SED "
		cQ += "WHERE ED_FILIAL = '"+xFilial("SED")+"' "
		cQ += "AND ED_MSBLQL <> '1' " 
		cQ += "AND ED_COND = 'D' "
		cQ += "AND SED.D_E_L_E_T_ = ' ' "
		cQ += "ORDER BY ED_CODIGO "
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::tipoDespesa := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::tipoDespesa,WSClassNew("tipoDespesa"))
			::tipoDespesa[len(::tipoDespesa)]:idTpDespesa	:= (cAliasTrb)->ED_CODIGO
			::tipoDespesa[len(::tipoDespesa)]:cNome 		:= (cAliasTrb)->ED_DESCRIC			
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
		if Empty(::tipoDespesa)
			SetSoapFault("enviaTipoDespesa", "Status:2 -Observação: Não há Tipo Despesa")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaTipoDespesa", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaItem WSRECEIVE empresaFilial, codigo, descricao WSSEND item WSSERVICE MGFWSS05
	Local lRet		:= .T.
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaItem", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT B1_COD,B1_DESC,B1_UM "
		cQ += "FROM "+RetSqlName("SB1")+" SB1 "
		cQ += "WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
		If !Empty(Codigo)
			cQ += "AND B1_COD LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND B1_DESC LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND B1_MSBLQL <> '1' " 
		cQ += "AND SB1.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY B1_COD "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY B1_DESC "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::item := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::item,WSClassNew("ItemProd"))
			::item[len(::item)]:idItem	:= (cAliasTrb)->B1_COD
			::item[len(::item)]:cNome 	:= (cAliasTrb)->B1_DESC
			::item[len(::item)]:cUM 	:= (cAliasTrb)->B1_UM
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("SB1")
		DbSetOrder(1)
		
		If !Empty(codigo)
			lRet := SB1->(DbSeek(xFilial("SB1")+alltrim(codigo)))
		ElseIf !Empty(descricao)
			SB1->(DbSetOrder(3))//B1_FILIAL+B1_DESC+B1_COD
			lRet := SB1->(DbSeek(xFilial("SB1")+alltrim(descricao)))
		EndIf
		
		::item := {}
		While !SB1->(Eof()) .And. lRet
			If 	alltrim(SB1->B1_COD) == alltrim(codigo) .or. ;
				alltrim(SB1->B1_DESC) == alltrim(descricao) .or.;
				(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
				aAdd(::item,WSClassNew( "ItemProd"))
				::item[len(::item)]:idItem	:= SB1->B1_COD
				::item[len(::item)]:cNome 	:= SB1->B1_DESC
				::item[len(::item)]:cUM 	:= SB1->B1_UM
	//			::item[len(::item)]:cGrDesp	:= SB1->B1_UM
	//			::item[len(::item)]:cTpDesp	:= SB1->B1_UM
				SB1->(DbSkip())
			Else
				Exit
			EndIf
		EndDo
		*/
		if Empty(::item)
			SetSoapFault("enviaItem", "Status:2 -Observação: Não há Item")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaItem", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet


WSMETHOD enviaCidade WSRECEIVE empresaFilial, codigo, descricao WSSEND cidade WSSERVICE MGFWSS05
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaCidade", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT CC2_CODMUN,CC2_MUN,CC2_EST "
		cQ += "FROM "+RetSqlName("CC2")+" CC2 "
		cQ += "WHERE CC2_FILIAL = '"+xFilial("CC2")+"' "
		If !Empty(Codigo)
			cQ += "AND CC2_CODMUN LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND CC2_MUN LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND CC2.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY CC2_CODMUN "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY CC2_MUN "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::cidade := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::cidade,WSClassNew("Cidade"))
			::cidade[len(::cidade)]:idCidade		:= (cAliasTrb)->CC2_CODMUN
			::cidade[len(::cidade)]:cNomeCidade		:= (cAliasTrb)->CC2_MUN
			::cidade[len(::cidade)]:cEstado			:= (cAliasTrb)->CC2_EST
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("CC2")
		DbSetOrder(3)
		
		If !Empty(codigo)
			lRet := CC2->(DbSeek(xFilial("CC2")+alltrim(codigo)))
		ElseIf !Empty(descricao)
			CC2->(DbSetOrder(2))//CC2_FILIAL+CC2_MUN
			lRet := CC2->(DbSeek(xFilial("CC2")+alltrim(descricao)))
		EndIf
		
		::cidade := {}
		While !CC2->(Eof()) .And. lRet
			If 	alltrim(CC2->CC2_CODMUN) == alltrim(codigo) .or. ;
				alltrim(CC2->CC2_MUN) == alltrim(descricao) .or.;
				(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
				aAdd(::cidade,WSClassNew( "Cidade"))
				::cidade[len(::cidade)]:idCidade		:= CC2->CC2_CODMUN
				::cidade[len(::cidade)]:cNomeCidade		:= CC2->CC2_MUN
				::cidade[len(::cidade)]:cEstado			:= CC2->CC2_EST
				CC2->(DbSkip())
			Else
				Exit
			EndIf
		EndDo
		*/
		if Empty(::cidade)
			SetSoapFault("enviaCidade", "Status:2 -Observação: Não há Cidade")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaCidade", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet


WSMETHOD enviaPais WSRECEIVE empresaFilial, codigo, descricao WSSEND pais WSSERVICE MGFWSS05
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaPais", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT YA_CODGI,YA_DESCR "
		cQ += "FROM "+RetSqlName("SYA")+" SYA "
		cQ += "WHERE YA_FILIAL = '"+xFilial("SYA")+"' "
		If !Empty(Codigo)
			cQ += "AND YA_CODGI LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND YA_DESCR LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND SYA.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY YA_CODGI "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY YA_DESCR "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::pais := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::pais,WSClassNew("pais"))
			::pais[len(::pais)]:idPais		:= (cAliasTrb)->YA_CODGI
			::pais[len(::pais)]:cNomePais	:= (cAliasTrb)->YA_DESCR
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("SYA")
		DbSetOrder(1)
		
		If !Empty(codigo)
			lRet := SYA->(DbSeek(xFilial("SYA")+alltrim(codigo)))
		ElseIf !Empty(descricao)
			SYA->(DbSetOrder(2))//YA_FILIAL+YA_DESCR
			lRet := SYA->(DbSeek(xFilial("SYA")+alltrim(descricao)))
		EndIf
		
		::pais := {}
		While !SYA->(Eof())
			If 	alltrim(SYA->YA_CODGI) == alltrim(codigo) .or. ;
				alltrim(SYA->YA_DESCR) == alltrim(descricao) .or.;
				(Empty(alltrim(codigo)) .and. Empty(alltrim(descricao)))
				aAdd(::pais,WSClassNew( "pais"))
				::pais[len(::pais)]:idPais		:= SYA->YA_CODGI
				::pais[len(::pais)]:cNomePais	:= SYA->YA_DESCR
				SYA->(DbSkip())
			Else
				Exit
			EndIf
		EndDo
		*/
		if Empty(::pais)
			SetSoapFault("enviaPais", "Status:2 -Observação: Não há Pais")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaPais", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaTitulosBordero WSRECEIVE empresaFilial, codigo, vencrea, emissao WSSEND titulosBordero WSSERVICE MGFWSS05
	Local lRet		:= .T.
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}
	Local lFoundSEA := .F.
	Local lFoundSF1 := .F.

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaPais", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_DESCONT,E2_JUROS,E2_VALOR,E2_SALDO,E2_VENCREA,E2_VALOR,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NUMBOR, "
		cQ += "E2_DECRESC,E2_ACRESC,E2_ORIGEM "
		cQ += "FROM "+RetSqlName("SE2")+" SE2 "
		cQ += "WHERE E2_FILIAL = '"+xFilial("SE2")+"' "
		If !Empty(Codigo)
			cQ += "AND E2_NUM LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(VencRea)
			cQ += "AND E2_VENCREA LIKE '%"+dTos(VencRea)+"%' "
		Endif	
		If !Empty(Emissao)
			cQ += "AND E2_EMISSAO LIKE '%"+dTos(Emissao)+"%' "
		Endif	
		cQ += "AND SE2.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. (Empty(VencRea) .and. Empty(Emissao))
			cQ += "ORDER BY E2_NUM "
		Elseif !Empty(VencRea)
			cQ += "ORDER BY E2_VENCREA "
		Elseif !Empty(Emissao)
			cQ += "ORDER BY E2_EMISSAO "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		SEA->(dbSetOrder(1))
		SF1->(dbSetOrder(1))
		
		::titulosBordero := {}
		While (cAliasTrb)->(!Eof())
			lFoundSEA := .F.
			lFoundSF1 := .F.
			
			aAdd(::titulosBordero,WSClassNew("TitulosBordero"))
			If !Empty((cAliasTrb)->E2_NUMBOR)
				If SEA->(dbSeek(xFilial("SEA")+(cAliasTrb)->(E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
					lFoundSEA := .T.
				Endif	
			Endif	
			If SF1->(dbSeek(xFilial("SF1")+(cAliasTrb)->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA)+"N"))
				lFoundSF1 := .T.
			Endif	

			::titulosBordero[len(::titulosBordero)]:dEmissao		:= sTod((cAliasTrb)->E2_EMISSAO)
			::titulosBordero[len(::titulosBordero)]:idTitulo		:= (cAliasTrb)->(E2_PREFIXO+E2_NUM) //???
			::titulosBordero[len(::titulosBordero)]:nDesconto		:= (cAliasTrb)->(E2_DECRESC+E2_DESCONT)
			::titulosBordero[len(::titulosBordero)]:nJuros			:= (cAliasTrb)->(E2_JUROS+E2_ACRESC) 
			::titulosBordero[len(::titulosBordero)]:nValor			:= (cAliasTrb)->E2_SALDO
			::titulosBordero[len(::titulosBordero)]:nValorNominal 	:= (cAliasTrb)->E2_VALOR
			::titulosBordero[len(::titulosBordero)]:dDataProposta 	:= cTod("") //???
			::titulosBordero[len(::titulosBordero)]:cSituacao 		:= IIf(lFoundSEA .and. !Empty(SEA->EA_SITUACA),Upper(Posicione("SX5",1,xFilial("SX5")+"07"+SEA->EA_SITUACA,"X5_DESCRI")),"") //???
			::titulosBordero[len(::titulosBordero)]:cBaixada		:= IIf((cAliasTrb)->E2_SALDO == 0,"S","N")
			::titulosBordero[len(::titulosBordero)]:dVencimento		:= sTod((cAliasTrb)->E2_VENCREA)
			::titulosBordero[len(::titulosBordero)]:cCap			:= "" //???
			::titulosBordero[len(::titulosBordero)]:cNumDocumento 	:= "" //???
			::titulosBordero[len(::titulosBordero)]:dDataRemessa 	:= cTod("") //???
			::titulosBordero[len(::titulosBordero)]:cLoteRemessa	:= "" //???
			::titulosBordero[len(::titulosBordero)]:cLotePagamento	:= (cAliasTrb)->E2_NUMBOR //???
			::titulosBordero[len(::titulosBordero)]:cCodFornecedor	:= (cAliasTrb)->E2_FORNECE
			::titulosBordero[len(::titulosBordero)]:cDepBol 		:= IIf(lFoundSEA,IIf((cAliasTrb)->EA_MOTIVO $ "30/31","BOLETO","DEPOSITO"),"") //???
			::titulosBordero[len(::titulosBordero)]:cSupCap 		:= IIf("MATA" $ (cAliasTrb)->E2_ORIGEM,"SUP","CAP") // ???
			::titulosBordero[len(::titulosBordero)]:nTotal 			:= IIf(lFoundSF1,SF1->F1_VALBRUT,0) //???
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
        
		/*
		DbSelectArea("SE2")
		DbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM
		DbSetOrder(5) //E2_FILIAL+DTOS(E2_EMISSAO)
		
		
		If !Empty(codigo)
			lRet := SE2->(DbSeek(xFilial("SE2")+alltrim(codigo)))
		ElseIf !Empty(vencrea)
			SE2->(DbSetOrder(3)) //E2_FILIAL+DTOS(E2_VENCREA)
			lRet := SE2->(DbSeek(xFilial("SE2")+DTOS(vencrea)))
		ElseIf !Empty(emissao)
			SE2->(DbSetOrder(5)) //E2_FILIAL+DTOS(E2_EMISSAO)
			lRet := SE2->(DbSeek(xFilial("SE2")+DTOS(emissao)))
		EndIf
		
		
		::titulosBordero := {}
		While !SF1->(Eof()) .AND. lRet
			aAdd(::titulosBordero,WSClassNew("TitulosBordero"))
			::titulosBordero[len(::titulosBordero)]:dEmissao		:= SE2->E2_EMISSAO
			::titulosBordero[len(::titulosBordero)]:idTitulo		:= SE2->E2_PREFIXO+SE2->E2_NUM
			::titulosBordero[len(::titulosBordero)]:nDesconto		:= SE2->E2_DESCONT
			::titulosBordero[len(::titulosBordero)]:nJuros			:= SE2->E2_JUROS
			::titulosBordero[len(::titulosBordero)]:nValor			:= SE2->E2_VALOR
//			::titulosBordero[len(::titulosBordero)]:nValorNominal ???
//			::titulosBordero[len(::titulosBordero)]:dDataProposta ???
//			::titulosBordero[len(::titulosBordero)]:cSituacao ???
			::titulosBordero[len(::titulosBordero)]:cBaixada		:= IIF(SE2->E2_SALDO > 0, "S","N")
			::titulosBordero[len(::titulosBordero)]:dVencimento		:= SE2->E2_VENCREA
//			::titulosBordero[len(::titulosBordero)]:cCap		???
//			::titulosBordero[len(::titulosBordero)]:cNumDocumento ???
//			::titulosBordero[len(::titulosBordero)]:dDataRemessa 	???
//			::titulosBordero[len(::titulosBordero)]:cLoteRemessa	??
			::titulosBordero[len(::titulosBordero)]:cLotePagamento	:= SE2->E2_LOTE
			::titulosBordero[len(::titulosBordero)]:cCodFornecedor	:= SE2->E2_FORNECE
//			::titulosBordero[len(::titulosBordero)]:cDepBol ????
//			::titulosBordero[len(::titulosBordero)]:cSupCap ???
			::titulosBordero[len(::titulosBordero)]:nTotal 			:= SE2->E2_VALOR
			SF1->(DbSkip())
		EndDo
		*/
		if Empty(::titulosBordero)
			SetSoapFault("enviaTitulosBordero", "Status:2 -Observação: Não há Titulos Bordero")
			lRet		:= .F.
		EndIf	


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaTitulosBordero", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaCondicaopagto WSRECEIVE empresaFilial WSSEND condicaoPagto WSSERVICE MGFWSS05
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviacondicaoPagto", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT E4_CODIGO,E4_DESCRI "
		cQ += "FROM "+RetSqlName("SE4")+" SE4 "
		cQ += "WHERE E4_FILIAL = '"+xFilial("SE4")+"' "
		cQ += "AND E4_MSBLQL <> '1' "
		cQ += "AND SE4.D_E_L_E_T_ = ' ' "
		cQ += "ORDER BY E4_CODIGO "
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::condicaoPagto := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::condicaoPagto,WSClassNew("condicaoPagto"))
			::condicaoPagto[len(::condicaoPagto)]:idCondicao		:= (cAliasTrb)->E4_CODIGO
			::condicaoPagto[len(::condicaoPagto)]:cDescricao		:= (cAliasTrb)->E4_DESCRI
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("SE4")
		DbSetOrder(1)
		
		::condicaoPagto := {}
		While !SE4->(Eof())
			aAdd(::condicaoPagto,WSClassNew( "condicaoPagto"))
			::condicaoPagto[len(::condicaoPagto)]:idCondicao		:= SE4->E4_CODIGO
			::condicaoPagto[len(::condicaoPagto)]:cDescricao		:= SE4->E4_DESCRI
			SE4->(DbSkip())
		EndDo
		*/
		if Empty(::condicaoPagto)
			SetSoapFault("enviacondicaoPagto", "Status:2 -Observação: Não há Condição de Pagamento")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviacondicaoPagto", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

WSMETHOD enviaComprador WSRECEIVE empresaFilial, codigo, descricao WSSEND comprador WSSERVICE MGFWSS05
	
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	Local lRet		:= .T.
	Local cQ := ""
	Local cAliasTrb := ""
	Local aRetEmpFil := {}

	BEGIN SEQUENCE
	
		aRetEmpFil := U_WSEmpFil(empresaFilial:empresa,empresaFilial:filial)
		If !aRetEmpFil[1]
			SetSoapFault("enviaComprador", "Status:0 - Observação:"+aRetEmpFil[2][2])
			Return(.F.)
		Endif

		//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
		PREPARE ENVIRONMENT EMPRESA Alltrim(empresaFilial:empresa) FILIAL Alltrim(empresaFilial:filial)
		
		cAliasTrb := GetNextAlias()
        
		cQ := "SELECT Y1_COD,Y1_NOME,Y1_USER "
		cQ += "FROM "+RetSqlName("SY1")+" SY1 "
		cQ += "WHERE Y1_FILIAL = '"+xFilial("SY1")+"' "
		If !Empty(Codigo)
			cQ += "AND Y1_COD LIKE '%"+Upper(Alltrim(Codigo))+"%' "
		Endif	
		If !Empty(Descricao)
			cQ += "AND UPPER(Y1_NOME) LIKE '%"+Upper(Alltrim(Descricao))+"%' "
		Endif	
		cQ += "AND SY1.D_E_L_E_T_ = ' ' "
		If !Empty(Codigo) .or. Empty(Descricao)
			cQ += "ORDER BY Y1_COD "
		Elseif !Empty(Descricao)
			cQ += "ORDER BY Y1_NOME "
		Endif
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)		
		
		::comprador := {}
		While (cAliasTrb)->(!Eof())
			aAdd(::comprador,WSClassNew("Comprador"))
			::comprador[len(::comprador)]:idComprador	:= (cAliasTrb)->Y1_COD
			::comprador[len(::comprador)]:cNome			:= (cAliasTrb)->Y1_NOME
			(cAliasTrb)->(dbSkip())
		Enddo
		(cAliasTrb)->(dbCloseArea())	
				
		/*
		DbSelectArea("SA1")
		DbSetOrder(1)
		
		::comprador := {}
		While !SA1->(Eof())
			aAdd(::comprador,WSClassNew( "Comprador"))
			::comprador[len(::comprador)]:idComprador	:= SA1->A1_COD
			::comprador[len(::comprador)]:cNome			:= SA1->A1_NOME
			::comprador[len(::comprador)]:cCPF			:= SA1->A1_CGC
			SA1->(DbSkip())
		EndDo
		*/
		if Empty(::comprador)
			SetSoapFault("enviaComprador", "Status:2 -Observação: Não há Comprador")
			lRet		:= .F.
		EndIf


	RECOVER
		Conout('Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
	END SEQUENCE		

	ErrorBlock( bError )

	RESET ENVIRONMENT

	if valType(_aErr) == 'A'
		SetSoapFault("enviaComprador", "Status:"+_aErr[1]+"-Observação:"+_aErr[2])
		lRet		:= .F.
	endif

return lRet

//-------------------------------------------------------
//-------------------------------------------------------
static function MyError(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	nQtd := iif(nQtd > 4,4,nQtd) //Retorna as 4 linhas 

	for ni:=1 to nQTd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( oError:Description + " Deu Erro" )
	_aErr := {'0',cEr}
	break

return .T.
