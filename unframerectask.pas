unit unFrameRectAsk;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls,UnOptions, unFrameAsk,rImgss,SizeControl;

type

  { TFrameRectAsk }

  TFrameRectAsk = class(TFrameAsk)
    ChckSC: TCheckBox;
    PanShWorkArea: TPanel;
    scrlbx1: TScrollBox;
    procedure butNextPgClick(Sender: TObject);
    procedure butPrevPgClick(Sender: TObject);
    procedure ChckSCChange(Sender: TObject);

    procedure MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMoveShImg(Sender: TObject; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDownShImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure ClickImg(Sender: TObject); override;
    procedure ClickLbl(Sender: TObject); override;
    procedure DblClickLbl(Sender: TObject); override;
    procedure MouseDownImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUpImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  private
    Xcr,Ycr : Integer;
    procedure SizeCtrlMouseDown(Sender: TObject;
      Target: TControl; TargetPt: TPoint; var handled: boolean);
  public
    procedure Init(); override;
  end;

implementation

{$R *.lfm}

procedure RegComponents(aParent: TWinControl; SizeCtrl: TSizeCtrl);
var
  i: integer;
begin
  for i := 0 to aParent.ControlCount -1 do
  begin
    if aParent.Controls[i].Tag <> 1 then
      SizeCtrl.RegisterControl(aParent.Controls[i]);
    if aParent.Controls[i] is TWinControl then
      RegComponents(TWinControl(aParent.Controls[i]), SizeCtrl);
  end;
end;
procedure UnregComponents(aParent: TWinControl; SizeCtrl: TSizeCtrl);
var
  i: integer;
begin
  for i := 0 to aParent.ControlCount -1 do begin
    SizeCtrl.UnRegisterControl(aParent.Controls[i]);
    if aParent.Controls[i] is TWinControl then
      UnregComponents(TWinControl(aParent.Controls[i]), SizeCtrl);
  end;
end;

{ TFrameRectAsk }
procedure TFrameRectAsk.butNextPgClick(Sender: TObject);
begin
  inherited;
end;

procedure TFrameRectAsk.butPrevPgClick(Sender: TObject);
begin
  inherited;
end;

procedure TFrameRectAsk.ChckSCChange(Sender: TObject);
begin
  UnregComponents(PanShWorkArea, SizeCtrl);
  if ChckSC.Checked then
  begin
    RegComponents(PanShWorkArea, SizeCtrl);
  end;

end;

procedure TFrameRectAsk.SizeCtrlMouseDown(Sender: TObject;
  Target: TControl; TargetPt: TPoint; var handled: boolean);
//var i: integer;
//  trg : TObject;
begin
  //curNode := GetNodeFromCtrl(tr.Items, TWinControl(Target));
  //tr.Selected := curNode;
  //eo := TEmbObj(Target);
end;

procedure TFrameRectAsk.Init();
begin
  //if Shema.
  inherited;

 // if Assigned(SizeCtrl) then
 //    SizeCtrl.Free;
 // SizeCtrl:= TSizeCtrl.Create(PanShWorkArea);
 //
 //UnregComponents(PanShWorkArea, SizeCtrl);
 // RegComponents(PanShWorkArea, SizeCtrl);
 // SizeCtrl.Enabled := true;
 // SizeCtrl.OnMouseDown := SizeCtrlMouseDown;

end;

procedure TFrameRectAsk.MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var lbl : TrLbl;
   s: String;
begin
  s := Sender.ClassName;
  StatusBar1.Panels[0].Text:= s;
   if Sender.ClassType=TrImage then
   begin
     StatusBar1.Panels[1].Text:= 'im '+TrImage(Sender).MyrImg.Name+' ('+inttostr(TrImage(Sender).MyrImg.aId)
       +'): '+inttostr(X)+', '+inttostr(Y)+'; st:'+inttostr(TrImage(Sender).MyrImg.St)
       +'; Flt:'+booltostr(TrImage(Sender).MyrImg.Fault);
       if TrImage(Sender).MyrImg.aId=0 then
              StatusBar1.Panels[1].Text:=StatusBar1.Panels[1].Text+ '  !!!';
       Shema.CurrObjMous := TrImage(Sender).MyrImg; Shema.MouseX:=X; Shema.MouseY:=Y;
   end
   else if Sender.ClassType=TrLbl then
   begin
     lbl:=TrLbl(Sender);
     StatusBar1.Panels[1].Text:= 'lb '+lbl.MyrImg.Name
     + lbl.Caption+' ('+inttostr(lbl.Tag)+'): '+inttostr(X)+', '+inttostr(Y);
     Shema.CurrObjMous := lbl.MyrImg; Shema.MouseX:=X; Shema.MouseY:=Y;
   end
   else
   begin
     StatusBar1.Panels[1].Text:= 'Sh : '+inttostr(X)+', '+inttostr(Y);
   end;
   Shema.PostMsgMainForm(LM_SH_MESSAGE,CMD_SH_MOUSEMOVEIMG,0);
end;

procedure TFrameRectAsk.MouseMoveShImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   StatusBar1.Panels[1].Text:= 'по подложке: '+inttostr(X)+', '+inttostr(Y);
//   shp1.Visible:=False;
end;
procedure TFrameRectAsk.MouseDownShImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFrameRectAsk.ClickImg(Sender: TObject);
begin
end;
procedure TFrameRectAsk.ClickLbl(Sender: TObject);
begin
end;
procedure TFrameRectAsk.DblClickLbl(Sender: TObject);
var s: String;
begin
  s := Sender.ClassName;
  Application.MessageBox(PChar(s),'DblClickLbl');
end;
procedure TFrameRectAsk.MouseDownImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var s: String;
begin
  //s := Sender.ClassName;
  //CurObjDown := Sender;
   if Sender.ClassType=TrImage then
   begin
      Shema.CurrObjMous := TrImage(Sender).MyrImg; Shema.MouseX:=X; Shema.MouseY:=Y;
   end
   else if Sender.ClassType=TrLbl then
   begin
     Shema.CurrObjMous := TrLbl(Sender).MyrImg; Shema.MouseX:=X; Shema.MouseY:=Y;
   end
   else
   begin
     StatusBar1.Panels[1].Text:= 'Sh : '+inttostr(X)+', '+inttostr(Y);
   end;
   Shema.PostMsgMainForm(LM_SH_MESSAGE,CMD_SH_MOUSEDOWNIMG,0);

//  inherited;
//  Application.MessageBox(PChar(s),'MouseDownImg');
end;
procedure TFrameRectAsk.MouseUpImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var s: String;
begin
  s := Sender.ClassName;
//  Application.MessageBox(PChar(s),'MouseUpImg');
end;


end.

