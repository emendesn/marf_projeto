#Include 'Protheus.ch'
#include "totvs.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "fileio.ch"

/*/{Protheus.doc} MGFWSC79 - Job de monitor de integrações
	@author Josué Danich
	@since 30/12/2019
/*/
User Function MGFWSC79()

Local _nni := 0
Local _ntimeout := 0
	
U_MFCONOUT(' Iniciando processamento...') 

RPCSetType( 3 )

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

U_MFCONOUT(' Iniciado o ambiente, iniciando monitoramento...' )

_ntimeout := getMv("MGF_SFATO")

cQry := " select    ZFR_CODIGO,"
cQry += "           ZFR_DESCRI,"
cQry += "           ZFR_TIPO  ,"
cQry += "           ZFR_URL   ,"
cQry += "           (UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZFR_PAYLOA, 2000, 1)) || " 
cQry += "               UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZFR_PAYLOA, 2000, 2001)))  ZFR_PAYLOA,"
cQry += "           ZFR_RESPOT,"
cQry += "           ZFR_INTERV,"
cQry += "           ZFR_TOLERA,"
cQry += "           ZFR_VALOR ,"
cQry += "           ZFR_POSH  ,"
cQry += "           ZFR_POSV  ,"
cQry += "           ZFR_TAMH  ,"
cQry += "           ZFR_TAMV  ,"
cQry += "           ZFR_FONTE ,"
cQry += "           ZFR_ATIVO ,"
cQry += "           ZFR_ALERT ,"
cQry += "           ZFR_MIN   ,"
cQry += "           ZFR_MAN   "
cQry += " FROM " + retsqlname("ZFR") + " where d_e_l_e_t_ <> '*' and "
cQry += " ZFR_ATIVO = '1' "
    
TcQuery cQry New Alias "TMPZFR"

Do while !(TMPZFR->(EOF()))
   
   aRet := StartJob("U_WSC79E",GetEnvServer(),.F.,;
                _nni,;
                TMPZFR->ZFR_CODIGO,;
                TMPZFR->ZFR_DESCRI,;
                TMPZFR->ZFR_TIPO,;
                TMPZFR->ZFR_URL,;
                TMPZFR->ZFR_PAYLOA,;
                TMPZFR->ZFR_RESPOT,;
                TMPZFR->ZFR_INTERV,;
                TMPZFR->ZFR_TOLERA,;
                TMPZFR->ZFR_VALOR,;
                TMPZFR->ZFR_POSH,;
                TMPZFR->ZFR_POSV,;
                TMPZFR->ZFR_TAMH,;
                TMPZFR->ZFR_TAMV,;
                TMPZFR->ZFR_FONTE,;
                TMPZFR->ZFR_ATIVO,;
                TMPZFR->ZFR_MIN,;
                TMPZFR->ZFR_MAN,;
                TMPZFR->ZFR_ALERT,;
                _ntimeout) 

    TMPZFR->(Dbskip())

Enddo

TMPZFR->(Dbclosearea())

U_MFCONOUT(' Encerrando monitoramento...' )

Return


/*/{Protheus.doc} MGFWSC79E - Monitora Regra
	@author Josué Danich
	@since 30/12/2019
/*/
User Function WSC79E (_nni,;
                        _cZFR_CODIGO,;
                        _cZFR_DESCRI,;
                        _cZFR_TIPO,;
                        _cZFR_URL,;
                        _cZFR_PAYLOA,;
                        _cZFR_RESPOT,;
                        _cZFR_INTERV,;
                        _cZFR_TOLERA,;
                        _cZFR_VALOR,;
                        _cZFR_POSH,;
                        _cZFR_POSV,;
                        _cZFR_TAMH,;
                        _cZFR_TAMV,;
                        _cZFR_FONTE,;
                        _cZFR_ATIVO,;
                        _cZFR_MIN,;
                        _cZFR_MAN,;
                        _cZFR_ALER,;
                        _ntimeout) 

    Local oWS
    Local oDlg
    Local oGet
    Local cIdEnt     := ""
    Local cURL       := ""
    Local cStatus    := ""
    Local cAuditoria := ""
    Local aSize      := {}
    Local aXML       := {}
    Local nX         := 0
    Local odetret    := nil

    U_MFCONOUT('Monitorando regra ' + _cZFR_CODIGO + " - " + alltrim(_cZFR_DESCRI) + '...' )

    RPCSetType( 3 )

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

    If _cZFR_TIPO == 'J' .OR. _cZFR_TIPO == 'G' .or. _cZFR_TIPO == 'T' //Monitoramento de serviço via Json

        _cHeadRet		:= ""
	    _aHeadOut		:= {}

	    aadd(_aHeadOut,'Content-Type: application/json')

	    _nTimeIni		:= seconds()
	    
        If _cZFR_TIPO == 'J'  //METODO POST
            _cPostRet		:= httpPost(_cZFR_URL,, _cZFR_PAYLOA, _ntimeout, _aHeadOut, @_cHeadRet)
        Elseif _cZFR_TIPO == 'G' .or.  _cZFR_TIPO == 'T'//METODO GET
           aHeadStr := {}
           cHeaderRet := ""
            aadd( aHeadStr, 'Content-Type: application/json')
   			_cPostRet := httpQuote( alltrim(_cZFR_URL) , "GET", alltrim(_cZFR_PAYLOA),  , _nTimeOut , aHeadStr , cHeaderRet  )
        Endif
	    _nTimeFin		:= seconds()
	    _nTimeProc		:= _ntimefin - _ntimeini
	
	    _nStatuHttp	:= httpGetStatus()
 
        If valtype(_cpostret) == "U"
            _cpostret := "Falha de conexão"
        Endif

        If _cZFR_TIPO == 'T' 

            If ALLTRIM(_cZFR_PAYLOA) $ _cPostRet

                fwJsonDeserialize( _cPostRet, @oDetRet )

                if valtype(oDetRet:ITENPENDENTES) == "N"
                    _cpostret := alltrim(str(oDetRet:ITENPENDENTES))
   
                    _cstatus := "ALERTA"
                    _ntot := oDetRet:ITENPENDENTES

                     If _ntot >=  _cZFR_MIN .and. _ntot <= _cZFR_ALER
                        _cstatus := "OK"
                    Elseif _ntot >=  _cZFR_MIN .and. _ntot <= _cZFR_MAN
                        _cstatus := "ALERTA"
                    Elseif _ntot <=  _cZFR_MIN .or. _ntot >= _cZFR_MAN
                        _cstatus := "FALHA"
                    Endif

                else
                    _cpostret := "FALHA"
                    _cstatus := "FALHA"
                Endif

            elseif "{" $ _cPostRet
                
                _cpostret := "0"
                _cstatus := "OK"

            else
                
                _cpostret := "FALHA" 
                _cstatus := "FALHA"   

            Endif

        else
            

            _cstatus := IIF(_nStatuHttp >=200 .AND. _nStatuHttp <= 299, "OK","FALHA")

            If _cstatus == "FALHA"

                //Valida se já teve falhas seguidas
                cQry := " select   ZFS_STATUS  "
                cQry += " FROM " + retsqlname("ZFS") + " where d_e_l_e_t_ <> '*' and "
                cQry += " ZFS_CODIGO = '" + _cZFR_CODIGO + "' "
                cQry += " AND ZFS_DATA = '" + DTOS(DATE())  + "' ORDER BY R_E_C_N_O_ DESC"
    
                If select("TMPZFS") > 0
                    TMPZFS->(Dbclosearea())
                Endif

                TcQuery cQry New Alias "TMPZFS"

                If !(TMPZFS->(EOF()))
                    _cstatus := "TEMPF"
                    _nni := 1
                    Do while !(TMPZFS->(EOF())) .and. _nni <= getmv("MGFWSC79N",,3)
                       _nni++
                        If alltrim(TMPZFS->ZFS_STATUS) == "TEMPF" .OR. alltrim(TMPZFS->ZFS_STATUS) == "FALHA"
                            _cstatus := "FALHA"
                        Endif
                     TMPZFS->(Dbskip())
                  Enddo
                Endif

            Endif

        Endif
	
		U_MFCONOUT('Gravando Resultado da consulta json: ' + allTrim( str( _nStatuHttp ) ) + " - " + _cPostRet)

        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := _cZFR_CODIGO
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := _cZFR_PAYLOA
        ZFS->ZFS_RESPOS     := _cPostRet
        ZFS->ZFS_TEMPO      := _nTimeProc
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())


    Endif
 
    If _cZFR_TIPO == 'Q' //Monitoramento de serviço query
    
        If Select("TMPQRY") > 0
            TMPQRY->(Dbclosearea())
        Endif

        U_MFCONOUT('Executando query da regra ' + " - " + alltrim(_cZFR_DESCRI) + '...' )

        _cZFR_PAYLOA := alltrim(_cZFR_PAYLOA)

        _cZFR_PAYLOA := strtran(_cZFR_PAYLOA,chr(13)," ")
        _cZFR_PAYLOA := strtran(_cZFR_PAYLOA,chr(10)," ")

        _cqry := &(_cZFR_PAYLOA)    

        TcQuery _cqry New Alias "TMPQRY"

        If !TMPQRY->(Eof())
            _ntot := TMPQRY->TOT
        Else
            _ntot := 0
        Endif

        //Monitor de pedidos ecommerce
        If _cZFR_CODIGO == '000000001'

            U_MFCONOUT('Ajustando arquivo de consulta da regra ' + " - " + alltrim(_cZFR_DESCRI) + '...' )
            //Ajusta arquivo de execução de consulta
            _larq := .F.
            _carqexe := getmv("MGFWSC79E",,"\\spdwvhml016\Consulta\executa.bat")
            nHandle := FT_FUse(_carqexe)
            _cdt := dtos(date()-10)
            _cdt := substr(_cdt,1,4) + "-" + substr(_cdt,5,2) + "-" + substr(_cdt,7,2)


            If nHandle = -1
                _larq := .T.
            Else
                FT_FGoTop()
                cLine  := alltrim(FT_FReadLn())
 
                If _cdt != substr(cline,51,10)
                    _larq := .T.
                Endif

            Endif

            If _larq //não tem arquivo ou precisa mudar
            
                FT_FUSE()
                _nresult := ferase(_carqexe)

                If file(_carqexe)
                    _ntot := 9999
                Else
                         
                    nHandle := fcreate(_carqexe)

                    If nHandle = -1
                        _ntot := 9999   
                    Else
                        _ctexto := 'c:\ConsultaeCommerce\ConsultaPedidosCommerce.exe "'
                        _ctexto += _cdt 
                        _ctexto += 'T00:00:00.000Z"'
                         _ctexto += "> c:\consultaecommerce\consulta.txt"
                        FWrite(nHandle, _ctexto, len(_ctexto)) // Insere texto no arquivo
                        fclose(nHandle)                     
                    Endif
                Endif
            Endif
                

            //Lê arquivo de consulta para array
            If _ntot != 9999
            
                _carqcon := getmv("MGFWSC79C",,"\\spdwvhml016\Consulta\CONSULTA.TXT")
                nHandle := FT_FUse(_carqcon)
                
                If nHandle = -1
                    _ntot := 9999   
                Else

                    _nLast := FT_FLastRec()
                    FT_FGoTop()
                    _nni := 1
                    _lfalha := .F.
                
                    Do while !FT_FEOF()

                        U_MFCONOUT('Validando pedido ' + strzero(_nni,6) + ' de ' + strzero(_nlast,6) + ' da regra ' + " - " + alltrim(_cZFR_DESCRI) + '...' )
                        
                        cLine  := alltrim(FT_FReadLn())   
                        
                        If substr(cline,1,19) == '{"lastModifiedDate"'
                        
                            oJson := JsonObject():New()
                            ret := oJson:FromJson(cLine)
                            _nId := oJson['id']
                            _cstatus := oJson['state']
                            
                            XC5->(Dbsetorder(5)) //XC5->IDECOM

                            If _cstatus == "SUBMITTED" .AND. !(XC5->(Dbseek(_nId)))
                                _ntot++
                                If _lfalha
                                    _cqry += _nId + " - "
                                Else
                                    _lfalha := .T.
                                     _cqry := _nId + " - "
                                Endif
                            Endif

                            FreeObj(oJson)

                        Endif

                        FT_FSKIP()
                        _nni++

                    Enddo

                    FT_FUSE()

                Endif

            Endif                 

        Endif

        U_MFCONOUT('Gravando resultado da regra ' + " - " + alltrim(_cZFR_DESCRI) + ' - ' + alltrim(str(_ntot)) + "..." )

        _cstatus := "ALERTA"

        If _ntot >=  _cZFR_MIN .and. _ntot <= _cZFR_ALER
            _cstatus := "OK"
        Elseif _ntot >=  _cZFR_MIN .and. _ntot <= _cZFR_MAN
            _cstatus := "ALERTA"
        Elseif _ntot <=  _cZFR_MIN .or. _ntot >= _cZFR_MAN
            _cstatus := "FALHA"
        Endif


        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := _cZFR_CODIGO
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := _cqry
        ZFS->ZFS_RESPOS     := alltrim(str(_ntot))
        ZFS->ZFS_TEMPO      := 0
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())

    Endif

    If _cZFR_TIPO == 'S' //TSS

        _asefaz := {}
        _nni := 1
        _cerr := ""
        _nerr := 0

 
        //Busca filiais e estados da tabela syscompany
        cQry := " select m0_estent,min(m0_codfil) filial from sys_company where d_e_l_e_t_ <> '*'and m0_estent <> ' '  "
        cQry += " and m0_estent <> 'EX' group by m0_estent order by m0_estent"
    

        If select("TMPSYS") > 0
            dbselectarea("TMPSYS")
            TMPSYS->(Dbclosearea())
        Endif

        TcQuery cQry New Alias "TMPSYS"

        Do while !(TMPSYS->(EOF()))

            aadd(_asefaz,{TMPSYS->m0_estent,TMPSYS->FILIAL,"FALHA"})

            TMPSYS->(Dbskip())

        Enddo
  
        For _nni := 1 to len(_asefaz)

            cfilant := _asefaz[_nni,2]

            U_MFCONOUT('Consultando TSS da regra ' + " - " + alltrim(_cZFR_DESCRI) + ' para o estado de ' + _asefaz[_nni,1] + '...' )

            cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    	    cIdEnt :=  getCfgEntidade()
	    
		    If !Empty(cIdEnt)
			    oWS:= WSNFeSBRA():New()
			    oWS:cUSERTOKEN := "TOTVS"
			    oWS:cID_ENT    := cIdEnt
			    oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
			    If oWS:MONITORSEFAZMODELO()
				    aSize := MsAdvSize()
				    aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
 				    For nX := 1 To Len(aXML)
		
        			    If aXML[nX]:cModelo == "55"
		
                            If aXML[nX]:cStatusCodigo == "107"
                                _asefaz[_nni,3] := "OK"
                            Endif

                        Endif

                    Next

                Endif
        
            Endif

            If _asefaz[_nni,3] == "FALHA"
                _cerr += _asefaz[_nni,1] + "/"
                _nerr++
            Endif

        Next

        if _nerr == 0
            _cstatus := 'OK'
        elseif _nerr < 4
            _cstatus := 'ALERTA'
            _cerr := "FALHA SEFAZ - " + _cerr
        Else
            _cstatus := 'FALHA'
            _cerr := "FALHA TSS - " + _cerr
        Endif

        _cerr := substr(_cerr,1,len(_cerr)-1)

        U_MFCONOUT('Gravando resultado da regra ' + " - " + alltrim(_cZFR_DESCRI) + ' - ' + _cstatus + "..." )

        Dbselectarea("ZFS")
        Reclock("ZFS",.T.)
        ZFS->ZFS_CODIGO     := _cZFR_CODIGO
        ZFS->ZFS_DATA       := date()
        ZFS->ZFS_HORA       := time()
        ZFS->ZFS_REQUIS     := " "
        ZFS->ZFS_RESPOS     := _cerr
        ZFS->ZFS_TEMPO      := 0
        ZFS->ZFS_STATUS     := _cstatus
        ZFS->(Msunlock())  


    Endif
    
    U_MFCONOUT('Completou monitoramento da regra ' + " - " + alltrim(_cZFR_DESCRI) + '...' )

Return

