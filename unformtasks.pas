unit unFormTasks;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Menus, JvgListBox, UtilitiesDB,UnTreeTopic,unAsk;

type

  { TFormTasks }

  TFormTasks = class(TForm)
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
    procedure trSubChange(Sender: TObject; Node: TTreeNode);
  private
    TreeSub : TdSubs;
    procedure FillLstQuestion(idt : Integer);
  public

  end;

var
  FormTasks: TFormTasks;

implementation

{$R *.lfm}

{ TFormTasks }

procedure TFormTasks.FillLstQuestion(idt : Integer);
var trNode : TdSub;
    i,n : Integer;
    QuestionsRec : TrQuestionsRec;
begin
  trNode := TreeSub.GetNodeIdt(idt,nil);
  LstAsk.Clear;
  if trNode=nil then
  begin
    for i := 0 to Pred(TreeSub.RootSubs.Count) do
    begin
      n := LstAsk.AddObjectO(TreeSub.RootSubs.Items[i].Name,TreeSub.RootSubs.Items[i]);
      if TreeSub.RootSubs.Items[i].Disable then LstAsk.IndexGlyph[n] := 21
        else LstAsk.IndexGlyph[n] := 20;
    end;
  end else
  begin
    for i := 0 to Pred(trNode.Subs.Count) do
    begin
      n := LstAsk.AddObjectO(trNode.Subs.Items[i].Name,trNode.Subs.Items[i]);
      if trNode.Subs[i].Disable then LstAsk.IndexGlyph[n] := 21
        else LstAsk.IndexGlyph[n] := 20;
    end;
  end;

  QuestionsRec := GetQuestionsIDT(idt);
  for i := 0 to Pred(QuestionsRec.Count) do
  begin
    n := LstAsk.AddObjectO(QuestionsRec[i].Ask, QuestionsRec[i]);
    LstAsk.IndexGlyph[n] := QuestionsRec[i].AskType;
  end;
end;

procedure TFormTasks.FormCreate(Sender: TObject);
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
  TreeSub := DBToTreeSub(True,True,'Tasks');
  if TreeSub=nil then Exit;

  FillTreeSub(TreeSub,trSub.Items.AddChild(nil,'Root'),trSub);
  FillLstQuestion(0);
end;

procedure TFormTasks.trSubChange(Sender: TObject; Node: TTreeNode);
var trNode : TdSub;
begin
   trNode := TdSub(Node.Data);
   if trNode= nil then
     FillLstQuestion(0)
   else
   FillLstQuestion(trNode.IDt);
end;

end.

