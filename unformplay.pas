unit UnFormPlay;

{$mode Delphi}

interface

uses
  LMessages, LCLIntf, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, LCLType, ComCtrls, LConvEncoding, ZConnection, ZDataset, UtilitiesDB,
  UnOptions, tren,rImgss,unAsk,
  unFrameVideo,unFrameRectAsk, UnFrameTopic,UnTreeTopic,unFormSubsAsks,
  JvTransparentButton, JvPanel, JvgListBox, JvgDigits,unMessage;

type

  { TFormPlay }

  TFormPlay = class(TForm)
    btn3: TJvTransparentButton;
    btn4: TJvTransparentButton;
    btn5: TJvTransparentButton;
    btnButHlp: TJvTransparentButton;
    btnButVv: TJvTransparentButton;
    btnCheck: TJvTransparentButton;
    btnJrnl: TJvTransparentButton;
    btnRem: TJvTransparentButton;
    ButAddSch: TJvTransparentButton;
    ButtonAbout: TJvTransparentButton;
    ButtonClose: TJvTransparentButton;
    ButtonClose1: TJvTransparentButton;
    cmbGroup: TComboBox;
    cmbPupils: TComboBox;
    LED: TJvgDigits;
    jvpnl_bot: TJvPanel;
    btnSelectFAM: TJvTransparentButton;
    JvTransparentButton2: TJvTransparentButton;
    JvTransparentButton3: TJvTransparentButton;
    JvTransparentButton7: TJvTransparentButton;
    JvTransparentButton9: TJvTransparentButton;
    Label1: TLabel;
    LabelTrenFam: TLabel;
    lblCntAsk: TLabel;
    lblInfoPupils: TLabel;
    Memo1: TMemo;
    PageTask: TPage;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel7: TPanel;
    PanShWorkArea: TPanel;
    pnlTopic: TPanel;
    PanFam: TPanel;
    Pan_top: TPanel;
    TimAsk: TTimer;
    WorkPG: TNotebook;
    PagePupils: TPage;
    PageTopic: TPage;
    PanBot: TPanel;
    Panel3: TPanel;
    PanScBut: TPanel;
    procedure btn5Click(Sender: TObject);
    procedure ButAddSchClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure ButtonClose1Click(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure cmbGroupChange(Sender: TObject);
    procedure cmbPupilsChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectFAMClick(Sender: TObject);
    procedure JvTransparentButton9Click(Sender: TObject);
    procedure pnlTopicClick(Sender: TObject);
    procedure TimAskTimer(Sender: TObject);
//    procedure LstTopicDblClick(Sender: TObject);
  private
    procedure SetCmbPupils(fam : String);
    procedure SetCmbGroup(grp : String);
    procedure RunPacket(var Msg: TLMessage); message WM_MY_MESSAGE;
  public
    flDemo : Boolean;
    TreeSub : TdSubs;
    frTopic : TFrameTopic;
    AskObject : TAskObject;
    frAsk : TFrame;
    CurTime : Integer;
    procedure FillScheme(IdAsk : Integer);
  end;

var
  FormPlay: TFormPlay;

implementation
uses unFormNewSc;
{$R *.lfm}

{ TFormPlay }

procedure TFormPlay.FormActivate(Sender: TObject);
var QpGroup : TZQuery;
begin
  SetCmbGroup('');
  SetCmbPupils('');
  WorkPG.PageIndex := 0;
end;

procedure TFormPlay.FormCreate(Sender: TObject);
begin
  CurSession := TrRecDiary.Create;
end;

procedure TFormPlay.FormDestroy(Sender: TObject);
begin
  CurSession.Free;
  if frTopic<>nil then frTopic.Free;
end;

procedure TFormPlay.btnSelectFAMClick(Sender: TObject);
var fam,sq : string;
  QPupilsOne : TZQuery;
begin
    fam:=cmbPupils.Text;
    if fam='' then
    begin
      application.MessageBox('Необходимо зарегистрироваться.','Введите фамилию!',MB_OK);
      exit;
    end
    else
        flDemo:=false;

    sq:='Select distinct Pupils.* from Pupils where Pupils.Family='''+fam +''' ;';
    QPupilsOne := TZQuery.Create(nil);
    QPupilsOne.Connection := DBcon;
    QPupilsOne.SQL.Add(sq);
    QPupilsOne.Open;
    if QPupilsOne.RecordCount=0 then
    begin
      if application.MessageBox('Если Вы впервые, необходимо зарегистрироваться.'+chr(13)+'Да - Зарегистрироваться, Нет - попробовать найти себя в списках.','Внимание!',MB_YESNO)=IDNO then
       exit
      else
      begin
        //FormNewSc.Edfio.Text:=fam;
        //FormNewSc.ShowModal;
        //FillPupils();
        //CmbGrpChange(self);
        //CmbFam.Text:=fam;
        //exit;
      end;
    end
    else
    begin
      CurSession.IDschool:=QPupilsOne.FieldByName('IDschool').AsInteger;
      CurSession.FIO := QPupilsOne.FieldByName('Family').AsString;
      CurSession.Doljnost:= QPupilsOne.FieldByName('Doljnost').AsString;
      CurSession.group:=QPupilsOne.FieldByName('group').AsString;
    end;

    TreeSub := DBToTreeSub(False,True,'Tasks');
    if TreeSub=nil then Exit;

    if frTopic<>nil then frTopic.Free;
    frTopic := TFrameTopic.Create(pnlTopic);
    frTopic.ParentForm := Self;
  //  frTopic.DblClickLst = DblClickLstFP;
    frTopic.TreeSub:=TreeSub;
    //FrameTopic1.TreeSub:=TreeSub;
    //FrameTopic1.Init();
    frTopic.Parent := pnlTopic;
    frTopic.Align:= alClient;
    frTopic.Init;

    WorkPG.PageIndex := 1;
end;

procedure TFormPlay.JvTransparentButton9Click(Sender: TObject);
begin
  WorkPG.PageIndex := 0;
end;

procedure TFormPlay.pnlTopicClick(Sender: TObject);
begin

end;

procedure TFormPlay.TimAskTimer(Sender: TObject);
var hr,mnt : integer; //,rt
    hrs,mnts : string;
begin
    CurTime:=CurTime+1;
    if CurTime<0 then CurTime:=0;
    hr:=CurTime div 60; mnt:=CurTime mod 60;
    hrs:=inttostr(hr);mnts:=inttostr(mnt);
    LED.Value:= hr*100+mnt;
end;


procedure TFormPlay.SetCmbGroup(grp : String);
var QpGroup : TZQuery;
  ind : Integer;
begin
  QpGroup := TZQuery.Create(nil);
  QpGroup.Connection := DBcon;
  QpGroup.SQL.Add('Select DISTINCT Pupils."group" From Pupils Order By "group";');
  QpGroup.Open;
  cmbGroup.Clear; QpGroup.First;
  cmbGroup.Items.Add('<Все>');
  while not QpGroup.Eof do begin
    cmbGroup.Items.Add(QpGroup.FieldByName('group').AsString);
    QpGroup.Next;
  end;
    if grp='' then
      cmbGroup.ItemIndex:=0
    else
    begin
      ind := cmbGroup.Items.IndexOf(grp);
      if ind > -1 Then;
          cmbGroup.ItemIndex := ind;
    end;
  ;
end;

procedure TFormPlay.SetCmbPupils(fam : String);
var QPupils : TZQuery;
  ind : Integer;
begin
  QPupils := TZQuery.Create(nil);
  QPupils.Connection := DBcon;
  if cmbGroup.ItemIndex = 0 Then
    QPupils.SQL.Add('Select distinct Pupils.* from Pupils ORDER BY Family;')
  else
    QPupils.SQL.Add('Select distinct Pupils.* from Pupils WHERE "group"= "'+cmbGroup.Text+'" ORDER BY Family;');
  QPupils.Open;

  cmbPupils.Clear; QPupils.First;
  while not QPupils.Eof do begin
    cmbPupils.Items.Add(QPupils.FieldByName('Family').AsString);
    QPupils.Next;
  end;
  if fam='' then
    cmbPupils.Text := ''
  else
  begin
    ind := cmbPupils.Items.IndexOf(fam);
    if ind > -1 Then;
        cmbPupils.ItemIndex := ind;
  end;
  lblInfoPupils.Caption := cmbPupils.Text;
end;

procedure TFormPlay.cmbGroupChange(Sender: TObject);
begin
  SetCmbPupils('');
end;

procedure TFormPlay.ButAddSchClick(Sender: TObject);
var ind : Integer;
begin
  tmpFam := cmbPupils.Text; tmpGrp := '';
  FormNewSc.ShowModal;
  SetCmbGroup(tmpGrp);
  SetCmbPupils(tmpFam);
end;

procedure TFormPlay.btn5Click(Sender: TObject);
begin
  WorkPG.PageIndex := 1;
end;

procedure TFormPlay.ButtonAboutClick(Sender: TObject);
begin
  WorkPG.PageIndex := 1;
end;

procedure TFormPlay.ButtonClose1Click(Sender: TObject);
begin

end;

procedure TFormPlay.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPlay.cmbPupilsChange(Sender: TObject);
begin
    lblInfoPupils.Caption := cmbPupils.Text;
end;

procedure TFormPlay.RunPacket(var Msg: TLMessage);
var cra : rRepAsk;
    Sh : TShema;
    i, j,cntA,cur, CurIdt : Integer;
    str,backFile : string;
    arrIdAsk : array of Integer;
    QTema, QAsks : TZQuery;
    QuestionsRec : TrQuestionsRec;
    QuestionRec : TrQuestionRec;
    RepAsk : rRepAsk;
begin
  CurIdt := Msg.wParam;
  Panel7.Caption:=IntToStr(Msg.wParam);
  //QTema := TZQuery.Create(nil);
  //QTema.Connection = DBcon;
  //QTema.SQL.Text:='Select Asks.* From Asks Where Asks.Idt='+inttostr(CurIdt)+' Order by Seq;';
  //FillScheme(Msg.wParam);
  //PanFam.Caption:=QPupilsOne.FieldByName('Family').AsString+'   '+QPupilsOne.FieldByName('Doljnost').AsString;
  LabelTrenFam.Caption:=CurSession.FIO+'  '+CurSession.Doljnost;
  WorkPG.PageIndex := 2;

  QuestionsRec := GetQuestionsIDT(CurIdt);
  if QuestionsRec.Count>0 then
  begin
    if RepAll<>nil then RepAll.Free;
    RepAll:=TRepAll.Create(nil);
    DateTimeToString(backFile, 'dd_mm_yyyy hh_mm_ss', Now);
    RepAll.FileNameForSaveLocal := rOptions.DirLogLocal+'\'+backFile+' '+IntToStr(CurSession.IDschool)+'.xml';
    RepAll.CurSc := CurSession.IDschool;
    DateTimeToString(backFile, 'dd/mm/yyyy hh:mm:ss', Now);
    RepAll.Start := backFile;
    RepAll.NameCurSc := CurSession.FIO;
    RepAll.DoljnostCurSc := CurSession.Doljnost;
    RepAll.CurGroup := CurSession.group;
    RepAll.IDt := CurSession.IDt;
    RepAll.CurAsk := QuestionsRec[0].IDv;
    //RepAll.TmPack:=0;  flTimeNoCheck:=False;

    QuestionRec := QuestionsRec[0];
    RepAsk := RepAll.RepPack.Add;
    RepAsk.idAsk:=QuestionsRec[0].IDv;
    FillScheme(QuestionsRec[0].IDv);


  end;
  exit;

  QAsks.Active:=true;
  //CountAsk:=QAsks.RecordCount;cntA:=CountAsk;
  //CurAsk:=CurAsk+1;
  if RepAll<>nil then RepAll.Free;
  RepAll:=TRepAll.Create(Self);
  //if CurSubRem='' then RepAll.Name:= CurSubName
  //else RepAll.Name:= CurSubRem;

//  TimAsk.
end;

procedure TFormPlay.FillScheme(IdAsk : Integer);
var s : String; i : Integer;
  Sh : TShema;
  Ss: TStringStream;
  strL : TStringList;
  tblAsks : TZQuery;
begin
  //if CurAsk = (CountAsk-1) then btnNextAsk.Enabled:=False
  //   else  btnNextAsk.Enabled:=True;
  //if CurAsk = 0 then btnPrevAsk.Enabled:=False
  //   else  btnPrevAsk.Enabled:=True;

  //lblCntAsk1.Caption:= IntToStr(CurAsk+1) +'/'+inttoStr(CountAsk);
  //SynEditSh.Clear;

  tblAsks := TZQuery.Create(nil);
  tblAsks.Connection := DBcon;
  tblAsks.SQL.Add('Select * From Asks Where idv = ' +inttostr(idAsk)+';');
  tblAsks.Active:=True;
  //strL := TStringList.Create;
  //strL.Text:=CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  Memo1.Lines.Text:=tblAsks.FieldByName('XMLProp').AsString;
  s:= CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  if s='' then Exit;

  if Assigned(AskObject) then AskObject.Free;
  AskObject := TAskObject.Create;
  AskObject.CurAsk := 0;
  AskObject.CurRepAsk:=RepAll.RepPack[AskObject.CurAsk];
  //CurRepAsk:=RepAll.RepPack.Add;
  AskObject.CurRepAsk.idAsk:=tblAsks.FieldByName('IDv').AsInteger;
  AskObject.CurRepAsk.AskType:=tblAsks.FieldByName('AskType').AsInteger;
  AskObject.DBTypeAsk:=tblAsks.FieldByName('AskType').AsInteger;
  //AskObject.DBTypeAsk:=RepAll.RepPack[AskObject.CurAsk].AskType;
  AskObject.CountAsk := RepAll.RepPack.Count;
  AskObject.Init(PanShWorkArea,s,false);
  //
  //Sh := AskObject.Shema;
  tblAsks.Free;
end;

end.

