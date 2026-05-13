unit unFormEdZ;

{$mode Delphi}

interface

uses
  Classes, SysUtils, LMessages, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  ExtCtrls, StdCtrls, DOM, XMLRead, SynEdit, SynHighlighterXML, //RTTIGrids,
  UtilitiesDB, unAsk, rImgss, unFrmEdLstAns, unFrameAsk;

type

  { TFormEdZ }

  TFormEdZ = class(TForm)
    butAnsvs: TButton;
    FrameAsk1: TFrameAsk;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PanShWorkArea: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StBarLeft: TStatusBar;
    SynEditSh: TSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    trvSh: TTreeView;
    trvXML: TTreeView;
    procedure btnNextPgClick(Sender: TObject);
    procedure btnPrevPgClick(Sender: TObject);
    procedure butAnsvsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FrameAsk1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ShMessageHandler(var Message: TLMessage); message LM_SH_MESSAGE;

    //procedure ClickImg(Sender: TObject);
    //procedure ClickLbl(Sender: TObject);
    //procedure DblClickLbl(Sender: TObject);
    //procedure MouseDownImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    //procedure MouseUpImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    //procedure MouseMoveShImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    //procedure MouseDownShImg(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    //procedure ClickPmn(Sender: TObject);
    //procedure GoTimer(Sender: TObject);
    //function ProcEvent(rIm : rImg;typeEvent : TrEvType; flDest: boolean): Boolean;
  private

  public
    IDv : Integer;
    AskObject : TAskObject;
    Shema : TShema;
    FrAsk : TFrameAsk;
    procedure XML2Tree(tree: TTreeView; XMLDoc: TDOMNode);
    procedure Shema2Tree(tree: TTreeView; Shema: TShema);
  end;

var
  FormEdZ: TFormEdZ;

implementation

{$R *.lfm}

{ TFormEdZ }

procedure TFormEdZ.FormActivate(Sender: TObject);
var s : String; i : Integer;
  Sh : TShema;
  Ss: TStringStream;
  strL : TStringList;
//  tblAsks : TZQuery;
begin
  Caption:='IDV = '+IntToStr(IDv);

    //if CurAsk = (CountAsk-1) then btnNextAsk.Enabled:=False
    //   else  btnNextAsk.Enabled:=True;
    //if CurAsk = 0 then btnPrevAsk.Enabled:=False
    //   else  btnPrevAsk.Enabled:=True;

    //lblCntAsk1.Caption:= IntToStr(CurAsk+1) +'/'+inttoStr(CountAsk);
    SynEditSh.Clear;
    AskObject := DBToAskObject(IDv,  PanShWorkArea, True);
    AskObject.Shema.hFormMain:=Self.Handle;
    FrAsk := AskObject.FrameAsk;

    FrAsk.OnMouseDown := FrameAsk1MouseDown;
    //MouseMoveImg := FrAsk.MouseMoveImg;
 //   AskObject.Shema.Image.OnMouseMove:=MouseMoveImg;
 //   AskObject.Shema.UpdateImg(PanShWorkArea,True);
   //tblAsks := TZQuery.Create(nil);
    //tblAsks.Connection := DBcon;
    //tblAsks.SQL.Add('Select * From Asks Where idv = ' +inttostr(IDv)+';');
    //tblAsks.Active:=True;
    //strL := TStringList.Create;
    //strL.Text:=CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
    //s:= CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
    //if s='' then Exit;
    //
    //if Assigned(AskObject) then AskObject.Free;
    //AskObject := TAskObject.Create;
    //AskObject.CurAsk := 0;
    //AskObject.CurRepAsk:=RepAll.RepPack[AskObject.CurAsk];
    //AskObject.DBTypeAsk:=tblAsks.FieldByName('AskType').AsInteger;
    //AskObject.DBTypeAsk:=RepAll.RepPack[AskObject.CurAsk].AskType;
    //AskObject.CountAsk := RepAll.RepPack.Count;
    //AskObject.InitEd(PanShWorkArea,s);

    SynEditSh.Lines.Text := AskObject.ShemaText.Text;
    Sh := AskObject.Shema;
    XML2Tree(trvXML,Sh.XMLDoc);
    Shema2Tree(trvSh,Sh);
    PanShWorkArea.Canvas.Clear;
    //tblAsks.Free;
end;

procedure TFormEdZ.butAnsvsClick(Sender: TObject);
var
  edt: TFrmEdLstAns;
begin
  edt := TFrmEdLstAns.Create(nil);
  edt.Edit(AskObject.Shema.AnsTxt);
  edt.Free;
end;

procedure TFormEdZ.btnNextPgClick(Sender: TObject);
begin
end;

procedure TFormEdZ.btnPrevPgClick(Sender: TObject);
begin

end;

procedure TFormEdZ.FormCreate(Sender: TObject);
begin

end;

procedure TFormEdZ.FrameAsk1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var s: String;
begin
  inherited;
  s := Sender.ClassName;
  StBarLeft.Panels[1].Text:=s;
end;

procedure TFormEdZ.Shema2Tree(tree: TTreeView; Shema: TShema);
var trN,trNp,trNf: TTreeNode;
  i,i1 : Integer;

  procedure AddNodes(Child: TTreeNode; obj: rImg);
  var j: Integer;
    s, vs : String;
  begin
    //if (aNode.NodeName = 'xml') or (aNode.NodeName = '#text') then Exit;
    //try
    //  if aNode.GetChildNodes.Count>0 then
    //     vs := aNode.ChildNodes[0].NodeValue;
    //except
    //  vs := 'ХЗ';
    //end;
    s := obj.Name;
    Child := tree.Items.AddChildObject(Child, s, Pointer(obj));
    for j:=0 to obj.rImgs.Count-1 do begin
      AddNodes(Child, obj.rImgs[j]);
    end;
  end;

begin
  trvSh.Items.BeginUpdate;
  try
    trvSh.Items.Clear;
    trNp:=trvSh.Items.AddChildObject(nil, 'rImgs',Shema.rImgs);
    for i:=0 to Shema.rImgs.Count-1 do begin
      AddNodes(trNp, Shema.rImgs[i]);
    end;
    trNp:=trvSh.Items.AddChildObject(nil, 'Pages',Shema.Pages);
    for i:=0 to Shema.Pages.Count-1 do begin
      trN:=trvSh.Items.AddChildObject(trNp, 'Page '+IntToStr(Shema.Pages[i].pId)+': '+Shema.Pages[i].Name,Shema.Pages[i]);
      for i1:=0 to Shema.Pages[i].rImgs.Count-1 do begin
        AddNodes(trN, Shema.Pages[i].rImgs[i1]);
      end;
    end;
    trNp:=trvSh.Items.AddChildObject(nil, 'Fragments',Shema.Fragments);
    for i:=0 to Shema.Fragments.Count-1 do begin
      trNf:=trvSh.Items.AddChildObject(trNp, 'Fragment '+IntToStr(Shema.Fragments[i].seq)+': '+Shema.Fragments[i].Name,Shema.Fragments[i]);

      for i1:=0 to Shema.Fragments[i].GrRects.Count-1 do begin
        trN:=trvSh.Items.AddChildObject(trNf, 'GrRect '+IntToStr(Shema.Fragments[i].GrRects[i1].seq)+': '
             +Shema.Fragments[i].GrRects[i1].Name,Shema.Fragments[i].GrRects[i1]);
//        AddNodes(trN, Shema.Pages[i].rImgs[i1]);
      end;
//      AddNodes(trNp, Shema.Fragments[i]);
    end;

    trvSh.Items.GetFirstNode.Expand(false);
  finally
    trvSh.Items.EndUpdate;
  end;
end;

procedure TFormEdZ.XML2Tree(tree: TTreeView; XMLDoc: TDOMNode);
var
  j: Integer;

  procedure AddNodes(Child: TTreeNode; aNode: TDOMNode);
  var i: Integer;
    s, vs : String;
  begin
    if (aNode.NodeName = 'xml') or (aNode.NodeName = '#text') then Exit;
    try
      if aNode.GetChildNodes.Count>0 then
         vs := aNode.ChildNodes[0].NodeValue;
    except
      vs := 'ХЗ';
    end;
    s := aNode.NodeName+': '+ vs;
    Child := tree.Items.AddChildObject(Child, s, Pointer(aNode));
    for i:=0 to aNode.ChildNodes.Count-1 do begin

      AddNodes(Child, aNode.ChildNodes[i]);
    end;
  end;

begin
    tree.Items.BeginUpdate;
  try
    tree.Items.Clear;
    for j:=0 to XMLDoc.ChildNodes.Count-1 do begin
      AddNodes(nil, XMLDoc.ChildNodes[j]);
    end;
    tree.Items.GetFirstNode.Expand(false);
  finally
    tree.Items.EndUpdate;
  end;
end;

procedure TFormEdZ.MouseMoveImg(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var lbl : TrLbl;
   s: String;
begin
 // inherited;
  s := Sender.ClassName+'/'+Sender.ClassType.ClassName;
  StBarLeft.Panels[2].Text:= s;
   if Sender.ClassType=TrImage then
   begin
     StBarLeft.Panels[1].Text:= 'im '+TrImage(Sender).MyrImg.Name+' ('+inttostr(TrImage(Sender).MyrImg.aId)
       +'): '+inttostr(X)+', '+inttostr(Y)+'; st:'+inttostr(TrImage(Sender).MyrImg.St)
       +'; Flt:'+booltostr(TrImage(Sender).MyrImg.Fault);
       if TrImage(Sender).MyrImg.aId=0 then
              StBarLeft.Panels[1].Text:=StBarLeft.Panels[1].Text+ '  !!!';
   end
   else if Sender.ClassType=TrLbl then
   begin
     lbl:=TrLbl(Sender);
     StBarLeft.Panels[1].Text:= 'lb '+lbl.MyrImg.Name
     + lbl.Caption+' ('+inttostr(lbl.Tag)+'): '+inttostr(X)+', '+inttostr(Y);
   end
   else
   begin
     StBarLeft.Panels[1].Text:= 'Sh : '+inttostr(X)+', '+inttostr(Y);
   end;
end;

procedure TFormEdZ.ShMessageHandler(var Message: TLMessage);
var
  S: String;
begin

  case Message.wParam of
    CMD_SH_MOUSEDOWNIMG:
      begin
        s := AskObject.Shema.CurrObjMous.ClassName+': '+ IntToStr(AskObject.Shema.CurrObjMous.aId);
       StBarLeft.Panels[0].Text:= s;
      end;
    CMD_SH_MOUSEUPIMG:
      begin

      end;
    CMD_SH_MOUSEMOVEIMG:
      begin
        s := AskObject.Shema.CurrObjMous.ClassName+': '+ IntToStr(AskObject.Shema.CurrObjMous.aId);
//        StBarLeft.Panels[0].Text:= s;
        StBarLeft.Panels[1].Text:= inttostr(AskObject.Shema.MouseX)+', '+inttostr(AskObject.Shema.MouseY);
      end;
  else
    S := '<unknown>'
  end;

end;

end.

