#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE24
Autor....:              Flávio Dentello	
Data.....:              15/01/2018
Descricao / Objetivo:   Integração PROTHEUS x Taura - Emissão CT-e
Doc. Origem:            Contrato - GAP Emissão Ct-e
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Integração de dados do CT-e
=====================================================================================
*/

//Chamada via Menu
user function XWSC23()

	runInteg23()

Return 

//-------------------------------------------------------------------
// Chamada via Schedule
user function MGFWSC23()

	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010003'

	conout('[MGFWSC03] Iniciada Threads para a empresa 01  - ' + dToC(dDataBase) + " - " + time())

	runInteg23()

	RESET ENVIRONMENT

return

//-------------------------------------------------------------------
static function runInteg23()
	local cURLPost			:= allTrim(getMv("MGF_WSC23"))
	local oWSCTE			:= nil
	local cChave			:= ""
	Local nValmerc			:= 0
	Local nQtd				:= 0
	Local nPeso				:= 0
	Local cBairro			:= ""			
	Local cCep				:= ""			
	Local cCPFCNPJ			:= ""
	Local cCodigoIBGECidade	:= ""
	Local cCodigoPais		:= ""
	Local cComplemento		:= ""
	Local cEndereco			:= ""
	Local cFil				:= ""
	Local cOE				:= ""
	Local cAliasC			:= ""
	Local lDest				:= .T.
	Local aAreaZDL  	    := ZDL->( GetArea() )
	private oOrdem			:= nil


	QWSC23() // CRIAR FUNÇÃO QUE RETORNA A QUERY DOS REGISTRO

	
	
	while !QRYZBL->(EOF()) .AND. cOE <> QRYZBL->ZDL_NUMOE 

		lDest := .T.
		
		cOE := QRYZBL->ZDL_NUMOE 
		
		cChave :=  QRYZBL->ZDL_FILIAL + QRYZBL->ZDL_NUMOE + QRYZBL->ZDL_CNPJ

		nValmerc := 0
		oOrdem 	 := nil
		oOrdem 	 := ordemEmbarque():new()

		oOrdem:NumeroOrdemEmbarque	:= QRYZBL->ZDL_NUMOE
		oOrdem:ChaveUID				:= FWUUID(QRYZBL->ZDL_NUMOE)
		oOrdem:Filial				:= QRYZBL->ZDL_FILIAL	

		oOrdem:ctes := {} 
		
		oCte := cte():new()

		oCte:CodigoIBGECidadeInicioPrestacao	:=  QRYZBL->ZDL_CIDINI
		oCte:CodigoIBGECidadeTerminoPrestacao 	:=	QRYZBL->ZDL_CIDDES
		oCte:DataPrevistaEntrega			  	:=	QRYZBL->ZDL_DATAPR
		oCte:ExibeICMSNaDACTE					:=	"true"
		oCte:IncluirICMSNoFrete					:=  "Sim"
		oCte:NumeroCarga						:=	val(QRYZBL->ZDL_NUMOE) 
		oCte:NumeroUnidade						:=	QRYZBL->ZDL_FILIAL//QRYZBL->M0_CODIGO
		oCte:PercentualICMSIncluirNoFrete		:=	"100"
		oCte:ProdutoPredominante				:=	"DIVERSOS"
		oCte:TipoCTe							:=	"Normal"
		oCte:TipoImpressao						:=	"Retrato"
		oCte:TipoPagamento						:=	"Pago"
		oCte:TipoServico						:=	"Normal"
		oCte:TipoTomador						:=	"Remetente"
		oCte:ValorTotalMercadoria				:=	QRYZBL->ZDL_VLRNF 
		//oCte:Destinatario 						:=	QRYZBL->ZDL_CNPJ  

		aadd( oOrdem:ctes, oCte )

		oOrdem:ctes[LEN(oOrdem:ctes)]:Documentos := Documento():new()

		//oOrdem:ctes[LEN(oOrdem:ctes)]:Documentos:documento				:= Documento():new()
		oOrdem:ctes[LEN(oOrdem:ctes)]:Documentos:DOCUMENTO := {}

		oDoc := subdoc():new()

		nQtd  := 0
		nPeso := 0

		while !QRYZBL->(EOF()) .AND. cChave == QRYZBL->ZDL_FILIAL + QRYZBL->ZDL_NUMOE + QRYZBL->ZDL_CNPJ
			
			nValmerc += QRYZBL->ZDL_VLRNF

			oDoc:CHAVENFE    := QRYZBL->ZDL_CHVNFE
			oDoc:DATAEMISSAO := QRYZBL->ZDL_DTEMIS
			oDoc:NUMERO		 := QRYZBL->ZDL_NUMNF
			oDoc:VALOR		 := QRYZBL->ZDL_VLRNF

			nQtd  += QRYZBL->ZDL_QTDE  
			nPeso += QRYZBL->ZDL_PESO

			cFil				:= QRYZBL->ZDL_FILIAL
			cBairro				:= QRYZBL->ZDL_REMBAI			
			cCep				:= QRYZBL->ZDL_CEPREM			
			cCPFCNPJ			:= QRYZBL->ZDL_CEPREM
			cCodigoIBGECidade	:= QRYZBL->ZDL_CIDINI
			cCodigoPais			:= QRYZBL->ZDL_CODPAI
			cComplemento		:= QRYZBL->ZDL_CPLEND
			cEndereco			:= QRYZBL->ZDL_ENDEMI


			aadd( oOrdem:ctes[LEN(oOrdem:ctes)]:Documentos:DOCUMENTO, oDoc )						

			If lDest
				///Destinatario
		
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario := Destinatari():new()

				
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Bairro			:= QRYZBL->ZDL_BAIRRO		
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Cep				:= QRYZBL->ZDL_CEP   
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:CPFCNPJ			:= QRYZBL->ZDL_CNPJ  
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Endereco			:= QRYZBL->ZDL_ENDENT
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:CodigoAtividade	:= QRYZBL->ZDL_CODATV
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:CodigoIBGECidade	:= QRYZBL->ZDL_CIDDES
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:CodigoPais		:= QRYZBL->ZDL_CODPAI
				If QRYZBL->ZDL_EXP = 'S'	
					oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Exportacao 	:= 'true'
				Else
					oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Exportacao 	:= 'false'		
				EndIf	   
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:NomeFantasia		:= QRYZBL->ZDL_NMFANT
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:Numero			:= ""//QRYZBL->
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:RGIE				:= QRYZBL->ZDL_IE    
				oOrdem:ctes[LEN(oOrdem:ctes)]:Destinatario:RazaoSocial		:= QRYZBL->ZDL_RAZAO 
				
				lDest := .F.
				
			EndIf
			
			QRYZBL->(DbSkip())	
		
		Enddo
		

		
		///QuantidadesCarga
		
		oOrdem:ctes[LEN(oOrdem:ctes)]:QuantidadesCarga := QuantidadeCarga():new()
		oOrdem:ctes[LEN(oOrdem:ctes)]:QuantidadesCarga:QuantidadeCarga := {}

		For nI := 1 to 2
			oDoc := nil
			oDoc := SubQuantidadeCarga():new()

			If nI = 1
				oDoc:Descricao		:= 'VOLUMES'
				oDoc:Quantidade		:= nQtd
				oDoc:UnidadeMedida	:= '03'
			Else
				oDoc:Descricao		:= 'PESOLIQUIDO'
				oDoc:Quantidade		:= nPeso
				oDoc:UnidadeMedida	:= '01'					
			EndIf

			aadd( oOrdem:ctes[LEN(oOrdem:ctes)]:QuantidadesCarga:QuantidadeCarga, oDoc )

		Next nI



		//// Verifica dados na tabela SYS_COMPANY (Remetente)

		oOrdem:ctes[LEN(oOrdem:ctes)]:Remetente := oDoc := Remetent():new()

		

		cAliasC := GetNextAlias()

		cQuery := " SELECT * FROM SYS_COMPANY "
		cQuery += "  WHERE M0_CODFIL = '" + cFil + "'"
		cQuery += "  AND SYS_COMPANY.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasC, .F., .T.)
		
		oDoc:Bairro				:= cBairro			
		oDoc:Cep				:= cCep			
		oDoc:CPFCNPJ			:= (cAliasC)->M0_CGC
		oDoc:CodigoAtividade	:= '2'
		oDoc:CodigoIBGECidade	:= cCodigoIBGECidade
		oDoc:CodigoPais			:= cCodigoPais
		oDoc:Complemento		:= cComplemento
		oDoc:Endereco			:= cEndereco
		oDoc:Exportacao			:= 'false'
		oDoc:NomeFantasia		:= (cAliasC)->M0_FILIAL
		oDoc:Numero				:= ""//"SN"
		oDoc:RGIE				:= (cAliasC)->M0_INSC
		oDoc:RazaoSocial		:= (cAliasC)->M0_NOMECOM

		//aadd( oOrdem:ctes[LEN(oOrdem:ctes)]:Remetente, oDoc )

		oWSCTE := nil
		oWSCTE := MGFINT23():new( cURLPost, oOrdem ,,,,,,,,,,,.T.,.T.)
		//oWSCTE := MGFINT23():new( cURLPost, oOrdem ,,,,,,,,,,,,)
		oWSCTE:sendByHttpPost()
		//cJson := FWJsonSerialize(oOrdem,.T., .T.)
		// Grava json
		
		If oWSCTE:LOK
		
			For nI := 1 to Len(OORDEM:CTES)
			
				For nJ := 1 to Len (OORDEM:CTES[nI]:DOCUMENTOS:DOCUMENTO)
				
				
					OORDEM:CTES[nI]:DOCUMENTOS:DOCUMENTO[nJ]:CHAVENFE
					
					DbSelectArea('ZDL')
					DbSetOrder(2)///Colocar a filial do objeto
					ZDL->(DbSeek(OORDEM:CTES[1]:NUMEROUNIDADE + OORDEM:CTES[nI]:DOCUMENTOS:DOCUMENTO[nJ]:CHAVENFE))
					//ZDL->(DbSeek(xFilial('ZDL')+ OORDEM:CTES[nI]:DOCUMENTOS:DOCUMENTO[nJ]:CHAVENFE))
				
					RecLock('ZDL',.F.)
						
					ZDL->ZDL_STATUS := '1'
					ZDL->ZDL_PROC := 'Processado com sucesso!'
					ZDL->(MsUnlock())
					
				Next 
			Next 
		EndIf
		
		memoWrite("C:\TEMP\CTE.JSON", oWSCTE:cJson)
	enddo
	RestArea(aAreaZDL)
	QRYZBL->(DBCloseArea())
return

//-------------------------------------------------------------------
// Seleciona Notas a serem enviadas
//-------------------------------------------------------------------
static function QWSC23()

	local cQryZBL := ""

	cQryZBL := "SELECT * "

	cQryZBL += " FROM "			+ retSQLName("ZDL") + " ZDL"						+ CRLF
	cQryZBL += " WHERE	ZDL.ZDL_STATUS	=	'2'"									+ CRLF
	cQryZBL += " 	AND	ZDL.ZDL_CHVNFE	<>	' ' "									+ CRLF
	cQryZBL += " 	AND	ZDL.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryZBL += " ORDER BY ZDL.ZDL_FILIAL, ZDL.ZDL_NUMOE, ZDL.ZDL_CNPJ" 				+ CRLF

	conout(cQryZBL)

	TcQuery changeQuery(cQryZBL) New Alias "QRYZBL"
return

// Retorna dados da Filial

static function QWSC23FIL()

Local cAliasC := ""
Local cQuery
Local cFil := QRYZBL->ZDL_FILIAL
		
	cAliasC := GetNextAlias()

	cQuery := " SELECT * FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CODFIL = '" + cFil + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_= ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasC, .F., .T.)
	
	If (cAliasC)->(!eof())
		
	EndIf	
Return


/*
Classe de Ordem de embarque
*/
class ordemEmbarque

data NumeroOrdemEmbarque		as string
data ChaveUID					as string
data Filial						as string
data CTES						as array  // ou array of object

method New() constructor constructor
//method setProduct()
return

/*
Construtor
*/
method New() class ordemEmbarque

return

/*
Classe de CTE
*/
class cte

data CodigoIBGECidadeInicioPrestacao	as string
data CodigoIBGECidadeTerminoPrestacao	as string
data DataPrevistaEntrega				as string
data ExibeICMSNaDACTE					as string
data IncluirICMSNoFrete					as string
data NumeroCarga						as string
data NumeroUnidade						as string
data PercentualICMSIncluirNoFrete		as string
data ProdutoPredominante				as string
data TipoCTe							as string
data TipoImpressao						as string
data TipoPagamento						as string
data TipoServico						as string
data TipoTomador						as string
data ValorTotalMercadoria				as string
data Destinatario 						as object //Destinatario // vinculo com a classe abaixo
data Documentos 						as object //of Documento  // vinculo com a classe abaixo
data QuantidadesCarga					as object  //of QuantidadeCarga
data Remetente							as string  //Remetente 

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class cte

return

/*
Destinatario
*/
class Destinatari

data Bairro				as string
data Cep				as string
data CPFCNPJ			as string
data Endereco			as string
data CodigoAtividade	as string
data CodigoIBGECidade	as string
data CodigoPais			as string
data Exportacao			as string
data NomeFantasia		as string
data Numero				as string
data RGIE				as string
data RazaoSocial		as string

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class Destinatari

return


///Documento

class Documento

	data documento		as array

method New() constructor
//method setProduct()

return


/*
Construtor
*/
method New() class Documento

return

///Documento

class QuantidadeCarga

	data QuantidadeCarga		as array

method New() constructor
//method setProduct()

return


/*
Construtor
*/
method New() class QuantidadeCarga

return


class subdoc

data CHAVENFE		as string
data DATAEMISSAO	as string
data NUMERO			as string
data VALOR			as string

method New() constructor
//method setProduct()

Return

method New() class subdoc

return

class SubQuantidadeCarga

data Descricao		as string
data Quantidade		as float
data UnidadeMedida	as string


method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class SubQuantidadeCarga

return

class Remetent

data Bairro				as string
data Cep				as string
data CPFCNPJ			as string
data CodigoAtividade	as string
data CodigoIBGECidade	as string
data CodigoPais			as string
data Complemento		as string
data Endereco			as string
data Exportacao			as string
data NomeFantasia		as string
data Numero				as string
data RGIE				as string
data RazaoSocial		as string

method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class Remetent

return


