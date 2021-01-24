#Include 'Protheus.ch'
#include "topconn.ch"

/*/{Protheus.doc} MGFWSC78 - Cadastro de regras de monitor de integrações
	@author Josué Danich
	@since 30/12/2019
/*/


User Function MGFWSC78()
	
Local _cTitulo := "Cadastro de Regras de Monitor de Integrações"
Local aRotAdic :={} 

aadd(aRotAdic,{ "Monitor","U_WSC78M", 0 , 2 })

AxCadastro("ZFR",_cTitulo,,,aRotAdic)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} WSC78M - Tela de monitor de intregrações
@author  Josué Danich
@since 03/01/2020
/*/
//--------------------------------------------------------------
User Function WSC78M()
Static oDlg
Static opanel
Private _cverde1 := getmv("MGFWSC781",,"#A8D4ED")
Private _cverde2 := getmv("MGFWSC782",,"#F781BE")
Private _cvermelho := "#F22213"
Private _camarelo := '#FFFF00'
Private _ccinza := '#BDBEC0'
Private _cpreto := '#59595C'
Private _ntempo := getmv("MGFWSC78T",,20)
Private _ncont := 0
Private _ctela := '2'

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100,.F.,.T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
aPosObj := MsObjSize( aInfo, aObjects )

		
DEFINE MSDIALOG oDlg TITLE "Monitor de Integrações" FROM aSize[7], aSize[8] TO aSize[6]+200,aSize[5]+200 OF oMainWnd PIXEL 

	oPanel := TPaintPanel():new(0,0,aSize[6]+200,aSize[5]+200,oDlg)

	U_WSC78MP()

	oTimer := TTimer():New(100, {|| oPanel:ClearAll(), U_WSC78MP() }, oDlg )
    oTimer:Activate()


	ACTIVATE MSDIALOG oDlg CENTERED
 
Return

//--------------------------------------------------------------
/*/{Protheus.doc} WSC78MP - Monta boxes de monitoramento
@author  Josué Danich
@since 03/01/2020
/*/
//--------------------------------------------------------------
User Function WSC78MP()

Local cQry := ""

//Incrementa contador de tempo da tela
_ncont++

If _ncont > _ntempo

	_ncont := 0

	If _ctela == '1'
		_ctela := '2'
	Else
		_ctela := '1'
	Endif

Endif


cQry := " select    ZFR_CODIGO,"
cQry += "           ZFR_DESCRI,"
cQry += "           ZFR_TIPO  ,"
cQry += "           ZFR_URL   ,"
cQry += "           ZFR_PAYLOA,"
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
cQry += "           ZFR_MIN   ,"
cQry += "           ZFR_MAN   "
cQry += " FROM " + retsqlname("ZFR") + " where d_e_l_e_t_ <> '*' and"
cQry += " ZFR_ATIVO = '" + _ctela +  "' "

If select("TMPZFR") > 0
	TMPZFR->(Dbclosearea())
Endif
    
TcQuery cQry New Alias "TMPZFR"

Do while !(TMPZFR->(EOF()))

	cQry := " select    ZFS_STATUS,ZFS_RESPOS FROM ( SELECT ZFS_STATUS,ZFS_RESPOS "
	cQry += " FROM " + retsqlname("ZFS") + " where d_e_l_e_t_ <> '*'  AND "
	cQry += " ZFS_CODIGO = '" + alltrim(TMPZFR->ZFR_CODIGO) + "' ORDER BY R_E_C_N_O_ DESC) WHERE ROWNUM = 1"
    
	If select("TMPZFS") > 0
		TMPZFS->(Dbclosearea())
	Endif

	TcQuery cQry New Alias "TMPZFS"

	If ALLTRIM(TMPZFS->ZFS_STATUS) == "OK"
		If _ctela == '1'
			_ccor := _cverde1
		Else
			_ccor := _cverde2
		Endif
	Elseif ALLTRIM(TMPZFS->ZFS_STATUS) == "FALHA"
		_ccor := _cvermelho
	Else
		_ccor := _camarelo
	Endif


	If TMPZFR->ZFR_TIPO == 'J' .or. TMPZFR->ZFR_TIPO == 'G'   //Monitoramento de serviço via Json

		_ctexto := ALLTRIM(TMPZFR->ZFR_DESCRI)

		oPanel:addShape("id=0;type=1;left="+ALLTRIM(STR(TMPZFR->ZFR_POSH))+";top="+ALLTRIM(STR(TMPZFR->ZFR_POSV))+;
	 			";width="+ALLTRIM(STR(TMPZFR->ZFR_TAMH))+";height="+ALLTRIM(STR(TMPZFR->ZFR_TAMV))+";"+;
                "gradient=1,0,0,0,0,0.0," + _ccor + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	

		_ncentv := TMPZFR->ZFR_POSV	+ (TMPZFR->ZFR_TAMV/2) - ((TMPZFR->ZFR_FONTE/2)*1.3)
		_ncenth := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))*.85)

		_ntamv := TMPZFR->ZFR_FONTE * 2
		_ntamh := ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))) * 2.2

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE)) + ;
					",0,0,1;left="+ALLTRIM(STR(_ncenth))+";top="+ALLTRIM(STR(_ncentv))+";width="+ALLTRIM(STR(_ntamh))+";"+;
                "height="+ALLTRIM(STR(_ntamv))+";text=" + _ctexto + ";gradient=0,0,0,0,0,0,#000000;")

	Endif

	If  TMPZFR->ZFR_TIPO == 'S' //Monitoramento de serviço sped

		_ctexto := ALLTRIM(TMPZFR->ZFR_DESCRI)
		
		If ALLTRIM(TMPZFS->ZFS_STATUS) != "OK" 
			_ctexto := ALLTRIM(TMPZFS->ZFS_RESPOS)
		Endif

		If len(_ctexto) > 23
			_ctexto2 := substr(_ctexto,24,len(_ctexto))
			_ctexto := substr(_ctexto,1,23)
			_nlin := 2
		Else
			_nlin := 1
		Endif

		oPanel:addShape("id=0;type=1;left="+ALLTRIM(STR(TMPZFR->ZFR_POSH))+";top="+ALLTRIM(STR(TMPZFR->ZFR_POSV))+;
	 			";width="+ALLTRIM(STR(TMPZFR->ZFR_TAMH))+";height="+ALLTRIM(STR(TMPZFR->ZFR_TAMV))+";"+;
                "gradient=1,0,0,0,0,0.0," + _ccor + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	

		If _nlin == 1
			_ncentv := TMPZFR->ZFR_POSV	+ (TMPZFR->ZFR_TAMV/2) - ((TMPZFR->ZFR_FONTE/2)*1.3)
		Else

			_ncentv := TMPZFR->ZFR_POSV	+ (TMPZFR->ZFR_TAMV/2) - (2*((TMPZFR->ZFR_FONTE/2)*1.3))
			_ncentv2 := TMPZFR->ZFR_POSV	+ (TMPZFR->ZFR_TAMV/2) + ((TMPZFR->ZFR_FONTE/2)*1.3)	

		Endif

		_ncenth := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))*.85)

		_ntamv := TMPZFR->ZFR_FONTE * 2
		_ntamh := ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))) * 2.2

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE)) + ;
					",0,0,1;left="+ALLTRIM(STR(_ncenth))+";top="+ALLTRIM(STR(_ncentv))+";width="+ALLTRIM(STR(_ntamh))+";"+;
                "height="+ALLTRIM(STR(_ntamv))+";text=" + _ctexto + ";gradient=0,0,0,0,0,0,#000000;")

		If _nlin == 2

			oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE)) + ;
					",0,0,1;left="+ALLTRIM(STR(_ncenth))+";top="+ALLTRIM(STR(_ncentv2))+";width="+ALLTRIM(STR(_ntamh))+";"+;
                "height="+ALLTRIM(STR(_ntamv))+";text=" + _ctexto2 + ";gradient=0,0,0,0,0,0,#000000;")

		Endif

	Endif



	If TMPZFR->ZFR_TIPO == 'Q' //Monitoramento de serviço via query

		_ctexto := ALLTRIM(TMPZFR->ZFR_DESCRI)

		oPanel:addShape("id=0;type=1;left="+ALLTRIM(STR(TMPZFR->ZFR_POSH))+";top="+ALLTRIM(STR(TMPZFR->ZFR_POSV))+;
	 			";width="+ALLTRIM(STR(TMPZFR->ZFR_TAMH))+";height="+ALLTRIM(STR(TMPZFR->ZFR_TAMV))+";"+;
                "gradient=1,0,0,0,0,0.0," + _ccor + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	

		_cvalor := alltrim(TMPZFS->ZFS_RESPOS)

		_ncentv := TMPZFR->ZFR_POSV	+ ((18/2))
		_ncenth := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))*.85)
		_ncenth2 := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_cvalor)*(48/2)))

		_ntamv := TMPZFR->ZFR_FONTE
		_ntamh := ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))) * 2.2

		

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE))+",0,0,1;left="+ALLTRIM(STR(_ncenth))+";top="+ALLTRIM(STR(_ncentv))+;
				";width="+ALLTRIM(STR(_ntamh))+";height="+ALLTRIM(STR(_ntamv*2))+";text=" + _ctexto + ";gradient=0,0,0,0,0,0,#000000;")

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE*2))+",0,0,1;left="+ALLTRIM(STR(_ncenth2))+";top="+ALLTRIM(STR(_ncentv+60));
				+";width="+ALLTRIM(STR(_ntamh*3))+";height="+ALLTRIM(STR(_ntamv*5))+";text=" + _cvalor + ";gradient=0,0,0,0,0,0,#000000;")

	Endif

	If TMPZFR->ZFR_TIPO == 'T' .or. TMPZFR->ZFR_TIPO == 'K' .or. TMPZFR->ZFR_TIPO == 'Y' //Monitoramento de serviço via query

		_ctexto := ALLTRIM(TMPZFR->ZFR_DESCRI)

		oPanel:addShape("id=0;type=1;left="+ALLTRIM(STR(TMPZFR->ZFR_POSH))+";top="+ALLTRIM(STR(TMPZFR->ZFR_POSV))+;
	 			";width="+ALLTRIM(STR(TMPZFR->ZFR_TAMH))+";height="+ALLTRIM(STR(TMPZFR->ZFR_TAMV))+";"+;
                "gradient=1,0,0,0,0,0.0," + _ccor + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	

		_cvalor := alltrim(TMPZFS->ZFS_RESPOS)

		_ncentv := TMPZFR->ZFR_POSV	+ ((18/2))
		_ncenth := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))*.85)
		_ncenth2 := TMPZFR->ZFR_POSH	+ (TMPZFR->ZFR_TAMH/2) - ((LEN(_cvalor)*(48/2)))

		_ntamv := TMPZFR->ZFR_FONTE
		_ntamh := ((LEN(_ctexto)*(TMPZFR->ZFR_FONTE/2))) * 2.2

		

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE))+",0,0,1;left="+ALLTRIM(STR(_ncenth))+";top="+ALLTRIM(STR(_ncentv))+;
				";width="+ALLTRIM(STR(_ntamh))+";height="+ALLTRIM(STR(_ntamv*2))+";text=" + _ctexto + ";gradient=0,0,0,0,0,0,#000000;")

		oPanel:addShape("id=10;type=7;pen-width=5;font=arial,"+alltrim(str(TMPZFR->ZFR_FONTE*2))+",0,0,1;left="+ALLTRIM(STR(_ncenth2))+";top="+ALLTRIM(STR(_ncentv+60));
				+";width="+ALLTRIM(STR(_ntamh*3))+";height="+ALLTRIM(STR(_ntamv*5))+";text=" + _cvalor + ";gradient=0,0,0,0,0,0,#000000;")

	Endif

	TMPZFR->(Dbskip())

Enddo

_ntotal := 1344
_ncinza := _ntotal * (_ncont/_ntempo)


//barra de tempo para virar a tela
oPanel:addShape("id=0;type=1;left=0;top=0"+;
				 ";width="+alltrim(str(_ncinza))+";height=10;"+;
                "gradient=1,0,0,0,0,0.0," + _ccinza + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	

oPanel:addShape("id=0;type=1;left="+alltrim(str(_ncinza+1))+";top=0"+;
				 ";width="+alltrim(str(_ntotal-_ncinza))+";height=10;"+;
                "gradient=1,0,0,0,0,0.0," + _cpreto + ";pen-width=1;"+;
                "pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")	
			

Return
