#include "totvs.ch"                                                 
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWFILTER.CH"
#INCLUDE "FWBRWSTR.CH"
#INCLUDE "FWMVCDEF.CH"   
#define CRLF chr(13) + chr(10)             

/*
=====================================================================================
Programa.:              MGFJUR02
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integração Grade de Aprovação SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE MVC JURA098 - Garantia e JURA099 - Depesas
=====================================================================================
*/

User Function MGFJUR02(cTab)

Local oObj     := IIf(Type("ParamIxb[1]")!="U",ParamIxb[1],Nil)
Local cIdPonto := IIf(Type("ParamIxb[2]")!="U",ParamIxb[2],"")
Local cIdModel := IIf(Type("ParamIxb[3]")!="U",ParamIxb[3],"")
Local nOpcx    := 0
Local uRet     := .T.
Local aRet     := {} 
Local cSeq     := ''
Local cStatus  := ''

If oObj == Nil .or. Empty(cIdPonto)
	Return(uRet)
Endif
	
nOpcx := oObj:GetOperation()

If cIdPonto == "MODELVLDACTIVE"
	If nOpcx == 3 .OR. nOpcx == 4//nOpcx == MODEL_OPERATION_INSERT .OR. nOpcx == MODEL_OPERATION_UPDATE
		//Não permitir inclusão de despesa/garantia quando não cadastrado o RD0_USER
		aRet := U_JUR02_TIPO()
		IF !aRet[1]
			uRet := .F.
			Help( ,, 'Help',, 'Não é possivel fazer a operação!'+CRLF+aRet[2] , 1, 0 )
		EndIF
	Endif
	If uRet  .And. nOpcx ==  4 /*MODEL_OPERATION_UPDATE*/ .AND. &(cTab+"->"+cTab+"_XAPROV") =='6'
		Help( ,, 'Help',, 'Despesa/Garantia foi gerada por inclusão inicial, não é possivel alterar!' , 1, 0 )
		uRet := .F.
	Endif
	If uRet  .And. nOpcx == 4 /*MODEL_OPERATION_UPDATE*/ .AND. cTab =='NT3' .AND. &(cTab+"->"+cTab+"_XAPROV") =='5'
		Help( ,, 'Help',, 'Despesa já aprovada!' , 1, 0 )
		uRet := .F.
	Endif
	If uRet  .And. nOpcx == 4 .And. !IsInCallStack("U_MGFJUR03") /*MODEL_OPERATION_UPDATE*/
		IF !ApMsgYesNo('Alteração irá iniciar novamente a grade aprovação, deseja continuar ?')
			uRet := .F.
		EndIF
	Endif
	
EndIf
If cIdPonto == "FORMPOS"                                                   
	If nOpcx == 3 .OR. nOpcx == 4//nOpcx == MODEL_OPERATION_INSERT .OR. nOpcx == MODEL_OPERATION_UPDATE
	    //Validar se tem dados bancarios
		IF cTab == 'NT2' // Garantia 
				If Empty(FwFldGet("NT2_CNATUT")) .OR. Empty(FwFldGet("NT2_PREFIX")) .OR. Empty(FwFldGet("NT2_CTIPOT")) 
				    JurMsgErro('Natureza, tipo do titulo e prefixo precisam estar preenchidos')
				    uRet := .F.
				ElseIF Empty(FwFldGet("NT2_CFORNT")) .OR. Empty(FwFldGet("NT2_LFORNT"))          
				    JurMsgErro('Fornecedor precisa estar preenchido')
				    uRet := .F.
				ElseIF Empty(FwFldGet("NT2_CBANCO")) .OR. Empty(FwFldGet("NT2_CAGENC")) .OR. Empty(FwFldGet("NT2_CCONTA"))
			        JurMsgErro('Dados do Banco precisam ser preenchidos')
			        uRet := .F.
			    EndIF
				//If uRet  .And. nOpcx == MODEL_OPERATION_INSERT .AND. Empty(FwFldGet("NT2_XCCUST"))// validação de centro de custo.
				//	Help( ,, 'Help',, 'Centro de Custo precisa ser preenchido !!' , 1, 0 )
				//	uRet := .F.
				//Endif

		EndIF
		IF cTab == 'NT3' // Despesas
				If Empty(FwFldGet("NT3_CNATUT")) .OR. Empty(FwFldGet("NT3_PREFIX")) .OR. Empty(FwFldGet("NT3_CTIPOT")) 
				    JurMsgErro('Natureza, tipo do titulo e prefixo precisam estar preenchidos')
				    uRet := .F.
				ElseIF Empty(FwFldGet("NT3_CFORNT")) .OR. Empty(FwFldGet("NT3_LFORNT"))          
				    JurMsgErro('Fornecedor precisa estar preenchido')
				    uRet := .F.
				EndIF
				//If uRet  .And. nOpcx == MODEL_OPERATION_INSERT .AND. Empty(FwFldGet("NT3_XCCUST"))// validação de centro de custo.
				//	Help( ,, 'Help',, 'Centro de Custo precisa ser preenchido !!' , 1, 0 )
				//	uRet := .F.
				//Endif
		EndIF
		// Verifica duplicidade
		IF uRet
			cQuery := "SELECT Count(*) TOTAL "
			cQuery += "  FROM " + RetSqlName(cTab) 
			cQuery += "  WHERE "+cTab+"_FILIAL = '" +xFilial(cTab)+ "' "
			IF nOpcx == 4
			    cQuery += "  AND R_E_C_N_O_    <> "+Alltrim(STR(&(cTab+"->(Recno())")))
			EndIF
			IF cTab == 'NT2'
				cQuery += "	AND NT2_CAJURI = '" + FwFldGet("NT2_CAJURI") + "' "
				cQuery += "	AND NT2_CTPGAR = '" + FwFldGet("NT2_CTPGAR") + "' "
				cQuery += "	AND NT2_VALOR  = " + Alltrim(STR(FwFldGet("NT2_VALOR"))) + " "
			ElseIF cTab =='NT3'
				cQuery += "	AND NT3_CAJURI = '" + FwFldGet("NT3_CAJURI") + "' "
				cQuery += "	AND NT3_CTPDES = '" + FwFldGet("NT3_CTPDES") + "' "
				cQuery += "	AND NT3_VALOR  = " + Alltrim(STR(FwFldGet("NT3_VALOR"))) + " "
			EndIF
			cQuery += "	AND D_E_L_E_T_	= ' ' "
			
			If Select("QRY_SOMA") > 0
				QRY_SOMA->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SOMA",.T.,.F.)
			dbSelectArea("QRY_SOMA")
			QRY_SOMA->(dbGoTop())
			IF !QRY_SOMA->( EOF() )
			    IF QRY_SOMA->TOTAL  > 0  
				     IF !ApMsgYesNo('Já existe lançamento para este processo com o mesmo valor e tipo, deseja continuar ?')
				     	uRet := .F.
				     EndIF  
				EndIF
			EndIF
		EndIF
        IF uRet
			IF cTab == 'NT2' // Verifica se a despesa do Alvará foi aprovado pelo CAP
 				If FwFldGet("NT2_MOVFIN") == '2'
				     cStatus := GetAdvFVal("NT2","NT2_XAPROV",xFilial("NT2")+FwFldGet("NT2_CAJURI")+FwFldGet("NT2_CGARAN"),1,"")
				     IF cStatus <> '5'
				     	Help( ,, 'Help',, 'Despesa Selecionada não foi aprovada ainda pelo CAP !!' , 1, 0 )
						uRet := .F.
					EndIF
				Endif
			EndIF
        EndIF
		IF uRet                 
    		IF nOpcx == 4 .AND. !IsInCallStack("U_MGFJUR03") //MODEL_OPERATION_UPDATE
	    		IF FwFldGet(cTab+'_XORIG') == '2'   
	    		    oObj:SetValue(cTab+'_XAPROV', "2")
	    		Else
	                oObj:SetValue(cTab+'_XAPROV', "2")
	    	    EndIF
	    	EndIF
    		IF nOpcx == 3//MODEL_OPERATION_INSERT
	    		aRet := U_JUR02_TIPO()
	    		IF aRet[02] == '4'
	    		    oObj:SetValue(cTab+'_XORIG', "4")
	    		    oObj:SetValue(cTab+'_XAPROV', "6")
	    		ELSEIF aRet[02] == '1' // Interno       
	    		    oObj:SetValue(cTab+'_XORIG', "1")
	    		    oObj:SetValue(cTab+'_XAPROV', "2")
	    		Else
	                oObj:SetValue(cTab+'_XORIG', "2")
	    		    oObj:SetValue(cTab+'_XAPROV', "2")
	    	    EndIF
	    	EndIF
    	EndIF
    EndIF
EndIF

IF cIdPonto == "MODELCOMMITTTS"
    If (nOpcx == 3 .OR. nOpcx == 4) .AND. !IsInCallStack("U_MGFJUR03") //nOpcx == MODEL_OPERATION_INSERT .OR. nOpcx == MODEL_OPERATION_UPDATE
	   // Gravar a grade ZJ1
	   ChkFile('ZJ1')
	   dbSelectArea('ZJ1')        
	   cSeq := U_JUR02_SEQ(cTab,&(cTab+"->(Recno())"))                                 
	   Reclock("ZJ1",.T.)    
	   ZJ1->ZJ1_FILIAL    := xFilial('SZ1')
	   ZJ1->ZJ1_TAB       := cTab 
	   ZJ1->ZJ1_RECNO     := &(cTab+"->(Recno())")
	   ZJ1->ZJ1_SEQ       := cSeq
	   ZJ1->ZJ1_STATUS    := &(cTab+"->"+cTab+"_XAPROV")
	   ZJ1->ZJ1_USER      := RetCodUsr() 
	   ZJ1->ZJ1_NOME      := USRRETNAME(RetCodUsr())                                                                                                         
	   ZJ1->ZJ1_DATA      := Date()
	   ZJ1->ZJ1_HORA      := Time()
	   ZJ1->ZJ1_MOTIVO    := IIF(nOpcx == MODEL_OPERATION_UPDATE, 'Reinicio do Processo de Aprovação','')
	   ZJ1->ZJ1_EMAIL     := IIF(&(cTab+"->"+cTab+"_XAPROV") =='6','N','S')
	   ZJ1->(MsUnlock())
	EndIf
EndIF      

Return uRet                
*****************************************************************************************************
User Function JUR02_TIPO

Local cUser := RetCodUsr()         
Local aRet  := {}

dbSelectArea('RD0')
RD0->(DbOrderNickName('USER'))
IF RD0->(dbSeek(cUser))	   
	 IF Empty(RD0->RD0_TIPO)
	     aRet  := {.F.,'Tipo de Usuário em Branco' }
	 Else
	     aRet := {.T., RD0->RD0_TIPO}
	 EndIF
Else
     aRet  := {.F.,'Não existe participante relacionado a este usuário' }
EndiF
RD0->(dbSetOrder(1))	   

Return aRet
*****************************************************************************************************
User Function JUR02_SEQ(cTab,nRecno)
Local cRet := '01'

ZJ1->(dbSetOrder(1))	                    
ZJ1->(dbSeek(cTab+STRZERO(nRecno,10)))
While ZJ1->(!Eof()) .AND. ZJ1->ZJ1_TAB == cTab .And.  ZJ1->ZJ1_RECNO == nRecno
	cRet := SOMA1(ZJ1->ZJ1_SEQ)
	Reclock("ZJ1",.F.)
	ZJ1->ZJ1_EMAIL     := 'N'
	ZJ1->(MsUnlock())
	ZJ1->(dbSkip())
End

Return cRet