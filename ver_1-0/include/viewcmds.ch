// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : mvcCmds - Definições de comandos
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _VIEW_CMDS_CH

#  define _VIEW_CMDS_CH

#define IDX_CFG_SIZE        2
#define IDX_CFG_COLLECTIONS 1
#define IDX_CFG_LOOKUPS     2

#define LAYOUT_FREE         0
#define LAYOUT_COL          1

// **************************************************************************************
// Comandos para extensão de views
// **************************************************************************************
#command extended view <viewName>;
  => class _xv<viewName> from MVCView;;
       method _xv<viewName>();;
       method _end_xv<viewName>();;
       method _new();;

#command end extended view <viewName>;
  => end class;;
     method _end_xv<viewName>(aoController) class _xv<viewName>;;
       ::_endMVCView();;
     return;;
     method _new() class _xv<viewName>;;
     return;;
     method _xv<viewName>(aoController) class _xv<viewName>;;
       ::MVCView(<"ViewName">);;
       ::setController(aoController);;
       aAdd(::FClassesName, upper("_xv" + <"viewName">));;
     return

#command method <method> view <viewName>;
  => method <method> class _xv<viewName>

// **************************************************************************************
// Comandos para definição de visões
// **************************************************************************************
# command register extended view <viewName>;
  => class _v<viewName> from _xv<viewName>;;
       method _v<viewName>();;
       method _new();;
       method execCommand();;
       method _end_v<viewName>();;
     end class;;
     method _new() class _v<viewName>;;
     return;;
     method _end_v<viewName>() class _v<viewName>;;
       ::_end_xv<viewName>();;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _v<viewName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _v<viewName>(aoController) class _v<viewName>;;
       ::_xv<viewName>(aoController);;
       aAdd(::FClassesName, upper("_v" + <"viewName">))

# command register view <ViewName>;
  => class _v<ViewName> from MVCView;;
       method _v<ViewName>();;
       method _end_v<ViewName>();;
       method _new() constructor;;
       method execCommand();;
     end class;;
     method _new() class _v<ViewName>;;
     return;;
     method _end_v<ViewName>(aoOwner) class _v<ViewName>;;
       ::_endMVCView();;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _v<ViewName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _v<ViewName>(aoOwner) class _v<ViewName>;;
       ::MVCView(<"ViewName">);;
       ::setController(aoOwner);;
       aAdd(::FClassesName, upper("_v"+<"ViewName">))

# command message <msgCode> process <procName>;
  => if isNull(_child);;
       ::addCapture(<msgCode>, \{|oNotify, ctx| ctx:execCommand(<'procName'>, oNotify) \});;
     else;;
       _child:addCapture(<msgCode>, \{|oNotify, ctx| ctx:execCommand(<'procName'>, oNotify) \});;
     endif

# command presentation <PresentationName>;
               [ type <type: CRUD, DIALOG, LOOKUP>];
               [ <automap: AUTOMAP> [<autoShow: noShow, no show>] ];
  => iif(.f.,<PresentationName>(),);;
     static function <PresentationName>(aoSender);;
       local _view := biNewPresentation(<"PresentationName">, <"type">, <.automap.>, !<.autoShow.>, aoSender);;
       local self := aoSender, _ctx := _view;;
       local _child := _ctx, _aStack, _wizard;;
       _aStack := { _ctx }

# command presentation <PresentationName> type DIALOG NO POPUP;
               [ <automap: AUTOMAP> [<autoShow: noShow, no show>] ];
  => iif(.f.,<PresentationName>(),);;
     static function <PresentationName>(aoSender);;
       local _view := biNewPresentation(<"PresentationName">, "DIALOG NO POPUP", <.automap.>, !<.autoShow.>, aoSender);;
       local self := _view, _ctx := _view;;
       local _child := _ctx, _aStack, _wizard;;
       _aStack := { self }

# translate presentation:<methName>([<params,...>]);
  => self:getPresentation():<methName>([<params>])

// --------------------------------
// comandos para ajuste de propriedade
// --------------------------------
# command caption <caption>;
  => _child:setCaption(<caption>)
  
# command tooltip <tooltip>;
  => _child:setTooltip(<tooltip>)

# command vertical position <anchorY: CENTER, TOP, BOTTOM, FULL>;
  => _child:setAnchor(<"anchorY">, nil)

# command horizontal position <anchorX: CENTER, LEFT, RIGHT, FULL>;
  => _child:setAnchor(nil, <"anchorX">)

# command center screen;
  => horizontal position CENTER; vertical position CENTER

# command full screen;
  => horizontal position FULL; vertical position FULL

# command width <nWidth>;
  => _child:setWidth(<nWidth>)

# command height <nHeight>;
  => _child:setHeight(<nHeight>)

# command width <nWidth>%;
  => width (<nWidth>/100)

# command height <nHeight>%;
  => height (<nHeight>/100)

# command top <nTop>;
  => _child:setTop(<nTop>)

# command bottom <nBottom>;
  => _child:setBottom(<nBottom>)

# command left <nLeft>;
  => _child:setLeft(<nLeft>)

# command right <nRight>;
  => _child:setRight(<nRight>)

# command position <nLeft>, <nTop>;
  => left <nLeft>; top <nTop>

# command dimension <nWidth>, <nHeight>;
  => width <nWidth>; height <nHeight>

# command dimension <nWidth>%, <nHeight>%;
  => width <nWidth>%; height <nHeight>%

# command visible;
  => _child:setVisible(.t.)

# command hide;
  => _child:setVisible(.f.)
  
# command scroll auto;
  => _child:setScroll(SCROLL_AUTO)
  
# command scroll hidden;
  => _child:setScroll(SCROLL_HIDDEN)
  
# command scroll none;
  => _child:setScroll(SCROLL_NONE)
  
# command scroll show;
  => _child:setScroll(SCROLL_SHOW)

# command draggable [scope <scope>];
  => _child:setDraggable(.t.);;
     [_child:setDragScope(<scope>)]

# command draghandle;
  => _view:setDragHandle(_child)

# command droppable  [scope <scope>];
  => _child:setDroppable(.t.);;
    [_child:setDropScope(<scope>)]

# command align client;
  => _child:setAlign(VW_ALIGN_ALLCLIENT)

# command align top;
  => _child:setAlign(VW_ALIGN_TOP)

# command align bottom;
  => _child:setAlign(VW_ALIGN_BOTTOM)

# command align left;
  => _child:setAlign(VW_ALIGN_LEFT)

# command align right;
  => _child:setAlign(VW_ALIGN_RIGHT)

# command align none;
  => _child:setAlign(VW_ALIGN_NONE)

# command layout free;
  => _child:setLayout(LAYOUT_FREE, nil)

# command layout <nCol> <col: col, cols, column, columns> ;
  => _child:setLayout(LAYOUT_COL, <nCol>)

# command layout default;
  => layout 1 col

# command status bar <state: OFF, ON>;
  => _child:setStatusBar(<"state"> == "ON")

# command title <title>;
  => caption <title>

# command picture <cPicture> ;
  => _child:setPicture( <cPicture> )

# command password [<lOff:off>];
  => _child:setPassword( !<.lOff.> )

# command description page <text>;
  => _child:setDescription(<text>)

# command can mark item;
  => _child:setCanMark(.t.)

# command add item <code>, <text>;
  => _child:add( { <code> ,<text> })

# command label align <align>;
  => _child:setLblAlign(<align>)

# command label width <width>;
  => _child:setLblWidth(<width>)

# command add style <cClassName>;
  => _child:addStyle(<cClassName>)

// -----------------------------------------
// comandos para seleção de widgets
// -----------------------------------------
# command settings of <name> ;
  => _child := _view:getWidMap():getWidget(<"name">)

# command show <fieldName>;
  => _child := iif ('#' $ <"fieldName">, ;
                    _view:getWidMap():fld2Widget(<"fieldName">),;
                    _view:getWidMap():getWidget(<"fieldName">));;
     _child:setParent(_ctx)

# command hide <fieldName>;
  => _child := _view:getWidMap():getWidget(<"fieldName">);;
     _child:setParent(nil)

# command read only;
  => _child:setReadOnly(.T.)

# command multi line;
  => _child:setMultiLine(.t.)

# command memo;
  => _child:setMultiLine(.t.)

// -----------------------------------------
// comandos para adição de widgets terminais
// -----------------------------------------
# command add tree [name <name> ];
  => _child := _view:getWidMap():newTree(<"name">);;
     _child:setParent(_ctx)

# command add widget <widgetName> [ name <name>];
  => _child := _view:getWidMap():newWidget(<"widgetName">,[<"name">], _view:getController());;
     _child:setParent(_ctx)

# command add collection <collectionID> [name <name>];
  => _child := _view:getWidMap():newCollection(<"name">, <"collectionID">);;
     _child:setParent(_ctx)

# command add presentation <name>;
  => _child := _view:getWidMap():newPresentation(<"name">);;
     _child:setParent(_ctx)

# command add image [name <name>];
  => _child := _view:getWidMap():newImage(<"name">);;
     _child:setParent(_ctx)

# command resource name <resName>;
  => _child:setResName(<resName>)

# command file name <fileName>;
  => _child:setBMPFile(<fileName>)

# command options [<autosize: auto size>] [<stretch: stretch>] [<transparent: transparent>];
  => _child:setAutoSize(<.autosize.>);_child:setStretch(<.stretch.>);_child:setTransparent(<.stretch.>)

# command add button [name <name>];
  => _child := _view:getWidMap():newButton(<"name">);;
     _child:setParent(_ctx)

# command add title [name <name>];
  => _child := _view:getWidMap():newTitle(<"name">);;
     _child:setParent(_ctx)

# command add label [name <name>];
  => _child := _view:getWidMap():newLabel(<"name">);;
     _child:setParent(_ctx)

# command add table [name <name>];
  => _child := _view:getWidMap():newTable(<"name">);;
     _child:setParent(_ctx)

# command axisTop <AxisTop>;
  => _child:setAxisTop(<AxisTop>)
  
# command axisLeft <AxisLeft>;
  => _child:setAxisLeft(<AxisLeft>)
  
# command axisBottom <AxisBottom>;
  => _child:setAxisBottom(<AxisBottom>)
  
# command axisRight <AxisRight>;
  => _child:setAxisRight(<AxisRight>)
  
# command axises <Axises>;
  => _child:setAxises(<Axises>)
  
# command putData <PutData>;
  => _child:setData(<PutData>)
  
# command columns <Columns>;
  => _child:setColumns(<Columns>)

# command add chart [name <name>];
  => _child := _view:getWidMap():newChart(<"name">);;
     _child:setParent(_ctx)

# command add frame [name <name>] url <url>;
  => _child := _view:getWidMap():newIFrame(<"name">);;
     _child:setUrl(<url>);;
     _child:setParent(_ctx)
  
# command add vspacer [name <name>];
  => _child := _view:getWidMap():newVSpacer(<"name">);;
     _child:setParent(_ctx)

# command add hspacer [name <name>];
  => _child := _view:getWidMap():newHSpacer(<"name">);;
     _child:setParent(_ctx)

# command add combobox [name <name>] [<noCaption: no caption>];
  => _child := _view:getWidMap():newComboBox(<"name">, !<.noCaption.>);;
     _child:setParent(_ctx)

# command add checkbox [name <name>] [<noCaption: no caption>];
  => _child := _view:getWidMap():newCheckBox(<"name">, !<.noCaption.>);;
     _child:setParent(_ctx)

# command add listbox [name <name>] [<noCaption: no caption>] [headers <header,...>] [<sorteable: is sorteable>];
  => _child := _view:getWidMap():newListBox(<"name">, !<.noCaption.>, , <.header.>, <.sorteable.>);;
     [_child:setHeaders(\{ <header> \})];;
     _child:setParent(_ctx)

# command add markbrowse [name <name>] headers <header,...> [<filter:no filter>];
  => _child := _view:getWidMap():newMarkBrowse(<"name">);;
     _child:setHeaders(\{ <header> \});;
     _child:setShowFilter(!<.filter.>);;
     _child:setParent(_ctx)

// ------------------------------------------------------------
// comandos para adição de widgets "containers" (muda contexto)
// ------------------------------------------------------------
# command add custom panel [name <name>];
  => add widget WCustomPanel [name <name>];;
     align bottom;;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child:getWidMap():getWidget("_PAN_BUTTONS");;
     _child := _ctx

# command add group [name <name>];
  => _child := _view:getWidMap():newGroup(<"name">);;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command add panel [name <name> ];
  => _child := _view:getWidMap():newPanel(<"name">);;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command add wizard [name <name>; ];
  => add widget WWizard [name <name>];;
     align client;;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child;;
     _wizard := _ctx

# command with introduction <text> ;
  => _child:setIntroduction(<text>)

# command with finish <text> ;
  => _child:setFinish(<text>)

# command with thanks;
  => with finish ""

# command with steps <min>[,<max>] ;
  => _child:setMinSteps(<min>)[;_child:setMaxSteps(<max>)]

# command pages;
  => _child := _ctx:getWidMap():childByPos(1):enableLayer( LAYER_LAYOUT_CENTER );;
     aAdd(_aStack, _child);;
     _ctx := _child

# command add page [name <name> ] [when <doWhen>([<paramsWhen,...>]) ];
                                  [valid <doValid>([<paramsValid,...>])];
                                  [execute <doExec>([<paramsExec,...>])];
                                  [<lUpdModel: update model>];
  => _child := _wizard:addPage(<"name">);;
     [_child:setWhen({ |event, ctx| ctx:execCommand(<'doWhen'> ,<paramsWhen>) })];;
     [_child:setValid({ |event, ctx| ctx:execCommand(<'doValid'> ,<paramsValid>) })];;
     [_child:setExecute({ |event, ctx| ctx:execCommand(<'doExec'> ,<paramsExec>) })];;
     _child:setUpdModel(<.lUpdModel.>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command add complete page [when <doWhen>([<paramsWhen,...>]) ];
                            [valid <doValid>([<paramsValid,...>])];
                            [execute <doExec>([<paramsExec,...>])];
  => _child := _wizard:addPage("_complete");;
     [_child:setWhen({ |event, ctx| ctx:execCommand(<'doWhen'> ,<paramsWhen>) })];;
     [_child:setValid({ |event, ctx| ctx:execCommand(<'doValid'> ,<paramsValid>) })];;
     [_child:setExecute({ |event, ctx| ctx:execCommand(<'doExec'> ,<paramsExec>) })];;
     _child:setUpdModel(.t.);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command end wizard;
  => aSize(_aStack, len(_aStack)-1);;
     _ctx := atail(_aStack);;
     _child := nil

# command end custom panel;
  => aSize(_aStack, len(_aStack)-1);;
     _ctx := atail(_aStack);;
     _child := nil

# command end <x: group, page, panel, pages, layer> [<name>];
  => aSize(_aStack, len(_aStack)-1);;
     _ctx := atail(_aStack);;
     _child := nil

# command add confirmation [name <name>; ];
  => add widget WConfirmation [name <name>];;
     align client;;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child;;
     _child := _ctx:getWidMap():childByPos(1):getLayer( LAYER_LAYOUT_CENTER );;
     aAdd(_aStack, _child);;
     _ctx := _child

# command end confirmation;
  => aSize(_aStack, len(_aStack)-1);;
     _ctx := atail(_aStack);;
     _child := nil

# command add browser [name <name> ];
  => add widget WBrowser [name <name>];;
     align client;;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command end browser;
  => aSize(_aStack, len(_aStack)-1);;
     _ctx := atail(_aStack);;
     _child := nil

# command add grid [name <name> ];
  => _child := _view:getWidMap():newGrid(<"name">);;
     _child:setParent(_ctx)

# command add action <eventCode> icone <imageName>;
  => _child:addAction(<imageName>, <eventCode>)

# command <state: NEW, EDIT, DELETE, VIEW> state;
  =>

// ------------------------------------
// comandos para manipulação de "layer"
// ------------------------------------
# command begin layer [name <name>];
  => _child := _view:getWidMap():newLayer(<"name">);;
     _child:setParent(_ctx);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer top size <nHeight>;
  => _child := _ctx:enableLayer( LAYER_LAYOUT_NORTH );;
     _child:setHeight(<nHeight>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer bottom size <nHeight>;
  => _child := _ctx:enableLayer( LAYER_LAYOUT_SOUTH );;
     _child:setHeight(<nHeight>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer left size <nWidth>;
  => _child := _ctx:enableLayer( LAYER_LAYOUT_WEST );;
     _child:setWidth(<nWidth>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer right size <nWidth>;
  => _child := _ctx:enableLayer( LAYER_LAYOUT_EAST );;
     _child:setWidth(<nWidth>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer center;
  => _child := _ctx:getLayer( LAYER_LAYOUT_CENTER );;
     _child:setWidth(<nWidth>);;
     aAdd(_aStack, _child);;
     _ctx := _child

# command begin layer top size <nHeight>%;
  => begin layer top size (<nHeight>/100);

# command begin layer bottom size <nHeight>%;
  => begin layer bottom size (<nHeight>/100);

# command begin layer left size <nWidth>%;
  => begin layer left size (<nWidth>/100);

# command begin layer right size <nWidth>%;
  => begin layer right size (<nWidth>/100);

# command closable <lValue>;
  => _child:setClosable(<lValue>)

# command resizable <lValue>;
  => _child:setResizable(<lValue>)

# command slidable <lValue>;
  => _child:setSlidable(<lValue>)

# command open space <nValue>;
  => _child:setSpacing(<nValue>)

# command resizable;
  => _child:setResizable(.t.)

# command helper <type: ORIGINAL, CLONE>;
  => _child:setDragHelper(iif(<"type"> == "ORIGINAL",HELPER_ORIGINAL,HELPER_CLONE))

// ---------------------
// comandos para eventos
// ---------------------
#command event <eventCode> process <doEvent>;
  => _aEvent := _child:addEvent(<eventCode>, <"doEvent">, self)

#command exec in client <funcName>([<params,...>]);
  => _aEvent\[4\] := { <"funcName"> , {<params>} }

# command before activate <doEvent>([<params,...>]);
  => event EV_BEFORE_ACTIVATE process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on activate <doEvent>([<params,...>]);
  => event EV_ACTIVATE process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on click <doEvent>([<params,...>]);
  => event EV_MOUSE_CLICK process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on show <doEvent>([<params,...>]);
  => event EV_SHOW process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on drop <doEvent>([<params,...>]);
  => event EV_DRAG_DROP process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on change <doEvent>([<params,...>]);
  => event EV_CHANGE_VALUE process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on lost focus <doEvent>([<params,...>]);
  => event EV_LOST_FOCUS process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on row data <doEvent>([<params,...>]);
  => event EV_CUSTOM_ROW_DATA process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

# command on double click <doEvent>([<params,...>]);
  => event EV_CUSTOM_DBL_CLICK process { |event, ctx| ctx:execCommand(<'doEvent'> [,<params>]) }

// **************************************************************************************
// Comandos para extensão de widgets
// **************************************************************************************
#command extended widget <widgetName>;
  => class _xw<widgetName> from MVCCustomWidget;;
       method _xw<widgetName>();;
       method _new();;

#command end extended widget <widgetName>;
  => end class;;
     method _new() class _xw<widgetName>;;
     return;;
     method _xw<widgetName>(acName, aoController) class _xw<widgetName>;;
       ::MVCCustomWidget(acName, aoController);;
       aAdd(::FClassesName, upper("_xw" + <"widgetName">));;
     return

#command method <method> widget <widgetName>;
  => method <method> class _xw<widgetName>

// **************************************************************************************
// Comandos para definição de widgets
// **************************************************************************************
# command register extended widget <widgetName>;
  => class _w<widgetName> from _xw<widgetName>;;
       method _w<widgetName>();;
       method _new();;
       method execCommand();;
     end class;;
     method _new() class _w<widgetName>;;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _w<widgetName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _w<widgetName>(acName, aoController) class _w<widgetName>;;
       ::_xw<widgetName>(acName, aoController);;
       aAdd(::FClassesName, upper("_w" + <"widgetName">));;
       call widget() of self

# command register widget <widgetName>;
  => class _w<widgetName> from MVCCustomWidget;;
       method _w<widgetName>();;
       method _new();;
       method execCommand();;
     end class;;
     method _new() class _w<widgetName>;;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _w<widgetName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _w<widgetName>(acName, aoController) class _w<widgetName>;;
       ::MVCCustomWidget(acName, aoController);;
       aAdd(::FClassesName, upper("_w" + <"widgetName">));;
       call widget() of self

# command presentation widget;
  => iif(.f.,widget(),);;
     static function widget(self);;
       local _view := self, _ctx := _view, _child := _view, _aStack;;
       _aStack := { self }
     
// **************************************************************************************
// Finalizadores de blocos
// **************************************************************************************
# command end widget;
  => return

# command end presentation;
  => _child :=nil; return _view
             
# command end view;
  =>

#endif