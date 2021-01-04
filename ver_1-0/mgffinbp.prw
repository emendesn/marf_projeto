#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'RWMAKE.CH'

# DEFINE CAMPOEXCL	'E1_OK|STATUS|RECNOSE1|EMAILCOB|A1ZREDE|CODGERENC|E1_VEND1'

/*/
==============================================================================================================================================================================
Descrição   : Tela para Envio de e-mail de Cobrança

@description
Seleciona titulos vencidos de acordo com criterio especifico.
Envia e-mail para Clientes e/ou Gerencia Comercial

@author     : Renato Junior
@since      : 02/06/2020
@type       : User Function

@table
ZGD -   CABECALHO GERENCIA COML X VENDEDORES
ZGE -	ITENS GERENCIA COML X VENDEDORES
SE1 -	TITULOS A RECEBER

@param

@return

@menu
Financeiro - Atualizações-Especificos MARFRIG

@history 
02/06/2020 - feature/RTASK0011151_Envio_auto_email_cobr_tit_atraso

/*/   

User Function MGFFINBP()
    Private cEmailDE   :=  ALLTRIM(UsrRetMail(RetCodUsr()))
    Private cPerg		:=  "MGFFINBP"

    If Empty(cEmailDE)	    // Usuario sem e-mail
        Alert("Usuário não possui e-mail no Cadastro de Usuários do Protheus. Por favor, procure a TI para atualização deste cadastro.")
    Else
        ValidPerg()
	    If Pergunte(cPerg,.T.)
		    MGFFINBP2(     MGFFINBP1() /* Monta a Tabela Temporária */    ) //Monta o Mark Browser
		Endif
    Endif
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBP1()
// Monta a Tabela Temporária

@author Renato Junior

@since 02/06/2020
@version 1.0
@return _aStrut
/*/
//-------------------------------------------------------------------

static function MGFFINBP1()
	local _aStruSE1 :=  {}
	local _aStrut   :=  {}
	local _aCampos  :=  {}
	local _ni       :=  0

	_aStruSE1	:= SE1->(DBSTRUCT())
	_aCampos    :=  {'E1_FILIAL', 'E1_PREFIXO', 'E1_NUM', 'E1_PARCELA', 'E1_TIPO', 'E1_NATUREZ', ;
	'E1_CLIENTE', 'E1_LOJA', 'E1_NOMCLI', 'E1_EMISSAO', 'E1_VENCREA', 'E1_VALOR', 'E1_SALDO', ;
	'E1_VEND1'}

	for _ni := 1 to len(_aStruSE1)
		if aScan(_aCampos, _aStruSE1[_ni][1]) > 0
			aadd(_aStrut, _aStruSE1[_ni])
		endif
	next _ni

	aadd(_aStrut, {'E1_OK'		,'C',02 ,0})
	aadd(_aStrut, {'STATUS'		,'C',60 ,0})
	aadd(_aStrut, {'RECNOSE1'	,'N',12 ,0})
	aadd(_aStrut, {'EMAILCOB'	,'C',80 ,0})
	aadd(_aStrut, {'CODGERENC'	,'C',06 ,0})
	aadd(_aStrut, {'A1ZREDE'	,'C',03 ,0})

Return _aStrut

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFGFE5202()
//Monta o Mark Browser

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
static function MGFFINBP2(strTab)
	local _aStruLib	    :=  strTab //Estrutura da tabela de Aprovação GW3
	local _cTmp		    :=  GetNextAlias()
	local _cAliasTmp
	local _aColumns	    :=  {}
	local _cInsert      :=  ''
	local _nx           :=  0
	local _ni           :=  0
	local _cFim         :=  CHR(13) + CHR(10)

	dbSelectarea("ZGD")
	Dbsetorder(1)

	//Instancio o objeto que vai criar a tabela temporária no BD para poder utilizar posteriormente
	oTmp := FWTemporaryTable():New( _cTmp )

//Defino os campos da tabela temporária
	oTmp:SetFields(_aStruLib)

//Criação da tabela temporária no BD
	oTmp:Create()

//Obtenho o nome "verdadeiro" da tabela no BD (criada como temporária)
	_cTable := oTmp:GetRealName()

	//Preparo o comando para alimentar a tabela temporária
	// Nao sera considerado Filial no SE1
	_cInsert += "INSERT INTO " + _cTable + _cFim
	_cInsert += "( " + _cFim
	_cInsert += "E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_CLIENTE, E1_LOJA, "
    _cInsert += "E1_NOMCLI, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_VEND1, "
    _cInsert += "STATUS, RECNOSE1, EMAILCOB, A1ZREDE, CODGERENC "
	_cInsert += ") " + _cFim

	_cInsert += "SELECT " + _cFim
	_cInsert += "E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_CLIENTE, E1_LOJA, " + _cFim
    _cInsert += "E1_NOMCLI, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_VEND1, " + _cFim

    _cInsert += "CASE WHEN ZGE_CODIGO IS NULL THEN 'Vendedor sem Gerência' ELSE ' ' END|| " + _cFim
    _cInsert += "CASE WHEN A1_XMAILCO = ' ' THEN ';Cliente sem e-mail de cobrança' ELSE ' ' END AS STATUS, " + _cFim

    _cInsert += "SE1.R_E_C_N_O_ RECNOSE1, " + _cFim
    _cInsert += "A1_XMAILCO EMAILCOB, A1_ZREDE A1ZREDE, " + _cFim
    _cInsert += "CASE WHEN ZGD_CODIGO IS NULL THEN ' ' ELSE ZGD_CODIGO END AS CODGERENC " + _cFim

    _cInsert += "FROM "+ RetSQLName("SE1") +" SE1 " + _cFim

    _cInsert += "JOIN "+ RetSQLName("SA1") +" SA1 " + _cFim
    _cInsert += "ON SA1.D_E_L_E_T_ = ' ' AND A1_FILIAL = '"+XFILIAL("SA1")+"' "
	_cInsert += "AND A1_COD||A1_LOJA = E1_CLIENTE||E1_LOJA AND A1_EST <> 'EX' " + _cFim
    _cInsert += "AND A1_ZREDE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + _cFim

    _cInsert += "LEFT JOIN "+ RetSQLName("ZGE") +" ZGE ON ZGE.D_E_L_E_T_ = ' ' AND ZGE_CODVEN = E1_VEND1 "
    _cInsert += "LEFT JOIN "+ RetSQLName("ZGD") +" ZGD ON ZGD.D_E_L_E_T_ = ' ' AND ZGD_CODIGO = ZGE_CODIGO AND ZGD_ATIVO = 'S' "

    _cInsert += "WHERE SE1.D_E_L_E_T_ = ' ' AND E1_TIPO = 'NF' AND E1_SALDO > 0 " + _cFim
	If Empty(MV_PAR09)
	    _cInsert += "AND E1_NATUREZ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + _cFim
	Else
	    _cInsert += "AND E1_NATUREZ IN ('" + STRTRAN(ALLTRIM(MV_PAR09),"/","','") + "') " + _cFim
	Endif
    _cInsert += "AND E1_CLIENTE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cFim
    _cInsert += "AND E1_VENCREA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' " + _cFim

    _cInsert += "ORDER BY E1_CLIENTE,E1_VENCREA "


	//Executo o comando para alimentar a tabela temporária
	//memowrite("c:\totvs\RVBJ_MGFFINBP2.TXT", _cInsert  )// remover
	_cInsert := strTran(_cInsert, _cFim, '')

	Processa({|| TcSQLExec(_cInsert)})

	For _nx := 1 To Len(_aStruLib)
		if !(_aStruLib[_nx][1] $ CAMPOEXCL)
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStruLib[_nx][1]+"}") )
			_aColumns[Len(_aColumns)]:SetTitle(RetTitle(_aStruLib[_nx][1]))
			_aColumns[Len(_aColumns)]:SetPicture(PesqPict("SE1",_aStruLib[_nx][1]))
			_aColumns[Len(_aColumns)]:SetSize(_aStruLib[_nx][3])
			_aColumns[Len(_aColumns)]:SetDecimal(_aStruLib[_nx][4])
		EndIf

		If	_aStruLib[_nx][1]	== "STATUS"
			aadd(_aColumns,FWBrwColumn():New())
			_aColumns[Len(_aColumns)]:SetData( &("{||"+_aStruLib[_nx][1]+"}") )
			_aColumns[Len(_aColumns)]:SetTitle("Status")
			_aColumns[Len(_aColumns)]:SetPicture("@!")
			_aColumns[Len(_aColumns)]:SetSize(_aStruLib[_nx][3])
			_aColumns[Len(_aColumns)]:SetDecimal(_aStruLib[_nx][4])
		endif

	Next _nx

	_cAliasTmp := oTmp:GetAlias()

	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetAlias( _cAliasTmp )
	oBrowse:SetDescription( 'Envio de E-mail de Cobrança para o Cliente' )
	oBrowse:SetTemporary(.T.)
	oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetFilterDefault( "" )
	oBrowse:DisableDetails()
	oBrowse:AddButton("Cliente", {|| MsgRun('Enviando E-mail','Processando',{|| MGFFINBP3("Cliente") }) },,,, .F., 2 )
	oBrowse:AddButton("Comercial", {|| MsgRun('Enviando E-mail','Processando',{|| MGFFINBP3("Comercial") }) },,,, .F., 2 )
	oBrowse:AddButton("Marcar Todos", {|| xMarkAll()},,,, .F., 2 )
	oBrowse:AddButton("Desmarc.Todos", {|| xMarkAll()},,,, .F., 2 )
	oBrowse:AddButton("Visu.Perguntas", {|| Pergunte(cPerg,,,.T.)},,,, .F., 2 )

	oBrowse:SetFieldMark("E1_OK")
	oBrowse:SetCustomMarkRec({||xMark()})

	oBrowse:SetAllMark({|| xMarkAll() })

	// Definição da legenda
	oBrowse:AddLegend( "EMPTY(STATUS)", "BR_VERDE"	, "E-mail OK" )
	oBrowse:AddLegend( "! EMPTY(STATUS) ", "BR_VERMELHO"	, "Sem E-mail" )

	oBrowse:SetColumns(_aColumns)
	oBrowse:Activate()
	oTmp:Delete()
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFINBP3()
Envia e-mail de cobrança de acordo com tipo selecionado
Grava erros no campo STATUS
@author Renato Junior

@since 03/06/2020
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
static function MGFFINBP3(cNomTipo)
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()
	local _aheader	:=	_acols	:=	{}
	Local cEmailCC	:= 	""
	Local cSTATUS	:=	cKeyLoop :=	cRetEnvio := cDtHora :=	""
	Local cCorpo	:=	""
	Local nHtmVlr	:=	nHtmSld	:=	0
	Local nB		:=	0

	If (cAlias)->(Eof())
		MSGALERT("SEM DADOS A ENVIAR !")
		Return
	Endif

	GetEmailCC(@cEmailCC)	// E-mail CC

	//If	cNomTipo	==	"Comercial"
	If ! ExisteSx6("MGF_FINBPA")
		CriarSX6("MGF_FINBPA", "Cc", "E-mail Gerencia Contas a Receber?"			, 'silvia.costa@marfrig.com.br ' )	
	EndIf
	cEmailCC += ChkExisCarat(";", cEmailCC)+SUPERGETMV("MGF_FINBPA",.F., 'silvia.costa@marfrig.com.br ' )
	//Endif

	// Colunas do Log
	_aheader := {"Filial","Prefixo","No. Título","Parcela","Tipo","Natureza","Cod Cliente", ;
	"Loja Cliente","Dt Emissao","Vencimento","Vlr. Titulo","Saldo","Dt.E-mail","Usuário",;
	"E-mail Cliente","Status"}

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If oBrowse:IsMark()

			cSTATUS	:=	""
			If	cNomTipo	==	"Comercial"	.AND.	Empty(CODGERENC)
				cSTATUS	+=	 'Vendedor sem Gerência'
			ElseIf	cNomTipo	==	"Cliente"	.AND.	Empty(EMAILCOB) 
				cSTATUS	+=	ChkExisCarat(";", cSTATUS)+'Cliente sem e-mail de cobrança'
			Endif

			Aadd( _acols, { E1_FILIAL, E1_PREFIXO, E1_NUM/*3*/, E1_PARCELA, E1_TIPO, E1_NATUREZ, ;
				E1_CLIENTE/*7*/, E1_LOJA/*8*/, E1_EMISSAO, E1_VENCREA/*10*/, E1_VALOR, E1_SALDO/*12*/, ;
				RECNOSE1 /*13*/, ;
				IIf(cNomTipo=="Comercial",CODGERENC,EMAILCOB) /*14*/, ;
				IIf(cNomTipo=="Comercial",EMAILCOB,"") /*15*/, ;
				cSTATUS/*16*/, A1ZREDE /*17*/ , E1_VALOR/*18*/, E1_VEND1/*19*/ })

		EndIf
		(cAlias)->(DbSkip())
	EndDo
	//
	RestArea(aRest)
	_acols := aSort(_acols,,, { |x,y| x[14] < y[14] })
	nA	:=	1
	WHILE nA <= Len(_acols)
		aPosica	:=	{}
		cCorpo:=	""
		cKeyLoop	:= _acols[nA][14]
		nHtmVlr	:=	nHtmSld	:=	0
		WHILE nA <= Len(_acols)	.and.	cKeyLoop	== _acols[nA][14]
			Aadd(aPosica, nA  )

			cCorpo	+=	" <tr style='mso-yfti-irow:1'>"
//			cCorpo	+=	" <td style='padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"

			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+_acols[nA][01]+"<o:p></o:p></span></p>"
			cCorpo	+=	" </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+POSICIONE("SA1",1,XFILIAL("SA1")+_acols[nA][07]+_acols[nA][08],"A1_NOME")+"<o:p></o:p></span></p>  </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+POSICIONE("SA3",1,XFILIAL("SA3")+_acols[nA][19],"A3_NOME")+"<o:p></o:p></span></p> </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+_acols[nA][17]+"<o:p></o:p></span></p> </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+DTOC(_acols[nA][10])+"<o:p></o:p></span></p>"
			cCorpo	+=	" </td>"

			cCorpo	+=	"   <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>"+_acols[nA][03]+"<o:p></o:p></span></p>"
			cCorpo	+=	" </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>R$ "+TRANSFORM(_acols[nA][18],"@e 9,999,999.99")+"<o:p></o:p></span></p>"
			cCorpo	+=	" </td>"

			cCorpo	+=	" <td style='text-align: center;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
			cCorpo	+=	" <p class=MsoNormal><span style='mso-fareast-language:EN-US'>R$ "+TRANSFORM(_acols[nA][12],"@e 9,999,999.99")+"<o:p></o:p></span></p>"
			cCorpo	+=	" </td>"

			cCorpo	+=	" </tr>"

			nHtmVlr	+=	_acols[nA][18]
			nHtmSld	+=	_acols[nA][12]

			++nA
		ENDDO

		cCorpo	+=	" <tr style='mso-yfti-irow:2;mso-yfti-lastrow:yes'>"
		cCorpo	+=	" <td colspan=5 style='padding:.75pt .75pt .75pt .75pt'></td>"
		cCorpo	+=	" <td style='background:#5B9BD5;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"

		cCorpo	+=	" <p class=MsoNormal><strong><span style='font-family:"
		cCorpo	+=	' "Calibri",sans-serif;'

		cCorpo	+=	" color:white;mso-fareast-language:EN-US'>Totais</span></strong><span"
		cCorpo	+=	" style='color:white;mso-fareast-language:EN-US'><o:p></o:p></span></p>"
		cCorpo	+=	" </td>"
		cCorpo	+=	" <td style='background:#5B9BD5;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
		cCorpo	+=	" <p class=MsoNormal><strong><span style='font-family:"
		cCorpo	+=	' "Calibri",sans-serif;'

		cCorpo	+=	" color:white;mso-fareast-language:EN-US'>R$ "+TRANSFORM(nHtmVlr,"@e 99,999,999.99")+"</span></strong><span"
		cCorpo	+=	" style='color:white;mso-fareast-language:EN-US'><o:p></o:p></span></p>"
		cCorpo	+=	" </td>"
		cCorpo	+=	" <td style='background:#5B9BD5;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
		cCorpo	+=	" <p class=MsoNormal><strong><span style='font-family:"
		cCorpo	+=	' "Calibri",sans-serif;'
		cCorpo	+=	" color:white;mso-fareast-language:EN-US'>R$ "+TRANSFORM(nHtmSld,"@e 99,999,999.99")+"</span></strong><span"
		cCorpo	+=	" style='color:white;mso-fareast-language:EN-US'><o:p></o:p></span></p>"
		cCorpo	+=	" </td>"
		cCorpo	+=	" </tr>"

		// Busca e-mail(s) da gerencia
		If	cNomTipo	==	"Comercial"
			cKeyLoop	:=	RetMails(cKeyLoop)
		Endif
	
		If Empty(cKeyLoop)
			cRetEnvio	:=	"E-mail nao enviado"
		Else
			cEmailCC += ChkExisCarat(";", cEmailCC) + cEmailDE 
			//      E-MAIL DE / E-MAIL PARA / E-MAIL CC
			If ( EnvMail({cEmailDE,cKeyLoop,cEmailCC}, cCorpo, cNomTipo) )
				cRetEnvio	:=	"Enviado com sucesso"
			Else
				cRetEnvio	:=	"Erro no envio do E-mail"
			Endif
		Endif

		// ATUALIZA SE1 E _acols
		For nB := 1 to Len(aPosica)
			SE1->(DBGOTO(_acols[aPosica[nB]][13]))
			If	cNomTipo	==	"Cliente"	.AND. cRetEnvio ==	"Enviado com sucesso"
				cDtHora	:=	cValtoChar(GravaData(dDataBase, .T., 5 )) + " " + LEFT(TIME(),5)
				SE1->(RecLock("SE1",.F.))
				SE1->E1_ZECDTHR		:=	cDtHora
				SE1->E1_ZECUSUA		:=	UsrFullName(RetCodUsr())
				SE1->E1_ZECEMAI		:=	cKeyLoop	//cEmailDE
				SE1->(MsUnLock())
			Endif
			/*/
			_acols[ aPosica[nB]][13]	:=	cDtHora
			_acols[ aPosica[nB]][14]	:=	cNmUsua
			If cNomTipo == "Cliente"
				_acols[ aPosica[nB]][15]	:=	cKeyLoop
			Endif
			/*/
			_acols[ aPosica[nB]][13]	:=	SE1->E1_ZECDTHR
			_acols[ aPosica[nB]][14]	:=	SE1->E1_ZECUSUA
			_acols[ aPosica[nB]][15]	:=	SE1->E1_ZECEMAI
			_acols[ aPosica[nB]][16]	+=	ChkExisCarat(";", _acols[ aPosica[nB]][16])+cRetEnvio

		Next
	ENDDO

	U_MGListBox( "Log de processamento - E-mail de cobrança "+cNomTipo , _aheader , _acols , .T. , 1 )

	(cAlias)->(DbGoTop())
	oBrowse:refresh(.F.)
	PROCESSMESSAGES()

Return Nil


/*/{Protheus.doc} RetMails()
Retorna os e-mails da gerencia comercial, concatenados com ";"
@author Renato Junior

@since 04/06/2020
@version 1.0
@return lRet
/*/
static function RetMails(cCodGGer)
Local cRetMails	:=	""

If	!Empty(cCodGGer)	.and.	ZGD->( Dbseek(Xfilial("ZGD")+cCodGGer))
	cRetMails	:=	ALLTRIM(ZGD->ZGD_EMAIL1)
	If ! Empty(ZGD->ZGD_EMAIL2)
		cRetMails	+=	ChkExisCarat(";", cRetMails) + ALLTRIM(ZGD->ZGD_EMAIL2)
	Endif
	If ! Empty(ZGD->ZGD_EMAIL3)
		cRetMails	+=	ChkExisCarat(";", cRetMails) + ALLTRIM(ZGD->ZGD_EMAIL3)
	Endif
Endif
Return( cRetMails)


/*/{Protheus.doc} xMark()
// Marca todas as opções com Zero de diferença

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
static function xMark()
	local cAlias    :=  oBrowse:Alias()
	local lRet      :=  .T.

	If (!oBrowse:IsMark())
		RecLock(cAlias,.F.)
		(cAlias)->E1_OK  := oBrowse:Mark()
		(cAlias)->(MsUnLock())
	Else
		RecLock(cAlias,.F.)
		(cAlias)->E1_OK  := ""
		(cAlias)->(MsUnLock())
	EndIf

Return lRet


/*/{Protheus.doc} xMarkAll()
// inverte a marcação de todos os itens

@author Cláudio Alves

@since 03/10/2019
@version 1.0
@return lRet
/*/
static function xMarkAll()
	local lRet      :=  .T.
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		RecLock(cAlias,.F.)
		If (!oBrowse:IsMark())
			(cAlias)->E1_OK  := oBrowse:Mark()
		Else
			(cAlias)->E1_OK  := ""
		EndIf
		(cAlias)->(MsUnLock())
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)
	oBrowse:refresh(.F.)
Return lRet


//-------------------------------------------------------
// Cria as perguntas da rotina
//-------------------------------------------------------
Static Function ValidPerg()

Local _sAlias       := Alias()
Local aPerguntas    := {}
Local aRegs         := {}
Local i,j
local nTamNatur     :=  TamSX3("E1_NATUREZ")[1]
local nTamClien     :=  TamSX3("E1_CLIENTE")[1]
local nTamZRede     :=  TamSX3("A1_ZREDE")[1]

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Natureza Inicial ?"      ,"","","mv_ch1" ,"C",nTamNatur,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SED","","","",""})
aAdd(aRegs,{cPerg,"02","Natureza Final ?"        ,"","","mv_ch2" ,"C",nTamNatur,0,0,"G","NaoVazio()","MV_PAR02","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SED","","","",""})
aAdd(aRegs,{cPerg,"03","Cliente Inicial ?"       ,"","","mv_ch3" ,"C",nTamClien,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","CLI","","","",""})
aAdd(aRegs,{cPerg,"04","Cliente Final ?"         ,"","","mv_ch4" ,"C",nTamClien,0,0,"G","NaoVazio()","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CLI","","","",""})
aAdd(aRegs,{cPerg,"05","Rede Inicial ?"          ,"","","mv_ch5" ,"C",nTamZRede,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SZQ","","","",""})
aAdd(aRegs,{cPerg,"06","Rede Final ?"            ,"","","mv_ch6" ,"C",nTamZRede,0,0,"G","NaoVazio()","MV_PAR06","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SZQ","","","",""})
aAdd(aRegs,{cPerg,"07","Dt. Venc/to Inicial ?"   ,"","","mv_ch7" ,"D",08       ,0,0,"G","NaoVazio() .and. MV_PAR07 <= MV_PAR08","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Dt. Venc/to Final ?"     ,"","","mv_ch8" ,"D",08       ,0,0,"G","u_VldDtX1(MV_PAR08)","MV_PAR08","","","","31/12/21","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Naturezas (com /) ?"     ,"","","mv_ch9" ,"C",60       ,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return()

//----------------------------------------------------------------------------
// Verifica se a Data Final é anterior ao dia anterior (vencido = ddatabase-1)
//----------------------------------------------------------------------------
User Function VldDtX1(dMVPAR)
If dMVPAR <= dDataBase-1
    Return .T.
Else
    Return .F.
Endif
Return Nil


//----------------------------------------------------------------------------
// Informa email adicional, se desejado
//----------------------------------------------------------------------------
Static Function GetEmailCC(cCodVolta)
Local cMsg, lOk := .F.
Local cCod := SPACE(60)

cMsg := "Deseja enviar os e-mails com copia para outra pessoa ? Digite o endereço :"

Define MSDialog oDlg Title "E-mail adicional" From 0, 0 To 130, 420 Of oMainWnd Pixel

@ 016,004 To 166,270 Label Pixel Of oDlg

@ 036,075 Say cMsg Size 136,200 Pixel Of oDlg
@ 050,072 MsGet cCod  Size 133,000 Valid (NaoVazio(cCod)) Pixel Of oDlg

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(ODlg,{||lRet := .T. , cCodVolta := ALLTRIM(cCod),  ODlg:End()},{||lRet := .F.  ,ODlg:End(),},,)

If ! lOk
    cCod := ""
EndIf

Return

//----------------------------------------------------------------------------
// Retorna caracter para contenar analisando a necessidade
//----------------------------------------------------------------------------
Static Function ChkExisCarat(cOqProcurar, cVariavel)
cOqProcurar	:=	Iif(!Empty(cVariavel),cOqProcurar,"")
Return( cOqProcurar)

//----------------------------------------------
// Envio de e-mail
// Exemplo de chamada : EnvMail({cEmailDE,cKeyLoop,cEmailCC}, cCorpo,"Cliente") )
//----------------------------------------------
Static Function EnvMail(aEmPara, cCorpo, cCliOuCom)

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := ""
	Local cPwdMail  := ""
	//Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := aEmPara[1]
	Local cPara		:= aEmPara[2]
	Local cCopia	:= aEmPara[3]
	Local cSubject	:=	""

	Local cErrMail

	cCtMail	:=	LEFT(cEmail, AT("@",cEmail)-1)

	If cCliOuCom	== "Comercial"
		cSubject	:=	"Títulos Vencidos da sua Carteira"
	Else
		cSubject	:=	"Título Vencido – Marfrig"
	Endif

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cPara
	oMessage:cCc                    := cCopia
	oMessage:cSubject               := cSubject
	oMessage:cBody                  := bodyMail(cCorpo, cCliOuCom)
	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return .T.

//----------------------------------------------
// Corpo do e-mail e inclusao da tabela
//----------------------------------------------
static function bodyMail(cCorpo, cCliOuCom)
	Local cHtml 	:= ""
	Local nI:=	0

 	cHtml += "<!DOCTYPE html>"
 	cHtml += "<html> "
 	cHtml += "<head> "
 	cHtml += "<style> "
 	cHtml += "table { "
 	cHtml += "font-family: arial, sans-serif; "
 	cHtml += "border-collapse: collapse; "
 	cHtml += "width: 100%; "
 	cHtml += "} "

 	cHtml += "td, th { "
 	cHtml += "border: 1px solid #dddddd; "
 	cHtml += "text-align: left; "
 	cHtml += "padding: 8px; "
 	cHtml += "} "

	cHtml += " </style> "
 	cHtml += "</head> "
	cHtml += "  </html> "

 	cHtml += "<HTML> "
 	cHtml += "<HEAD> "
  	cHtml += "<style> "
  	cHtml += "table, th, td {  "
    cHtml += "border: 0; "

	cHtml += " }  "
  	cHtml += "th, td { "
  	cHtml += "padding: 5px; "
  	cHtml += "text-align: left; "
 	cHtml += "} "
 	cHtml += "</style> "

If cCliOuCom	==	"Comercial"
	cHtml += "<p><span style='color:red'>Título(s) Vencido(s) entre: "+LEFT(DTOC(MV_PAR07),5)+" até "+LEFT(DTOC(MV_PAR08),5)+"<o:p></o:p></span></p>"
Else
	cHtml += "<p><span style='color:black'>Não acusamos o pagamento do(s) titulo(s) abaixo.<o:p></o:p></span></p>"
	cHtml += "<p><span style='color:black'>Solicitamos previsão de pagamento, ou comprovante de pagamento caso o mesmo já tenha sido liquidado.<o:p></o:p></span></p>"
	cHtml += "<p><span style='color:black'>O envio ao cartório é automático, após o 7º dia corrido da data de vencimento.<o:p></o:p></span></p>"
Endif

 	cHtml += "</head> "

	cHtml += " <body lang=PT-BR style='tab-interval:35.4pt'> "
	cHtml += "<div class=WordSection1> "

// dados da Tabela
	cHtml += "<table class=MsoNormalTable border=0 align=center cellpadding=0 style='mso-cellspacing:1.5pt;"
 	cHtml += "mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>"
 	cHtml += "<thead>"
  	cHtml += "<tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>"

	_aItCab	:=	{"Cod","Cliente","Vendedor","Rede","Vcto","Nº Título","Valor","Saldo Pendente"}
For nI :=	1	to Len (_aItCab)

   	cHtml += "<td style='background:#5B9BD5;padding:3.75pt 3.75pt 3.75pt 3.75pt'>"
   	cHtml += "<p class=MsoNormal align=center style='text-align:center'><span"
   	cHtml += "class=SpellE><b><span style='color:white;mso-fareast-language:EN-US'>"+_aItCab[nI]+"</span></b></span><b><span"
   	cHtml += "style='color:white;mso-fareast-language:EN-US'><o:p></o:p></span></b></p>"
   	cHtml += "</td>
Next

  	cHtml += "</tr> "
 	cHtml += "</thead> "

	cHtml += cCorpo

	cHtml += "</table> "

	cHtml += "<p class=MsoNormal><o:p>&nbsp;</o:p></p> "
	cHtml += "<p class=MsoNormal><o:p>&nbsp;</o:p></p> "
	cHtml += "</div> "
	cHtml += "</body> "

If cCliOuCom	==	"Cliente"
	cHtml += "<p><span style='color:red'>“Nossos boletos são anexados às NFs e o nosso e-mail possui a extensão @marfrig.com.br. Desta forma, eventual e-mail enviado em nosso nome, contendo qualquer outra extensão, NÃO DEVE <o:p></o:p></span></p> "
	cHtml += "<p><span style='color:red'>SER CONSIDERADO. A Marfrig não envia boleto por e-mail sem solicitação prévia. Caso recebe ligação ou e-mail solicitando substituição de boleto, favor entrar em contato com a cobrança da Marfrig”<o:p></o:p></span></p> "
Endif

	cHtml += " </html> "
	
	//memowrite("c:\totvs\RVBJ_MGFFINBP3.HTML", cHtml  )	// remover

Return cHtml
