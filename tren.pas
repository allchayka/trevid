unit tren;

interface
uses
  Classes, TypInfo, SysUtils, StdCtrls, DOM, XMLRead, XMLSer;

//======================================================

type
  TAnsvTxt = class(TObject)
  id : integer;
  idV : integer;
  idApp : integer;
  Seq : integer;
  idGrR : integer;
  right : Boolean;
  Ansver : string;
  Rem : string;
  ball : single;
  Group : Boolean;
  check : TCheckBoxState;
  constructor Create();
  end;

type
  TMark = class(TObject)
  NFragment : Integer;
  pos : integer;
  posFr : int64;
  x,y : integer;
  Name : string;
  ball : single;
  ListAnsTxt : TList;
  flMyAns : boolean;
  MyAns : string;
  BallMyAns : single;
  constructor Create();
  end;

//======================================================
Type
  TrAnsNFnd = class(TCollectionItem)
  private
  fidv : Integer;
  fNFragment : Integer;
  fflCh : Boolean;
  fAns,fRem : string;
  public
  published
    property idv: Integer read fidv write fidv default 0;
    property NFragment: Integer read fNFragment write fNFragment default 0;
    property flCh: Boolean read fflCh write fflCh default False;
    property Ans: string read fAns write fAns;
    property Rem: string read fRem write fRem;
  end;

Type
  TrLstNFnd = class(TCollection)
  private
    function GetItem(Index: Integer): TrAnsNFnd;
    procedure SetItem(Index: Integer; const Value: TrAnsNFnd);
  public
    destructor Destroy; override;
    function  Add: TrAnsNFnd;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAnsNFnd;
    property Items[Index: Integer]: TrAnsNFnd read GetItem  write SetItem; default;
  end;
//======================================================
Type
  TrAnsvTxt = class(TCollectionItem)
  private
  fidV, fidApp, fSeq, fidGrR : integer;
  fright, fGroup : Boolean;
  fAnsver, fRem : string;
  fball : single;
  fcheck : TCheckBoxState;
  public
  published
    property idV: Integer read fidV write fidV;
    property idApp: Integer read fidApp write fidApp default 0;
    property Seq: Integer read fSeq write fSeq default 0;
    property idGrR: Integer read fidGrR write fidGrR default 0;
    property right: boolean read fright write fright default False;
    property Ansver: string read fAnsver write fAnsver;
    property Rem: string read fRem write fRem;
    property ball: single read fball write fball;
    property Group: boolean read fGroup write fGroup default False;
    property check : TCheckBoxState read fcheck write fcheck default cbUnchecked;
  end;

Type
  TrLstAnsTxt = class(TCollection)
  private
    function GetItem(Index: Integer): TrAnsvTxt;
    procedure SetItem(Index: Integer; const Value: TrAnsvTxt);
  public
    destructor Destroy; override;
    function  Add: TrAnsvTxt;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAnsvTxt;
    property Items[Index: Integer]: TrAnsvTxt read GetItem  write SetItem; default;
  end;
//======================================================
Type
  TrMark = class(TCollectionItem)
  private
    fNFragment : Integer;
    fpos : integer;
    fposFr : int64;
    fx,fy : integer;
    fName : string;
    fball : single;
    fListAnsTxt : TrLstAnsTxt;
    fflMyAns : boolean;
    fMyAns : string;
    fBallMyAns : single;
  public
  published
    property NFragment: Integer read fNFragment write fNFragment default 0;
    property pos: Integer read fpos write fpos default 0;
    property posFr: int64 read fposFr write fposFr default 0;
    property x: Integer read fx write fx default 0;
    property y: Integer read fy write fy default 0;
    property Name: string read fName write fName;
    property ball: single read fball write fball;
    property ListAnsTxt : TrLstAnsTxt read fListAnsTxt write fListAnsTxt;
    property flMyAns: boolean read fflMyAns write fflMyAns default False;
    property MyAns: string read fMyAns write fMyAns;
    property BallMyAns: single read fBallMyAns write fBallMyAns;
  end;
Type
  TrLstMrk = class(TCollection)
  private
    function GetItem(Index: Integer): TrMark;
    procedure SetItem(Index: Integer; const Value: TrMark);
  public
    destructor Destroy; override;
    function  Add: TrMark;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrMark;
    property Items[Index: Integer]: TrMark read GetItem  write SetItem; default;
    function FindForPos(frag: Integer; psFr: int64): TrMark;
  end;
//======================================================
Type
  TrAnsvInRep = class(TCollectionItem)
  private
  private
  fidV, fidApp, fSeq, fidGrR : integer;
  fright, fflMyAns, fGroup : Boolean;
  fAnsver, fRem : string;
  fball : single;
  fpos : integer;
  public
    property idV: Integer read fidV write fidV;
    property idApp: Integer read fidApp write fidApp;
    property Seq: Integer read fSeq write fSeq;
    property idGrR: Integer read fidGrR write fidGrR;
    property right: boolean read fright write fright;
    property Ansver: string read fAnsver write fAnsver;
    property Rem: string read fRem write fRem;
    property ball: single read fball write fball;
    property Group: boolean read fGroup write fGroup;
    property pos: Integer read fpos write fpos default 0;
    property flMyAns: boolean read fflMyAns write fflMyAns default False;
  published
  end;
Type
  TrLstAnsvInRep = class(TCollection)
  private
    function GetItem(Index: Integer): TrAnsvInRep;
    procedure SetItem(Index: Integer; const Value: TrAnsvInRep);
  public
    destructor Destroy; override;
    function  Add: TrAnsvInRep;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAnsvInRep;
    property Items[Index: Integer]: TrAnsvInRep read GetItem  write SetItem; default;
  end;
//======================================================
Type
  rrpObj = class(TCollectionItem)
  private
//    fid : Integer;
    fN : Integer; //??? ????????
    fSl,fFlMyAnsv : Boolean;
    fBl : Extended; // ?????????? ???
    fRight :Integer;
    fNmO : string;
    fido : integer;
    fAnsv : TStringList;  //??????? ??????????? ?????
    fMyAns : string;
  public
    FlUsed : Boolean; //??? ?????????????
    FltTxt : TStringList;  //?????? ??????? ???????????? ???????
    CurAnsv : TStringList;  //??????? ?????
    Nobj : string;
    NFault : Integer;
  published
    property N: Integer read fN write fN default 0;
    property Sl: Boolean read fSl write fSl default False;
    property Bl: Extended read fBl write fBl;
    property Right: Integer read fRight write fRight default 1;
    property ido : Integer read fido write fido default 0;
    property NmO: string read fNmO write fNmO;
    property FlMyAn: Boolean read fFlMyAnsv write fFlMyAnsv default False;
    property MyAns: string read fMyAns write fMyAns;
    property Ansv: TStringList read fAnsv write fAnsv;
  end;

  TrpObjAsk = class(TCollection)
  private
    function GetItem(Index: Integer): rrpObj;
    procedure SetItem(Index: Integer; const Value: rrpObj);
  public
    destructor Destroy; override;
    function  Add: rrpObj;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rrpObj;
    property Items[Index: Integer]: rrpObj read GetItem  write SetItem; default;
    function GetItemIDO(idobj: Integer): rrpObj;
  end;

//======================================================
type
  TrStrLst  = class(TPersistent)
  private
  public
  published
  end;

Type
  rArr = class(TCollectionItem)
  private
    fName : string;
    fid : integer;
    fArr : TStringList;  //??????
    fNArr : TStringList;  //?????? ????
  public
  published
    property id : Integer read fid write fid default 0;
    property Name: string read fName write fName;
    property Arr: TStringList read fArr write fArr;
    property NArr: TStringList read fNArr write fNArr;
  end;

  TrArrays = class(TCollection)
  private
    function GetItem(Index: Integer): rArr;
    procedure SetItem(Index: Integer; const Value: rArr);
  public
    destructor Destroy; override;
    function  Add: rArr;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rArr;
    property Items[Index: Integer]: rArr read GetItem  write SetItem; default;
  end;

//======================================================
Type
  rRec = class(TCollectionItem)
  private
    fName : string;
    fid : integer;
    fnf : integer;
    fcnt : integer;
    fArr : TStringList;  //??????
    fTFld : TStringList;  //???? ?????
    fNFld : TStringList;  //????? ?????
    fRem : TStringList;  //????????
  public
  published
    property id : Integer read fid write fid default 0;
    property nf : Integer read fnf write fnf default 0;
    property cnt : Integer read fcnt write fcnt default 0;
    property Name: string read fName write fName;
    property NFld: TStringList read fNFld write fNFld;
    property TFld: TStringList read fTFld write fTFld;
    property Rem: TStringList read fRem write fRem;
    property Arr: TStringList read fArr write fArr;
  end;

  TrRecords = class(TCollection)
  private
    function GetItem(Index: Integer): rRec;
    procedure SetItem(Index: Integer; const Value: rRec);
  public
    destructor Destroy; override;
    function  Add: rRec;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rRec;
    property Items[Index: Integer]: rRec read GetItem  write SetItem; default;
  end;

//======================================================
  Type
  rrpAnsvT = class(TCollectionItem)
  private
    fN : Integer; //??? ????????
    fSl : Boolean;
    fDisJrn : Boolean;
    fBl : Extended; // ?????????? ???
    fRight :Integer;
    fNmO : string;
    fido : integer;
    fAnsv : TStringList;  //??????? ??????????? ?????
    fChAns : TStringList;  //??????????
    fRndAns : TStringList;  //??????? (??? ?????????????)
  public
    FlUsed : Boolean; //??? ?????????????
    FltTxt : TStringList;  //?????? ??????? ???????????? ???????
    CurAnsv : TStringList;  //??????? ?????
    Nobj : string;
    NFault : Integer;
  published
//    property id: Integer read fid write fid default 0;
    property N: Integer read fN write fN default 0;
    property Sl: Boolean read fSl write fSl default False;
    property DisJrn: Boolean read fDisJrn write fDisJrn default False;
    property Bl: Extended read fBl write fBl;
    property Right: Integer read fRight write fRight default 1;
    property ido : Integer read fido write fido default 0;
    property NmO: string read fNmO write fNmO;
    property Ansv: TStringList read fAnsv write fAnsv;
    property ChAns: TStringList read fChAns write fChAns;
    property RndAns: TStringList read fRndAns write fRndAns;
  end;

  TrpAnsvT = class(TCollection)
  private
    function GetItem(Index: Integer): rrpAnsvT;
    procedure SetItem(Index: Integer; const Value: rrpAnsvT);
  public
    destructor Destroy; override;
    function  Add: rrpAnsvT;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rrpAnsvT;
    property Items[Index: Integer]: rrpAnsvT read GetItem  write SetItem; default;
    function GetItemIDO(idobj: Integer): rrpAnsvT;
  end;
//======================================================
Type
  TrPathPic = class(TCollectionItem)
  private
    Fpic : integer;
    FPathPic : string;
    FflInter : Boolean;
  public
    property pic: Integer read Fpic write Fpic default 0;
    property flInter: Boolean read FflInter write FflInter default False;
    property PathPic: string read FPathPic write FPathPic;
  published
  end;

Type
  TrLstPathPic = class(TCollection)
  private
    function GetItem(Index: Integer): TrPathPic;
    procedure SetItem(Index: Integer; const Value: TrPathPic);
  public
    destructor Destroy; override;
    function  Add: TrPathPic;
    function  AddPath(pic:Integer;Path:string;flIn:Boolean) : TrPathPic;
    function  FindPic(pic : Integer): TrPathPic;
    function  FindPath(pth: string) : TrPathPic;
    function  Path(pic : Integer): string;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrPathPic;
    property Items[Index: Integer]: TrPathPic read GetItem  write SetItem; default;
  end;

type
  TrGroupP = class(TObject)
  public
    group : string;
  end;
type
  TrPupil = class(TObject)
  public
    IDschool : Integer;
    Family,group : string;
  end;

type
  TrRecDiary = class(TObject)
  public
    ID,IDj,IDschool,IDask,TimeRun,IDt : Integer;
    DataD,TimeD,XML,FIO,Doljnost,group : string;
    Ball,MaxBall,Ball1,MaxBall1 : single;
  end;

//============================================
type
  TrDiary = class;
  rJrn = class;
//  TShema = class;
//===========================================
  TrDiary = class(TCollection)
  private
    destructor Destroy; override;
    function GetItem(Index: Integer): rJrn;
    procedure SetItem(Index: Integer; const Value: rJrn);
  public
    function  Add: rJrn;
    function  AddRec(Nm,Tm : string;Mark:Double;parTxt:string;rul:Integer): rJrn;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rJrn;
    property Items[Index: Integer]: rJrn read GetItem  write SetItem; default;
  end;
//==========================================
  rJrn = class(TCollectionItem)
  private
    FId : integer;
    Ftime : string;
    FName: string;
    Fpar : TStringList;
    FMark: Double;
    FRul : integer;
  published
    property Id: integer read FId write FId default 0;
    property Name: string read FName write FName;
    property tm: string read Ftime write Ftime;
    property Mark : Double read FMark write FMark;
    property par : TStringList read Fpar write Fpar;
    property Rul: integer read FRul write FRul default 0;
  end;
//++++++++++++++++++++++++++++++
//======================================================
  rRepAsk = class(TCollectionItem)
  private
    fidAsk : Integer;
    fShema : TPersistent;
    fAsk : string;
    fAskType : Integer;
    fFlLoad : Boolean;
    froAsk : TrpObjAsk;
    froAnsT : TrpAnsvT;
    FDiary : TrDiary;
    fLstMrk : TrLstMrk;
    fLstNFnd : TrLstNFnd;
    fLstAnsvInRep : TrLstAnsvInRep;
    FBallM : Extended;
    FBallP : Extended;
    FBall : Extended;
    FTmRun : Integer;
    FDisTm : Boolean;
    FModeView : Integer;   //0-obj   ;1-sh
  public
    property FlLoad : Boolean read fFlLoad write fFlLoad;
    property LstAnsvInRep: TrLstAnsvInRep read fLstAnsvInRep write fLstAnsvInRep;
    property Shema : TPersistent read fShema write fShema;
  published
    property idAsk: Integer read fidAsk write fidAsk default 0;
    property Ask: string read fAsk write fAsk;
    property AskType: Integer read fAskType write fAskType default 0;
    property ModeView : Integer read FModeView write FModeView default 0;
    property BallM : Extended read FBallM write FBallM;
    property BallP : Extended read FBallP write FBallP;
    property Ball : Extended read FBall write FBall;
    property TmRun: Integer read FTmRun write FTmRun default 0;
    property DisTm: Boolean read FDisTm write FDisTm default False;
    property roAsk : TrpObjAsk read froAsk write froAsk;
    property roAnsT : TrpAnsvT read froAnsT write froAnsT;
    property Diary: TrDiary read FDiary write FDiary;
    property LstMrk: TrLstMrk read fLstMrk write fLstMrk;
    property LstNFnd: TrLstNFnd read fLstNFnd write fLstNFnd;
  end;

  TRepPack = class(TCollection)
  private
    function GetItem(Index: Integer): rRepAsk;
    procedure SetItem(Index: Integer; const Value: rRepAsk);
  public
    destructor Destroy; override;
    function  Add: rRepAsk;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): rRepAsk;
    property Items[Index: Integer]: rRepAsk read GetItem  write SetItem; default;
  end;

//======================================================
  TRepAll = class(TPersistent)
  private
    FRepPack : TRepPack;
    FSerializer : TshXMLSerializer;
    FTmPack : Integer;
    FTmRun : Integer;
    FDisTm : Boolean;
    FDisLED : Boolean;
    fDisBotPan : Boolean;
    FName : string;
    FBall : Extended;
    FIDt : integer;
    FCurAsk : integer;
    FCurSc : integer;
    FNameCurSc : string;
    FDoljnostCurSc : string;
    FCurGroup : string;
    FFileNameForSaveLocal : string;
    FStart : string;
    FFinish : string;
    FDoc: TXMLDocument;
  public

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property Serializer : TshXMLSerializer read FSerializer write FSerializer;
    property FileNameForSaveLocal : string read FFileNameForSaveLocal write FFileNameForSaveLocal;
    procedure DeSerialize(XmlStr : string);
    procedure DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
    procedure SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
    function SaveLocal(): Boolean;
  published
    property IDt : integer read FIDt write FIDt;
    property CurAsk : integer read FCurAsk write FCurAsk;
    property CurSc : integer read FCurSc write FCurSc;
    property Start : string read FStart write FStart;
    property Finish : string read FFinish write FFinish;
    property NameCurSc : string read FNameCurSc write FNameCurSc;
    property DoljnostCurSc : string read FDoljnostCurSc write FDoljnostCurSc;
    property CurGroup : string read FCurGroup write FCurGroup;
    property TmPack : Integer read FTmPack write FTmPack default 0;
    property TmRun : Integer read FTmRun write FTmRun default 0;
    property DisTm: Boolean read FDisTm write FDisTm default False;
    property DisLED: Boolean read FDisLED write FDisLED default False;
    property DisBotPan : Boolean read fDisBotPan write fDisBotPan default False;
    property Name: string read FName write FName;
    property RepPack: TRepPack read FRepPack write FRepPack;
    property Ball : Extended read FBall write FBall;
  end;

var RepAll : TRepAll;
    CurSession : TrRecDiary;
    tmpFam,tmpGrp : String;

implementation

{TrLstPathPic}
destructor TrLstPathPic.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstPathPic.Add: TrPathPic;
begin Result := TrPathPic(inherited Add); end;
procedure TrLstPathPic.Delete(Index: Integer);
begin  inherited Delete(Index); end;
function TrLstPathPic.FindPic(pic: Integer) : TrPathPic;
var i : Integer;
begin
  Result:=nil;
  if Count= 0 then Exit;
  for i := 0 to Count-1 do
  begin
    if Items[i].pic=pic then
    begin
      Result:=Items[i];
      Exit;
    end;
  end;
end;
function TrLstPathPic.FindPath(pth: string) : TrPathPic;
var i : Integer;
begin
  Result:=nil;
  if Count= 0 then Exit;
  for i := 0 to Count-1 do
  begin
    if Items[i].PathPic=pth then
    begin
      Result:=Items[i];
      Exit;
    end;
  end;
end;
function TrLstPathPic.Path(pic: Integer) : string;
var i : Integer;
begin
  Result:='';
  if Count= 0 then Exit;
  for i := 0 to Count-1 do
  begin
    if Items[i].pic=pic then
    begin
      Result:=Items[i].PathPic;
      Exit;
    end;
  end;
end;
function  TrLstPathPic.AddPath(pic:Integer;Path:string;flIn:Boolean) : TrPathPic;
begin
  Result:=FindPic(pic);
  if Result=nil then begin
    Result:=FindPath(Path);
    if Result=nil then begin
      Result:=Add;
      Result.pic:=pic;Result.PathPic:=Path;Result.flInter:=flIn;
    end;
  end;
end;
function TrLstPathPic.GetItem(Index: Integer): TrPathPic;
begin Result := TrPathPic(inherited Items[Index]); end;
function TrLstPathPic.Insert(Index: Integer): TrPathPic;
begin Result := TrPathPic(inherited Insert(Index)); end;
procedure TrLstPathPic.SetItem(Index: Integer; const Value: TrPathPic);
begin Items[Index].Assign(Value); end;

{TrArrays}
destructor TrArrays.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrArrays.Add: rArr;
begin
  Result := rArr(inherited Add);
  Result.Arr:=TStringList.Create;
  Result.NArr:=TStringList.Create;
end;
procedure TrArrays.Delete(Index: Integer);
begin
  Items[Index].Arr.Free;
  Items[Index].NArr.Free;
  inherited Delete(Index);
end;
function TrArrays.GetItem(Index: Integer): rArr;
begin
  Result := rArr(inherited Items[Index]);
end;
function TrArrays.Insert(Index: Integer): rArr;
begin
  Result := rArr(inherited Insert(Index));
end;
procedure TrArrays.SetItem(Index: Integer; const Value: rArr);
begin
  Items[Index].Assign(Value);
end;
{TrRecords}
destructor TrRecords.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrRecords.Add: rRec;
begin
  Result := rRec(inherited Add);
  Result.Arr:=TStringList.Create;
  Result.NFld:=TStringList.Create;
  Result.TFld:=TStringList.Create;
  Result.Rem:=TStringList.Create;
  Result.nf:=1;Result.NFld.Add('');
end;
procedure TrRecords.Delete(Index: Integer);
begin
  Items[Index].Arr.Free;
  Items[Index].NFld.Free;
  Items[Index].TFld.Free;
  Items[Index].Rem.Free;
  inherited Delete(Index);
end;
function TrRecords.GetItem(Index: Integer): rRec;
begin
  Result := rRec(inherited Items[Index]);
end;
function TrRecords.Insert(Index: Integer): rRec;
begin
  Result := rRec(inherited Insert(Index));
end;
procedure TrRecords.SetItem(Index: Integer; const Value: rRec);
begin
  Items[Index].Assign(Value);
end;

{TrLstNFnd}
destructor TrLstNFnd.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstNFnd.Add: TrAnsNFnd;
begin
  Result := TrAnsNFnd(inherited Add);
end;
procedure TrLstNFnd.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrLstNFnd.GetItem(Index: Integer): TrAnsNFnd;
begin
  Result := TrAnsNFnd(inherited Items[Index]);
end;
function TrLstNFnd.Insert(Index: Integer): TrAnsNFnd;
begin
  Result := TrAnsNFnd(inherited Insert(Index));
end;
procedure TrLstNFnd.SetItem(Index: Integer; const Value: TrAnsNFnd);
begin
  Items[Index].Assign(Value);
end;

{TrLstAnsTxt}
destructor TrLstAnsTxt.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstAnsTxt.Add: TrAnsvTxt;
begin
  Result := TrAnsvTxt(inherited Add);
end;
procedure TrLstAnsTxt.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrLstAnsTxt.GetItem(Index: Integer): TrAnsvTxt;
begin
  Result := TrAnsvTxt(inherited Items[Index]);
end;
function TrLstAnsTxt.Insert(Index: Integer): TrAnsvTxt;
begin
  Result := TrAnsvTxt(inherited Insert(Index));
end;
procedure TrLstAnsTxt.SetItem(Index: Integer; const Value: TrAnsvTxt);
begin
  Items[Index].Assign(Value);
end;

{TrLstAnsvInRep}
destructor TrLstAnsvInRep.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstAnsvInRep.Add: TrAnsvInRep;
begin
  Result := TrAnsvInRep(inherited Add);
end;
procedure TrLstAnsvInRep.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrLstAnsvInRep.GetItem(Index: Integer): TrAnsvInRep;
begin
  Result := TrAnsvInRep(inherited Items[Index]);
end;
function TrLstAnsvInRep.Insert(Index: Integer): TrAnsvInRep;
begin
  Result := TrAnsvInRep(inherited Insert(Index));
end;
procedure TrLstAnsvInRep.SetItem(Index: Integer; const Value: TrAnsvInRep);
begin
  Items[Index].Assign(Value);
end;

{TrLstMrk}
destructor TrLstMrk.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrLstMrk.Add: TrMark;
begin
  Result := TrMark(inherited Add);
  Result.ListAnsTxt := TrLstAnsTxt.Create(TrAnsvTxt);
  Result.MyAns:='-';
end;
procedure TrLstMrk.Delete(Index: Integer);
begin
  Items[Index].ListAnsTxt.Free;
  inherited Delete(Index);
end;
function TrLstMrk.GetItem(Index: Integer): TrMark;
begin
  Result := TrMark(inherited Items[Index]);
end;
function TrLstMrk.Insert(Index: Integer): TrMark;
begin
  Result := TrMark(inherited Insert(Index));
end;
procedure TrLstMrk.SetItem(Index: Integer; const Value: TrMark);
begin
  Items[Index].Assign(Value);
end;
function TrLstMrk.FindForPos(frag: Integer; psFr: int64): TrMark;
var i: Integer;
begin
  Result :=nil;
  for i := 0 to Count-1 do
  begin
    if Items[i].NFragment=frag then
      if Items[i].posFr=psFr then
      begin
        Result :=Items[i];
        Exit;
      end;
  end;
end;

{TrpObjAsk}
destructor TrpObjAsk.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrpObjAsk.Add: rrpObj;
begin
  Result := rrpObj(inherited Add);
  Result.Right:=1;
  Result.FltTxt:=TStringList.Create;
  Result.CurAnsv:=TStringList.Create;
  Result.Ansv:=TStringList.Create;
end;
procedure TrpObjAsk.Delete(Index: Integer);
begin
  Items[Index].FltTxt.Free;
  Items[Index].CurAnsv.Free;
  Items[Index].Ansv.Free;
  inherited Delete(Index);
end;
function TrpObjAsk.GetItemIDO(idobj: Integer): rrpObj;
var i : Integer;
begin

  for i:=0 to Count-1 do
  begin
    if Items[i].fido=idobj then
    begin
      Result := rrpObj(Items[i]);
      Exit;
    end;
  end;
  Result:=nil;
end;
function TrpObjAsk.GetItem(Index: Integer): rrpObj;
begin
  Result := rrpObj(inherited Items[Index]);
end;
function TrpObjAsk.Insert(Index: Integer): rrpObj;
begin
  Result := rrpObj(inherited Insert(Index));
end;
procedure TrpObjAsk.SetItem(Index: Integer; const Value: rrpObj);
begin
  Items[Index].Assign(Value);
end;

{TrpAnsvT}
destructor TrpAnsvT.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TrpAnsvT.Add: rrpAnsvT;
begin
  Result := rrpAnsvT(inherited Add);
  Result.Right:=1;
  Result.FltTxt:=TStringList.Create;
  Result.CurAnsv:=TStringList.Create;
  Result.Ansv:=TStringList.Create;
  Result.ChAns:=TStringList.Create;
  Result.RndAns:=TStringList.Create;
end;
procedure TrpAnsvT.Delete(Index: Integer);
begin
  Items[Index].FltTxt.Free;
  Items[Index].CurAnsv.Free;
  Items[Index].Ansv.Free;
  Items[Index].ChAns.Free;
  Items[Index].RndAns.Free;
  inherited Delete(Index);
end;
function TrpAnsvT.GetItemIDO(idobj: Integer): rrpAnsvT;
var i : Integer;
begin
  for i:=0 to Count-1 do
  begin
    if Items[i].fido=idobj then
    begin
      Result := rrpAnsvT(Items[i]);
      Exit;
    end;
  end;
  Result:=nil;
end;
function TrpAnsvT.GetItem(Index: Integer): rrpAnsvT;
begin
  Result := rrpAnsvT(inherited Items[Index]);
end;
function TrpAnsvT.Insert(Index: Integer): rrpAnsvT;
begin
  Result := rrpAnsvT(inherited Insert(Index));
end;
procedure TrpAnsvT.SetItem(Index: Integer; const Value: rrpAnsvT);
begin
  Items[Index].Assign(Value);
end;

{TAnsvTxt}
constructor TAnsvTxt.Create();
begin
 inherited Create;
end;
{TMark}
constructor TMark.Create();
begin
 inherited Create;
end;

{TrDiary}
destructor TrDiary.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function  TrDiary.AddRec(Nm,Tm : string;Mark:Double;parTxt:string;rul:Integer): rJrn;
var lstJrn,jrn:rJrn;
begin
  Result:=nil;
  if Count>0 then lstJrn:=Items[Count-1];
  jrn:=Add; jrn.Name:=Nm;jrn.tm:=Tm;
  jrn.Mark:=Mark;jrn.par.Text:=parTxt;jrn.Rul:=rul;
  Result:=jrn;
end;
function TrDiary.Add: rJrn;
begin
  Result := rJrn(inherited Add);
  Result.par:=TStringList.Create;
end;
procedure TrDiary.Delete(Index: Integer);
begin
  Items[Index].par.Free;
  inherited Delete(Index);
end;
function TrDiary.GetItem(Index: Integer): rJrn;
begin
  Result := rJrn(inherited Items[Index]);
end;
function TrDiary.Insert(Index: Integer): rJrn;
begin
  Result := rJrn(inherited Insert(Index));
end;
procedure TrDiary.SetItem(Index: Integer; const Value: rJrn);
begin
  Items[Index].Assign(Value);
end;

{TRepPack}
destructor TRepPack.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;
function TRepPack.Add: rRepAsk;
begin
  Result := rRepAsk(inherited Add);
  Result.roAsk:=TrpObjAsk.Create(rrpObj);
  Result.roAnsT:=TrpAnsvT.Create(rrpAnsvT);
  Result.Diary:= TrDiary.Create(rJrn);
  Result.LstMrk:=TrLstMrk.Create(TrMark);
  Result.LstNFnd:= TrLstNFnd.Create(TrAnsNFnd);
  Result.LstAnsvInRep:=TrLstAnsvInRep.Create(TrAnsvInRep);
end;
procedure TRepPack.Delete(Index: Integer);
begin
  Items[Index].roAsk.Free;
  inherited Delete(Index);
end;
function TRepPack.GetItem(Index: Integer): rRepAsk;
begin
  Result := rRepAsk(inherited Items[Index]);
end;
function TRepPack.Insert(Index: Integer): rRepAsk;
begin
  Result := rRepAsk(inherited Insert(Index));
end;
procedure TRepPack.SetItem(Index: Integer; const Value: rRepAsk);
begin
  Items[Index].Assign(Value);
end;

{TRepAll}
constructor TRepAll.Create(AOwner: TComponent);
begin
   Self.RepPack:=TRepPack.Create(rRepAsk);
  Serializer:=TshXMLSerializer.Create;
end;

destructor TRepAll.Destroy;
begin
  Serializer.Free;
  inherited Destroy;
end;
procedure TRepAll.DeSerializeInt(AnXMLNode: TDOMNode; Component: TObject);
var j: integer;
begin
  if (AnXMLNode.NodeName = 'xml') or (AnXMLNode.NodeName = '#text') then Exit;
  for j:=0 to AnXMLNode.ChildNodes.Count-1 do begin
    SetPropertyValue(Component, AnXMLNode.ChildNodes[j]);
  end;
end;

procedure TRepAll.DeSerialize(XmlStr : string);
var tss : TStringStream;
    i: Integer;
begin
  try
    tss := TStringStream.Create(XmlStr);
    ReadXMLFile(FDoc, tss);
    for i:=0 to FDoc.ChildNodes.Count-1 do begin
      DeSerializeInt(FDoc.ChildNodes[i],self);
    end;
  finally
    tss.Free;
  end;
end;
procedure TRepAll.SetPropertyValue(Component: TObject; AnXMLNode: TDOMNode);
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
              if PropObject is TRepPack then obj := TRepPack(PropObject).Add
              else if PropObject is TrpObjAsk then obj := TrpObjAsk(PropObject).Add
              else if PropObject is TrpAnsvT then obj := TrpAnsvT(PropObject).Add
              else if PropObject is TrDiary then obj := TrDiary(PropObject).Add
              else if PropObject is TrLstMrk then obj := TrLstMrk(PropObject).Add
              else if PropObject is TrLstAnsTxt then obj := TrLstAnsTxt(PropObject).Add
              else if PropObject is TrLstNFnd then obj := TrLstNFnd(PropObject).Add
//              else if PropObject is TrDiary then obj := TrDiary(PropObject).Add
              else obj := (PropObject as TCollection).Add;
//              DeSerializeInt(XmlNodeList.Item[i], obj);
              DeSerializeInt(AnXMLNode.ChildNodes[i], obj);
            end;
          end
          else DeSerializeInt(AnXMLNode, PropObject);
      end;
    end;
  end;
end;
function TRepAll.SaveLocal(): Boolean;
var  Ss: TStringStream;
  str : TStringList;
  s,backFile : string;

begin
    s:='';
    Ss := TStringStream.Create(s);
    str := TStringList.Create;
    try
      try
        Serializer.Serialize(Self,Ss);
        str.Text:=Ss.DataString;
        if FFileNameForSaveLocal='' then
        begin
          DateTimeToString(backFile, 'dd_mm_yyyy hh_mm_ss', Now);
          FFileNameForSaveLocal := backFile+' '+IntToStr(FCurSc)+'.xml';
        end;
        str.SaveToFile(FFileNameForSaveLocal);
        Result := True;
      except
        Result := False;
      end;
    finally
      str.Free;
      Ss.Free;
    end;
end;

end.
