#include 'protheus.ch'
#include 'rwmake.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fwmvcdef.ch"
#include "msmgadd.ch"
#include "TOTVS.CH"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"
#include "TOPCONN.CH"

#define ENTER CHR(13)
#define DMPAPER_LETTER      1           /* Letter 8 1/2 x 11 in               */
#define DMPAPER_LETTERSMALL 2           /* Letter Small 8 1/2 x 11 in        */
#define DMPAPER_TABLOID     3           /* Tabloid 11 x 17 in                 */
#define DMPAPER_LEDGER      4           /* Ledger 17 x 11 in                  */
#define DMPAPER_LEGAL       5           /* Legal 8 1/2 x 14 in               */
#define DMPAPER_STATEMENT   6           /* Statement 5 1/2 x 8 1/2 in        */
#define DMPAPER_EXECUTIVE   7           /* Executive 7 1/4 x 10 1/2 in        */
#define DMPAPER_A3          8           /* A3 297 x 420 mm                    */
#define DMPAPER_A4          9           /* A4 210 x 297 mm                    */
#define DMPAPER_A4SMALL     10          /* A4 Small 210 x 297 mm              */
#define DMPAPER_A5          11          /* A5 148 x 210 mm                    */
#define DMPAPER_B4          12          /* B4 250 x 354                      */
#define DMPAPER_B5          13          /* B5 182 x 257 mm                    */
#define DMPAPER_FOLIO       14          /* Folio 8 1/2 x 13 in               */
#define DMPAPER_QUARTO      15          /* Quarto 215 x 275 mm               */
#define DMPAPER_10X14       16          /* 10x14 in                           */
#define DMPAPER_11X17       17          /* 11x17 in                           */
#define DMPAPER_NOTE        18          /* Note 8 1/2 x 11 in                 */
#define DMPAPER_ENV_9       19          /* Envelope #9 3 7/8 x 8 7/8          */
#define DMPAPER_ENV_10      20          /* Envelope #10 4 1/8 x 9 1/2        */
#define DMPAPER_ENV_11      21          /* Envelope #11 4 1/2 x 10 3/8        */
#define DMPAPER_ENV_12      22          /* Envelope #12 4 \276 x 11           */
#define DMPAPER_ENV_14      23          /* Envelope #14 5 x 11 1/2            */
#define DMPAPER_CSHEET      24          /* C size sheet                      */
#define DMPAPER_DSHEET      25          /* D size sheet                      */
#define DMPAPER_ENV_DL      27          /* Envelope DL 110 x 220mm            */
#define DMPAPER_ENV_C5      28          /* Envelope C5 162 x 229 mm           */
#define DMPAPER_ENV_C3      29          /* Envelope C3 324 x 458 mm          */
#define DMPAPER_ENV_C4      30          /* Envelope C4 229 x 324 mm          */
#define DMPAPER_ENV_C6      31          /* Envelope C6 114 x 162 mm          */
#define DMPAPER_ENV_C65     32          /* Envelope C65 114 x 229 mm          */
#define DMPAPER_ENV_B4      33          /* Envelope B4 250 x 353 mm          */
#define DMPAPER_ENV_B5      34          /* Envelope B5 176 x 250 mm          */
#define DMPAPER_ENV_B6      35          /* Envelope B6 176 x 125 mm          */
#define DMPAPER_ENV_ITALY   36          /* Envelope 110 x 230 mm              */
#define DMPAPER_ENV_MONARCH 37          /* Envelope Monarch 3.875 x 7.5 in    */
#define DMPAPER_ENV_PERSONAL 38        /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
#define DMPAPER_FANFOLD_US 39          /* US Std Fanfold 14 7/8 x 11 in      */
#define DMPAPER_FANFOLD_STD_GERMAN 40 /* German Std Fanfold 8 1/2 x 12 in   */
#define DMPAPER_FANFOLD_LGL_GERMAN 41 /* German Legal Fanfold 8 1/2 x 13 in */

/*---------------------------------------------------------------------*
| Func:  MGFFATAP                                                     |
| Autor: Cristiano Macedo                                             |
| Data:  26/12/2017                                                   |
| Desc:  Controle de Pallets                                          |
*---------------------------------------------------------------------*/

user function MGFFATAP()

	local _cAlias 		:= "Z01"
	local _nSoma  		:= 1
	private _lOpc9  	:= .F.
	private oBrw 		:= nil
	private aField  	:= {}
	private cCadastro	:= "Controle de Pallets"
	private aRotina		:= MenuDef()
	private aSeek 		:= {}
	private _xPallet    := ""
	private _nXRec      := 0

	DbSelectArea("SX3")//ABRE A TABELA
	DbSetOrder(1) //ARQUIVO+ORDEM
	DbSeek(_cAlias) //PESQUISA NA TABELA
	while SX3->X3_ARQUIVO == _cAlias .and. SX3->(!Eof())
		if Alltrim(SX3->X3_CAMPO) $ "Z01_CODIGO|Z01_REMESS|Z01_ENDENT|Z01_VEIC|Z01_MOTOR|Z01_XPRCOD|Z01_DESCPR|Z01_DTENTR|Z01_VEIC|Z01_MOTOR|Z01_CODTRA|Z01_TRANSP"
			Aadd(aSeek,{X3TITULO(), {{"",SX3->X3_TIPO,SX3->X3_TAMANHO,0, SX3->X3_CAMPO   ,SX3->X3_PICTURE}}, _nSoma, .T. } )
			_nSoma++
		endif
		SX3->(DbSkip())
	enddo

	u_xStatusZ01("OK")

	oBrw := FWMBrowse():New()
	oBrw:SetAlias( _cAlias )
	oBrw:SetFilial( {FWxFilial(_cAlias)} )
	oBrw:SetDescription( "Controle de Pallets" )
	oBrw:SetUseFilter(.T.)
	oBrw:AddFilter( "Filial Corrente" , "Z01->Z01_FILIAL == '" + FWxFilial("Z01") + "'",.T.  )
	oBrw:DisableDetails()
	//Legenda da grade, é obrigatório carregar antes de montar as colunas
	oBrw:AddLegend("Z01_STATUS=='1'","GREEN" 	 ,"Pallet Gerado")
	oBrw:AddLegend("Z01_STATUS=='2'","BLUE"  ,"Pallet TOTALMENTE Entregue")
	oBrw:AddLegend("Z01_STATUS=='3'","BLACK" ,"Pallet com Divergencia Fisica")
	oBrw:AddLegend("Z01_STATUS=='4'","RED" ,"Pallet fora do prazo")
	oBrw:AddLegend("Z01_STATUS=='5'","YELLOW","Vale Pallet Emitido")
	oBrw:AddLegend("Z01_STATUS=='6'","WHITE","Pallet(s) Total no Cliente")	
	oBrw:AddLegend("Z01_STATUS=='7'","BR_PINK","Pallet(s) Parcial no Cliente")
	oBrw:AddLegend("Z01_STATUS=='8'","BR_LARANJA","Pallet(s) Com NDF Gerado")
	oBrw:AddLegend("Z01_STATUS=='9'","BR_MARROM","Recebimento pelo Cliente") //*** Personalizacao - Vagner Azanha - B2 finance
	oBrw:AddLegend("Z01_STATUS=='0'","BR_CINZA","Baixa por descarte")//*** Personalizacao - Vagner Azanha - B2 finance
	oBrw:AddLegend("Z01_STATUS==' '","BR_CANCEL","Cancelado")//*** Personalizacao - Vagner Azanha - B2 finance
	oBrw:Activate()

return


static function MenuDef()

	Local aRot 	:= {}

	AAdd(aRot,{"Add NF de Produtos ao Pallet","U_XADDNF",0,6})
	AAdd(aRot,{"Visualizar","U_MIT6312",0,2})
	AAdd(aRot,{"Gerar","u_MIT6312",0,3})	
	AAdd(aRot,{"Recebimento","u_zVPallet",0,4})
	AAdd(aRot,{"Excluir","u_MIT6312",0,5})
	AAdd(aRot,{"Notas do Pallet Produtos","u_viewz02",0,5})
	AAdd(aRot,{"Gerar NDF","u_gerandf",0,5})
	AAdd(aRot,{"Visualizar NDF","u_VisNDF",0,5})
	AAdd(aRot,{"Pallets fora do prazo","U_xStatusZ01",0,5})
	AAdd(aRot,{"Termo de Responsabilidade","U_xRTermo",0,5})
	AAdd(aRot,{"Emitir Vale Pallet","U_xVPallet",0,5})
	AAdd(aRot,{"Notas do Pallet Remessa","u_viewz03",0,5})
    AAdd(aRot,{"Recebimento pelo Cliente","u_zVPallet",0,5}) //*** Personalizacao - Vagner Azanha - B2 finance
    AAdd(aRot,{"Baixa por Descarte","u_zVPallet",0,5}) //*** Personalizacao - Vagner Azanha - B2 finance
    AAdd(aRot,{"Pesquisar por Nota Fiscal","u_zVPalNF",0,5}) //*** Personalizacao - Vagner Azanha - B2 finance
    AAdd(aRot,{"Cancelamento de Vale Pallet","u_zVPalCanc",0,5})//*** Personalizacao - Vagner Azanha - B2 finance
    AAdd(aRot,{"Recebimento por Outra Filial","u_zVPalOFil()",0,5})//*** Personalizacao - Vagner Azanha - B2 finance
	AAdd(aRot,{"Legenda","u_xLegz",0,5})

return( aRot )

User Function xLegz()
	local aLegenda := {	{"BR_VERDE"		,"Pallet Gerado"	},;	
	{"BR_AZUL"		,"Pallet TOTALMENTE Entregue"	},;
	{"BR_PRETO"		,"Pallet com Divergencia Fisica"	},;
	{"BR_VERMELHO"	,"Pallet Fora do Prazo"	},;
	{"BR_BRANCO"	,"Pallet(s) Total no Cliente"},;
	{"BR_PINK"		,"Pallet(s) Parcial no Cliente"	},;
	{"BR_AMARELO"	,"Vale Pallet Emitido"},;
	{"BR_LARANJA"	,"Pallet(s) Com NDF Gerado"},;
	{"BR_MARROM"	,"Recebimento pelo Cliente"},;//*** Personalizacao - Vagner Azanha - B2 finance
	{"BR_CINZA"    ,"Baixa por Descarte"},;//*** Personalizacao - Vagner Azanha - B2 finance
    {"BR_CANCEL"	,"Cancelado"}}//*** Personalizacao - Vagner Azanha - B2 finance
	BrwLegenda("Legenda dos Pallets","Legenda",aLegenda)
return

user function XADDNF(_cAlias,nRecno,nOpc)
	local aParamBox	 := {}
	local _aRet      := {}

	dbSelectArea(_cAlias)
	dbGoTo(nRecno)
	if (_cAlias)->Z01_STATUS == '1'

		aAdd(aParamBox,{1,"Emissão NF de"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
		aAdd(aParamBox,{1,"Emissão NF até"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data

		if ParamBox(aParamBox,"Parametro para seleção de notas fiscais",_aRet)
			DbSelectArea(_cAlias)
			DbGoTo(nRecno)
			MsgRun("Aguarde...","Coletando dados",{|| u_XADDNF2(_cAlias,nRecno,(_cAlias)->Z01_CODTRA,(_cAlias)->Z01_XPRCOD,"XADDNF",Dtos(_aRet[1]),Dtos(_aRet[2]),"",(_cAlias)->Z01_CODIGO)})
		endif
	else
		MsgStop("Você só pode incluir notas de produtos ao Pallets que não tiveram movimentações")
	endif
return

user function YADDNF(_cAlias,nRecno,nOpc)
	local aParamBox	 := {}
	local _aRet       := {}

	dbSelectArea(_cAlias)
	dbGoTo(nRecno)
	if (_cAlias)->Z01_STATUS == '1' .Or. M->Z01_STATUS == '1' 

		aAdd(aParamBox,{1,"Informe a Transportadora",Space(15),"","","SA4","",0,.T.}) // Tipo caractere 
		aAdd(aParamBox,{1,"Informe o Cod. do Pallet",Space(15),"","","SB1","",0,.T.}) // Tipo caractere	
		aAdd(aParamBox,{1,"Emissão NF de"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data
		aAdd(aParamBox,{1,"Emissão NF até"  ,Ctod(Space(8)),"","","","",50,.T.}) // Tipo data

		if ParamBox(aParamBox,"Parametro para seleção de notas de remessas",_aRet)	
			DbSelectArea(_cAlias)
			DbGoTo(nRecno)
			MsgRun("Aguarde...","Coletando dados",{|| u_XADDNF2(_cAlias,nRecno,(_cAlias)->Z01_CODTRA,_aRet[2],"YADDNF",Dtos(_aRet[3]),Dtos(_aRet[4]),_aRet[1],(_cAlias)->Z01_CODIGO) })		
		endif
	else
		MsgStop("Você só pode incluir notas de remessa ao Pallets que não tiveram movimentações")
	endif

return

user function zVPallet(_cAlias,nRecno,nOpc)

	private _cPalAlias := _cAlias 
	private _nRecPal   := nRecno

	if (nOpc <> 13) .and. (nOpc <> 14) .and. (nOpc <> 17) // //*** Personalizacao - Vagner Azanha - B2 finance
	   if MsgYesNo("Você esta recebendo Pallet(Sim) ou Vale Pallet(Não)")
		  u_MIT6312(_cAlias,nRecno,nOpc)
	   else
		  u_viewz02(_cAlias,nRecno)
		  //u_MIT6312("Z03",0,10)
	   endif
	elseif (nOpc == 13) .or. (nOpc == 14) .or. (nOpc == 17)  // //*** Personalizacao - Vagner Azanha - B2 finance
	   u_MIT6312(_cAlias,nRecno,nOpc)
	endif
return

user function MIT6312(_cAlias,nRecno,nOpc)

	local oDlg
	local aButtons:={}
	local lColuna:= .F.//se aparece uma ou duas colunas no formulário
	local aEdit:={}//campos que deverao estar liberados no momento da alteracao.
	local aPosicao:={}//coordenadas da tela que deverao aparecer o formulario
	Local lMemoria 	:= .T.       
	Local lCreate	:= .T.
	local _lBranco  := .T.
	private _lNF	:= .F.
	private _lPalletX  := .F.
	private aCampos :={} //campos que deverao aparecer no formulario. esses campos virao da tabela sx3
	
	if nOpc = 10
		DbSelectArea(_cAlias)
		DbGoTo(nRecno)	
	endif

	if nOpc = 3
		_lNF := .T.
		Aadd(aButtons,{"PEDIDO",{||U_YADDNF(_cAlias,nRecno,nOpc)},"Incluir Notas de Remessa"})//variavel para incluir botoes novos
		//Aadd(aButtons,{"PEDIDO",{||U_XADDNF(_cAlias,nRecno,nOpc)},"Incluir Notas de Produto"})//variavel para incluir botoes novos		
	endif

	if (nOpc = 4) .or. (nOpc == 13)  .or.(nOpc == 14) .or. (nOpc == 17) //*** Personalizacao - Vagner Azanha - B2 finance

		DbSelectArea(_cAlias)
		DbGoTo(nRecno)
		if !((_cAlias)->Z01_STATUS $ '1|4|5|6|9|') //*** Personalizacao - Vagner Azanha - B2 finance
			MsgStop("O Pallet: " + (_cAlias)->Z01_CODIGO + ", não pode ser modificado, já passou por outros processos!")
			return	
		elseif (_cAlias)->Z01_STATUS == " " //*** Personalizacao - Vagner Azanha - B2 finance
			MsgStop("O Pallet: " + (_cAlias)->Z01_CODIGO + ", cancelado ! Não pode ser modificado !")
			return	

		endif
	endif	

	CriaCampos(_cAlias,nOpc)//funcao para alimentar a variavel acampos
	_nOpcAux := nOpc
	
	do case

		case nOpc = 2
		Define MsDialog oDlg From 0,0 to 0,0 title cCadastro Pixel
		oDlg:lMaximized := .T.
		aPosicao := {30,2,oDlg:oWnd:nClientHeight/2-5,oDlg:oWnd:nClientWidth/2-5}//coordenadas da tela.

		case nOpc = 3
		Define MsDialog oDlg From 0,0 to 0,0 title cCadastro Pixel
		oDlg:lMaximized := .T.		
		aPosicao := {30,2,oDlg:oWnd:nClientHeight/2-5,oDlg:oWnd:nClientWidth/2-5}//coordenadas da tela.		

		case nOpc = 5
		Define MsDialog oDlg From 0,0 to 0,0 title cCadastro Pixel
		oDlg:lMaximized := .T.
		aPosicao := {30,2,oDlg:oWnd:nClientHeight/2-5,oDlg:oWnd:nClientWidth/2-5}//coordenadas da tela.

		case nOpc = 4
		Define MsDialog oDlg From 0,0 to 450,450 title "Recebimento" Pixel
		aPosicao := {30,2,440,240}//coordenadas da tela.

		case nOpc = 9
		Define MsDialog oDlg From 0,0 to 450,450 title "Informe o Motivo" Pixel
		aPosicao := {30,2,440,240}//coordenadas da tela.
		nOpc := 4		

		case nOpc = 10
		Define MsDialog oDlg From 0,0 to 0,0 title "Recebimento Vale Pallet" Pixel
		oDlg:lMaximized := .T.
		aPosicao := {30,2,oDlg:oWnd:nClientHeight/2-5,oDlg:oWnd:nClientWidth/2-5}//coordenadas da tela.
		_lPalletX := .T.
		case nOpc = 13
        Define MsDialog oDlg From 0,0 to 450,450 title "Recebimento pelo Cliente" Pixel //*** Personalizacao - Vagner Azanha - B2 finance
		aPosicao := {30,2,440,240}//coordenadas da tela.
	    nOpc := 4
	    _lPalletX := .f.

		case nOpc = 14
        Define MsDialog oDlg From 0,0 to 400,1200 title "Baixa por Descarte" Pixel //*** Personalizacao - Vagner Azanha - B2 finance
		aPosicao := {30,2,440,800}//coordenadas da tela.
	    nOpc := 4
	    _lPalletX := .f.
   	case nOpc = 17
		Define MsDialog oDlg From 0,0 to 450,450 title "Recebimento de Outra Filial" Pixel //*** Personalizacao - Vagner Azanha - B2 finance
		aPosicao := {30,2,440,240}//coordenadas da tela.	    
         nOpc := 4
	    _lPalletX := .f.  
	endcase		

	RegToMemory(_cAlias,nOpc == 3)//essa função cria os campos em branco caso o nOpc == 3, e busca o conteúdo do banco de dados caso o nOpc != 3	

    //oEnchoice := MsmGet():New(,,nOpc,,,,aCampos,aPosicao,aCampos,,,,,oDlg,,lMemoria,,,,,aCampos,,lCreate,)
	//oEnchoice := MsmGet():New(,,nOpc,,,,aCampos,aPosicao,aCampos,,,,,oDlg,,lMemoria,,,,,aField,,lCreate,)
	oEnchoice := MsmGet():New(,,4,,,,aCampos,aPosicao,aCampos,,,,,oDlg,,lMemoria,,,,,aField,,lCreate,)
    
	// Wagner Neves------Tratamento para verificar se o numero gerado ja existe na filial
	if nOpc == 3
		if (_cAlias)->(DbSeek(xFilial("Z01")+M->Z01_CODIGO))
			Msgalert("Foi gerado o número "+M->Z01_CODIGO+". Esse número de pallet já existe nessa filial. Gere novamente.","Número Pallet já existe !!!")
			return	
		endif
	endif // Eof Wagner

  Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg, {||Confirmacao(_cAlias,nRecno,_nOpcAux,oDlg),oDlg:End()}, {||xCancelar(M->Z01_CODIGO,_nOpcAux),oDlg:End()},,aButtons)
  //  Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg, {||Confirmacao(_cAlias,nRecno,_nOpcAux,oDlg),oDlg}, {||xCancelar(M->Z01_CODIGO,_nOpcAux),oDlg:End()},,aButtons)
return

//Esse programa monta o array com os campos que devem aparecer na Enchoice
static function CriaCampos(cTabela,nOpc)
    Local _cListFields 

	aCampos := {}
	aField = {}

	DbSelectArea("SX3")	//ABRE A TABELA
	DbSetOrder(1) 		//ARQUIVO+ORDEM
	DbSeek(cTabela) 	//PESQUISA NA TABELA

	while SX3->X3_ARQUIVO == cTabela .and. SX3->(!Eof())

		if X3Uso(SX3->X3_Usado)    .And. cNivel >= SX3->X3_Nivel  .And. SX3->X3_BROWSE == 'S'    // cNivel é uma variavel publica que grava o Nivel do Usuario >= Nivel do Campo.			

			do case

				case nOpc = 10
				if Alltrim(SX3->X3_CAMPO) $ "Z03_CODPAL|Z03_CODCLI|Z03_NFCLI|Z03_NFSERI|Z03_QUANT|Z03_QDRET|Z03_OBS"
					aadd(aCampos,SX3->X3_CAMPO)
					Aadd(aField,{X3TITULO(),;
					SX3->X3_CAMPO,;
					SX3->X3_TIPO,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_PICTURE,;
					SX3->X3_VLDUSER,;
					.F.,;
					SX3->X3_NIVEL,;
					SX3->X3_RELACAO,;
					"",;
					SX3->X3_WHEN,;
					iif(Alltrim(SX3->X3_CAMPO) $ "Z03_QDRET|Z03_OBS",.F.,.T.),;
					.F.,;
					SX3->X3_CBOX,;
					Val(SX3->X3_FOLDER),;
					.F.,;
					SX3->X3_PICTVAR,;
					SX3->X3_TRIGGER})
				endif

				case nOpc = 9	
				if Alltrim(SX3->X3_CAMPO) $ "Z01_CODIGO|Z01_MOTIVO|Z01_DTRECE|Z01_QTDENV|Z01_QTDREC"
					aadd(aCampos,SX3->X3_CAMPO)
					Aadd(aField,{X3TITULO(),;
					SX3->X3_CAMPO,;
					SX3->X3_TIPO,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_PICTURE,;
					SX3->X3_VLDUSER,;
					.F.,;
					SX3->X3_NIVEL,;
					SX3->X3_RELACAO,;
					"",;
					SX3->X3_WHEN,;
					iif(SX3->X3_CAMPO $ "Z01_CODIGO|Z01_DTRECE|Z01_QTDENV|Z01_QTDREC",.T.,Iif(SX3->X3_VISUAL == 'A',.F.,.T.)),;
					.F.,;
					SX3->X3_CBOX,;
					Val(SX3->X3_FOLDER),;
					.F.,;
					SX3->X3_PICTVAR,;
					SX3->X3_TRIGGER})
				endif

				case nOpc = 2
				aadd(aCampos,SX3->X3_CAMPO)
				Aadd(aField,{X3TITULO(),;
				SX3->X3_CAMPO,;
				SX3->X3_TIPO,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_PICTURE,;
				SX3->X3_VLDUSER,;
				.F.,;
				SX3->X3_NIVEL,;
				SX3->X3_RELACAO,;
				"",;
				SX3->X3_WHEN,;
				.T.,;
				.F.,;
				SX3->X3_CBOX,;
				Val(SX3->X3_FOLDER),;
				.F.,;
				SX3->X3_PICTVAR,;
				SX3->X3_TRIGGER})

				case nOpc = 3
				if Alltrim(SX3->X3_CAMPO) $ "Z01_CODIGO|Z01_ENDENT|Z01_VEIC|Z01_MOTOR|Z01_XPRCOD|Z01_DESCPR|Z01_QUANT|Z01_VLUNIT|Z01_VLTOTA|Z01_DTENTR|Z01_VEIC|Z01_MOTOR|Z01_VALBON|Z01_CODTRA|Z01_TRANSP|Z01_CPFM"
					aadd(aCampos,SX3->X3_CAMPO)
					Aadd(aField,{X3TITULO(),;
					SX3->X3_CAMPO,;
					SX3->X3_TIPO,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_PICTURE,;
					SX3->X3_VLDUSER,;
					.F.,;
					SX3->X3_NIVEL,;
					SX3->X3_RELACAO,;
					Iif(_lNF,IIf(Alltrim(SX3->X3_CAMPO) $ "Z01_TRANSP|Z01_VEIC|Z01_MOTOR|Z01_ENDENT",SX3->X3_F3,""),SX3->X3_F3),;
					SX3->X3_WHEN,;
					iif(Alltrim(SX3->X3_CAMPO) $ "Z01_VEIC|Z01_MOTOR|Z01_ENDENT|Z01_CPFM",.F.,.T.),;//Iif(_lNF,iif(Alltrim(SX3->X3_CAMPO) $ "Z01_VEIC|Z01_MOTOR|Z01_ENDENT",.F.,.T.),Iif(SX3->X3_VISUAL == 'A',.F.,.T.)),;
					.F.,;
					SX3->X3_CBOX,;
					Val(SX3->X3_FOLDER),;
					.F.,;
					SX3->X3_PICTVAR,;
					SX3->X3_TRIGGER})
				endif

				case (nOpc == 4) .or. (nOpc == 13) .or. (nOpc == 14) .or. (nOpc==17) //*** Personalizacao - Vagner Azanha - B2 finance
		          		
				if nOpc == 4
				  _cListFields := "Z01_QTDENV|Z01_QTDREC|Z01_DTRECE"
				elseif nOpc == 13
				  _cListFields := "Z01_QTDENV|Z01_DTCLIR" // Vagner - 19.11.2019
				elseif nOpc == 14
				  _cListFields := "Z01_QTDENV|Z01_QTDREC|Z01_DTRECE|Z01_DTDESC|Z01_MOTDES"
				elseif nOpc== 17
				  _cListFields := "Z01_QTDENV|Z01_QTDREC|Z01_DTRECEC|Z01_NFTRAS|Z01_SERTRA"
				endif  
				
				//if (Alltrim(SX3->X3_CAMPO)) $ "Z01_QTDENV|Z01_QTDREC|Z01_DTRECE|Z01_DTCLIR"
				if (Alltrim(SX3->X3_CAMPO)) $ _cListFields
					aadd(aCampos,SX3->X3_CAMPO)
					Aadd(aField,{X3TITULO(),;
					SX3->X3_CAMPO,;
					SX3->X3_TIPO,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_PICTURE,;
					SX3->X3_VLDUSER,;
					.F.,;
					SX3->X3_NIVEL,;
					SX3->X3_RELACAO,;
					SX3->X3_F3,;
					SX3->X3_WHEN,;
					iif(SX3->X3_CAMPO $ "Z01_DTRECE|Z01_QTDENV",.T.,Iif(SX3->X3_VISUAL == 'A',.F.,.T.)),;
					.F.,;
					SX3->X3_CBOX,;
					Val(SX3->X3_FOLDER),;
					.F.,;
					SX3->X3_PICTVAR,;
					SX3->X3_TRIGGER})
				endif

				case nOpc = 5
				aadd(aCampos,SX3->X3_CAMPO)
				Aadd(aField,{X3TITULO(),;
				SX3->X3_CAMPO,;
				SX3->X3_TIPO,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_PICTURE,;
				SX3->X3_VLDUSER,;
				.F.,;
				SX3->X3_NIVEL,;
				SX3->X3_RELACAO,;
				"",;
				SX3->X3_WHEN,;
				.T.,;
				.F.,;
				SX3->X3_CBOX,;
				Val(SX3->X3_FOLDER),;
				.F.,;
				SX3->X3_PICTVAR,;
				SX3->X3_TRIGGER})
			endcase
		endif
		SX3->(DbSkip())
	enddo

return

//Programa que decide o que fazer com os dados digitados pelo usuario
static function Confirmacao(_cAlias,nRecno,nOpc,oDlg)
    do case
	case nOpc == 10
		Altera2(_cAlias,nRecno,nOpc)
	case nOpc == 3
		Inclui(_cAlias)
    case (nOpc ==4) .or. (nOpc == 13) .or. (nOpc == 14) .or. (nOpc == 17) //*** Personalizacao - Vagner Azanha - B2 finance
	    if nOpc == 14
           if Empty(M->Z01_MOTDES) .or. Empty(M->Z01_DTDESC)
		      MsgAlert("Infome a Data e o Motivo do Descate !")
		      return nil
	       endif
	    elseif nOpc == 17
           if Empty(M->Z01_NFTRAS) 
		      MsgAlert("Necesário informar a NF de Transferencia !")
		      return nil
	       else
              SF2->(dbsetorder(1))
              if !SF2->(dbseek(xFilial("SF2")+M->Z01_NFTRAS+M->Z01_SERTRA))
                 MsgAlert("Necesário informar a NF de Transferencia Válida !")
		         return nil              
              endif       
	       endif	    
	    endif   	      
	
	
		if !_lPalletX
			Altera(_cAlias,nRecno,nOpc)
		else			
			Altera2(_cAlias,nRecno,nOpc)			
			_lPalletX := .F.
		endif	
	case nOpc == 5
		Exclui(_cAlias,nRecno)
	endcase
	oDlg:End()

return

//Programa que verifica no momento de cancelar se existem notas informadas na Z03 e Z02, com isso ele limpa a tabela, marcando como deletado.
static function xCancelar(_cPallet,_nOpc)

	if _nOpc = 3
		dbSelectArea("Z03")
		dbSetOrder(1)
		if dbSeek(FWxFilial("Z03") + _cPallet)
			while Z03->(!Eof()) .and. Z03->Z03_CODPAL == _cPallet
				RecLock("Z03",.F.)
				Z03->(DbDelete())
				MsUnlock()		
				Z03->(dbSkip())
			enddo
		endIf

		dbSelectArea("Z02")
		dbSetOrder(1)
		if dbSeek(FWxFilial("Z02") + _cPallet)
			while Z02->(!Eof()) .and. Z02->Z02_CODPAL == _cPallet
				RecLock("Z02",.F.)
				Z02->(DbDelete())
				MsUnlock()		

				Z02->(dbSkip())
			enddo
		endIf
	endif

return

//programa que vai incluir os registros
static function Inclui(_cAlias)

	local i:=0
	private _XYPallet := M->Z01_CODIGO

	DbSelectArea(_cAlias)
	RecLock(_cAlias,.T.)//.T. INCLUIR REGISTRO/ .F. BLOQUEIA PARA ALTERAR

	if !empty(M->Z01_DESCPR) .And. !empty(M->Z01_VEIC) .And. !empty(M->Z01_MOTOR) .And. !empty(M->Z01_VEIC) .And. !empty(M->Z01_CPFM)

		for i := 1 to FCount() //Fcont=retorna o número relacionado com o campo no banco de dados. É a ordem física dos campos no banco de dados.

			if "FILIAL" $ FieldName(i)//Fieldname= retorna o nome de um campo
				FieldPut(i, xFilial(_cAlias))//fieldput=grava um campo em uma tabela
			else
				nPos := Ascan(aCampos,{|x| Alltrim(x) == FieldName(i)})

				if nPos > 0
					FieldPut(i, M->&(aCampos[nPos])) //fieldput=grava um campo em uma tabela
				else
					FieldPut(i, Criavar(FieldName(i))) //criavar coloca o conteúdo padrao no campo, caso o usuario nao tenha acesso ao campo
				endIf
			endif
		next

		Z01->Z01_QTDENV := M->Z01_QUANT 

		MsUnlock()
	else
		Exclui2(Alltrim(M->Z01_CODIGO))
		msgStop("Dados importantes não foram informados, Pallet não foi salvo.")
	endif
return

//programa que vai alterar os registros
static function Altera(_cAlias,nRecno,nOpc)

	local i:=0

	DbSelectArea(_cAlias)
	DbGoTo(nRecno)

	RecLock(_cAlias,.F.)

	for i:=1 to len(aCampos)
		(_cAlias)->&(aCampos[i]) := M->&(aCampos[i])
	next i

	if nOPc==13
	   (_cAlias)->Z01_STATUS := "9"
	else
	   if _lOpc9
	  		(_cAlias)->Z01_STATUS := "3"
		 	_lOpc9 := .F.		  
			(_cAlias)->(MsUnlock())
		  	// WAGNER - BAIXA O Z03
			IF Z03->(DBSEEK(XFILIAL("Z03")+(_cAlias)->Z01_CODIGO))
				WHILE Z03->Z03_CODPAL = (_cAlias)->Z01_CODIGO
					IF Z03->Z03_NFFIL = (_cAlias)->Z01_FILIAL
						RECLOCK("Z03",.F.)
						Z03->Z03_STATUS := "3"
						Z03->(MSUNLOCK())
					ENDIF
					Z03->(DBSKIP())
				ENDDO
			ENDIF
			// EOF WAGNER
       else
		  Z01->Z01_STATUS := "2"
		  Z01->(MsUnlock())
			// WAGNER - BAIXA O Z03
			IF Z03->(DBSEEK(XFILIAL("Z03")+Z01->Z01_CODIGO))
				WHILE Z03->Z03_CODPAL = Z01->Z01_CODIGO
					IF Z03->Z03_NFFIL = Z01->Z01_FILIAL
						RECLOCK("Z03",.F.)
						Z03->Z03_STATUS := "2"
						Z03->(MSUNLOCK())
					ENDIF
					Z03->(DBSKIP())
				ENDDO
			ENDIF
			// EOF WAGNER
	   endif
	endif
	//*** Personalizacao - Vagner Azanha - B2 finance
    if nOpc == 13
		Reclock(_cAlias,.F.)
	   (_cAlias)->Z01_STATUS := "9"
	   (_cAlias)->Z01_QTDREC := M->Z01_QTDREC
	   MsUnlock()
	   return nil
	   
	elseif nOpc == 14 
		Reclock(_cAlias,.F.)
	   (_cAlias)->Z01_STATUS := "0"
	   (_cAlias)->Z01_QTDREC := M->Z01_QTDREC
	   (_cAlias)->Z01_DTDESC := M->Z01_DTDESC
	   (_cAlias)->Z01_MOTDES := M->Z01_MOTDES		
       MsUnlock()
       return nil
    elseif  nOpc == 17
		Reclock(_cAlias,.F.)
       (_cAlias)->Z01_NFTRAS := M->Z01_NFTRAS
       (_cAlias)->Z01_SERTRA := M->Z01_SERTRA 
	   MsUnlock()           
    endif
        // *** FIm da Personalizacao - Vagner Azanha - B2 finance
	MsUnlock()

	if M->Z01_QTDENV <> M->Z01_QTDREC .And. Empty(M->Z01_MOTIVO)
		MsgAlert("Há divergencia entre o que foi recebido e entregue, informe o motivo da divergencia no campo MOTIVO!","Atenção!!!")
		//U_xGetMot(nRecno)
		_lOpc9 := .T.
		u_MIT6312(_cAlias,nRecno,9)
	endif
return

static function Altera2(_cAlias,nRecno,nOpc)

	local i:=0
	local _cPalY := Alltrim(M->Z03_CODPAL)
	local _nQuant := 0
	local _nRec   := 0
	local _nRec2  := 0 
	local _lCont  := .T.

	DbSelectArea(_cAlias)
	DbGoTo(nRecno)

	if M->Z03_QDRET > M->Z03_QUANT
		if msgYesNo("A quantidade informada recebida é maior que a quantidade enviada nesta nota, deseja continuar?")
			_lCont  := .T.
		else
			_lCont  := .F.
		endif
	endif

	if _lCont
		RecLock(_cAlias,.F.)

		for i:=1 to len(aCampos)
			(_cAlias)->&(aCampos[i]) := M->&(aCampos[i])
		next i

		if M->Z03_QUANT <> M->Z03_QDRET	
			(_cAlias)->Z03_STATUS := "3"
		else
			(_cAlias)->Z03_STATUS := "2"
		endif

		MsUnlock()

		DbSelectArea(_cAlias)
		DbSetOrder(1)
		if DbSeek(FWxFilial(_cAlias) + _cPalY)
			while (_cAlias)->(!Eof()) .And. (_cAlias)->Z03_CODPAL == _cPalY
				IF FWxFilial("Z01") == (_cAlias)->Z03_NFFIL
					_nQuant := _nQuant + (_cAlias)->Z03_QUANT					
					_nRec   := _nRec + (_cAlias)->Z03_QDRET
				ENDIF
				(_cAlias)->(DbSkip())
			enddo
		endif

		if _nQuant > _nRec
			DbSelectArea("Z01")
			DbGoTo(_nXRec)
			RecLock("Z01",.F.)
			Z01->Z01_STATUS := "7"
			Z01->Z01_QTDREC := _nRec
			MsUnlock()
		else
			DbSelectArea("Z01")
			DbGoTo(_nXRec)
			RecLock("Z01",.F.)
			Z01->Z01_STATUS := "6"
			Z01->Z01_QTDREC := _nRec
			MsUnlock()		
		endif

		_aVetBrw := {}

		DbSelectArea(_cAlias)
		DbSetOrder(1)
		If dbSeek(FWxFilial(_cAlias) + Z01->Z01_CODIGO)
			while (_cAlias)->(!Eof()) .and. (_cAlias)->Z03_CODPAL == Z01->Z01_CODIGO
				IF FWxFilial("Z01") == (_cAlias)->Z03_NFFIL
					if (_cAlias)->Z03_QUANT > (_cAlias)->Z03_QDRET 
						aAdd(_aVetBrw,{(_cAlias)->Z03_FILIAL,;
						(_cAlias)->Z03_CODPAL,;
						(_cAlias)->Z03_NFFIL,;			
						(_cAlias)->Z03_NFCLI,;
						(_cAlias)->Z03_NFSERI,;
						(_cAlias)->Z03_CODCLI})
					endif
				ENDIF
				(_cAlias)->(DbSkip())	
			enddo
		endif

		oMark:SetArray(_aVetBrw)
		oMark:Refresh()

	endif
return

//programa que vai excluir os registros
static function Exclui(_cAlias,nRecno)

	DbSelectArea(_cAlias)
	DbGoTo(nRecno)

	if (_cAlias)->Z01_STATUS == '1'
		DbSelectArea("Z02")
		dbSetOrder(1)
		if DbSeek(FWxFilial("Z02") + Alltrim((_cAlias)->Z01_CODIGO))
			while Z02->(!eof()) .And. Alltrim(Z02->Z02_PALLET) == Alltrim((_cAlias)->Z01_CODIGO)	
				RecLock("Z02",.F.)
				Z02->(DbDelete())
				MsUnlock()

				Z02->(dbSkip())
			enddo
		endIf

		DbSelectArea("Z03")
		dbSetOrder(1)
		if DbSeek(FWxFilial("Z03") + Alltrim((_cAlias)->Z01_CODIGO))
			while Z03->(!eof()) .And. Alltrim(Z03->Z03_CODPAL) == Alltrim((_cAlias)->Z01_CODIGO)	
				RecLock("Z03",.F.)
				Z03->(DbDelete())
				MsUnlock()

				Z03->(dbSkip())
			enddo
		endIf

		RecLock(_cAlias,.F.)
		(_cAlias)->(DbDelete())
		MsUnlock()
	else
		msgStop("O registro não pode ser deletado, existem movimentações neste registro e ou o mesmo está em atraso!")
	endif

return

//programa que vai excluir os registros
static function Exclui2(_cPallet)

	DbSelectArea("Z02")
	dbSetOrder(1)
	if DbSeek(FWxFilial("Z02") + _cPallet)
		while Z02->(!eof()) .And. Alltrim(Z02->Z02_PALLET) == _cPallet	
			RecLock("Z02",.F.)
			Z02->(DbDelete())
			MsUnlock()

			Z02->(dbSkip())
		enddo
	endIf

	DbSelectArea("Z03")
	dbSetOrder(1)
	if DbSeek(FWxFilial("Z03") + _cPallet)
		while Z03->(!eof()) .And. Alltrim(Z03->Z03_CODPAL) == _cPallet	
			RecLock("Z03",.F.)
			Z03->(DbDelete())
			MsUnlock()

			Z03->(dbSkip())
		enddo
	endIf

return


//Programa para preencher o nome do cliente
user function xRetSA1(_cCodCli)

	local _cNome := ""

	DbSelectArea("SA1")
	DbSetOrder(1)
	if dbseek(FWxFilial("SA1")+Alltrim(_cCodCli))
		_cNome := SA1->A1_NOME
	endif

return(_cNome)	

//Programa para preencher o nome da transportadora
user function xRetSA4(_cCodTra)

	local _cNome := ""

	DbSelectArea("SA4")
	DbSetOrder(1)
	if dbseek(FWxFilial("SA4")+Alltrim(_cCodTra))
		_cNome := SA4->A4_NOME
	endif

return(_cNome)

//Programa para preencher a descrição do produto
user function xRetSB1(_cCodPrd)

	local _cPrd := ""

	DbSelectArea("SB1")
	DbSetOrder(1)
	if dbseek(FWxFilial("SB1")+Alltrim(_cCodPrd))
		_cPrd := SB1->B1_DESC
	endif

return(_cPrd)		

//Função criada para alimentar os capos abaixos no momento em que a nota é informada no campo NOTA REMESSA, através de validação de usuário
user function xRetSD2(_cNota,_cSerie,_cCli)

	local _cTrans := ""
	local _cQuery := ""
	local _cAliasx	:= GetNextAlias()
	local _cAliasy	:= GetNextAlias()

	_cQuery := "select * from " + RetSqlName("SF2") + " where f2_doc = '" + M->Z01_REMESS + "' and f2_serie = '200' and d_e_l_e_t_ <> '*'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), _cAliasx, .F., .T.)
	DbSelectArea(_cAliasx)
	(_cAliasx)->(DbGoTop())

	if !Empty((_cAliasx)->F2_TRANSP)
		_cTrans:= (_cAliasx)->F2_TRANSP
		M->Z01_DTENTR	:= Stod((_cAliasx)->F2_EMISSAO)
	else
		msgStop("Não consta na nota informada a transportadora!")
		M->Z01_REMESS := ""
	endif

	_cQuery := "select * from " + RetSqlName("SD2") + " where d2_doc = '" + M->Z01_REMESS + "' and d2_serie = '200' and d2_cod = '809351' and d_e_l_e_t_ <> '*'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), _cAliasy, .F., .T.)
	DbSelectArea(_cAliasy)
	(_cAliasy)->(DbGoTop())
/*
	dbSelectArea("SF4")
	dbSetOrder()
	if dbSeek(FWxFilial("SF4") + (_cAliasy)->D2_TES )
		if SF4->F4_PODER3 <> "R"
			MsgStop("A nota escolhida não é de REMESSA, por favor escolha uma nota de REMESSA")
			return(.F.)
		endif
	else
		return(.F.)
	endif
*/	
	dbSelectArea("SB1")
	dbSetorder(1)
	if dbSeek(FWxFilial("SB1") + (_cAliasy)->D2_COD)
		M->Z01_XPRCOD  	:= SB1->B1_COD
		M->Z01_DESCPR 	:= SB1->B1_DESC
	endif

	M->Z01_QUANT  	:= (_cAliasy)->D2_QUANT
	M->Z01_VLUNIT	:= (_cAliasy)->D2_PRCVEN
	M->Z01_VLTOTA	:= (_cAliasy)->D2_TOTAL

	dbSelectArea("SA4")
	dbSetOrder(1)
	if dbSeek(FwxFilial("SA4") + Alltrim(_cTrans))
		M->Z01_CODTRA	:= SA4->A4_COD
		M->Z01_TRANSP	:= SA4->A4_NOME
	endif

	(_cAliasy)->(dbCloseArea())
	(_cAliasx)->(dbCloseArea())

return(.T.)

//Programa utilizado para gerar titulos de NDF no contas a pagar.
user function gerandf(_cAlias,nRecno)
	
	local _nValor := 0
	local cTexto  := ""
	local _cYesNo := ""
	local _cForn  := ""
	
	//MsgAlert("Registro Z01--> "+Str(nrecno)) //teste para verificar o recno retornado

	DbSelectArea(_cAlias)
	DbGoTo(nRecno)
	cTexto := "Titulo gerado apartir do Pallet: " + Alltrim(Z01_CODIGO)
	if (_cAlias)->Z01_STATUS $ '7|3'

		if (_cAlias)->Z01_STATUS $ '7'
			_nValor := (_cAlias)->Z01_QTDREC * (_cAlias)->Z01_VLUNIT
			_cYesNo := "Será gerado um Titulo de NDF contra a transportadora: " + Chr(13) + Chr(10)
			_cYesNo +=  (_cAlias)->Z01_TRANSP + Chr(13) + Chr(10)
			_cYesNo += "No valor de R$: " + Transform(_nValor, "@E 999,999,999.99" ) + Chr(13) + Chr(10)
			_cYesNo += "DESEJA CONTINUAR?"
			if msgyesno(_cYesNo)
				_cForn := xSelFor(Alltrim((_cAlias)->Z01_CODTRA))

				if !Empty(_cForn)
					RecLock (_cAlias, .F.)
					(_cAlias)->Z01_STATUS := '8'								
					MsUnlock()
				else
					msgAlert("Fornecedor relativo a transportadora não informado, NDF não será gerado!")
					return
				endif
			else
				return()
			endif
		else
			_nValor := ((_cAlias)->Z01_QUANT - (_cAlias)->Z01_QTDREC) * (_cAlias)->Z01_VLUNIT
			_cYesNo := "Será gerado um Titulo de NDF contra a transportadora: " + Chr(13) + Chr(10)
			_cYesNo +=  (_cAlias)->Z01_TRANSP + Chr(13) + Chr(10)
			_cYesNo += "No valor de R$: " + Transform(_nValor, "@E 999,999,999.99" ) + Chr(13) + Chr(10)
			_cYesNo += "DESEJA CONTINUAR?"
			if msgyesno(_cYesNo)
				_cForn := xSelFor(Alltrim((_cAlias)->Z01_CODTRA))
				if !Empty(_cForn)
					RecLock (_cAlias, .F.)
					(_cAlias)->Z01_STATUS := '8'								
					MsUnlock()
				else
					msgAlert("Fornecedor relativo a transportadora não informado, NDF não será gerado!")
					return
				endif
			else
				return()
			endif
		endif				
		u_gerNdf("PAL","NDF","20408",_cForn,dDataBase,DataValida(dDataBase+15,.T.),DataValida(dDataBase+15,.T.),_nValor,cTexto)		
	else
		if (_cAlias)->Z01_STATUS $ '1|5'
			msgStop("O Pallet não foi conferido, nota de débito não será criada!")
		else
			if (_cAlias)->Z01_STATUS == '4|6'

				_nValor := (_cAlias)->Z01_QTDREC * (_cAlias)->Z01_VLUNIT 
				_cYesNo := "Será gerado um Titulo de NDF contra a transportadora: " + Chr(13) + Chr(10)
				_cYesNo +=  (_cAlias)->Z01_TRANSP + Chr(13) + Chr(10)
				_cYesNo += "No valor de R$: " + Transform(_nValor, "@E 999,999,999.99" ) + Chr(13) + Chr(10)
				_cYesNo += "DESEJA CONTINUAR?"
				if msgyesno(_cYesNo)
					_cForn := xSelFor(Alltrim((_cAlias)->Z01_CODTRA))
					if !Empty(_cForn)
						RecLock (_cAlias, .F.)
						(_cAlias)->Z01_STATUS := '8'								
						MsUnlock()
					else
						msgAlert("Fornecedor relativo a transportadora não informado, NDF não será gerado!")
						return
					endif
				else
					return()
				endif
				u_gerNdf("PAL","NDF","20408",_cForn,dDataBase,DataValida(dDataBase+15,.T.),DataValida(dDataBase+15,.T.),_nValor,cTexto)
			else
				msgStop("O Pallet não possue divergência, nota de débito não será criada!")
			endif	
		endif
	endif

return

//Programa complementar ao gerandf para executar o execauto com as informações OK.
user function gerNdf(_cPre,_cTipo,_cNaturez,_cForn,_dEmissao,_dVencto,_dVenctoR,_nValor,_cTxtPal)

    Local cError     := ''
	local aArray 		:= {}
	private lMsErroAuto := .F.

	dbSelectArea("Z01")

	aArray := { { "E2_PREFIXO"  , _cPre         			, NIL },;
	{ "E2_NUM"      , Alltrim(Z01->Z01_CODIGO), NIL },;
	{ "E2_TIPO"     , _cTipo        			, NIL },;
	{ "E2_NATUREZ"  , _cNaturez     			, NIL },;
	{ "E2_FORNECE"  , _cForn        			, NIL },;
	{ "E2_EMISSAO"  , _dEmissao					, NIL },;
	{ "E2_VENCTO"   , _dVencto					, NIL },;
	{ "E2_VENCREA"  , _dVenctoR					, NIL },;	
	{ "E2_VALOR"    , _nValor     				, NIL },;
	{ "E2_HIST"  	, _cTxtPal					, NIL }}

	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

	if lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	else		
		if Reclock("Z01",.F.)
			Z01->Z01_PRETIT := "PAL"
			Z01->Z01_NUMTIT := SE2->E2_NUM
			Z01->Z01_TPNDF := "NDF"
		endif
		Alert("Título NDF gerado com sucesso!")
	endif

return

//Programa utilizado para visualizar a NDF quando o foco estiver posicionado em determinado Pallet na Browser principal.
user function VisNDF(_cAlias,_nReg,_nOpc)

	dbSelectArea(_cAlias)
	dbGoTo(_nReg)

	dbSelectArea("SE2")
	dbSetOrder(1)

	if dbSeek((_cAlias)->Z01_FILIAL + (_cAlias)->Z01_PRETIT + (_cAlias)->Z01_NUMTIT )
		//Fa050Visua( "SE2",SE2->(RECNO()),2)
		AxVisual("SE2",SE2->(RECNO()),2)
	else
		MsgStop("Não foi encontrado titulo NDF para o Pallet selecionado!")
	endif

return

//Programa criado para que o usuário informe qual o fornecedor atrelado a transportadora para gerar o NDF.
static function xSelFor(_cCodTransp)
	local oFWLayer		:= nil
	local oDlgPrinc 	:= nil
	local oPanelU1 		:= nil
	local oPanelU2 		:= nil
	local oTBtnBmp1 	:= nil
	local _cAliasx		:= GetNextAlias()
	local _cQuery		:= ""
	local _cForn        := ""
	local _aVetBrw4		:= {}

	_cQuery := " SELECT A2_COD,"
	_cQuery += " 		A2_NOME," 
	_cQuery += " 		A4_COD," 
	_cQuery += " 		A4_NOME" 
	_cQuery += " 	FROM " + RetSqlName("SA4") + " SA4" 
	_cQuery += " 	INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_NOME = SA4.A4_NOME AND SA2.D_E_L_E_T_ <> '*'"
	_cQuery += " 	WHERE SA4.A4_COD = '" + Alltrim(_cCodTransp) + "' AND SA4.D_E_L_E_T_ <> '*'" 
	_cQuery += " ORDER BY A2_COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), _cAliasx, .F., .T.)
	DbSelectArea(_cAliasx)
	(_cAliasx)->(DbGoTop())

	while (_cAliasx)->(!eof())
		aAdd(_aVetBrw4,{(_cAliasx)->A2_COD,;
		(_cAliasx)->A2_NOME})
		(_cAliasx)->(dbSkip())						
	enddo

	if len(_aVetBrw4) > 0
		DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 400,500 PIXEL TITLE "Selecionar Fornecedor para NDF"

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001","Selecione o Fornecedor",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark4:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark4:SetArray(_aVetBrw4)

		oMark4:AddColumn(TCColumn():New("Cod. Fornecedor"	,{||_aVetBrw4[oMark4:nAt,01]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark4:AddColumn(TCColumn():New("Razão Fornecedor"	,{||_aVetBrw4[oMark4:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))	

		oMark4:Align := CONTROL_ALIGN_ALLCLIENT
		oMark4:bWhen := { || Len(_aVetBrw4) > 0 }

		oTBtnBmp1 	:=  TButton():New( 01,002, "Processa",oPanelU2,{||xSelFor2(_aVetBrw4[oMark4:nAt,01],@_cForn),oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlgPrinc CENTERED
	else	
		MsgAlert("Verifique com o depto de cadastro, pois não foi encontrado cadastro de fornecedor para a transportadora informa.")
		Return(_cForn)
	endif	

return(_cForn)

//Programa complentar a função xSelFor()
static function xSelFor2(_cCodTransp,_cForn)

	_cForn := _cCodTransp

return

//Programa criado para buscar as notas de remessas relacionadas a transportadora, emissão e produto relacionado ao pallet.
user function XADDNF2(_cAlias,_nRecno,_cCodTran,_cPrdPal,_cRotina,_cDataDe,_cDataAte,_cTransp,_cCodPal) 

	local aClone 	:= aClone(aRotina)
	local oColumn	:= nil
	local aCampos	:= {}
	local _aVet		:= {}
	local aColumns	:= {}
	local cArqTrb	:= ""
	local _cQuery   := ""
	local _cAliasB  := iif(_cRotina == "YADDNF", "Z03","Z02")
	local _cAliasx	:= GetNextAlias()
	local cIndice1, cIndice2, cIndice3,cIndice4 := ""
	local nX		:= 0
	local nX2 		:= 0
	local _nPos     := 0
	local lMarcar  	:= .F.
	local aSeek   	:= {}
	local bKeyF12	:= {||  U_MCFG006M(),oBrowse:SetInvert(.F.),oBrowse:Refresh(),oBrowse:GoTop(.T.) } //Programar a tecla F12
	private _xAlias := _cAlias
	private _xRecno := _nRecno
	private oMark2 	:= nil
	private _nQuant	:= 0
	private	_nValx  := 0
	private	_nValTot:= 0

	aRotina := {}

	AAdd(aRotina,{"Visualizar Notas do Pallet","u_viewz02",0,5})
	//AAdd(aRotina,{"Adicionar Selecionados","u_xAddSel1",0,2})

	//Criar a tabela temporária
	AAdd(aCampos,{"F2_OK"  	,"C",002,0}) //Este campo será usado para marcar/desmarcar

	DbSelectArea("SX3")//ABRE A TABELA
	DbSetOrder(1) //ARQUIVO+ORDEM
	DbSeek("SF2") //PESQUISA NA TABELA
	while SX3->X3_ARQUIVO == "SF2" .and. SX3->(!Eof())
		if Alltrim(SX3->X3_CAMPO) $ "F2_FILIAL|F2_DOC|F2_CLIENTE|F2_LOJA|F2_EMISSAO|F2_SERIE"
			if Alltrim(SX3->X3_CAMPO) == "F2_CLIENTE"
				AAdd(aCampos,{SX3->X3_CAMPO  	,SX3->X3_TIPO,SX3->X3_TAMANHO,0}) //Este campo será usado para marcar/desmarcar
				AAdd(aCampos,{"F2_NOME"  	,"C",40,0}) //Este campo será usado para marcar/desmarcar
			else
				AAdd(aCampos,{SX3->X3_CAMPO  	,SX3->X3_TIPO,SX3->X3_TAMANHO,0}) //Este campo será usado para marcar/desmarcar
			endif
		endif
		SX3->(DbSkip())
	end

	if _cRotina == "YADDNF"
		AAdd(aCampos,{"F2_QUANT"  	,"N",16,4})
		AAdd(aCampos,{"F2_PRCVEN"  	,"N",16,4})
		AAdd(aCampos,{"F2_TOTAL"  	,"N",16,4})
	endif

	If (Select("TRB") > 0)
		dbSelectArea("TRB")
		TRB->(dbCloseArea ())
	Endif

	cArqTrb   := CriaTrab(aCampos,.T.)

	//Criar indices
	cIndice1 := Alltrim(CriaTrab(,.F.))
	cIndice2 := cIndice1
	cIndice3 := cIndice1

	cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
	cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"
	cIndice3 := Left(cIndice3,5) + Right(cIndice3,2) + "C"

	//Se indice existir excluir
	if File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	endif

	if File(cIndice2+OrdBagExt())
		FErase(cIndice2+OrdBagExt())
	endif

	if File(cIndice3+OrdBagExt())
		FErase(cIndice3+OrdBagExt())
	endif

	//A função dbUseArea abre uma tabela de dados na área de trabalho atual ou na primeira área de trabalho disponível
	dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)

	//A função IndRegua cria um índice temporário para o alias especificado, podendo ou não ter um filtro
	IndRegua("TRB", cIndice1, "F2_DOC"	,,, "Indice Nota Fiscal...")
	IndRegua("TRB", cIndice2, "F2_CLIENTE",,, "Indice Cod.Cliente...")
	IndRegua("TRB", cIndice3, "F2_EMISSAO",,, "Indice Emissão da Nota...") 

	//Fecha todos os índices da área de trabalho corrente.
	dbClearIndex()

	//Acrescenta uma ou mais ordens de determinado índice de ordens ativas da área de trabalho.
	dbSetIndex(cIndice1+OrdBagExt())
	dbSetIndex(cIndice2+OrdBagExt())
	dbSetIndex(cIndice3+OrdBagExt())

	if _cRotina <> "YADDNF"
		//Popular tabela temporária, irei colocar apenas um unico registro
		_cQuery := " SELECT DISTINCT F2_FILIAL, F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_TRANSP"
		_cQuery += "	FROM " + RetSqlName("SF2") + " SF2 WHERE SF2.F2_FILIAL = " + FWxFilial("SF2") + " AND SF2.D_E_L_E_T_ <> '*' AND SF2.F2_TRANSP = '" + _cCodTran + "' AND SF2.F2_EMISSAO BETWEEN '" + _cDataDe + "' AND '" + _cDataAte + "'"
		_cQuery += " ORDER BY F2_DOC,F2_SERIE"
	else
		//Popular tabela temporária, irei colocar apenas um unico registro
		_cQuery := " SELECT DISTINCT F2_FILIAL, F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_TRANSP, D2_TES,D2_QUANT,D2_TOTAL,D2_PRCVEN" 
		_cQuery += "	FROM " + RetSqlName("SD2") + " SD2" 
		_cQuery += "	INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_DOC = SF2.F2_DOC AND SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_EMISSAO BETWEEN '" + _cDataDe + "' AND '" + _cDataAte + "' AND SF2.F2_TRANSP = '" + Alltrim(_cTransp) + "' AND SF2.D_E_L_E_T_ <> '*'"
		//_cQuery += "	INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_PODER3 = 'R' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ <> '*'"
		_cQuery += "	WHERE SD2.D2_FILIAL = '" + FWxFilial("SD2") + "' AND SD2.D2_COD = '" + Alltrim(_cPrdPal) + "' AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D_E_L_E_T_ <> '*'"
		_cQuery += " ORDER BY F2_DOC,F2_SERIE"
	endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), _cAliasx, .F., .T.)
	DbSelectArea(_cAliasX)
	(_cAliasx)->(DbGoTop())

	while (_cAliasx)->(!eof())

		DbSelectArea(_cAliasB)
		dbSetOrder(2) //Z03_FILIAL+Z03_NFCLI+Z03_NFSERI+Z03_NFFIL
		if !dbSeek(FWxFilial(_cAliasB)  + (_cAliasX)->F2_DOC + (_cAliasX)->F2_SERIE + (_cAliasX)->F2_FILIAL) //Bruno Tamanaka - INC0038427 - 2019/02/25

			if RecLock("TRB",.t.)
				TRB->F2_OK    	:= "  "
				TRB->F2_FILIAL	:= (_cAliasx)->F2_FILIAL
				TRB->F2_DOC 	:= (_cAliasx)->F2_DOC
				TRB->F2_SERIE 	:= (_cAliasx)->F2_SERIE
				TRB->F2_CLIENTE := (_cAliasx)->F2_CLIENTE
				TRB->F2_NOME    := POSICIONE("SA1", 1, xFilial("SA1") + (_cAliasx)->F2_CLIENTE + (_cAliasx)->F2_LOJA, "A1_NOME")
				TRB->F2_LOJA 	:= (_cAliasx)->F2_LOJA
				TRB->F2_EMISSAO := Stod((_cAliasx)->F2_EMISSAO)

				if _cRotina == "YADDNF"
					TRB->F2_QUANT	:= (_cAliasx)->D2_QUANT
					TRB->F2_PRCVEN	:= (_cAliasx)->D2_PRCVEN
					TRB->F2_TOTAL	:= (_cAliasx)->D2_TOTAL
				endif

				MsUnLock()
			endif
		endif		
		(_cAliasx)->(dbSkip())						
	enddo

	TRB->(DbGoTop())

	if TRB->(!Eof())
		//Irei criar a pesquisa que será apresentada na tela
		aAdd(aSeek,{"Nota Fiscal"	,{{"","C",009,0,"Nota Fiscal"	,"@!"}} } )
		aAdd(aSeek,{"Cliente"		,{{"","C",040,0,"Cliente"		,"@!"}} } )
		aAdd(aSeek,{"Emissão"		,{{"","D",8,0,"Emissão"			,""}} } )
		//Agora iremos usar a classe FWMarkBrowse
		oMark2:= FWMarkBrowse():New()
		oMark2:SetDescription(cCadastro) //Titulo da Janela
		oMark2:SetParam(bKeyF12) // Seta tecla F12
		oMark2:SetAlias("TRB") //Indica o alias da tabela que será utilizada no Browse
		oMark2:SetFieldMark("F2_OK") //Indica o campo que deverá ser atualizado com a marca no registro
		oMark2:SetDBFFilter(.T.)
		oMark2:SetUseFilter(.T.) //Habilita a utilização do filtro no Browse
		oMark2:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
		oMark2:SetTemporary() //Indica que o Browse utiliza tabela temporária
		oMark2:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
		oMark2:SetFilterDefault("") //Indica o filtro padrão do Browse
		//Adiciona uma coluna no Browse em tempo de execução
		oMark2:SetColumns(MIT613CFGT("F2_FILIAL"	,"Filial NF"	,04,"@!",1,04,0))
		oMark2:SetColumns(MIT613CFGT("F2_DOC"	,"Num. Nota"	,09,"@!",1,09,0))
		oMark2:SetColumns(MIT613CFGT("F2_SERIE"	,"Serie Nota"	,03,"@!",1,03,0))
		oMark2:SetColumns(MIT613CFGT("F2_CLIENTE","Cod. Cliente"	,10,"@!",1,10,0))
		oMark2:SetColumns(MIT613CFGT("F2_LOJA"	,"Loja Cliente"	,02,""  ,1,02,0))
		oMark2:SetColumns(MIT613CFGT("F2_NOME"	,"Razão"		,40,"@!",1,40,0))
		oMark2:SetColumns(MIT613CFGT("F2_EMISSAO","Emissão"		,08,""  ,1,08,0))

		if _cRotina == "YADDNF"
			oMark2:SetColumns(MIT613CFGT("F2_QUANT"	,"Quantidade de Pallets"	,16,""  ,1,16,2))
			oMark2:SetColumns(MIT613CFGT("F2_PRCVEN"	,"Valor do Pallets"	,16,""  ,1,16,2))
			oMark2:SetColumns(MIT613CFGT("F2_TOTAL"	,"Valor Total do Pallets"	,16,""  ,1,16,2))
		endif

		//Adiciona botoes na janela
		oMark2:AddButton("Adicionar Notas"		, { || MsgRun('Adicionando Notas ao Pallet','Processando',{|| U_xAddSel1(_cRotina,_cTransp,_cPrdPal,M->Z01_CODIGO) }) },,,, .F., 2 )
		//Indica o Code-Block executado no clique do header da coluna de marca/desmarca
		oMark2:bAllMark := { || MT613Inv(oMark2:Mark(),lMarcar := !lMarcar ), oMark2:Refresh(.T.)  }
		//Método de ativação da classe
		oMark2:Activate()
	else
		MsgAlert("Não existem notas a serem exibidas com os parametros informados!")
		Return
	endif
	//Limpar o arquivo temporário
	if !empty(cArqTrb)
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		cArqTrb := ""
		TRB->(DbCloseArea())
	endif

	aRotina := {}
	aRotina := aClone(aClone)

return

//Função para marcar/desmarcar todos os registros do grid
static function MT613Inv(cMarca,lMarcar)

	local cAliasSF2 := 'TRB'
	local aAreaSF2  := (cAliasSF2)->( GetArea() )

	dbSelectArea(cAliasSF2)
	(cAliasSF2)->( dbGoTop() )
	while !(cAliasSF2)->( Eof() )

		RecLock( (cAliasSF2), .F. )
		(cAliasSF2)->F2_OK := IIf( lMarcar, cMarca, '  ' )
		MsUnlock()

		(cAliasSF2)->( dbSkip() )

	end

	RestArea( aAreaSF2 )

return .T.

//Função para criar as colunas do grid
Static Function MIT613CFGT(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)

	local aColumn
	local bData 	:= {||}
	default nAlign 	:= 1
	default nSize 	:= 20
	default nDecimal:= 0
	default nArrData:= 0  

	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&amp;("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}

user function xAddSel1(_cRotina,_cCodTran,_cCodPrd,_cCodPal)

	local cMarca   := oMark2:Mark()
	local lInverte := oMark2:IsInvert()
	local nCt      := 0
	local _cAlias  := "TRB"
	local _cTxt    := ""
	local _cTxt2   := ""
	local _aCheck  := {}
	local nx		:= 0
	local _nPos		:= 0
	local _nQuant   := 0
	local _nValor   := 0

	dbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())

	while !(_cAlias)->(EoF())
		//Caso esteja marcado, aumenta o contador

		if !Empty((_cAlias)->F2_OK)
			nCt++

			if _cRotina <> "YADDNF"
				dbSelectArea(_xAlias)
				dbGoTo(_xRecno)

				RecLock('Z02', .T.)

				Z02_FILIAL 	:= 	FWxFilial("Z02")
			//  Z02_PALLET  :=  Alltrim(_cCodPal)  //wagner
				Z02_PALLET 	:= 	Alltrim(Z01->Z01_CODIGO) // wagner
				Z02_FILNF	:=	(_cAlias)->F2_FILIAL
				Z02_NFISCA	:= 	(_cAlias)->F2_DOC
				Z02_CODCLI	:= 	(_cAlias)->F2_CLIENTE
				Z02_NFSERI	:= 	(_cAlias)->F2_SERIE
				Z02_CLINOM	:=	(_cAlias)->F2_NOME	
				Z02_EMISSA	:= 	(_cAlias)->F2_EMISSAO
				MsUnlock()
			else
				RecLock('Z03', .T.)
				Z03_FILIAL 	:= 	FWxFilial("Z03")
				Z03_STATUS 	:= "1"
				Z03_CODPAL 	:= Alltrim(_cCodPal)
				Z03_CODTRA  := Alltrim(_cCodTran)
				Z03_CODCLI 	:= (_cAlias)->F2_CLIENTE
				Z03_NFCLI  	:= (_cAlias)->F2_DOC
				Z03_NFSERI 	:= (_cAlias)->F2_SERIE
				Z03_QUANT   := (_cAlias)->F2_QUANT
				Z03_NFFIL   := (_cAlias)->F2_FILIAL
				MsUnlock()

				_nQuant := (_cAlias)->F2_QUANT + _nQuant 
				_nValor := (_cAlias)->F2_TOTAL + _nValor

			endif
			//Limpando a marca
			RecLock((_cAlias), .F.)
			(_cAlias)->(dbDelete())
			(_cAlias)->(MsUnlock())
			//endif
		endif

		//Pulando registro
		(_cAlias)->(DbSkip())
	enddo
	//Mostrando a mensagem de registros marcados

	if _cRotina <> "YADDNF"
		MsgInfo('Foram adicionados <b>' + cValToChar( nCt ) + ' notas de produto ao pallet: ' + (_xAlias)->Z01_CODIGO + '</b>.', "Atenção")		
	else
		M->Z01_CODTRA := Alltrim(_cCodTran) 
		M->Z01_TRANSP := u_xRetSA4(Alltrim(_cCodTran))		
		M->Z01_XPRCOD := Alltrim(_cCodPrd)
		M->Z01_DESCPR := u_xRetSB1(Alltrim(_cCodPrd))
		M->Z01_QUANT  := _nQuant 
		M->Z01_VLUNIT := _nValor/_nQuant
		M->Z01_VLTOTA := _nValor	
		M->Z01_VALBON := _nValor
		M->Z01_DTENTR := dDataBase 
		MsgInfo('Foram adicionados <b>' + cValToChar( nCt ) + ' notas de remessa ao pallet: ' + M->Z01_CODIGO + '</b>.', "Atenção")
		oMark2:Refresh(.T.)
	endif

return

//Função criada para visualizar as notas atreladas ao pallet, bem como exclusão 
//das mesmas quando o status for 1 na tabela z01, dependendo de onde foi a chamada da função. 
user function viewz02(_xAlias,nRecno)

	local oFWLayer		:= nil
	local oDlgPrinc 	:= nil
	local oPanelU1 		:= nil
	local oPanelU2 		:= nil
	local oTBtnBmp1 	:= nil
	local oTBtnBmp2 	:= nil
	local _cAlias		:= ""
	private oMark 		:= nil
	private _aVetBrw 	:= {}
	private oOk  		:= LoadBitMap(GetResources(), "LBOK")
	private oNo     	:= LoadBitMap(GetResources(), "LBNO")

	if  ISINCALLSTACK('U_zVPallet' )
		_cAlias := "Z03"
		_nXRec  := nRecno
	else
		_cAlias := "Z02"
	endif

	DbSelectArea(_xAlias)
	dbGoTo(nRecno)

	DbSelectArea(_cAlias)
	DbSetOrder(1)
	If dbSeek(FWxFilial(_cAlias) + (_xAlias)->Z01_CODIGO)
		//(_cAlias)->(DbGoTop()) 
		if !ISINCALLSTACK( 'U_zVPallet' )
			while (_cAlias)->(!Eof()) .and. (_cAlias)->Z02_PALLET == (_xAlias)->Z01_CODIGO

				aAdd(_aVetBrw,{.F.,;
				(_cAlias)->Z02_FILIAL,;
				(_cAlias)->Z02_PALLET,;
				(_cAlias)->Z02_FILNF,;
				Dtoc((_cAlias)->Z02_EMISSAO),;			
				(_cAlias)->Z02_NFISCA,;
				(_cAlias)->Z02_NFSERI,;
				(_cAlias)->Z02_CODCLI,;
				(_cAlias)->Z02_CLINOM})

				(_cAlias)->(DbSkip())	
			enddo
		else
			while (_cAlias)->(!Eof()) .and. (_cAlias)->Z03_CODPAL == (_xAlias)->Z01_CODIGO
				
				//wagner - somente filial posicionada Z01
				if (_cAlias)->Z03_NFFIL <> (_xAlias)->Z01_FILIAL
					(_cAlias)->(DbSkip())		
					Loop
				Endif
				//wagner eof			
				
				if (_cAlias)->Z03_QUANT > (_cAlias)->Z03_QDRET 
					aAdd(_aVetBrw,{(_cAlias)->Z03_FILIAL,;
					(_cAlias)->Z03_CODPAL,;
					(_cAlias)->Z03_NFFIL,;			
					(_cAlias)->Z03_NFCLI,;
					(_cAlias)->Z03_NFSERI,;
					(_cAlias)->Z03_CODCLI})
				endif
				(_cAlias)->(DbSkip())	
			enddo
		endif
	EndIf

	if Len(_aVetBrw) > 0
		DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 500,900 PIXEL TITLE "Notas Fiscais Adicionadas ao Pallet"

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001","Notas Adionadas",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark:SetArray(_aVetBrw)

		if !ISINCALLSTACK( 'U_zVPallet' )
			oMark:AddColumn(TCColumn():New(""					,{|| If(_aVetBrw[oMark:nAt,01],oOk,oNo) },,,,"LEFT",,.T.,.F.,,,,,))			
			oMark:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw[oMark:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Filial NF"			,{||_aVetBrw[oMark:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Nota Fiscal"		,{||_aVetBrw[oMark:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))	
			oMark:AddColumn(TCColumn():New("Serie Nota"			,{||_aVetBrw[oMark:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Emissão"			,{||_aVetBrw[oMark:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Cod. Cliente"		,{||_aVetBrw[oMark:nAt,08]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Nome Cliente"		,{||_aVetBrw[oMark:nAt,09]},,,,"LEFT",,.F.,.F.,,,,,))
		else			
			oMark:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw[oMark:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Filial NF"			,{||_aVetBrw[oMark:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Nota Fiscal"		,{||_aVetBrw[oMark:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))	
			oMark:AddColumn(TCColumn():New("Serie Nota"			,{||_aVetBrw[oMark:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark:AddColumn(TCColumn():New("Cod. Cliente"		,{||_aVetBrw[oMark:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))
		endif

		oMark:Align := CONTROL_ALIGN_ALLCLIENT
		oMark:bWhen := { || Len(_aVetBrw) > 0 }

		if !ISINCALLSTACK( 'U_zVPallet' ) 
			oMark:bLDblClick := { || EditaVet(@_aVetBrw,@oMark)}
			oMark:bHeaderClick := { || fSelectAll() }
			oTBtnBmp1	:=  TButton():New( 01,002, "Excluir Notas",oPanelU2,{||MsgRun("Aguarde...","Deletando selecionados...",{|| delz02() })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )			
		else
			oTBtnBmp1	:=  TButton():New( 01,002, "Receber Vale Pallet",oPanelU2,{||MsgRun("Aguarde...","Processando...",{|| xRecPal(_aVetBrw[oMark:nAt,02],_aVetBrw[oMark:nAt,04],_aVetBrw[oMark:nAt,05],_aVetBrw[oMark:nAt,03])})},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		endif		

		oTBtnBmp2 	:=  TButton():New( 20,002, "Sair",oPanelU2,{||oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlgPrinc CENTERED
	else
		if ISINCALLSTACK( 'U_zVPallet' )
			if (_xAlias)->Z01_STATUS == '2'
				msgStop("Este vale pallet já foi totalmente recebido!")
			else
				msgStop("Para receber Vale Pallet você precisa adicionar as notas dos clientes relacionadas a este Pallet!")
			endif	
		else
			msgStop("Não existem notas atreladas a este Pallet!")
		endif
	endif	

return

user function viewz03(_xAlias,nRecno)

	local oFWLayer		:= nil
	local oDlgPrinc 	:= nil
	local oPanelU1 		:= nil
	local oPanelU2 		:= nil
	local oTBtnBmp1 	:= nil
	local oTBtnBmp2 	:= nil
	local _cAlias		:= ""
	private oMark3 		:= nil
	private _aVetBrw2 	:= {}
	private oOk  		:= LoadBitMap(GetResources(), "LBOK")
	private oNo     	:= LoadBitMap(GetResources(), "LBNO")

	_cAlias := "Z03"

	DbSelectArea(_xAlias)
	dbGoTo(nRecno)

	DbSelectArea(_cAlias)
	DbSetOrder(1)
	if dbSeek(FWxFilial(_cAlias) + (_xAlias)->Z01_CODIGO)
		while (_cAlias)->(!Eof()) .and. (_cAlias)->Z03_CODPAL == (_xAlias)->Z01_CODIGO 

			//wagner - somente filial posicionada Z01
			if (_cAlias)->Z03_NFFIL <> Z01->Z01_FILIAL
				(_cAlias)->(DbSkip())		
				Loop
			Endif
			//wagner eof

			if (_xAlias)->Z01_STATUS == '1'
				aAdd(_aVetBrw2,{.F.,;
				(_cAlias)->Z03_CODPAL,;
				(_cAlias)->Z03_NFFIL,;			
				(_cAlias)->Z03_NFCLI,;
				(_cAlias)->Z03_NFSERI,;
				(_cAlias)->Z03_CODCLI,;
				Transform((_cAlias)->Z03_QUANT, "@E 999,999.99" ),;
				Transform((_cAlias)->Z03_QDRET, "@E 999,999.99" )})
			else
				aAdd(_aVetBrw2,{(_cAlias)->Z03_CODPAL,;
				(_cAlias)->Z03_NFFIL,;			
				(_cAlias)->Z03_NFCLI,;
				(_cAlias)->Z03_NFSERI,;
				(_cAlias)->Z03_CODCLI,;
				Transform((_cAlias)->Z03_QUANT, "@E 999,999.99" ),;
				Transform((_cAlias)->Z03_QDRET, "@E 999,999.99" )})			
			endif
			(_cAlias)->(DbSkip())	
		enddo
	endif

	if Len(_aVetBrw2) > 0
		DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 500,1000 PIXEL TITLE "Notas de Remessa Adicionadas ao Pallet"

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001","Notas Adicionadas",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark3:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark3:SetArray(_aVetBrw2)
		if (_xAlias)->Z01_STATUS == '1'
			oMark3:AddColumn(TCColumn():New(""					,{|| If(_aVetBrw2[oMark3:nAt,01],oOk,oNo) },,,,"LEFT",,.T.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw2[oMark3:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Filial NF"			,{||_aVetBrw2[oMark3:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Nota Fiscal"		,{||_aVetBrw2[oMark3:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))	
			oMark3:AddColumn(TCColumn():New("Serie Nota"		,{||_aVetBrw2[oMark3:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Cod. Cliente"		,{||_aVetBrw2[oMark3:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Qtde Enviada"		,{||_aVetBrw2[oMark3:nAt,07]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Qtde Recebida"		,{||_aVetBrw2[oMark3:nAt,08]},,,,"LEFT",,.F.,.F.,,,,,))
		else
			oMark3:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw2[oMark3:nAt,01]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Filial NF"			,{||_aVetBrw2[oMark3:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Nota Fiscal"		,{||_aVetBrw2[oMark3:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))	
			oMark3:AddColumn(TCColumn():New("Serie Nota"		,{||_aVetBrw2[oMark3:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Cod. Cliente"		,{||_aVetBrw2[oMark3:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Qtde Enviada"		,{||_aVetBrw2[oMark3:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))
			oMark3:AddColumn(TCColumn():New("Qtde Recebida"		,{||_aVetBrw2[oMark3:nAt,07]},,,,"LEFT",,.F.,.F.,,,,,))

		endif
		oMark3:Align := CONTROL_ALIGN_ALLCLIENT
		oMark3:bWhen := { || Len(_aVetBrw2) > 0 }
		
		//WAGNER - INCLUSAO IF
		if (_xAlias)->Z01_STATUS == '1' 
			oMark3:bLDblClick := { || EditaVet(@_aVetBrw2,@oMark3)}
			oMark3:bHeaderClick := { || fSelectAll() }
		ENDIF
		
		if (_xAlias)->Z01_STATUS == '1'
			oTBtnBmp1	:=  TButton():New( 01,002, "Excluir Notas",oPanelU2,{||MsgRun("Aguarde...","Deletando selecionados...",{|| delz03() })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )			
			oTBtnBmp2 	:=  TButton():New( 20,002, "Sair",oPanelU2,{||oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		else
			oTBtnBmp1	:=  TButton():New( 01,002, "Sair",oPanelU2,{||oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )			
		endif
		ACTIVATE MSDIALOG oDlgPrinc CENTERED
	else
		msgStop("Não existem notas de remessa atreladas a este Pallet!")
	endif	

return

static function xRecPal(_cCodPal,_cNota,_cSerie,_cFilial)

	local _nRecno := 0

	dbSelectArea("Z03")
	dbSetOrder(1)
	if dbSeek(FWxFilial("Z03") + _cCodPal + _cNota + _cSerie)
		_nRecno := Z03->(RECNO())
		u_MIT6312("Z03",_nRecno,10)
	endif

return

//Função para deletar dados
static function delz02()

	local nX := 0
	local _aNum := {}
	local _lPassei := .F.
	local _cAlias := "Z02"
	local aClVet := aClone(_aVetBrw)

	for nX := 1 to Len (_aVetBrw)
		if _aVetBrw[nX][1]

			aadd(_aNum,{nX})
			_lPassei := .T.
			DbSelectArea(_cAlias)
			dbSetOrder(1)

			if dbSeek(FWxFilial(_cAlias) + _aVetBrw[nX][3] + _aVetBrw[nX][6])// + _aVetBrw[nX][4] + _aVetBrw[nX][7])

				RecLock((_cAlias),.F.)
				(_cAlias)->(DbDelete())
				MsUnlock()

				_nPos := aScan(aClVet,{|x| AllTrim(x[3])== Alltrim(_aVetBrw[nX][3]) .and. AllTrim(x[6])== Alltrim(_aVetBrw[nX][6])})

				ADEL(aClVet, _nPos)
				aSize(aClVet,Len(aClVet)-1)
			endif

		endIf

	next nX

	_aVetBrw := {}
	_aVetBrw := aClone(aClVet)

	if !_lPassei
		msgAlert("Nenhum registro foi marcado para deleção!")
	else
		oMark:SetArray(_aVetBrw)
		oMark:Refresh()
	endif	

return

static function delz03()

	local nX := 0
	local _aNum := {}
	local _lPassei := .F.
	local _cAlias := "Z03"
	local aClVet := aClone(_aVetBrw2)

	for nX := 1 to Len (_aVetBrw2)
		if _aVetBrw2[nX][1]

			aadd(_aNum,{nX})
			_lPassei := .T.
			DbSelectArea(_cAlias)
			dbSetOrder(1)

			if dbSeek(FWxFilial(_cAlias) + _aVetBrw2[nX][2] + _aVetBrw2[nX][4] + _aVetBrw2[nX][5])// + _aVetBrw[nX][4] + _aVetBrw[nX][7])

				RecLock((_cAlias),.F.)
				(_cAlias)->(DbDelete())
				MsUnlock()
				//Wagner - Ao excluir uma nota do pallet abate o valor no z01
				//if msgyesno("Deseja abater valores do registro principal ?")
					RecLock("Z01",.F.)
					Z01->Z01_QTDENV := Z01->Z01_QTDENV - (_cAlias)->Z03_QUANT
					Z01->Z01_QUANT  := Z01->Z01_QUANT - (_cAlias)->Z03_QUANT
					Z01->Z01_VLTOTA := Z01->Z01_QUANT * Z01->Z01_VLUNIT
					Z01->Z01_VALBON := Z01->Z01_QUANT * Z01->Z01_VLUNIT
					Z01->(MsUnlock())
					// eof wagner
				//endif
				_nPos := aScan(aClVet,{|x| AllTrim(x[4])== Alltrim(_aVetBrw2[nX][4]) .and. AllTrim(x[5])== Alltrim(_aVetBrw2[nX][5])})

				ADEL(aClVet, _nPos)
				aSize(aClVet,Len(aClVet)-1)
			endif

		endIf

	next nX

	_aVetBrw2 := {}
	_aVetBrw2 := aClone(aClVet)

	if !_lPassei
		msgAlert("Nenhum registro foi marcado para deleção!")
	else
		oMark3:SetArray(_aVetBrw2)
		oMark3:Refresh()
	endif	

return

static function EditaVet(_aVetBrw,oMark)

_aVetBrw[oMark:nAt,01] := !_aVetBrw[oMark:nAt,01] // essa linha já existia no fonte

// Inclusão Wagner Neves para tratamento do codigo que foi selecionado no browse do array
// estava dando erro de variavel nrecno nao encontrada ao acessar a função gerandf

	IF _aVetBrw[oMark:nAt,01] == .T. 
	
		_cCodBrw  := _aVetBrw[oMark:nAt,02] 
		_cSeqBrw  := oMark:nAt
		_cAreaZ01 := Z01->(GetArea())
	
		IF Z01->(DbSeek(xFilial("Z01")+_cCodBrw))
			wRecno := Z01->(Recno())
		ELSE
			wRecno := 0
		ENDIF
	
		RestArea(_cAreaZ01)

	ENDIF
// fim de alteração - Wagner

Return(wRecno)  // Inclusao da variáaval wrecno no retorno

user function xStatusZ01(_cOK)
	if _cOK <> 'OK'
		_cOK := ""
	endif	
	MsgRun("Aguarde...","Verificando status dos Pallets",{|| yStatusZ01(_cOK) })
return

static function yStatusZ01(_cOK)

	local oPanelU1		:= nil
	local oPanelU2		:= nil
	local oFWLayer		:= nil
	local oDlgPrinc 	:= nil
	local oMark			:= nil
	local oPanelU1 		:= nil
	local oPanelU2 		:= nil
	local oTBtnBmp1     := nil
	local oTBtnBmp2     := nil
	local _aVetx        := {}
	local oOk  			:= LoadBitMap(GetResources(), "LBOK")
	local oNo    	 	:= LoadBitMap(GetResources(), "LBNO")
	local _nQDiasFPRZ
	Public wRecno 		:= 0
	//------| Verifica existência de parâmetros e caso não exista cria. |-----------------
	If !ExisteSx6("MGF_QDFPRZ")
		CriarSX6("MGF_QDFPRZ", "N", "Qtde.dias para Pallets fora do prazo."	, '45' )	
	EndIf

	_nQDiasFPRZ	:= SUPERGETMV("MGF_QDFPRZ",,45)

	_cAliasZ01	:= GetNextAlias()	//Calcula valor da depreciacao no exercicio anterior
	BeginSql Alias _cAliasZ01
		COLUMN Z01_DTENTR AS DATE 

		SELECT 
			Z01.Z01_CODIGO, Z01.Z01_DTENTR, Z01.Z01_STATUS, TRUNC(SYSDATE - TO_DATE(Z01_DTENTR, 'YYYYMMDD')) DIFDATA
		FROM 
			%table:Z01% Z01
		WHERE         				
			Z01.Z01_FILIAL	= %exp:xFilial("Z01")%		AND 
			Z01.Z01_STATUS IN ('1','4','5','6','7')		AND
			TRUNC(SYSDATE - TO_DATE(Z01_DTENTR, 'YYYYMMDD')) > %exp:_nQDiasFPRZ% AND		
			Z01.%notDel% 		
		ORDER BY Z01_CODIGO
	EndSql

	While !(_cAliasZ01)->( Eof()) 
		aAdd(_aVetx,{.F., (_cAliasZ01)->Z01_CODIGO,DtoC((_cAliasZ01)->Z01_DTENTR),STR((_cAliasZ01)->DIFDATA)})
		dbSelectArea("Z01")
		dbSetOrder(1)
		If dbSeek(FWxFilial("Z01") + (_cAliasZ01)->Z01_CODIGO) .AND. !(_cAliasZ01)->Z01_STATUS $ '4|6' 
			Reclock("Z01", .F.)
			Z01_STATUS := '4'
			MsUnlock()
		EndIf
		(_cAliasZ01)->(DbSkip())
	EndDo

	if len(_aVetx) > 0		
		if!empty(_cOK)
			msgStop("Existem Pallets fora do prazo para retorno!")
		endif	

		DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 500,450 PIXEL TITLE "Pallet(s) com retorno fora do prazo com mais de "+ALLTRIM(STR(_nQDiasFPRZ))+" dias em atraso"

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001","Pallet(s) fora do prazo",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark:SetArray(_aVetx)
		oMark:AddColumn(TCColumn():New(""					,{|| If(_aVetx[oMark:nAt,01],oOk,oNo) },,,,"LEFT",,.T.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetx[oMark:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Emissão"			,{||_aVetx[oMark:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Dias de Atraso"		,{||_aVetx[oMark:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:Align := CONTROL_ALIGN_ALLCLIENT
		oMark:bWhen := { || Len(_aVetx) > 0 }
		oMark:bLDblClick := { || EditaVet(@_aVetx,@oMark)}
		oMark:bHeaderClick := { || fSelectAll() }
		
		//oTBtnBmp1	:=  TButton():New( 01,002, "Gerar NDF",oPanelU2,{||MsgRun("Aguarde...","Gerando NDF do(s) Pallet(s) selecionado(s)...",{|| gerandf("Z01",nrecno) })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )	
		oTBtnBmp1	:=  TButton():New( 01,002, "Gerar NDF",oPanelU2,{||MsgRun("Aguarde...","Gerando NDF do(s) Pallet(s) selecionado(s)...",{|| u_gerandf("Z01",wRecno) })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )	
		oTBtnBmp2 	:=  TButton():New( 20,002, "Sair",oPanelU2,{||oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlgPrinc CENTERED
	else
		if empty(_cOK)
			msgAlert("Não existem Pallets em atraso!")
		endif
	endif

return


//Função que gera o termo de responsabilidade para o motorista da transportadora
user function xRTermo(_cAlias,nRecno,nOpc)

	local cLocal 	:= ""
	local oPrint 	:= nil
	local _cTxtIni 	:= ""
	local _cPallet	:= ""
	local _cMotor	:= ""
	local _cCPF		:= ""
	local _cPlaca	:= ""
	local _cTransp  := ""
	local _cNFRemes := ""
	local _cRoteiro := ""
	local _cDTEmiNF := ""
	local _cQtdPal  := ""
	local _cNFs     := ""
	local nLinx		:= 0
	local _nContL	:= 0
	local nX		:= 0
	local oFont		:= TFont():New('Courier New',,18,,.T.)
	local oFont2	:= TFont():New('Courier New',,20,,.T.)
	local _lOk      := .F.
	local _lFirst   := .T.

	dbSelectArea(_cAlias)
	dbGoTo(nRecno)

	_cPallet	:= Alltrim((_cAlias)->Z01_CODIGO)
	_cMotor		:= Alltrim((_cAlias)->Z01_MOTOR) 
	_cCPF		:= Transform( Alltrim(Alltrim((_cAlias)->Z01_CPFM)), "@R 999.999.999-99" )  
	_cPlaca		:= Alltrim((_cAlias)->Z01_VEIC)  
	_cTransp  	:= Alltrim((_cAlias)->Z01_TRANSP)
	//_cNFRemes 	:= Alltrim((_cAlias)->Z01_REMESS)
	_cDTEmiNF 	:= Dtoc((_cAlias)->Z01_DTENTR)
	_cQtdPal  	:= Alltrim(Str((_cAlias)->Z01_QUANT)) 

	if Alltrim((_cAlias)->Z01_STATUS) $ '1|5'

		cLocal := cGetFile('','Selecione o diretorio para salvar o termo',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)

		dbSelectArea("Z03")
		dbSetOrder(1)
		if dbSeek(FWxFilial("Z03") + _cPallet)
			_lOk := .T.
			While Z03->(!eof()) .and. Z03->Z03_CODPAL == _cPallet
				if _lFirst
					_cNFs := Alltrim(Z03->Z03_NFCLI) + "/" + Alltrim(Z03->Z03_NFSERI)
					_lFirst := .F.
				else	 
					_cNFs += ", " + Alltrim(Z03->Z03_NFCLI) + "/" + Alltrim(Z03->Z03_NFSERI)
				endif
				Z03->(dbSkip())
			end
		endif

		if _lOk	

			oPrint := FWMSPrinter():New("Termo_de_Responsabilidade_" + Alltrim((_cAlias)->Z01_CODIGO) + ".rel", IMP_PDF, .T.,cLocal, .T., , , , , , .F., )//TMSPrinter():New("Termo de Responsabilidade")
			oPrint:SetPortrait()
			oPrint:StartPage()
			oPrint:SetPaperSize(9)

			//oPrint:SayBitmap(205,200,"\system\CabecalhoTermo.jpg",2000,281 )
			oPrint:SayBitmap(205,200,"\system\CabecalhoTermo.jpg",2000,281 )

			_cTxtIni := "TERMO DE RESPONSABILIDADE - Nº " + _cPallet

			oPrint:Say(350,700,_cTxtIni,oFont2,1400,CLR_BLACK,,0 )

			_cTxtIni := "Eu " + _cMotor + ", CPF: " + _cCPF + ", condutor do Veículo Placa: " + _cPlaca + ", Transportadora: " + _cTransp +" , declaro sob as penas de lei que:" 

			nLinx := mlcount(_cTxtIni,70)

			_nContL := 600

			For nX := 1 to nLinx
				oPrint:Say(_nContL,202,AV_Justifica(memoline(_cTxtIni,70,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "1. Por meio da(s) NF(s): " + _cNFs + ", referente ao Vale Pallet nº " + _cPallet + ", de data " + _cDTEmiNF + ", estou transportando a quantidade de " + _cQtdPal
			_cTxtIni += " paletes que fazem parte desta carga."

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,61)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,450,AV_Justifica(memoline(_cTxtIni,61,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "2.	É da minha responsabilidade no ato do descarregamento, cobrar do Cliente / Operador Logístico o " 
			_cTxtIni += "retorno dos respectivos paletes e ou em caso de não devolução, colher assinatura no respectivo Vale Pallet e " 
			_cTxtIni += "devolver este assinado por pessoa devidamente identificada com nome por extenso e número do R.G. juntamente "
			_cTxtIni += "com o canhoto da NF de Venda do Produto."

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,61)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,450,AV_Justifica(memoline(_cTxtIni,61,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "3. Que assume total e inteira responsabilidade por toda e qualquer conseqüência decorrente da não "
			_cTxtIni += "observação das normas de segurança e uso do alojamento;"

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,61)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,450,AV_Justifica(memoline(_cTxtIni,61,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "4. Estar ciente e de acordo com a obrigação apresentada, sendo que em caso de descumprimento das etapas "
			_cTxtIni += "acima determinadas, fica a empresa Contratante autorizada a efetuar o desconto do valor correspondente a quantidade faltante " 
			_cTxtIni += "de paletes embarcada na carga da nota fiscal, acima referida."

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,61)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,450,AV_Justifica(memoline(_cTxtIni,61,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "5. Ciente que devo prestar conta do comprovante em até 45 dias uteis"

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,61)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,450,AV_Justifica(memoline(_cTxtIni,61,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_cTxtIni := "Declaro que li, entendi e assinei a presente declaração livre de quaisquer vícios de manifestação da vontade previsto em lei" 

			_nContL := _nContL + 80

			nX := 0

			nLinx := mlcount(_cTxtIni,70)

			For nX := 1 to nLinx
				oPrint:Say(_nContL,202,AV_Justifica(memoline(_cTxtIni,70,nX,,.T.)),oFont,1400,CLR_BLACK,,0 )
				_nContL := _nContL + 50
			Next nX

			_nContL := _nContL + 80

			oPrint:Say(_nContL,778, Alltrim(SM0->M0_CIDENT)+", " + Day2Str(Date()) + " de " + MesExtenso(Month(Date())) + " de " + Year2Str(Date()) ,oFont,1400,CLR_BLACK,,0 )
			_nContL := _nContL + 150
			oPrint:Say(_nContL,700,"_______________________________________" ,oFont,1400,CLR_BLACK,,0 )

			_nContL := _nContL + 80
			oPrint:Say(_nContL,922,"Assinatura do Motorista" ,oFont,1400,CLR_BLACK,,0 )

			cFilePrint := cLocal+"TERMO_DE_COMPROMISSO_" + Alltrim((_cAlias)->Z01_CODIGO) + ".PD_"
			File2Printer( cFilePrint, "PDF" )
			oPrint:cPathPDF:= cLocal
			oPrint:Preview()			
			//Z03->(dbSkip())
			//end
		else
			msgStop("O termo só pode ser emitido com nostas de remessas atreladas ao pallet, por favor, acrecente as notas de remessas ao pallet!")
		endif
	else
		msgStop("O termo só pode ser emitido em pallets sem movimentações, o mesmo deve estar com a legenda VERDE e ou legenda AMARELA para emitir o termo.")
	endif
return

user function xVPallet(_cAlias,nRecno,nOpc)

	local cLocal 	:= ""
	local oPrint 	:= nil
	local _cTxtIni 	:= ""
	local nLinx		:= 0
	local _nContL	:= 0
	local nX		:= 0
	local oFont		:= TFont():New('ARIAL_08_BOLD',,25,,.T.)
	local oFont2	:= TFont():New('ARIAL_08_BOLD',,26,,.T.)

	cLocal := cGetFile('','Selecione o diretorio para salvar o termo',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)

	oPrint := FWMSPrinter():New("ValePallet_" + Alltrim((_cAlias)->Z01_CODIGO) + ".rel", IMP_PDF, .T.,cLocal, .T., , , , , , .F., )//TMSPrinter():New("Termo de Responsabilidade")
	oPrint:SetPortrait()
	oPrint:StartPage()
	oPrint:SetPaperSize(9)

	dbSelectArea(_cAlias)
	dbGoTo(nRecno)
	RecLock((_cAlias),.F.)
	(_cAlias)->Z01_STATUS := '5'
	MSUnlock()
	oPrint:Box(220,250,2050,2150)
	oPrint:SayBitmap(260,280,"\system\LogoValePallet.jpg",300,225 )

	_cTxtIni := "Declaração Vale Pallet - Nº " + Alltrim((_cAlias)->Z01_CODIGO)

	oPrint:Say(370,630,_cTxtIni,oFont2,1400,CLR_BLACK,,0 )

	_cTxtIni := "Declaro para os devidos fins que hoje, foi descarregado da empresa " + Alltrim(SM0->M0_NOMECOM) + "," 
	_cTxtIni += " CNPJ " + Transform( Alltrim(SM0->M0_CGC), "@R 99.999.999/9999-99" )  + ", situada na Cidade: " + Alltrim(SM0->M0_CIDENT) + " UF: " + Alltrim(SM0->M0_ESTENT) +  "," 
	_cTxtIni += " a quantidade de " + Alltrim(Str((_cAlias)->Z01_QUANT)) + " pallet PBR na plataforma de descarga de mercadoria emissão dia " + Dtoc((_cAlias)->Z01_DTENTR)  

	nLinx := mlcount(_cTxtIni,43)

	_nContL := 600

	For nX := 1 to nLinx
		oPrint:Say(_nContL,300,AV_Justifica(memoline(_cTxtIni,43,nX,2,.T.)),oFont,1400,CLR_BLACK,,0 )
		_nContL := _nContL + 75
	Next nX

	_cTxtIni := "Autorizamos a mesma a retirar os paletes posteriormente em data pré agendada e na quantidade mencionada acima em nossa unidade, mediante apresentação deste documento original assinado e carimbado."

	nLinx := mlcount(_cTxtIni,43)

	_nContL := _nContL + 110

	For nX := 1 to nLinx
		oPrint:Say(_nContL,300,AV_Justifica(memoline(_cTxtIni,43,nX,2,.T.)),oFont,1400,CLR_BLACK,,0 )
		_nContL := _nContL + 75
	Next nX

	_nContL := _nContL + 120

	oPrint:Say(_nContL,500, Alltrim(SM0->M0_CIDENT)+", " + Day2Str(Date()) + " de " + MesExtenso(Month(Date())) + " de " + Year2Str(Date()) ,oFont,1400,CLR_BLACK,,0 )
	_nContL := _nContL + 180
	oPrint:Say(_nContL,485,"___________________________________" ,oFont,1400,CLR_BLACK,,0 )
	_nContL := _nContL + 80
	oPrint:Say(_nContL,480,"Assinatura e carimbo do responsável" ,oFont,1400,CLR_BLACK,,0 )
	cFilePrint := cLocal+"ValePallet_" + Alltrim((_cAlias)->Z01_CODIGO) + ".PD_"
	File2Printer( cFilePrint, "PDF" )
	oPrint:cPathPDF:= cLocal
	oPrint:Preview()

return
//*** Persaonalizacao - Vagner Azanha - B2 finance
User Function zVPalNF()
  local aParamBox	 := {}
  local _aRet       := {}
  local _cDeNF
  local _cAteNF

  
  aAdd(aParamBox,{1,"De Nota Fiscal "  ,space(09),"","","","",50,.T.}) // Tipo data
  aAdd(aParamBox,{1,"Ate Nota Fiscal "  ,space(09),"","","","",50,.T.}) // Tipo data
  
  if ParamBox(aParamBox,"Seleçao de Vale Pallets por NFs",_aRet)
     _cDeNf := _aRet[1]
     _cAteNf := _aRet[2]
     
     Processa({ || zVPalPNF(_cDeNf,_cAteNf) },"Processando...","Filtando os Vales Pallets , aguarde...") 
     

  endif
     
 return nil
//*** Persaonalizacao - Vagner Azanha - B2 finance
Static function zVPalPNF(_cIniNF,_cFimNF)
  local _cQuery
  local _aVetBrw := {}
  
  _cQuery:= "SELECT * FROM "+RetSqlName("Z03")+" Z03 WHERE Z03.Z03_FILIAL='"+xFilial("Z03")+"' AND Z03.Z03_NFFIL='"+cFilial+"'AND Z03.Z03_NFCLI BETWEEN '"+_cIniNF+"' AND '"+_cFimNF+"' AND Z03.D_E_L_E_T_=' ' ORDER BY Z03.Z03_NFCLI"
  
  if select("_PESQNF")<>0
     _PESQNF->(dbclosearea())
  endif   
  
  dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "_PESQNF", .F., .T.)
  DbSelectArea("_PESQNF")
  _PESQNF->(DbGoTop())
	
  do while _PESQNF->(!eof())
     aAdd(_aVetBrw,{_PESQNF->Z03_FILIAL,;
	      			_PESQNF->Z03_CODPAL,;
					_PESQNF->Z03_NFFIL,;			
					_PESQNF->Z03_NFCLI,;
					_PESQNF->Z03_NFSERI,;
					_PESQNF->Z03_CODCLI})	
	
       _PESQNF->(Dbskip()) 	
  enddo
  if Len(_aVetBrw) > 0
	 DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 500,900 PIXEL TITLE "Notas Fiscais Adicionadas ao Pallet"

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001","Notas Adionadas",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark:SetArray(_aVetBrw)
		oMark:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw[oMark:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Filial NF"			,{||_aVetBrw[oMark:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Nota Fiscal"		,{||_aVetBrw[oMark:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))	
		oMark:AddColumn(TCColumn():New("Serie Nota"			,{||_aVetBrw[oMark:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Cod. Cliente"		,{||_aVetBrw[oMark:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))

       	oMark:Align := CONTROL_ALIGN_ALLCLIENT
		oMark:bWhen := { || Len(_aVetBrw) > 0 }
		
		
		oTBtnBmp1	:=  TButton():New( 01,002, "Vale Pallet",oPanelU2,{||MsgRun("Aguarde...","Acessando Vale Pallet)...",{|| vZPaMain(oDlgPrinc,_aVetBrw[oMark:nAt][2]) })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )	
		//oTBtnBmp2 	:=  TButton():New( 20,002, "Sair",oPanelU2,{||oDlgPrinc:End()},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        //oTBtnBmp2 	:=  TButton():New( 20,002, "Sair",oPanelU2,{||vZPaMain(oDlgPrinc,_aVetBrw[oMark:nAt][2]}},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	   	//oTBtnBmp1	:=  TButton():New( 01,002, "Vai para o Vale Pallet",oPanelU2,{||MsgRun("Aguarde...","Acessando Vale Pallet...",{|| vZPaMain(oDlgPrinc,_aVetBrw[oMark:nAt][2]})},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	   	//TButton():New( 20, 002, "Linha atual", oDlgPrinc,{|| alert(oMark:nAt) },(oPanelU2:nClientWidth/2)-5,040,,,.F.,.T.,.F.,,.F.,,,.F. )
	   
	   	ACTIVATE MSDIALOG oDlgPrinc CENTERED
    
	else
		msgStop("Notas Fiscais nao encontradas atreladas a Vale Pallets !!! ")
	endif
		

return nil
//*** Persaonalizacao - Vagner Azanha - B2 finance
Static Function vZPaMain(oDlgPrinc,_cCodPal)
   Z01->(dbsetorder(1))
   if Z01->(dbseek(xFilial("Z01")+_cCodPal))
       oDlgPrinc:End()
       oBrw:CleanFilter()                 
	   oBrw:AddFilter( "Pallet : "+_cCodPal , "Z01->Z01_CODIGO=='"+_cCodPal+"' ",.T.  )
       oBrw:Refresh()
   endif   

return nil
//*** Persaonalizacao - Vagner Azanha - B2 finance
User Function zVPalCanc()
	if msgyesno("Deseja cancelar o Vale Pallet e todas as NFs atrelhadas a ele. Ele sera marcado como cancelado e as NFs liberadas ")
	   begin transaction
	      Z01->(RecLock("Z01",.F.))
	      Z01->Z01_STATUS := ""  
          Z01->Z01_CANCEL := "S"
		  Z01->(MsUnlock())
		  
		  Exclui2(Z01->Z01_CODIGO)
		  
	   end transaction	   
     	
	endif

return nil

// *** Personalizacao - Vaner Aznha - B2 Finance - 19.11.2019
User Function zVPalOFil()
  local aParamBox := {}
  local _aRet     := {}
  Public _cOutFil := "010007"
  
  aAdd(aParamBox,{1,"Filial"       ,space(06),"","","SM0","",50,.T.}) 
   
  if ParamBox(aParamBox,"Baixa de Vale Pallet por Outra Filial",_aRet)
     
     Processa({ || zVPalFil(_aRet[1]) },"Processando...","Filtando os Vales Pallets , aguarde...") 
     
  endif
 
Retur nil

Static Function zVPalFil(_cFilOut)
   Local _cQry
   Local _aVetBrw
   
   _cQry:="SELECT Z01.* FROM "+RetSqlName("Z01")+" Z01 WHERE Z01.Z01_FILIAL='"+_cFilOut+"' "
   _cQry+=" AND Z01.D_E_L_E_T_=' ' AND Z01.Z01_STATUS NOT IN ('2') ORDER BY Z01.Z01_CODIGO "
   
    if select("_PESQPAL")<>0
     _PESQPAL->(dbclosearea())
  endif   
  
  dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "_PESQPAL", .F., .T.)
  DbSelectArea("_PESQPAL")
  _PESQPAL->(DbGoTop())
  
  _aVetBrw:={}
	
  do while _PESQPAL->(!eof())
     aAdd(_aVetBrw,{_PESQPAL->Z01_CODIGO,;
	      			substr(_PESQPAL->Z01_DTENTR,7,2)+"/"+substr(_PESQPAL->Z01_DTENTR,5,2)+"/"+substr(_PESQPAL->Z01_DTENTR,1,4),;
					_PESQPAL->Z01_ENDENT,;
					_PESQPAL->Z01_CODTRA,;
					_PESQPAL->Z01_TRANSP,;	
					_PESQPAL->Z01_XPRCOD,;	
					_PESQPAL->Z01_DESCPR})	
	
       _PESQPAL->(Dbskip()) 	
  enddo
  if Len(_aVetBrw) > 0
   
     DEFINE MSDIALOG oDlgPrinc FROM 000,000 TO 500,900 PIXEL TITLE "Vale Pallets - Filial "+_cFilOut

		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgPrinc, .F., .T. )
		oFWLayer:AddLine( 'UP', 100, .F. )
		oFWLayer:AddCollumn( 'UP01', 80, .T., 'UP' )
		oFWLayer:AddCollumn( 'UP02', 20, .T., 'UP' )
		oFWLayer:AddWindow("UP01","UP001"," Vale Pallets",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)
		oFWLayer:AddWindow("UP02","UP002","Acoes",100,.F.,.F.,/*bAction*/,"UP",/*bGotFocus*/)

		oPanelU1 := oFWLayer:GetWinPanel("UP01","UP001","UP")
		oPanelU2 := oFWLayer:GetWinPanel("UP02","UP002","UP")

		oMark:= TCBrowse():New(0, 0, 0,0,,,,oPanelU1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		oMark:SetArray(_aVetBrw)
		oMark:AddColumn(TCColumn():New("Cod. Pallet"		,{||_aVetBrw[oMark:nAt,01]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Dt. Emissao"	    ,{||_aVetBrw[oMark:nAt,02]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("End. Entrega"		,{||_aVetBrw[oMark:nAt,03]},,,,"LEFT",,.F.,.F.,,,,,))	
		oMark:AddColumn(TCColumn():New("Cod. Transp "		,{||_aVetBrw[oMark:nAt,04]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Nome Transp."		,{||_aVetBrw[oMark:nAt,05]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Cd. Produto "		,{||_aVetBrw[oMark:nAt,06]},,,,"LEFT",,.F.,.F.,,,,,))
		oMark:AddColumn(TCColumn():New("Des. Produto"		,{||_aVetBrw[oMark:nAt,07]},,,,"LEFT",,.F.,.F.,,,,,))

       	oMark:Align := CONTROL_ALIGN_ALLCLIENT
		oMark:bWhen := { || Len(_aVetBrw) > 0 }
		
		oTBtnBmp1	:=  TButton():New( 01,002, "Recebimento",oPanelU2,{||MsgRun("Aguarde...","Acessando Vale Pallet)...",{|| vZAcePal(oDlgPrinc,_aVetBrw[oMark:nAt][1],_cFilOut) })},(oPanelU2:nClientWidth/2)-5,10,,,.F.,.T.,.F.,,.F.,,,.F. )	
			   
	   	ACTIVATE MSDIALOG oDlgPrinc CENTERED
    endif
    
return nil

Static Function vZAcePal(oDlgPrinc,_cCodPal,_cFilOut)

   if Z01->(dbseek(_cFilOut+_cCodPal))
      Close(oDlgPrinc)
      u_zVPallet("Z01",Z01->(RECNO()),17)
   else
      msgStop("Vale Pallet nao econtrado na Filial  !!! "+_cFilOut)
   endif  
    
return nil
