unit unFrameAsk;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls,StdCtrls, ExtCtrls, ComCtrls,
  rImgss, SizeControl;

type

  { TFrameAsk }

  TFrameAsk = class(TFrame)
    butNextPg: TButton;
    butPrevPg: TButton;
    panBot: TPanel;
    StatusBar1: TStatusBar;
    procedure butNextPgClick(Sender: TObject);
    procedure butPrevPgClick(Sender: TObject);
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMoveShImg(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseDownShImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    procedure ClickImg(Sender: TObject); virtual;
    procedure ClickLbl(Sender: TObject); virtual;
    procedure DblClickLbl(Sender: TObject); virtual;
    procedure MouseDownImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUpImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  private

  public
    PageCnt, PageCur : Integer;
    TypeAsk : Integer;
    Shema : TShema;
    CurObjDown : TObject;
    function LoadShema(str : string) : TShema;
    procedure Init(); virtual;
    procedure FrMD(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); virtual;
  end;

var
  SizeCtrl: TSizeCtrl;

implementation

{$R *.lfm}

{ TFrameAsk }

procedure TFrameAsk.Init();
begin

  if Shema.Pcnt>0 then begin
    panBot.Visible:=True;
    panBot.Caption:=IntToStr(Shema.CurrPg)+' страница из '+IntToStr(Shema.Pcnt);
    if Shema.CurrPg=1 then butPrevPg.Enabled:=False
       else butPrevPg.Enabled:=True;
    if Shema.CurrPg=Shema.Pcnt then butNextPg.Enabled:=False
       else butNextPg.Enabled:=True;
  end
  else begin
    panBot.Visible:=False; //pnlLst.Visible:=False;
  end;
end;

procedure TFrameAsk.butPrevPgClick(Sender: TObject);
begin
  Shema.CurrPg:=Shema.CurrPg-1;
  Init();
end;

procedure TFrameAsk.FrMD(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var s: String;
begin
end;

procedure TFrameAsk.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var s: String;
begin

end;

procedure TFrameAsk.butNextPgClick(Sender: TObject);
begin
  Shema.CurrPg:=Shema.CurrPg+1;
  Init();
end;

function TFrameAsk.LoadShema(str: string): TShema;
begin

end;
procedure TFrameAsk.MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //s := Sender.ClassName+'/'+Sender.ClassType.ClassName;
end;
procedure TFrameAsk.MouseDownShImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;
procedure TFrameAsk.MouseMoveShImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;
procedure TFrameAsk.ClickImg(Sender: TObject);
begin
end;
procedure TFrameAsk.ClickLbl(Sender: TObject);
begin
end;
procedure TFrameAsk.DblClickLbl(Sender: TObject);
begin
end;
procedure TFrameAsk.MouseDownImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  //FrMD(Sender,Button, Shift, X, Y);
  FrameMouseDown(Sender,Button, Shift, X, Y);
end;
procedure TFrameAsk.MouseUpImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

end.

