unit UtilitiesDB;

{$mode Delphi}

interface

uses
  SysUtils,LConvEncoding, Variants, Classes, StdCtrls,ExtCtrls, DB, ZConnection, ZDataset,
  UnOptions, tren,rImgss,Utils,UnTreeTopic, unAsk;

type
  {Типы баз данных}
  TDataBaseType = (dbtABS, dbtMySQL, dbtPGRES,dbtMSSQL,dbtSQLite,dbtADO);

function ConnectDB(rOptions:TrOptions) : Boolean;       // tpDB:TDataBaseType;
function GetShemaDB(idv : Integer): TShema;
function DBToTreeSub(fLost,fDis : Boolean; tName : String): TdSubs;
function GetAsksIDT(idt : Integer) : TrAsksRec;
function GetQuestionsIDT(idt : Integer) : TrQuestionsRec;
function DBToAskObject(idv : Integer; parent : TPanel; flEd:Boolean) : TAskObject;

function SetRecD(qd,qp:TDataSet): TrRecDiary;

var DBcon : TZConnection;

implementation


function ConnectDB(rOptions:TrOptions) : Boolean;    //    tpDB:TDataBaseType;
begin
  if Assigned(DBcon) then DBcon.Free;
  try
    DBcon := TZConnection.Create(nil);
    DBcon.Name:= 'DBcon';
    DBcon.Catalog:='main';
//    DBcon.ControlsCodePage:= cCP_UTF8;
//    DBcon.Protocol:= 'sqlite-3';
    DBcon.Protocol:= 'sqlite';
    DBcon.ClientCodepage:='UTF-8';
    DBcon.Database:=rOptions.PathDB;
    DBcon.Connected:= True;
    Result:= True;
  except
    Result:= false;
  end;
end;

function DBToTreeSub(fLost,fDis : Boolean; tName : String): TdSubs;
var recSub : TrecSub;
    ZQueryTopic : TZQuery;
    TreeSub : TdSubs;
    dSub : TdSub;
    i,j,appidt,idt : Integer;
    s : string;
    ft : TFieldType;
begin
  try
    Result := nil;
    ZQueryTopic := TZQuery.Create(nil);
    ZQueryTopic.Connection := DBcon;
    ZQueryTopic.SQL.Text := 'Select * From '+tName+' Order By AppIdt, IndInG';
    ZQueryTopic.Active:=True;
//    if TreeSub <> nil then TreeSub.Free;
    TreeSub := TdSubs.Create(TdSub);
    TreeSub.RootSubs:=TreeSub;
    ZQueryTopic.First;
    while not ZQueryTopic.EOF do begin
      recSub.IDt:=ZQueryTopic.FieldByName('IDt').AsInteger;
      if recSub.IDt = 1 then
          recSub.IDt:=recSub.IDt;
      recSub.AppIdt:=ZQueryTopic.FieldByName('AppIdt').AsInteger;
//      ft := ZQueryTopic.FieldByName('Disable').DataType;
//      s := ZQueryTopic.FieldByName('Disable').AsString;
     recSub.Disable:=ZQueryTopic.FieldByName('Disable').AsBoolean;
      recSub.IndInG:=ZQueryTopic.FieldByName('IndInG').AsInteger;
      recSub.Name:=CP1251ToUTF8(ZQueryTopic.FieldByName('Name').AsString);
      recSub.Rem:=CP1251ToUTF8(ZQueryTopic.FieldByName('Rem').AsString);
      TreeSub.AddRecord(recSub,fLost,fDis);
      ZQueryTopic.Next;
    end;
    j := Pred(TreeSub.RootSubs.Count);
    i := 0;
    while i<TreeSub.RootSubs.Count do
    begin
      idt := TreeSub.RootSubs[i].Idt;
     appidt := TreeSub.RootSubs[i].AppIdt;
     if appidt>0 then
     begin
       dSub := TreeSub.GetNodeIdt(appidt,nil);
       if dSub<>nil then
         TreeSub.RootSubs[i].Collection := dSub.Subs
       else Inc(i);
     end
     else Inc(i);
    end;
  finally
     ZQueryTopic.Free;
     Result := TreeSub;
  end;
end;

function GetShemaDB(idv : Integer): TShema;
var
  tblAsks : TZQuery;
  s : String;
begin
  tblAsks := TZQuery.Create(nil);
  tblAsks.Connection := DBcon;
  tblAsks.SQL.Add('Select * From Asks Where idv = ' +inttostr(idv)+';');
  tblAsks.Active:=True;
//        s:=tblAsks.FieldByName('XMLProp').AsString;
  s:=CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  Result:=TShema.Create(nil);
  Result.flDsrForRp:=True;

  try
    Result.DeSerialize(s);
  finally
  end;
end;

function GetAsksIDT(idt : Integer) : TrAsksRec;
var ZQueryAsks : TZQuery;
    AsksRec : TrAsksRec;
    AskRec : TrAskRec;
    s : String;
begin
  try
    Result := nil;
    ZQueryAsks := TZQuery.Create(nil);
    ZQueryAsks.Connection := DBcon;
    s := 'Select * From Asks Where IDt = '+IntToStr(idt)+' Order By Seq;';
    ZQueryAsks.SQL.Text := s;
    ZQueryAsks.Active:=True;

    AsksRec := TrAsksRec.Create(TrAskRec);
    ZQueryAsks.First;
    while not ZQueryAsks.EOF do begin
      AskRec := AsksRec.Add;
      AskRec.IDv:=ZQueryAsks.FieldByName('IDv').AsInteger;
      AskRec.IDt:=ZQueryAsks.FieldByName('IDt').AsInteger;
      AskRec.IDh:=ZQueryAsks.FieldByName('IDh').AsInteger;
      AskRec.AskType:=ZQueryAsks.FieldByName('AskType').AsInteger;
      AskRec.Ask:=CP1251ToUTF8(ZQueryAsks.FieldByName('Ask').AsString);
      AskRec.PropAsk:=CP1251ToUTF8(ZQueryAsks.FieldByName('PropAsk').AsString);
      AskRec.Pages:=ZQueryAsks.FieldByName('Pages').AsInteger;
      AskRec.NumbRightAns:=ZQueryAsks.FieldByName('NumbRightAns').AsInteger;
      AskRec.ExeFile:=CP1251ToUTF8(ZQueryAsks.FieldByName('ExeFile').AsString);
      AskRec.Extended:=CP1251ToUTF8(ZQueryAsks.FieldByName('Extended').AsString);
      AskRec.PictureAsk:=CP1251ToUTF8(ZQueryAsks.FieldByName('PictureAsk').AsString);
      AskRec.PictureWork:=CP1251ToUTF8(ZQueryAsks.FieldByName('PictureWork').AsString);
      AskRec.ExtReaction:=ZQueryAsks.FieldByName('ExtReaction').AsBoolean;
      AskRec.UseDDE:=ZQueryAsks.FieldByName('UseDDE').AsBoolean;
      AskRec.UseShWnd:=ZQueryAsks.FieldByName('UseShWnd').AsBoolean;
      AskRec.Seq:=ZQueryAsks.FieldByName('Seq').AsInteger;
      AskRec.UseWinhelp:=ZQueryAsks.FieldByName('UseWinhelp').AsBoolean;
      AskRec.Ball:=ZQueryAsks.FieldByName('Ball').AsFloat;
      AskRec.Rem1:=CP1251ToUTF8(ZQueryAsks.FieldByName('Rem1').AsString);
      AskRec.Rem2:=CP1251ToUTF8(ZQueryAsks.FieldByName('Rem2').AsString);
      AskRec.Disable:=ZQueryAsks.FieldByName('Disable').AsBoolean;
      AskRec.TimeA:=ZQueryAsks.FieldByName('TimeA').AsInteger;
      AskRec.DisTime:=ZQueryAsks.FieldByName('DisTime').AsBoolean;
      AskRec.DisMyAns:=ZQueryAsks.FieldByName('DisMyAns').AsBoolean;
      AskRec.DisQueryAns:=ZQueryAsks.FieldByName('DisQueryAns').AsBoolean;
      AskRec.BallMyAns:=ZQueryAsks.FieldByName('BallMyAns').AsFloat;
      AskRec.idRobj:=ZQueryAsks.FieldByName('idRobj').AsInteger;
      AskRec.XMLProp:=CP1251ToUTF8(ZQueryAsks.FieldByName('XMLProp').AsString);
      ZQueryAsks.Next;
    end;
  finally
     ZQueryAsks.Free;
     Result := AsksRec;
  end;
end;

function GetQuestionsIDT(idt : Integer) : TrQuestionsRec;
var ZQueryQuestions : TZQuery;
    QuestionsRec : TrQuestionsRec;
    QuestionRec : TrQuestionRec;
    s : String;
begin
  try
    Result := nil;
    ZQueryQuestions := TZQuery.Create(nil);
    ZQueryQuestions.Connection := DBcon;
    s := 'select QuestionForTask.IDa,QuestionForTask.IDv,QuestionForTask.IDt,QuestionForTask.Nask,QuestionForTask.IdPatern, QuestionForTask.XMLProp as XMLPropQ, Asks.*';
    s := s+'from QuestionForTask inner join Asks on (QuestionForTask.IDv = Asks.IDv)';
    s := s+'where (QuestionForTask.IDt = '+IntToStr(idt)+');';
//    s := 'Select * From Asks Where IDt = '+IntToStr(idt)+' Order By Seq;';
    ZQueryQuestions.SQL.Text := s;
    ZQueryQuestions.Active:=True;

    QuestionsRec := TrQuestionsRec.Create(TrQuestionRec);
    ZQueryQuestions.First;
    while not ZQueryQuestions.EOF do begin
      QuestionRec := QuestionsRec.Add;
      QuestionRec.IDa:=ZQueryQuestions.FieldByName('IDa').AsInteger;
      QuestionRec.IDv:=ZQueryQuestions.FieldByName('IDv').AsInteger;
      QuestionRec.IDt:=ZQueryQuestions.FieldByName('IDt').AsInteger;
      QuestionRec.Nask:=ZQueryQuestions.FieldByName('Nask').AsInteger;
      QuestionRec.IdPatern:=ZQueryQuestions.FieldByName('IdPatern').AsInteger;
      QuestionRec.XMLPropQ:=CP1251ToUTF8(ZQueryQuestions.FieldByName('XMLPropQ').AsString);
      QuestionRec.IDh:=ZQueryQuestions.FieldByName('IDh').AsInteger;
      QuestionRec.AskType:=ZQueryQuestions.FieldByName('AskType').AsInteger;
      QuestionRec.Ask:=CP1251ToUTF8(ZQueryQuestions.FieldByName('Ask').AsString);
      QuestionRec.PropAsk:=CP1251ToUTF8(ZQueryQuestions.FieldByName('PropAsk').AsString);
      QuestionRec.Pages:=ZQueryQuestions.FieldByName('Pages').AsInteger;
      QuestionRec.NumbRightAns:=ZQueryQuestions.FieldByName('NumbRightAns').AsInteger;
      QuestionRec.ExeFile:=CP1251ToUTF8(ZQueryQuestions.FieldByName('ExeFile').AsString);
      QuestionRec.Extended:=CP1251ToUTF8(ZQueryQuestions.FieldByName('Extended').AsString);
      QuestionRec.PictureAsk:=CP1251ToUTF8(ZQueryQuestions.FieldByName('PictureAsk').AsString);
      QuestionRec.PictureWork:=CP1251ToUTF8(ZQueryQuestions.FieldByName('PictureWork').AsString);
      QuestionRec.ExtReaction:=ZQueryQuestions.FieldByName('ExtReaction').AsBoolean;
      QuestionRec.UseDDE:=ZQueryQuestions.FieldByName('UseDDE').AsBoolean;
      QuestionRec.UseShWnd:=ZQueryQuestions.FieldByName('UseShWnd').AsBoolean;
      QuestionRec.Seq:=ZQueryQuestions.FieldByName('Seq').AsInteger;
      QuestionRec.UseWinhelp:=ZQueryQuestions.FieldByName('UseWinhelp').AsBoolean;
      QuestionRec.Ball:=ZQueryQuestions.FieldByName('Ball').AsFloat;
      QuestionRec.Rem1:=CP1251ToUTF8(ZQueryQuestions.FieldByName('Rem1').AsString);
      QuestionRec.Rem2:=CP1251ToUTF8(ZQueryQuestions.FieldByName('Rem2').AsString);
      QuestionRec.Disable:=ZQueryQuestions.FieldByName('Disable').AsBoolean;
      QuestionRec.TimeA:=ZQueryQuestions.FieldByName('TimeA').AsInteger;
      QuestionRec.DisTime:=ZQueryQuestions.FieldByName('DisTime').AsBoolean;
      QuestionRec.DisMyAns:=ZQueryQuestions.FieldByName('DisMyAns').AsBoolean;
      QuestionRec.DisQueryAns:=ZQueryQuestions.FieldByName('DisQueryAns').AsBoolean;
      QuestionRec.BallMyAns:=ZQueryQuestions.FieldByName('BallMyAns').AsFloat;
      QuestionRec.idRobj:=ZQueryQuestions.FieldByName('idRobj').AsInteger;
      QuestionRec.XMLProp:=CP1251ToUTF8(ZQueryQuestions.FieldByName('XMLProp').AsString);
      ZQueryQuestions.Next;
    end;
  finally
     ZQueryQuestions.Free;
     Result := QuestionsRec;
  end;
end;

function DBToAskObject(idv : Integer; parent : TPanel; flEd:Boolean) : TAskObject;
var s : String; i : Integer;
  Sh : TShema;
  Ss: TStringStream;
  strL : TStringList;
  tblAsks : TZQuery;
  ao : TAskObject;
begin
  tblAsks := TZQuery.Create(nil);
  tblAsks.Connection := DBcon;
  tblAsks.SQL.Add('Select * From Asks Where idv = ' +inttostr(IDv)+';');
  tblAsks.Active:=True;
  strL := TStringList.Create;
  strL.Text:=CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  s:= CP1251ToUTF8(tblAsks.FieldByName('XMLProp').AsString);
  if s='' then Exit;

  //if Assigned(ao) then
  //   ao.Free;
  ao := TAskObject.Create;
  ao.CurAsk := 0;
//  ao.CurRepAsk:=RepAll.RepPack[ao.CurAsk];
  ao.DBTypeAsk:=tblAsks.FieldByName('AskType').AsInteger;
//  ao.DBTypeAsk:=RepAll.RepPack[ao.CurAsk].AskType;
//  ao.CountAsk := RepAll.RepPack.Count;
  ao.Init(parent,s,flEd);
  tblAsks.Free;
  Result := ao;
end;

function SetRecD(qd,qp:TDataSet): TrRecDiary;
begin
  if Assigned(qd) then
  Begin
    Result := TrRecDiary.Create;
    Result.ID :=qd.FieldByName('ID').AsInteger;
    Result.IDschool:=qd.FieldByName('IDschool').AsInteger;
    Result.IDj:=qd.FieldByName('IDschool').AsInteger;
    Result.IDask:=qd.FieldByName('IDask').AsInteger;
    Result.TimeRun:=qd.FieldByName('TimeRun').AsInteger;
    Result.IDt:=qd.FieldByName('IDt').AsInteger;
    Result.DataD:=qd.FieldByName('Data').AsString;
    Result.TimeD:=qd.FieldByName('Time').AsString;
    Result.Ball:=qd.FieldByName('Ball').AsFloat;
    Result.MaxBall:=qd.FieldByName('MaxBall').AsFloat;
    Result.Ball1:=qd.FieldByName('Ball1').AsFloat;
    Result.MaxBall1:=qd.FieldByName('MaxBall1').AsFloat;
    Result.XML := CP1251ToUTF8(qd.FieldByName('History').AsString);
  end;
  if not Assigned(qd) then
  Begin
    Result.FIO := qp.FieldByName('Family').AsString;
    Result.Doljnost := qp.FieldByName('Doljnost').AsString;
    Result.group := qp.FieldByName('group').AsString;
  end;
end;

end.

