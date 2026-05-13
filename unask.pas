unit unAsk;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, rImgss, tren, unFrameAsk, unFrameRectAsk, unFrameVideo,UnOptions;

Type
  TrAskRec = class(TCollectionItem)
  public
    IDv, IDt, IDh : Integer;
    AskType : Integer;
    Ask : String;
    PropAsk : String;
    Pages : Integer;
    NumbRightAns : Integer;
    ExeFile : String;
    Extended : String;
    PictureAsk : String;
    PictureWork : String;
    ExtReaction, UseDDE, UseShWnd : Boolean;
    Seq : Integer;
    UseWinhelp : Boolean;
    Ball : Extended;
    Rem1 : String;
    Rem2 : String;
    Disable : Boolean;
    TimeA : Integer;
    DisTime, DisMyAns, DisQueryAns : Boolean;
    BallMyAns : Extended;
    idRobj : Integer;
    XMLProp : String;
  end;
  TrAsksRec =  class(TCollection)
  private
    function GetItem(Index: Integer): TrAskRec;
    procedure SetItem(Index: Integer; const Value: TrAskRec);
  public
    destructor Destroy; override;
    function  Add: TrAskRec;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrAskRec;
    property Items[Index: Integer]: TrAskRec read GetItem  write SetItem; default;
  end;

  TrQuestionRec = class(TCollectionItem)
  public
    IDa, IDv, IDt, Nask,IdPatern : Integer;
    XMLPropQ : String;
    IDh : Integer;
    AskType : Integer;
    Ask : String;
    PropAsk : String;
    Pages : Integer;
    NumbRightAns : Integer;
    ExeFile : String;
    Extended : String;
    PictureAsk : String;
    PictureWork : String;
    ExtReaction, UseDDE, UseShWnd : Boolean;
    Seq : Integer;
    UseWinhelp : Boolean;
    Ball : Extended;
    Rem1 : String;
    Rem2 : String;
    Disable : Boolean;
    TimeA : Integer;
    DisTime, DisMyAns, DisQueryAns : Boolean;
    BallMyAns : Extended;
    idRobj : Integer;
    XMLProp : String;
  end;
  TrQuestionsRec =  class(TCollection)
  private
    function GetItem(Index: Integer): TrQuestionRec;
    procedure SetItem(Index: Integer; const Value: TrQuestionRec);
  public
    destructor Destroy; override;
    function  Add: TrQuestionRec;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TrQuestionRec;
    property Items[Index: Integer]: TrQuestionRec read GetItem  write SetItem; default;
  end;

Type
  TAskObject = class (TObject)
  private
    FDBTypeAsk : Integer;
  protected

    procedure SetDBTypeAsk(value : Integer);
  public
    Journal :TrJournal;
    CurRepAsk : rRepAsk;
    CurAsk,CountAsk : Integer;
    PageCnt, PageCur : Integer;
    TypeAsk : Integer;
    ShemaText : TStringList;
    Shema : TShema;
    Owner : TControl;
    FrameAsk : TFrameAsk;
 // constructor Create; override;
    destructor Destroy; override;
    function LoadShema(str : string; Owner : TControl; flEd:Boolean) : TShema;
    function Init(parent: TWinControl; s : String; flEd:Boolean) : Boolean;
    function InitEd(parent: TPanel; s : String; flEd:Boolean) : Boolean;
    property DBTypeAsk : Integer  read FDBTypeAsk write SetDBTypeAsk;

  published
  end;

implementation

{TrAsksRec}
destructor TrAsksRec.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;

function TrAsksRec.Add: TrAskRec;
begin
    Result := TrAskRec(inherited Add);
end;
procedure TrAsksRec.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrAsksRec.GetItem(Index: Integer): TrAskRec;
begin
  Result := TrAskRec(inherited Items[Index]);
end;
function TrAsksRec.Insert(Index: Integer): TrAskRec;
begin
  Result := TrAskRec(inherited Insert(Index));
end;
procedure TrAsksRec.SetItem(Index: Integer; const Value: TrAskRec);
begin
  Items[Index].Assign(Value);
end;

{TrQuestionsRec}
destructor TrQuestionsRec.Destroy;
begin
  while Count>0 do Delete(0);
  inherited Destroy;
end;

function TrQuestionsRec.Add: TrQuestionRec;
begin
    Result := TrQuestionRec(inherited Add);
end;
procedure TrQuestionsRec.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;
function TrQuestionsRec.GetItem(Index: Integer): TrQuestionRec;
begin
  Result := TrQuestionRec(inherited Items[Index]);
end;
function TrQuestionsRec.Insert(Index: Integer): TrQuestionRec;
begin
  Result := TrQuestionRec(inherited Insert(Index));
end;
procedure TrQuestionsRec.SetItem(Index: Integer; const Value: TrQuestionRec);
begin
  Items[Index].Assign(Value);
end;

{TAskObject}
//constructor TAskObject.Create; override;
//begin
//
//end;
destructor TAskObject.Destroy;
begin
   if Shema<>nil then Shema.Free;
   if FrameAsk<>nil then FrameAsk.Free;
end;
procedure TAskObject.SetDBTypeAsk(value : Integer);
begin
  FDBTypeAsk := value;
end;

function TAskObject.LoadShema(str : string; Owner : TControl; flEd:Boolean) : TShema;
var i,j,k : Integer;
  tm,tm1,tm2,tme : Integer;
  Ansv : TStringList;
  PanShWorkArea : TPanel;
begin

  if Owner=nil then Exit;
  if RepAll<>nil then
     CurRepAsk:=RepAll.RepPack.Items[CurAsk];
 PanShWorkArea := TPanel(Owner);
 PanShWorkArea.DoubleBuffered := true;
 PanShWorkArea.Caption:='1234567890 ФЫВАпролдэ';
 if Journal<>nil then Journal.Free;
 if Shema<>nil then Shema.Free;
 Shema := TShema.Create(Owner);

   Shema.Coord.x:=0;Shema.Coord.y:=0;Shema.Coord.w:=1000;Shema.Coord.h:=1000;
   Shema.PathPic:=rOptions.PathTr.PathPict;//PathPic;
   tm1:= GetTickCount;
   Shema.DeSerialize(str);
   case DBTypeAsk of
   0 : Shema.TypeSub:=rBook;      //лекции
   1 : Shema.TypeSub:=rAskTxt ;   //вопросы
   2 : Shema.TypeSub:=rAskTxt;    //Выбор картинок
   3 : Shema.TypeSub:=rOuter;     //Внешняя программа
   4 : Shema.TypeSub:=rAskRect;   //Выбор областей
   9 : Shema.TypeSub:=rTren;
   10 : Shema.TypeSub:=rVideo;
   end;

 Shema.RepAll:=RepAll;
 Shema.CurA:=CurRepAsk;

 if Shema.ModeView=0 then Shema.ModeView:=2;

  if Shema.TypeSub=rAskRect then begin
   tm2:= GetTickCount;
   Shema.LoadState;
   Shema.Mode:=rShPlay;
   PanShWorkArea.Visible:=False;
   PanShWorkArea.SetBounds(0,0,Shema.Coord.w,Shema.Coord.h);
   Shema.UpdateImg(PanShWorkArea,true);
   PanShWorkArea.Visible:=True;
  end
  else if Shema.TypeSub=rVideo then begin
  ////++++++++++++++++++++++
  ////      CaptAsk.Caption:= QAsks.FieldByName('Ask').AsString;
  // pnlVid.Visible:=True;
  //  lstFragments.Clear; i:=0;
     for i := 0 to Shema.Fragments.Count-1 do
     begin
  //     lstFragments.Items.Append(Shema.Fragments.Items[i].Name);
  //     Fragm[i].Name:=Shema.Fragments.Items[i].Name;
  //     Fragm[i].FileP:=Shema.Fragments.Items[i].Files;
  //     Fragm[i].Rem:=Shema.Fragments.Items[i].Rem;
  //     Fragm[i].TimeF:=Shema.Fragments.Items[i].TimeF;
  //     Fragm[i].TimeB:=Shema.Fragments.Items[i].TimeB;
  //     Fragm[i].TimeE:=Shema.Fragments.Items[i].TimeE;
  //     Fragm[i].seq:=Shema.Fragments.Items[i].seq;
       if Shema.Fragments.Items[i].GrRects.Count>0 then
       begin
         for j:=0 to Shema.Fragments.Items[i].GrRects.Count-1 do
         begin
  //         Fragm[i].GrRct[j].id:=Shema.Fragments.Items[i].GrRects.Items[j].ID;
  //         Fragm[i].GrRct[j].Name:=Shema.Fragments.Items[i].GrRects.Items[j].Name;
  //         Fragm[i].GrRct[j].Rem:=Shema.Fragments.Items[i].GrRects.Items[j].Rem;
  //         Fragm[i].GrRct[j].seq:=Shema.Fragments.Items[i].GrRects.Items[j].seq;;
           if  Shema.Fragments.Items[i].GrRects.Items[j].VRects.Count>0 then
           begin
             for k:=0 to Shema.Fragments.Items[i].GrRects.Items[j].VRects.Count-1 do
             begin
  //             Fragm[i].GrRct[j].Rct[k].id:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].ID;
  //             Fragm[i].GrRct[j].Rct[k].TimeB:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].TmB;
  //             Fragm[i].GrRct[j].Rct[k].TimeE:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].TmE;
  //             Fragm[i].GrRct[j].Rct[k].TimeBc:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].TmBc;
  //             Fragm[i].GrRct[j].Rct[k].TimeEc:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].TmEc;
  //             Fragm[i].GrRct[j].Rct[k].l:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].Coord.x;
  //             Fragm[i].GrRct[j].Rct[k].t:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].Coord.y;
  //             Fragm[i].GrRct[j].Rct[k].w:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].Coord.w;
  //             Fragm[i].GrRct[j].Rct[k].h:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].Coord.h;
  //             Fragm[i].GrRct[j].Rct[k].seq:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].seq;
  //             Fragm[i].GrRct[j].Rct[k].flTime:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].flTm;
  //             Fragm[i].GrRct[j].Rct[k].flCoord:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Items[k].flCrd;
               end;
             end;
  //         Fragm[i].GrRct[j].cntRct:=Shema.Fragments.Items[i].GrRects.Items[j].VRects.Count;
           if Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Count>0 then
           begin
             for k:=0 to Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Count-1 do
             begin
  //             Fragm[i].GrRct[j].AnsvRct[k].id:=Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Items[k].ID;
  //             Fragm[i].GrRct[j].AnsvRct[k].Rigth:=Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Items[k].Rght;
  //             Fragm[i].GrRct[j].AnsvRct[k].Ball:=Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Items[k].Ball;
  //             Fragm[i].GrRct[j].AnsvRct[k].idAns:=Shema.Fragments.Items[i].GrRects.Items[j].AnsRects.Items[k].IdAns; //seq
             end;
           end;
  //         Fragm[i].GrRct[j].cntAnsvRct:=k;
         end;
       end;
  //     Fragm[i].cntGr:=j;
  //     lstMark.Clear; j:=0;
       if Shema.AnsTxt.Ans.Count>0 then begin
  //       Ansv:=TStringList.Create;
         for j:=0 to Shema.AnsTxt.Ans.Count-1 do begin
  //         Ansv.CommaText:=Shema.AnsTxt.Ans[j];
  //         Fragm[i].AnsvT[j].Seq:=StrToInt(Ansv[1]);
  //         Fragm[i].AnsvT[j].Ansver:=Ansv[2];
  //         Fragm[i].AnsvT[j].Group:=False;
         end;
       end;
  //     Fragm[i].cntAnsvT:=j;
     end;
  //
  //   if lstFragments.Count>1 then begin
  //    lstFragments.Height:=Round(pnlPanVid.Height/3);
  //    pnl9.Visible:=True;
  //   end
  //   else begin
  //    pnl9.Visible:=False;
  //   end;
  //   CurrFr:=0;
  //  GoVideo(CurrFr);
  end;
//++++++++++++++++++++++
end;

function TAskObject.Init(parent: TWinControl; s : String; flEd:Boolean) : Boolean;
var prnt : TPanel;
begin
  if ShemaText<>nil then ShemaText.Free;
  ShemaText := TStringList.Create;

  ShemaText.Text:=s;
//  ShemaText[0] := '<?xml version="1.0" encoding="windows-1251"?>';
  CurAsk := 0;
  if not flEd then
     DBTypeAsk:=CurRepAsk.AskType;
  if FrameAsk<>nil then FrameAsk.Free;
  case DBTypeAsk of
  0: begin      //лекции
      FrameAsk := TFrameRectAsk.Create(parent);
      TFrameRectAsk(FrameAsk).scrlbx1.HorzScrollBar.Position:=0;
      TFrameRectAsk(FrameAsk).scrlbx1.VertScrollBar.Position:=0;
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  1: begin    //вопросы
      FrameAsk := TFrameRectAsk.Create(parent);
      TFrameRectAsk(FrameAsk).scrlbx1.HorzScrollBar.Position:=0;
      TFrameRectAsk(FrameAsk).scrlbx1.VertScrollBar.Position:=0;
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  2: begin    //Выбор картинок
      FrameAsk := TFrameRectAsk.Create(parent);
      TFrameRectAsk(FrameAsk).scrlbx1.HorzScrollBar.Position:=0;
      TFrameRectAsk(FrameAsk).scrlbx1.VertScrollBar.Position:=0;
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  3: begin   //Внешняя программа
      FrameAsk := TFrameRectAsk.Create(parent);
      TFrameRectAsk(FrameAsk).scrlbx1.HorzScrollBar.Position:=0;
      TFrameRectAsk(FrameAsk).scrlbx1.VertScrollBar.Position:=0;
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  4: begin  //Выбор областей
      FrameAsk := TFrameRectAsk.Create(parent);
      TFrameRectAsk(FrameAsk).scrlbx1.HorzScrollBar.Position:=0;
      TFrameRectAsk(FrameAsk).scrlbx1.VertScrollBar.Position:=0;
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  9: begin  //Тренажер
      FrameAsk := TFrameRectAsk.Create(parent);
      prnt:= TFrameRectAsk(FrameAsk).PanShWorkArea;
    end;
  10: begin  //Видеовопрос
      FrameAsk := TFrameVideo.Create(parent);
      prnt:= TFrameVideo(FrameAsk).PanShWorkArea;
      TFrameVideo(FrameAsk).CurrFr := 0;
    end;
  else ;
  end;
  FrameAsk.Visible:=False;
  LoadShema(s,prnt,flEd);
//  Shema.LoadState;
  Shema.Mode:=rShPlay;

  Shema.MouseMove:=FrameAsk.MouseMoveImg;
  Shema.MouseDown:=FrameAsk.MouseDownImg;
  Shema.MouseUp:=FrameAsk.MouseUpImg;
  Shema.DblClickLbl:=FrameAsk.DblClickLbl;
  Shema.Image.OnMouseMove:=FrameAsk.MouseMoveShImg;
  Shema.Image.OnMouseDown:=FrameAsk.MouseDownShImg;

  FrameAsk.Parent := parent;
  FrameAsk.Align:= alClient;
  FrameAsk.Shema := Shema;
  FrameAsk.PageCnt:=Shema.Pages.Count;
  FrameAsk.PageCur:=1;
  FrameAsk.TypeAsk:=DBTypeAsk;
  FrameAsk.Init();
  prnt.SetBounds(0,0,Shema.Coord.w,Shema.Coord.h);
//  parent.SetBounds(0,0,Shema.Coord.w+2,Shema.Coord.h+2);
//  Shema.UpdateImg(prnt,true);

  FrameAsk.Visible:=True;

end;

function TAskObject.InitEd(parent: TPanel; s : String; flEd:Boolean) : Boolean;
var prnt : TPanel;
begin
  if ShemaText<>nil then ShemaText.Free;
  ShemaText := TStringList.Create;

  ShemaText.Text:=s;
//  ShemaText[0] := '<?xml version="1.0" encoding="windows-1251"?>';
  CurAsk := 0;
//  DBTypeAsk:=CurRepAsk.AskType;
  LoadShema(s,parent,flEd);
  Shema.LoadState;
  Shema.Mode:=rShPlay;
  parent.SetBounds(0,0,Shema.Coord.w,Shema.Coord.h);
//  Shema.UpdateImg(prnt,flEd);
//  FrameAsk.Visible:=True;

end;


end.

