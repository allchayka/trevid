unit unFormSubsAsks;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  ComCtrls, UtilitiesDB,UnTreeTopic, JvgListBox,rImgss, unAsk,unFormEdZ;

type

  { TFormSubsAsks }

  TFormSubsAsks = class(TForm)
    ImageList1: TImageList;
    LstAsk: TJvgListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    trSub: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure LstAskChange(Sender: TObject; FOldSelItemIndex,
      FSelItemIndex: Integer);
    procedure LstAskDblClick(Sender: TObject);
    procedure trSubChange(Sender: TObject; Node: TTreeNode);
    function FindTvNodeFromIDt(idt : Integer; Node: TTreeNode): TTreeNode;
  private

  public
     TreeSub : TdSubs;
     procedure FillLstAsk(idt : Integer);
  end;

var
  FormSubsAsks: TFormSubsAsks;

implementation

{$R *.lfm}

{ TFormSubsAsks }

function TFormSubsAsks.FindTvNodeFromIDt(idt : Integer; Node: TTreeNode): TTreeNode;
var i, cnt : Integer;
  tNodes : TTreeNodes;
  dSub : TdSub;
begin
  Result:=nil;
  if Node=nil then tNodes := trSub.Items
    else tNodes := Node.TreeNodes;
  cnt := Pred(tNodes.Count);
  for i := 0 to cnt do begin
    dSub:=TdSub(tNodes[i].Data);
    if dSub<>nil then
    begin
      if dSub.IDt=idt then begin
        Result:=tNodes[i];
        Exit;
      end;
    end;
  end;
end;

procedure TFormSubsAsks.FillLstAsk(idt : Integer);
var trNode : TdSub;
    i,n : Integer;
    AsksRec : TrAsksRec;
begin
  trNode := TreeSub.GetNodeIdt(idt,nil);
  LstAsk.Clear;
  if trNode=nil then
  begin
    for i := 0 to Pred(TreeSub.RootSubs.Count) do
    begin
      n := LstAsk.AddObjectO(TreeSub.RootSubs.Items[i].Name,TreeSub.RootSubs.Items[i]);
//      n := LstAsk.AddItem(TreeSub.RootSubs.Items[i].Name,TreeSub.RootSubs.Items[i]);
      if TreeSub.RootSubs.Items[i].Disable then LstAsk.IndexGlyph[n] := 21
        else LstAsk.IndexGlyph[n] := 20;
    end;
  end else
  begin
    for i := 0 to Pred(trNode.Subs.Count) do
    begin
      n := LstAsk.AddObjectO(trNode.Subs.Items[i].Name,trNode.Subs.Items[i]);
      if trNode.Subs.Items[i].Disable then LstAsk.IndexGlyph[n] := 21
        else LstAsk.IndexGlyph[n] := 20;
    end;
  end;

  AsksRec := GetAsksIDT(idt);
  for i := 0 to Pred(AsksRec.Count) do
  begin
    n := LstAsk.AddObjectO(AsksRec[i].Ask, AsksRec[i]);
    LstAsk.IndexGlyph[n] := AsksRec[i].AskType;
  end;
end;

procedure TFormSubsAsks.FormCreate(Sender: TObject);

  procedure FillTreeSub(trSc:TdSubs;trvNode : TTreeNode;trvw : TTreeView );
  var j : Integer;
    tn : TTreeNode;
  begin

    for j := 0 to Pred(trSc.Count) do begin
      if trvNode=nil then
      begin
        tn := trvw.Items.AddChild(trvNode,IntToStr(trSc[j].AppIdt)+';'+IntToStr(trSc[j].Idt)+';'+IntToStr(trSc[j].IndInG)+'; '+trSc[j].Name)
      end
      else
        tn := trvNode.TreeNodes.AddChild(trvNode,IntToStr(trSc[j].AppIdt)+';'+IntToStr(trSc[j].Idt)+';'+IntToStr(trSc[j].IndInG)+'; '+trSc[j].Name);
      tn.Data:=trSc[j];
      FillTreeSub(trSc[j].Subs,tn,trvw);
    end;
  end;

begin
  trSub.Items.Clear;
  TreeSub := DBToTreeSub(True,True,'Subjects');
  if TreeSub=nil then Exit;
  FillTreeSub(TreeSub,trSub.Items.AddChild(nil,'Root'),trSub);
  FillLstAsk(0);
end;

procedure TFormSubsAsks.LstAskChange(Sender: TObject; FOldSelItemIndex,
  FSelItemIndex: Integer);
begin

end;

procedure TFormSubsAsks.LstAskDblClick(Sender: TObject);
var id : Integer;
  nmCl : String;
  trNode : TTreeNode;
  frm : TFormEdZ;
begin
 nmCl := LstAsk.Items.Objects[lstAsk.ItemIndex].ClassName;
 if nmCl = 'TdSub' then
 begin
   id:= TdSub(LstAsk.Items.Objects[lstAsk.ItemIndex]).IDt;
   trNode := FindTvNodeFromIDt(id,nil);
   if trNode<>nil then
      trNode.Selected:=True;
 end else if nmCl = 'TrAskRec' then
 begin
   frm := TFormEdZ.Create(Self);
   frm.IDv := TrAskRec(LstAsk.Items.Objects[lstAsk.ItemIndex]).IDv;
   frm.Show;
 end;
end;

procedure TFormSubsAsks.trSubChange(Sender: TObject; Node: TTreeNode);
var trNode : TdSub;
begin
   trNode := TdSub(Node.Data);
   if trNode= nil then
     FillLstAsk(0)
   else
   FillLstAsk(trNode.IDt);
end;

end.

