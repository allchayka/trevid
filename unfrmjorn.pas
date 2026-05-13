unit unFrmJorn;

{$mode Delphi}
//{$CODEPAGE CP1251}
//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LConvEncoding, DB, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, DBGrids, Grids, DBCtrls, SynHighlighterXML,
  SynEdit, SynGutterBase, PrintersDlgs, DOM, XMLRead, XML2HTML, HtmlView,
  {$ifndef MetaFileMissing}
    MetaFilePrinter,
  {$endif}
  {$ifdef UseOldPreviewForm}
    PreviewForm,
  {$else UseOldPreviewForm}
    BegaZoom,
    BegaHtmlPrintPreviewForm,
  {$endif UseOldPreviewForm}

  ZConnection, ZDataset, UtilitiesDB,
  UnOptions, tren,rImgss,unAsk,
  unFrameVideo,unFrameRectAsk, UnFrameTopic,UnTreeTopic,unFormSubsAsks;//, ;   unDataBase

type

  { TFrmJorn }

  TFrmJorn = class(TForm)
    btnNextAsk: TButton;
    btnNextPg: TButton;
    btnPrevAsk: TButton;
    btnPrevPg: TButton;
    btnReloadTree: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ButtonToTree: TButton;
    chckLost: TCheckBox;
    chckDis: TCheckBox;
    cmbTreeTypeView: TComboBox;
    cmbxTRep: TComboBox;
    HtmlViewer1: THtmlViewer;
    Label1: TLabel;
    lblCntAsk: TLabel;
    lbl1: TLabel;
    lblCntAsk1: TLabel;
    lstAsks: TListBox;
    lst1: TListBox;
    ListBoxAsk: TListBox;
    lst2: TListBox;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    pnlTopTopic: TPanel;
    pnlTopic: TPanel;
    PanShWorkArea: TPanel;
    pnlTopAsk: TPanel;
    pnlBot1: TPanel;
    pnlLstCapt1: TPanel;
    pnlLstCapt2: TPanel;
    pnlLstTop: TPanel;
    pnlLstBot: TPanel;
    pnlLst: TPanel;
    pnlAsk: TPanel;
    PanShWorkArea2: TPanel;
    pnlPG: TPanel;
    pnlTop: TPanel;
    PanelHtml: TPanel;
    pnl5: TPanel;
    pnl6: TPanel;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    scrlbx1: TScrollBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Splitter8: TSplitter;
    Splitter9: TSplitter;
    statTr: TStatusBar;
    grdAsks: TStringGrid;
    SynEdit1: TSynEdit;
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
    trSub: TTreeView;
    trvXML: TTreeView;
    trvXMLsh: TTreeView;
    tvJr: TTreeView;
    ZConnection1: TZConnection;
    procedure btnNextAskClick(Sender: TObject);
    procedure btnNextPgClick(Sender: TObject);
    procedure btnPrevAskClick(Sender: TObject);
    procedure btnPrevPgClick(Sender: TObject);
    procedure btnReloadTreeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ButtonToTreeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBoxAskClick(Sender: TObject);
    procedure trSubChange(Sender: TObject; Node: TTreeNode);
    procedure trSubClick(Sender: TObject);
    procedure tvJrChange(Sender: TObject; Node: TTreeNode);
    procedure tvJrClick(Sender: TObject);
  private

  public
//    XmlDocument: IXmlDocument;
    FDoc : TXmlDocument;
    AskObject : TAskObject;
    frAsk : TFrame;
    frTopic : TFrameTopic;
    TreeSub : TdSubs;
    procedure FillTree(tp: Integer);
    procedure FillScheme(RepAsk : rRepAsk);
    procedure XML2Tree(tree: TTreeView; XMLDoc: TDOMNode);
  end;

var
  FrmJorn: TFrmJorn;
  HTMvw : THtmlViewer;
  Shema : TShema;
  Journal :TrJournal;
  PathPic,PathDoc,PathHlp : String;
  CurRepAsk : rRepAsk;
  CurAsk,CountAsk : Integer;

implementation

{$R *.lfm}

{ TFrmJorn }

procedure TFrmJorn.btnReloadTreeClick(Sender: TObject);
begin
   FillTree(cmbTreeTypeView.ItemIndex);
end;

procedure TFrmJorn.btnPrevPgClick(Sender: TObject);
begin
  if Shema.CurrPg=1 then Exit;
  scrlbx1.HorzScrollBar.Position:=0;
  scrlbx1.VertScrollBar.Position:=0;
    Shema.CurrPg:=Shema.CurrPg-1;
    pnlPG.Caption:=IntToStr(Shema.CurrPg)+' страница из '+IntToStr(Shema.Pcnt);
end;

procedure TFrmJorn.btnNextPgClick(Sender: TObject);
begin
  if Shema.CurrPg=Shema.Pcnt then Exit;
  scrlbx1.HorzScrollBar.Position:=0;
  scrlbx1.VertScrollBar.Position:=0;
    Shema.CurrPg:=Shema.CurrPg+1;
    pnlPG.Caption:=IntToStr(Shema.CurrPg)+' страница из '+IntToStr(Shema.Pcnt);
end;

procedure TFrmJorn.btnNextAskClick(Sender: TObject);
begin
  if CurAsk< (CountAsk-1) then Inc(CurAsk);
  FillScheme(RepAll.RepPack[CurAsk]);
end;

procedure TFrmJorn.btnPrevAskClick(Sender: TObject);
begin
  if CurAsk> 0 then Dec(CurAsk);
  FillScheme(RepAll.RepPack[CurAsk]);
end;

procedure TFrmJorn.Button1Click(Sender: TObject);
//{$ifndef NoMetaFile}
//var
//{$ifdef UseOldPreviewForm}
//  pf: TPreviewForm;
//{$else UseOldPreviewForm}
//  pf: TBegaHtmlPrintPreviewForm;
//{$endif UseOldPreviewForm}
//  Abort: Boolean;
begin
//{$ifdef UseOldPreviewForm}
//  pf := TPreviewForm.CreateIt(Self, Viewer, Abort);
//{$else UseOldPreviewForm}
//  pf := TBegaHtmlPrintPreviewForm.Create(Self);
//  pf.HtmlViewer := HTMvw;
//  Abort := False;
//{$endif UseOldPreviewForm}
//  try
//    if not Abort then
//      pf.Position:=poScreenCenter;
//      pf.ShowModal;
//  finally
//    pf.Free;
//  end;
//{$else !NoMetaFile}
//begin
//{$endif !NoMetaFile}
end;

procedure TFrmJorn.Button2Click(Sender: TObject);

  procedure FillTreeSub(trSc:TdSubs;trvNode : TTreeNode;trvw : TTreeView );
  var j : Integer;
    tn : TTreeNode;
  begin
    for j := 0 to Pred(trSc.Count) do begin
      if trvNode=nil then
      begin
        tn := trvw.Items.AddChild(trvNode,IntToStr(trSc[j].IDt)+';'+IntToStr(trSc[j].AppIdt)+';'+IntToStr(trSc[j].IndInG)+';'+trSc[j].Name)
      end
      else
        tn := trvNode.TreeNodes.AddChild(trvNode,IntToStr(trSc[j].IDt)+';'+IntToStr(trSc[j].AppIdt)+';'+IntToStr(trSc[j].IndInG)+trSc[j].Name);
      tn.Data:=trSc[j];
      FillTreeSub(trSc[j].Subs,tn,trvw);
    end;
  end;

begin
  trSub.Items.Clear;
  TreeSub := DBToTreeSub(chckLost.Checked,not chckDis.Checked,'Tasks');
  if TreeSub=nil then Exit;

  if frTopic<>nil then frTopic.Free;
  frTopic := TFrameTopic.Create(pnlTopic);
  frTopic.TreeSub:=TreeSub;
  frTopic.Parent := pnlTopic;
  frTopic.Align:= alClient;
  frTopic.Init;

  FillTreeSub(TreeSub,nil,trSub);

end;

procedure TFrmJorn.Button3Click(Sender: TObject);
begin
  //FormStartEditor.Show;
end;


procedure TFrmJorn.XML2Tree(tree: TTreeView; XMLDoc: TDOMNode);
var
  j: Integer;

  procedure AddNodes(Child: TTreeNode; aNode: TDOMNode);
  var i: Integer;
    s : String;
  begin
    if (aNode.NodeName = 'xml') or (aNode.NodeName = '#text') then Exit;
    s := aNode.NodeName+': '+ aNode.ChildNodes[0].NodeValue;
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

procedure TFrmJorn.ButtonToTreeClick(Sender: TObject);
var tss : TStringStream;
    s : String;
begin
  try
    s:= SynEdit1.Lines.Text;
    tss := TStringStream.Create(s);
    ReadXMLFile(FDoc, tss);
    XML2Tree(trvXML,FDoc);
  finally
    tss.Free;
  end;
end;

procedure TFrmJorn.FormActivate(Sender: TObject);
begin
  FillTree(cmbTreeTypeView.ItemIndex);
end;

procedure TFrmJorn.FormCreate(Sender: TObject);
var logstr,pth : string;
    tpDB : TDataBaseType;
begin
 pth:= ExtractFilePath(Application.ExeName);
 rOptions := TrOptions.Create(pth);
  grdAsks.RowHeights[0]:= 20;
  grdAsks.Rows[0].Text:='№'+#13+'Вид'+#13+'Наименование';
  grdAsks.ColWidths[0]:= 50;
  grdAsks.ColWidths[1]:= 70;
  grdAsks.ColWidths[2]:= 500;
  grdAsks.RowCount:=1;

  HTMvw := THtmlViewer.Create(PanelHtml);
  HTMvw.Parent:=PanelHtml;
  HTMvw.SetBounds(0,0,PanelHtml.Width,PanelHtml.Height);
  HTMvw.Align:=alClient;
  HTMvw.Visible:=True;
  HTMvw.Color:=clWhite;
  HTMvw.DefBackground:=clWhite;
  tpDB := dbtSQLite;
  ConnectDB(rOptions);

  cmbxTRep.Clear;
  cmbxTRep.Items.Add('Без примечания и комментариев');
  cmbxTRep.Items.Add('Свой ответ в действие+Примечания');
  cmbxTRep.Items.Add('Свой ответ как комментарий');
  cmbxTRep.Items.Add('Св. отв. как комментарий+Примечания');
  cmbxTRep.ItemIndex:=0;

  cmbTreeTypeView.Clear;
  cmbTreeTypeView.Items.Add('Дата,записи');
  cmbTreeTypeView.Items.Add('Дата,ФИО,записи');
  cmbTreeTypeView.Items.Add('Группы,ФИО,записи');
  cmbTreeTypeView.ItemIndex:=0;

end;

procedure TFrmJorn.FormDestroy(Sender: TObject);
begin
  if Assigned(AskObject) then AskObject.Free;
end;

procedure TFrmJorn.ListBoxAskClick(Sender: TObject);
begin
  CurAsk :=ListBoxAsk.ItemIndex;
  FillScheme(rRepAsk(ListBoxAsk.Items.Objects[CurAsk]));
end;

procedure TFrmJorn.trSubChange(Sender: TObject; Node: TTreeNode);
var ds : TdSub;
    ZQueryAsk : TZQuery;
    s : String;
begin

  //SELECT Tasks.IDt, Asks.AskType, Asks.IDv, Asks.Ask
  //FROM (Tasks INNER JOIN QuestionForTask ON Tasks.IDt = QuestionForTask.IDt) INNER JOIN Asks ON QuestionForTask.IDv = Asks.IDv;

  //SELECT Tasks.IDt, QuestionForTask.IDa, QuestionForTask.Nask, QuestionForTask.IDv
  //  FROM Tasks INNER JOIN QuestionForTask ON Tasks.IDt = QuestionForTask.IDt
  // ORDER BY Tasks.IDt,
  //          QuestionForTask.IDa,
  //          QuestionForTask.Nask;
  if Node =nil then exit;
  if Node.Data =nil then exit;
  ds := TdSub(Node.Data);

    try
      ZQueryAsk := TZQuery.Create(nil);
      ZQueryAsk.Connection := DBcon;//
      ZQueryAsk.SQL.Clear;

      ZQueryAsk.SQL.Add('SELECT QuestionForTask.Nask, Tasks.IDt, Asks.AskType, Asks.IDv, Asks.Ask');
      ZQueryAsk.SQL.Add('FROM (Tasks INNER JOIN QuestionForTask ON Tasks.IDt = QuestionForTask.IDt) INNER JOIN Asks ON QuestionForTask.IDv = Asks.IDv');
      ZQueryAsk.SQL.Add('WHERE Tasks.IDt='+IntToStr(ds.IDt));
      ZQueryAsk.SQL.Add('ORDER BY QuestionForTask.Nask;');

      //ZQueryAsk.SQL.Add('SELECT Tasks.IDt, QuestionForTask.IDa, QuestionForTask.Nask, QuestionForTask.IDv');
      //ZQueryAsk.SQL.Add('FROM Tasks INNER JOIN QuestionForTask ON Tasks.IDt = QuestionForTask.IDt');
      //ZQueryAsk.SQL.Add('WHERE Tasks.IDt='+IntToStr(ds.IDt));
      //ZQueryAsk.SQL.Add('ORDER BY QuestionForTask.Nask;');
      ZQueryAsk.Active:=True;
      lstAsks.Clear;
      ZQueryAsk.First;
      while not ZQueryAsk.EOF do begin
        s := CP1251ToUTF8(ZQueryAsk.FieldByName('Ask').AsString);
        lstAsks.Items.Add(ZQueryAsk.FieldByName('Nask').AsString+';'
                        +ZQueryAsk.FieldByName('IDt').AsString+';'
                        +ZQueryAsk.FieldByName('AskType').AsString+';'
                        +ZQueryAsk.FieldByName('IDv').AsString+';'
                        +s);
      ZQueryAsk.Next;
    end;
    finally
      ZQueryAsk.Free;
    end;

end;

procedure TFrmJorn.trSubClick(Sender: TObject);
begin

end;

procedure TFrmJorn.tvJrChange(Sender: TObject; Node: TTreeNode);
begin
//  tvJrClick(Sender);
end;

procedure TFrmJorn.tvJrClick(Sender: TObject);
var recD : TrRecDiary;
    s : String; i : Integer;
    Ss: TStringStream;
    strL : TStringList;
begin
  if not Assigned(tvJr.Selected.Data) then Exit;
  if TObject(tvJr.Selected.Data).ClassName = 'TrRecDiary' then begin
    recD := TrRecDiary(tvJr.Selected.Data);
    SynEdit1.Lines.Text:=recD.XML;
    if recD.XML='' then Exit;
    s := XMLToHTML(recD,cmbxTRep.ItemIndex);
    HTMvw.LoadFromString(s);
    if RepAll<>nil then RepAll.Free;
    RepAll:=TRepAll.Create(nil);
    try
      s := recD.XML;
      RepAll.DeSerialize(s);
    finally
    end;
    grdAsks.RowCount:=RepAll.RepPack.Count+1;
    for i:=1 to RepAll.RepPack.Count do
      grdAsks.Rows[i].Text := IntToStr(i)+#13+IntToStr(RepAll.RepPack.Items[i-1].AskType)+#13+RepAll.RepPack.Items[i-1].Ask;
//    ListBoxAsk.ItemIndex:=0;

      ListBoxAsk.Clear;
    CurAsk := 0; CountAsk := RepAll.RepPack.Count;
    for i:=0 to RepAll.RepPack.Count-1 do
      ListBoxAsk.AddItem(RepAll.RepPack.Items[i].Ask,RepAll.RepPack.Items[i]);
    ListBoxAsk.ItemIndex:=0;
    FillScheme(rRepAsk(ListBoxAsk.Items.Objects[ListBoxAsk.ItemIndex]));
  end;
end;

procedure TFrmJorn.FillScheme(RepAsk : rRepAsk);
var s : String; i : Integer;
  Sh : TShema;
  Ss: TStringStream;
  strL : TStringList;
  tblAsks : TZQuery;
begin
  if CurAsk = (CountAsk-1) then btnNextAsk.Enabled:=False
     else  btnNextAsk.Enabled:=True;
  if CurAsk = 0 then btnPrevAsk.Enabled:=False
     else  btnPrevAsk.Enabled:=True;

  lblCntAsk1.Caption:= IntToStr(CurAsk+1) +'/'+inttoStr(CountAsk);
  SynEditSh.Clear;

  tblAsks := TZQuery.Create(nil);
  tblAsks.Connection := DBcon;
  tblAsks.SQL.Add('Select * From Asks Where idv = ' +inttostr(RepAsk.idAsk)+';');
  tblAsks.Active:=True;
  strL := TStringList.Create;
  strL.Text:=CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  s:= CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  if s='' then Exit;

  if Assigned(AskObject) then AskObject.Free;
  AskObject := TAskObject.Create;
  AskObject.CurAsk := 0;
  AskObject.CurRepAsk:=RepAll.RepPack[AskObject.CurAsk];
  AskObject.DBTypeAsk:=tblAsks.FieldByName('AskType').AsInteger;
  AskObject.DBTypeAsk:=RepAll.RepPack[AskObject.CurAsk].AskType;
  AskObject.CountAsk := RepAll.RepPack.Count;
  AskObject.Init(PanShWorkArea,s,false);

  SynEditSh.Lines.Text := AskObject.ShemaText.Text;
  Sh := AskObject.Shema;
  PanShWorkArea2.Canvas.Clear;
  tblAsks.Free;
end;

procedure TFrmJorn.FillTree(tp: Integer);
var trItGr,trItPup,trItRecD,trIt1,trIt2,trIt3 : TTreeNode;
  Qp1,Qp2,Qp3,QPupils : TZQuery;// TDataSet;
  gr : TrGroupP; pup : TrPupil; recD : TrRecDiary;
  a : Integer;
  sd,st,sg,sdv,s,sF : string;

begin
  tvJr.Items.Clear;
  //ZConnection1.Database:='dsgn.db3';
  //ZConnection1.Connected:=True;
  Qp1 := TZQuery.Create(nil);
  Qp2 := TZQuery.Create(nil);
  Qp3 := TZQuery.Create(nil);
  QPupils := TZQuery.Create(nil);
  Qp1.Connection := DBcon;
  Qp2.Connection := DBcon;
  Qp3.Connection := DBcon;
  QPupils.Connection := DBcon;


//sd :=DBConnections.SQLFieldName('Data');
//st :=DBConnections.SQLFieldName('Time');
//sg :=DBConnections.SQLFieldName('group');
  sd :='[Data]';
  st :='[Time]';
  sg :='[group]';
  try
    case tp of
      0: begin             //Дата,записи
//        Qp1 := DBConnections.QueryCreate('Select distinct Diary.Data from Diary order by '+sd+';');

        Qp1.SQL.Add('Select distinct Diary.[Data] from Diary order by '+sd+';');
        Qp1.Open;
        //
        //QPupils := DBConnections.QueryCreate('Select distinct Pupils.* from Pupils;');
        QPupils.SQL.Add('Select distinct Pupils.* from Pupils;');
        QPupils.Open;
        while not Qp1.Eof do begin
          trIt1 := tvJr.Items.AddChild(nil,Qp1.FieldByName('Data').AsString);
          if Qp2<>nil then Qp2.Free;
          Qp2 := TZQuery.Create(nil);
          Qp2.Connection := DBcon;//ZConnection1;

          sdv := Qp1.FieldByName('Data').AsString;
        //  Qp2 := DBConnections.QueryCreate('Select Diary.* from Diary where '+sd+' = "'+
        //     DBConnections.Data2SQLstr(Qp1.FieldByName('Data'))+'" order by '+sd+','+st+';');
          if sdv='' then
             sdv := '0000-00-00'
            else
              sdv := FormatDateTime('yyyy-mm-dd', Qp1.FieldByName('Data').AsDateTime);
        s := 'Select Diary.* from Diary where '+sd+' = "'+ sdv+ ' 00:00:00.000'+ '" order by ' +st+';';
        Qp2.SQL.Add(s);
        Qp2.Active:=True;
          Qp2.First;

          while not Qp2.Eof do begin
        //    QPupils := DBConnections.QueryCreate('Select distinct Pupils.* from Pupils where IDschool = '+Qp2.FieldByName('IDschool').AsString+';');
            s := Qp2.FieldByName('IDschool').AsString;
            if QPupils<>nil then QPupils.Free;
            QPupils := TZQuery.Create(nil);
            QPupils.Connection := DBcon;//ZConnection1;
            QPupils.SQL.Add('Select distinct Pupils.* from Pupils where IDschool = '+s+';');
            QPupils.Open;
            sF := QPupils.FieldByName('Family').AsString;
            trIt2 := tvJr.Items.AddChild(trIt1,Qp2.FieldByName('Time').AsString+' '+sF);
            recD := SetRecD(Qp2,QPupils);
            trIt2.Data := recD;
            Qp2.Next;
          end;
          Qp1.Next;
        end;
        end;
      end;
      //1: begin             //Дата,ФИО,записи
      //  Qp1 := DBConnections.QueryCreate('Select distinct Diary.Data from Diary order by '+sd+';');
      //  while not Qp1.Eof do begin
      //    trIt1 := tvJr.Items.AddChild(nil,Qp1.FieldByName('Data').AsString);
      //    QPupils := DBConnections.QueryCreate('select distinct Diary.IDschool, Pupils.*'+
      //    ' from Diary inner join Pupils on (Diary.IDschool = Pupils.IDschool)'+
      //    ' where (Diary.Data ="'+DBConnections.Data2SQLstr(Qp1.FieldByName('Data'))+'") order by Pupils.Family;');
      //    while not QPupils.Eof do begin
      //      trIt2 := tvJr.Items.AddChild(trIt1, QPupils.FieldByName('Family').AsString);
      //      if Qp2<>nil then Qp2.Free;
      //      Qp2 := DBConnections.QueryCreate('Select Diary.* from Diary where ('+sd+' = "'+
      //       DBConnections.Data2SQLstr(Qp1.FieldByName('Data'))+'") and (IDschool = '+
      //        QPupils.FieldByName('IDschool').AsString+') order by '+sd+','+st+';');
      //      while not Qp2.Eof do
      //      begin
      //        trIt3 := tvJr.Items.AddChild(trIt2, Qp2.FieldByName('Time').AsString);
      //        recD := SetRecD(Qp2,QPupils);
      //        trIt3.Data := recD;
      //        Qp2.Next;
      //      end;
      //      QPupils.Next;
      //    end;
      //    Qp1.Next;
      //  end;
      //end;
      //2: begin              //Группы,ФИО,записи
      //  QPupils := DBConnections.QueryCreate('Select distinct Pupils.[group] from Pupils order by '+sg+';');
      //  while not QPupils.Eof do begin
      //    trItGr := tvJr.Items.AddChild(nil,QPupils.FieldByName('group').AsString);
      //    gr := TrGroupP.Create; gr.group :=QPupils.FieldByName('group').AsString;
      //    trItGr.Data := gr;
      //    if Qp1<>nil then Qp1.Free;
      //    Qp1 := DBConnections.QueryCreate('Select distinct Pupils.Family,Pupils.Doljnost,Pupils.IDschool,Pupils.[group] from Pupils where '+sg+' = "'+QPupils.FieldByName('group').AsString+'" order by Family;');
      //    while not Qp1.Eof do begin
      //      trItPup := tvJr.Items.AddChild(trItGr,Qp1.FieldByName('Family').AsString);
      //      pup := TrPupil.Create;
      //      pup.IDschool:=Qp1.FieldByName('IDschool').AsInteger;
      //      pup.Family:=Qp1.FieldByName('Family').AsString;
      //      pup.group:=Qp1.FieldByName('group').AsString;
      //      trItPup.Data := pup;
      //      if Qp2<>nil then Qp2.Free;
      //      Qp2 := DBConnections.QueryCreate('Select Diary.* from Diary where IDschool = '+ IntToStr(pup.IDschool)+' order by '+sd+','+st+';');
      //      while not Qp2.Eof do begin
      //        recD := SetRecD(Qp2,Qp1);
      //        trItRecD := tvJr.Items.AddChild(trItPup, recD.DataD+' '+recD.TimeD);
      //        trItRecD.Data := recD;
      //        Qp2.Next;
      //      end;
      //      Qp1.Next;
      //    end;
      //    QPupils.Next;
      //  end;
      //end;
    //end;
  finally
    Qp2.Free;
    Qp1.Free;
  end;
end;

end.

