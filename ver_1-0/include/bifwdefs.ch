// ######################################################################################
// Projeto: BI-FW - Framework para BI
// Modulo : Include
// Fonte  : bifwDefs - Definições de uso genérico
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _BIFW_DEFS_CH
#  define _BIFW_DEFS_CH

// **************************************************************************************
// Constantes de uso geral
// **************************************************************************************
#define CR      chr(13)
#define LF      chr(10)
#define CRLF    chr(13)+chr(10)
#define ASPAS_D '"'
#define ASPAS_S "'"

#define ALERT_ERROR 0000
#define ALERT_INFO 0001

// **************************************************************************************
// Erros (raise)
// **************************************************************************************

#xcommand APPEXCEPTION SEVERITY <severity:FATAL, ERROR, INFO>;
                       CODE <cCode> ;
                       MESSAGE <cMessage>;
                       SOLUCTION <cSoluction>;
                       [<lDetail: WITHOUT DETAILS>];
	=> UserException(<"severity"> + "|" + <cCode> + "|" + <cMessage> + "|" + <cSoluction> + "|" + iif(<.lDetail.>, "S","N"))

#xcommand APPRAISE ERROR <cErrorCode> MESSAGE <cText> ;
	=> if valType(self) == "O" ;;
       APPEXCEPTION SEVERITY ERROR CODE <cErrorCode> MESSAGE getClassName(self) + ":" + <cText> SOLUCTION "";;
    else;;  
       APPEXCEPTION SEVERITY ERROR CODE <cErrorCode> MESSAGE "APPLICATION: " + <cText> SOLUCTION "";;
    endif

#xcommand APPRAISE WARNING <cErrorCode> MESSAGE <cText> SOLUCTION <cSoluction>;
	=> ;           
	  if valType(self) == "O" ;;
       APPEXCEPTION SEVERITY ERROR CODE <cErrorCode> MESSAGE getClassName(self) + ":" + <"cText"> SOLUCTION <cSoluction> WITHOUT DETAILS;;
    else;;  
       APPEXCEPTION SEVERITY ERROR CODE <cErrorCode> MESSAGE "APPLICATION: " + <"cText"> SOLUCTION <cSoluction> WITHOUT DETAILS;;
    endif

#xcommand APPRAISE FATAL <cErrorCode> MESSAGE <cText> ;
	=> if valType(self) == "O" ;;
       APPEXCEPTION SEVERITY FATAL CODE <cErrorCode> MESSAGE getClassName(self) + ":" + <cText> SOLUCTION "";;
    else;;  
       APPEXCEPTION SEVERITY FATAL CODE <cErrorCode> MESSAGE "APPLICATION: " + <cText> SOLUCTION "";;
    endif

#xcommand RAISE ERROR <cCode> MESSAGE <cMessage>;
	=> ;
   APPRAISE ERROR <cCode> MESSAGE <cMessage>

#xcommand RAISE ABSTRACT METHOD ;
	=> ;
   APPRAISE ERROR "ABSTRACT_METHOD" MESSAGE "interface OR abstract method not implemented or inherited call executed"

#xcommand RAISE NOT SUPPORTED METHOD ;
	=> ;
   APPRAISE ERROR "NOT_SUPORTED_METHOD" MESSAGE "method not suported"

#xcommand RAISE READ ONLY PROPERTY ;
	=> ;
   APPRAISE ERROR "READ_ONLY_PROPERTY" MESSAGE "Property is read only"

#xcommand RAISE NOT OPEN ;
	=> ;
   APPRAISE ERROR "NOT_OPEN" MESSAGE "Data Object/Database not open"

#xcommand RAISE ALREADY OPEN ;
	=> ;
   APPRAISE ERROR "ALREADY_OPEN" MESSAGE "Data Object/Database already open"

#xcommand RAISE ALREADY EXIST ;
	=> ;
   APPRAISE ERROR "ALREADY_EXIST" MESSAGE "Data Object/Database already exists"

#xcommand RAISE NOT FOUND [FILE <name> [FIELD <fieldName>]] ;
	=> ;
   APPRAISE ERROR "NOT_FOUND" MESSAGE "Object not found" [ + " -> Filename " + <(name)> [ + ":" + <(fieldName)> ]]

#xcommand RAISE DUPLICATE OBJECT [ ID <id>];
	=> ;
   APPRAISE ERROR "DPL_OBJ" MESSAGE "Duplicated object not allowed (same ID)" [ + " -> ID " + <(id)> ]

#xcommand RAISE INVALID PARAM <paramName> MESSAGE <text> ;
	=> ;
   APPRAISE ERROR "INV_PARAM" MESSAGE (<"text">) + " -> Parameter " + <"paramName">

#xcommand RAISE FATAL [PARAM <paramName>] MESSAGE <text> ;
	=> ;
   APPRAISE ERROR "FATAL" MESSAGE (<text>) [+ " -> Parameter " + <"paramName">]

#xcommand RAISE NOT EDIT MODE ;
	=> ;
   APPRAISE ERROR "NOT_EDIT_MODE" MESSAGE "It´s not in 'edit mode'. Call '::beginEdit()' first."

#xcommand RAISE PENDDING OPERATION;
	=> ;
   APPRAISE ERROR "PENDDING_OPERATION" MESSAGE "Pendding operation."

#xcommand RAISE PENDDING OPERATION;
	=> ;
   APPRAISE ERROR "PENDDING_OPERATION" MESSAGE "Pendding operation."

#xcommand RAISE CALCULATED FIELD <fieldName> ;
	=> ;
   APPRAISE ERROR "CALCULATED_FIELD" MESSAGE "This calculated field, not allowed modify. Field: " + <fieldName>

// **************************************************************************************
// Validação de parâmetros
// **************************************************************************************
#xtranslate testParam(<varName>, <ctype>, <alReadOnly>);
	=> ;
	iif(<alReadOnly>, UserException(getClassName(self) + " (READ_ONLY_PROPERTY): Property is read only"), ;
     iif(valType(<varName>) == left(<ctype>,1), nil, UserException("argument error in parameter, expected " + left(<ctype>,1))))

// **************************************************************************************
// Definição e manipulação de classes/objetos
// **************************************************************************************

#xcommand release <obj:object, obj> <varObj1>[,<varObjN,...>] ;
  => iif( <varObj1> <> NIL , ( <varObj1>:_end(), <varObj1> := NIL),) ;
      [ ; iif ( <varObjN>  <> NIL, ( <varObjN>:_end(), <varObjN> := NIL),) ]

// definição de propriedade
#xcommand DATA <propertyName> AS [<ctype: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT>] PROPERTY [<ro: read only, readonly>];
  =>;
    data F<propertyName>;;
    method get<propertyName>();;
    method set<propertyName>()

*/    
// **************************************************************************************
// Translates especificos
// **************************************************************************************

#translate isArray(<var>);
	=> (valType(<var>)=="A")

#translate isBlock(<var>);
	=> (valType(<var>)=="B")

#translate isNull(<var>);
	=> (valType(<var>)=="U")

#translate isNull(<var>, <value>);
	=> (iif(isNull(<var>), <value>, <var> ))


#translate httpSend(<exp>);
	=> wiHttpSend(<exp>)

// **************************************************************************************
// Ações utilizadas na movimentação de registros em IDAO
// **************************************************************************************
#  define DAO_FIRST  -1  // vai para o 1o registro
#  define DAO_SKIP   0   // movimentação de 'n' registros
#  define DAO_LAST   1   // vai para o último
      
// **************************************************************************************
// Ações utilizadas nas operações (atualização) registros em IDAO
// **************************************************************************************
#  define DAO_OPER_QUERY  "0"
#  define DAO_OPER_INSERT "1"
#  define DAO_OPER_UPDATE "2"
#  define DAO_OPER_DELETE "4"
#  define DAO_OPER_AUTO   "3"
                 
// utilizado para testes
#  define DAO_OPER_TEST_UPD DAO_OPER_INSERT + "|" + DAO_OPER_UPDATE + "|" + DAO_OPER_DELETE + "|" + DAO_OPER_AUTO

// **************************************************************************************
// Fatores utilizado no calculo das larguras dos widgets
// **************************************************************************************
#  define VW_FATOR_PIXEL_L	1
#  define VW_FATOR_PIXEL_C	3
#  define VW_FATOR_PIXEL_N	2
#  define VW_FATOR_PIXEL_D	1
#  define VW_FATOR_PIXEL_M	20

#  define VW_BUTTON_PIXEL	20

// **************************************************************************************
// Códigos de retornos de views - padronizados
// Códigos do usuário devem ser superios a 1000
// **************************************************************************************
#define RC_NO_PROCESS       0
#define RC_OK               1
#define RC_CANCEL           2
#define RC_YES              3
#define RC_NO               4
#define RC_RETRY            5
#define RC_USER          1000

// **************************************************************************************
// Identifica os estados da aplicação
// **************************************************************************************
#define APP_STATE_INIT      1
#define APP_STATE_STOPING   2
#define APP_STATE_RUNNING   3
#define APP_STATE_CANCEL    4

/*
-----------------------------------------------------------------------------------------
Identificadores de temas
-----------------------------------------------------------------------------------------
*/      
#define P11_DEFAULT         "p11"

#define WI_THEME_LIST       { P11_DEFAULT }
#define WI_DEFAULT_THEME    P11_DEFAULT

/*
-----------------------------------------------------------------------------------------
Identifica o idioma
-----------------------------------------------------------------------------------------
*/      
#ifdef SPANISH
	#define IDIOMA "ES"
#else
  #ifdef ENGLISH
	  #define IDIOMA "EN"
  #else
	  #define IDIOMA "PT"
  #endif
#endif
      
/*
-----------------------------------------------------------------------------------------
Momentos de execução da ação
-----------------------------------------------------------------------------------------
*/      
#define BEFORE_ACTION   2
#define EXEC_ACTION     3
#define AFTER_ACTION    4

/*
-----------------------------------------------------------------------------------------
Valores lógicos utilizados em JS
-----------------------------------------------------------------------------------------
*/                              
#define CHKBOX_ON       1   // equivale a .T.
#define CHKBOX_OFF      0   // equivale a .F.

/*
-----------------------------------------------------------------------------------------
Manipulação de httpSession
-----------------------------------------------------------------------------------------
*/                              

#command httpSession-><identifier> := <exp> ;
  => biSetSession(<"identifier">, <exp>)

#endif