#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFEST63 
Relatório de log de liberações de SA

@author Josué Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/   
User Function MGFEST63()

If pergunte("MGFEST63")

    fwmsgrun(,{|oproc| MGEST63P(oproc)},"Aguarde...","Carregando registros...")

Else

    msgbox("Processo cancelado!")

Endif


Return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGEST63P 
Processamento de relatório de log de SA

@author Josué Danich Prestes
@since 03/10/2019 
@type Function  

@history 
    03/10/2019 - Criado com RTASK0010069
 /*/   
Static Function MGEST63P(oproc)

Local _cQuery := ""
Local _calias := getnextalias()
Local _ntot := 0
Local _npos := 0

_cQuery := " SELECT  ZEZ_FILIAL,ZEZ_NUM,ZEZ_ITEM,ZEZ_USER,ZEZ_HORA,ZEZ_DATA,CP_PRODUTO,
_cQuery += "         CP_UM,CP_QUANT,CP_OP,CP_SOLICIT,CP_CC,CP_DESCRI,CP_QUJE,CP_CLVL,ZEZ_CODU "                 
_cQuery += " FROM  "+ RetSqlName('ZEZ') + " ZEZ " 
_cQuery += " JOIN "+ RetSqlName('SCP') + " SCP ON CP_FILIAL = ZEZ_FILIAL AND CP_NUM = ZEZ_NUM AND CP_ITEM = ZEZ_ITEM "
_cQuery += " WHERE	SCP.D_E_L_E_T_ = ' ' AND ZEZ.D_E_L_E_T_ = ' ' "
_cQuery += " AND ZEZ_FILIAL >= '"+ MV_PAR01 +"' "
_cQuery += " AND ZEZ_FILIAL <= '"+ MV_PAR02 +"' "
_cQuery += " AND ZEZ_DATA >= '"+ dtos(MV_PAR03) +"' "
_cQuery += " AND ZEZ_DATA <= '"+ dtos(MV_PAR04) +"' "
_cQuery += " AND CP_EMISSAO >= '"+ dtos(MV_PAR05) +"' "
_cQuery += " AND CP_EMISSAO <= '"+ dtos(MV_PAR06) +"' "
_cQuery += " AND ZEZ_NUM >= '"+ MV_PAR07 +"' "
_cQuery += " AND ZEZ_NUM <= '"+ MV_PAR08 +"' "
_cQuery += " AND CP_CC >= '"+ MV_PAR09 +"' "
_cQuery += " AND CP_CC <= '"+ MV_PAR10 +"' "
_cQuery += " AND CP_PRODUTO >= '"+ MV_PAR11 +"' "
_cQuery += " AND CP_PRODUTO <= '"+ MV_PAR12 +"' "
_cQuery += " AND CP_CODSOLI >= '"+ MV_PAR13 +"' "
_cQuery += " AND CP_CODSOLI <= '"+ MV_PAR14 +"' "
_cQuery += " AND ZEZ_CODU >= '"+ MV_PAR15 +"' "
_cQuery += " AND ZEZ_CODU <= '"+ MV_PAR16 +"' "
_cQuery += " ORDER BY ZEZ_FILIAL,ZEZ_NUM,ZEZ_ITEM,ZEZ_DATA"

DBUseArea( .T. , "TOPCONN" , TCGenQry(,,_cQuery) , _calias , .F. , .T. )
	
(_calias)->( DBGoTop() )

If (_calias)->( Eof() )

    msgbox("Não foram localizados registros com os filtros informados!")

Else

    //Conta registros
    oproc:ccaption := "Contando registros..."
    processmessages()
    Do while !((_calias)->( Eof() ))
        _ntot++
        (_calias)->( Dbskip() )
    Enddo

    (_calias)->( DBGoTop() )
    _acols := {}
    _aheader := {   "Filial      ",;
                    "Nr.S.A.     ",;
                    "Item S.A.   ",;
                    "Usuario Libe",;
                    "Solicitante ",;
                    "Data Lib    ",;
                    "Hora Lib    ",;
                    "Produto     ",;
                    "Unid Medida ",;
                    "Quantidade  ",; 
                    "Ord Producao",;
                    "C Custo     ",;
                    "Descricao   ",;  
                    "Quant.Atend.",;
                    "Cod Cl Val  "}

    Do while !((_calias)->( Eof() ))

        aadd( _acols, {  (_calias)->ZEZ_FILIAL  ,;
                        (_calias)->ZEZ_NUM,;
                        (_calias)->ZEZ_ITEM,;
                        UsrFullName((_calias)->ZEZ_CODU),;
                        (_calias)->CP_SOLICIT,;
                        STOD((_calias)->ZEZ_DATA),;
                        (_calias)->ZEZ_HORA,;
                        (_calias)->CP_PRODUTO  ,;
                        (_calias)->CP_UM,;
                        transform((_calias)->CP_QUANT,"@E 999,999.99")  ,;
                        (_calias)->CP_OP,;
                        (_calias)->CP_CC,;
                        (_calias)->CP_DESCRI,;
                        transform((_calias)->CP_QUJE,"@E 999,999.99")  ,;
                        (_calias)->CP_CLVL  } )

        _npos++
        oproc:ccaption := "Carregando registro " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "..."
        processmessages()
        (_calias)->( Dbskip() )

    Enddo 

    If len(_acols) > 0

        U_MGListBox( "Log de aprovações de SA" , _aheader , _acols , .T. , 1 )

    Else

        msgbox("Não foram localizados registros com os filtros indicados!")

    Endif          

Endif

Return