#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFFATBC 
Estorno de roteiriza��o de pedido simples ou multipedidos

@description
Estorno de roteiriza��o de pedido simples ou multipedidos

@author Josu� Danich Prestes
@since 30/09/2019 
@type Function  

@table 
    SC5 - Cabe�alho dos pedidos de venda
 
@menu
    A��es relacionadas do browse de pedido de vendas-op��o Exc Roteiriza��o

@history 
    30/09/2019 - RTASK001064 - Josu� Danich Prestes
/*/   
User Function MGFFATBC()

Local _bOk, _bCancel
Local _oRadio, _nRadio := 1
Local _lRet := .F.

Private _oDlgPesq

//Valida se usu�rio pode utilizar a rotina
If !(cusername $ getmv("MGF_ESTROT",,"   "))

    msgbox("Usu�rio " + cusername + " n�o autorizado a estornar roteiriza��o!")
    Return

Endif

_bOk := {|| _lRet := .T., _oDlgPesq:End()}
_bCancel := {|| _lRet := .F., _oDlgPesq:End()}
                                                
_cTitulo := "Exclus�o de roteiriza��o de pedidos de vendas"
   
Define MsDialog _oDlgPesq Title _cTitulo From 9,0 To 25,40 Of oMainWnd      
      
    @ 03,08 Say " Tipo de exclus�o " Pixel of _oDlgPesq                 
    @ 20,04 To 60,80 Pixel of _oDlgPesq       
    @ 25,10 Radio _oRadio Var _nRadio Items "Pedido " + SC5->C5_NUM, "V�rios pedidos" Size 70,25  Pixel Of _oDlgPesq
            
    @ 70,040  Button "Processar" Size 50,20  Of _oDlgPesq Pixel Action EVAL(_bOk)
    @ 70,105  Button "Sair"      Size 50,20  Of _oDlgPesq Pixel Action EVAL(_bCancel)
      
Activate MsDialog _oDlgPesq CENTERED //On Init EnchoiceBar(_oDlgPesq,_bOk,_bCancel) 

If _lRet

    If _nRadio == 1
        if msgbox("Confirma estorno de roteiriza��o do pedido " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + "?","Aten��o","YESNO")
            fwmsgrun(,{|| MGFFATBCS()},"Aguarde...","Estornando roteiriza��o...")
        Else
            msgbox("Processo cancelado!")
         Endif
    Else
            fwmsgrun(,{|oproc| MGFFATBCM(oproc)},"Aguarde...","Carregando estorno multipedidos...")
    Endif

Else

    msgbox("Processo cancelado!")

Endif


Return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFFATBCS 
Execu��o de estorno de roteiriza��o por pedido de venda

@param
    _cfilial - filial do pedido de venda
    _cnum - numero do pedido de venda
    _lshow - exibe mensagens

@return
    _cstatus - status da execu��o do estorno de roteiriza��o 

*/
Static Function MGFFATBCS(_cfilial,_cnum,_lshow)

Local _aareaSC5 := SC5->(Getarea())
Local _aareaSC6 := SC6->(Getarea())
Local _cstatus := "Erro n�o identificado"
Local _lexecuta := .T.
Local _nsaldo := 0

Default _lshow := .T.
Default _cfilial := SC5->C5_FILIAL
Default _cnum := SC5->C5_NUM


SC5->(Dbsetorder(1)) //C5_FILIAL+C5_NUM
SC6->(Dbsetorder(1)) //C6_FILIAL+C6_NUM

If SC5->(Dbseek(_cfilial+_cnum))

    If _lexecuta .and. SC5->C5_ZROAD != 'S'
        _cstatus := "Pedido de vendas n�o roteirizado!"
        _lexecuta := .F.
    Endif
 
    If _lexecuta .and. !EMPTY(SC5->C5_NOTA)
        _cstatus := "Pedido de vendas j� faturado!"
        _lexecuta := .F.
    Endif

    If _lexecuta .and. SC6->(Dbseek(_cfilial+_cnum))

        Do while _cfilial+_cnum == SC6->C6_FILIAL + SC6->C6_NUM

            _nsaldo := _nsaldo + SC6->C6_QTDVEN - SC6->C6_QTDENT

            SC6->(Dbskip())

        Enddo

        If _nsaldo == 0

            _cstatus := "Pedido de vendas sem saldo para faturamento!"
            _lexecuta := .F.

        Endif

    Elseif _lexecuta

        _cstatus := "Itens do pedido n�o localizados!"
        _lexecuta := .F.

    Endif

    If _lexecuta

        //Valida OE no Taura
        _cfilori := cfilant
        cfilant := SC5->C5_FILIAL
        _lret := U_TAS01StatPV({SC5->C5_NUM,2},.F.)
        cfilant := _cfilori
        If !(_lret)
            _cstatus := "Pedido bloqueado no Taura!"
            _lexecuta := .F.
        Endif

    Endif

Else

    _lexecuta := .F.
    _cstatus := "Pedido n�o localizado!"

Endif

If _lexecuta

    Reclock("SC5",.F.)
    SC5->C5_ZROAD := "N"
    SC5->(Msunlock())

    If SC5->C5_ZROAD == "N"
        _cstatus := "Roteiriza��o estornada com sucesso!"
    Else
        _cstatus := "Falha de grava��o do estorno de roteiriza��o!"
    Endif

Endif

If _lshow

    If _cstatus == "Roteiriza��o estornada com sucesso!"
        msgbox(_cstatus,"Aten��o","INFO")
    Else
        msgbox(_cstatus,"Aten��o","STOP")
    Endif

Endif

SC5->(Restarea(_aareaSC5))
SC6->(Restarea(_aareaSC6))

Return _cstatus


/*/
==============================================================================================================================================================================
{Protheus.doc} MGFFATBCM 
Execu��o de estorno de roteiriza��o multi pedido de venda

*/
Static Function MGFFATBCM(oproc)

Local cperg := "MGFFATBC"
Local _acols := {}
Local _aheader := {}
Local _aareaSC5 := SC5->(Getarea())
Local _aareaSC6 := SC6->(Getarea())
Local _calias := getnextalias()

If pergunte("MGFFATBC")

    _cQuery := " SELECT  C5_FILIAL , C5_NUM, C5_FECENT, C5_LOJACLI,C5_CLIENTE"
	_cQuery += " FROM  "+ RetSqlName('SC5') +' C5 '
	_cQuery += " WHERE	D_E_L_E_T_ = ' '
	_cQuery += " AND C5_FILIAL >= '"+ MV_PAR01 +"' "
    _cQuery += " AND C5_FILIAL <= '"+ MV_PAR02 +"' "
	_cQuery += " AND C5_NUM >= '"+MV_PAR03+"' "
    _cQuery += " AND C5_NUM <= '"+MV_PAR04+"' "
  	_cQuery += " AND C5_FECENT >= '"+DTOS(MV_PAR05)+"' "
    _cQuery += " AND C5_FECENT <= '"+DTOS(MV_PAR06)+"' "
  	_cQuery += " AND C5_CLIENTE >= '"+MV_PAR07+"' "
    _cQuery += " AND C5_LOJACLI >= '"+MV_PAR08+"' "
   	_cQuery += " AND C5_CLIENTE <= '"+MV_PAR09+"' "
    _cQuery += " AND C5_LOJACLI <= '"+MV_PAR10+"' "
    _cQuery += " AND C5_ZROAD = 'S' "
    _cQuery += " AND C5_NOTA = '         ' "
	_cQuery += " ORDER BY C5_FILIAL,C5_NUM "


    DBUseArea( .T. , "TOPCONN" , TCGenQry(,,_cQuery) , _calias , .F. , .T. )
	
	(_calias)->( DBGoTop() )

    If (_calias)->(Eof())
        msgbox("N�o foram localizados pedidos com os par�metros indicados!")
    Else
		
	    DO While (_calias)->( !Eof() )

            aadd(_acols, {  (_calias)->C5_FILIAL,;
                            (_calias)->C5_NUM,;
                            STOD((_calias)->C5_FECENT),;
                            (_calias)->C5_CLIENTE + "/" + (_calias)->C5_LOJACLI ,;
                            POSICIONE("SA1",1,xfilial("SA1")+(_calias)->C5_CLIENTE + (_calias)->C5_LOJACLI,"A1_NREDUZ"),;
                            "  " })


            (_calias)->( Dbskip() )

        Enddo

        _aheader := { "Filial", "Pedido", "Dt Entrega", "Cliente","Nome cliente"}

        If U_MGListBox( "Pedidos para estornar roteiriza��o" , _aheader , _ACOLS , .T. , 1 )

            For _nnj := 1 to len(_acols)

                _cmens := "Estornando roteiriza��o do pedido " + _acols[_nnj][1] + "/" + _acols[_nnj][2] 
                _cmens += + " - " + STRZERO(_nnj,6) + " de " + STRZERO(len(_acols),6) + "..." 
                oproc:ccaption := _cmens
                processmessages()

                _acols[_nnj][6] := MGFFATBCS(_acols[_nnj][1],_acols[_nnj][2],.F.)

            Next

            _aheader := { "Filial", "Pedido", "Dt Entrega", "Cliente","Nome cliente","Status"}
            U_MGListBox( "Resultado de estorno de  roteiriza��o" , _aheader , _ACOLS , .T. , 1 )

        Else

            msgbox("Processo cancelado!")   

        Endif

    Endif

Else

    msgbox("Processo cancelado!")

Endif

SC5->(Restarea(_aareaSC5))
SC6->(Restarea(_aareaSC6))

Return