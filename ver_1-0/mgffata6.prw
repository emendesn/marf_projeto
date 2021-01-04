#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10  )

static _aErr

//---------------------------------------------------------------------
//---------------------------------------------------------------------
user function MGFFATA6()

	If FieldPos("A1_XENVECO") > 0 .and. FieldPos("A1_XINTECO") > 0
		if M->A1_XENVECO == "1"
			M->A1_XINTECO := "0"
		endif
	endif

	If FieldPos("A1_XENVSFO") > 0 .and. FieldPos("A1_XINTSFO") > 0
		if M->A1_PESSOA == "J" .and. !empty( M->A1_CGC )
			if M->A1_XENVSFO == "S"
				M->A1_XINTSFO := "P"
			endif
		endif
	endif
return