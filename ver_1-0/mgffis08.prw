#include 'protheus.ch'
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MGFFIS08
Autor....:              Gustavo Ananias Afonso
Data.....:              09/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              
Obs......:              Manutencao dos Livros Fiscais
=====================================================================================
*/
User Function MGFFIS08()
	local aArea		:= getArea()
	local aAreaSF3	:= SF3->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("SF3")
	SF3->(DBGoTop())
	SF3->(DBSetOrder(4)) // 4 - F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

	if SF3->( DBSeek( xFilial("SF3") + SF2->(F2_CLIENTE + F2_LOJA + F2_DOC + F2_SERIE ) ) )
		//UPDATE/ exclusao precisa estar possicionado
		fwExecView("Alteracao", "MGFFIS08", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)//"Alteracao"
	else
		msgAlert("Livro Fiscal nao encontrado!")
	endif

	SF3->(DBCloseArea())

	restArea(aAreaSF3)
	restArea(aArea)
return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrSF3 	:= FWFormStruct(1,"SF3")
	local oStrSFT 	:= FWFormStruct(1,"SFT")

	oStrSF3:SetProperty( '*'			, MODEL_FIELD_WHEN		, {||.F.}) // USAR * PARA TODOS OS CAMPOS
	oStrSFT:SetProperty( '*'			, MODEL_FIELD_WHEN		, {||.F.})

	oStrSFT:SetProperty( 'FT_CLASFIS'	, MODEL_FIELD_WHEN		, {||.T.})
	oStrSFT:SetProperty( 'FT_POSIPI'	, MODEL_FIELD_WHEN		, {||.T.})
	oStrSFT:SetProperty( 'FT_CEST'		, MODEL_FIELD_WHEN		, {||.T.})
	oStrSFT:SetProperty( 'FT_CTIPI'		, MODEL_FIELD_WHEN		, {||.T.})

	oStrSF3:SetProperty( '*'			, MODEL_FIELD_OBRIGAT	, .F.) // Indica se o campo tem preenchimento obrigat�rio
	oStrSFT:SetProperty( '*'			, MODEL_FIELD_OBRIGAT	, .F.) // Indica se o campo tem preenchimento obrigat�rio

	oModel := MPFormModel():New("XMGFFIS08", /*bPreValidacao*/,/*bPosValidacao*/, { |oModel| cmtFIS08(oModel) }/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SF3MASTER",/*cOwner*/,oStrSF3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid("SFTDETAIL", "SF3MASTER",oStrSFT,/*bPreValidacao*/, /*bPosValidacao*/,/*bCarga*/)

	oModel:GetModel( 'SFTDETAIL' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'SFTDETAIL' ):SetNoDeleteLine( .T. )

	oModel:SetRelation( 'SFTDETAIL' , {	{'FT_FILIAL'	, 'xFilial( "SFT" )'},;
										{'FT_SERIE'		, 'F3_SERIE'		},;
										{'FT_NFISCAL'	, 'F3_NFISCAL'		},;
										{'FT_CLIEFOR'	, 'F3_CLIEFOR'		},;
										{'FT_LOJA'		, 'F3_LOJA'			}}, SFT->(IndexKey( 1 )))

	oModel:GetModel( 'SF3MASTER' ):SetDescription( 'Livros Fiscais' )
	oModel:GetModel( 'SFTDETAIL' ):SetDescription( 'Livros Fiscais por item da NF' )

	oModel:SetPrimaryKey( {} )
return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS08' )
	local bFieldSF3	:= {|cCampo| Alltrim(cCampo) $ "F3_FILIAL|F3_SERIE|F3_NFISCAL|F3_CLIEFOR|F3_LOJA"}
	local bFieldSFT	:= {|cCampo| Alltrim(cCampo) $ "FT_ITEM|FT_PRODUTO|FT_CLASFIS|FT_POSIPI|FT_CEST|FT_CTIPI"}
	local oStrSF3	:= FWFormStruct( 2, "SF3", bFieldSF3 )
	local oStrSFT	:= FWFormStruct( 2, "SFT", bFieldSFT )

	oStrSFT:SetProperty('FT_POSIPI',MVC_VIEW_LOOKUP,'SYD1')

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SF3', oStrSF3, 'SF3MASTER' )
	oView:AddGrid( 'VIEW_SFT', oStrSFT, 'SFTDETAIL' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
	oView:CreateHorizontalBox( 'INFERIOR', 80 )

	oView:SetOwnerView( 'VIEW_SF3', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SFT', 'INFERIOR' )

Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtFIS08(oModel)
	local nI			:= 0
	local lRetCommit	:= .T.
	local oMdlSF3		:= oModel:GetModel('SF3MASTER')
	local oMdlSFT		:= oModel:GetModel('SFTDETAIL')
	local cTime			:= time()
	local dDate			:= dDataBase
	local aArea			:= getArea()
	local aAreaSFT		:= SFT->(getArea())

	SFT->(DBSetOrder(1)) // FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO

	BEGIN TRANSACTION
		for nI := 1 to  oMdlSFT:GetQtdLine()
			oMdlSFT:GoLine( nI )

			//SFT->(dbGoTo(FwFldGet( 'FT_XRECNO' )))

			SFT->(DBGoTop())
			if SFT->(DBSeek(oMdlSFT:GetValue( 'FT_FILIAL' ) + oMdlSFT:GetValue( 'FT_TIPOMOV' ) + oMdlSFT:GetValue( 'FT_SERIE' ) + oMdlSFT:GetValue( 'FT_NFISCAL' ) + oMdlSF3:GetValue( 'F3_CLIEFOR' ) + oMdlSFT:GetValue( 'FT_LOJA' ) + oMdlSFT:GetValue( 'FT_ITEM' ) + oMdlSFT:GetValue( 'FT_PRODUTO' )))
				if FwFldGet( 'FT_CLASFIS' ) <> SFT->FT_CLASFIS
					//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)				
					updCD2(FwFldGet( 'FT_CLASFIS' ))
					
					if nTipoNF == 1
						U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SFT", SFT->(RECNO()), "FT_CLASFIS", SFT->FT_CLASFIS, oMdlSFT:getValue('FT_CLASFIS'), dDate, cTime, usrFullName(retCodUsr()))
					elseif nTipoNF == 2
						U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SFT", SFT->(RECNO()), "FT_CLASFIS", SFT->FT_CLASFIS, oMdlSFT:getValue('FT_CLASFIS'), dDate, cTime, usrFullName(retCodUsr()))
					endif
				endif
	
				if FwFldGet( 'FT_POSIPI' ) <> SFT->FT_POSIPI
					if nTipoNF == 1
						U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SFT", SFT->(RECNO()), "FT_POSIPI", SFT->FT_POSIPI, oMdlSFT:getValue('FT_POSIPI'), dDate, cTime, usrFullName(retCodUsr()))
					elseif nTipoNF == 2
						U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SFT", SFT->(RECNO()), "FT_POSIPI", SFT->FT_POSIPI, oMdlSFT:getValue('FT_POSIPI'), dDate, cTime, usrFullName(retCodUsr()))
					endif					
				endif
	
				if FwFldGet( 'FT_CEST' ) <> SFT->FT_CEST
					if nTipoNF == 1
						U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SFT", SFT->(RECNO()), "FT_CEST", SFT->FT_CEST, oMdlSFT:getValue('FT_CEST'), dDate, cTime, usrFullName(retCodUsr()))
					elseif nTipoNF == 2
						U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SFT", SFT->(RECNO()), "FT_CEST", SFT->FT_CEST, oMdlSFT:getValue('FT_CEST'), dDate, cTime, usrFullName(retCodUsr()))
					endif
				endif

				if FwFldGet( 'FT_CTIPI' ) <> SFT->FT_CTIPI
					if nTipoNF == 1
						U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SFT", SFT->(RECNO()), "FT_CTIPI", SFT->FT_CTIPI, oMdlSFT:getValue('FT_CTIPI'), dDate, cTime, usrFullName(retCodUsr()))
					elseif nTipoNF == 2
						U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SFT", SFT->(RECNO()), "FT_CTIPI", SFT->FT_CTIPI, oMdlSFT:getValue('FT_CTIPI'), dDate, cTime, usrFullName(retCodUsr()))
					endif
				endif
				
			endif
		next
		fwFormCommit(oModel)
	END TRANSACTION

	restArea(aAreaSFT)
	restArea(aArea)
return lRetCommit

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function updCD2(cFTClasFis)
	local cUpdCD2 := ""

	cUpdCD2 := "UPDATE " + retSQLName("CD2")	+ CRLF
	cUpdCD2 += " SET "	+ CRLF
	cUpdCD2 += "	CD2_ORIGEM	= '" + subStr(cFTClasFis, 1, 1) + "'," 	+ CRLF
	cUpdCD2 += "	CD2_CST		= '" + subStr(cFTClasFis, 2, 2) + "'"	+ CRLF
	cUpdCD2 += " WHERE"	+ CRLF
	cUpdCD2 += "		CD2_CODPRO	=	'" + SFT->FT_PRODUTO	+ "'"	+ CRLF
	cUpdCD2 += "	AND	CD2_ITEM	=	'" + SFT->FT_ITEM		+ "'"	+ CRLF

	if nTipoNF == 1
		cUpdCD2 += "	AND	CD2_LOJFOR	=	'" + SFT->FT_LOJA		+ "'"	+ CRLF
		cUpdCD2 += "	AND CD2_CODFOR	=	'" + SFT->FT_CLIEFOR	+ "'"	+ CRLF
	elseif nTipoNF == 2
		cUpdCD2 += "	AND	CD2_LOJCLI	=	'" + SFT->FT_LOJA		+ "'"	+ CRLF
		cUpdCD2 += "	AND CD2_CODCLI	=	'" + SFT->FT_CLIEFOR	+ "'"	+ CRLF
	endif

	cUpdCD2 += "	AND	CD2_DOC		=	'" + SFT->FT_NFISCAL	+ "'"	+ CRLF
	cUpdCD2 += "	AND CD2_SERIE	=	'" + SFT->FT_SERIE		+ "'"	+ CRLF
	cUpdCD2 += "	AND	CD2_TPMOV	=	'" + SFT->FT_TIPOMOV	+ "'"	+ CRLF
	cUpdCD2 += "	AND	CD2_FILIAL	=	'" + SFT->FT_FILIAL		+ "'"	+ CRLF
	cUpdCD2 += "	AND CD2_IMP		IN	('ICM','SOL')" + CRLF //Apenas ICMS/ICMS-ST
	cUpdCD2 += "	AND D_E_L_E_T_	<>	'*'"							+ CRLF

	// X2_UNICO:
	//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
	//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO

	tcSQLExec(cUpdCD2)
return
