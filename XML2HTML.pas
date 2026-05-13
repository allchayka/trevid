unit XML2HTML;

interface
uses
  SysUtils,LConvEncoding, Variants, Classes, StdCtrls, UtilitiesDB, tren,rImgss,Utils; // , DB, ZConnection, ZDataset
//  rImgss;

function XMLToHTML(recD : TrRecDiary; TpRep : Integer): string;
  
implementation

function XMLToHTML(recD : TrRecDiary; TpRep : Integer) : string;
var i,i1,j,k,k3,cntNewGr,AskType,f,m,a,a1,m1 : integer;
    s,st,st1,st2,st3,st4,stNo,stB,stAns,stMyAns,Doljnost,cr : string;
    MyList: TStringList;
    arrIdGrR : array [0..200] of integer;
    flnewGr: boolean;
    MaxBallPack,MnBallPack,PlBallPack,BallPack,Btmp,Ball : Extended;
    Sh : TShema;
    Ss: TStringStream;
    AnsIR : TrAnsvInRep;
    RepAll : TRepAll;
    strL : TStringList;
//    tblAsks : TZQuery;

  function ChLstToBall() : Extended;
  var k0,k1 : Integer;
      flFnd : Boolean;
  begin
    flFnd:=True;
    for k0 := 0 to RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns.Count-1 do
    begin
      if k0<RepAll.RepPack.Items[i].roAnsT.Items[j].Right then
      begin
        if RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns[k0]='0' then flFnd:=False;
      end
      else
      if RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns[k0]='1' then flFnd:=False;
    end;
    if flFnd then Result:=RepAll.RepPack.Items[i].roAnsT.Items[j].Bl
    else Result:=0;
  end;
begin
  Result := '';
  if recD.XML='' then Exit;
  RepAll := TRepAll.Create(nil);
  try
    cr:=chr(13)+chr(10);
    if RepAll<>nil then RepAll.Free;
    RepAll:=TRepAll.Create(nil);
    try
      strL := TStringList.Create;
      strL.Text:=recD.XML;
      s := strL.Text;
      RepAll.DeSerialize(s);
    finally
      strL.Free;
    end;
    st:='<HTML><HEAD><TITLE></TITLE></HEAD><BODY>';
    st:=st+'<P><FONT size=4>ФИО: <b>'+recD.FIO+'</b></p>';
    if recD.Doljnost<>'' then
        st:=st+'<p><FONT size=4>Должность: <b>'+recD.Doljnost+'</b></FONT><br>';
        st:=st+'<FONT size=3>Группа:<b>'+recD.group+'</b><br>';
        st:=st+'Дата: <b>'+recD.DataD+', '+recD.TimeD+', '+'</b><br>';
        st:=st+'Тема: <b>'+RepAll.Name+'</b><br>';
        st:=st+'Время, затраченное на выполнение задания: <b>'+TimeStr(recD.TimeRun)+'</b></FONT></p>';
        PlBallPack:=0;MaxBallPack:=0;MnBallPack:=0;BallPack:=0; Ball:=0;
    for i:=0 to RepAll.RepPack.Count-1 do begin
      if RepAll.RepPack.Items[i].ModeView>0 then begin
        for j:=0 to RepAll.RepPack.Items[i].roAsk.Count-1 do begin
          if RepAll.RepPack.Items[i].roAsk.Items[j].Bl>0 then PlBallPack:=PlBallPack+RepAll.RepPack.Items[i].roAsk.Items[j].Bl
            else begin
              if RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
                MnBallPack:=MnBallPack+RepAll.RepPack.Items[i].roAsk.Items[j].Bl;
            end;
          if RepAll.RepPack.Items[i].roAsk.Items[j].CurAnsv.Count>5 then
          if RepAll.RepPack.Items[i].roAsk.Items[j].CurAnsv[3]='0' then
            if RepAll.RepPack.Items[i].roAsk.Items[j].CurAnsv[4]='' then MaxBallPack:=MaxBallPack+0
            else MaxBallPack:=MaxBallPack+RepAll.RepPack.Items[i].BallP;
          if RepAll.RepPack.Items[i].roAsk.Items[j].Sl then BallPack:=BallPack+RepAll.RepPack.Items[i].roAsk.Items[j].Bl;
        end;
      end;
      for j:=0 to RepAll.RepPack.Items[i].roAnsT.Count-1 do begin
        if not RepAll.RepPack.Items[i].roAnsT.Items[j].DisJrn then begin
          MaxBallPack:=MaxBallPack+RepAll.RepPack.Items[i].roAnsT.Items[j].Bl;
          Btmp:=ChLstToBall();
          if Btmp<0 then MnBallPack:=MnBallPack+Btmp
            else PlBallPack:=PlBallPack+Btmp;
          BallPack:=BallPack+Btmp;
        end;
      end;
      if RepAll.RepPack.Items[i].Diary.Count>0 then begin
        for j:=0 to RepAll.RepPack.Items[i].Diary.Count-1 do begin
          if RepAll.RepPack.Items[i].Diary.Items[j].Mark<>0 then
          begin
  //          k:=k+1;
            if RepAll.RepPack.Items[i].Diary.Items[j].Mark<0 then MnBallPack:=MnBallPack+RepAll.RepPack.Items[i].Diary.Items[j].Mark
            else PlBallPack:=PlBallPack+RepAll.RepPack.Items[i].Diary.Items[j].Mark;
            Ball:=Ball+RepAll.RepPack.Items[i].Diary.Items[j].Mark;
          end;
        end;
      end;
  //=============Video
        for m:=0 to RepAll.RepPack.Items[i].LstMrk.Count-1 do  //текущая отметка
        begin
          for a:=0 to RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Count-1 do begin //текущий ответ из отметки
            if RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].check=cbChecked then   //если выбран то дальнейшая проверка
            begin
              flnewGr:=True;
              if RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].right then
              begin
                if RepAll.RepPack.Items[i].LstAnsvInRep.Count>0 then
                begin
                  for a1 := 0 to RepAll.RepPack.Items[i].LstAnsvInRep.Count-1 do
                  begin
                    if RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].idV=RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].idV then
                      if RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].right then
                        flnewGr:=False;
                  end;
                end;
              end;
              if flnewGr then
              begin
                Ball:=Ball+RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].ball;
                if RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].ball<0 then MnBallPack:=MnBallPack+RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].ball
                  else PlBallPack:=PlBallPack+RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].ball;
                AnsIR := RepAll.RepPack.Items[i].LstAnsvInRep.Add;
                AnsIR.idV:=RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].idV;
                AnsIR.right:=RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].right;
                AnsIR.Ansver:=RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].Ansver;
                AnsIR.Rem:= RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].Rem;
                AnsIR.ball:=RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].ball;
                AnsIR.pos :=RepAll.RepPack.Items[i].LstMrk.Items[m].pos;
              end;
            end;
          end;
          if RepAll.RepPack.Items[i].LstMrk.Items[m].flMyAns then
          begin
            if RepAll.RepPack.Items[i].LstMrk.Items[m].BallMyAns<0 then
              MnBallPack:=MnBallPack+RepAll.RepPack.Items[i].LstMrk.Items[m].BallMyAns
            else
              PlBallPack:=PlBallPack+RepAll.RepPack.Items[i].LstMrk.Items[m].BallMyAns;
            Ball:=Ball+RepAll.RepPack.Items[i].LstMrk.Items[m].BallMyAns;
            AnsIR := RepAll.RepPack.Items[i].LstAnsvInRep.Add;
            AnsIR.idV:=-2;
            AnsIR.flMyAns := RepAll.RepPack.Items[i].LstMrk.Items[m].flMyAns;
            AnsIR.right:=False;// RepAll.RepPack.Items[i].LstMrk.Items[m].ListAnsTxt.Items[a].right;
            AnsIR.Ansver:=RepAll.RepPack.Items[i].LstMrk.Items[m].MyAns;
            AnsIR.Rem:= 'Свой ответ!';
            AnsIR.ball:=RepAll.RepPack.Items[i].LstMrk.Items[m].BallMyAns;
            AnsIR.pos :=RepAll.RepPack.Items[i].LstMrk.Items[m].pos;
          end;
        end;
   //     BallPack:=BallPack+Ball;
    end;
      BallPack:=PlBallPack+MnBallPack;
      if RepAll.Ball=0 then
         st:=st+'<P><FONT size=3>Общий набранный балл: <b>'+ FloatToStr(BallPack)+'</b><br>'
      else
         st:=st+'<P><FONT size=3>Общий набранный балл: <b>'+ FloatToStr(BallPack)+'</b> из '+FloatToStr(RepAll.Ball)+' возможных.<br>';
      st:=st+'За неправильные: <b>'+ FloatToStr(MnBallPack)+'</b><br>';
      st:=st+'За правильные: <b>'+ FloatToStr(PlBallPack)+'</b></FONT></p>';

    for i:=0 to RepAll.RepPack.Count-1 do
    begin
        AskType:=RepAll.RepPack.Items[i].AskType;
      if AskType=4 then
      begin
        st:=st+'<table width=100% cellspacing=1 cellpadding=1 border=1>';
        st:=st+'<tr bgColor=silver><td width=50><b>№ п/п</b></td><td width=50%><b>Наименование выбранного поля</b></td>';
        st:=st+'<td width=50><b>Полученный балл</b></td>';
        if TpRep=0 then
        begin
          st2:='<td><b>Наименование ошибки или действия</b></td>';//4f
          st3:='<td>&nbsp;</td>';st4:='';
        end
        else if TpRep=1 then
        begin
          st2:='<td><b>Наименование ошибки или действия(свой ответ)</b></td><td><b>Примечания</b></td>';//5f
          st3:='<td>&nbsp;</td><td>&nbsp;</td>';
          st4:='<td>&nbsp;</td>';
        end
        else if TpRep=2 then
        begin
          st2:='<td><b>Наименование ошибки или действия</b></td><td><b>Комментарий к ответу</b></td>'; //5f
          st3:='<td>&nbsp;</td><td>&nbsp;</td>';
          st4:='<td>&nbsp;</td>';
        end
        else if TpRep=3 then
        begin
          st2:='<td><b>Наименование ошибки или действия</b></td><td><b>Комментарий к ответу</b></td><td><b>Примечания</b></td>';//6f
          st3:='<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>';
          st4:='<td>&nbsp;</td><td>&nbsp;</td>';
        end;
        st:=st+st2+'</tr>';

        if RepAll.RepPack.Items[i].ModeView>0 then
        begin
            st:=st+'<tr bgcolor=gainsboro><td>&nbsp;</td><td>Задание '+inttostr(i+1)+': '+RepAll.RepPack.Items[i].Ask+'</td>';
            st:=st+'<td>&nbsp;</td><td>&nbsp;</td>'+st4+'</tr>';
            st:=st+'<tr bgColor=whitesmoke><td>&nbsp;</td><td><b>Выбраные</b></td><td>&nbsp;</td><td>&nbsp;</td>'+st4+'</tr>';
            k:=0;
            for j:=0 to RepAll.RepPack.Items[i].roAsk.Count-1 do
            begin
              stMyAns:='&nbsp;'; stAns:='&nbsp;';
              if RepAll.RepPack.Items[i].roAsk.Items[j].FlMyAn then
              begin
                  inc(k);  //stNo,stB,stAns,stMyAns,
                  st:=st+'<tr>';
                  stNo:='<td><b>'+inttostr(k)+'</b>' +'</td><td> '+RepAll.RepPack.Items[i].roAsk.Items[j].NmO+'</td>';
                  stB:='<td>-</td>';
                  stMyAns:=RepAll.RepPack.Items[i].roAsk.Items[j].MyAns;
                  if RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
                  begin
                      stB:='<td>'+FloatToStr(RepAll.RepPack.Items[i].roAsk.Items[j].Bl)+'</td>';
                      if RepAll.RepPack.Items[i].roAsk.Items[j].Ansv.Count>2 then
                      stAns:=RepAll.RepPack.Items[i].roAsk.Items[j].Ansv[2];
                  end;
                  if TpRep=0 then
                  begin
                    st:=st+stNo+stB+'<td>'+stAns+'</td>'+st4+'</tr>';
                    inc(k);
                    st:=st+'<tr><td><b>'+inttostr(k)+'</b>'+'</td><td>'+RepAll.RepPack.Items[i].roAsk.Items[j].NmO+'</td><td>-</td><td>Указан свой ответ:<br>'+RepAll.RepPack.Items[i].roAsk.Items[j].MyAns+'</td>'+st4;
                  end
                  else if TpRep=1 then
                  begin
                    st:=st+stNo+stB+'<td>'+stAns;if stAns<>'' then st:=st+'<br>';st:=st+'Указан свой ответ:'+'<br>'+stMyAns+'</td>'+st4;
                  end
                  else if TpRep=2 then
                  begin
                    st:=st+stNo+stB+'<td>'+stAns+'</td>';st:=st+'<td>'+stMyAns+'</td>';
                  end
                  else if TpRep=3 then
                  begin
                    st:=st+stNo+stB+'<td>'+stAns+'</td>';st:=st+'<td>'+stMyAns+'</td>'+'<td>&nbsp;</td>';
                  end;
                 st:=st+'</tr>'
              end
              else if RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
              begin
                  inc(k);
                  st:=st+'<tr><td><b>'+inttostr(k)+'</b>'+'</td><td> '+RepAll.RepPack.Items[i].roAsk.Items[j].NmO+'</td>';
                  st:=st+'<td>'+FloatToStr(RepAll.RepPack.Items[i].roAsk.Items[j].Bl)+'</td><td> ';
                  if RepAll.RepPack.Items[i].roAsk.Items[j].Ansv.Count>2 then
                  st:=st+RepAll.RepPack.Items[i].roAsk.Items[j].Ansv[2];
                  st:=st+'</td>'+st4+'</tr>';
              end;
            end;
            st:=st+'<tr bgColor=whitesmoke><td>&nbsp;</td><td><b>Ненайденные</b></td><td>&nbsp;</td>'+st3+'</tr>';
            k:=0;
            for j:=0 to RepAll.RepPack.Items[i].roAsk.Count-1 do
            begin
              if not RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
              begin
                if RepAll.RepPack.Items[i].roAsk.Items[j].Right=0 then
                begin
                  inc(k);
                  st:=st+'<tr><td><b>'+inttostr(k)+'</b>'+
                  '</td><td> '+RepAll.RepPack.Items[i].roAsk.Items[j].NmO+'</td>';
                  st:=st+'<td>0</td><td> ';
                  if RepAll.RepPack.Items[i].roAsk.Items[j].Ansv.Count>2 then
                  st:=st+RepAll.RepPack.Items[i].roAsk.Items[j].Ansv[2];
                  st:=st+'</td>'+st4+'</tr>';
                end;
              end;
            end;
        end;
      end
      else if AskType=9 then
      begin
        st:=st+'<table width=100% cellspacing=1 cellpadding=1 border=1>';
        st:=st+'<tr bgColor=silver><td width=50><b>№ п/п</b></td><td width=50%><b>Наименование ошибки или действия</b></td>';
        st:=st+'<td width=50><b>Полученный балл</b></td><td><b>Примечание</b></td></tr>';
        st:=st+'<tr bgColor=gainsboro><td>&nbsp;</td><td>Задание '+inttostr(i+1)+': '+RepAll.RepPack.Items[i].Ask+'</td>';
        st:=st+'<td> </td><td> </td></tr>';

        if RepAll.RepPack.Items[i].roAsk.Count>0 then
        begin
          st:=st+'<tr bgColor=whitesmoke><td>&nbsp;</td><td>Выбраные</td><td>&nbsp;</td><td>&nbsp;</td></tr>';
          k:=0;
          for j:=0 to RepAll.RepPack.Items[i].roAsk.Count-1 do
          begin
            if RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
            begin
              inc(k);
              st:=st+'<tr><td><b>'+inttostr(k)+'</b>'{+inttostr(RepAll.RepPack.Items[i].roAsk.Items[j].ido)}
              +'</td><td> '+RepAll.RepPack.Items[i].roAsk.Items[j].Nobj+'</td>';
              st:=st+'<td>'+FloatToStr(RepAll.RepPack.Items[i].roAsk.Items[j].Bl)+'</td><td> ';
              if RepAll.RepPack.Items[i].roAsk.Items[j].Ansv.Count>2 then
                st:=st+RepAll.RepPack.Items[i].roAsk.Items[j].Ansv[2]
              else st:=st+'&nbsp;';
              st:=st+'</td></tr>';
            end;
          end;
          st:=st+'<tr bgColor=whitesmoke><td>&nbsp;</td><td>Ненайденные</td><td>&nbsp;</td><td>&nbsp;</td></tr>';
          k:=0;
          for j:=0 to RepAll.RepPack.Items[i].roAsk.Count-1 do
          begin
            if not RepAll.RepPack.Items[i].roAsk.Items[j].Sl then
            begin
              if RepAll.RepPack.Items[i].roAsk.Items[j].Right=0 then
              begin
                inc(k);
                st:=st+'<tr><td><b>'+inttostr(k)+'</b>'+
                '</td><td> '+RepAll.RepPack.Items[i].roAsk.Items[j].NmO+'</td>';
                st:=st+'<td>'+FloatToStr(RepAll.RepPack.Items[i].roAsk.Items[j].Bl)+'</td><td> ';
                if RepAll.RepPack.Items[i].roAsk.Items[j].Ansv.Count>2 then
                st:=st+RepAll.RepPack.Items[i].roAsk.Items[j].Ansv[2];
                st:=st+'</td></tr>';
              end;
            end;
          end;
        end;

          if RepAll.RepPack.Items[i].roAnsT.Count>0 then
          begin
            k:=0;
            for j:=0 to RepAll.RepPack.Items[i].roAnsT.Count-1 do
            begin
              inc(k);
              if not RepAll.RepPack.Items[i].roAnsT.Items[j].DisJrn then
              begin
                st:=st+'<tr><td valign="top"><b>'+inttostr(k)+'</b>'
                +'</td><td valign="top"> '+RepAll.RepPack.Items[i].roAnsT.Items[j].NmO+'</td>';
                Btmp:=ChLstToBall();
                st:=st+'<td valign="top">'+ FloatToStr(Btmp)+'</td><td> ';
                for k3 := 0 to RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns.Count-1 do
                begin
                  if RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns[k3]='1' then
                   st:=st+'- ' +RepAll.RepPack.Items[i].roAnsT.Items[j].Ansv[k3]+'<br>';
                end;
                st:=st+'&nbsp;</td></tr>';
              end;
            end;
          end;

      end
      else if AskType=1 then
      begin
        if (i=0) or (AskType <> RepAll.RepPack.Items[i-1].AskType) then
        begin
          st:=st+'<table width=100% cellspacing=1 cellpadding=1 border=1>';
          st:=st+'<tr bgColor=silver><td width=50><b>№ п/п</b></td><td width=50%><b>Вопрос</b></td>';
          st:=st+'<td width=50><b>Полученный балл</b></td><td><b>Ответы</b></td></tr>';
        end;
          k:=0;
        for j:=0 to RepAll.RepPack.Items[i].roAnsT.Count-1 do
        begin
          inc(k);
          st:=st+'<tr><td valign="top"><b>'+inttostr(k+i)+'</b>'
          +'</td><td valign="top"> '+RepAll.RepPack.Items[i].roAnsT.Items[j].NmO+'</td>';
          Btmp:=ChLstToBall();
          st:=st+'<td valign="top">'+ FloatToStr(Btmp)+'</td><td> ';
          for k3 := 0 to RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns.Count-1 do
          begin
            if RepAll.RepPack.Items[i].roAnsT.Items[j].ChAns[k3]='1' then
              st:=st+'- ' +RepAll.RepPack.Items[i].roAnsT.Items[j].Ansv[k3]+'<br>';
          end;
          st:=st+'&nbsp;</td></tr>';
        end;
      end
      else if AskType=10 then
      begin
        try
        Sh:= GetShemaDB(RepAll.RepPack.Items[i].idAsk);
          for f:=0 to Sh.Fragments.Count-1 do
          begin
            Ball:=0;
            st:=st+'<br>';
            st:=st+'<table width=100% cellspacing=0 cellpadding=0 border=1>';
            st:=st+'<tr bgColor=gainsboro><td>&nbsp;</td><td colspan=6><b>Задание '+inttostr(i+1)+': '+RepAll.RepPack.Items[i].Ask+'</b></td>';
            st:=st+'<tr><td width=50><b>№ п/п</b></td><td width=300><b>Описание выбранного нарушения</b></td>'; //2
            st:=st+'<td width=100><b>Пункт правил</b></td><td width=50><b>Время зафиксированного нарушения</b></td>';  //2
            st:=st+'<td width=50><b>Полученный балл</b></td><td><b>Примечание</b></td><td width=30><b>№ тк</b></td></tr>'; // 3 7
            if Sh.Fragments.Count>1 then begin
              st:=st+'<tr bgColor=gainsboro><td>&nbsp;</td><td colspan=6> '+Sh.Fragments.Items[f].Name+'</td>';
              if Sh.Fragments.Items[f].Rem<>'' then
                st:=st+'<tr bgColor=gainsboro><td>&nbsp;</td><td colspan=6> '+Sh.Fragments.Items[f].Rem+'</td>';
            end;
            if RepAll.RepPack.Items[i].LstAnsvInRep.Count>0 then begin
              for a1 := 0 to RepAll.RepPack.Items[i].LstAnsvInRep.Count-1 do begin
                st:=st+'<tr><td>'+inttostr(a1)+'</td>';
                st:=st+'<td>'+ RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].Ansver+'</td>';
                st1:=RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].Rem;
                if st1='' then st1:='-';
                st:=st+'<td>'+st1+'</td><td>'+TimeStr(RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].pos)+'</td>';
                st:=st+'<td>'+FloatToStr(RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].ball)+'</td><td>-</td>';
                if RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].idV>=0 then
                  st1:=inttostr(RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].idV+1)
                  else st1:='-';
                st:=st+'<td>'+st1+'</td></tr>';
                Ball:=Ball+RepAll.RepPack.Items[i].LstAnsvInRep.Items[a1].ball;
              end;
            end;
            st:=st+cr+'<table width=100% cellspacing=0 cellpadding=0 border=1>';
            st:=st+'<tr><td>&nbsp;</td><td colspan=3><b>Ненайденные нарушения</b></td></tr>';
            st:=st+'<tr><td width=50><b>№ п/п</b></td><td><b>Описание выбранного нарушения</b></td><td width=100><b>Пункт правил</b></td><td width=30><b>№ тк</b></td></tr>'; //4
            for m:=0 to RepAll.RepPack.Items[i].LstNFnd.Count-1 do begin
              if f=RepAll.RepPack.Items[i].LstNFnd.Items[m].NFragment then begin
                st1:=RepAll.RepPack.Items[i].LstNFnd.Items[m].Rem;
                if st1='' then st1:='-';
                s := RepAll.RepPack.Items[i].LstNFnd.Items[m].Ans;
                st:=st+cr+'<tr><td>'+IntToStr(m+1)+'</td><td>'+s+'</td><td>'+st1+'</td>';
                st:=st+'<td>'+inttostr(RepAll.RepPack.Items[i].LstNFnd.Items[m].idv)+'</td></tr>';
              end;
            end;
            st:=st+cr+'</table>';
          end;
        finally
          Sh.Free;
        end;

      end;
      for j:=0 to RepAll.RepPack.Items[i].Diary.Count-1 do begin
        if (RepAll.RepPack.Items[i].Diary.Items[j].Mark<>0) or (RepAll.RepPack.Items[i].Diary.Items[j].Rul=-1) then begin
          k:=k+1;
          st:=st+'<tr><td>'+inttostr(k)+' _</td><td>'+RepAll.RepPack.Items[i].Diary.Items[j].Name+'</td><td>';
          if RepAll.RepPack.Items[i].Diary.Items[j].par.Text='' then
            st:=st+floattostr(RepAll.RepPack.Items[i].Diary.Items[j].Mark)+'</td><td>'+'--'+'</td></tr>'
          else
           st:=st+floattostr(RepAll.RepPack.Items[i].Diary.Items[j].Mark)+'</td><td>'+RepAll.RepPack.Items[i].Diary.Items[j].par.Text+'</td></tr>';
        end;
      end;
      end;
    st:=st+'</table>';
    st:=st+'<p align=right>Проверяющий______________________________</p>';
    st:=st+'</BODY></HTML>';
    Result := st;
  finally
    RepAll.Free;
  end;
end;

end.
