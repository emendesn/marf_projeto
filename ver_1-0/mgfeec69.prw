#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFEEC69

Seleção de EXPs para lançamento de despesas

@type function
@author TOTVS
@since JUNHO/2019
@version P12
/*/
user function MGFEEC69()
	local aAreaX	:= getArea()
	local aAreaEEC	:= EEC->( getArea() )
	local aRet		:= {}
	local aParambox	:= {}
	Local cCODFILIA	:= ''
	Local cFiltro   := ''
	Local _aSelFil  := {}

	private nParamOpc	:= 0
	private oBrowse
	Private aMark       := {}

    EYG->( DBSetOrder(1) )
    ZB8->(dbSetOrder(3))
	DBSelectArea( "EEC" )
	EEC->( DBSetOrder(1) )

	oBrowse := FWMarkBrowse():New()
	oBrowse:setAlias('EEC')

	oBrowse:setCacheView(.F.)
	oBrowse:disableDetails()

	oBrowse:setDescription("Lançamento de Despesas - Exportação")

	oBrowse:setFieldMark( "EEC_ZOK" )
	oBrowse:setCustomMarkRec( { || xMark() } )
	oBrowse:SetAllMark( { || .F. } )

	//oBrowse:setUseFilter( .T. )

	AAdd( aParambox,{ 3 , "Tipo de Lançamento" , 1 , { "Armadores" , "Terminais","Despachantes" } , 070 , "" , .T. } )
	AAdd( aParamBox,{1, "Filial"       	,Space(tamSx3("A1_FILIAL")[1])        , "@!",                           ,"XM0" ,, 070	, .F.	})
	AAdd( aParambox,{1,"Número do EXP Inicial"		,Space(tamSx3("EEC_ZEXP  ")[1])	,""		,""	,"EECEXP"	,"",050,.F.})
	AAdd( aParambox,{1,"Número do EXP Final"		,Space(tamSx3("EEC_ZEXP  ")[1])	,""		,""	,"EECEXP"	,"",050,.F.})
	AAdd( aParambox,{1,"Data Processo Inicial"	,Ctod("")						,""		    ,"" ,""		,"",050,.F.})
	AAdd( aParambox,{1,"Data Processo Final"	,Ctod("")						,""		    ,""	,""		,"",050,.F.})
	AAdd( aParambox,{1,"Data Embarque Inicial"	,Ctod("")						,""		    ,"" ,""		,"",050,.F.})
	AAdd( aParambox,{1,"Data Embarque Final"	,Ctod("")						,""		    ,""	,""		,"",050,.F.})
	If paramBox(aParambox, "Tipo de Lançamento"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	
	
		nParamOpc := MV_PAR01
		cFiltro   +='  1 = 1 '
		cFiltro   += IIF(!Empty(MV_PAR02)," .AND. EEC_FILIAL == '"+MV_PAR02+"'","")   
		cFiltro   += IIF(!Empty(MV_PAR03)," .AND. EEC_ZEXP >= '"+MV_PAR03+"'","")	
		cFiltro   += IIF(!Empty(MV_PAR04)," .AND. EEC_ZEXP <= '"+MV_PAR04+"'","")
		cFiltro   += IIF(!Empty(MV_PAR05)," .AND. DTOS(EEC_DTPROC) >= '"+DTOS(MV_PAR05)+"'","")	
		cFiltro   += IIF(!Empty(MV_PAR06)," .AND. DTOS(EEC_DTPROC) <= '"+DTOS(MV_PAR06)+"'","")
		cFiltro   += IIF(!Empty(MV_PAR07)," .AND. DTOS(EEC_DTEMBA) >= '"+DTOS(MV_PAR07)+"'","")	
		cFiltro   += IIF(!Empty(MV_PAR08)," .AND. DTOS(EEC_DTEMBA) <= '"+DTOS(MV_PAR08)+"'","")
		
		oBrowse:SetFilterDefault(cFiltro )
		oBrowse:activate()
	endif

	xDesmark()

	restArea( aAreaEEC )
	restArea( aAreaX )
return

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
static function xMark()

Local cAlias := oBrowse:Alias()
Local cChave := ''
Local nPos   := 0 

If ( !oBrowse:IsMark() )
	IF aScan(aMark,{|x|  x[1] == (cAlias)->(Recno()) }  ) == 0 
	   
		If nParamOpc == 1
		   IF !EMPTY( (cAlias)->EEC_ZDTSNA ) .AND. !EMPTY( (cAlias)->EEC_ZARMAD ) .AND. !EMPTY( (cAlias)->EEC_ZCONTA )
				IF EYG->(!dbSeek(XFilial("EYG")+(cAlias)->EEC_ZCONTA))
				       MsgAlert('Não encontrado o Contanier !!')
				Else
					cChave :=	(cAlias)->EEC_FILIAL + (cAlias)->EEC_ZARMAD + (cAlias)->EEC_DEST + (cAlias)->EEC_ORIGEM + (cAlias)->EEC_ZCONTA + EYG->EYG_XTIPO +STR( EYG->EYG_COMCON)
					IF Len(aMark) == 0 
					    AAdd(aMark,{(cAlias)->(Recno()),cChave})
					    RecLock( cAlias , .F. )
					    (cAlias)->EEC_ZOK		:= oBrowse:Mark()
						(cAlias)->EEC_ZUMARK	:= retCodUsr()
						(cAlias)->(MsUnLock())
					Else	
						If aScan(aMark,{|x|  x[2] == cChave }) <> 0 
						    AAdd(aMark,{(cAlias)->(Recno()),cChave})
							RecLock( cAlias , .F. )
							(cAlias)->EEC_ZOK		:= oBrowse:Mark()
							(cAlias)->EEC_ZUMARK	:= retCodUsr()
							(cAlias)->(MsUnLock())
						Else
						    msgAlert("Foram selecionados EXPs com diferentes:" + CRLF + CRLF + "Filiais, Armadores, Origem, Destino, Tipo de Container ou Tamanho de Container.")
						EndIF
					EndIF
				EndIF
		   Else
		        MsgAlert('Dt.Sai.Navio ou Armador Prof ou Container em Brancos, não é possivel selecionar')
		   EndIF
	   ElseIf nParamOpc == 2
		   IF ZB8->(!dbSeek(xFilial('ZB8',(cAlias)->EEC_FILIAL)+PADR(ALLtrim((cAlias)->EEC_ZEXP),TamSX3('ZB8_EXP')[01])+(cAlias)->EEC_ZANOEX+(cAlias)->EEC_ZSUBEX))
	           MsgAlert('Não encontrado a EXP na tabela de cabeçalho!!')
		   Else
				IF EMPTY( ZB8->ZB8_TERMIN ) .OR. EMPTY( ZB8->ZB8_ZDTDEC ).OR. EMPTY( ZB8->ZB8_ZDAEST ).OR. EMPTY( ZB8->ZB8_ZCONTA )
					 msgAlert("Terminal, Data de Chegada, Data de Saida ou Tipo do Container em Branco")
				Else
					cChave := xFilial('ZB8',(cAlias)->EEC_FILIAL)+ ZB8->ZB8_TERMIN 
					IF Len(aMark) == 0 
					    AAdd(aMark,{(cAlias)->(Recno()),cChave})
					    RecLock( cAlias , .F. )
					    (cAlias)->EEC_ZOK		:= oBrowse:Mark()
						(cAlias)->EEC_ZUMARK	:= retCodUsr()
						(cAlias)->(MsUnLock())
					Else	
						If aScan(aMark,{|x|  x[2] == cChave }) <> 0
						    AAdd(aMark,{(cAlias)->(Recno()),cChave})
							RecLock( cAlias , .F. )
							(cAlias)->EEC_ZOK		:= oBrowse:Mark()
							(cAlias)->EEC_ZUMARK	:= retCodUsr()
							(cAlias)->(MsUnLock())
						Else
						    msgAlert("As EXP's selecionada não possuem os mesmos Terminais e/ou Filiais cadastradas. Favor verificar o registro da EXP e tentar novamente")
						EndIF
					EndIF
				EndIF
			EndIF
	   Else
			IF Empty(EEC->EEC_ZDTSNA) 
			    MsgAlert('Data de Saida do Navio em Branco !!') 
			Else
				AAdd(aMark,{(cAlias)->(Recno()),""})
				RecLock( cAlias , .F. )
				(cAlias)->EEC_ZOK		:= oBrowse:Mark()
				(cAlias)->EEC_ZUMARK	:= retCodUsr()
				(cAlias)->(MsUnLock())
		 	EndIf
	   EndIF
	EndIF
Else
	nPos := aScan(aMark,{|x|  x[1] == (cAlias)->(Recno()) }  )
	IF nPos <> 0 
		ADel(aMark,nPos)
		ASize(aMark,Len(aMark)-1)
		RecLock( cAlias , .F. )
		(cAlias)->EEC_ZOK		:= ""
		(cAlias)->EEC_ZUMARK	:= ""
		(cAlias)->(MsUnLock())
	EndIF
endif


return .T.

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
static function xDesMark()
Local nI := 0 
/*
	local aArea		:= GetArea()
	local cQryEEC	:= ""

	cQryEEC := "UPDATE " + retSQLName("EEC")					+ CRLF
	cQryEEC += "	SET"										+ CRLF
	cQryEEC += " 		EEC_ZOK		= ' ',"						+ CRLF
	cQryEEC += " 		EEC_ZUMARK	= ' '"						+ CRLF
	cQryEEC += " WHERE"											+ CRLF
	cQryEEC += " 		EEC_ZUMARK	=	'" + retCodUsr() + "'"	+ CRLF
	cQryEEC += " 	AND	D_E_L_E_T_	<>	'*'"					+ CRLF

	if tcSQLExec( cQryEEC ) < 0
		conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
	endif
    aMark := {}
	restArea(aArea)*/
For nI := 1 To Len(aMark)
    EEC->(dbGoTo(aMark[nI,01]))
    RecLock( 'EEC' , .F. )
	EEC->EEC_ZOK		:= ""
	EEC->EEC_ZUMARK	:= ""
	EEC->(MsUnLock())
Next nI	
aMark := {}
	
	
return

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
static function xMarkAll()
	local cAlias	:= oBrowse:Alias()
	local aRest		:= GetArea()

	(cAlias)->(DbGoTop())

	while (cAlias)->(!Eof())
		if ( !oBrowse:isMark() )
			RecLock(cAlias,.F.)
				(cAlias)->EEC_ZOK		:= oBrowse:Mark()
				(cAlias)->EEC_ZUMARK	:= RetCodUsr()
			(cAlias)->(MsUnLock())
		else
			RecLock(cAlias,.F.)
			(cAlias)->EEC_ZOK		:= ""
			(cAlias)->EEC_ZUMARK	:= ""
			(cAlias)->(MsUnLock())
		endif
		(cAlias)->(DbSkip())
	enddo

	restArea(aRest)

	oBrowse:refresh(.F.)
Return .T.

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina Title "Lançar Despesas" ACTION 'U_chkEEC69()' OPERATION 2 ACCESS 0

return aRotina

/*/{Protheus.doc} chkEEC69

Valida seleção de EXPs

@type function
@author TOTVS
@since JUNHO/2019
@version P12
/*/
user function chkEEC69()

Local cQryEEC	:= ""
Local aRet		    := {}
Local aParambox	    := {}



   If nParamOpc == 1
		if Len(aMark) > 0
				U_MGFEEC67()
				xDesMark()
		endif
   ElseIF nParamOpc == 2
		if Len(aMark) > 0
				U_MGFEEC73()
				xDesMark()
		endif
    ElseIF nParamOpc == 3
		if Len(aMark) > 0
			AAdd( aParamBox,{1, "Despachante :"  ,Space(tamSx3("Y5_COD")[1])     ,"@!", "NaoVazio() .And. U_xEEC69Vld()"  		 			 ,"DES" ,, 040	, .T.	})
			AAdd( aParamBox,{1, "Emissão :"      ,Ctod("  /  /  ")               ,"@D", "MV_PAR02 <= dDataBase"  			 ,      ,, 050	, .T.	})
			AAdd( aParamBox,{1, "Qtde. Exps :"   ,Len(aMark)             ,"@D", "MV_PAR02 <= dDataBase"  			 ,      ,".F.", 050	, .T.	})
			If ParamBox(aParambox, "Dados da Nota Fiscal"  , @aRet, , , .T. , 0, 0, , , .F. , .F. )
				U_MGFEEC75()
				xDesMark()
			EndIf
		endif
   EndIF
return
************************************************************************************************************************
User Function xEEC69Vld
Local bRet    := .T.
Local cQuery  := ""

SY5->(dbSetOrder(1))
IF SY5->(!dbSeek(xFilial('SY5')+MV_PAR01))
	MsgAlert('Despachante não encontrado !!')
	bRet  := .F.  
Else
	IF !(LEFT(SY5->Y5_TIPOAGE,1) == "6" .OR. LEFT(SY5->Y5_TIPOAGE,1) == " ")
		MsgAlert('Codigo não é de despachante !!')
		bRet  := .F.  
	Else
		IF Empty(SY5->Y5_FORNECE) .OR. Empty(SY5->Y5_LOJAF)
			MsgAlert('Codigo de fornecedor não cadastro para o despachante !!')
			bRet  := .F.
		EndIF  
	EndIF
EndIF

Return bRet