#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DIRECTRY.CH"

#define CRLF chr(13) + chr(10)

/*/
{Protheus.doc} MGFWSS30
	WebService Protheus x Taura x ME.

	@description
		A integração tem como objetivo a Marfrig (Protheus) receber a Filial e o Codigo do Produto e
		retornar o ultimo valor de compra, a Categoria contabil, Código e descrição do grupo e Centro de Custo   

	@author Marcos Cesar Donizeti Vieira
	@since 26/11/2020

	@version P12.1.017
	@country Brasil
	@language Português

	

{Protheus.doc} MGFWSS30REC
	Estrutura dos Dados que sera recebida no WS
	
/*/
WSSTRUCT MGFWSS30REC
	WSDATA Filial		as String
	WSDATA CodProduto	as String
ENDWSSTRUCT



/*/
{Protheus.doc} MGFWSS30RET
	Estrutura dos Dados para retorno do WS

	@author Marcos Cesar Donizeti Vieira
	@since 26/11/2020
/*/
WSSTRUCT MGFWSS30RET
	WSDATA Status				as String
	WSDATA Msg					as String
	WSDATA CodProduto			as String	Optional
	WSDATA UltimoPreco			as Float	Optional
	WSDATA CategoriaContabil	as String	Optional
	WSDATA GrupoProduto			as String	Optional
	WSDATA DescricaoGrupo		as String	Optional
	WSDATA CCustoProduto		as String	Optional
	WSDATA Armazem				as String	Optional
ENDWSSTRUCT



/*/
{Protheus.doc} MGFWSS30
	Classe do WS contendo suas propriedades e metodos - Retorno NDF multiembarcador
	@type class

	@author Marcos Vieira
	@since 26/11/2020
/*/
WSSERVICE MGFWSS30 DESCRIPTION "Integracao Protheus x Taura x ME" NameSpace "http://totvs.com.br/MGFWSS30.apw"
	WSMETHOD WSS30RetUltPrc DESCRIPTION "Retorna ultimo preço"
	WSDATA MGFWSS30REC	as MGFWSS30REC
	WSDATA MGFWSS30RET	as MGFWSS30RET
ENDWSSERVICE



/*/
{Protheus.doc} WSS30RetUltPrc
	Integração com o portal do Fornecedor

	@author Marcos Vieira
	@since 26/11/2020
	@type WSMethod
/*/   
WSMETHOD WSS30RetUltPrc WSRECEIVE MGFWSS30REC WSSEND MGFWSS30RET WSSERVICE MGFWSS30

	Local _lRet := .T.
		
	::MGFWSS30RET := WSClassNew( "MGFWSS30RET" )
	::MGFWSS30RET := WSS30ULTP(::MGFWSS30REC:Filial, ::MGFWSS30REC:CodProduto)

Return _lRet



/*/{Protheus.doc} WSS30ULTP
    Retornar o preço do produto e campos cadastrais do Produto
    @type  Static Function 
    @author Marcos Vieira
    @since 26/22/2020
/*/
Static Function WSS30ULTP( _cFilial, _cCodProd )
	Local oUltPrc 	:= WSClassNew( "MGFWSS30RET" )  //Objeto de retorno do Ult.Preço e demais campos
	Local _cStatus	:= "200"
	Local _cMsg		:= "Consulta executada com sucesso."
	Local _nUltPrec	:= 0
	Local _cCatCont	:= "01"
	Local _cGrpProd	:= ""
	Local _cDescGrp	:= ""
	Local _cCCusto	:= ""
	Local _cArmazem	:= ""

	Private _cAliasSD1 := GetNextAlias()

	If Select(_cAliasSD1) > 0	//Encerra a area de trabalho, caso já esteja aberto.
		(_cAliasSD1)->(DbClosearea())
	Endif

	U_MFConout("Iniciando consulta de Utimo preço...")
	U_MFConout("Validando Filial informada: " +_cFilial)
	If !Empty(_cFilial)
		U_MFConout("Validando Produto informado: " +_cCodProd)
		If !Empty(_cCodProd)
			U_MFConout("Buscando Produto informado: " +_cCodProd)
			SB1->(dbSetorder(1))
			If SB1->(dbSeek(xFilial("SB1")+_cCodProd))
				U_MFConout("Filtrando ultimo preço de Produto informado: " +_cCodProd)
				BeginSql Alias _cAliasSD1 
					SELECT
						A.D1_VUNIT, A.D1_CC, A.D1_LOCAL
					FROM SD1010 A 
						JOIN 
							(    
								SELECT 
									MAX(R_E_C_N_O_) R_E_C_N_O_ , D1_FILIAL, D1_COD
								FROM 
									%Table:SD1% SD1 
								WHERE
									SD1.%NotDel% 
								GROUP BY D1_FILIAL, D1_COD
							)B 
						ON 
							A.D1_FILIAL = B.D1_FILIAL AND A.D1_COD = B.D1_COD AND A.R_E_C_N_O_ = B.R_E_C_N_O_
					WHERE
						A.D1_FILIAL = %Exp:_cFilial% AND A.D1_COD = %Exp:_cCodProd%	AND A.%NotDel%
				EndSql 
				U_MFConout("Query da consulta: "+GetLastQuery()[2])

				If (_cAliasSD1)->( !Eof() )
					_nUltPrec 	:= (_cAliasSD1)->D1_VUNIT 
					_cCCusto	:= (_cAliasSD1)->D1_CC
					_cArmazem	:= (_cAliasSD1)->D1_LOCAL
				Else
					_nUltPrec 	:= 0
					_cCCusto	:= SB1->B1_CC
					_cArmazem	:= SB1->B1_LOCPAD
				EndIf

				_cCatCont	:= "01"
				_cGrpProd	:= SB1->B1_GRUPO
				_cDescGrp	:= POSICIONE("SBM",1,XFILIAL("SBM")+_cGrpProd,"BM_DESC")

			Else
				_cStatus := "203"
				_cMsg    := "Produto não encontrado."
				U_MFConout("Produto informado não encontrado na base de dados..." +_cCodProd)
			EndIf
		Else
			_cStatus := "202"
			_cMsg    := "Codigo do Produto da consulta não informado."
			U_MFConout("Código de Produto não informado..." +_cCodProd)
		EndIf
	Else
		_cStatus := "201"
		_cMsg    := "Filial da consulta não informado."
		U_MFConout("Filial não informada..." +_cCodProd)
	EndIf

	oUltPrc 					:= WSClassNew( "MGFWSS30RET" )
	oUltPrc:Status				:= _cStatus
	oUltPrc:Msg					:= _cMsg
	oUltPrc:UltimoPreco			:= _nUltPrec
	oUltPrc:CategoriaContabil	:= _cCatCont
	oUltPrc:GrupoProduto		:= _cGrpProd
	oUltPrc:DescricaoGrupo		:= _cDescGrp
	oUltPrc:CCustoProduto		:= _cCCusto
	oUltPrc:Armazem				:= _cArmazem

	U_MFConout("Finalizando consulta de ultimo preço: "+_cStatus+" - "+_cMsg)

	(_cAliasSD1)->(DbClosearea())	//Encerrar a tabela temporária

Return oUltPrc