#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"        
#include "APWEBEX.CH"
#include "APWEBSRV.CH"                                                                                                                   

/*                                    
=====================================================================================
Programa............: MGFTMS01
Autor...............: Geronimo Benedito Alves
Data................: 26/09/2018
Descricao / Objetivo: Integração Protheus-TMS, para envio de EXP
Doc. Origem.........: Integração Protheus-TMS, para envio de EXP
Solicitante.........: Cliente
Uso.................: Marfrig
Fontes do FAT14 são : MGFFAT10.prw e MGFFAT16.prw
Tabelas de bloqueio : SZJ-CADASTRO DE TIPO DE PEDIDO  SZT-Bloqueios    e  SZV-Bloqueios por Pedidos
=====================================================================================
*/            

/*/{Protheus.doc} TMSJASEX
//TODO Envia o EXP + ano + SUb e a ação informada ao TMS.  Antes do envio valida os dados atravéz do U_TMSVLEXP()
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param _cZB8_EXP, caracter, m-> ou SZ8->ZB8_EXP
@param _ZB8ANOEXP, caracter, m-> ou SZ8->ZB8_ANOEXP
@param _ZB8SUBEXP, caracter, m-> ou SZ8->ZB8_SUBEXP
@param _cZB8_MOTE, caracter, m-> ou SZ8->ZB8_MOTEXP
@param _ZB8TMSACA, caracter, m-> ou SZ8->ZB8_TMSACA
@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão) 
/*/

USER Function TMSJASEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _xZB8TMSACA, _lTela,_cFilTmsMs  ) 
Local aEmpFilial := { }								// {"01","010003"}
//DbSelectArea("ZB8")
ZB8->(dbSetOrder(3))
If ZB8->(dbSeek(xFilial("ZB8")+_cZB8_EXP + _ZB8ANOEXP + _ZB8SUBEXP) )
	aEmpFilial := { cEmpAnt , ZB8->ZB8_FILVEN }			// {"01","010003"}
	If _cFilTmsMs $ GETMV("MGF_TMSEXP")
		Processa({|| U_TMSJAWEX(_cZB8_EXP ,_ZB8ANOEXP ,_ZB8SUBEXP ,_cZB8_MOTE ,_xZB8TMSACA ,_lTela ,"01", _cFilTmsMs )},"Processando","Aguarde........Enviando EXP ao TMS MultiSoftWare.",.F.)
		//U_TMSJAWEX(_cZB8_EXP ,_ZB8ANOEXP ,_ZB8SUBEXP ,_cZB8_MOTE ,_xZB8TMSACA ,_lTela ,aEmpFilial, _cFilTmsMs )
	ELSE
		StartJob( "U_TMSJAWEX" ,GetEnvServer() ,.F. ,_cZB8_EXP ,_ZB8ANOEXP ,_ZB8SUBEXP ,_cZB8_MOTE ,_xZB8TMSACA ,_lTela ,aEmpFilial,_cFilTmsMs )		// o terceiro parametro como .F. ,  não aguarda o retorno da função do startjob
	ENDIF
	//U_TMSJAWPV(aParam, _xC5TMSACA, _lTela, nil )
Endif
cEmpAnt	:= cEmpAnt		// linha de comando sem função. criada somente para não dar o Warning indevido de variavel local nao utilizada.
Return()


/*/{Protheus.doc} TMSJAWEX
//TODO Envia o EXP + ano + SUb e a ação informada ao TMS.  Antes do envio valida os dados atravéz do U_TMSVLEXP()
@author Geronimo Benedito Alves
@since 27/09/18
@version 1
@type function
@param _cZB8_EXP, caracter, m-> ou SZ8->ZB8_EXP
@param _ZB8ANOEXP, caracter, m-> ou SZ8->ZB8_ANOEXP
@param _ZB8SUBEXP, caracter, m-> ou SZ8->ZB8_SUBEXP
@param _cZB8_MOTE, caracter, m-> ou SZ8->ZB8_MOTEXP
@param _ZB8TMSACA, caracter, m-> ou SZ8->ZB8_TMSACA
@param _lTela,     boolean,  Se .T. Abre uma tela para informar o pedido EXP, e a ação a ser enviada ao TMS (Inclusao, alteração ou exclusão) 
/*/
 
USER Function TMSJAWEX( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _xZB8TMSACA, _lTela, aEmpFilial,_cFilTmsMs  ) 

Local lRet		:= .F.
Local aArea		:= {}
Local cURLPost	:= ""
Local oItens	:= Nil
Local cChave	:= ""
Local nRet		:= 0
Local cQ		:= ""
Local cTamErro	:= 100
Local bTms		:= .F.   

inkey(.1)				// Pausa de 1/3 de segundo para que um processo somente comece, apos o anterior, inclusive nos logs
If Valtype( aEmpFilial ) == "A"
	RpcSetType(3)
	RpcSetEnv(aEmpFilial[1],aEmpFilial[2],,,"EEC")
Else
	aArea  := {ZB8->(GetArea()),ZB9->(GetArea()),GetArea()}		// Se não for JOB, Grava as areas, para no retorno não ficar deposiionado.
Endif
//wvn
If _cFilTmsMs $ GETMV("MGF_TMSEXP")
	IF ALTERA = .T.   // EXECUTA POR ALTERAÇÃO
		IF EMPTY(ZB8->ZB8_ZTMSID )
			RETURN
		ENDIF
		_xZB8TMSACA := 'A'	
	ENDIF
	U_MGFEEC81( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _xZB8TMSACA, _lTela, aEmpFilial, _cFilTmsMs  ) 
	Return(lRet)
ENDIF

cURLPost := GetMv("MGF_TMSURL")		//http://spdwvapl203:8050/api/exp    exp   //http://spdwvapl203:8050/api/pedido  pedidos 		//http://SPDWVAPL203:8081/Tms-Transwide-pedido-venda

Private _ZB8TMSACA := _xZB8TMSACA		// Transformo o escopo da variavel de local para private 
Private oPEXP    := Nil
Private oWSPEXP  := Nil

ZB9->(dbSetOrder(2))
DbSelectArea("ZB8")
ZB8->(dbSetOrder(3))
If ZB8->(dbSeek(xFilial("ZB8")+_cZB8_EXP + _ZB8ANOEXP + _ZB8SUBEXP) )

	If Empty(ZB8->ZB8_ZCODES) .OR. GetAdvFVal("ZBM","ZBM_TMS",xFilial("ZBM")+ZB8->ZB8_ZCODES,1,"") <> "S"
		aEval(aArea,{|x| RestArea(x)})
		Return(lRet)
	Endif

	cChave := ZB8->ZB8_FILIAL + _cZB8_EXP + _ZB8ANOEXP + _ZB8SUBEXP			// If IsInCallStack("U_MGFFAT64")
	
	conOut("***********************************************************************************************************"+ CRLF)
	conOut('Inicio do  - integração de EXP no TMS Transwide. - Status/EXP = ' +_ZB8TMSACA + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP + " - " + DTOC(dDATABASE) + " - " + TIME() + CRLF)
	conOut("***********************************************************************************************************"+ CRLF) 

	oPEXP := Nil
	oPEXP := GrvEXP():New()
	oPEXP:GrvEXPCa()
	// substituiu a query, pois na tabela ZB8/ZB9, o registro não pode estar deletado. Apenas cancelado
	IF _ZB8TMSACA <> "C"		// Se for C=Cancelamento, não envio os itens do PV
		If ZB9->(dbSeek(xFilial("ZB9")+_cZB8_EXP + _ZB8ANOEXP + _ZB8SUBEXP))
			While ZB9->(!Eof()) .and. xFilial("ZB9")+_cZB8_EXP + _ZB8ANOEXP + _ZB8SUBEXP == ZB9->ZB9_FILIAL +ZB9->ZB9_EXP +ZB9->ZB9_ANOEXP + ZB9->ZB9_SUBEXP 
				oItens := Nil
				oItens := ItensEXP():New()
				oPEXP:GrvEXPItens(oItens)				//oPEXP:GravarPVItens(oItens)
				ZB9->(dbSkip())
			Enddo
		Endif		
	Endif		
	
	oWSPEXP := MGFINT53():New(cURLPost,oPEXP/*oObjToJson*/,ZZ8->(Recno())/*nKeyRecord*/,/*"ZZ8"/*cTblUpd*/,/*"C5_ZTMSFLA"/*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01"))/*cCodint*/,AllTrim(GetMv("MGF_MONT08")),cChave/*cChave*/,.F./*lDeserialize*/,.F.,.F.)
	StaticCall(MGFTAC01,ForcaIsBlind,oWSPEXP)
	
	If oWSPEXP:lOk

		IF oWSPEXP:nStatus == 1 
			cQ := "UPDATE "+ RetSqlName("ZB8")+" "
			cQ += "SET  ZB8_TMSACA = '" + _ZB8TMSACA + "', " 
			cQ += "     ZB8_TMSERR   = ' '  "
			cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))
		ElseIF oWSPEXP:nStatus == 2
			If bTms
			   	cQ := "UPDATE "+ RetSqlName("SC5")+" "
				cQ += "SET  ZB8_TMSERR   = '"+SUBSTR(oWSPEXP:cDetailInt,1,cTamErro)+"'  "
				cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))
			Endif	
		EndIF
	Else
		IF oWSPEXP:lErro500
			//IF ZB8->ZB8_ZTMSREE $ "S N"
			//    cQuant := '1'
			//ElseIF ZB8->ZB8_ZTMSREE $ '123456789'
			//    cQuant := SOMA1(ZB8->ZB8_ZTMSREE)
			//Else             
			//	cQuant := '1'
			//EndIF
			
			cQ := "UPDATE "+ RetSqlName("ZB8")+" "
			cQ += "SET  ZB8_TMSERR   = 'ERRO NA TRANSMISSAO - lErro500'  "
			cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))

		EndIF
	Endif
		
	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação dos campos da EXP, após o processo de envio ao Tms-Transwide.")
	EndIf
    
	//MemoWrite( GetTempPath(.T.) + "AAABBB_" + FunName()+"_"+cChave+"_Result_"+StrTran(Time(),":","")+".txt", oWSPEXP:CDETAILINT )
	
Endif
conOut("************************************************************************************************************"+ CRLF)
conOut('Final do MGFTMS01 - integração de EXP no TMS Transwide. - Status/EXP = ' +_ZB8TMSACA + _cZB8_EXP+_ZB8ANOEXP+_ZB8SUBEXP + " - " + DTOC(dDATABASE) + " - " + TIME() + CRLF)
conOut("************************************************* **********************************************************"+ CRLF)
aEval(aArea,{|x| RestArea(x)})

If Valtype( aEmpFilial ) == "A"
	RpcClearEnv()	
Endif

Return(lRet)

Class GrvEXP

	Data numeroEXP				as String	
	Data action					as String
	Data codigoimportador		as String
	Data nomeimportador			as String
	Data endimportador	   		as String
	Data municipioimportador	as String
	Data cepimportador			as String
	Data estadoimportador		as String
	Data paisimportador			as String
	Data dataembarqueplanta		as String
	Data dataembarqueporto		as String
	Data datadeadline			as String
	Data dataemissao			as String
	Data siglaportoembarque  	as String
	Data nome_portoembarque		as String
	Data cidadeportoembarque	as String
	Data estadoportoembarque	as String
	Data paisportoembarque		as String
	Data siglaportodestino  	as String
	Data nomeportodestino  		as String
	Data cidadeportodestino		as String
	Data estadoportodestino		as String
	Data paisportodestino		as String
	Data Cnpjestufagem			as String
	Data Nomeestufagem			as String
	Data enderecoestufagem		as String
	Data municipioestufagem		as String
	Data cepestufagem			as String
	Data UFestufagem			as String
	Data paisestufagem			as String 
	Data codigotipopedido		as String
	//Data Observacaoimportador	as String
	Data observacaoEXP			as String	
	Data statusEXP				as String	
	Data numerobooking			as String	
	Data nomearmador			as String	
	Data viatransp				as String
	Data nometpprod				as String 	
	Data Codigofilial			as String
	Data pesoliquidototal		as Float
	Data unidademedidatotal		as String
	Data ApplicationArea		as ApplicationArea

	Data Itens					as Array

	Method New()
	Method GrvEXPCa()
	Method GrvEXPItens()

//Return
EndClass


Method New() Class GrvEXP
	::ApplicationArea := ApplicationArea():New()
Return


Method GrvEXPCa() Class GrvEXP

Local cStringTime	:= "T00:00:00"
Local cCliente		:= ""
Local cLoja			:= ""
Local _cNome_Imp	:= ""
Local _cEnderImp	:= ""
Local _cMunicImp	:= ""
Local _cepImp		:= ""
Local _cEstadImp	:= ""
Local _cPais_Imp	:= ""

Local _cCnpjestu	:= ""
Local _cNomeestu	:= ""
Local _cendeestu	:= ""
Local _cmuniestu	:= ""
Local _ccepestuf	:= ""
Local _cEstaestu	:= ""
Local _cPaisestu	:= ""

SY5->(DbSetOrder(1))
SY9->(DbSetOrder(2))
SZ9->(dbSetOrder(1))
SA1->(dbSetOrder(1))
ZBM->(DbSetOrder(1))

If ZBM->(dbSeek(xFilial("ZBM")+ZB8->ZB8_ZCODES ))		// Codigo do local de estufagem
	If SA1->(dbSeek(xFilial("SA1")+ZBM->ZBM_CODCLI +ZBM->ZBM_LOJCLI ))
		_cCnpjestu	:= SA1->A1_CGC
		_cNomeestu	:= ZBM->ZBM_DESCRI
		_cendeestu	:= SA1->A1_END
		_cmuniestu	:= SA1->A1_MUN
		_ccepestuf	:= SA1->A1_CEP
		_cEstaestu	:= SA1->A1_EST
		//_cPaisestu	:= GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+SA1->A1_PAIS,1,"")
		_cPaisestu	:= GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SA1->A1_PAIS,1,"")
	Endif
Endif

If SA1->(dbSeek(xFilial("SA1") +ZB8->ZB8_IMPORT +ZB8->ZB8_IMLOJA))
	If !Empty(SA1->A1_ZCODMGF) // campo que conterah o codigo do cliente no sistema da Marfrig. ***verificar o nome que este campo serah criado
		cCliente := SA1->A1_ZCODMGF
	Else
		cCliente := SA1->A1_COD
		cLoja := SA1->A1_LOJA
	Endif
	
	_cNome_Imp	:= SA1->A1_NREDUZ
	_cEnderImp	:= IF(Empty(SA1->A1_ENDENT), SA1->A1_END, SA1->A1_ENDENT )
	_cMunicImp	:= IF(Empty(SA1->A1_MUNE),   SA1->A1_MUN, SA1->A1_MUNE   )
	_cepImp		:= IF(Empty(SA1->A1_CEPE),   SA1->A1_CEP, SA1->A1_CEPE )
	_cEstadImp	:= IF(Empty(SA1->A1_ESTE),   SA1->A1_EST, SA1->A1_ESTE )
	_cEstadImp	:= IF(_cEstadImp == "EX" ,"  " ,_cEstadImp )
	_cPais_Imp	:= GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SA1->A1_PAIS,1,"")
	_cPaisImpD	:= GetAdvFVal("SYA","YA_DESCR" ,xFilial("SYA")+SA1->A1_PAIS,1,"")

Endif

::numeroEXP				:= Alltrim( Subs(ZB8->ZB8_EXP,4)+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP ) 		//Pego no ZB8_EXP somente a partir da 4ª posicao para desprezar o lable "EXP", POIS O CAMPO NO tms É NUMERICO
::action				:= Alltrim( U_TMSAcao( _ZB8TMSACA ) ) 
::codigoimportador		:= Alltrim( cCliente     )
::nomeimportador		:= Alltrim( _cNome_Imp   )
::endimportador	   		:= Alltrim( _cEnderImp   )
::municipioimportador	:= Alltrim( _cMunicImp   )
::cepimportador			:= Alltrim( _cepImp      )
::estadoimportador		:= Alltrim( _cEstadImp   )
::paisimportador		:= Alltrim( _cPais_Imp   )

::dataembarqueplanta	:= Alltrim( IIf(!Empty(ZB8->ZB8_ZDTEST),Subs(dTos(ZB8->ZB8_ZDTEST),1,4)+"-"+Subs(dTos(ZB8->ZB8_ZDTEST),5,2)+"-"+Subs(dTos(ZB8->ZB8_ZDTEST),7,2)+cStringTime,"") ) 

_ZB8ZDELDR	:= If( Empty(ZB8->ZB8_ZDELDR) , Ctod("31/12/2050"), ZB8->ZB8_ZDELDR )
::dataembarqueporto		:= Alltrim( IIf(!Empty(_ZB8ZDELDR),Subs(dTos(_ZB8ZDELDR),1,4)+"-"+Subs(dTos(_ZB8ZDELDR),5,2)+"-"+Subs(dTos(_ZB8ZDELDR),7,2)+cStringTime,"") ) 

_ZB8ZDTDEC	:= If( Empty(ZB8->ZB8_ZDTDEC) , Ctod("31/12/2050"), ZB8->ZB8_ZDTDEC )
::datadeadline			:= Alltrim( IIf(!Empty(_ZB8ZDTDEC),Subs(dTos(_ZB8ZDTDEC),1,4)+"-"+Subs(dTos(_ZB8ZDTDEC),5,2)+"-"+Subs(dTos(_ZB8ZDTDEC),7,2)+cStringTime,"") ) 

::dataemissao			:= Alltrim( IIf(!Empty(ZB8->ZB8_DTPROC),Subs(dTos(ZB8->ZB8_DTPROC),1,4)+"-"+Subs(dTos(ZB8->ZB8_DTPROC),5,2)+"-"+Subs(dTos(ZB8->ZB8_DTPROC),7,2)+cStringTime,"") ) 

SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_ORIGEM))
::siglaportoembarque  	:= Alltrim( SY9->Y9_SIGLA) 
::nome_portoembarque	:= Alltrim( SY9->Y9_DESCR)
::cidadeportoembarque	:= Alltrim( SY9->Y9_CIDADE)
::estadoportoembarque	:= Alltrim( SY9->Y9_ESTADO)
::paisportoembarque		:= Alltrim( GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SY9->Y9_PAIS,1,"") )


SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_DEST))
_cSiglPDes				:= Alltrim( SY9->Y9_SIGLA)
_cNomePDes				:= Alltrim( SY9->Y9_DESCR)
::siglaportodestino  	:= _cSiglPDes 
::nomeportodestino  	:= _cNomePDes
::cidadeportodestino	:= Alltrim( SY9->Y9_CIDADE)
::estadoportodestino	:= Alltrim( SY9->Y9_ESTADO)
::paisportodestino		:= Alltrim( GetAdvFVal("SYA","YA_ZSIGLA",xFilial("SYA")+SY9->Y9_PAIS,1,"") )
::Cnpjestufagem			:= Alltrim( _cCnpjestu   ) 
::Nomeestufagem			:= Alltrim( _cNomeestu   ) 
::enderecoestufagem		:= Alltrim( _cendeestu   ) 
::municipioestufagem	:= Alltrim( _cmuniestu   ) 
::cepestufagem			:= Alltrim( _ccepestuf   )
::UFestufagem			:= Alltrim( _cEstaestu   ) 
::paisestufagem			:= Alltrim( _cPaisestu   ) 
::codigotipopedido		:= Alltrim( GetAdvFVal("SZJ","ZJ_NOME",xFilial("SZJ")+ZB8->ZB8_ZTIPPE,1,"") ) 
//::observacaoEXP			:= Alltrim( StrTran(StrTran(Noacento(Subs(ZB8->ZB8_ZOBSND,1,4000)), ">",""), "<","" ) ) 	// Para evitar erros, retiro os caracteres especiais e os "<" e ">"
//::Observacaoimportador 	:= _cNome_Imp +" - "+ _cEnderImp +" - "+ _cMunicImp +" - "+ _cepImp +" - "+ _cEstadImp  +" - "+ _cPais_Imp  +" - "+ _cSiglPDes +" - "+ _cNomePDes 
::observacaoEXP			:= _cNome_Imp +" - "+ _cEnderImp +" - "+ _cMunicImp +" - "+ _cepImp +" - "+ _cEstadImp  +" - "+ _cPais_Imp  +" - "+ _cSiglPDes +" - "+ _cNomePDes 
::statusEXP				:= Alltrim( U_TMSStatu(ZB8->ZB8_MOTEXP) ) 	
::numerobooking			:= Alltrim( ZB8->ZB8_ZNUMRE) 
::nomearmador			:= Alltrim( GETADVFVAL("SY5","Y5_NOME",xFilial("SY5")+ZB8->ZB8_ZARMAD,1,"") )  
::viatransp				:= Alltrim( ZB8->ZB8_VIA ) 
::nometpprod			:= Alltrim( GetAdvFVal("SYC","YC_NOME",xFilial("SYC")+ZB8->ZB8_IDIOMA+ZB8->ZB8_ZTPROD,4,"") ) 
::Codigofilial			:= ZB8->ZB8_FILIAL
::pesoliquidototal		:= PesoLiqPed(ZB8->ZB8_FILIAL, ZB8->ZB8_EXP +ZB8->ZB8_ANOEXP + ZB8->ZB8_SUBEXP)
::unidademedidatotal    := "KG" 

If ZB8->ZB8_VIA = "03"		// Se a via de trasporte for 03=Terrestre, (provavelmente chile) modifico alguns campos.

			//									// SY9->(DbSeek(xFilial("SY9")+ ZB8->ZB8_ORIGEM))
	::siglaportoembarque  	:= _cSiglPDes		// Alltrim( SY9->Y9_SIGLA) 
	::nome_portoembarque	:= _cNomePDes		// Alltrim( SY9->Y9_DESCR)
	::cidadeportoembarque	:= _cMunicImp
	::estadoportoembarque	:= _cEstadImp
	::paisportoembarque		:= _cPaisImpD

	::observacaoEXP		:= _cNome_Imp +" - "+ _cEnderImp +" - "+ _cMunicImp +" - "+ _cepImp +" - "+ _cEstadImp  +" - "+ _cPais_Imp 
Endif

::Itens	:= {}

Return()


Class ItensEXP

	Data seqproduto				as String
	Data codigoproduto			as String
	Data descricaoproduto		as String	
	Data qtdeproduto			as Float	
	Data unidademedida			as String	
	Data precounitarioproduto	as Float	
	
	Method New()

Return


Method New() Class ItensEXP                                          
Local cStringTime := "T00:00:00"
::seqproduto			:= ZB9->ZB9_SEQUEN 
::codigoproduto			:= Alltrim(ZB9->ZB9_COD_I)
::descricaoproduto		:= Alltrim(ZB9->ZB9_DESC)
::qtdeproduto			:= ZB9->ZB9_SLDINI
::unidademedida			:= ZB9->ZB9_UNIDAD
::precounitarioproduto	:= ZB9->ZB9_PRECO

Return()


Method GrvEXPItens(oItens) Class GrvEXP
	aAdd(::Itens,oItens)
Return()


/*/{Protheus.doc} TMSStatu
//TODO Recebe o motivo da EXP, e retorna o status da EXP.  Se for 3=Cancelada
@author Geronimo Benedito Alves
@since 01/10/18
@version 1
@type function
@param _ZB8MOTEXP, caracter.  Motivo da EXP
/*/

USER Function TMSStatu( _ZB8MOTEXP )
Local _cRet := ""

If ZB8->ZB8_MOTEXP = '1'
	_cRet := 'Aguardando Distribuição'
ElseIf ZB8->ZB8_MOTEXP = '5'
	_cRet := 'EXP Parcialmente Distribuida'
ElseIf ZB8->ZB8_MOTEXP = '6'
	_cRet := 'EXP Distribuida'
ElseIf ZB8->ZB8_MOTEXP = '4'
	_cRet := 'Pedido Exportação Parcialmente Gerado'
ElseIf ZB8->ZB8_MOTEXP = '2'
	_cRet := 'Pedido Exportação Gerado'
ElseIf ZB8->ZB8_MOTEXP = '3'
	_cRet := 'EXP Cancelada'
ElseIf ZB8->ZB8_MOTEXP = '7'
	_cRet := 'Pedido de Venda Gerado'
Endif
Return _cRet


/*/{Protheus.doc} TMSAcao
//TODO   Retorna a descrição da acao, de acordo com o parametro recebido.
@author Geronimo Benedito Alves
@since 01/10/18
@version 1
@type function
@param _c_ACAO, caracter.  Ação da EXP à ser enviada. "CANCEL ,CREATE ,UPDADTE"
/*/
 
User Function TMSAcao( _c_ACAO )
Local _cRet	:= ""

If _c_ACAO == "C"		// EXP Cancelada
	_cRet	:= "CANCEL"

ElseIf _c_ACAO == "I"
	_cRet	:= "CREATE"

ElseIf _c_ACAO == "A"
	_cRet	:= "UPDATE"
Endif 

Return _cRet


/*/{Protheus.doc} PesoLiqPed
// Retorna o peso liquido da EXP
@author Geronimo Benedito Alves
@since 16/10/18
@version 1
@type function
@param _cChave,   caracter,    //SC5->C5_FILIAL + SC5->C5_NUM
/*/
Static Function PesoLiqPed(_ZB9FILIAL, _cChave_EXP )		//ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP
Local aArea		:= {GetArea()}
Local cAliasTrb := GetNextAlias()

_nRet	:= 0

_cQuery := " SELECT ZB9_PSLQTO PESO_ITEM, ZB9.D_E_L_E_T_ ZB9_D_E_L_E_T_  "
_cQuery += " FROM "       + RetSqlName("ZB9") + " ZB9 "
_cQuery += " WHERE  ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP = '"+ xFilial("ZB9") + _cChave_EXP + "' "
_cQuery += " AND ZB9.D_E_L_E_T_ <> '*'   "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
(cAliasTrb)->(dbGoTop())
While (cAliasTrb)->(!Eof())
	_nRet += (cAliasTrb)->PESO_ITEM
	(cAliasTrb)->(dbSkip())
Enddo
(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})
Return _nRet

