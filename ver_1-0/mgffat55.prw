#include 'protheus.ch'
#include 'parmtype.ch'

user function MGFFAT55( nOpcX )
	local _lRet			:= .T.
	local cTiposSale	:= allTrim( getMv( "MGFTIPOSFO" ) )

	default nOpcX := 0

	if !ExisteSx6("MGF_FAT55A")
		CriarSX6("MGF_FAT55A", "L", "Habilita Funcionalodade da Rotina",'.T.' )
	endif

	if superGetMV("MGF_FAT55A", , .T.)
		if !IsBlind() .and. empty(M->C5_XTPROD)
			Help('',1,'TIPO DE PRODUTO',,' O tipo de produto não pode ficar em branco, Corrija o campo, por favor.',1,0)
			_lRet := .F.
		endif
	endif

	if nOpcX == 3 .or. nOpcX == 4
		if !( isInCallStack( 'U_MGFFAT51' ) .or. isInCallStack( 'U_MGFFAT53' ) .or. isInCallStack( 'U_RUNFAT53' ) )
			if M->C5_ZTIPPED $ cTiposSale
				help( '' , 1 , 'TIPO DO PEDIDO' , , ' O Tipo de Pedido é inválido. Este Tipo de Pedido é para uso exclusivo no Salesforce.' , 1 , 0 )
				_lRet := .F.
			endif
		endif
	endif

	if !IsBlind() .and. _lRet
		msgAlert("               PEDIDO GERADO NÚMERO: " + M->C5_NUM)
	EndIf

return _lRet