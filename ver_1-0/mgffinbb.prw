#include 'parmtype.ch'
#include 'protheus.ch'
#include 'topconn.ch'

#DEFINE CRLF chr(13) + chr(10)
//-----------------------------
user function MGFFINBB()
//-----------------------------
Private nValCar := 0.00
Private cMotivo	:= SPACE(90) 
Private cMens	:= ""
Private cQry	:= ""	 
Private cMensVal:= ""
Private _cCODPOS:= ""

if SE1->E1_SALDO = 0 
	MsgStop("Este título não tem saldo em aberto.")	
endif 

//Verificando os atendimentos anteriores. 
cQry := "SELECT * "
cQry += " FROM " + retSQLName("ZZB") + " ZZB"
cQry += " WHERE"
cQry += " ZZB.ZZB_VALCAR <> 0 	" 
cQry += " AND ZZB.ZZB_PREFIX	= 	'" + SE1->E1_PREFIXO	+ "'"
cQry += " AND ZZB.ZZB_NUM		=	'" + SE1->E1_NUM		+ "'"
cQry += " AND ZZB.ZZB_PARCEL	=	'" + SE1->E1_PARCELA	+ "'"
cQry += " AND ZZB.ZZB_TIPO		=	'" + SE1->E1_TIPO		+ "'"
cQry += " AND ZZB.ZZB_FILORI	=	'" + SE1->E1_FILIAL		+ "'"
cQry += " AND ZZB.D_E_L_E_T_	<>	'*' "
cQry += " ORDER BY ZZB_DATA||ZZB_HORA DESC "
if SELECT("QRY") > 0 
	QRY->(dbCloseArea("QRY"))
endif 
TcQuery cQry New Alias "QRY"

if !QRY->(EOF())
	cMensVal +=   "Data: " + dtoc(stod(QRY->ZZB_DATA)) + " Hora: "+QRY->ZZB_HORA + alltrim(QRY->ZZB_CONTAT) + " Valor: " + Transform(QRY->ZZB_VALCAR,"@e 9,999,999,999,999.99")  
	if !MsgNoYes("Existe lançamento de Taxa de cartório, deseja atualiza-lo?"+CRLF+CRLF+cMensVal)
		Return
	endif 
endif

//pegar o valor do campo - ultimo atendimento
cQry := "SELECT ZZB_CODPOS "
cQry += " FROM " + retSQLName("ZZB") + " ZZB"
cQry += " WHERE"
cQry += " ZZB.ZZB_PREFIX	= 	'" + SE1->E1_PREFIXO	+ "'"
cQry += " AND ZZB.ZZB_NUM		=	'" + SE1->E1_NUM		+ "'"
cQry += " AND ZZB.ZZB_PARCEL	=	'" + SE1->E1_PARCELA	+ "'"
cQry += " AND ZZB.ZZB_TIPO		=	'" + SE1->E1_TIPO		+ "'"
cQry += " AND ZZB.ZZB_FILORI	=	'" + SE1->E1_FILIAL		+ "'"
cQry += " AND ZZB.D_E_L_E_T_	<>	'*' "
cQry += " ORDER BY ZZB_DATA||ZZB_HORA DESC "
if SELECT("QRY1") > 0 
	QRY1->(dbCloseArea("QRY"))
endif 
TcQuery cQry New Alias "QRY1"

_cCODPOS := QRY1->ZZB_CODPOS

if SELECT("QRY1") > 0 
	QRY1->(dbCloseArea("QRY"))
endif 


if SELECT("QRY") > 0 
	QRY->(dbCloseArea("QRY"))
endif 

DEFINE MSDIALOG oDLG2 TITLE "Adiciona Custo de Cartório ao Título Posiconado" FROM 000, 000  TO 120, 495 COLORS 0, 16777215 PIXEL

@ 008, 002 SAY  	"VALOR CARTORIO :"    	SIZE 050, 009 OF oDLG2 										COLORS 0, 16777215 PIXEL
@ 006, 055 MSGET  	nValCar     			SIZE 050, 010 OF oDLG2 PICTURE "@E 999,999,999.99" 			COLORS 0, 16777215 PIXEL

@ 020, 002 SAY  	"MOTIVO		    :"    	SIZE 050, 009 OF oDLG2 										COLORS 0, 16777215 PIXEL
@ 022, 055 MSGET  	cMotivo     			SIZE 180, 010 OF oDLG2 PICTURE "@!" VALID(!empty(cMotivo)) 	COLORS 0, 16777215 PIXEL


oBtn := TButton():New( 040, 185 ,"Confirma"	, oDlg2,{|| FINBBGrv() }  	,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
oBtn := TButton():New( 040, 130 ,"Cancela"	, oDlg2,{|| oDLG2:End() }  	,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDLG2 CENTERED
	
return

//-------------------------------------
Static Function FINBBGrv()
//-------------------------------------
Local _cNomUsr	:= cUserName
Begin Transaction
	Reclock("SE1",.F.)
	SE1->E1_ZVALCAR := nValCar
	SE1->( msUnlock() )
	
	Reclock("ZZB",.T.)
	ZZB_FILIAL	:= SE1->E1_FILIAL
	ZZB_FILORI	:= SE1->E1_FILIAL
	ZZB_PREFIX	:= SE1->E1_PREFIXO
	ZZB_NUM 	:= SE1->E1_NUM
	ZZB_PARCEL	:= SE1->E1_PARCELA
	ZZB_TIPO	:= SE1->E1_TIPO
	
	ZZB_ZATEN	:= SE1->E1_ZATEND
	ZZB_ZSEGME	:= SE1->E1_ZSEGMEN
	ZZB_ZDESRE	:= SE1->E1_ZDESRED
	ZZB_RESPOS	:= cMotivo
	ZZB_VALCAR	:= nValCar
	ZZB_DATA	:= ddatabase     
	ZZB_HORA	:= time()
	ZZB_CODPOS	:= _cCODPOS
	// Busca dados do usuário para saber qtos digitos usa no ANO.
	PswOrder(2)
	If PswSeek( _cNomUsr, .T. )
		aDadosUsu := PswRet() // Retorna vetor com informações do usuário
		ZZB_USUARI	:= aDadosUsu[1][1]
		ZZB_USRNOM	:= aDadosUsu[1][2]
		ZZB_CONTAT	:= aDadosUsu[1][4]
	EndIf
	ZZB->( msUnlock() )
End Transaction 
cMens := SE1->E1_CLIENTE+"/"+SE1->E1_LOJA+"/"+alltrim(SE1->E1_NOMCLI)+CRLF+CRLF+"Motivo:"+ alltrim(cMotivo)+;
"Valor Cartório :"+ Transform(nValCar,"@e 9,999,999,999,999.99") 


MsgInfo("Atendimento registrado com sucesso. "+CRLF+cMens) 

oDLG2:End()

Return


