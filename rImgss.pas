unit rImgss;

interface

uses
  Types, LCLType,LMessages, LCLIntf,
  Classes, SysUtils, TypInfo, Variants, Graphics,Controls,StdCtrls, ExtCtrls, Forms,Menus,
  tren, DOM, XMLRead,XMLSer,                  //   ,SimpleXML
  JvInterpreter,JvHtControls;//,Math;
  //JvImage,JvResources, JvgUtils,{DB,}JvSimpleXml,
  //,JvLabel,JvPanel,JvHtControls,JvHotTrackPersistent,JvgListBox;

const
  LM_SH_MESSAGE =        LM_USER + 1;
  //wp
  CMD_SH_MOUSEDOWNIMG  = 101;
  CMD_SH_MOUSEUPIMG =    102;
  CMD_SH_MOUSEMOVEIMG =  103;


type
  TrImgType=(rIm,rLs,rPn,rLb);
  TrMoveType=(rAll,rOnlH,rOnlV);
  TrShemModeType=(rShPlay,rShEdit,rShMeas);
  TrEvType=(rEMsDown,rEMsUp,rEMsMove,rEMsEnter,rEMsLeave,rEStCh,rEValCh,rEFaultCh,rEVisCh,rEQuit,rEStopTm,rERunTm,
        rEAnValCh,rEChkAsk,rENxAsk,rEPrAsk,rEVsAsk,rEAskOK,rEAskCansel,rESetLbl,rEBckMeas,rEMsg,rEMyAnsv,rENil);
  TrActType=(rAcSt,rAcVis,rAcVisChd,rGoPas,rAcMove,rAcMoveTo,rAcVal,rAcValTo,
        rAcHlp,rAcShwPar,rAcRegVal,rAcTmr,rAcFlt,rAcErr,rAcMeas,rAcBrMs,rAcRstMs, rAcQuit,rAcJrnl,
        rAcRule,rAcChkAsk,rAcNxAsk,rAcPrAsk,rAcVsAsk,rAcAskOK,rAcAskCansel, rAcSetLbl,rAcMsg,rAcStopTm,rAcRunTm);
  TrCndType=(rEq,rNEq,rGr,rEGr,rLes,rELes);
  TrCndsType=(rAnd,rOr,rNone);
  TrTypeSub=(rBook,rAskTxt,rAskRect,rOuter,rTren,rVideo);
  TrCndOf=(cSt,cVs,cVal,cMov,cFault,cGoPas);
  TTypeRule=(Tpr1,Tpr2);  
  TTypePar=(rPCnd,rPAct);
  TTypeItLstH=(rStr,rPic,rHtm,rPathDoc,rPathPic);
  TIconPosition = (LfTp, LfBt, RtBt, RtTp);
type
  TrImgs = class;   //основной
  rImg = class;     //
  TrStats = class;  //Статус
  rStat = class;    //
  TConds = class;   //Условия
  Cnd = class;      //
  TrVals = class;   //Значения
  rRct = class;      //
  TrRcts = class;   //Области
  rVal = class;      //
  TrTmrs = class;   //Таймеры
  rTmr = class;      //

  TrShVls = class;   //Значения  схемы не public
  rShVl = class;      //

  TrMemo = class;
  TrCoord = class;   //Координаты
  TAnVls = class;   //Параметры значения
  TAnlgPrib = class;   //Параметры аналового прибора
  rMn = class;      //
  TrMns = class;   //меню
  rEv = class;      //
  TrEvs = class;   //меню
  rAct = class;      //
  TrActs = class;   //действия
  TrAsk = class;
  TrAsks = class;

//'TrAnsTxts') or (cln='TrGrRects') or (cln='TrVRects') or (cln='TrAnsRects')
  TrAnsRect = class;
  TrAnsRects = class;
  TrVRect = class;
  TrVRects = class;
  TrGrRect = class;
  TrGrRects = class;
  TrAnsTxt = class;
  TrMsgs = class;   //collect сообщения
  rMsg = class;    //items
  TrFragment = class;
  TrFragments = class;

  TrMRuls =class;   //оценивание
  rMrul = class;
//  TrAnss = class;   //основной
//  rAns = class;     //
  TrMeass = class;     //измерения
  rMsr = class;
  TrCndMsrs = class;
  rCndMsr = class;
//  TTstLstEnd = class;   //для проверки при окончании
//  TChkEnd = class;
  TrJournal = class;
  //TrDiary = class;
  //rJrn = class;
  TrLstsHlp = class;
  rLstHlp = class;

  TrPages = class;
  TrPg = class;
  //TRepAll = class;
  //rRepAsk = class;
  //TRepPack = class;

  rShrPr = class;
  TrShrPrs = class;

  tProcEvent=function(rIm : rImg; typeEvent : TrEvType; flDest: boolean):Boolean of object;
//  tProcEvent=procedure(rIm : rImg; typeEvent : TrEvType; flDest: boolean) of object;
  tGoActions=procedure(rActions : TrActs; cndSh:TShiftState) of object;
  tGoRule=procedure(rule : rMrul; msg:String) of object;
  tSetCurrAsk=procedure(ind : Integer) of object;
  tInterpreterGetValue=procedure(Sender: TObject; Identifier: String;
     var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean) of object;
  tInterpreterSetValue=procedure(Sender: TObject; Identifier: String;
     const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean) of object;

  TrPar = class(TPersistent)
  private
    Ftp : TTypePar;
    Fpar : TStringList;
  published
    property tp : TTypePar read Ftp write Ftp;
    property par : TStringList read Fpar write Fpar;
  end;

  TrSelLbl=class(TPersistent)
  private
    FHT: Boolean;
    FHTEnabled: Boolean;
    FHTFrameVisible: Boolean;
    FHTBrush: TBrush;
    FHTFrameColor: TColor;
    FFr : Boolean;
    FFrColor : TColor;
    FBrush: TBrush;
    FFnt : Boolean;
    FFntColor : TColor;
    FShColor : TColor;
//    FShPos : TShadowPosition;
    FShSize : Integer;
    FIcCrd : TrCoord;
    FIcClr1 : TColor;
    FIcClr2 : TColor;
    FIcClr3 : TColor;
    FIcPos : TIconPosition;
  public
    constructor Create();
  published
    property HT: Boolean read FHT write FHT default True;
    property HTEnabled: Boolean read FHTEnabled write FHTEnabled default True;
    property HTFrameVisible: Boolean read FHTFrameVisible write FHTFrameVisible default True;
    property HTBrush: TBrush read FHTBrush write FHTBrush;
    property HTFrameColor: TColor read FHTFrameColor write FHTFrameColor default 0;
    property Fr: Boolean read FFr write FFr default True;
    property FrColor: TColor read FFrColor write FFrColor default 0;
    property Brush: TBrush read FBrush write FBrush;
    property Fnt: Boolean read FFnt write FFnt default False;
    property FntColor: TColor read FFntColor write FFntColor default 0;
    property ShColor: TColor read FShColor write FShColor default 0;
//    property ShPos: TShadowPosition read FShPos write FShPos default spLeftTop;
    property ShSize: Integer read FShSize write FShSize default 0;

    property IcCrd: TrCoord read FIcCrd write FIcCrd;
    property IcClr1: TColor read FIcClr1 write FIcClr1 default clGray;
    property IcClr2: TColor read FIcClr2 write FIcClr2 default clBlue;
    property IcClr3: TColor read FIcClr3 write FIcClr3 default clRed;
    property IcPos: TIconPosition read FIcPos write FIcPos default RtBt;
  end;

  tProcSetMem=procedure(rMem : TrMemo) of object;
  TrBevel = class(TPersistent)
  private
   FBvlO,FBvlI :TPanelBevel;
   FBvlOw,FBvlIw,FBorder : Integer;
  public
    constructor Create();
  published
    property BvlO : TPanelBevel read FBvlO write FBvlO;
    property BvlI : TPanelBevel read FBvlI write FBvlI;
    property BvlOw : Integer read FBvlOw write FBvlOw default 1;
    property BvlIw : Integer read FBvlIw write FBvlIw default 1;
    property Border : Integer read FBorder write FBorder default 0;
  end;

  TrMemo = class(TPersistent)
  private
   FLines : TStringList;
   FFont : TFont;
   FColor1 : TColor;
   FColor2 : TColor;
   FAlignment : TAlignment;
   FVAlignment : TVerticalAlignment;
   FCrd : TrCoord;
   FVis : Boolean;
   FfHtm : Boolean;
   FProcSetMem : tProcSetMem;
   FBvl : TrBevel;
   FDisWrap : Boolean;
  public
    constructor Create();
    destructor Destroy; override;
    procedure SetLines(Value : TStringList);
    procedure SetFont(Value :TFont);
    procedure SetColor1(Value :TColor);
    procedure SetColor2(Value :TColor);
    procedure SetAlignment(Value :TAlignment);
    procedure SetVAlignment(Value :TVerticalAlignment);
    procedure ProcSetMem(rMem : TrMemo);
  published
    property Lines : TStringList read FLines write SetLines;
    property Font : TFont read FFont write SetFont;
    property Alignment : TAlignment read FAlignment write SetAlignment;
    property VAlignment : TVerticalAlignment read FVAlignment write SetVAlignment;
    property Color1 : TColor read FColor1 write SetColor1;
    property Color2 : TColor read FColor2 write SetColor2;
    property Crd : TrCoord read FCrd write FCrd;
    property Vis: Boolean read FVis write FVis default true;
    property fHtm: Boolean read FfHtm write FfHtm default False;
    property DisWrap: Boolean read FDisWrap write FDisWrap default False;
    property OnProcSetMem : tProcSetMem read FProcSetMem write FProcSetMem;
    property Bvl : TrBevel read FBvl write FBvl;
  end;

  TrCoord = class(TPersistent)
  private
    Fx,Fy,Fw,Fh:integer;
    obj : TObject;
  public
    constructor Create();
    procedure SetX(value : Integer);
    procedure SetY(value : Integer);
    procedure SetCrd();
  published
    property x: integer read Fx write SetX default 0;
    property y: integer read Fy write SetY default 0;
    property w: integer read Fw write Fw default 0;
    property h: integer read Fh write Fh default 0;
  end;
//++++++++++++++++++++++++
  TrPropPar = class(TPersistent)
  private
    Fcrd :TrCoord;
    FfntSz,FtblW,FtblC1,FtblC2,FtblC3,FtblR:integer;
    fprc : Boolean;
  public
    constructor Create();
    destructor Destroy; override;
  published
    property fntSz: integer read FfntSz write FfntSz default 0;
    property tblW: integer read FtblW write FtblW default 0;
    property tblC1: integer read FtblC1 write FtblC1 default 0;
    property tblC2: integer read FtblC2 write FtblC2 default 0;
    property tblC3: integer read FtblC3 write FtblC3 default 0;
    property tblR: integer read FtblR write FtblR default 0;
    property prc: Boolean read fprc write fprc default False;
    property crd: TrCoord read Fcrd write Fcrd;
  end;

//====================================================
  TShema = class(TPersistent)
  private
    arrFlt : array of Integer;
    cntFlt : Integer;
    FTypeSub : TrTypeSub;
    FName : string;
    FAcnt : integer; //кол-во объектов
    FTcnt : integer; //кол-во таймеров
    FRcnt : integer;
    FVcnt : integer;
    FMcnt : integer;
    Fpic : integer;
    FpicP : string;
    FPicCenter,FPicProportional,FPicStretch : Boolean;
    FPcnt : Integer; //кол-во страниц
    FCoord : TrCoord;
    FdefPrPar : TrPropPar;
    FColor : TColor;
    FShowHintObj : Boolean;
    FShButVv : Boolean;
    FShButHlp : Boolean;
    FShButJrnl : Boolean;
    FSelLbl : TrSelLbl;
    FParent: TWinControl;
    FSerializer : TshXMLSerializer;
    FImage: TImage;
    FPathPic : string;
    FOwnHlp : Boolean;
    FHlp : string;
    FPopMnIm : TPopupMenu;
    FPopMnLb : TPopupMenu;
    FClickImg : TNotifyEvent;
    FClickLbl : TNotifyEvent;
    FDblClickLbl : TNotifyEvent;
    FDblClick : TNotifyEvent;
    FOnTimer : TNotifyEvent;
    FMouseDown : TMouseEvent;
    FMouseUp : TMouseEvent;
    FMouseMove : TMouseMoveEvent;
    FMode : TrShemModeType;
    FModeShow : Boolean;
    FModeView : Integer;   //0-obj   ;1-sh
    FNumbFault : Integer;
    FBallM : Extended;
    FBallP : Extended;
    FBall : Extended;
    FBallObj : Boolean;
    FUseIdAsk,FUseIcMyAnsv : Boolean;
    FUnUsePicDB : Boolean;
    FCurrImg : rImg;
    FCurrAct : rAct;
    FCurrMsr : integer;
    FCurrPg : integer;
    FCurrFr : Integer;
    FCurrAsk : Integer;
    FPanAskO : TWinControl;
    FPanAskI : TWinControl;
    FPanAns : TWinControl;
    FPanRem : TWinControl;
    FPanRemI : TWinControl;
    FPanRemBack : TWinControl;
    FPanAskA : TWinControl;
    fProcEvent : tProcEvent;
    FGoActions : tGoActions;
    FGoRule : tGoRule;
    FSetCurrAsk : tSetCurrAsk;
    FXMLDoc : TXMLDocument;
    FlDeser : boolean;
    FIntrGetValue : tInterpreterGetValue;
    FIntrSetValue : tInterpreterSetValue;
    FOnSetMeass : TNotifyEvent;
    FAsks : TrAsks;
    FFragments : TrFragments;
    FrImgs: TrImgs;        //все объекты
    FrTmrs : TrTmrs;       //таймера
    FRules : TrMRuls;      //правила
    FrMeass : TrMeass;     //измерения
    FTstLstEnd : TConds;  //список для проверки при окончании
    FPages : TrPages;
    FLstsHlp : TrLstsHlp;
    FCurA : rRepAsk;
    FRepAll : TRepAll;      //отчет
    FShVls : TrShVls;
    FAnsTxt : TrAnsTxt;
    FShActsLd : TrActs;
    FShrPrs : TrShrPrs;
    FMsgs : TrMsgs;
    FArrs : TrArrays;
    FRecs : TrRecords;
    FFormMsg : TForm;
    FLstPathPic : TrLstPathPic;
    CurImgRul : Integer;
    CurSndRul : string;
    CurTpEvntS : string;
    CurTpEvnt : TrEvType;
   procedure SetPicture(const Value: TImage);
    procedure SetColor(const Value: TColor);

  public
    flDsrForRp : Boolean;
//    tblP : TDataSet;
    ImgRemBack : TImage;
    CurrObjMous : rImg;// TObject;
    MouseX,MouseY : Integer;
    hFormMain : THandle;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Free;
    procedure UpdateImg(Wpar : TWinControl;flEd:Boolean);
    procedure UpdRimg(rImgs : TrImgs);
//    procedure UpdateImg(Wpar : TWinControl;tblPic : TDataSet;flEd:bool);
//    procedure UpdImg(tblPic : TDataSet);
//    procedure UpdRimg(rImgs : TrImgs;tblPic : TDataSet);
//    function FindPicture(id : integer;tblPic  : TDataSet) : string;
//    function FindPictureP(id : integer;tblPic  : TDataSet;path : string) : string;
    function LoadStaterImg (rImgs : TrImgs;par : Integer) : rImg;
    procedure LoadStaterAsks (par : Integer);
    procedure LoadState();
    function FindrImg(id : integer) : rImg;
    function FindrMsg(id : integer) : rMsg;
    function FindAsk(id : integer) : TrAsk;
    function FindShrPr(id : integer) : rShrPr;
    function FindrImgById(id : integer;rImgs : TrImgs) : rImg;
    function FindrTmrById(id : integer) : rTmr;
    function FindrVlsById(id : integer) : rShVl;
    function FindrArrsById(id : integer) : rArr;
    function FindrRecsById(id : integer) : rRec;
    procedure SetCurrMsr(value : Integer);
    procedure SetCurrPg(value : Integer);
    procedure SetShowHintObj(value : Boolean);
    procedure UpdateRimg(rImgs : TrImgs;Wpar : TWinControl;flEd:Boolean);
//    procedure UpdateRimg(rImgs : TrImgs;Wpar : TWinControl; tblPic : TDataSet;flEd:bool);
    procedure SetRec(IndRec,col,row:Integer;val : string);
    property PathPic : string read FPathPic write FPathPic;
    property Serializer : TshXMLSerializer read FSerializer write FSerializer;
    property Parent: TWinControl read FParent write FParent;
    property Image: TImage read FImage write FImage;
    property PopMnIm : TPopupMenu read FPopMnIm write FPopMnIm;
    property PopMnLb : TPopupMenu read FPopMnLb write FPopMnLb;
    property ClickImg: TNotifyEvent read FClickImg write FClickImg;
    property ClickLbl : TNotifyEvent read FClickLbl write FClickLbl;
    property DblClickLbl : TNotifyEvent read FDblClickLbl write FDblClickLbl;
    property DblClick : TNotifyEvent read FDblClick write FDblClick;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    property MouseDown: TMouseEvent read FMouseDown write FMouseDown;
    property MouseUp: TMouseEvent read FMouseUp write FMouseUp;
    property MouseMove: TMouseMoveEvent read FMouseMove write FMouseMove;
    property Mode : TrShemModeType read FMode write FMode;
    property ModeShow: Boolean read FModeShow write FModeShow;
    property CurrImg: rImg read FCurrImg write FCurrImg;
    property CurrAct: rAct read FCurrAct write FCurrAct;
    property PanAskO : TWinControl read FPanAskO write FPanAskO;
//    property PanAsk : TWinControl read FPanAsk write FPanAsk;
    property PanAskI : TWinControl read FPanAskI write FPanAskI;
    property PanAns : TWinControl read FPanAns write FPanAns;
    property PanRem : TWinControl read FPanRem write FPanRem;
    property PanRemI : TWinControl read FPanRemI write FPanRemI;
    property PanRemBack : TWinControl read FPanRemBack write FPanRemBack;
    property PanAskA : TWinControl read FPanAskA write FPanAskA;
    property CurrMsr: integer read FCurrMsr write SetCurrMsr default 0;
    property CurrAsk : Integer  read FCurrAsk write FCurrAsk;
    property ProcEvent : tProcEvent read fProcEvent write fProcEvent;
    property GoAcnions : tGoActions read FGoActions write FGoActions;
    property GoRule : tGoRule read FGoRule write FGoRule;
    property XMLDoc : TXmlDocument read FXMLDoc write FXMLDoc;
    property CurA: rRepAsk read FCurA write FCurA;
    property CurrFr : Integer read FCurrFr write FCurrFr;
    property RepAll: TRepAll read FRepAll write FRepAll;
    property LstPathPic : TrLstPathPic read FLstPathPic write FLstPathPic;
    property FormMsg : TForm read FFormMsg write FFormMsg;
    function Ainc : integer;
    function Tinc : integer;
    function Pinc : integer;
    function Vinc : integer;
    function Minc : integer;
    procedure DeSerialize(XmlStr : string);
    procedure DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
    procedure SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
    procedure InterpreterGetValue(Sender: TObject; Identifier: String; var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure InterpreterSetValue(Sender: TObject; Identifier: String; const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    function TestLstEnd(): boolean;
    function RunInterpreter(pas : string): Variant;
    function SetCurrAsk(ind : Integer): Boolean;
    procedure SetPicP(picP : string);
    procedure SetPic(pic : integer);
    procedure SetVisibleCurrAsk(vis : Boolean);
    procedure rImg2Lst(lst : TList; rIms : TrImgs);
    function rImgs2Lst(): TList;
    function MsgBox(Caption : string;txt : string; tp,alg : Integer ): Integer;
    procedure PicRealign(par : Boolean);
    function SendMsgMainForm(Msg: Cardinal; WParam: WParam; LParam: LParam ): Boolean;
    function PostMsgMainForm(Msg: Cardinal; WParam: WParam; LParam: LParam ): Boolean;
  published
    //тип темы
    property TypeSub : TrTypeSub read FTypeSub write FTypeSub default rAskTxt;
    //имя темы
    property Name : string read FName write FName;
    //использовать картинку из PicDB (не используется)
    property UnUsePicDB : Boolean read FUnUsePicDB write FUnUsePicDB default False;
    property pic: integer read Fpic write SetPic default 0;
    property picP : string read FpicP write SetPicP;
    property PicCenter : Boolean read FPicCenter write PicRealign default False;
    property PicProportional : Boolean read FPicProportional write PicRealign default False;
    property PicStretch : Boolean read FPicStretch write PicRealign default False;
    property Acnt: integer read FAcnt write FAcnt default 0;
    property Tcnt: integer read FTcnt write FTcnt default 0;
    property Pcnt: integer read FPcnt write FPcnt default 0;
    property Vcnt: integer read FVcnt write FVcnt default 0;
    property Mcnt: integer read FMcnt write FMcnt default 0;
    property ModeView : Integer read FModeView write FModeView default 0;
    property NumbFault : Integer read FNumbFault write FNumbFault default 0;
    property BallM : Extended read FBallM write FBallM;
    property BallP : Extended read FBallP write FBallP;
    property Ball : Extended read FBall write FBall;
    property BallObj : Boolean read FBallObj write FBallObj default False;
    property UseIdAsk : Boolean read FUseIdAsk write FUseIdAsk default False;
    property UseIcMyAnsv : Boolean read FUseIcMyAnsv write FUseIcMyAnsv default False;
    property Coord: TrCoord read FCoord write FCoord;
    property defPrPar : TrPropPar read FdefPrPar write FdefPrPar;
    property Color: TColor read FColor write SetColor;
    property ShButVv: Boolean read FShButVv write FShButVv default False;
    property ShButHlp: Boolean read FShButHlp write FShButHlp default False;
    property ShButJrnl: Boolean read FShButJrnl write FShButJrnl default False;
    property OwnHlp : Boolean read FOwnHlp write FOwnHlp default False;
    property Hlp : string read FHlp write FHlp;
    property SelLbl: TrSelLbl read FSelLbl write FSelLbl;
    property ShowHintObj : Boolean  read FShowHintObj write SetShowHintObj default True;
    //ответы csv таблица (TStringList) для видеовопроса
    property AnsTxt : TrAnsTxt read FAnsTxt write FAnsTxt;
    //колекция вопросы (с ответами) угадайки
    property Asks : TrAsks read FAsks write FAsks;
    //колекция видеофрагментов
    property Fragments : TrFragments read FFragments write FFragments;
    //колекция основных объектов тренажера
    property rImgs: TrImgs read FrImgs write FrImgs;
    //колекция страниц для многостраничного задания
    property Pages : TrPages read FPages write FPages;
    //колекция таймеров
    property rTmrs: TrTmrs read FrTmrs write FrTmrs;
    //колекция измерительных приборов
    property rMeass: TrMeass read FrMeass write FrMeass;
    //колекция правил
    property Rules: TrMRuls read FRules write FRules;
    property TstLstEnd : TConds read FTstLstEnd write FTstLstEnd;
    property OnIntrGetValue : tInterpreterGetValue read FIntrGetValue write FIntrGetValue;
    property OnIntrSetValue : tInterpreterSetValue read FIntrSetValue write FIntrSetValue;
    property OnSetMeass: TNotifyEvent read FOnSetMeass write FOnSetMeass;
    //текущая страница при загрузке
    property CurrPg: integer read FCurrPg write SetCurrPg;
    //колекция переменных схемы
    property ShVls: TrShVls  read FShVls write FShVls;
    property Arrs: TrArrays read FArrs write FArrs;
    property Recs: TrRecords read FRecs write FRecs;
    property ShActsLd : TrActs read FShActsLd write FShActsLd;
    property ShrPrs : TrShrPrs read FShrPrs write FShrPrs;
    property Msgs : TrMsgs read FMsgs write FMsgs;
    property LstsHlp: TrLstsHlp read FLstsHlp write FLstsHlp;
    property OnSetCurrAsk: tSetCurrAsk read FSetCurrAsk write FSetCurrAsk;
  end;

//==================================
  rShrPr = class(TCollectionItem)
  private
    FId  : Integer;
    FName: string;
    FProc :TrPar;
  public
  published
    property Id: integer read FId write FId default 0;
    property Name: string read FName write FName;
    property Proc: TrPar read FProc write FProc;
  end;

  TrShrPrs = class(TCollection)
  private
    function GetItem(Index: Integer): rShrPr;
    procedure SetItem(Index: Integer; const Value: rShrPr);
  public
    destructor Destroy; override;
    function  Add: rShrPr;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rShrPr;
    property Items[Index: Integer]: rShrPr read GetItem  write SetItem; default;
  end;

//======================================================
  rItLstH = class(TCollectionItem)
  private
    fType : TTypeItLstH;
    fName : string;
    fpic : Integer;
    fTxt : TStringList;
  public
  published
    property TpIt : TTypeItLstH read fType write fType;
    property Name: string read fName write fName;
    property pic: Integer read fpic write fpic default 0;
    property Txt : TStringList read fTxt write fTxt;
  end;

  TrItLstH = class(TCollection)
  private
    function GetItem(Index: Integer): rItLstH;
    procedure SetItem(Index: Integer; const Value: rItLstH);
  public
    destructor Destroy; override;
    function  Add: rItLstH;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rItLstH;
    property Items[Index: Integer]: rItLstH read GetItem  write SetItem; default;
  end;
//======================================================
  rLstHlp = class(TCollectionItem)
  private
    fName : string;
    fEnb : Boolean;
    fLst : TrItLstH;
  public
  published
    property Name: string read fName write fName;
    property Enb : Boolean read fEnb write fEnb;
    property Lst : TrItLstH read fLst write fLst;
  end;

  TrLstsHlp = class(TCollection)
  private
    function GetItem(Index: Integer): rLstHlp;
    procedure SetItem(Index: Integer; const Value: rLstHlp);
  public
    destructor Destroy; override;
    function  Add: rLstHlp;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rLstHlp;
    property Items[Index: Integer]: rLstHlp read GetItem  write SetItem; default;
  end;
//============================================
  TrJournal = class(TPersistent)
  private
    FName : string;
    FJcnt : integer;
    FDiary : TrDiary;
    FSerializer : TshXMLSerializer;
    FXMLDoc : TXmlDocument;
    FShema : TShema;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property Serializer : TshXMLSerializer read FSerializer write FSerializer;
    property XMLDoc : TXmlDocument read FXMLDoc write FXMLDoc;
    property Shema : TShema read FShema write FShema;
    function Jinc : integer;
    procedure DeSerialize(XmlStr : string);
    procedure DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
    procedure SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
  published
    property Name : string read FName write FName;
    property Jcnt: integer read FJcnt write FJcnt default 0;
    property Diary: TrDiary read FDiary write FDiary;
  end;

  TrText = class(TPersistent)
  private
    FEnb : Boolean;
    FAutoSize : Boolean;
    Fx,Fy : Integer;
    FFont : TFont;
    FText : TStringList;
    FCurText : TStringList;
    FCurCap : string;
    FAngl : Integer;
    FAlg : Integer; //Alignment
    FCnt : Integer;
    FARow : Integer;
    FARowCur : Integer;
    FMyrImg : rImg;
  public
    constructor Create();
    destructor Destroy; override;
    procedure SetEnb(Value : Boolean);
    procedure SetAutoSize(Value : Boolean);
    procedure SetAngl(Value : Integer);
    procedure SetX(Value : Integer);
    procedure SetY(Value : Integer);
    procedure SetAlg(Value : Integer);
    procedure SetARow(Value : Integer);
    procedure SetARowCur(Value : Integer);
    procedure SetLabel();
    property MyrImg : rImg read FMyrImg write FMyrImg;
    property CurCap: string read FCurCap write FCurCap;
    property CurText: TStringList read FCurText write FCurText;
    property ARowCur : Integer read FARowCur write SetARowCur default 0;
  published
    property Enb : Boolean read FEnb write SetEnb default False;
    property AutoSize : Boolean read FAutoSize write SetAutoSize default False;
    property Text : TStringList read FText write FText;
    property x : Integer read Fx write SetX default 0;
    property y : Integer read Fy write SetY default 0;
    property Angl : Integer read FAngl write SetAngl default 0;
    property Alg : Integer read FAlg write SetAlg default 0;
    property Cnt : Integer read FCnt write FCnt default 0;
    property ARow : Integer read FARow write SetARow default 0;
    property Font : TFont read FFont write FFont;
  end;
//===========================================

  TAnVls = class(TPersistent)
  private
    FLtR : boolean;
    FVal:integer;
    FMin:integer;
    FMax:integer;
    FAngMin,FAngMax:integer;
  published
    property LtR: boolean read FLtR write FLtR default false;
    property Val: integer read FVal write FVal default 0;
    property Min: integer read FMin write FMin default 0;
    property Max: integer read FMax write FMax default 0;
    property AngMin: integer read FAngMin write FAngMin default 110;
    property AngMax: integer read FAngMax write FAngMax default 210;
  end;

  TAnlgPrib = class(TPersistent)
  private
    FActive : Boolean;
    FAnVls : TAnVls;
    Fx,Fy,Fw,Fh:integer;
    Flx,Fly,Fln : integer;
    FArrW : Integer;
    FArrClr : TColor;
    FArrTp : Integer;
  published
    property Active: Boolean read FActive write FActive default false;
    property AnVls: TAnVls read FAnVls write FAnVls;
    property x: integer read Fx write Fx default 0;
    property y: integer read Fy write Fy default 0;
    property w: integer read Fw write Fw default 0;
    property h: integer read Fh write Fh default 0;
    property lx: integer read Flx write Flx default 0;
    property ly: integer read Fly write Fly default 0;
    property ln: integer read Fln write Fln default 0;
    property ArrW: integer read FArrW write FArrW default 2;
    property ArrTp: integer read FArrTp write FArrTp default 0;
    property ArrClr: TColor read FArrClr write FArrClr default 0;
  end;
//====================================
  TrLbl = class(TLabel) //TJvHTLabel)//
  private
    FMyrImg : rImg;
//    Fmove:bool;
    Fxold,Fyold:integer;
    FlMvIc,FlSaveRem : Boolean;
    FMyAns : string;
  protected
//    procedure SetEnabled(Value: Boolean); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
//    procedure MouseEnter(Control: TControl); override;
//    procedure MouseLeave(Control: TControl); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DblClick; override;
    procedure Paint; override;
    function MoveIco(X, Y: Integer): Boolean;
  public
   property MyAns : string read FMyAns write FMyAns;
   property xold : integer read Fxold write Fxold;
   property yold : integer read Fyold write Fyold;
   property FlMyAnsv : Boolean read FlSaveRem write FlSaveRem;
   procedure Assign(Source: TPersistent); override;
   property MyrImg : rImg read FMyrImg write FMyrImg;
  end;
//====================================
//TrMsrImg = class(TJvImage)
  TrMsrImg = class(TImage)
  private
    Fid : integer;
    FMyrMsr : rMsr;
//    Fxold,Fyold:integer;
//    Fmove:bool;
  protected
    procedure Click; override;
  public
    property id : integer read Fid write Fid default 0;
    property MyrMsr : rMsr read FMyrMsr write FMyrMsr;
  end;
//======================================================
  TrPg  = class(TCollectionItem)
  private
    fName : string;
    FpId : Integer;
    fCoord : TrCoord;
    Fpic : integer;
    FPathPic : string;
    FParent: TWinControl;
//    FImage: TImage;
    FPgVis : Boolean;
    FAsks : TrAsks;
    frImgs : TrImgs;
    fRcts : TrRcts;
    FShema : TShema;     //сцылка на родителя
    procedure SetPgVis(value : Boolean);
    procedure SetPic(pc_ : integer);
  public
    property Parent: TWinControl read FParent write FParent;
//    property Image: TImage read FImage write FImage;
    property PgVis : Boolean read FPgVis write SetPgVis;
    property Shema: TShema read FShema write FShema;
  published
    property Name : string read fName write fName;
    property pId: Integer read FpId write FpId default 0;
    property pic : integer read Fpic write SetPic default 0;
    property PathPic : string read FPathPic write FPathPic;
    property Coord : TrCoord read fCoord write fCoord;
    property Asks : TrAsks read FAsks write FAsks;
    property rImgs : TrImgs read frImgs write frImgs;
    property Rcts : TrRcts read fRcts write fRcts;
  end;

  TrPages =  class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TrPg;
    procedure SetItem(Index: Integer; const Value: TrPg);
  public
    destructor Destroy; override;
    function  Add: TrPg;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrPg;
    property Items[Index: Integer]: TrPg read GetItem  write SetItem; default;
  end;
//======================================================
  TrAsk  = class(TCollectionItem)
  private
    fId :  Integer;
    fName : string;
    fAsk : TrMemo;
    fAnsver : TrMemo;
    fRem : TrMemo;
    FRnd : Boolean;
    fNright : Integer;
    FBall : Extended;
//    FMltSel : Boolean;
    FDsJr : boolean;
    FTpSh : Integer;  //тип показа ответов
    FRt : TStringList;  //правильные
    FRemPnlSh : Boolean;  //показывать панель комента(закрыть ответы)
    FRemImg : string;  //подложка коментария
    FRemColor : TColor; //цвет подложки комента
    FRICenter,FRIProportional,FRIStretch : Boolean;
    FItmH : Integer;
  public
    ChAns : TStringList;  //помеченные
    procedure RIRealign();
    procedure SetRemPnlSh(par : Boolean);
    procedure SetRICenter(par : Boolean);
    procedure SetRIProportional(par : Boolean);
    procedure SetRIStretch(par : Boolean);
    procedure SetRemBackPic(picP : string);
    procedure SetItmH(par : Integer);
  published
    property Id : Integer read fId write fId default 0;
    property Name: string read fName write fName;
    property Ask : TrMemo read fAsk write fAsk;
    property Ansver : TrMemo read fAnsver write fAnsver;
    property Ball : Extended read FBall write FBall;
    property Nrt : Integer read fNright write fNright default 1;
    property Rem : TrMemo read fRem write fRem;
    property Rnd: Boolean read FRnd write FRnd default true;
    property DsJr: boolean read FDsJr write FDsJr default False;
//    property MltSel : Boolean read FMltSel write FMltSel default true;
    property TpSh : Integer read FTpSh write FTpSh default 0;
    property ItmH : Integer read FItmH write SetItmH default 0;
    property Rt : TStringList read FRt write FRt;
    property RemPnlSh : Boolean read FRemPnlSh write SetRemPnlSh default False;
    property RemImg: string read FRemImg write SetRemBackPic;
    property RICenter : Boolean read FRICenter write SetRICenter default False;
    property RIProportional : Boolean read FRIProportional write SetRIProportional default False;
    property RIStretch : Boolean read FRIStretch write SetRIStretch default False;
    property RemColor: TColor read FRemColor write FRemColor;
  end;

  TrAsks =  class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TrAsk;
    procedure SetItem(Index: Integer; const Value: TrAsk);
  public
    destructor Destroy; override;
    function  Add: TrAsk;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAsk;
    property Items[Index: Integer]: TrAsk read GetItem  write SetItem; default;
  end;
//======================================================
  rMsg  = class(TCollectionItem)
  private
    FmId : Integer;
    FName : string;
    FTxt : string;
    FTp :  Integer;
    FAlg : Integer; //<ALIGN [CENTER, LEFT, Right]>
  public
  published
    property mId: Integer read FmId write FmId default 0;
    property Name: string read fName write fName;
    property Txt : string read FTxt write FTxt;
    property Tp: Integer read FTp write FTp default 0;
    property Alg: Integer read FAlg write FAlg default 0;
  end;

  TrMsgs =  class(TOwnedCollection)
  private
    function GetItem(Index: Integer): rMsg;
    procedure SetItem(Index: Integer; const Value: rMsg);
  public
    destructor Destroy; override;
    function  Add: rMsg;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rMsg;
    property Items[Index: Integer]: rMsg read GetItem  write SetItem; default;
  end;
//======================================================
  TrGrRect  = class(TCollectionItem)
  private
    fseq : Integer;
    fName : string;
    fRem : string;
    fVRects : TrVRects;
    fAnsRects : TrAnsRects;
  public
  published
//    property Id : Integer read fId write fId;
    property seq : Integer read fseq write fseq;
    property Name : string read fName write fName;
    property Rem : string read fRem write fRem;
    property VRects : TrVRects read fVRects write fVRects;
    property AnsRects : TrAnsRects read fAnsRects write fAnsRects;
  end;

  TrGrRects =  class(TCollection)
  private
    function GetItem(Index: Integer): TrGrRect;
    procedure SetItem(Index: Integer; const Value: TrGrRect);
  public
    destructor Destroy; override;
    function  Add: TrGrRect;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrGrRect;
    property Items[Index: Integer]: TrGrRect read GetItem  write SetItem; default;
  end;

//======================================================
  TrVRect  = class(TCollectionItem)
  private
    fseq : Integer;
    fflTm : Boolean;
    fflCrd : Boolean;
    fTmB : Integer;
    fTmE : Integer;
    fTmBc : Integer;
    fTmEc : Integer;
    fCoord : TrCoord;
  public
  published
    property seq : Integer read fseq write fseq;
    property flTm : Boolean read fflTm write fflTm;
    property flCrd : Boolean read fflCrd write fflCrd;
    property TmB : Integer read fTmB write fTmB;
    property TmE : Integer read fTmE write fTmE;
    property TmBc : Integer read fTmBc write fTmBc;
    property TmEc : Integer read fTmEc write fTmEc;
    property Coord : TrCoord read fCoord write fCoord;
  end;

  TrVRects =  class(TCollection)
  private
    function GetItem(Index: Integer): TrVRect;
    procedure SetItem(Index: Integer; const Value: TrVRect);
  public
    destructor Destroy; override;
    function  Add: TrVRect;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrVRect;
    property Items[Index: Integer]: TrVRect read GetItem  write SetItem; default;
  end;

//======================================================
  TrAnsRect  = class(TCollectionItem)
  private
    fRght : Boolean;
    fBall : single;
    fIdAns : Integer;
  public
  published
    property Rght : Boolean read fRght write fRght;
    property Ball : single read fBall write fBall;
    property IdAns : Integer read fIdAns write fIdAns;
  end;

  TrAnsRects =  class(TCollection)
  private
    function GetItem(Index: Integer): TrAnsRect;
    procedure SetItem(Index: Integer; const Value: TrAnsRect);
  public
    destructor Destroy; override;
    function  Add: TrAnsRect;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAnsRect;
    property Items[Index: Integer]: TrAnsRect read GetItem  write SetItem; default;
  end;

//======================================================
//  TrAnsTxt  = class(TCollectionItem)
  TrAnsTxt  = class(TPersistent)
  private
    fAns : TStringList;//string;
  public
  published
    property Ans : TStringList read fAns write fAns;
  end;

//======================================================
  TrFragment  = class(TCollectionItem)
  private
    fseq : Integer;
    fName : string;
    fFiles : string;
    fTimeF : Integer;
    fTimeB : Integer;
    fTimeE : Integer;
    fRem : string;
    fGrRects : TrGrRects;
  public
  published
    property seq : Integer read fseq write fseq;
    property Name: string read fName write fName;
    property Files: string read fFiles write fFiles;
    property TimeF : Integer read fTimeF write fTimeF;
    property TimeB : Integer read fTimeB write fTimeB;
    property TimeE : Integer read fTimeE write fTimeE;
    property Rem : string read fRem write fRem;
    property GrRects : TrGrRects read fGrRects write fGrRects;
  end;

  TrFragments =  class(TCollection)
  private
    function GetItem(Index: Integer): TrFragment;
    procedure SetItem(Index: Integer; const Value: TrFragment);
  public
    destructor Destroy; override;
    function  Add: TrFragment;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrFragment;
    property Items[Index: Integer]: TrFragment read GetItem  write SetItem; default;
  end;

//============================================
  rCndMsr = class(TCollectionItem)
  private
    FName: string;
    FTp : TrCndType;
    FNxt : TrCndsType;
    FidO : integer;
//    Fpar : TStringList;
    Fpar1 : TrPar;
    FrpVal: string;
    FrindPV : integer;
  published
    property idO: integer read FidO write FidO default 0;
    property Name: string read FName write FName;
    property Nxt: TrCndsType read FNxt write FNxt default rOr;
    property Tp: TrCndType read FTp write FTp default rEq;
    property rpVal : string read FrpVal write FrpVal;
    property rindPV : integer read FrindPV write FrindPV default 0;
//    property par : TStringList read Fpar write Fpar;
    property par1 : TrPar read Fpar1 write Fpar1;
  end;

  TrCndMsrs = class(TCollection)
  private
    function GetItem(Index: Integer): rCndMsr;
    procedure SetItem(Index: Integer; const Value: rCndMsr);
  public
    destructor Destroy; override;
    function  Add: rCndMsr;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rCndMsr;
    property Items[Index: Integer]: rCndMsr read GetItem  write SetItem; default;
  end;

//====================================
  rMsr = class(TCollectionItem)
  private
    Fid : integer;
    FName: string;
    FidO,FidO1,FidO2 : integer;
    FVal : Double;
    Fpic1 : integer;
    Fpic2 : integer;
    FpicP1 : string;
    FpicP2 : string;
    FImage1 : TrMsrImg;
    FImage2 : TrMsrImg;
    FCndMsrs :TrCndMsrs;
    FShema: TShema;
    FNcont : Integer;
    FUsVal : Boolean;
  public
    property Image1: TrMsrImg read FImage1 write FImage1;
    property Image2: TrMsrImg read FImage2 write FImage2;
    property Shema: TShema read FShema write FShema;
    property idO1: integer read FidO1 write FidO1 default 0;
    property idO2: integer read FidO2 write FidO2 default 0;
  published
    property id: integer read Fid write Fid default 0;
    property Name: string read FName write FName;
    property Ncont : Integer read FNcont write FNcont default 0;
    property pic1: integer read Fpic1 write Fpic1 default 0;
    property pic2: integer read Fpic2 write Fpic2 default 0;
    property picP1: string read FpicP1 write FpicP1;
    property picP2: string read FpicP2 write FpicP2;
    property idO: integer read FidO write FidO default 0;
    property Val: Double read FVal write FVal;
    property UsVal : Boolean  read FUsVal write FUsVal default True;
    property CndMsrs: TrCndMsrs read FCndMsrs write FCndMsrs;
  end;

  TrMeass = class(TOwnedCollection)
  private
    FShema: TShema;
    function GetItem(Index: Integer): rMsr;
    procedure SetItem(Index: Integer; const Value: rMsr);
  public
    destructor Destroy; override;
    function  Add: rMsr;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rMsr;
    property Items[Index: Integer]: rMsr read GetItem  write SetItem; default;
    property Shema: TShema read FShema write FShema;
  end;
//============================================
  Cnd = class(TCollectionItem)
  private
    FName: string;
    FTp : TrCndType;
    FNxt : TrCndsType;
    FidO : integer;
//    Fpar : TStringList;
    Fpar1 : TrPar;
    FrActs : TrActs;
    FrCndOf : TrCndOf;
    FrpVal: string;
    FrindPV : integer;
  published
    property idO: integer read FidO write FidO default 0;
    property Name: string read FName write FName;
    property Nxt: TrCndsType read FNxt write FNxt default rOr;
    property Tp: TrCndType read FTp write FTp default rEq;
    property rCndOf : TrCndOf read FrCndOf write FrCndOf default cSt;
    property rpVal : string read FrpVal write FrpVal;
    property rindPV : integer read FrindPV write FrindPV default 0;
//    property par : TStringList read Fpar write Fpar;
    property par1 : TrPar read Fpar1 write Fpar1;
    property rActs: TrActs read FrActs write FrActs;
  end;

  TConds = class(TCollection)
  private
    function GetItem(Index: Integer): Cnd;
    procedure SetItem(Index: Integer; const Value: Cnd);
  public
    destructor Destroy; override;
    function  Add: Cnd;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): Cnd;
    property Items[Index: Integer]: Cnd read GetItem  write SetItem; default;
  end;
//==================================
  rMrul = class(TCollectionItem)
  private
    FrId : integer;
    FName: string;
    FMsg : TStringList;
    FMark : Double;
    FTpRul : TTypeRule;
    FrActs : TrActs;
    FConds : TConds;
    FShema: TShema;
    Fbfr  : Boolean;
    FGoRule : tGoRule;         //
  public
    property Shema: TShema read FShema write FShema;
    procedure GoRule(rule : rMrul; msg:String);
  published
    property rId : integer read FrId write FrId default 0;
    property TpRul : TTypeRule read FTpRul write FTpRul;
    property bfr : Boolean read Fbfr write Fbfr default False;
    property Name: string read FName write FName;
    property Msg: TStringList read FMsg write FMsg;
    property Mark: Double read FMark write FMark;
    property rActs: TrActs read FrActs write FrActs;
    property Conds: TConds read FConds write FConds;
    property OnGoRule : tGoRule read FGoRule write FGoRule;
  end;

  TrMRuls = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): rMrul;
    procedure SetItem(Index: Integer; const Value: rMrul);
  public
    destructor Destroy; override;
    function  Add: rMrul;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rMrul;
    property Items[Index: Integer]: rMrul read GetItem  write SetItem; default;
  end;
//==================================
  rTmr = class(TCollectionItem)
  private
    FtId : integer;
    FoId : integer;
    FpImg : rImg;
    FName: string;
    FEnab : boolean;
    FIntr: Cardinal;
    FTmr : TTimer;
    FCount : integer;
    FSrImg : rImg;
    FParent: TWinControl;   //родители
    FShema: TShema;         //
    FrActs : TrActs;
    Fcurcnt : integer;
  public
    property pImg : rImg read FpImg write FpImg;
    property SrImg: rImg read FSrImg write FSrImg;
    property Parent: TWinControl read FParent write FParent;
    property curcnt : integer read Fcurcnt write Fcurcnt;
    property Shema: TShema read FShema write FShema;
    procedure SetIntr(value : Cardinal);
    procedure SetEnab(value : boolean);
    procedure GoTimer(AOwner: TObject);
  published
    property tId : integer read FtId write FtId default 0;
    property oId : integer read FoId write FoId default 0;
    property Name: string read FName write FName;
    property Enab: boolean read FEnab write SetEnab default false;
    property Intr: Cardinal read FIntr write SetIntr;
    property Count: integer read FCount write FCount default 0;
    property Tmr: TTimer read FTmr write FTmr;
    property rActs: TrActs read FrActs write FrActs;
  end;

  TrTmrs = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): rTmr;
    procedure SetItem(Index: Integer; const Value: rTmr);
  public
    destructor Destroy; override;
    function  Add: rTmr;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rTmr;
    property Items[Index: Integer]: rTmr read GetItem  write SetItem; default;
  end;
//============================
  rAct = class(TCollectionItem)
  private
    FName: string;
    FType : TrActType;
    FidO : integer;
    FstO : integer;
    Fidv : integer;
    FidR : integer;
    FvO : Double;
//    Fpar : TStringList;
    Fpar1 :TrPar;
    FCndAct : TShiftState;
    FfAsk : boolean;
    FVis : boolean;
    FConds : TConds;
    FDsJr : boolean;
    
  published
    property Name: string read FName write FName;
    property TpA: TrActType read FType write FType default rAcSt;
    property idO: integer read FidO write FidO default 0;
    property stO: integer read FstO write FstO default 0;
    property idv: integer read Fidv write Fidv default 0;
    property idR: integer read FidR write FidR default 0;
    property vO: Double read FvO write FvO;
    property fAsk: boolean read FfAsk write FfAsk default False;
    property Vis: boolean read FVis write FVis default False;
    property DsJr: boolean read FDsJr write FDsJr default False;
//    property par : TStringList read Fpar write Fpar;
    property par1 : TrPar read Fpar1 write Fpar1;
    property CndAct: TShiftState read FCndAct write FCndAct default [ssLeft];
    property Conds: TConds read FConds write FConds;
  end;

  TrActs = class(TCollection)
  private
    function GetItem(Index: Integer): rAct;
    procedure SetItem(Index: Integer; const Value: rAct);
  public
    destructor Destroy; override;
    function  Add: rAct;
    function Insert(Index: Integer): rAct;
    procedure Delete(Index: Integer);
    property Items[Index: Integer]: rAct read GetItem  write SetItem; default;
  end;
//==================================
  rVal = class(TCollectionItem)
  private
    FName: string;
    FIdv : integer;
    FvO : Double;
    FOldvO : Double;
    Funt : string;
    FConds : TConds;
    FMyrImg : rImg;
  public
    property MyrImg : rImg read FMyrImg write FMyrImg;
    property OldvO: Double read FOldvO write FOldvO;
    procedure SetVal(Val : Double);
  published
    property IdV: integer read FIdv write FIdv default 0;
    property Name: string read FName write FName;
    property vO: Double read FvO write SetVal;
    property unt: string read Funt write Funt;
    property Conds: TConds read FConds write FConds;
  end;

  TrVals = class(TCollection)
  private
    FMyrImg : rImg;
    function GetItem(Index: Integer): rVal;
    procedure SetItem(Index: Integer; const Value: rVal);
  public
    destructor Destroy; override;
    property MyrImg : rImg read FMyrImg write FMyrImg;
    function  Add: rVal;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rVal;
    property Items[Index: Integer]: rVal read GetItem  write SetItem; default;
  end;
//==================================
  rShVl = class(TCollectionItem)
  private
    FIdv  : Integer;
    FName: string;
    FvO : Double;
    FOldvO : Double;
  public
    property OldvO: Double read FOldvO write FOldvO;
  published
    property Idv: integer read FIdv write FIdv default 0;
    property Name: string read FName write FName;
    property vO: Double read FvO write FvO;
  end;

  TrShVls = class(TCollection)
  private
    FShema : TShema;
    function GetItem(Index: Integer): rShVl;
    procedure SetItem(Index: Integer; const Value: rShVl);
  public
    property TShema: TShema read FShema write FShema;
    destructor Destroy; override;
    function  Add: rShVl;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rShVl;
    property Items[Index: Integer]: rShVl read GetItem  write SetItem; default;
  end;
//==================================
  rRct = class(TCollectionItem)
  private
    FName: string;
    FCoord : TrCoord;
    FrEvs : TrEvs;
    Fpar1 : TrPar;
    FrActs : TrActs;
    FMyrImg : rImg;
  public
    property MyrImg : rImg read FMyrImg write FMyrImg;
  published
    property Name: string read FName write FName;
    property Coord: TrCoord read FCoord write FCoord;
    property par1: TrPar read Fpar1 write Fpar1;
    property rEvs: TrEvs read FrEvs write FrEvs;
//    property rActs: TrActs read FrActs write FrActs;
  end;

  TrRcts = class(TCollection)
  private
    FMyrImg : rImg;
    function GetItem(Index: Integer): rRct;
    procedure SetItem(Index: Integer; const Value: rRct);
  public
    destructor Destroy; override;
    property MyrImg : rImg read FMyrImg write FMyrImg;
    function  Add: rRct;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rRct;
    property Items[Index: Integer]: rRct read GetItem  write SetItem; default;
  end;
//==================================
  rMn = class(TCollectionItem)
  private
    FName: string;
    FrActs : TrActs;
  published
    property Name: string read FName write FName;
    property rActs: TrActs read FrActs write FrActs;
  end;

  TrMns = class(TCollection)
  private
    function GetItem(Index: Integer): rMn;
    procedure SetItem(Index: Integer; const Value: rMn);
  public
    destructor Destroy; override;
    function  Add: rMn;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rMn;
    property Items[Index: Integer]: rMn read GetItem  write SetItem; default;
  end;
//==================================
  rEv = class(TCollectionItem)
  private
    FName: string;
    FType : TrEvType;
    FrActs : TrActs;
  published
    property Name: string read FName write FName;
    property TpE: TrEvType read FType write FType default rEMsUp;
    property rActs: TrActs read FrActs write FrActs;
  end;

  TrEvs = class(TCollection)
  private
    function GetItem(Index: Integer): rEv;
    procedure SetItem(Index: Integer; const Value: rEv);
  public
    destructor Destroy; override;
    function  Add: rEv;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rEv;
    property Items[Index: Integer]: rEv read GetItem  write SetItem; default;
  end;
//---------
  rStat = class(TCollectionItem)
  private
    FName: string;
    Fst : integer;
    Fpic : integer;
    FpicD : integer;
    FpicE : integer;
    FConds : TConds;
    FPathPic : string;
    FPathPicD : string;
    FPathPicE : string;
    FrActs : TrActs;
  public
    procedure Setpic(pc : Integer);
    procedure SetpicD(pc : Integer);
    procedure SetpicE(pc : Integer);
    procedure SetPathPic(PathPc : string);
    procedure SetPathPicD(PathPc : string);
    procedure SetPathPicE(PathPc : string);
  published
    property Name: string read FName write FName;
    property st: integer read Fst write Fst default 0;
    property pic: integer read Fpic write Setpic default 0;
    property picD: integer read FpicD write SetpicD default 0;
    property picE: integer read FpicE write SetpicE default 0;
    property PathPic: string read FPathPic write SetPathPic;
    property PathPicD: string read FPathPicD write SetPathPicD;
    property PathPicE: string read FPathPicE write SetPathPicE;
    property Conds: TConds read FConds write FConds;
    property rActs: TrActs read FrActs write FrActs;
  end;

  TrStats = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): rStat;
    procedure SetItem(Index: Integer; const Value: rStat);
  public
    destructor Destroy; override;
    function  Add: rStat;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rStat;
    property Items[Index: Integer]: rStat read GetItem  write SetItem; default;
  end;

//  TrImage = class(TJvImage)
  TrImage = class(TImage)
  private
    Fido : integer;
    FMyrImg : rImg;
    Fxold,Fyold:integer;
    Fmove,Fdblc:Boolean;
    FImgAn:TImage;
  protected
    procedure Click; override;
//    procedure SetEnabled(Value: Boolean); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
//    procedure MouseEnter(Control: TControl); override;
//    procedure MouseLeave(Control: TControl); override;
//    function HitTest(Control: TControl;X, Y: Integer): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DblClick; override;
    property OnMouseEnter;
    property OnMouseLeave;
  public
    property ido : integer read Fido write Fido;
    property xold : integer read Fxold write Fxold;
    property yold : integer read Fyold write Fyold;
    property MyrImg : rImg read FMyrImg write FMyrImg;
    property ImgAn : TImage read FImgAn write FImgAn;
    property flmove: Boolean read Fmove write Fmove;
  end;

  rImg = class(TCollectionItem)
  private
    FName: string;
    FTypeObj : TrImgType;
    FaId : integer;
    FSt : integer;
    FOldSt : integer;
    FrVals : TrVals;
    FCoord : TrCoord;
    FAnPrib : TAnlgPrib;
    FAnVal : Double;
    FOldCoord : TrCoord;
    FrStats : TrStats;
    FrMns : TrMns;
    FrEvs : TrEvs;
    FrRcts : TrRcts;
    FrImgs: TrImgs;
    FParent: TWinControl;   //родители
    FShema: TShema;         //
    FImage: TrImage;
    FLabel: TrLbl;
    FLblClk : Boolean;
    FLck : Boolean;
    FVis : Boolean;
    FVisChd : Boolean;
    FVisChdTmp : Boolean;
    FShwHnt : Boolean;
    FModeEdit : Boolean;
    FnotMsr : Boolean;
    fProcEvent : tProcEvent;
    fGoAcnions :tGoActions;
    FMoveChd : boolean;
    FFault : boolean;
    FMn0 : Boolean;
    Ftxt : TrText;
    FVx,x0 : Integer;
    FVxMax,FVxMin : Integer;
    FVxK : Double;
    FidVx : Integer;
    FrctOld : rRct;
    FTpMv : TrMoveType;
    procedure SetName(Val : string);
    procedure SetSt (const Value : integer);
    procedure SetVx (const Value : integer);
    procedure SetVis (const Value : Boolean);
    procedure SetVisChd (const Value : Boolean);
    procedure SetFault (const Value : Boolean);
    procedure SetShwHnt(value : Boolean);
    procedure SetTypeObj(value : TrImgType);
  public
    destructor Destroy; override;
    property ModeEdit: Boolean read FModeEdit write FModeEdit default false;
    property Parent: TWinControl read FParent write FParent;
    property Shema: TShema read FShema write FShema;
    property Image: TrImage read FImage write FImage;
    property Lbl: TrLbl read FLabel write FLabel;
    property OldSt: integer read FOldSt write FOldSt;
    procedure SetAnVal(Val : Double);
    property OldCoord: TrCoord read FOldCoord write FOldCoord;
    function ProcEvent(rIm : rImg; typeEvent : TrEvType; flDest: boolean): Boolean;
    function ProcEventB(rIm : rImg; typeEvent : TrEvType; flDest: boolean): Boolean;
    procedure CopyImg(rIm : rImg);
    function ConditionEntry(conds : TConds) : boolean;
    function CheckRules(Sender:TObject) : Boolean;
    function CheckRulesB(Sender:TObject) : Boolean;
    function GoActions(rActions : TrActs; cndSh:TShiftState) : boolean;
    function GoMouseEv(typeEvent : TrEvType; X,Y : integer; cndSh:TShiftState) : boolean;
    function GoMeasure(X,Y : integer) : boolean;
    procedure MoveChld(x,y : integer);
    procedure SetCoord(crd : TrCoord);
    procedure SetCrdCh(x,y : integer);
    procedure Update();
//    procedure SetZOrderPosition(Position: Integer);
  published
    property Name: string read FName write SetName;
    property TypeObj: TrImgType read FTypeObj write SetTypeObj default rIm;
    property aId: integer read FaId write FaId default 0;
    property St: integer read FSt write SetSt default 0;
    property ShwHnt : Boolean read FShwHnt write SetShwHnt default True;
    property Fault : Boolean read FFault write SetFault default False;
    property notMsr : Boolean read FnotMsr write FnotMsr default False;
    property Mn0 : Boolean read FMn0 write FMn0 default False;
    property Lck: Boolean read FLck write FLck default True;
    property LblClk: Boolean read FLblClk write FLblClk default False;
    property TpMv : TrMoveType read FTpMv write FTpMv default rAll;
    property Vx: Integer read FVx write SetVx default 0;
    property idVx : Integer read FidVx write FidVx default 0;
    property VxMax : Integer read FVxMax write FVxMax default 0;
    property VxMin : Integer read FVxMin write FVxMin default 0;
    property VxK : Double read FVxK write FVxK;
    property VisChd: Boolean read FVisChd write SetVisChd default true;
    property Vis: Boolean read FVis write SetVis default true;
    property Coord: TrCoord read FCoord write SetCoord;
    property AnVal: Double read FAnVal write SetAnVal;
    property AnPrib: TAnlgPrib read FAnPrib write FAnPrib;
    property txt : TrText read Ftxt write Ftxt;
    property rStats: TrStats read FrStats write FrStats;
    property rVals: TrVals read FrVals write FrVals;
    property rMns: TrMns read FrMns write FrMns;
    property rEvs: TrEvs read FrEvs write FrEvs;
    property rRcts: TrRcts read FrRcts write FrRcts;
    property rImgs: TrImgs read FrImgs write FrImgs;
    property OnProcEvent : tProcEvent read fProcEvent write fProcEvent;
    property OnGoAcnions : tGoActions read fGoAcnions write fGoAcnions;
  end;

  TrImgs = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): rImg;
    procedure SetItem(Index: Integer; const Value: rImg);
  public
    destructor Destroy; override;
    function  Add: rImg;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rImg;
    property Items[Index: Integer]: rImg read GetItem  write SetItem; default;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++
{  TFrmSave = class(TPersistent)
  private
    FRepPack : TRepPack;
    FSerializer : TshXMLSerializer;
    FSmplXML : TJvSimpleXml;
    FTmPack : Integer;
    FTmRun : Integer;
    FName : string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property Serializer : TshXMLSerializer read FSerializer write FSerializer;
    property SmplXML : TJvSimpleXml read FSmplXML write FSmplXML;
    procedure DeSerialize(XmlStr : string);
    procedure DeSerializeInt(AnXMLNode: TJvSimpleXmlElem; Component: TObject);
    procedure SetPropertyValue(Component: TObject; AnXMLNode: TJvSimpleXmlElem);
  published
    property TmPack : Integer read FTmPack write FTmPack default 0;
    property TmRun : Integer read FTmRun write FTmRun default 0;
    property Name: string read FName write FName;
    property RepPack: TRepPack read FRepPack write FRepPack;
  end;
}
implementation

//uses
//  JvThemes,FrmMsg_;
const
//  Alignments: array [TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  Alignments: array [TAlignment] of Word = (0, 2, 1);
//  WordWraps: array [Boolean] of Word = (0, DT_WORDBREAK);
  WordWraps: array [Boolean] of Word = (0, 16);

procedure LoadPicture(pct : TPicture; pathpct : string);
begin
    if FileExists(pathpct) then pct.LoadFromFile(pathpct)
    else pct.LoadFromFile('00.png');
end;

{TrBevel}
constructor TrBevel.Create();
begin
  FBvlOw:=1; FBvlO:= bvNone;
  FBvlIw:=1; FBvlI:= bvNone;
end;
{TrCoord}
constructor TrCoord.Create();
begin
  Fh:=5; Fw:=5;
end;
procedure TrCoord.SetX(value : Integer);
begin
 Fx:=value; SetCrd();
end;
procedure TrCoord.SetY(value : Integer);
begin
 Fy:=value; SetCrd();
end;
procedure TrCoord.SetCrd();
var rim : rImg;
begin
  if obj= nil then Exit;
  if obj.ClassName='rImg' then
  begin
    rim:=rImg(obj);
    if rim.Shema.FlDeser then Exit;
    if rim.Image<>nil then
    begin
      rim.Image.SetBounds(Fx,Fy,Fh,Fw);
      rim.txt.SetX(rim.txt.Fx);
    end;
  end;
end;
{TrPropPar}
constructor TrPropPar.Create();
begin
  crd:=TrCoord.Create;
  crd.w:=300;crd.h:=200;
  fntSz:=3;
end;
destructor TrPropPar.Destroy;
begin
  crd.Free;
  inherited Destroy;
end;

{TrSelLbl}
constructor TrSelLbl.Create();
begin
    FHT:=True;
    FHTEnabled:=True;
    FHTFrameVisible:=True;
    FHTBrush:=TBrush.Create;
    FHTBrush.Style:=bsClear;
    FHTFrameColor:=clRed;
    FFr :=True;
    FFrColor :=0;
    FBrush:=TBrush.Create;
    FFnt :=False;
    FFntColor :=0;
    FShColor :=0;
//     FShPos := spLeftTop;
    FShSize :=0;

    FIcCrd :=TrCoord.Create();
    IcCrd.x:=1;IcCrd.y:=1;IcCrd.w:=10;IcCrd.h:=15;
    FIcClr1 := clGray;
    FIcClr2 := clBlue;
    FIcClr3 := clRed;
    FIcPos:= RtBt;

end;
{TrMemo}
constructor TrMemo.Create();
begin

  FLines:=TStringList.Create;
  FFont:= TFont.Create;
  FCrd:= TrCoord.Create;
  FBvl:=TrBevel.Create;
  FVis:=True;
  FAlignment:=taLeftJustify;
  FVAlignment:=taAlignTop;
end;

destructor TrMemo.Destroy;
begin
  FLines.Free;
  FFont.Free;
end;
procedure TrMemo.SetLines(Value : TStringList);
begin
  FLines:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.SetFont(Value : TFont);
begin
  FFont:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.SetColor1(Value : TColor);
begin
  FColor1:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.SetColor2(Value : TColor);
begin
  FColor2:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.SetAlignment(Value : TAlignment);
begin
  FAlignment:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.SetVAlignment(Value : TVerticalAlignment);
begin
  FVAlignment:=Value;
  ProcSetMem(Self);
end;
procedure TrMemo.ProcSetMem(rMem : TrMemo);
begin
if Assigned(FProcSetMem) then
    FProcSetMem(rMem);  // (objLst As TImgObjList).Items[indI],
end;

{TrItLstH}
destructor TrItLstH.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrItLstH.Add: rItLstH;
begin
  Result := rItLstH(inherited Add);
  Result.fTxt:= TStringList.Create;
  Result.fType:=rStr;
end;
procedure TrItLstH.Delete(Index: Integer);
begin
  Self.Items[Index].fTxt.Free;
  inherited Delete(Index);
end;
function TrItLstH.GetItem(Index: Integer): rItLstH;
begin
  Result := rItLstH(inherited Items[Index]);
end;
function TrItLstH.Insert(Index: Integer): rItLstH;
begin
  Result := rItLstH(inherited Insert(Index));
end;
procedure TrItLstH.SetItem(Index: Integer; const Value: rItLstH);
begin
  Items[Index].Assign(Value);
end;

{TrLstsHlp}
destructor TrLstsHlp.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstsHlp.Add: rLstHlp;
begin
  Result := rLstHlp(inherited Add);
  Result.fEnb:= True;
  Result.fLst :=TrItLstH.Create(rItLstH);
end;
procedure TrLstsHlp.Delete(Index: Integer);
begin
  Self.Items[Index].Lst.Free;
  inherited Delete(Index);
end;
function TrLstsHlp.GetItem(Index: Integer): rLstHlp;
begin
  Result := rLstHlp(inherited Items[Index]);
end;
function TrLstsHlp.Insert(Index: Integer): rLstHlp;
begin
  Result := rLstHlp(inherited Insert(Index));
end;
procedure TrLstsHlp.SetItem(Index: Integer; const Value: rLstHlp);
begin
  Items[Index].Assign(Value);
end;

{TrPg}
procedure TrPg.SetPic(pc_ : Integer);
begin
  Fpic:=pc_;
end;
procedure TrPg.SetPgVis(value : Boolean);
var i : Integer;
begin
  FPgVis:=value;
  for i :=0  to rImgs.Count-1 do
  begin
    rImgs.Items[i].VisChd:=value;
  end;
end;

{TrPages}
destructor TrPages.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrPages.Add: TrPg;
var par:  TWinControl;
    own: TPersistent;
    s : string;
begin
    Result := TrPg(inherited Add);
    Result.fRcts:=TrRcts.Create(rRct);
    Result.Coord:=TrCoord.Create;
  own:=Result.Collection.Owner;
  s:=own.ClassName;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    Result.Asks:=TrAsks.Create(own,TrAsk);
    Result.rImgs:=TrImgs.Create(own,rImg);
    par:=TShema(own).Parent;
    if par<>nil then
      Result.Shema:=TShema(own);
      if (Result.FpId=0) and not Result.Shema.FlDeser then
        Result.FpId:=Result.Shema.Pinc;
      Result.Parent:=par;
  end;
end;
procedure TrPages.Delete(Index: Integer);
begin
//  Items[Index].Image.Free;
  Items[Index].Rcts.Free;
  Items[Index].Coord.Free;
  Items[Index].rImgs.Free;
  inherited Delete(Index);
end;
function TrPages.GetItem(Index: Integer): TrPg;
begin
  Result := TrPg(inherited Items[Index]);
end;
function TrPages.Insert(Index: Integer): TrPg;
begin
  Result := TrPg(inherited Insert(Index));
end;
procedure TrPages.SetItem(Index: Integer; const Value: TrPg);
begin
  Items[Index].Assign(Value);
end;

{TrAsks}
destructor TrAsks.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;

function TrAsks.Add: TrAsk;
begin
    Result := TrAsk(inherited Add);
    Result.Ask:=TrMemo.Create;
    Result.Ask.FColor1:=-16777201;//clBtnFace;
    Result.Ask.FColor2:=-16777200;//clBtnShadow;
    Result.Ansver:=TrMemo.Create;
    Result.Ansver.FColor1:=16776960;//clAqua;
    Result.Ansver.FColor2:=15780518;//clSkyBlue;
    Result.Rem:=TrMemo.Create;
    Result.Rem.FColor1:=clSilver;
    Result.Rem.FColor2:=clBtnShadow;
    Result.ChAns:=TStringList.Create;
    Result.FRnd:=True;
//    Result.FMltSel:=True;
    Result.fNright:=1;
    Result.Rt:=TStringList.Create;
    Result.RemColor:=16711680;//clBlue;
end;
procedure TrAsks.Delete(Index: Integer);
begin
  Items[Index].Ask.Free;
  Items[Index].Rem.Free;
  Items[Index].Ansver.Free;
  Items[Index].ChAns.Free;
  Items[Index].Rt.Free;
  inherited Delete(Index);
end;
function TrAsks.GetItem(Index: Integer): TrAsk;
begin
  Result := TrAsk(inherited Items[Index]);
end;
function TrAsks.Insert(Index: Integer): TrAsk;
begin
  Result := TrAsk(inherited Insert(Index));
end;
procedure TrAsks.SetItem(Index: Integer; const Value: TrAsk);
begin
  Items[Index].Assign(Value);
end;

{TrAsk}
procedure TrAsk.SetRemBackPic(picP : string);
var own: TPersistent;
    Sh : TShema;
begin
  FRemImg:=picP;
  own:=Collection.Owner;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    Sh:=TShema(own);
    if Sh.ImgRemBack<>nil then
    begin
      Sh.ImgRemBack.Center:=RICenter;Sh.ImgRemBack.Stretch:=RIStretch;Sh.ImgRemBack.Proportional:=RIProportional;
      LoadPicture(Sh.ImgRemBack.Picture,Sh.PathPic+picP);
    end;
  end;
end;

procedure TrAsk.SetItmH(par : Integer);
begin
  FItmH:=par;
  Ansver.ProcSetMem(Ansver);
end;

procedure TrAsk.SetRemPnlSh(par : Boolean);
begin
  FRemPnlSh:=par;
  RIRealign;
end;
procedure TrAsk.SetRICenter(par : Boolean);
begin
  FRICenter:=par; RIRealign;
end;
procedure TrAsk.SetRIProportional(par : Boolean);
begin
  FRIProportional:=par; RIRealign;
end;
procedure TrAsk.SetRIStretch(par : Boolean);
begin
  FRIStretch:=par; RIRealign;
end;

procedure TrAsk.RIRealign();
var own: TPersistent;
    Sh : TShema;
begin
//  FRICenter:=RICenter; FRICenter:=RIStretch;FRICenter:=RIProportional;FRemPnlSh:=RemPnlSh;
  own:=Self.Collection.Owner;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    Sh:=TShema(own);
    if Sh.FlDeser then Exit;
    if Sh.ImgRemBack<>nil then
    begin
      Sh.ImgRemBack.Proportional:=RIProportional;
      Sh.ImgRemBack.Center:=RICenter;
      Sh.ImgRemBack.Stretch:=RIStretch;
    end;
    if Sh.PanAskO<>nil then
    begin
      Sh.PanAskO.SetBounds(Sh.Asks.Items[Sh.CurrAsk].Ask.Crd.x,Sh.Asks.Items[Sh.CurrAsk].Ask.Crd.y,
                          Sh.Asks.Items[Sh.CurrAsk].Ask.Crd.w,Sh.Asks.Items[Sh.CurrAsk].Ask.Crd.h);
      TPanel(Sh.PanAskO).BevelOuter:=Sh.Asks.Items[Sh.CurrAsk].Ask.Bvl.BvlO;
      TPanel(Sh.PanAskO).BevelWidth:=Sh.Asks.Items[Sh.CurrAsk].Ask.Bvl.FBvlOw;
    end;
    if Sh.PanAskI<>nil then
    begin
      TPanel(Sh.PanAskI).BevelInner:=Sh.Asks.Items[Sh.CurrAsk].Ask.Bvl.BvlI;
      TPanel(Sh.PanAskI).BevelWidth:=Sh.Asks.Items[Sh.CurrAsk].Ask.Bvl.FBvlIw;
      TPanel(Sh.PanAskI).BorderWidth:=Sh.Asks.Items[Sh.CurrAsk].Ask.Bvl.Border;
    end;
    if Sh.PanRem<>nil then
    begin
      Sh.PanRem.SetBounds(Sh.Asks.Items[Sh.CurrAsk].Rem.Crd.x,Sh.Asks.Items[Sh.CurrAsk].Rem.Crd.y,
                          Sh.Asks.Items[Sh.CurrAsk].Rem.Crd.w,Sh.Asks.Items[Sh.CurrAsk].Rem.Crd.h);
      TPanel(Sh.PanRem).BevelOuter:=Sh.Asks.Items[Sh.CurrAsk].Rem.Bvl.BvlO;
      TPanel(Sh.PanRem).BevelWidth:=Sh.Asks.Items[Sh.CurrAsk].Rem.Bvl.FBvlOw;
    end;
    if Sh.PanRemI<>nil then
    begin
      TPanel(Sh.PanRemI).BevelInner:=Sh.Asks.Items[Sh.CurrAsk].Rem.Bvl.BvlI;
      TPanel(Sh.PanRemI).BevelWidth:=Sh.Asks.Items[Sh.CurrAsk].Rem.Bvl.FBvlIw;
      TPanel(Sh.PanRemI).BorderWidth:=Sh.Asks.Items[Sh.CurrAsk].Rem.Bvl.Border;
    end;
    if Sh.PanRemBack<>nil then
    begin
      Sh.PanRemBack.SetBounds(0,0,Sh.Coord.w,Sh.Coord.h);
      if RemPnlSh then
      begin
        Sh.PanRemBack.Visible:=Sh.Asks.Items[Sh.CurrAsk].Rem.Vis
      end
      else
        Sh.PanRemBack.Visible:=False;
    end;
  end;
end;

{TrMsgs}
destructor TrMsgs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;

function TrMsgs.Add: rMsg;
var own: TPersistent;
    She : TShema;
    s : string;
begin
  Result := rMsg(inherited Add);
  own:=Result.Collection.Owner;
  s:=own.ClassName;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
//    par:=TShema(own).Parent;
    She:=TShema(own);
      if (Result.FmId=0) and not She.FlDeser then
        Result.FmId:=She.Minc;
  end;
end;
procedure TrMsgs.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrMsgs.GetItem(Index: Integer): rMsg;
begin
  Result := rMsg(inherited Items[Index]);
end;
function TrMsgs.Insert(Index: Integer): rMsg;
begin
  Result := rMsg(inherited Insert(Index));
end;
procedure TrMsgs.SetItem(Index: Integer; const Value: rMsg);
begin
  Items[Index].Assign(Value);
end;

{TrShrPrs}
destructor TrShrPrs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrShrPrs.Add: rShrPr;
begin
 Result := rShrPr(inherited Add);
 Result.Proc:=TrPar.Create;
 Result.Proc.tp:=rPAct;
 Result.Proc.par:= TStringList.Create;
end;
procedure TrShrPrs.Delete(Index: Integer);
begin inherited Delete(Index);end;
function TrShrPrs.GetItem(Index: Integer): rShrPr;
begin Result := rShrPr(inherited Items[Index]);end;
function TrShrPrs.Insert(Index: Integer): rShrPr;
begin Result := rShrPr(inherited Insert(Index)); end;
procedure TrShrPrs.SetItem(Index: Integer; const Value: rShrPr);
begin Items[Index].Assign(Value); end;

{TrGrRects}
destructor TrGrRects.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrGrRects.Add: TrGrRect;
begin
    Result := TrGrRect(inherited Add);
    Result.VRects:=TrVRects.Create(TrVRect);
    Result.AnsRects:=TrAnsRects.Create(TrAnsRect);
end;
procedure TrGrRects.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrGrRects.GetItem(Index: Integer): TrGrRect;
begin
  Result := TrGrRect(inherited Items[Index]);
end;
function TrGrRects.Insert(Index: Integer): TrGrRect;
begin
  Result := TrGrRect(inherited Insert(Index));
end;
procedure TrGrRects.SetItem(Index: Integer; const Value: TrGrRect);
begin
  Items[Index].Assign(Value);
end;
{TrGrRect}
{TrVRects}
destructor TrVRects.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrVRects.Add: TrVRect;
begin
    Result := TrVRect(inherited Add);
    Result.Coord:=TrCoord.Create;
end;
procedure TrVRects.Delete(Index: Integer);
begin
  if Items[Index].Coord<>nil then Items[Index].Coord.Free;
  inherited Delete(Index);
end;
function TrVRects.GetItem(Index: Integer): TrVRect;
begin
  Result := TrVRect(inherited Items[Index]);
end;
function TrVRects.Insert(Index: Integer): TrVRect;
begin
  Result := TrVRect(inherited Insert(Index));
end;
procedure TrVRects.SetItem(Index: Integer; const Value: TrVRect);
begin
  Items[Index].Assign(Value);
end;
{TrVRect}
{TrAnsRects}
destructor TrAnsRects.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrAnsRects.Add: TrAnsRect;
begin
    Result := TrAnsRect(inherited Add);
end;
procedure TrAnsRects.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrAnsRects.GetItem(Index: Integer): TrAnsRect;
begin
  Result := TrAnsRect(inherited Items[Index]);
end;
function TrAnsRects.Insert(Index: Integer): TrAnsRect;
begin
  Result := TrAnsRect(inherited Insert(Index));
end;
procedure TrAnsRects.SetItem(Index: Integer; const Value: TrAnsRect);
begin
  Items[Index].Assign(Value);
end;
{TrAnsRect}

{TrAnsTxts}
{destructor TrAnsTxts.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrAnsTxts.Add: TrAnsTxt;
begin
    Result := TrAnsTxt(inherited Add);
end;
procedure TrAnsTxts.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrAnsTxts.GetItem(Index: Integer): TrAnsTxt;
begin
  Result := TrAnsTxt(inherited Items[Index]);
end;
function TrAnsTxts.Insert(Index: Integer): TrAnsTxt;
begin
  Result := TrAnsTxt(inherited Insert(Index));
end;
procedure TrAnsTxts.SetItem(Index: Integer; const Value: TrAnsTxt);
begin
  Items[Index].Assign(Value);
end;}
{TrAnsTxt}

{TrFragments}
destructor TrFragments.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrFragments.Add: TrFragment;
begin
    Result := TrFragment(inherited Add);
{    Result.AnsTxt:= TrAnsTxt.Create();
    Result.AnsTxt.Ans:=TStringList.Create;
    Result.AnsTxt.Ans.Text:= '"1","1","Ответ"';}
    Result.GrRects:=TrGrRects.Create(TrGrRect);
end;
procedure TrFragments.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrFragments.GetItem(Index: Integer): TrFragment;
begin
  Result := TrFragment(inherited Items[Index]);
end;
function TrFragments.Insert(Index: Integer): TrFragment;
begin
  Result := TrFragment(inherited Insert(Index));
end;
procedure TrFragments.SetItem(Index: Integer; const Value: TrFragment);
begin
  Items[Index].Assign(Value);
end;
{TrFragment}

{rMrul}
procedure rMrul.GoRule(rule : rMrul; msg:String);
begin
  if Assigned(fGoRule) then fGoRule(rule , msg);
end;

{TrText}
constructor TrText.Create();
begin
  FFont:=TFont.Create;
  FAlg:=0;
  FAutoSize:=False;
  FText:=TStringList.Create;
  FCurText:=TStringList.Create;
end;
destructor TrText.Destroy;
begin
  if Font<>nil then Font.Free;
  Text.Free; CurText.Free;
end;
procedure TrText.SetEnb(Value : Boolean);
begin
  FEnb:=Value; SetLabel;
end;
procedure TrText.SetAutoSize(Value : Boolean);
begin
  FAutoSize:=Value; SetLabel;
end;
procedure TrText.SetAngl(Value : Integer);
begin
  FAngl:=Value; SetLabel;
end;
procedure TrText.SetX(Value : Integer);
begin
  Fx:=Value; SetLabel;
end;
procedure TrText.SetY(Value : Integer);
begin
  Fy:=Value;
end;
procedure TrText.SetAlg(Value : Integer);
begin
  FAlg:=Value; SetLabel;
end;
procedure TrText.SetLabel();
begin
  if MyrImg<>nil then
  begin
    if MyrImg.Shema.FlDeser then Exit;
    if MyrImg.Lbl=nil then Exit;

    MyrImg.Lbl.AutoSize:=FAutoSize;
//    MyrImg.Lbl.Angle:=FAngl;
    MyrImg.Lbl.SetBounds(Fx+MyrImg.Coord.x,Fy+MyrImg.Coord.y,MyrImg.Lbl.Width,MyrImg.Lbl.Height);
    case Alg of
    0: MyrImg.Lbl.Alignment:=taCenter;
    1: MyrImg.Lbl.Alignment:=taLeftJustify;
    2: MyrImg.Lbl.Alignment:=taRightJustify;
     else MyrImg.Lbl.Alignment:=taCenter;
    end;
  end;
end;
procedure TrText.SetARowCur(Value : Integer);
var vl :Integer;
    rpObj : rrpObj;
begin
  if self=nil then Exit;
  if Text=nil then Exit;
  if Value<0 then Value:=0;
  if Text.Text<>'' then
    Cnt:=Text.Count;

  if MyrImg.Shema.ModeView=0 then vl:=0
  else if MyrImg.Shema.ModeView=1 then vl:=Value
  else if MyrImg.Shema.ModeView=2 then
  begin
    vl:=Value;
    if MyrImg.Shema.CurA<>nil then
    begin
      rpObj:=MyrImg.Shema.CurA.roAsk.GetItemIDO(MyrImg.aId);
      if rpObj<>nil then vl:=rpObj.N;
    end;
  end;
  FARowCur:=vl;
  if Cnt<=vl then MyrImg.Lbl.Caption:=''
  else
  begin
    if Text.Count>vl then
    begin
     CurText.CommaText:=Text[vl];
     MyrImg.Lbl.Caption:=CurText[1];
    end;
  end;
end;
procedure TrText.SetARow(Value : Integer);
begin
  if Value<0 then Value:=0;
  FARow:=Value;
  SetARowCur(Value);
end;

{rVal}
procedure rVal.SetVal(Val : Double);
begin
  if not MyrImg.ProcEventB(MyrImg,rEValCh,false) then Exit;
  FvO:=Val;
  if Conds.Count>0 then
    MyrImg.ConditionEntry(Conds);
  MyrImg.ProcEvent(MyrImg,rEValCh,false);
end;
{rTmr}
procedure rTmr.GoTimer(AOwner: TObject);
var rIm : rImg;
begin
  if Count<>-1 then
  begin
    if curcnt<=0 then Enab:=false;
    curcnt:=curcnt-1;
  end;
  if pImg=nil then
  begin
    rIm:=rImg(self.Shema.rImgs.Items[0]);
    rIm.GoActions(self.rActs,[ssLeft]);
  end
  else  pImg.GoActions(self.rActs,[ssLeft]);
end;
procedure rTmr.SetIntr(value : Cardinal);
begin
  FIntr:=value;
  Tmr.Interval:=value;
end;
procedure rTmr.SetEnab(value : boolean);
begin
  FEnab:=value;
  Tmr.Enabled:=value;
end;
{TrLbl}
procedure TrLbl.DblClick;
begin
  inherited DblClick;
  MyrImg.Image.DblClick;
end;

//procedure TrLbl.MouseEnter(Control: TControl);
//begin
//  inherited  MouseEnter(Control);
//  MyrImg.Image.MouseEnter(Control);
//end;
//procedure TrLbl.MouseLeave(Control: TControl);
//begin
//  inherited  MouseLeave(Control);
//  MyrImg.Image.MouseLeave(Control);
//end;

function TrLbl.MoveIco(X, Y: Integer): Boolean;
  var xIc,yIc,x1Ic,y1Ic: Integer;
  Rect: TRect;
  mrIm : rImg;
begin
  Result:=False;
  mrIm:=MyrImg;
  if mrIm.Shema=nil then Exit;
    Rect := ClientRect;
    if mrIm.Shema.SelLbl.IcPos=LfTp then
    begin
      xIc:=MyrImg.Shema.SelLbl.IcCrd.x;yIc:=MyrImg.Shema.SelLbl.IcCrd.y;
    end
    else if mrIm.Shema.SelLbl.IcPos=RtTp then
    begin
      xIc:=Rect.Right- MyrImg.Shema.SelLbl.IcCrd.w- MyrImg.Shema.SelLbl.IcCrd.x;yIc:=MyrImg.Shema.SelLbl.IcCrd.y;
    end
    else if mrIm.Shema.SelLbl.IcPos=RtBt then
    begin
      xIc:=Rect.Right- MyrImg.Shema.SelLbl.IcCrd.x- MyrImg.Shema.SelLbl.IcCrd.w;
      yIc:=Rect.Bottom -MyrImg.Shema.SelLbl.IcCrd.y- MyrImg.Shema.SelLbl.IcCrd.h;
    end
    else if mrIm.Shema.SelLbl.IcPos=LfBt then
    begin
      xIc:=MyrImg.Shema.SelLbl.IcCrd.x;
      yIc:=Rect.Bottom -MyrImg.Shema.SelLbl.IcCrd.y- MyrImg.Shema.SelLbl.IcCrd.h;
    end;
    x1Ic:=xIc+MyrImg.Shema.SelLbl.IcCrd.w;
    y1Ic:=yIc+MyrImg.Shema.SelLbl.IcCrd.h;
    if (X<x1Ic) and (X>xIc) and (y<y1Ic) and (y>yIc) then Result:=True;
end;

procedure TrLbl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  FlMvIc:=MoveIco(X, Y);
  Paint;
  MyrImg.Image.MouseMove(Shift, X+FMyrImg.txt.x, Y+FMyrImg.txt.y);
end;

procedure TrLbl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (FMyrImg.Shema.Mode=rShMeas) and (Button=mbLeft) then
  begin
    Exit;
  end;
    if MyrImg.LblClk then
    begin
//      if MyrImg.Shema.TypeSub<>rAskRect then Exit;
//      FMyrImg.GoMeasure(X+Left,Y+Top);
    end;
  MyrImg.Image.MouseDown(Button, Shift, X+FMyrImg.txt.x, Y+FMyrImg.txt.y);
  Paint;
end;

procedure TrLbl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
//  if MyrImg.Shema.TypeSub<>rAskRect then Exit;
//  MyrImg.Image.MouseUp(Button, Shift, X-FMyrImg.txt.x, Y-FMyrImg.txt.y);
  MyrImg.Image.MouseUp(Button, Shift, X+FMyrImg.txt.x, Y+FMyrImg.txt.y);
end;
procedure TrLbl.Assign(Source: TPersistent);
begin
   inherited Assign(Source);
end;
procedure TrLbl.Paint;
var
  Rect,Rect1,CalcRect: TRect;
  DrawStyle,xIc,yIc,x1Ic,y1Ic: Integer;
  InteriorMargin: Integer;
  OldPenColor,clrFr: TColor;
  mrIm : rImg;

  procedure PaintIcoMyAns();
  begin //FlSaveRem он же FlMyAnsv
      if not (Enabled {and MouseOver and HotTrack})  then
       if not FlSaveRem then Exit;

       if FlSaveRem then  Canvas.Pen.Color:=MyrImg.Shema.SelLbl.FIcClr2
       else Canvas.Pen.Color:=MyrImg.Shema.SelLbl.FIcClr1;
       Canvas.Pen.Width:=1;Canvas.Brush.Style := bsClear ;
        if mrIm.Shema.SelLbl.IcPos=LfTp then
        begin
          xIc:=MyrImg.Shema.SelLbl.IcCrd.x;yIc:=MyrImg.Shema.SelLbl.IcCrd.y;
        end
        else if mrIm.Shema.SelLbl.IcPos=RtTp then
        begin
          xIc:=Rect.Right- MyrImg.Shema.SelLbl.IcCrd.w- MyrImg.Shema.SelLbl.IcCrd.x;yIc:=MyrImg.Shema.SelLbl.IcCrd.y;
        end
        else if mrIm.Shema.SelLbl.IcPos=RtBt then
        begin
          xIc:=Rect.Right- MyrImg.Shema.SelLbl.IcCrd.x- MyrImg.Shema.SelLbl.IcCrd.w;
          yIc:=Rect.Bottom -MyrImg.Shema.SelLbl.IcCrd.y- MyrImg.Shema.SelLbl.IcCrd.h;
        end
        else if mrIm.Shema.SelLbl.IcPos=LfBt then
        begin
          xIc:=MyrImg.Shema.SelLbl.IcCrd.x;
          yIc:=Rect.Bottom -MyrImg.Shema.SelLbl.IcCrd.y- MyrImg.Shema.SelLbl.IcCrd.h;
        end;
          x1Ic:=xIc+MyrImg.Shema.SelLbl.IcCrd.w;
          y1Ic:=yIc+MyrImg.Shema.SelLbl.IcCrd.h;
          Canvas.Rectangle(xIc,yIc,x1Ic,y1Ic);
  end;

begin
  InteriorMargin := 0;
  mrIm:=MyrImg;
  if mrIm.Shema=nil then Exit;
  inherited;
//  Exit;

  with Canvas do
  begin
    Rect := ClientRect;
    Canvas.Pen.Width:=4;
    if Enabled {and MouseOver and HotTrack}  then
    begin

    end
    else
    begin
      Canvas.Font := Self.Font;
      if not Transparent then
            Canvas.Rectangle(0, 0, Width, Height)
 //     else if Transparent then Canvas.Brush.Style := bsClear;
    end;
    if mrIm.Shema.UseIcMyAnsv then PaintIcoMyAns();
    InflateRect(Rect, -1, 0);
    DrawStyle := 64 or WordWraps[WordWrap] or Alignments[Alignment];
    { Calculate vertical layout }
    if Layout <> tlTop then
    begin
      CalcRect := Rect;
//      DoDrawText(CalcRect, DrawStyle or 1024);
      if Layout = tlBottom then
        OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else
        OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
//    DoDrawText(Rect, DrawStyle);
  end;
end;

{TrImage}
procedure TrImage.DblClick;
begin
  Fmove:=false;
  Fdblc:=True;
  inherited DblClick;
end;
procedure TrImage.Click;
begin
  inherited Click;
end;

//procedure TrImage.MouseEnter(Control: TControl);
//begin
//  inherited  MouseEnter(Control);
////  if Assigned(FOnMouseEnter) then
////    FOnMouseEnter(Self);
//  MyrImg.GoMouseEv(rEMsEnter,0,0,[ssLeft]);
//end;
//procedure TrImage.MouseLeave(Control: TControl);
//begin
//  inherited  MouseLeave(Control);
//  MyrImg.GoMouseEv(rEMsLeave,0,0,[ssLeft]);
//end;
procedure TrImage.MouseMove(Shift: TShiftState; X, Y: Integer);
var x0,y0,x1,y1,xan,yan : integer;
begin
  if Fdblc then begin Fdblc:=False;Fmove:=False; end;
//    if FMyrImg.FMoveChd then exit;
  inherited MouseMove(Shift, X, Y);
  if not MyrImg.FLck then
  begin
    if Fmove then
    begin
      if MyrImg.TpMv=rAll then
      begin
        x0:=X-Fxold+Left;y0:=Y-Fyold+Top;
        x1:=X-Fxold;y1:=Y-Fyold;
        FMyrImg.MoveChld(x1,y1);
        SetBounds(x0,y0,Width,Height);
//        if FMyrImg.txt.Enb then

        if (FMyrImg.Lbl<>nil) and (FMyrImg.txt<>nil) then
//          FMyrImg.Lbl.SetBounds(x0,y0,FMyrImg.Lbl.Width,FMyrImg.Lbl.Height);
          FMyrImg.Lbl.SetBounds(x0+FMyrImg.txt.x,y0+FMyrImg.txt.y,FMyrImg.Lbl.Width,FMyrImg.Lbl.Height);
        if FMyrImg.FAnPrib <> nil then
        begin
          xan:=x0+FMyrImg.FAnPrib.Fx; yan:=y0+FMyrImg.FAnPrib.Fy;
          if FMyrImg.AnPrib.Active then
            FImgAn.SetBounds(xan,yan,FImgAn.Width,FImgAn.Height);
        end;
        FMyrImg.Vx:= xan - FMyrImg.x0;
      end
      else if MyrImg.TpMv=rOnlH then
      begin
        x0:=X-Fxold+Left;y0:=Top;
        x1:=X-Fxold;y1:=Y-Fyold;
        xan:=x0+FMyrImg.FAnPrib.Fx;yan:=y0+FMyrImg.FAnPrib.Fy;
        FMyrImg.Vx:= xan - FMyrImg.x0;
        if (FMyrImg.FVx>=MyrImg.VxMin) and (FMyrImg.FVx<=MyrImg.VxMax) then
        begin
          FMyrImg.MoveChld(x1,y1);
          SetBounds(x0,y0,Width,Height);
          if FMyrImg.txt.Enb then FMyrImg.Lbl.SetBounds(x0+FMyrImg.txt.x,y0+FMyrImg.txt.y,FMyrImg.Lbl.Width,FMyrImg.Lbl.Height);
          if FMyrImg.AnPrib.Active then FImgAn.SetBounds(xan,yan,FImgAn.Width,FImgAn.Height);
        end;
      end;
    end;
  end;
  MyrImg.GoMouseEv(rEMsMove,X,Y,Shift);
end;

procedure TrImage.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Fdblc then begin Fdblc:=False;Fmove:=False;Exit end;
  inherited MouseDown(Button, Shift, X, Y);
  if FMyrImg.Shema.UseIcMyAnsv then
  begin
    if (FMyrImg.Shema.Mode=rShPlay) and (FMyrImg.TypeObj=rLb) then
    begin
      if FMyrImg.Lbl.MoveIco(X,Y)then
      begin
        MyrImg.ProcEvent(FMyrImg,rEMyAnsv,false);
//        FMyrImg.Lbl.OnClick(FMyrImg.Lbl);
//        MyrImg.ProcEvent(FMyrImg,rEMsDown,false);
       Exit;
      end;
    end;
  end;

  if (FMyrImg.Shema.Mode=rShMeas) and (Button=mbLeft) then
  begin
//    xc1:=X-round(msr.Image1.Width/2)+Left; yc1:=Y-round(msr.Image1.Height/2)+Top;
    FMyrImg.GoMeasure(X+Left,Y+Top);
  end;
  if not FMyrImg.FLck then //FMyrImg.FModeEdit or
  begin
//    if (FMyrImg.Shema.Mode<>rShPlay) and (FMyrImg.TypeObj<>rLb) then
//    begin
    if FMyrImg.Shema.TypeSub<>rAskRect then
    begin
     Fxold:=X;Fyold:=Y; Fmove:=true;
    end;
  end;
  MyrImg.GoMouseEv(rEMsDown,X,Y,Shift);
  MyrImg.ProcEvent(FMyrImg,rEMsDown,false);
end;

procedure TrImage.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FMyrImg.FLck then //FMyrImg.FModeEdit or
  begin
    if Fmove then
    begin
      Fmove:=false;
      if FMyrImg=nil then exit;
      FMyrImg.SetCrdCh(Left,Top);
      FMyrImg.Coord.x:=Left; FMyrImg.Coord.y:=Top;
      FMyrImg.Coord.w:=Width; FMyrImg.Coord.h:=Height;
    end;
  end;
  Fmove:=false;
  inherited MouseUp(Button, Shift, X, Y);
//ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble
    if Button=mbLeft then MyrImg.GoMouseEv(rEMsUp,X,Y,[ssLeft]);
    if Button=mbLeft then MyrImg.ProcEvent(FMyrImg,rEMsUp,false);
end;

{TConds}
destructor TConds.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TConds.Add: Cnd;
begin
  Result := Cnd(inherited Add);
  Result.rActs:=TrActs.Create(rAct);
  Result.par1:=TrPar.Create;
  Result.par1.tp:=rPCnd;
  Result.par1.par:= TStringList.Create;
end;
procedure TConds.Delete(Index: Integer);
begin
//  Items[Index].par.Free;
  Items[Index].par1.par.Free;
  Items[Index].par1.Free;
  Items[Index].rActs.Free;
  inherited Delete(Index);
end;
function TConds.GetItem(Index: Integer): Cnd;
begin
  Result := Cnd(inherited Items[Index]);
end;
function TConds.Insert(Index: Integer): Cnd;
begin
  Result := Cnd(inherited Insert(Index));
end;
procedure TConds.SetItem(Index: Integer; const Value: Cnd);
begin
  Items[Index].Assign(Value);
end;

{TrMRuls}
destructor TrMRuls.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrMRuls.Add: rMrul;
var own: TPersistent;
    s : string;
begin
  Result := rMrul(inherited Add);
  Result.Msg:= TStringList.Create;
  Result.FConds:=TConds.Create(Cnd);
  Result.rActs:=TrActs.Create(rAct);
  own:=Result.Collection.Owner;
  s:=own.ClassName;
  while (own<>nil) and (own.ClassName<>'TShema') do
    own:=TOwnedCollection(own).Owner;
  if own<>nil then Result.FShema:=TShema(own);
end;
procedure TrMRuls.Delete(Index: Integer);
begin
  Self.Items[Index].Msg.Free;
  Self.Items[Index].Conds.Free;
  Self.Items[Index].rActs.Free;
  inherited Delete(Index);
end;
function TrMRuls.GetItem(Index: Integer): rMrul;
begin
  Result := rMrul(inherited Items[Index]);
end;
function TrMRuls.Insert(Index: Integer): rMrul;
begin
  Result := rMrul(inherited Insert(Index));
end;
procedure TrMRuls.SetItem(Index: Integer; const Value: rMrul);
begin
  Items[Index].Assign(Value);
end;

{TrTmrs}
destructor TrTmrs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrTmrs.Add: rTmr;
var par:  TWinControl;
    own: TPersistent;
    s : string;
begin
  Result := rTmr(inherited Add);
  Result.rActs:=TrActs.Create(rAct);
  own:=Result.Collection.Owner;
  s:=own.ClassName;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    par:=TShema(own).Parent;
    Result.FShema:=TShema(own);
    if par<>nil then
      Result.Parent:=par;
      Result.FTmr:=TTimer.Create(par);
      Result.FTmr.Enabled:=false;
      if (Result.FtId=0) and not Result.Shema.FlDeser then
        Result.FtId:=Result.Shema.Tinc;
      Result.FTmr.OnTimer:=Result.GoTimer;
  end;
end;
procedure TrTmrs.Delete(Index: Integer);
begin
  Items[Index].Tmr.Enabled:=false;
  Items[Index].Tmr.Free;
  Items[Index].rActs.Free;
  inherited Delete(Index);
end;
function TrTmrs.GetItem(Index: Integer): rTmr;
begin
  Result := rTmr(inherited Items[Index]);
end;
function TrTmrs.Insert(Index: Integer): rTmr;
begin
  Result := rTmr(inherited Insert(Index));
end;
procedure TrTmrs.SetItem(Index: Integer; const Value: rTmr);
begin
  Items[Index].Assign(Value);
end;

{TrActs}
destructor TrActs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrActs.Add: rAct;
begin
  Result := rAct(inherited Add);
  Result.FConds:=TConds.Create(Cnd);
  Result.FCndAct:=[ssLeft];
  Result.TpA:=rAcSt;
  Result.par1:=TrPar.Create;
  Result.par1.tp:=rPAct;
  Result.par1.par:= TStringList.Create;
end;
procedure TrActs.Delete(Index: Integer);
begin
  Items[Index].par1.par.Free;
  Items[Index].par1.Free;
  inherited Delete(Index);
end;
function TrActs.GetItem(Index: Integer): rAct;
begin
  Result := rAct(inherited Items[Index]);
end;
function TrActs.Insert(Index: Integer): rAct;
begin
  Result := rAct(inherited Insert(Index));
end;
procedure TrActs.SetItem(Index: Integer; const Value: rAct);
begin
  Items[Index].Assign(Value);
end;

{TrVals}
destructor TrVals.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrVals.Add: rVal;
begin
  Result := rVal(inherited Add);
  Result.FMyrImg:=FMyrImg;
  Result.FConds:=TConds.Create(Cnd);
  Result.IdV:=Count;
end;
procedure TrVals.Delete(Index: Integer);
begin
  Self.Items[Index].Conds.Free;
  inherited Delete(Index);
end;
function TrVals.GetItem(Index: Integer): rVal;
begin
  Result := rVal(inherited Items[Index]);
end;
function TrVals.Insert(Index: Integer): rVal;
begin
  Result := rVal(inherited Insert(Index));
end;
procedure TrVals.SetItem(Index: Integer; const Value: rVal);
begin
  Items[Index].Assign(Value);
end;
{TrShVls}
destructor TrShVls.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrShVls.Add: rShVl;
begin
  Result := rShVl(inherited Add);
  Result.FIdv:= Self.FShema.Vinc;
end;
procedure TrShVls.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrShVls.GetItem(Index: Integer): rShVl;
begin
  Result := rShVl(inherited Items[Index]);
end;
function TrShVls.Insert(Index: Integer): rShVl;
begin
  Result := rShVl(inherited Insert(Index));
end;
procedure TrShVls.SetItem(Index: Integer; const Value: rShVl);
begin
  Items[Index].Assign(Value);
end;
{TrMsrImg}
procedure TrMsrImg.Click;
var im:rImg;
begin
  Visible:=false;
  im:=MyrMsr.Shema.FindrImgById(MyrMsr.FidO,MyrMsr.Shema.rImgs);
  if id = 1 then MyrMsr.idO1:=0
  else if id = 2 then MyrMsr.idO2:=0;
  if MyrMsr.UsVal then im.AnVal:=MyrMsr.Val;
  im.GoMeasure(0,0);
end;

{TrCndMsrs}
destructor TrCndMsrs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrCndMsrs.Add: rCndMsr;
begin
    Result := rCndMsr(inherited Add);
    Result.par1:=TrPar.Create;
    Result.par1.tp:=rPAct;
    Result.par1.par:= TStringList.Create;
end;
procedure TrCndMsrs.Delete(Index: Integer);
begin
  Items[Index].par1.par.Free;
  Items[Index].par1.Free;
  inherited Delete(Index);
end;
function TrCndMsrs.GetItem(Index: Integer): rCndMsr;
begin
  Result := rCndMsr(inherited Items[Index]);
end;
function TrCndMsrs.Insert(Index: Integer): rCndMsr;
begin
  Result := rCndMsr(inherited Insert(Index));
end;
procedure TrCndMsrs.SetItem(Index: Integer; const Value: rCndMsr);
begin
  Items[Index].Assign(Value);
end;

{rMsr}

{TrMeass}
destructor TrMeass.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrMeass.Add: rMsr;
begin
    Result := rMsr(inherited Add);
    Result.Shema:=Shema;
    Result.Image1:=TrMsrImg.Create(Shema.Parent);
    Result.Image1.Parent:=Shema.Parent;
    Result.Image1.MyrMsr:=Result;
    Result.Image1.id:=1;
    Result.Image1.Visible:=false;
    Result.Image2:=TrMsrImg.Create(Shema.Parent);
    Result.Image2.Parent:=Shema.Parent;
    Result.Image2.MyrMsr:=Result;
    Result.Image2.id:=2;
    Result.Image1.Visible:=false;
    Result.CndMsrs:=TrCndMsrs.Create(rCndMsr);
    Result.UsVal:=True;
end;
procedure TrMeass.Delete(Index: Integer);
begin
  Items[Index].Image1.Visible:=false;
  Items[Index].Image1.Free;
  Items[Index].Image2.Visible:=false;
  Items[Index].Image2.Free;
  inherited Delete(Index);
end;
function TrMeass.GetItem(Index: Integer): rMsr;
begin
  Result := rMsr(inherited Items[Index]);
end;
function TrMeass.Insert(Index: Integer): rMsr;
begin
  Result := rMsr(inherited Insert(Index));
end;
procedure TrMeass.SetItem(Index: Integer; const Value: rMsr);
begin
  Items[Index].Assign(Value);
end;

{TrRcts}
destructor TrRcts.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrRcts.Add: rRct;
begin
  Result := rRct(inherited Add);
  Result.FMyrImg:=FMyrImg;
  Result.FCoord:=TrCoord.Create;
  Result.FrEvs:=TrEvs.Create(rEv);
  Result.par1:=TrPar.Create;
  Result.par1.par:=TStringList.Create;
end;
procedure TrRcts.Delete(Index: Integer);
begin
  Items[Index].rEvs.Free;
  Items[Index].Coord.Free;
  Items[Index].par1.par.Free;
  Items[Index].par1.Free;
  inherited Delete(Index);
end;
function TrRcts.GetItem(Index: Integer): rRct;
begin
  Result := rRct(inherited Items[Index]);
end;
function TrRcts.Insert(Index: Integer): rRct;
begin
  Result := rRct(inherited Insert(Index));
end;
procedure TrRcts.SetItem(Index: Integer; const Value: rRct);
begin
  Items[Index].Assign(Value);
end;

{TrEvs}
destructor TrEvs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrEvs.Add: rEv;
begin
  Result := rEv(inherited Add);
  Result.rActs:=TrActs.Create(rAct);
  Result.FType:=rEMsUp;
end;
procedure TrEvs.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrEvs.GetItem(Index: Integer): rEv;
begin
  Result := rEv(inherited Items[Index]);
end;
function TrEvs.Insert(Index: Integer): rEv;
begin
  Result := rEv(inherited Insert(Index));
end;
procedure TrEvs.SetItem(Index: Integer; const Value: rEv);
begin
  Items[Index].Assign(Value);
end;
{TrMns}
destructor TrMns.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrMns.Add: rMn;
begin
  Result := rMn(inherited Add);
  Result.rActs:=TrActs.Create(rAct);
end;
procedure TrMns.Delete(Index: Integer);
begin
  Self.Items[Index].rActs.Free;
  inherited Delete(Index);
end;
function TrMns.GetItem(Index: Integer): rMn;
begin
  Result := rMn(inherited Items[Index]);
end;
function TrMns.Insert(Index: Integer): rMn;
begin
  Result := rMn(inherited Insert(Index));
end;
procedure TrMns.SetItem(Index: Integer; const Value: rMn);
begin
  Items[Index].Assign(Value);
end;

{rStat}
procedure rStat.Setpic(pc : Integer);
var
  img : rImg;
  s : string;
begin
  Self.Fpic:=pc;
  img:= rImg(Collection.Owner);
  if img=nil then Exit;
  if img.Shema=nil then Exit;
  if img.Shema.FlDeser or img.Shema.flDsrForRp then Exit;
  if img.Shema.LstPathPic=nil then Exit;
  s:= img.Shema.LstPathPic.Path(pc);
  if s<>'' then PathPic:=s;
  if img.St= Self.st then  img.Update;
end;

procedure rStat.SetPathPic(PathPc : string);
var img : rImg;
begin
  FPathPic:=PathPc;
  img:= rImg(Collection.Owner);
  if img=nil then Exit;
  if img.Shema=nil then Exit;
  if img.Shema.FlDeser or img.Shema.flDsrForRp then Exit;
  if img.St= Self.st then  img.Update;
end;

procedure rStat.SetPathPicD(PathPc : string);
var img : rImg;
begin
  FPathPicD:=PathPc;
  img:= rImg(Collection.Owner);
  if img=nil then Exit;
  if img.Shema=nil then Exit;
  if img.Shema.FlDeser or img.Shema.flDsrForRp then Exit;
end;

procedure rStat.SetPathPicE(PathPc : string);
var img : rImg;
begin
  FPathPicE:=PathPc;
  img:= rImg(Collection.Owner);
  if img=nil then Exit;
  if img.Shema=nil then Exit;
  if img.Shema.FlDeser or img.Shema.flDsrForRp then Exit;
end;

procedure rStat.SetpicD(pc : Integer);
begin
  Self.FpicD:=pc;
end;

procedure rStat.SetpicE(pc : Integer);
begin
  Self.FpicE:=pc;
end;
{ TrStats }

destructor TrStats.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrStats.Add: rStat;
begin
  Result := rStat(inherited Add);
  Result.FConds:=TConds.Create(Cnd);
  Result.rActs:=TrActs.Create(rAct);

end;
procedure TrStats.Delete(Index: Integer);
begin
  Self.Items[Index].Conds.Free;
  Self.Items[Index].rActs.Free;
  inherited Delete(Index);
end;
function TrStats.GetItem(Index: Integer): rStat;
begin
  Result := rStat(inherited Items[Index]);
end;
function TrStats.Insert(Index: Integer): rStat;
begin
  Result := rStat(inherited Insert(Index));
end;
procedure TrStats.SetItem(Index: Integer; const Value: rStat);
begin
  Items[Index].Assign(Value);
end;

{rImg}

function rImg.GoMeasure(X,Y : integer) : boolean;
var xc1,yc1,i :integer;
    msr : rMsr; rim:rImg;
  function str2int(s:string) : integer;
  begin
    try result:=strtoint(s)
      except result:=0
    end;
  end;
begin
  Result:=True;
  if Shema.FCurrMsr<0 then Exit;
    msr:=Shema.rMeass.Items[Shema.FCurrMsr];
    if (not notMsr) and (msr.idO<>aId) then exit;
    xc1:=X-round(msr.Image1.Width/2); yc1:=Y-round(msr.Image1.Height/2);
  if msr.Ncont=2 then
  begin
    if msr.idO<>aId then
    begin
      if not msr.Image1.Visible then
      begin
        msr.Image1.Left:=xc1; msr.Image1.Top:=yc1; msr.FidO1:=aId;
        msr.Image1.Visible:=true; msr.Image1.BringToFront;
      end
      else
      begin
        msr.Image2.Left:=xc1; msr.Image2.Top:=yc1; msr.FidO2:=aId;
        msr.Image2.Visible:=true; msr.Image2.BringToFront;
      end;
    end;
    if msr.Image1.Visible and msr.Image2.Visible then
    begin
      rim:=Shema.FindrImgById(msr.idO,Shema.rImgs);
      if rim<>nil then
      begin
        if msr.UsVal then rim.AnVal:=msr.Val;
        if (msr.idO1=msr.idO2) and (msr.idO1<>0) then rim.AnVal:=0  //кз
        else if msr.CndMsrs.Count>0 then
        begin
          for i := 0 to msr.CndMsrs.Count-1 do
          begin
            if VarToStr(Shema.RunInterpreter(msr.CndMsrs.Items[i].par1.par.Text))='True' then Break;
          end;
        end
        else
        begin
          if msr.UsVal then rim.AnVal:=msr.Val;
        end;
      end;
    end
    else
    begin
      rim:=Shema.FindrImgById(msr.idO,Shema.rImgs);
      if rim<>nil then
      begin
       if msr.UsVal then rim.AnVal:=msr.Val;
       rim.ProcEvent(rim,rEBckMeas,False);
      end;
    end;
  end
  else if msr.Ncont=1 then
  begin
    msr.idO2:=0;
    if msr.idO<>aId then
    begin
      msr.Image1.Left:=xc1; msr.Image1.Top:=yc1; msr.FidO1:=aId;
      msr.Image1.Visible:=true; msr.Image1.BringToFront;
    end;
      rim:=Shema.FindrImgById(msr.idO,Shema.rImgs);
      if rim<>nil then
      begin
        if msr.UsVal then rim.AnVal:=msr.Val;
        if msr.CndMsrs.Count>0 then
        begin
          for i := 0 to msr.CndMsrs.Count-1 do
          begin
            if VarToStr(Shema.RunInterpreter(msr.CndMsrs.Items[i].par1.par.Text))='true' then Break;
          end;
        end
        else
        if msr.UsVal then rim.AnVal:=msr.Val;
      end;
  end;
      CheckRules(msr);
end;

function rImg.GoActions(rActions : TrActs; cndSh:TShiftState) : boolean;
var j,idDest : integer;
    rImD : rImg;cndEntr : boolean;
    rTmrD : rTmr; jrn : rJrn;
    s1,s2 : string;
    cDiary : TrDiary;
begin
Result:=true;
if Assigned(fGoAcnions) then fGoAcnions(rActions, cndSh);
 if rActions.Count=0 then
 begin
   Result:=false;exit;
 end;
//(1-rAcSt,2-rAcVis,3-rAcVisChd,4-rAcMove,5-rAcMoveTo,6-rAcVal,7-rAcValTo,
//        8-rAcHlp,9-rAcShwPar,10-rAcTmr,11-rAcFlt,12-rAcErr,13-rAcMeas,14-rAcBrMs,
//        15-rAcRstMs,16-,rAcQuit,17-rAcJrnl,rAcChkAsk,rAcNxAsk,rAcPrAsk,rAcSetLbl,rAcMsg,rAcStopTm,rAcRunTm);
cDiary:=Shema.CurA.Diary;
  for j := 0 to rActions.Count-1 do
  begin
//    cndEntr:=true;
    rTmrD:=nil;rImD:=nil;
    cndEntr:=ConditionEntry(rActions.Items[j].Conds);
    if cndEntr then
    begin
      idDest:=rActions.Items[j].idO;
      if rActions.Items[j].TpA=rAcTmr then
        rTmrD:= Shema.FindrTmrById(rActions.Items[j].idO)
      else
      begin
        if idDest=aId then rImD:=self
          else rImD:=Shema.FindrImgById(idDest,Shema.rImgs);
      end;
      if (rImD<>nil) or (rTmrD<>nil) or (rActions.Items[j].TpA=rAcMeas)
         or (rActions.Items[j].TpA=rAcBrMs) or (rActions.Items[j].TpA=rAcQuit)
         or (rActions.Items[j].TpA=rAcErr) then
      begin
        if cndSh = rActions.Items[j].FCndAct then
        begin
          Shema.CurrAct:=rActions.Items[j];
          if rActions.Items[j].fAsk then
            if Application.MessageBox(PAnsiChar('Вы действительно хотите выполнить '+rActions.Items[j].Name+'?'),'Внимание!',MB_YESNO)=IDNO then Exit;
          if rActions.Items[j].TpA=rAcSt then// rAcSt    1
          begin
            if not rImD.Fault then
            begin
              if rActions.Items[j].stO=-1 then
              begin
                if rImD.St<(rImD.rStats.Count-1) then rImD.St:=rImD.St+1
                else rImD.St:=0;
              end
              else if rActions.Items[j].stO=-2 then
              begin
               if rImD.St>0 then rImD.St:=rImD.St-1
               else rImD.St:=rImD.rStats.Count-1;
              end
              else rImD.St:= rActions.Items[j].stO;
              //========Journal
              if not rActions.Items[j].DsJr then
              begin
                if rActions.Items[j].Name<>'' then
                begin
                  try
                    jrn:=cDiary.AddRec(Name+'('+rActions.Items[j].Name+')',TimeToStr(Time),0,
                        rImD.Name+' - '+'('+inttostr(rImD.St)+') '+rImD.rStats.Items[rImD.St].Name,-1);
                  //    jrn.Id:=Shema.Jrnl.Jinc;
                  except
                    Application.MessageBox(PAnsiChar(IntToStr(aId)+'-'+ Name+', '+IntToStr(j)+'-'+rActions.Items[j].Name+''),'Внимание!')
                  end;
                end;
              end;
            end;
            Shema.CurImgRul:=rImD.aId;
            CheckRules(rActions.Items[j]);
          end
          else if rActions.Items[j].TpA=rAcFlt then //rAcFlt    11
          begin
            //========Journal
            if not rActions.Items[j].DsJr then
            begin
              if rActions.Items[j].Name<>'' then
              begin
                if (rImD.Fault=rActions.Items[j].Vis) and (not rImD.Fault) then
                  jrn:=cDiary.AddRec(Name+'('+rActions.Items[j].Name+')',TimeToStr(Time),0,
                        rImD.Name+' - '+' - '+'замена исправного узла!',-1)
                else
                  jrn:=cDiary.AddRec(Name+'('+rActions.Items[j].Name+')',TimeToStr(Time),0,
                        rImD.Name+' - '+' - '+'устранение неисправности.',-1);
             //   jrn.Id:=Shema.Jrnl.Jinc;
              end;
            end;
            rImD.Fault:=rActions.Items[j].Vis;
            Shema.CurImgRul:=rImD.aId;
            CheckRules(rActions.Items[j]);
          end
          else if rActions.Items[j].TpA=rAcVis then //rAcVis        2
          begin
            rImD.Vis:=rActions.Items[j].Vis;
            //========Journal
            if not rActions.Items[j].DsJr then
            begin
              if rActions.Items[j].Name<>'' then
              begin
                jrn:=cDiary.AddRec(Name+'('+rActions.Items[j].Name+')',TimeToStr(Time),0,
                        rImD.Name+' - '+'('+inttostr(rImD.St)+') '+rImD.rStats.Items[rImD.St].Name,-1);
              //  jrn.Id:=Shema.Jrnl.Jinc;
              end;
            end;
          end
          else if rActions.Items[j].TpA=rAcVisChd then //rAcVisChd   3
          begin
            rImD.VisChd:=rActions.Items[j].Vis;
            //========Journal
            if not rActions.Items[j].DsJr then
            begin
              if rActions.Items[j].Name<>'' then
              begin
                jrn:=cDiary.AddRec(Name+'('+rActions.Items[j].Name+')',TimeToStr(Time),0,
                      rImD.Name+' - '+'('+inttostr(rImD.St)+') '+rImD.rStats.Items[rImD.St].Name,-1);
              //  jrn.Id:=Shema.Jrnl.Jinc;
              end;
            end;
          end
          else if rActions.Items[j].TpA=rAcMove then //rAcMove      4
            rImD.Image.SetBounds(strtoint(rActions.Items[j].par1.par.Strings[0]),strtoint(rActions.Items[j].par1.par.Strings[1]),
                          rImD.Image.Width,rImD.Image.Height)
          else if rActions.Items[j].TpA=rAcMoveTo then //rAcMoveTo   5
            rImD.Image.SetBounds(rImD.Image.Left+strtoint(rActions.Items[j].par1.par.Strings[0]),rImD.Image.Top+ strtoint(rActions.Items[j].par1.par.Strings[1]),
                          rImD.Image.Width,rImD.Image.Height)
          else if rActions.Items[j].TpA=rAcVal then //rAcVal          6
            rImD.rVals.Items[rActions.Items[j].idv].vO:=rActions.Items[j].vO
          else if rActions.Items[j].TpA=rAcValTo then //rAcValTo      7
            rImD.rVals.Items[rActions.Items[j].idv].vO:=rImD.rVals.Items[rActions.Items[j].idv].vO+rActions.Items[j].vO
          else if rActions.Items[j].TpA=rAcTmr then //rAcTmr      10
          begin
            if rTmrD<>nil then
            begin
              rTmrD.pImg:=Self; rTmrD.curcnt:=rTmrD.Count;
              rTmrD.Tmr.Interval:=rTmrD.Intr; rTmrD.Enab:=rActions.Items[j].Vis;
            end;
          end
          else if rActions.Items[j].TpA=rAcHlp then //rAcHlp      8
          begin

          end
          else if rActions.Items[j].TpA=rAcMeas then //rAcMeas      13       rAcBrMs
          begin        //rShPlay,rShEdit,rShMeas
            if rActions.Items[j].FstO=1 then
            begin
              Shema.Mode:=rShMeas;
              Shema.CurrMsr:=rActions.Items[j].FidO;
            end
            else if rActions.Items[j].FstO=0 then
            begin
              Shema.Mode:=rShPlay;
              if Shema.CurrMsr=-1 then Continue;
              Shema.rMeass.Items[Shema.FCurrMsr].Image1.Visible:=false;
              Shema.rMeass.Items[Shema.FCurrMsr].Image2.Visible:=false;
              Shema.rMeass.Items[Shema.FCurrMsr].idO1:=0;
              Shema.rMeass.Items[Shema.FCurrMsr].idO2:=0;
              Shema.CurrMsr:=-1;
            end;
          end
          else if rActions.Items[j].TpA=rAcBrMs then //rAcBrMs      14
          begin
            if Shema.CurrMsr=-1 then Continue;
            Shema.rMeass.Items[Shema.FCurrMsr].Image1.Visible:=false;
            Shema.rMeass.Items[Shema.FCurrMsr].Image2.Visible:=false;
            Shema.FindrImgById(Shema.rMeass.Items[Shema.FCurrMsr].FidO,Shema.rImgs).AnVal:=Shema.rMeass.Items[Shema.FCurrMsr].Val;
            Shema.CurrMsr:=-1;
            Shema.Mode:=rShPlay;
          end
          else if rActions.Items[j].TpA=rAcRstMs then //rAcRstMs      15
          begin
            if Shema.CurrMsr=-1 then Continue;
            Shema.rMeass.Items[Shema.FCurrMsr].Image1.Visible:=false;
            Shema.rMeass.Items[Shema.FCurrMsr].Image2.Visible:=false;
            Shema.FindrImgById(Shema.rMeass.Items[Shema.FCurrMsr].FidO,Shema.rImgs).AnVal:=Shema.rMeass.Items[Shema.FCurrMsr].Val;
          end
          else if rActions.Items[j].TpA=rGoPas then   //rGoPas       15
          begin
            Shema.RunInterpreter(rActions.Items[j].par1.par.Text);
          end
          else if rActions.Items[j].TpA=rAcShwPar then //rAcShwPar      12
          begin
            Shema.CurImgRul:=rImD.aId;
            CheckRules(rActions.Items[j]);
          end
          else if rActions.Items[j].TpA=rAcErr then //rAcErr      12
          begin
            Application.MessageBox(PAnsiChar(rActions.Items[j].par1.par.Text),PAnsiChar(rActions.Items[j].Name));
          end
          else if rActions.Items[j].TpA=rAcChkAsk then   //rAcChkAsk
          begin
            if Shema.Asks.Count<1 then Exit;
            if Shema.CurrAsk<1 then Exit;
            ProcEvent(Self,rEChkAsk,False);
          end
          else if rActions.Items[j].TpA=rAcNxAsk then   //rAcNxAsk
          begin
            Shema.SetCurrAsk(Shema.CurrAsk+1);
            ProcEvent(Self,rENxAsk,False);
          end
          else if rActions.Items[j].TpA=rAcPrAsk then   //rAcPrAsk
          begin
            Shema.SetCurrAsk(Shema.CurrAsk-1);
            ProcEvent(Self,rEPrAsk,False);
          end
          else if rActions.Items[j].TpA=rAcVsAsk then   //rAcVsAsk
          begin
            Shema.SetVisibleCurrAsk(rActions.Items[j].Vis);
            ProcEvent(Self,rEVsAsk,False);
          end
          else if rActions.Items[j].TpA=rAcAskOK then   //rAcAskOK
          begin
            ProcEvent(Self,rEAskOK,False);
          end
          else if rActions.Items[j].TpA=rAcAskCansel then   //rAcAskCansel
          begin
            ProcEvent(Self,rEAskCansel,False);
          end
          else if rActions.Items[j].TpA=rAcQuit then   //rAcQuit       16
          begin
            Shema.TestLstEnd;
            ProcEvent(Self,rEQuit,False);
          end
          else if rActions.Items[j].TpA=rAcStopTm then   //rAcStopTm
          begin
            ProcEvent(Self,rEStopTm,False);
          end
          else if rActions.Items[j].TpA=rAcRunTm then   //rAcRunTm
          begin
            ProcEvent(Self,rERunTm,False);
          end
          else if rActions.Items[j].TpA=rAcSetLbl then   //rAcSetLbl
          begin
            rImD.Lbl.Caption:=rActions.Items[j].par1.par.Text;
            ProcEvent(Self,rESetLbl,False);
          end
          else if rActions.Items[j].TpA=rAcMsg then   //rAcMsg
          begin
          Application.MessageBox(PAnsiChar(rActions.Items[j].par1.par.Text),PAnsiChar(rActions.Items[j].Name));
            ProcEvent(Self,rEMsg,False);
          end
          else if rActions.Items[j].TpA=rAcJrnl then   //rAcJrnl       17
          begin
            //========Journal
            if not rActions.Items[j].DsJr then
            begin
              if rActions.Items[j].Name<>'' then
              begin
                s1:=Name+'('+rActions.Items[j].Name+')';
                s2:=rActions.Items[j].par1.par.Text;
                try
                  jrn:=cDiary.AddRec(s1,TimeToStr(Time),rActions.Items[j].vO, s2,-1);
                except
//                if jrn=nil then jrn:=Shema.Jrnl.Diary.AddRec(s1,TimeToStr(Time+1),rActions.Items[j].vO, s2,-1);
                end;
              //    jrn.Id:=Shema.Jrnl.Jinc;
              end;
            end;
          end;
          Shema.CurrAct:=nil;
        end;
      end;
    end;
  end;
end;

function rImg.GoMouseEv( typeEvent : TrEvType;X,Y : integer; cndSh:TShiftState) : boolean;
var i,j : integer;
    rAc : TrActs;
begin
Result:=false;
  if rEvs=nil then Exit;
  if rRcts.Count>0 then
  begin
    for i := 0 to rRcts.Count-1 do
    begin
      if (rRcts.Items[i].Coord.x<=X) and
       (rRcts.Items[i].Coord.x+rRcts.Items[i].Coord.w>=X) and
       (rRcts.Items[i].Coord.y<=Y) and
       (rRcts.Items[i].Coord.y+rRcts.Items[i].Coord.h>=Y) then
      begin
        if FrctOld<>rRcts.Items[i] then
        begin
          FrctOld:=rRcts.Items[i];
          if rRcts.Items[i].rEvs.Count>0 then
          begin
            for j := 0 to rRcts.Items[i].rEvs.Count-1 do
            begin
              if rRcts.Items[i].rEvs.Items[j].TpE=typeEvent then
              begin
                rAc := rRcts.Items[i].rEvs.Items[j].rActs;
                GoActions(rAc,cndSh);Result:=true;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function rImg.CheckRules(Sender:TObject) : Boolean;
var i : Integer; res : Boolean; jrn : rJrn;
    cDiary : TrDiary; clnm : string;
begin
clnm:=Sender.ClassName;

if clnm='rEv' then if rEv(Sender).FType=rEAskCansel then Exit;
cDiary:=Shema.CurA.Diary;
//  Shema.CurImgRul:=aId;
  for i:=0 to Shema.Rules.Count-1 do
  begin
    if not Shema.Rules[i].bfr then
    begin
      Shema.CurSndRul:=clnm;
      res:=ConditionEntry(Shema.Rules.Items[i].Conds);
      if res then
      begin
        if clnm='rImg' then
        begin
  //
        end
        else if Sender.ClassName='rStat' then
        begin
  //
        end
        else if Sender.ClassName='Cnd' then
        begin
  //
        end
        else if Sender.ClassName='rEv' then
        begin
  //
        end
        else if Sender.ClassName='rRct' then
        begin
  //
        end
        else if Sender.ClassName='rVal' then
        begin
  //
        end
        else if Sender.ClassName='rAct' then
        begin
          if not rAct(Sender).FDsJr then
          begin
            jrn:=cDiary.AddRec(Shema.Rules.Items[i].Name,TimeToStr(Time),Shema.Rules.Items[i].Mark,
               Shema.Rules.Items[i].Msg.Text+' ('+self.Name+')',Shema.Rules.Items[i].rId);
          end;
        end
        else if Sender.ClassName='TrAsk' then
        begin
  //
        end
        else if Sender.ClassName='rMsr' then
        begin
          jrn:=cDiary.AddRec(Shema.Rules.Items[i].Name,TimeToStr(Time),Shema.Rules.Items[i].Mark,
               Shema.Rules.Items[i].Msg.Text,Shema.Rules.Items[i].rId);
        end;
        Shema.CurSndRul:=clnm;
        if Shema.Rules.Items[i].rActs.Count>0 then
           GoActions(Shema.Rules.Items[i].rActs,[ssLeft]);
      end;
    end;
  end;
Shema.CurSndRul:='';
end;
function rImg.CheckRulesB(Sender:TObject) : Boolean;
var i : Integer; res : Boolean; jrn : rJrn;
    cDiary : TrDiary; clnm : string;
begin
clnm:=Sender.ClassName;

if clnm='rEv' then if rEv(Sender).FType=rEAskCansel then Exit;
Shema.CurSndRul:=clnm;
  for i:=0 to Shema.Rules.Count-1 do
  begin
    if Shema.Rules[i].bfr then
    begin
      Shema.CurSndRul:=clnm;
      res:=ConditionEntry(Shema.Rules.Items[i].Conds);
      Result:=res;
      if res then
      begin
        if clnm='rImg' then
        begin
        end
        else if Sender.ClassName='rAct' then
        begin
          if not rAct(Sender).FDsJr then
          begin
            jrn:=cDiary.AddRec(Shema.Rules.Items[i].Name,TimeToStr(Time),Shema.Rules.Items[i].Mark,
               Shema.Rules.Items[i].Msg.Text+' ('+self.Name+')',Shema.Rules.Items[i].rId);
          end;
        end
        else if Sender.ClassName='TrAsk' then
        begin
  //
        end
        else if Sender.ClassName='rMsr' then
        begin
          jrn:=cDiary.AddRec(Shema.Rules.Items[i].Name,TimeToStr(Time),Shema.Rules.Items[i].Mark,
               Shema.Rules.Items[i].Msg.Text,Shema.Rules.Items[i].rId);
        end;
          Shema.CurSndRul:=clnm;
          if Shema.Rules.Items[i].rActs.Count>0 then
           GoActions(Shema.Rules.Items[i].rActs,[ssLeft]);
      end;
    end;
  end;
Shema.CurSndRul:='';
end;

function rImg.ConditionEntry(conds : TConds) : boolean;
var i,st,cndst,cidv : integer; Res, Res1 : boolean;
    sh : TShema; rIm : rImg; cvo,vo:Double; cond : Cnd;
    retStr : string;
begin
  Result := true; Res1 :=true; cndst:=0; cidv:=-1;cvo:=0;vo:=0;st:=0;
  if conds.Count>0 then
  begin
    sh:=FShema;
    for i := 0 to conds.Count-1 do
    begin
      rIm := sh.FindrImgById(conds.Items[i].idO,sh.rImgs);
      cond:=conds.Items[i];
      Res :=false;
//  TrCndOf=(cSt,cVs,cVal,cMov,cFault,cGoPas);
      if cond.rCndOf=cVal then
      begin
        if rIm<>nil then
        begin
         cidv:= cond.rindPV; vo:=rIm.FrVals.Items[cidv].FvO;
          try cvo :=StrToFloat(cond.FrpVal)
          except cvo :=0 end;
        end;
      end
      else if cond.rCndOf=cSt then
      begin
        if rIm<>nil then
        begin
          st:=rIm.St;
          try
             if cond.rpVal='' then cndst:=0
             else cndst:=StrToInt(cond.rpVal)
           except cndst:=0
          end;
        end;
      end
      else if cond.rCndOf=cVs then
      begin
        if rIm<>nil then
        begin
          if rIm.Vis then st:=1
          else st:=0;
          try
             if cond.rpVal='' then cndst:=0
             else cndst:=StrToInt(cond.rpVal)
           except cndst:=0
          end;
        end;
      end
      else if cond.rCndOf=cGoPas then
      begin
        retStr:=UpperCase(VarToStr(Shema.RunInterpreter(cond.par1.par.Text)));
        if retStr='TRUE' then Res:=True;
      end;
//        (rEq,rNEq,rGr,rEGr,rLes,rELes)
      if rIm<>nil then
      begin
        if cond.FTp=rEq then     //rEq
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo=vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st=cndst);
          if (cond.rCndOf=cVs) then Res:=(st=cndst);
        end
        else if cond.FTp=rNEq then  //rNEq
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<>vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<>cndst);
          if (cond.rCndOf=cVs) then Res:=(st<>cndst);
        end
        else if cond.FTp=rGr then   //rGr
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<cndst);
        end
        else if cond.FTp=rEGr then   //rEGr
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<=vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<=cndst);
        end
        else if cond.FTp=rLes then   //rLes
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo>vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st>cndst);
        end
        else if cond.FTp=rELes then   //rELes
        begin
          if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo>=vo);
          if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st>=cndst);
        end;
      end;
      if Res then
        if cond.rActs.Count>0 then
         GoActions(cond.rActs,[ssLeft]);
      if cond.Nxt=rAnd then Res1:=Res1 And Res
      else if cond.Nxt=rOr then Res1:=Res1 Or Res;
    end;
    Result:=Res1;
  end;
end;

procedure rImg.MoveChld(x,y : integer);
var i,x1,y1 :integer;
begin
  FMoveChd:=true;
  if rImgs.Count=0 then exit;
  for i := 0 to rImgs.Count-1 do
  begin
    x1:=rImgs.Items[i].Image.Left;y1:=rImgs.Items[i].Image.Top;
    rImgs.Items[i].Image.SetBounds(x1+x,y1+y,rImgs.Items[i].Image.Width,rImgs.Items[i].Image.Height);
  end;
  FMoveChd:=false;
end;

procedure rImg.SetCrdCh(x,y : integer);
var i : Integer;
begin
  Coord.x:=x;Coord.y:=y;
  if rImgs.Count=0 then exit;
  for i := 0 to rImgs.Count-1 do
    rImgs.Items[i].SetCrdCh(rImgs.Items[i].Image.Left,rImgs.Items[i].Image.Top);
end;
procedure rImg.SetCoord(crd : TrCoord);
begin
  FCoord.x:=crd.x;FCoord.y:=crd.y;FCoord.h:=crd.h;FCoord.w:=crd.w;
end;
procedure rImg.Update();
var  visImg : boolean;
begin
    visImg:=false;
  if (rStats.Count>0) and (FSt<rStats.Count) then
  begin
    if rStats.Items[FSt].FPathPic<>'' then
    begin
      Image.Picture.LoadFromFile(Shema.PathPic+rStats.Items[FSt].FPathPic);
      Coord.w:=Image.Width;Coord.h:=Image.Height;
      Image.SetBounds(Coord.x,Coord.y,Image.Width,Image.Height);
          //if rStats.Items[FSt].FPathPicD<>'' then
          //  Image.Pictures.PicDown.LoadFromFile(Shema.PathPic+rStats.Items[FSt].FPathPicD);
          //if rStats.Items[FSt].FPathPicE<>'' then
          //  Image.Pictures.PicEnter.LoadFromFile(Shema.PathPic+rStats.Items[FSt].FPathPicE);
      if Vis then visImg:=true;
    end;
  end;
 if Image<>nil then Image.Visible:=visImg;
 SetAnVal(FAnVal);
end;

procedure DrawArrow(AnPr : TAnlgPrib ;Angle_Line : Double; DrawSurface: TCanvas);
var XB, YB: Integer;
begin
  DrawSurface.MoveTo(AnPr.Flx, AnPr.Fly);
  DrawSurface.Pen.Width:=AnPr.ArrW;
  DrawSurface.Pen.Color:=AnPr.ArrClr;
  XB := Round(AnPr.Flx + Cos(Angle_Line/180) * AnPr.Fln);
  YB := Round(AnPr.Fly - Sin(Angle_Line/180) * AnPr.Fln);
  if AnPr.ArrTp=0 then
    DrawSurface.LineTo(XB, YB)
  else
  begin
    DrawSurface.LineTo(XB, YB)
  end;
end;

procedure rImg.SetAnVal(Val : Double);
var rct : TRect;valarr:Double;
begin
  if TypeObj<>rIm then Exit;
  if FAnPrib=nil  then  Exit;
  FAnVal:=Val;
  if FImage=nil then exit;

  if not FImage.Visible then exit;
  if not FAnPrib.FActive then exit;
  ProcEvent(self,rEAnValCh,false);
  rct := Rect(0,0,FImage.ImgAn.Width,FImage.ImgAn.Height);
  FImage.ImgAn.Transparent:=true;
  FImage.ImgAn.Canvas.FillRect(rct);
  if AnPrib.AnVls.Max=AnPrib.AnVls.Min then exit;
  if AnPrib.AnVls.LtR then
    valarr:=AnPrib.AnVls.AngMin+Val*(AnPrib.AnVls.AngMax-AnPrib.AnVls.AngMin)/(AnPrib.AnVls.Max-AnPrib.AnVls.Min)
  else
    valarr:=AnPrib.AnVls.AngMax-Val*(AnPrib.AnVls.AngMax-AnPrib.AnVls.AngMin)/(AnPrib.AnVls.Max-AnPrib.AnVls.Min);
  DrawArrow(FAnPrib ,valarr, FImage.ImgAn.Canvas);
  FImage.ImgAn.Visible:=true;
end;
procedure rImg.SetVis(const Value: boolean);
var trans : Boolean;
begin
  FVis:=Value;
  if TypeObj=rIm then
  begin
    if Image<>nil then Image.Visible:=Value;
    if txt.Enb then Lbl.Visible:=Value;
    if AnPrib=nil then exit;
    if AnPrib.FActive then
    begin
      Image.FImgAn.Visible:=Value;
      if Value then
        SetAnVal(fAnVal);
    end;
  end
  else if TypeObj=rPn then
  begin

  end
  else if TypeObj=rLb then
  begin
     Lbl.Visible:=Value;
     Lbl.Transparent:=True;
     trans := Lbl.Transparent;
  end;
  ProcEvent(self,rEVisCh,false);
end;
procedure rImg.SetVisChd(const Value: boolean);
var i : integer;
begin
  if rImgs<>nil then
  begin
    if rImgs.Count>0 then
    begin
      for i := 0 to rImgs.Count-1 do
      begin
        rImgs.Items[i].VisChd:=Value;
      end;
    end;
  end;
  FVisChd:=Value;
  Vis:=Value;
//  ProcEvent(self,rEVisCh,false);
end;
procedure rImg.SetName(Val : string);
begin
  FName:=Val;
  if Image<>nil then Image.Hint:=Val;
  if Lbl<>nil then Lbl.Hint:=Val;
end;
procedure rImg.SetTypeObj(value : TrImgType);
var par:  TWinControl;
    own: TPersistent;
    s : string; Sh : TShema;
    trans : Boolean;
begin
  FTypeObj:=value;

  own:=Collection.Owner;
  s:=own.ClassName;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    par:=TShema(own).Parent;
    Sh:=TShema(own);
    Shema:=Sh;
    OnProcEvent:=Sh.ProcEvent;
    OnGoAcnions:=Sh.GoAcnions;
    if par<>nil then
      if (FaId=0) and not Shema.FlDeser then FaId:=Shema.Ainc;
      Parent:=par;

    if value=rIm then
    begin
      FrStats:=TrStats.Create(self,rStat);
      FrVals:=TrVals.Create(rVal);
      FrVals.MyrImg:=Self;
      FrRcts:=TrRcts.Create(rRct);
      FrRcts.MyrImg:=Self;
      FrImgs:=TrImgs.Create(self,rImg);
      FrMns:=TrMns.Create(rMn);
      FrEvs:=TrEvs.Create(rEv);
      FAnPrib:=TAnlgPrib.Create;
      FAnPrib.FAnVls:=TAnVls.Create;

      FImage:=TrImage.Create(par);
      FImage.Parent:=TWinControl(Parent);
      FImage.Visible:=false;
      FImage.FMyrImg:=Self;
      FImage.FImgAn:=TImage.Create(par);
      FImage.FImgAn.Parent:=TWinControl(Parent);
      FImage.FImgAn.Visible:=false;
      Image.Cursor:=crHandPoint;
      Image.OnClick:=Sh.ClickImg;
      Image.OnMouseDown:=Sh.MouseDown;
      Image.OnMouseMove:=Sh.MouseMove;
    end
    else if value=rLb then
    begin
      txt:=TrText.Create;
      txt.MyrImg:=Self;

      Lbl:=TrLbl.Create(par);
      Lbl.Parent:=par;
//      Lbl.Color:=Sh.Color;
      Lbl.AutoSize:=False;
      Lbl.WordWrap:=True;
      Lbl.Visible:=True;
      //Lbl.HotTrack:=Sh.SelLbl.HT;
      //Lbl.HotTrackOptions.Enabled:=Sh.SelLbl.HTEnabled;
      //
      //Lbl.HotTrackOptions.FrameColor:=Sh.SelLbl.FrColor;
      //Lbl.HotTrackOptions.FrameVisible:=Sh.SelLbl.HTFrameVisible;
      Lbl.MyrImg:=Self;
      case txt.Alg of
        0: Lbl.Alignment:=taCenter;
        1: Lbl.Alignment:=taLeftJustify;
        2: Lbl.Alignment:=taRightJustify;
         else Lbl.Alignment:=taCenter;
      end;
      Lbl.Transparent:=True;
      Lbl.OnMouseDown:=Sh.MouseDown;
      Lbl.OnMouseMove:=Sh.MouseMove;
      Lbl.OnClick:=Sh.ClickLbl;
      Lbl.OnDblClick:=Sh.DblClickLbl;
      Lbl.PopupMenu:=Sh.PopMnLb;
    end
    else if value=rLs then
    begin
      txt:=TrText.Create;
      txt.MyrImg:=Self;

      Lbl:=TrLbl.Create(par);
      Lbl.Parent:=par;
      Lbl.Transparent:=True;
      Lbl.AutoSize:=False;
      Lbl.WordWrap:=True;
      Lbl.Visible:=True;
//      Lbl.Color:=Sh.Color;
      //Lbl.HotTrack:=Sh.SelLbl.HT;
      //Lbl.HotTrackOptions.Enabled:=Sh.SelLbl.HTEnabled;
      //
      //Lbl.HotTrackOptions.FrameColor:=Sh.SelLbl.FrColor;
      //Lbl.HotTrackOptions.FrameVisible:=Sh.SelLbl.HTFrameVisible;
      Lbl.MyrImg:=Self;
      case txt.Alg of
        0: Lbl.Alignment:=taCenter;
        1: Lbl.Alignment:=taLeftJustify;
        2: Lbl.Alignment:=taRightJustify;
         else Lbl.Alignment:=taCenter;
      end;
      Lbl.OnMouseDown:=Sh.MouseDown;
      Lbl.OnMouseMove:=Sh.MouseMove;
      Lbl.OnClick:=Sh.ClickLbl;
      Lbl.OnDblClick:=Sh.DblClickLbl;
      Lbl.PopupMenu:=Sh.PopMnLb;
    end;
  end;
  Lbl.Color:=TColor($1FFFFFFF);//clNone;
  trans := Lbl.Transparent;
  ShwHnt:=True;
end;

procedure rImg.SetFault(const Value: boolean);
begin
  if not ProcEventB(self,rEFaultCh,false) then Exit;
  FFault:=Value;
  ProcEvent(self,rEFaultCh,false);
end;
procedure rImg.SetSt(const Value: Integer);
var cndEntr,visImg : boolean;
begin
  if Value=FSt then exit;
  if not ProcEventB(self,rEStCh,false) then Exit;
    visImg:=false;
    FOldSt:=FSt;
    FSt:=Value;
    cndEntr:=true;
    if (rStats.Count>0) or (FSt<rStats.Count-1) or (FSt<0) then
        cndEntr:=ConditionEntry(rStats.Items[FSt].Conds);
    if not cndEntr then
    begin
      FSt:=FOldSt; exit;
    end;
  ProcEvent(self,rEStCh,false);
  if (rStats.Count>0) and (FSt<rStats.Count) then
  begin
    if rStats.Items[FSt].FPathPic<>'' then
    begin
      Image.Picture.LoadFromFile(Shema.PathPic+ rStats.Items[FSt].FPathPic);
          //if rStats.Items[FSt].FPathPicD<>'' then
          //  Image.Pictures.PicDown.LoadFromFile(Shema.PathPic+rStats.Items[FSt].FPathPicD);
          //if rStats.Items[FSt].FPathPicE<>'' then
          //  Image.Pictures.PicEnter.LoadFromFile(Shema.PathPic+rStats.Items[FSt].FPathPicE);
      if Vis then visImg:=true;
    end;
    if rStats.Items[FSt].FrActs.Count>0 then
       GoActions(rStats.Items[FSt].FrActs,[ssLeft]);
  end;
 if Image<>nil then
 Image.Visible:=visImg;
 SetAnVal(FAnVal);
end;
procedure rImg.SetShwHnt(value : Boolean);
begin
  FShwHnt:=value;
  if Image<>nil then Image.ShowHint:=value;
  if Lbl<>nil then Lbl.ShowHint:=value;
end;

function rImg.ProcEventB(rIm : rImg;typeEvent : TrEvType; flDest: boolean) : Boolean;
var i : integer; rAc : TrActs; res : Boolean;
begin
 if Shema.FlDeser then Exit;
//  TrEvType=(rEMsDown,rEMsUp,rEMsMove,rEMsEnter,rEMsLeave,rEStCh,rEValCh,rEFaultCh,rEVisCh,rEQuit,
//        rEAnValCh,rEChkAsk,rENxAsk,rEPrAsk,rEVsAsk,rEAskOK,rEAskCansel,rESetLbl,rEBckMeas,rEMsg);
  Result:=True;
  if rEvs=nil then Exit;
  res:=True;
  if (typeEvent=rEStCh) or (typeEvent=rEValCh) or (typeEvent=rEFaultCh) then
  begin
    Shema.CurImgRul:=rIm.aId;Shema.CurTpEvnt:=typeEvent;
    Shema.CurTpEvntS:= GetEnumName(TypeInfo(TrEvType), integer(typeEvent));
    for i := 0 to rEvs.Count-1 do
    if res then res:= CheckRulesB(rEvs.Items[i]);
  end;
  if not res then Result:=False;
   Shema.CurImgRul:=rIm.aId;Shema.CurTpEvnt:=rENil;
   Shema.CurTpEvntS:= '';
end;

function rImg.ProcEvent(rIm : rImg;typeEvent : TrEvType; flDest: boolean) : Boolean;
var i : integer; rAc : TrActs; res : Boolean;
begin
//  TrEvType=(rEMsDown,rEMsUp,rEMsMove,rEMsEnter,rEMsLeave,rEStCh,rEValCh,rEFaultCh,rEVisCh,rEQuit,
//        rEAnValCh,rEChkAsk,rENxAsk,rEPrAsk,rEVsAsk,rEAskOK,rEAskCansel,rESetLbl,rEBckMeas,rEMsg,rENil);
  Result:=True;
  if Shema.FlDeser then Exit;
  if rEvs=nil then Exit;
   Shema.CurImgRul:=rIm.aId;Shema.CurTpEvnt:=typeEvent;
   Shema.CurTpEvntS:= GetEnumName(TypeInfo(TrEvType), integer(typeEvent));
  if Assigned(fProcEvent) then fProcEvent(rIm, typeEvent,flDest);
  if rEvs.Count>0 then
  begin
    for i := 0 to rEvs.Count-1 do
    begin
      if rEvs.Items[i].TpE=typeEvent then
      begin
        Shema.CurImgRul:=rIm.aId;
        rAc := rEvs.Items[i].rActs;
        GoActions(rAc,[ssLeft]);
        if not((typeEvent=rEMsDown) or (typeEvent=rEMsUp) or
        (typeEvent=rEMsMove) or (typeEvent=rEMsEnter) or
        (typeEvent=rEMsLeave)) then
        res:=CheckRules(rEvs.Items[i]);
      end;
    end;
  end;
  Shema.CurImgRul:=rIm.aId;Shema.CurTpEvnt:=rENil;
  Shema.CurTpEvntS:= '';
end;

procedure rImg.SetVx(const Value : integer);
begin
  FVx:=Value;
  if FTypeObj=rIm then
  begin
    if rVals<>nil then
    begin
      if rVals.Count>idVx then
      begin
        rVals.Items[idVx].FvO:=(Value-VxMin)*VxK;
      end;
    end;
    if TpMv=rOnlH then
    begin

    end;
  end;
end;
procedure rImg.CopyImg(rIm : rImg);
begin
   Name:=rIm.Name;
   Coord.x:=rIm.Coord.x; Coord.y:=rIm.Coord.y;
   Coord.w:=rIm.Coord.w; Coord.h:=rIm.Coord.h;
   Lck:=rIm.Lck;
   Lbl.Assign(rIm.Lbl);
   txt.Text:=rIm.txt.Text;
   txt.Font.Assign(rIm.txt.Font);
   txt.Angl:=rIm.txt.Angl;
   txt.Enb:=rIm.txt.Enb;
end;
destructor rImg.Destroy;
begin
  if Image<>nil then
  begin
    Image.ImgAn.Free;
    Image.Free;
  end;
  inherited Destroy;
end;

{ TrImgs }
destructor TrImgs.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrImgs.Add: rImg;
var par:  TWinControl;
    own: TPersistent;
    s : string; Sh : TShema;
begin
  Result := rImg(inherited Add);

    Result.FCoord:=TrCoord.Create;
    Result.FCoord.obj:=Result;
    Result.FVisChd:=true;
    Result.FVis:=true;
    Result.FLck:=true;
    Result.FrStats:=TrStats.Create(Result,rStat);
    Result.FrVals:=TrVals.Create(rVal);
    Result.FrVals.MyrImg:=Result;
    Result.FrRcts:=TrRcts.Create(rRct);
    Result.FrRcts.MyrImg:=Result;
    Result.FrImgs:=TrImgs.Create(self,rImg);
    Result.FrMns:=TrMns.Create(rMn);
    Result.FrEvs:=TrEvs.Create(rEv);

  Result.txt:=TrText.Create;
  Result.txt.MyrImg:=Result;
  own:=Result.Collection.Owner;
  while (own<>nil) and (own.ClassName<>'TShema') do
  begin
    own:=TOwnedCollection(own).Owner;
  end;
  if own<>nil then
  begin
    Sh:=TShema(own);
    Result.Shema:=Sh;
  end;
  if Sh.TypeSub=rTren then
  begin
    Result.FAnPrib:=TAnlgPrib.Create;
    Result.FAnPrib.FAnVls:=TAnVls.Create;
    Result.FAnPrib.ArrW:=2;
  end;

  if own<>nil then
  begin
    if not Sh.flDsrForRp then
    begin
      par:=TShema(own).Parent;
      Result.Parent:=par;
      Result.FImage:=TrImage.Create(par);
      Result.FImage.Height:=2;
      Result.FImage.Width:=2;
      Result.FImage.Parent:=TWinControl(Result.Parent);
      Result.FImage.Visible:=false;
      Result.FImage.FMyrImg:=Result;
      Result.Image.Cursor:=crHandPoint;
      Result.Image.OnClick:=Sh.ClickImg;
      Result.Image.OnMouseDown:=Sh.MouseDown;
      Result.Image.OnMouseUp:=Sh.MouseUp;
      Result.Image.OnMouseMove:=Sh.MouseMove;
      Result.Image.OnDblClick:=Sh.DblClick;

      Result.FImage.FImgAn:=TImage.Create(par);
      Result.FImage.FImgAn.Height:=2;
      Result.FImage.FImgAn.Width:=2;
      Result.FImage.FImgAn.Parent:=TWinControl(Result.Parent);
      Result.FImage.FImgAn.Visible:=false;
      Result.Image.ImgAn.PopupMenu:=Sh.PopMnLb;
      Result.Image.ImgAn.Cursor:=crHandPoint;
      Result.Image.ImgAn.OnClick:=Sh.ClickImg;
      Result.Image.ImgAn.OnMouseDown:=Sh.MouseDown;
      Result.Image.ImgAn.OnMouseMove:=Sh.MouseMove;

      if par<>nil then
      begin
        Result.Lbl:=TrLbl.Create(par);
        Result.Lbl.Parent:=par;
        Result.Lbl.Transparent:=True;
        Result.Lbl.AutoSize:=False;
        Result.Lbl.WordWrap:=True;
//        Result.Lbl.Color:=Sh.Color;
        //Result.Lbl.HotTrack:=Sh.SelLbl.HT;
        //Result.Lbl.HotTrackOptions.Enabled:=Sh.SelLbl.HTEnabled;

        Result.Lbl.Cursor:=crHandPoint;
        //Result.Lbl.HotTrackOptions.FrameColor:=Sh.SelLbl.FrColor;
        //Result.Lbl.HotTrackOptions.FrameVisible:=Sh.SelLbl.HTFrameVisible;
        Result.Lbl.MyrImg:=Result;
        case Result.txt.Alg of
          0: Result.Lbl.Alignment:=taCenter;
          1: Result.Lbl.Alignment:=taLeftJustify;
          2: Result.Lbl.Alignment:=taRightJustify;
           else Result.Lbl.Alignment:=taCenter;
        end;
        Result.Lbl.OnMouseDown:=Sh.MouseDown;
        Result.Lbl.OnMouseUp:=Sh.MouseUp;
        Result.Lbl.OnMouseMove:=Sh.MouseMove;
        Result.Lbl.OnClick:=Sh.ClickLbl;
        Result.Lbl.OnDblClick:=Sh.DblClickLbl;
        Result.Lbl.PopupMenu:=Sh.PopMnLb;
        Result.Lbl.Visible:=False;
      end;

      if (Result.FaId=0) and not Result.Shema.FlDeser then
        Result.FaId:=Result.Shema.Ainc;
    end;
  end;
    Result.OnProcEvent:=Sh.ProcEvent;
    Result.OnGoAcnions:=Sh.GoAcnions;
    Result.ShwHnt:=True;
end;

procedure TrImgs.Delete(Index: Integer);
begin
  if Items[Index].Coord<>nil then Items[Index].Coord.Free;
  if Items[Index].Lbl<>nil then Items[Index].Lbl.Free;
  if Items[Index].rVals<>nil then Items[Index].rVals.Free;
  if Items[Index].rRcts<>nil then Items[Index].rRcts.Free;
  if Items[Index].rMns<>nil then Items[Index].rMns.Free;
  if Items[Index].rEvs<>nil then Items[Index].rEvs.Free;

  if Items[Index].AnPrib<>nil then
  begin
    if Items[Index].AnPrib.AnVls<>nil then Items[Index].AnPrib.AnVls.Free;
    Items[Index].AnPrib.Free;
  end;
  if Items[Index].rImgs<>nil then Items[Index].rImgs.Free;
  inherited Delete(Index);
end;
function TrImgs.GetItem(Index: Integer): rImg;
begin
  Result := rImg(inherited Items[Index]);
end;
function TrImgs.Insert(Index: Integer): rImg;
begin
  Result := rImg(inherited Insert(Index));
end;
procedure TrImgs.SetItem(Index: Integer; const Value: rImg);
begin
  Items[Index].Assign(Value);
end;

{ TrJournal }
constructor TrJournal.Create(AOwner: TComponent);
begin
  Serializer:=TshXMLSerializer.Create;
  Diary := TrDiary.Create(rJrn);
//  SmplXML := TJvSimpleXml.Create(AOwner);
end;

destructor TrJournal.Destroy;
begin
  Serializer.Free;
  Diary.Free;
//  SmplXML.Free;
  inherited Destroy;
end;

function TrJournal.Jinc;
begin
  FJcnt:=FJcnt+1;
  Result := Jcnt;
end;

procedure TrJournal.DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
var j: integer;
begin
  if (AnXMLNode.NodeName = 'xml') or (AnXMLNode.NodeName = '#text') then Exit;
  for j:=0 to AnXMLNode.ChildNodes.Count-1 do begin
    SetPropertyValue(Component, AnXMLNode.ChildNodes[j]);
  end;
end;

procedure TrJournal.DeSerialize(XmlStr : string);
var tss : TStringStream;
    i: Integer;
begin
  try
    tss := TStringStream.Create(XmlStr);
    ReadXMLFile(FXMLDoc, tss);
    for i:=0 to FXMLDoc.ChildNodes.Count-1 do begin
      DeSerializeInt(FXMLDoc.ChildNodes[i],self);
    end;
  finally
    tss.Free;
  end;
end;
procedure TrJournal.SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
  {PropInfo: PPropInfo; Value: string);}
var
  PropTypeInf: PTypeInfo; PropObject,obj: TObject;
  CollectionItem: TCollectionItem;
  TypeInf: PTypeInfo; TypeData: PTypeData; PropList: PPropList;
  PropIndex,i: Integer; AName,SValue,s: string; NumProps: Word;

  function FindProperty(TagName: PChar): Integer;
  var I: Integer;
  begin
    Result := -1;
    for I := 0 to NumProps - 1 do
      if CompareStr({$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(PropList^[I]^.Name), TagName) = 0 then
      begin
        Result := I; Break;
      end;
  end;

begin
  TypeInf := Component.ClassInfo;
  AName := {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(TypeInf^.Name);
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;
  GetMem(PropList, NumProps * SizeOf(Pointer));
  GetPropInfos(TypeInf, PropList);
  s := AnXMLNode.NodeName;
  PropIndex := FindProperty(PChar(s));
  if PropIndex=-1 then exit;
  PropTypeInf := PropList^[PropIndex].PropType;
  if AnXMLNode.ChildNodes.Count>0 then
    if AnXMLNode.ChildNodes[0].NodeName = '#text' then
      SValue:=AnXMLNode.ChildNodes[0].NodeValue;//  Text;
  case PropTypeInf^.Kind of
    tkInteger, tkInt64, tkChar, tkEnumeration, tkFloat, tkString,tkAString, tkSet,
    {$IFDEF UNICODE} tkUString, {$ENDIF}
    tkWChar, tkLString, tkWString, tkVariant:
    begin
      if PropTypeInf^.Kind = tkFloat then
        if {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator = ',' then
          SValue := StringReplace(SValue, '.', {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator, [rfReplaceAll])
        else
          SValue := StringReplace(SValue, ',', {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator, [rfReplaceAll]);
      if PropTypeInf^.Kind = tkSet then
        SValue := '[' + SValue + ']';
      SetPropValue(Component, {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(PropList^[PropIndex].Name), SValue);
    end;
    tkClass:
    begin
      PropObject := GetObjectProp(Component, PropList^[PropIndex]);
      if Assigned(PropObject) then
      begin
        if PropObject is TStrings then
          TStrings(PropObject).CommaText := SValue
        else if PropObject is TStringList then
          TStringList(PropObject).CommaText := SValue
        else if PropObject is TCollection then
          begin
            for i := 0 to AnXMLNode.ChildNodes.Count - 1 do
            begin
              if PropObject is TrDiary then obj := TrDiary(PropObject).Add
              else if PropObject is TrImgs then obj := TrImgs(PropObject).Add
              else if PropObject is TrTmrs then obj := TrTmrs(PropObject).Add
              else if PropObject is TrRcts then obj := TrRcts(PropObject).Add
              else if PropObject is TrStats then obj := TrStats(PropObject).Add
              else if PropObject is TConds then obj := TConds(PropObject).Add
              else if PropObject is TrEvs then obj := TrEvs(PropObject).Add
              else if PropObject is TrMns then obj := TrMns(PropObject).Add
              else if PropObject is TrActs then obj := TrActs(PropObject).Add
              else if PropObject is TrVals then obj := TrVals(PropObject).Add
              else if PropObject is TrMRuls then obj := TrMRuls(PropObject).Add
              else if PropObject is TrMeass then obj := TrMeass(PropObject).Add
              else if PropObject is TrCndMsrs then obj := TrCndMsrs(PropObject).Add
              else if PropObject is TrAsks then obj := TrAsks(PropObject).Add
              else if PropObject is TrPages then obj := TrPages(PropObject).Add
              else if PropObject is TrItLstH then obj := TrItLstH(PropObject).Add
              else if PropObject is TrLstsHlp then obj := TrLstsHlp(PropObject).Add
              else if PropObject is TRepPack then obj := TRepPack(PropObject).Add
              else if PropObject is TrpObjAsk then obj := TrpObjAsk(PropObject).Add
              else obj := (PropObject as TCollection).Add;
              DeSerializeInt(AnXMLNode.ChildNodes[i], obj);
            end;
          end
          else DeSerializeInt(AnXMLNode, PropObject);
      end;
    end;
  end;
end;

{ TShema }
constructor TShema.Create(AOwner: TComponent);
begin
  ShowHintObj:=True;
  Serializer:=TshXMLSerializer.Create;
  rImgs := TrImgs.Create(self,rImg);
  Parent:=TWinControl(AOwner);
  Image := TImage.Create(AOwner);
  Image.Height:=5;Image.Width:=5;
  Image.Parent := Parent;
  TypeSub:=rAskTxt;
  FUnUsePicDB:=False;
  if not flDsrForRp then
  begin
    FCoord:=TrCoord.Create;
    defPrPar:= TrPropPar.Create;
    rTmrs:=TrTmrs.Create(self,rTmr);
    Rules:=TrMRuls.Create(self,rMrul);
//    SmplXML := TJvSimpleXml.Create(AOwner);
    rMeass := TrMeass.Create(self,rMsr);
    rMeass.Shema:=self;
    Color:=12632256;
    FSelLbl:=TrSelLbl.Create;
    Pages:=TrPages.Create(Self,TrPg);
    TstLstEnd:=TConds.Create(Cnd);
    Asks:=TrAsks.Create(Self ,TrAsk);
    Fragments:=TrFragments.Create(TrFragment);
    ShVls:=TrShVls.Create(rShVl);
    ShVls.FShema:=Self;
    Arrs:=TrArrays.Create(rArr);
    Recs:=TrRecords.Create(rRec);
    ShActsLd:=TrActs.Create(rAct);
    ShrPrs := TrShrPrs.Create(rShrPr);
    LstPathPic:=TrLstPathPic.Create(TrPathPic);
    LstsHlp:=TrLstsHlp.Create(rLstHlp);
    Msgs:=TrMsgs.Create(self,rMsg);
      FNumbFault :=0;
      FBallM :=-1;
      FBallP :=1.5;

      AnsTxt:= TrAnsTxt.Create();
      AnsTxt.Ans:=TStringList.Create;
  end;

end;

destructor TShema.Destroy;
var i: integer;
begin
  Serializer.Free;
  rImgs.Free;
  Image.Free;
  Coord.Free;
  defPrPar.Free;
  if Pages.Count>0 then
  begin
    for i := 0 to Pages.Count-1 do
    begin
      Pages.Items[i].Free;
    end;
  end;
  Pages.Free;
  if rTmrs.Count>0 then
  begin
    for i := 0 to rTmrs.Count-1 do
    begin
      rTmrs.Items[i].Tmr.Enabled:=false;
      rTmrs.Items[i].Tmr.Free;
    end;
  end;
  rTmrs.Free;
  Fragments.Free;
  Self.Asks.Free;
  Self.AnsTxt.Free;
  ShrPrs.Free;
  inherited Destroy;
end;

procedure TShema.Free;
//var i: integer;
begin
  if self=nil then exit;
  if rTmrs<>nil then rTmrs.Free;
  if Rules<>nil then Rules.Free;
  if Serializer<>nil then Serializer.Free;
  if rImgs<>nil then rImgs.Free;
  if Image<>nil then Image.Free;
  if Coord<>nil then Coord.Free;
  if rMeass<>nil then rMeass.Free;
  if TstLstEnd<>nil then TstLstEnd.Free;
  if Pages<>nil then Pages.Free;
//  inherited Free;
end;

procedure TShema.PicRealign(par : Boolean);
begin
  FPicCenter:=PicCenter; FPicStretch:=PicStretch;FPicProportional:=PicProportional;
  if Image=nil then Exit;
  Image.Center:=PicCenter;Image.Stretch:=PicStretch;Image.Proportional:=PicProportional;
end;
procedure TShema.SetPicP(picP : string);
begin
  FpicP:=picP;
  if Image=nil then Exit;
  PicRealign(True);
  LoadPicture(Image.Picture,PathPic + FpicP);
//  Image.Picture.LoadFromFile(PathPic + FpicP);
end;
procedure TShema.SetPic(pic : Integer);
var s : string;
begin
  if UnUsePicDB then Exit;
//  s:=FindPicture(pic,tblP);
//  if s='' then Exit;
//  Fpic:=pic;
//  picP:=s;
end;
function TShema.Ainc;
begin
  FAcnt:=FAcnt+1;
  Result := Acnt;
end;
function TShema.Tinc;
begin
  FTcnt:=FTcnt+1;
  Result := Tcnt;
end;
function TShema.Pinc;
begin
  FPcnt:=FPcnt+1;
  Result := Pcnt;
end;
function TShema.Vinc;
begin
  FVcnt:=FVcnt+1;
  Result := Vcnt;
end;
function TShema.Minc;
begin
  FMcnt:=FMcnt+1;
  Result := Mcnt;
end;

procedure TShema.SetCurrMsr(value : Integer);
begin
  FCurrMsr:=value;
if Assigned(FOnSetMeass) then FOnSetMeass(Self);
end;
procedure TShema.SetColor(const Value: TColor);
begin
  FColor:=Value;
  if Parent<>nil then TPanel(Parent).Color:= Color;
end;
procedure TShema.SetPicture(const Value: TImage);
begin
  FImage.Assign(Value);
end;

function TShema.SetCurrAsk(ind : Integer): Boolean;
var i,ind1 : Integer;ask:TrAsk;
begin
  if UseIdAsk then
   begin
     ask:=FindAsk(ind);
     if ask=nil then
     begin
       if ind>=Asks.Count then ind:=Asks.Count-1;
       if ind<0 then  ind:=0;
       ask:=Asks.Items[ind];
     end;
   end
  else
     begin
       if ind>=Asks.Count then ind:=Asks.Count-1;
       if ind<0 then  ind:=0;
       ask:=Asks.Items[ind];
     end;
  FCurrAsk:=ind;
  if PanAskI<>nil then
  begin
    TPanel(PanAskI).Color:=ask.Ask.Color1;
    TPanel(PanAskI).BevelWidth:=ask.Ask.Bvl.BvlIw;
    TPanel(PanAskI).BevelInner:=ask.Ask.Bvl.BvlI;
    TPanel(PanAskI).BorderWidth:=ask.Ask.Bvl.Border;
  end;
  if PanAskO<>nil then
  begin
//    PanAskO.SetBounds(0,0,1,1);
    PanAskO.SetBounds(ask.Ask.Crd.x,ask.Ask.Crd.y,ask.Ask.Crd.w,ask.Ask.Crd.h);
    TPanel(PanAskO).BevelWidth:=ask.Ask.Bvl.BvlOw;
    TPanel(PanAskO).BevelOuter:=ask.Ask.Bvl.BvlO;
  end;

  if PanAns<>nil then
  begin
    PanAns.SetBounds(ask.Ansver.Crd.x,ask.Ansver.Crd.y,ask.Ansver.Crd.w,ask.Ansver.Crd.h);
    //TJvgListBox(PanAns).ItemStyle.Color:=ask.Ansver.Color1;
    //TJvgListBox(PanAns).ItemSelStyle.Color:=ask.Ansver.Color2;
  end;

//  Self.
  if PanRem<>nil then
  begin
//    PanRem.SetBounds(0,0,1,1);
    PanRem.SetBounds(ask.Rem.Crd.x,ask.Rem.Crd.y,ask.Rem.Crd.w,ask.Rem.Crd.h);
    TPanel(PanRem).Color:=ask.Rem.Color1;
//    TJvPanel(PanRem).Color:=ask.Rem.Color1;
  end;
  if PanRemBack<>nil then
  begin
//    PanRemBack.SetBounds(0,0,1,1);
    PanRemBack.SetBounds(0,0,Coord.w,Coord.h);
    TPanel(PanRemBack).Color:=ask.RemColor;
//    TJvPanel(PanRemBack).Color:=ask.RemColor;
  end;
//TpSh-1
  if PanAskA<>nil then
        PanAskA.SetBounds(ask.Ansver.Crd.x,ask.Ansver.Crd.y, ask.Ansver.Crd.w,ask.Ansver.Crd.h);

  if Assigned(FSetCurrAsk) then FSetCurrAsk(ind);
  Result:=True;
end;

procedure TShema.SetVisibleCurrAsk(vis : Boolean);
begin
  if (CurrAsk>=Asks.Count) or (CurrAsk<0) then Exit;
  if PanAskO<>nil then PanAskO.Visible :=False;
  if PanAns<>nil then PanAns.Visible :=False;
  if PanRem<>nil then PanRem.Visible :=False;
  if PanAskA<>nil then PanAskA.Visible :=False;

  if Asks.Items[CurrAsk].TpSh=0 then
  begin
    if vis then
    begin
      if PanAns<>nil then PanAns.Visible :=Asks.Items[CurrAsk].Ansver.Vis;
      if PanAskO<>nil then PanAskO.Visible :=Asks.Items[CurrAsk].Ask.Vis;
      if PanRem<>nil then PanRem.Visible :=Asks.Items[CurrAsk].Rem.Vis;
      if Asks.Items[CurrAsk].RemPnlSh then
        if PanRemBack<>nil then PanRemBack.Visible:=Asks.Items[CurrAsk].Rem.Vis;
    end
    else
    begin
      if PanAskO<>nil then PanAskO.Visible :=False;
      if PanAns<>nil then PanAns.Visible :=False;
      if PanRem<>nil then PanRem.Visible :=False;
      if Asks.Items[CurrAsk].RemPnlSh then
        if PanRemBack<>nil then PanRemBack.Visible:=False;
    end;
  end
  else
  begin
    if vis then
    begin
      if PanAskA<>nil then PanAskA.Visible :=True;//Asks.Items[CurrAsk].Ask.Vis;
    end
    else if PanAskA<>nil then PanAskA.Visible :=False;
  end;
end;

procedure TShema.SetCurrPg(value : Integer);
var i,j : Integer;
  s, s1 : String;
begin
  FCurrPg:=value;
  if FlDeser then Exit;
  //Image.Picture := nil;
  //if Image.Picture.Graphic<>nil then
  //  Image.Picture.Graphic.Clear;
  //   Image.Picture.PNG.SetSize(2000,2000);

  Image.Free;
  Image:=TImage.Create(Parent);
  Image.Height:=5;Image.Width:=5;
  Image.Parent:=Parent;

  Image.SendToBack;
  if Pcnt=0 then
  begin
      try
        LoadPicture(Image.Picture,PathPic + Self.FpicP);
//        Image.Picture.LoadFromFile(PathPic + Self.FpicP);
      except
//        Image.Picture
      end;
  end
  else
  begin
    //Сначала все объекты в невидимость
    for i := 0 to rImgs.Count-1 do
    begin
      if rImgs.Items[i].VisChd then
        rImgs.Items[i].FVisChdTmp:=rImgs.Items[i].VisChd;
      rImgs.Items[i].VisChd:=False;
    end;
    for j := 0 to Pages.Count-1 do
    begin
      for i := 0 to Pages.Items[j].rImgs.Count-1 do
      begin
        if Pages.Items[j].rImgs.Items[i].VisChd then
          Pages.Items[j].rImgs.Items[i].FVisChdTmp:=Pages.Items[j].rImgs.Items[i].VisChd;
        Pages.Items[j].rImgs.Items[i].VisChd:=False;
      end;
    end;

    if FCurrPg=0 then begin
      try
        s :=Self.FPathPic;
        LoadPicture(Image.Picture,PathPic + s);
      except
//        Image.Picture
      end;
      for i := 0 to rImgs.Count-1 do
        rImgs.Items[i].VisChd:=rImgs.Items[i].FVisChdTmp;
    end
    else begin
      if Pages.Count<value then Exit;
      try
        s1 := Pages.Items[FCurrPg-1].FPathPic;
        s :=PathPic +  StringReplace(s1,'\',PathDelim,[rfReplaceAll, rfIgnoreCase]);
//        Image.Picture.Clear;
//        Image.Picture.LoadFromFile(s);
        LoadPicture(Image.Picture, s);
      except
//        Image.Picture
      end;
      //for i := 0 to Pages.Items[FCurrPg-1].rImgs.Count-1 do
      //begin
      //  Pages.Items[FCurrPg-1].rImgs.Items[i].VisChd:=True;
      //end;
    end;
  end;
//  Image.Visible:=False;
//  if FCurrPg>1 then
  Image.Visible:=true;
  LoadPicture(Image.Picture, s);
  //Image.BringToFront;
  //Image.SendToBack;
  //Image.Repaint;
  Image.AutoSize:=true;
end;

procedure TShema.SetShowHintObj(value : Boolean);
begin
    fShowHintObj:=value;
   //установка всех хинтов в схеме
end;

procedure TShema.LoadStaterAsks (par : Integer);
var i,j,k,ind : integer;
    ts{tmptxt} : TStringList;
    rpAnsT : rrpAnsvT;
begin
  if Asks=nil then Exit;
  if Asks.Count=0 then Exit;
  for i := 0 to Asks.Count-1 do
  begin
    ts := TStringList.Create;
    for j := 1 to Asks.Items[i].Ansver.Lines.Count do ts.Add(IntToStr(j));
    if par=1 then  //если вопрос загружается первый раз
    begin
      rpAnsT:=CurA.roAnsT.Add; rpAnsT.Right:=Asks.Items[i].Nrt;
      rpAnsT.Ansv.Text:= Asks.Items[i].Ansver.Lines.Text;
      rpAnsT.Bl:=Asks.Items[i].Ball; rpAnsT.DisJrn:=Asks.Items[i].DsJr;
      if rpAnsT.Ansv.Count>0 then
      for j := 0 to rpAnsT.Ansv.Count-1 do rpAnsT.ChAns.Add('0');
    rpAnsT.RndAns.Clear;
    if Asks.Items[i].Rnd then
    begin
      Randomize;
      for j:=Asks.Items[i].Ansver.Lines.Count downto 1 do
      begin
        k:=Random(j);
        rpAnsT.RndAns.Add(ts[k]);
        ts.Delete(k);
      end;
    end
    else
      for j:=1 to Asks.Items[i].Ansver.Lines.Count do
        rpAnsT.RndAns.Add(IntToStr(j));
      rpAnsT.NmO:=Asks.Items[i].Ask.Lines.Text;
    end;
  end;
end;

function TShema.LoadStaterImg(rImgs : TrImgs;par : Integer) : rImg;
var i,j,k,ind : integer;
    tmptxt : TStringList;
    rpObj : rrpObj;
begin
  Result:=nil;
  if rImgs=nil then exit;
  for i := 0 to rImgs.Count-1 do
  begin
    tmptxt := TStringList.Create;
    if rImgs.Items[i].FTypeObj=rLb then
    begin
      if par=1 then  //если вопрос загружается первый раз
      begin
        rpObj:=CurA.roAsk.Add;
        rpObj.Sl:=False; k:=0;
        rpObj.ido:=rImgs.Items[i].aId; rpObj.Right:=1;
        if rImgs.Items[i].txt<>nil then
        begin
          if rImgs.Items[i].txt.Text<>nil then
          begin
            if rImgs.Items[i].txt.Text.Count>0 then
            begin
              for j:=0 to rImgs.Items[i].txt.Text.Count-1 do
              begin
                tmptxt.CommaText:=rImgs.Items[i].txt.Text[j];
                if tmptxt.Count>4 then
                  if tmptxt[3]='0' then  //k - кол-во неправильных
                  begin
                    inc(k); rpObj.FltTxt.Add(IntToStr(j));
                  end;
              end;
            end;
            if k>0 then
            begin
              Inc(cntFlt); arrFlt[cntFlt]:=CurA.roAsk.Count-1;
              rpObj.FlUsed:=True;   //можно исп-ть для неправильных
            end;
            if rImgs.Items[i]<> nil then
              if rImgs.Items[i].txt<>nil then
                if rImgs.Items[i].txt.Text.Text<>'' then
                begin
                  try
                   rpObj.CurAnsv.CommaText:=rImgs.Items[i].txt.Text[0]   //в CurAnsv установить 0 строку
                  except
                    rpObj.CurAnsv.CommaText:='';
                  end;
                end
                else rpObj.CurAnsv.CommaText:=''
               else rpObj.CurAnsv.CommaText:=''
             else rpObj.CurAnsv.CommaText:='';
          end;
        end;
        rpObj.NFault:=k;
        rpObj.Nobj:=rImgs.Items[i].Name;
        rpObj.NmO:=rImgs.Items[i].Name;
        rpObj.N:=0;
        if ModeView=1 then
        begin
          if rImgs.Items[i].txt<>nil then
          begin
            if rImgs.Items[i].txt.ARow>=0 then rpObj.N:=rImgs.Items[i].txt.ARow
            else if rImgs.Items[i].txt.ARow=-1 then
            begin
              if rImgs.Items[i].txt.Text<>nil then
              begin
                if rImgs.Items[i].txt.Text.Count>0 then
                begin
                  Randomize;rpObj.N:=Random(rImgs.Items[i].txt.Text.Count-1);
                end;
              end;
            end
            else if rImgs.Items[i].txt.ARow=-2 then
            begin
              if rpObj.NFault>0 then
              begin
                Randomize;
                rpObj.N:=StrToInt(rpObj.FltTxt[Random(rpObj.NFault)]);
              end;
            end;
            rpObj.CurAnsv.CommaText:=rImgs.Items[i].txt.Text[rpObj.N];   //в CurAnsv установить строку
          end;
          if rpObj.CurAnsv.Count>4 then
          if rpObj.CurAnsv[3]='0' then
          begin
           rpObj.Right:=0;
          end
          else rpObj.Right:=1;
        end;
        rpObj.Ansv.Text:=rpObj.CurAnsv.Text;
        if ModeView<2 then
        begin
          rImgs.Items[i].txt.ARowCur:=rpObj.N;
        end;
      end
      else if par=2 then
      begin
        ind:=-1;
        for j:=0 to CurA.roAsk.Count-1 do
          if CurA.roAsk.Items[j].ido=rImgs.Items[i].aId then
          begin
           ind:=j; Break;
          end;
        if ind>-1 then
        begin
          if rImgs.Items[i].txt<>nil then
          begin
            rImgs.Items[i].txt.ARow:=CurA.roAsk.Items[ind].N;
//            if CurA.roAsk.Items[ind].Sl then rImgs.Items[i].Lbl.FrameColor:=clRed
//            else rImgs.Items[i].Lbl.FrameColor:=clNone;
          end;
          rImgs.Items[i].Lbl.FlMyAnsv:= CurA.roAsk.Items[ind].FlMyAn;
          rImgs.Items[i].Lbl.MyAns:= CurA.roAsk.Items[ind].MyAns;
        end;
      end;
    end;
    tmptxt.Free;
    Result:=LoadStaterImg(rImgs.Items[i].rImgs,par);
    if Result<>nil then exit;
  end;
end;

procedure TShema.LoadState();
var i, j,par,k,indF,indI,nf : integer; s : string;
    img : rImg; arrTmp : array[1..1000] of Integer;
begin
  if RepAll=nil then RepAll:=TRepAll.Create(Self.Parent);
  if CurA=nil then CurA:=RepAll.RepPack.Add;//rRepAsk.Create();
  if (Self.FTypeSub<>rAskRect) and (Self.FTypeSub<>rAskTxt) and (Self.FTypeSub<>rTren) then Exit;
  if not CurA.FlLoad then
  begin
    CurA.BallM:=BallM; CurA.BallP:=BallP;
    if CurA.roAsk.Count=0 then CurA.roAsk:=TrpObjAsk.Create(rrpObj);
    SetLength(arrFlt,1000);
    cntFlt:=0;
    par:=1;
    LoadStaterAsks(par);
    img:=LoadStaterImg(rImgs,par);
    for j:=0 to Pages.Count-1 do
    begin
      img:=LoadStaterImg(Pages.Items[j].rImgs,par);
    end;
    SetLength(arrFlt,cntFlt);   //возможных полей для выбора ошибок
    if ModeView=2 then
    begin
      if NumbFault>0 then
      begin
        Randomize; k:=cntFlt-1;
        for i:=1 to k do arrTmp[i]:=arrFlt[i];
        if k<NumbFault then nf:=k
        else nf:=NumbFault;
        for i:=1 to nf do
        begin
          indF:=Random(k)+1;indI:=arrTmp[indF];
          img:=FindrImg(CurA.roAsk.Items[indI].ido);
          img.txt.ARowCur:=CurA.roAsk.Items[indI].N;
          CurA.roAsk.Items[indI].N:=StrToInt(CurA.roAsk.Items[indI].FltTxt[Random(CurA.roAsk.Items[indI].NFault)]);
          s:=img.txt.FText[CurA.roAsk.Items[indI].N];
          CurA.roAsk.Items[indI].CurAnsv.CommaText:=s;
          CurA.roAsk.Items[indI].NmO:=img.Name;
          CurA.roAsk.Items[indI].Ansv.Text:=CurA.roAsk.Items[indI].CurAnsv.Text;
          CurA.roAsk.Items[indI].Bl:=img.Shema.BallM;
          CurA.roAsk.Items[indI].Right:=0;
          Dec(k);
          for j:=indF to k do arrTmp[j]:=arrTmp[j+1];    //сдвигаем
        end;
      end;
    end;
  end
  else
  begin
    par:=2;
    img:=LoadStaterImg(rImgs,par);
    for j:=0 to Pages.Count-1 do
    begin
      img:=LoadStaterImg(Pages.Items[j].rImgs,par);
    end;
  end;
end;

function TShema.FindrImgById(id : integer; rImgs : TrImgs) : rImg;
var i : integer;
begin
  Result:=nil;
  if rImgs=nil then exit;
  for i := 0 to rImgs.Count-1 do
  begin
    if rImgs.Items[i].FaId=id then
    begin
      Result:=rImgs.Items[i]; exit;
    end
    else
     Result:=FindrImgById(id,rImgs.Items[i].rImgs);
     if Result<>nil then exit;
  end;
end;

function TShema.FindrImg(id : integer) : rImg;
var i,j : integer;
begin
  for i := 0 to rImgs.Count-1 do
  begin
    if rImgs.Items[i].FaId=id then
    begin
      Result:=rImgs.Items[i];
      exit;
    end
    else
     Result:=FindrImgById(id,rImgs.Items[i].rImgs);
     if Result<>nil then exit;
  end;
  for j:=0 to Pages.Count-1 do
  begin
    for i := 0 to Pages.Items[j].rImgs.Count-1 do
    begin
      if Pages.Items[j].rImgs.Items[i].FaId=id then
      begin
        Result:=Pages.Items[j].rImgs.Items[i];
        exit;
      end
      else
       Result:=FindrImgById(id,Pages.Items[j].rImgs.Items[i].rImgs);
       if Result<>nil then exit;
    end;
  end;
  Result:=nil;
end;
function TShema.FindrMsg(id : integer) : rMsg;
var i : integer;
begin
  Result:=nil;
  for i := 0 to Msgs.Count-1 do
  begin
    if Msgs.Items[i].FmId=id then
    begin
      Result:=Msgs.Items[i]; exit;
    end;
  end;
end;
function TShema.FindShrPr(id : integer) : rShrPr;
var i : integer;
begin
  Result:=nil;
  for i := 0 to ShrPrs.Count-1 do
  begin
    if ShrPrs.Items[i].FId=id then
    begin
      Result:=ShrPrs.Items[i]; exit;
    end;
  end;
end;
function TShema.FindAsk(id : integer) : TrAsk;
var i : integer;
begin
  Result:=nil;
  for i := 0 to Asks.Count-1 do
  begin
    if Asks.Items[i].FId=id then
    begin
      Result:=Asks.Items[i]; exit;
    end;
  end;
end;

//______________
procedure TShema.rImg2Lst(lst : TList; rIms : TrImgs);
var i : integer;
begin
  if rImgs=nil then exit;
  for i := 0 to rIms.Count-1 do
  begin
    lst.Add(rIms.Items[i]);
    rImg2Lst(lst,rIms.Items[i].rImgs);
  end;
end;

function TShema.rImgs2Lst() : TList;
var i,j : integer;
  lst : TList;
begin
  lst:=TList.Create;
  for i := 0 to rImgs.Count-1 do
  begin
    lst.Add(rImgs.Items[i]);
    rImg2Lst(lst,rImgs.Items[i].rImgs);
  end;

  for j:=0 to Pages.Count-1 do
  begin
    for i := 0 to Pages.Items[j].rImgs.Count-1 do
    begin
      lst.Add(Pages.Items[j].rImgs.Items[i]);
      rImg2Lst(lst,Pages.Items[j].rImgs.Items[i].rImgs);
    end;
  end;
  Result:=lst;
end;

function TShema.FindrVlsById(id : integer) : rShVl;
var i : integer;
begin
  for i := 0 to ShVls.Count-1 do
  begin
    if ShVls.Items[i].Idv=id then
    begin
      Result:=ShVls.Items[i];
      exit;
    end;
  end;
  Result:=nil;
end;

function TShema.FindrArrsById(id : integer) : rArr;
var i : integer;
begin
  Result:=nil; if Arrs.Count=0 then Exit;
  for i := 0 to Arrs.Count-1 do
  begin
    if Arrs.Items[i].id=id then begin Result:=Arrs.Items[i]; exit; end;
  end;
end;
function TShema.FindrRecsById(id : integer) : rRec;
var i : integer;
begin
  Result:=nil; if Recs.Count=0 then Exit;
  for i := 0 to Recs.Count-1 do
  begin
    if Recs.Items[i].id=id then begin Result:=Recs.Items[i]; exit; end;
  end;
end;

function TShema.FindrTmrById(id : integer) : rTmr;
var i : integer;
begin
  for i := 0 to rTmrs.Count-1 do
  begin
    if rTmrs.Items[i].FtId=id then
    begin
      Result:=rTmrs.Items[i];
      exit;
    end;
  end;
  Result:=nil;
end;

//function TShema.FindPicture(id : integer; tblPic : TDataSet) : string;
//var s : string;
//    rPath:TrPathPic;
//begin
//  if tblPic=nil then Exit;
//  rPath:=nil;
//  if LstPathPic.Count>0 then rPath:=LstPathPic.FindPic(id);
//  s:='';
//  if rPath=nil then
//  begin
//    if id>0 then
//    begin
//      tblPic.Filter:='Id='+inttostr(id);
//      tblPic.Active:=true;
//      if tblPic.FindFirst then
//      begin
//        s:=tblPic.FieldByName('Path').AsString;
//      end;
//      tblPic.Active:=false;
//    end;
//    if s='' then rPath:=LstPathPic.AddPath(id,'',False)//00.png
//      else rPath:=LstPathPic.AddPath(id,s,False);
//  end;
//  s:=rPath.PathPic;
// Result:=s;
//end;

//function TShema.FindPictureP(id : integer; tblPic : TDataSet;path:string) : string;
//var s : string;
//    rPath:TrPathPic;
//begin
//  if tblPic=nil then Exit;
//  rPath:=nil;
//  if LstPathPic.Count>0 then rPath:=LstPathPic.FindPic(id);
//  s:='';
//  if rPath=nil then
//  begin
//    if id>0 then
//    begin
//      tblPic.Filter:='Id='+inttostr(id);
//      tblPic.Active:=true;
//      if tblPic.FindFirst then
//      begin
//        s:=tblPic.FieldByName('Path').AsString;
//      end;
//      tblPic.Active:=false;
//    end;
//    if s='' then
//    begin
//      rPath:=LstPathPic.FindPath(path);
//      if rPath = nil then rPath:=LstPathPic.AddPath(id,'',False);//00.png
//    end
//    else rPath:=LstPathPic.AddPath(id,s,False);
//  end;
//  s:=rPath.PathPic;
// Result:=s;
//end;

//procedure TShema.UpdateRimg(rImgs : TrImgs; Wpar : TWinControl; tblPic : TDataSet; flEd:bool);
procedure TShema.UpdateRimg(rImgs : TrImgs; Wpar : TWinControl; flEd:Boolean);
var s : string;
    i,j,cnt : integer;
    rpObj : rrpObj;
    Lbl : TrLbl;
    Img : rImg;
    trans : Boolean;
begin
  if rImgs=nil then exit;
  if rImgs.Count=0 then exit;
  cnt:=rImgs.Count-1;
  for i := 0 to cnt do begin
    Img := rImgs.Items[i];
    Img.Shema:=self;
    Img.FModeEdit:=flEd;

    Img.OnProcEvent:=ProcEvent;
    Img.OnGoAcnions:=GoAcnions;

    Img.Image.SetBounds(Img.Coord.x,Img.Coord.y,Img.Coord.w,Img.Coord.h);
    Img.x0:=Img.Coord.x-Img.FVx;
    //rIm ++++++++++++++++++++
    if Img.TypeObj=rIm then begin
      if Img.Image<>nil then begin
        Img.Image.PopupMenu:=PopMnIm;
        Img.Image.Hint:=Img.Name;
        Img.Image.ShowHint:=true;
        Img.Image.Cursor:=crHandPoint;
        Img.Image.OnClick:=ClickImg;
        Img.Image.OnMouseDown:=MouseDown;
        Img.Image.OnMouseMove:=MouseMove;
      end;
      if Img.rStats<>nil then begin
        if Img.rStats.Count>0 then begin
//          for j := 0 to Img.rStats.Count-1 do
//          begin
//            s:=FindPicture(Img.rStats.Items[j].pic,tblPic);
//            if s<>'' then
//             Img.rStats.Items[j].FPathPic:=s;//PathPic+s
//            s:=FindPicture(Img.rStats.Items[j].picD,tblPic);
//            if s<>'' then Img.rStats.Items[j].FPathPicD:=s;//PathPic+s
//            s:=FindPicture(Img.rStats.Items[j].picE,tblPic);
//            if s<>'' then Img.rStats.Items[j].FPathPicE:=s;//PathPic+s
//          end;

          Img.Image.SetBounds(Img.Coord.x,Img.Coord.y,Img.Coord.w,Img.Coord.h);
          Img.x0:=Img.Coord.x-Img.FVx;
          if Img.FAnPrib <> nil then
          Img.Image.FImgAn.SetBounds(Img.Image.Left+Img.FAnPrib.x,
             Img.Image.Top+Img.FAnPrib.y, Img.FAnPrib.w,Img.FAnPrib.h);
          Img.Image.Visible:=false;
          Img.Image.ImgAn.Visible:=false;
          if Img.St<Img.rStats.Count then
          begin
            if Img.rStats.Items[Img.St].FPathPic<>'' then
            begin
              LoadPicture(Img.Image.Picture,PathPic+Img.rStats.Items[Img.St].FPathPic);
              Img.Image.Transparent:=true;
              if Img.Vis then Img.Image.Visible:=true;
              Img.Image.AutoSize:=true;
              //if Img.rStats.Items[Img.St].FPathPicD<>'' then
              //  LoadPicture(Img.Image.Pictures.PicDown, PathPic+Img.rStats.Items[Img.St].FPathPicD);
              //if Img.rStats.Items[Img.St].FPathPicE<>'' then
              //  LoadPicture(Img.Image.Pictures.PicEnter,PathPic+Img.rStats.Items[Img.St].FPathPicE);
            end;
          end;
        end
        else
        begin
          Img.Image.SetBounds(Img.Coord.x,Img.Coord.y,Img.Coord.w,Img.Coord.h);
          Img.Image.Visible:=False;
        end;
      end;
      Img.SetAnVal(Img.AnVal);

      if Img.txt.Enb then
      begin
        Img.Lbl.Visible:= Img.Vis;
        Img.Lbl.Tag:=Img.aId;
        Img.Lbl.OnMouseDown:=MouseDown;
        Img.Lbl.OnMouseMove:=MouseMove;
        Img.Lbl.OnClick:=ClickLbl;
        Img.Lbl.OnDblClick:=DblClickLbl;
        Img.Lbl.AutoSize:=Img.txt.FAutoSize;
          case Img.txt.Alg of
            0: Img.Lbl.Alignment:=taCenter;
            1: Img.Lbl.Alignment:=taLeftJustify;
            2: Img.Lbl.Alignment:=taRightJustify;
             else Img.Lbl.Alignment:=taCenter;
          end;
        Img.Lbl.Font.Assign(Img.txt.Font);
        Img.Lbl.SetBounds(Img.Coord.x+Img.txt.x,Img.Coord.y+Img.txt.y,Img.Coord.w,Img.Coord.h);
        Img.Lbl.Caption:=Img.txt.Text.Text;
//        Img.Lbl.HotTrack:=False;
        Img.Lbl.PopupMenu:=PopMnIm;
        if Self.Mode=rShPlay then
         Img.Lbl.ShowHint:=ShowHintObj
        else Img.Lbl.ShowHint:=True;
        if Img.Lbl.ShowHint then Img.Lbl.Hint:=Img.Name;
      end;

    end
    //rLb ++++++++++++++++++++
    else if Img.TypeObj=rLb then begin
      if Img.Image<>nil then
         Img.Image.Visible:=False;
      Lbl := Img.Lbl;
      Lbl.Transparent:=True;
      Lbl.Tag:=Img.aId;
      Lbl.OnMouseDown:=MouseDown;
      Lbl.OnMouseUp:=MouseUp;
      Lbl.OnMouseMove:=MouseMove;
      Lbl.OnClick:=ClickLbl;
      Lbl.OnDblClick:=DblClickLbl;
        case Img.txt.Alg of
          0: Lbl.Alignment:=taCenter;
          1: Lbl.Alignment:=taLeftJustify;
          2: Lbl.Alignment:=taRightJustify;
           else Lbl.Alignment:=taCenter;
        end;

      if Img.txt.Cnt=0 then begin
        Img.txt.CurText.Add('1');
        if Img.txt.Text.Count>0 then begin
          if Img.txt.Text[0]='Выбрано верное поле' then
            Img.txt.Text[0]:=' ';
          Img.txt.CurText.Add(Img.txt.Text[0])
        end
        else Img.txt.CurText.Add(' ');
        Img.txt.CurText.Add('Выбрано верное поле');
        Img.txt.CurText.Add('1');
        Img.txt.CurText.Add('1');
        Img.txt.CurText.Add('-1');
        Img.txt.CurText.Add('');
        Img.txt.CurText.Add('');
        Img.txt.CurText.Add('');
        Img.txt.CurText.Add('');
        Img.txt.FText.Text:=Img.txt.CurText.CommaText;
        Img.txt.Cnt:=Img.txt.FText.Count;
      end
      else begin
        if Img.txt.FText.Count>0 then begin
          //выбор
          if ModeView=1 then begin
            rpObj:=CurA.roAsk.GetItemIDO(Img.FaId);
            if rpObj=nil then begin
              rpObj:=CurA.roAsk.Add;
              rpObj.ido:=Img.FaId;
              Img.FName:=Img.FName;
            end;
            if Img.txt.FText.Count>1 then begin
               rpObj.FlUsed:=True;rpObj.NFault:=Img.txt.FText.Count-1;
            end;
            if Img.txt.ARow>=0 then begin
              rpObj.N:=Img.txt.ARow;
              Img.txt.CurText.CommaText:=Img.txt.FText[rpObj.N];
              rpObj.NFault:=0;
            end
            else if  Img.txt.ARow=-1 then begin
              Randomize;
              rpObj.N:=Random(Img.txt.FText.Count-1);
              Img.txt.CurText.CommaText:=Img.txt.FText[rpObj.N];
              rpObj.NFault:=Img.txt.FText.Count-1; rpObj.FlUsed:=True;
            end
            else if  Img.txt.ARow=-2 then //случайно из неправильных
            begin
              if Img.txt.FText.Count<2 then rpObj.N:=0
              else begin
                Randomize;
                rpObj.N:=Random(Img.txt.FText.Count-2);
                rpObj.NFault:=Img.txt.FText.Count-2; rpObj.FlUsed:=True;
              end;
               Img.txt.CurText.CommaText:=Img.txt.FText[0];
            end;
          end
          else if ModeView=2 then begin
          //исправление
          Img.txt.CurText.CommaText:=Img.txt.FText[0];
          if Img.txt.CurText.Count>4 then
          begin
            if (Img.txt.CurText[3]='1') and (Img.txt.CurText[2]='') then
            Img.txt.CurText[2]:='Выбрано верное поле';
            Img.txt.FText[0]:=Img.txt.CurText.CommaText;
          end;
            if Img.txt.FText.Count>1 then
            begin
              if Img.txt.ARow>0 then
                Img.txt.CurText.CommaText:=Img.txt.FText[Img.txt.ARow]
              else
                Img.txt.CurText.CommaText:=Img.txt.FText[0];
            end;

            if Img.txt.CurText.Count>1 then
              Lbl.Caption:=Img.txt.CurText[1]
              else Lbl.Caption:='';
          end;
        end;
      end;

      Lbl.AutoSize:=False;
      Lbl.SetBounds(Img.Coord.x,Img.Coord.y,Img.Coord.w,Img.Coord.h);
//      Lbl.Transparent:=True;
      Lbl.Font.Assign(Img.txt.Font);
//      Img.Lbl.HotTrackFont.Assign(Img.txt.Font);
      if Self.Mode=rShPlay then
       Lbl.ShowHint:=ShowHintObj
      else Img.Lbl.ShowHint:=True;
      if Lbl.ShowHint then Img.Lbl.Hint:=Img.Name;
      Lbl.Transparent:=False;
      Lbl.Transparent:=True;
      Lbl.Color:=TColor($1FFFFFFF);//clNone;
      trans := Lbl.Transparent;
    end;
//    UpdateRimg(Img.rImgs,Wpar,tblPic,flEd);
      if Img.rImgs.Count>0 then
        UpdateRimg(Img.rImgs,Wpar,flEd);
  end;
end;

procedure TShema.UpdateImg(Wpar : TWinControl; flEd:Boolean);
var s, ppic : string;
    i : integer;
    img : rImg;
begin
  LstPathPic.Clear;
//  tblP := tblPic;
  Image:=TImage.Create(Wpar);
  Image.Height:=5;Image.Width:=5;
  Image.Parent:=Wpar;
  Parent.SetBounds(Coord.x,Coord.y,Coord.w,Coord.h);
  TPanel(Wpar).Color:= Color;
  ppic:=PathPic;
//  if not UnUsePicDB then
//  begin
//    s:=FindPicture(pic,tblPic); if s<>'' then picP:=s;
//  end;
//  UpdateRimg(rImgs,Wpar,tblPic,flEd);
  UpdateRimg(rImgs,Wpar,flEd);
  for i := 0 to Pcnt-1 do
  begin
    Parent.SetBounds(Pages.Items[i].Coord.x,Pages.Items[i].Coord.y,Pages.Items[i].Coord.w,Pages.Items[i].Coord.h);
//    if not UnUsePicDB then
//    begin
//      s:=FindPicture(Pages.Items[i].pic,tblPic); if s<>'' then Pages.Items[i].PathPic:=s;
//    end;
//    UpdateRimg(Pages.Items[i].rImgs,Wpar,tblPic,flEd);
    UpdateRimg(Pages.Items[i].rImgs,Wpar,flEd);
  end;
  SetCurrPg(CurrPg);
  for i := 0 to rMeass.Count-1 do begin
    with rMeass.Items[i] do begin
//      if not UnUsePicDB then
//      begin
//        s:=FindPicture(Fpic1,tblPic);picP1:=s;
//        s:=FindPicture(Fpic2,tblPic);picP2:=s;
//      end;

      if picP1<>'' then begin
        Image1.Picture.LoadFromFile(PathPic+picP1);
        Image1.Transparent:=true; Image1.AutoSize:=true;
      end;
      if picP2<>'' then begin
        Image2.Picture.LoadFromFile(PathPic+picP2);
        Image2.Transparent:=true; Image2.AutoSize:=true;
      end;
      Image1.Visible:=false; Image2.Visible:=false;
    end;
  end;
  CurrMsr:=-1;
end;

procedure TShema.UpdRimg(rImgs : TrImgs);
var s : string;
    i,j,cnt : integer;
    rpObj : rrpObj;
begin
  if rImgs=nil then exit;
  if rImgs.Count=0 then exit;
  cnt:=rImgs.Count-1;
  for i := 0 to cnt do
  begin
    rImgs.Items[i].Shema:=self;
    rImgs.Items[i].FModeEdit:=False;
    rImgs.Items[i].x0:=rImgs.Items[i].Coord.x-rImgs.Items[i].FVx;
    if rImgs.Items[i].TypeObj=rIm then
    begin
      if rImgs.Items[i].rStats<>nil then
      begin
        if rImgs.Items[i].rStats.Count>0 then
        begin
          for j := 0 to rImgs.Items[i].rStats.Count-1 do
          begin
//            s:=FindPictureP(rImgs.Items[i].rStats.Items[j].pic,tblPic,rImgs.Items[i].rStats.Items[j].FPathPic);
//            if s<>'' then rImgs.Items[i].rStats.Items[j].FPathPic:=s;//PathPic+s
//            s:=FindPictureP(rImgs.Items[i].rStats.Items[j].picD,tblPic,rImgs.Items[i].rStats.Items[j].FPathPicD);
//            if s<>'' then rImgs.Items[i].rStats.Items[j].FPathPicD:=s;//PathPic+s
//            s:=FindPictureP(rImgs.Items[i].rStats.Items[j].picE,tblPic,rImgs.Items[i].rStats.Items[j].FPathPicE);
//            if s<>'' then rImgs.Items[i].rStats.Items[j].FPathPicE:=s;//PathPic+s
            rImgs.Items[i].rStats.Items[j].pic:=0;
            rImgs.Items[i].rStats.Items[j].picD:=0;
            rImgs.Items[i].rStats.Items[j].picE:=0;
          end;
          rImgs.Items[i].x0:=rImgs.Items[i].Coord.x-rImgs.Items[i].FVx;
        end;
      end;
    end
    else if rImgs.Items[i].TypeObj=rLb then
    begin
    end;
//    UpdRimg(rImgs.Items[i].rImgs,tblPic);
    UpdRimg(rImgs.Items[i].rImgs);
  end;
end;

//procedure TShema.UpdImg(tblPic : TDataSet);
//var s, ppic : string;
//    i : integer;
//    img : rImg;
//begin
//  LstPathPic.Clear;
//  tblP := tblPic;
//  ppic:=PathPic;
//  if not UnUsePicDB then
//  begin
//    s:=FindPictureP(pic,tblPic,picP); if s<>'' then picP:=s;
//    pic:=0;
//  end;
//  UpdRimg(rImgs,tblPic);
//  for i := 0 to Pcnt-1 do
//  begin
//    if not UnUsePicDB then
//    begin
//      s:=FindPictureP(Pages.Items[i].pic,tblPic,Pages.Items[i].PathPic); if s<>'' then Pages.Items[i].PathPic:=s;
//      Pages.Items[i].pic:=0;
//    end;
//    UpdRimg(Pages.Items[i].rImgs,tblPic);
//  end;
//  for i := 0 to rMeass.Count-1 do
//  begin
//    with rMeass.Items[i] do
//    begin
//      if not UnUsePicDB then
//      begin
//        s:=FindPictureP(Fpic1,tblPic,picP1); if s<>'' then picP1:=s;
//        Fpic1:=0;
//        s:=FindPictureP(Fpic2,tblPic,picP2); if s<>'' then picP2:=s;
//        Fpic2:=0;
//      end;
//    end;
//  end;
//  CurrMsr:=-1;
//end;

procedure TShema.SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
var
  PropTypeInf: PTypeInfo;
  PropObject,obj: TObject;
  TypeInf: PTypeInfo;
  TypeData: PTypeData;
  PropIndex: Integer;
  AName,SValue,s: string;
  PropList: PPropList;
  NumProps: Word;
  i : integer;
 //{ Поиск у объекта свойства с заданным именем }
  function FindProperty(TagName: PChar): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to NumProps - 1 do
      if CompareStr({$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(PropList^[I]^.Name), TagName) = 0 then
      begin
        Result := I;
        Break;
      end;
  end;

begin
  TypeInf := Component.ClassInfo;
  AName := {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(TypeInf^.Name);
  TypeData := GetTypeData(TypeInf);
  NumProps := TypeData^.PropCount;
  GetMem(PropList, NumProps * SizeOf(Pointer));
  GetPropInfos(TypeInf, PropList);
  s := AnXMLNode.NodeName;
  PropIndex := FindProperty(PChar(s));
  if PropIndex=-1 then exit;
  PropTypeInf := PropList^[PropIndex].PropType;
  if AnXMLNode.ChildNodes.Count>0 then
    if AnXMLNode.ChildNodes[0].NodeName = '#text' then
      SValue:=AnXMLNode.ChildNodes[0].NodeValue;//  Text;
  case PropTypeInf^.Kind of
    tkInteger, tkInt64, tkChar, tkEnumeration, tkFloat, tkString,tkAString, tkSet,
    {$IFDEF UNICODE} tkUString, {$ENDIF}
    tkWChar, tkLString, tkWString, tkVariant:
    begin
        //{ Замена разделителя на системный }
      if PropTypeInf^.Kind = tkFloat then
        if {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator = ',' then
          SValue := StringReplace(SValue, '.', {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator, [rfReplaceAll])
        else
          SValue := StringReplace(SValue, ',', {$IFDEF RTL220_UP}FormatSettings.{$ENDIF RTL220_UP}DecimalSeparator, [rfReplaceAll]);
        //{ Для корректного преобразования парсером tkSet нужны угловые скобки }
      if PropTypeInf^.Kind = tkSet then
        SValue := '[' + SValue + ']';
      SetPropValue(Component, {$IFDEF SUPPORTS_UNICODE}UTF8ToString{$ENDIF SUPPORTS_UNICODE}(PropList^[PropIndex].Name), SValue);
    end;
    tkClass:
    begin
      PropObject := GetObjectProp(Component, PropList^[PropIndex]);
      if Assigned(PropObject) then
      begin
        if PropObject is TStrings then
          TStrings(PropObject).CommaText := SValue
        else if PropObject is TStringList then
          TStringList(PropObject).CommaText := SValue
        else if PropObject is TCollection then
          begin
            for i := 0 to AnXMLNode.ChildNodes.Count - 1 do
            begin
              if PropObject is TrImgs then obj := TrImgs(PropObject).Add
              else if PropObject is TrTmrs then obj := TrTmrs(PropObject).Add
              else if PropObject is TrRcts then obj := TrRcts(PropObject).Add
              else if PropObject is TrStats then obj := TrStats(PropObject).Add
              else if PropObject is TConds then obj := TConds(PropObject).Add
              else if PropObject is TrEvs then obj := TrEvs(PropObject).Add
              else if PropObject is TrMns then obj := TrMns(PropObject).Add
              else if PropObject is TrActs then obj := TrActs(PropObject).Add
              else if PropObject is TrVals then obj := TrVals(PropObject).Add
              else if PropObject is TrMRuls then obj := TrMRuls(PropObject).Add
              else if PropObject is TrMeass then obj := TrMeass(PropObject).Add
              else if PropObject is TrMsgs then obj := TrMsgs(PropObject).Add
              else if PropObject is TrArrays then obj := TrArrays(PropObject).Add
              else if PropObject is TrRecords then obj := TrRecords(PropObject).Add
              else if PropObject is TrCndMsrs then obj := TrCndMsrs(PropObject).Add
              else if PropObject is TrAsks then obj := TrAsks(PropObject).Add
              else if PropObject is TrPages then obj := TrPages(PropObject).Add
              else if PropObject is TrItLstH then obj := TrItLstH(PropObject).Add
              else if PropObject is TrLstsHlp then obj := TrLstsHlp(PropObject).Add
              else if PropObject is TrFragments then obj := TrFragments(PropObject).Add
              else if PropObject is TrGrRects then obj := TrGrRects(PropObject).Add
              else if PropObject is TrVRects then obj := TrVRects(PropObject).Add
              else if PropObject is TrShrPrs then obj := TrShrPrs(PropObject).Add
              else obj := (PropObject as TCollection).Add;
              DeSerializeInt(AnXMLNode.ChildNodes[i], obj);
            end;
          end
          else DeSerializeInt(AnXMLNode, PropObject);
      end;
    end;
  end;
end;

procedure TShema.DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
var j: integer;
begin
  if (AnXMLNode.NodeName = 'xml') or (AnXMLNode.NodeName = '#text') then Exit;
  for j:=0 to AnXMLNode.ChildNodes.Count-1 do begin
    try
      SetPropertyValue(Component, AnXMLNode.ChildNodes[j]);
    except
      Application.MessageBox(PAnsiChar('Версия ПО устарела, отсутствует '+AnXMLNode.ChildNodes[j].NodeName+'='+AnXMLNode.ChildNodes[j].ChildNodes[0].NodeValue+'.'),'Внимание!',MB_OK);
    end;
  end;
end;

procedure TShema.DeSerialize(XmlStr : string);
var tss : TStringStream;
    i: Integer;
begin
  FlDeser:=true;
  try
    tss := TStringStream.Create(XmlStr);
    ReadXMLFile(FXMLDoc, tss);
    for i:=0 to FXMLDoc.ChildNodes.Count-1 do begin
      DeSerializeInt(FXMLDoc.ChildNodes[i],self);
    end;
  finally
    tss.Free;
    FlDeser:=false;
  end;
end;
function TShema.MsgBox(Caption : string;txt : string; tp,alg : Integer): Integer;
begin
  if FFormMsg=nil then Exit;
  //TFrmMsg(FFormMsg).Capt:=Caption;
  //TFrmMsg(FFormMsg).txt:=txt;
  //TFrmMsg(FFormMsg).alg:=alg;
  //
  //Result:=TFrmMsg(FFormMsg).ShowModal;
end;

procedure TShema.SetRec(IndRec,col,row:Integer;val : string);
var  rc : rRec;c,r,i : Integer;
   strlst : TStringList;
begin
     rc:=FindrRecsById(IndRec);
     if rc=nil then Exit;
     c:=col-1;if c<0 then Exit; r:=row-1;if r<0 then Exit;
     if rc.cnt<=r then Exit;
     if rc.cnt>rc.Arr.Count then
     begin
      for i:= rc.Arr.Count to rc.cnt-1 do rc.Arr.Add('');
//      rc.cnt:=rc.Arr.Count;
     end;

     if rc.cnt>r then
     if rc.Arr.Count<=r then
     begin
      for i:= rc.Arr.Count-1 to r do rc.Arr.Add('');
//      rc.cnt:=r+1;
     end;

     strlst:= TStringList.Create;
     strlst.CommaText:=rc.Arr[r];
     if strlst.Count<=c then
      for i:= strlst.Count-1 to c do strlst.Add('');

      strlst[c]:=val;
     rc.Arr[r]:=strlst.CommaText;
     strlst.Free;
end;

{Функции калькулятора}
procedure TShema.InterpreterGetValue(Sender: TObject; Identifier: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var  id1,id2,str :string; rim : rImg; x,y,i,c,r : Integer; flFind : Boolean;
  msg : rMsg;tmr:rTmr; ar : rArr; rc : rRec; ShrPr : rShrPr;
  strlst,strlst1 : TStringList; mx:Integer;
begin
  Identifier := UpperCase(Identifier);
  if Length(Identifier)>2 then
  begin
    id1:=Copy(Identifier,0,2);id2:=Copy(Identifier,3,Length(Identifier)-2);
  end
  else id1:= Identifier;
  Done := true;  {VERY IMPORTANT!}
//function
//FLTALL()
//INOB(idO1,idO2)
//INOBE(idO1,idO2)
//GETVAL(ind,vo)
//GETNVAL(ind,name)
//GETUVAL(ind,unt)
//GETARR(IndArr,ind,value)
//CURASK()
//RIGHTANS() CHECKANS()
//CHECKANSI()
//GETASKCURASK()
//GETREC(IndRec,col,row)
//GETRECCOL(IndRec)
//GETRECROW(IndRec)
//RECCNT
//CURTPEVNT  CRSNDRL
//RNDI(max)
//GETFLT(ind),//GETVS(ind)
//OB  ST  IR  VS  VC  AV  FT  VX  AS AF  SV  TM  MS
//
//procedure
//SETTM(idt,Intr,Count,Enab)
//SETVAL(aId,idv,vo), SETNVAL(aId,idv,vo), SETUVAL(aId,idv,vo)
//SETARR(IndArr,ind,value)
//SETVC(aId,VisChd)
//SETFT(aId,Fault)
//MOVE(aId,x,y), MOVETO(aId,dx,dy)
//VAL(aId,vId,vO), VALTO(aId,vId,dvO)
//SETLBLI(aId,value), SETLBL(aId,value)
//SETASK(curask)
//SETVASK(visible)
//VISREM(vi)VISASK(vi) VISANS(vi)
//SETJRNL(arg1,time,arg2,arg3)
//SETJRASK(ask)
//SETJRASKP(+ask)
//MESBOX(Cap,Txt) MSGBOX(Nmsg) MsgBox1(Cap,Txt,Tp,Alg)
//SETREC(IndRec,col,row,val)
//SHRPR(idShrPr)
//STOPTM(); RUNTM;
//QUIT
  if Identifier='FLTALL' then    //fault
  begin
      Value := False;
  end
  else { FUNCTION INOB! }
  if (Identifier='INOB') then   //
   begin
      if CurrMsr<>-1 then
      begin
        if (Args.Count=2) and VarIsNumeric(Args.Values[0]) and VarIsNumeric(Args.Values[1]) then
            begin
             Value := ((rMeass.Items[CurrMsr].idO1=Args.Values[0]) and (rMeass.Items[CurrMsr].idO2=Args.Values[1])) or
             ((rMeass.Items[CurrMsr].idO2=Args.Values[0]) and (rMeass.Items[CurrMsr].idO1=Args.Values[1]));
         end else
         begin
            JvInterpreterError(ieIncompatibleTypes,0); // or  ieNotEnoughParams, or others.
            Done := false;
         end;
      end
      else
       Value := False;
   end
  else if (Identifier='INOBE') then
   begin
    if CurrMsr<>-1 then
    begin
      Value:=False; Exit;
    end;
           if (rMeass.Items[CurrMsr].idO1=rMeass.Items[CurrMsr].idO2) and (rMeass.Items[CurrMsr].idO1<>0) then Value :=True
              else Value:=False;
   end
  else if (Identifier='SETTM') then
   begin
     tmr:= FindrTmrById(Args.Values[0]);
     if tmr=nil then Exit;
     tmr.Intr:=Args.Values[1];
//     tmr.Tmr.Interval:=Args.Values[1];
     tmr.Count:=Args.Values[2];
     tmr.Enab:=Args.Values[3];
   end
  else if (Identifier='SETVLO') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     for i := 0 to rim.rVals.Count-1 do
     begin
       if rim.rVals.Items[i].FIdv=Args.Values[1] then
         rim.rVals.Items[i].vO:=Args.Values[2];
     end;
   end
  else if (Identifier='SETNVLO') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     for i := 0 to rim.rVals.Count-1 do
     begin
       if rim.rVals.Items[i].FIdv=Args.Values[1] then
         rim.rVals.Items[i].Name:=Args.Values[2];
     end;
   end
  else if (Identifier='SETUVLO') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     for i := 0 to rim.rVals.Count-1 do
     begin
       if rim.rVals.Items[i].FIdv=Args.Values[1] then
         rim.rVals.Items[i].unt:=Args.Values[2];
     end;
   end
  else if (Identifier='GETVAL') then
   begin
     Value :=0;
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     Value := rim.rVals.Items[Args.Values[1]].vO;
   end
  else if (Identifier='GETNVAL') then
   begin
     Value :='';
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     Value := rim.rVals.Items[Args.Values[1]].Name;
   end
  else if (Identifier='GETUVAL') then
   begin
     Value :='';
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     Value := rim.rVals.Items[Args.Values[1]].unt;
   end
  else if (Identifier='SETVAL') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     rim.rVals.Items[Args.Values[1]].vO:=Args.Values[2];
   end
  else if (Identifier='SETNVAL') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     rim.rVals.Items[Args.Values[1]].Name:=Args.Values[2];
   end
  else if (Identifier='SETUVAL') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim=nil then Exit;
     rim.rVals.Items[Args.Values[1]].unt:=Args.Values[2];
   end
  else if (Identifier='GETARR') then
   begin
     Value :=0;   //GETARR(IndArr,ind,value,type) //int,str,flt,bool
     ar:=FindrArrsById(Args.Values[0]);
     if ar=nil then Exit;
      if ar.Arr.Count>Args.Values[1] then
        if Args.Values[2]=0 then  //int
         Value := StrToInt(ar.Arr.Strings[Args.Values[1]])
        else if Args.Values[2]=1 then  //float
         Value := StrToFloat(ar.Arr.Strings[Args.Values[1]])
        else if Args.Values[2]=2 then  //strint
         Value := ar.Arr.Strings[Args.Values[1]]
        else if Args.Values[2]=4 then  //bool
         Value := StrToBool(ar.Arr.Strings[Args.Values[1]]);
   end
//SETREC(IndRec,col,row,val)
  else if (Identifier='SETREC') then
   begin
     SetRec(Args.Values[0],Args.Values[1],Args.Values[2],Args.Values[3]);
   end
  else if (Identifier='GETREC') then
   begin
     Value :=0;   //GETREC(IndRec,col,row)
     rc:=FindrRecsById(Args.Values[0]);
     if rc=nil then Exit;
     c:=Args.Values[1]-1;
     if c<0 then Exit;
      r:=Args.Values[2]-1;
      if r<0 then Exit;
     if rc.cnt<=r then Exit;
     if rc.Arr.Count<=r then Exit;
     strlst:= TStringList.Create;
     strlst.CommaText:=rc.Arr[r];
     if strlst.Count>c then str:=strlst.Strings[c]
     else begin strlst.Free; Exit; end;
    //i,s,f,b
     if c<rc.TFld.Count then
     begin
       try
         if rc.TFld[c]='i' then
         begin if str<>'' then Value:=StrToInt(str) else Value:=0; end
         else if rc.TFld[c]='f' then
         begin if str<>'' then Value:=StrToFloat(str) else Value:=0; end
         else if rc.TFld[c]='b' then
         begin if str<>'' then Value:=StrToBool(str) else Value:=False; end
         else Value := str;
       except  end;
     end
     else Value := str;
     strlst.Free;
   end
  else if (Identifier='GETRECCOL') then
   begin   //GETRECCOL(IndRec)
     Value :=0;
     rc:=FindrRecsById(Args.Values[0]);
     if rc=nil then Exit;
     if rc.nf>0 then  Value :=rc.nf else Value:=rc.TFld.Count;
   end
  else if (Identifier='GETRECROW') then
   begin   //GETRECROW(IndRec)
     Value :=0;
     rc:=FindrRecsById(Args.Values[0]);
     if rc=nil then Exit;
     if rc.cnt>0 then Value :=rc.cnt else Value:=rc.Arr.Count;
   end
  else if (Identifier='RECCNT') then Value :=Recs.Count  //RECCNT
  else if (Identifier='CRSNDRL') then Value :=CurSndRul  //RECCNT
  else if (Identifier='SETARR') then
   begin   //SETARR(IndArr,ind,value)
     Arrs.Items[Args.Values[0]].Arr.Strings[Args.Values[1]]:=Args.Values[2];
   end
  else if (Identifier='SETVC') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.VisChd:=Args.Values[1];
   end
  else if (Identifier='SETFT') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.Fault:=Args.Values[1];
   end
  else if (Identifier='SETST') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.St:=Args.Values[1];
   end
  else if (Identifier='GETST') then
   begin
     Value:=0;
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     Value:=rim.St;
   end
  else if (Identifier='GETFLT') then
   begin
     Value:=False;
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     Value:=rim.Fault;
   end
  else if (Identifier='GETVS') then
   begin
     Value:=False;
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     Value:=rim.Vis;
   end
  else if (Identifier='GETNAME') then
   begin
     Value:=0;
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     Value:=rim.Name;
   end
  else if (Identifier='MOVE') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.Image.SetBounds(Args.Values[1],Args.Values[2],rim.Image.Width,rim.Image.Height);
   end
  else if (Identifier='MOVETO') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     x:=rim.Image.Left+Args.Values[1];y:=rim.Image.Top+Args.Values[2];
     rim.Image.SetBounds(x,y,rim.Image.Width,rim.Image.Height);
   end
  else if (Identifier='VAL') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.rVals.Items[Args.Values[1]].FvO:=Args.Values[2];
   end
  else if (Identifier='VALTO') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.rVals.Items[Args.Values[1]].FvO:=Args.Values[2]+rim.rVals.Items[Args.Values[1]].FvO;
   end
  else if (Identifier='SETLBLI') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.Lbl.Caption:=inttostr(Args.Values[1]);
   end
  else if (Identifier='SETLBL') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
     rim.Lbl.Caption:=Args.Values[1];
   end
  else if (Identifier='SETASK') then SetCurrAsk(Args.Values[0])
  else if (Identifier='CURASK') then Value:=CurrAsk
  else if (Identifier='GETASKCURASK') then Value:=Asks[CurrAsk].Ask.Lines.Text
  else if (Identifier='CURTPEVNT') then Value:=CurTpEvntS
  else if (Identifier='SETVASKOK') then
   begin
     rim:=FindrImgById(Args.Values[0],rImgs);
     if rim = nil then Exit;
      if rImgs.Count>0 then
       rim.ProcEvent(rim,rEAskOK,False);
   end
  else if (Identifier='SETVASK') then
   begin
     if Args.Values[0]=0 then SetVisibleCurrAsk(False)
     else SetVisibleCurrAsk(True);
   end
  else if (Identifier='VISREM') then
   begin
     if Args.Values[0]=0 then Asks.Items[CurrAsk].Rem.Vis:=False
     else Asks.Items[CurrAsk].Rem.Vis:=True;
   end
  else if (Identifier='VISASK') then
   begin
     if Args.Values[0]=0 then Asks.Items[CurrAsk].Ask.Vis:=False
     else Asks.Items[CurrAsk].Ask.Vis:=True;
   end
  else if (Identifier='RIGHTANS') then
   begin
     Value:=True;
     for i :=0  to Asks[CurrAsk].fNright-1 do
     begin
       if Asks[CurrAsk].ChAns[i] ='0' then Value:=False;
     end;
     for i :=Asks[CurrAsk].fNright  to Asks[CurrAsk].ChAns.Count-1 do
     begin
       if Asks[CurrAsk].ChAns[i] ='1' then Value:=False;
     end;
   end
  else if (Identifier='CHECKANS') then
   begin
     Value:='';
     for i :=0  to Asks[CurrAsk].ChAns.Count-1 do
     begin
       if Asks[CurrAsk].ChAns[i] ='1' then
       if Args.Values[0]=0 then
        Value:=Value+Asks[CurrAsk].Ansver.Lines[i]+chr(13)
       else
        Value:=Value+'- '+Asks[CurrAsk].Ansver.Lines[i]+'<br>';
     end;
   end
  else if (Identifier='CHECKANSI') then
   begin
     Value:=-1;
     for i :=0  to Asks[CurrAsk].ChAns.Count-1 do
     begin
       if Asks[CurrAsk].ChAns[i] ='1' then
       begin
        Value:=i; Exit;
       end;
     end;
   end
  else if (Identifier='SETJRNL') then
   begin
     CurA.Diary.AddRec(Args.Values[0],TimeToStr(Time),Args.Values[1], Args.Values[2],Args.Values[3]);
   end
  else if (Identifier='SETJRASK') then
   begin
     CurA.Ask:=Args.Values[0];
   end
  else if (Identifier='SETJRASKP') then
   begin
     CurA.Ask:=CurA.Ask+Args.Values[0];
   end
  else if (Identifier='MESBOX') then
   begin
     Application.MessageBox(PAnsiChar(string(Args.Values[0])),PAnsiChar(string(Args.Values[1])));
   end
  else if (Identifier='MSGBOX') then
   begin
     msg:=FindrMsg(Args.Values[0]);
     if msg=nil then Exit;
     Self.MsgBox(msg.FName,msg.FTxt,msg.FTp,msg.Alg);
   end
  else if (Identifier='MSGBOX1') then
   begin
     Self.MsgBox(Args.Values[0],Args.Values[1],0,0);
   end
  else if (Identifier='SHRPR') then
   begin
     ShrPr:=FindShrPr(Args.Values[0]);
     if ShrPr=nil then Exit;
     RunInterpreter(ShrPr.Proc.par.Text);
   end
  else if (Identifier='RND') then
   begin
     Randomize;
     mx:=Args.Values[0];
      Value:=Random(mx);
  end
  else if (Identifier='STOPTM') then
   begin
       ProcEvent(nil,rEStopTm,False);
  end
  else if (Identifier='RUNTM') then
   begin
       ProcEvent(nil,rERunTm,False);
  end
  else if (Identifier='QUIT') then
   begin
       ProcEvent(nil,rEQuit,False);
  end

  else

//===================идентификатор
  if id1='OB' then Value:=1
  else if id1='ST' then   //state
    Value := FindrImgById(StrToInt(id2),rImgs).St
  else if id1='IR' then    //visible
    Value := CurImgRul
  else if id1='VS' then    //visible
    Value := FindrImgById(StrToInt(id2),rImgs).Vis
  else if id1='AV' then Value :=FindrImgById(StrToInt(id2),rImgs).AnVal
  else if id1='FT' then    //fault
    Value := FindrImgById(StrToInt(id2),rImgs).Fault
  else if id1='VX' then    //value
    Value := FindrImgById(StrToInt(id2),rImgs).Vx
  else if id1='AS' then    //Action state
  begin
    Value:=False;
    if CurrAct<>nil then
      if CurrAct.TpA=rAcSt then
        if StrToInt(id2)= CurrAct.idO then  Value:=True;
  end
  else if id1='AF' then    //Action fault
  begin
    Value:=False;
    if CurrAct<>nil then
      if CurrAct.TpA=rAcFlt then
        if StrToInt(id2)= CurrAct.idO then  Value:=True;
  end
  else if id1='SV' then    //значение схемы
    Value:= FindrVlsById(StrToInt(id2)).vO
  else if id1='TM' then Value:= FindrTmrById(StrToInt(id2)).Enab
  else if id1='MS' then    //измерение
  begin
    Value:=False;
     if StrToInt(id2)= CurrMsr then  Value:=True;
  end
  else if (Identifier='VISANS') then
   begin
     if Args.Values[0]=0 then Asks.Items[CurrAsk].Ansver.Vis:=False
     else Asks.Items[CurrAsk].Ansver.Vis:=True;
   end;
end;

procedure TShema.InterpreterSetValue(Sender: TObject; Identifier: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  id1,id2:string;
  tmr : rTmr;
  rim : rImg;
  rsv : rShVl;
begin
  Identifier := UpperCase(Identifier);
  if Length(Identifier)>2 then
  begin
    id1:=Copy(Identifier,0,2);id2:=Copy(Identifier,3,Length(Identifier)-2);
    rim:=FindrImgById(StrToInt(id2),rImgs);
  end;
  if VarIsNumeric(Value) then begin
    if id1='AV' then
    begin
      if rim=nil then Exit;
      rim.AnVal := StrToFloat(VarToStr(Value));
        Done := true;
    end
    else
    if id1='SV' then    //значение схемы
    begin
      rsv:=FindrVlsById(StrToInt(id2));
      if rsv=nil then Exit;
      rsv.vO:=StrToFloat(VarToStr(Value));
        Done := true;
    end
    else
    if id1='ST' then
    begin
      if rim=nil then Exit;
      rim.St := StrToInt(VarToStr(Value));
        Done := true;
    end
    else
    if id1='FT' then    //fault
    begin
      if rim=nil then Exit;
      rim.Fault := StrToBool(VarToStr(Value));
        Done := true;
    end
    else if id1='VS' then
    begin
      if rim=nil then Exit;
      rim.Vis := StrToBool(VarToStr(Value));
        Done := true;
    end
    else if id1='VC' then
    begin
      if rim=nil then Exit;
      rim.VisChd := StrToBool(VarToStr(Value));
        Done := true;
    end
    else if id1='TM' then
    begin
      tmr:=FindrTmrById(StrToInt(id2));
      if tmr=nil then Exit;
      tmr.curcnt:=tmr.Count;
      tmr.Tmr.Interval:=tmr.Intr;
      tmr.Enab := StrToBool(VarToStr(Value));
        Done := true;
    end
    else Done :=True;
  end;
end;

function TShema.TestLstEnd() : boolean;
//  TrCndType=(rEq,rNEq,rGr,rEGr,rLes,rELes);
//  TrCndsType=(rAnd,rOr,rNone);
//  TrTypeSub=(rBook,rAskTxt,rAskRect,rOuter,rTren,rVideo);
//  TrCndOf=(cSt,cVal,cMov,cFault);
//  TTypeRule=(Tpr1,Tpr2);
var i,st,cndst,cidv : integer; Res, Res1 : boolean;
    {sh : TShema; }rIm : rImg; cvo,vo:Double; cond : Cnd;
begin
  Result := true; Res1 :=true; cndst:=0; cidv:=-1;cvo:=0;vo:=0;st:=0;
  if TstLstEnd.Count=0 then Exit;

  if TstLstEnd.Count>0 then
  begin
//    sh:=FShema;
    for i := 0 to TstLstEnd.Count-1 do
    begin
      rIm := FindrImgById(TstLstEnd.Items[i].idO, rImgs);
      cond:=TstLstEnd.Items[i];
      Res :=false;
//  TrCndOf=(cSt,cVal,cMov,cFault);
      if cond.rCndOf=cVal then
      begin
       cidv:= cond.rindPV; vo:=rIm.FrVals.Items[cidv].FvO;
        try
          cvo :=StrToFloat(cond.FrpVal)
        except
          cvo :=0
        end;
      end
      else if cond.rCndOf=cSt then
      begin
        st:=rIm.St;
        try
           if cond.rpVal='' then cndst:=0
           else cndst:=StrToInt(cond.rpVal)
         except cndst:=0
        end;
      end
      else if cond.rCndOf=cGoPas then
      begin
{        Interpreter.Pas.Text:=cond.par1.par.Text;
        Interpreter.Run;
        if UpperCase(VarToStr(Interpreter.VResult))='TRUE' then Res:=True;
}        if UpperCase(VarToStr(RunInterpreter(cond.par1.par.Text)))='TRUE' then Res:=True;
      end;
//        (rEq,rNEq,rGr,rEGr,rLes,rELes)
      if cond.FTp=rEq then     //rEq
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo=vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st=cndst);
      end
      else if cond.FTp=rNEq then  //rNEq
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<>vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<>cndst);
      end
      else if cond.FTp=rGr then   //rGr
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<cndst);
      end
      else if cond.FTp=rEGr then   //rEGr
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo<=vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st<=cndst);
      end
      else if cond.FTp=rLes then   //rLes
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo>vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st>cndst);
      end
      else if cond.FTp=rELes then   //rELes
      begin
        if (cond.rCndOf=cVal) and (cidv<rIm.FrVals.Count) then Res:=(cvo>=vo);
        if (cond.rCndOf=cSt) and (cndst<rIm.FrStats.Count) then Res:=(st>=cndst);
      end;
      if Res then
        if cond.rActs.Count>0 then
         rIm.GoActions(cond.rActs,[ssLeft]);
      if cond.Nxt=rAnd then Res1:=Res1 And Res
      else if cond.Nxt=rOr then Res1:=Res1 Or Res;
    end;
    Result:=Res1;
  end;
end;

function TShema.RunInterpreter(pas : string): Variant;
var interp : TJvInterpreterProgram;
begin
  Result:=false;
  if pas='' then Exit;
  interp := TJvInterpreterProgram.Create(TComponent(Parent));
  interp.OnGetValue:= InterpreterGetValue;
  interp.OnSetValue:= InterpreterSetValue;
  interp.Pas.Text:=pas;
  interp.Run;
  Result:= interp.VResult;
  interp.Free;
end;
function TShema.SendMsgMainForm(Msg: Cardinal; WParam: WParam; LParam: LParam ): Boolean;
begin
  Result:=false;
  if hFormMain=0 then Exit;
  SendMessage(hFormMain, Msg, WParam, LParam);
  Result:=True;
end;

function TShema.PostMsgMainForm(Msg: Cardinal; WParam: WParam; LParam: LParam ): Boolean;
begin
  Result:=false;
  if hFormMain=0 then Exit;
  PostMessage(hFormMain, Msg, WParam, LParam);
  Result:=True;
end;

end.

