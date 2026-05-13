unit unFrameVideo;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, unFrameAsk, rImgss,
  tren, unRecords, Utils, UnOptions, PasLibVlcUnit, PasLibVlcPlayerUnit;

type

  { TFrameVideo }

  TFrameVideo = class(TFrameAsk)
    butResume: TButton;
    Button1: TButton;
    Button2: TButton;
    lstMark: TListBox;
    lstFragments: TListBox;
    panCntrl: TPanel;
    PanInfoMark: TPanel;
    Panel2: TPanel;
    PanShWorkArea: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PasLibVlcPlayer1: TPasLibVlcPlayer;
    Splitter2: TSplitter;
    Splitter1: TSplitter;
    procedure butNextPgClick(Sender: TObject);
    procedure butResumeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lstFragmentsClick(Sender: TObject);
    procedure lstMarkClick(Sender: TObject);
    procedure lstMarkDblClick(Sender: TObject);
  private

  public
    Fragm : array [0..20] of TFragments;
    CurAsk,CurrFr : Integer;
    procedure Init(); override;
  end;

implementation

{$R *.lfm}

{ TFrameVideo }

procedure TFrameVideo.lstMarkDblClick(Sender: TObject);
var mark : TrMark;
begin
  mark := Shema.CurA.LstMrk.Items[lstMark.ItemIndex];

  //PanInfoMark.Caption:= mark.Name + #13
  //+IntToStr(mark.NFragment) + ' - pos='+IntToStr(mark.pos) + '; posFr='+IntToStr(mark.posFr) + #13
  //+'x='+IntToStr(mark.x) + ';y='+IntToStr(mark.y)+';ball='+FloatToStr(mark.ball) + #13
  //+mark.MyAns + #13
  //;
end;

procedure TFrameVideo.lstMarkClick(Sender: TObject);
var mark : TrMark;
begin
  mark := Shema.CurA.LstMrk.Items[lstMark.ItemIndex];
  PanInfoMark.Caption:= mark.Name + #13
  +IntToStr(mark.NFragment) + ' - pos='+IntToStr(mark.pos) + '; posFr='+IntToStr(mark.posFr) + #13
  +'x='+IntToStr(mark.x) + ';y='+IntToStr(mark.y)+';ball='+FloatToStr(mark.ball) + #13
  +mark.MyAns;
end;

procedure TFrameVideo.lstFragmentsClick(Sender: TObject);
var i : Integer;
    CurRepAsk : rRepAsk;
    lstInd : Integer;
begin
  CurrFr:=lstFragments.ItemIndex;

  PanShWorkArea.Caption:=rOptions.PathVideo + Shema.Fragments.Items[CurrFr].Files;
  lstMark.Clear;
  CurRepAsk := Shema.CurA;
  if Shema.CurA.LstMrk.Count>0 then
  begin
    for i:=0 to Shema.CurA.LstMrk.Count-1 do begin
      if Shema.CurA.LstMrk.Items[i].NFragment=CurrFr then
        lstInd := lstMark.Items.Add(Shema.CurA.LstMrk.Items[i].Name);
    end;
  end;
  if lstMark.Count>0 then begin
    lstMark.ItemIndex:=0;
    lstMarkClick(Self);
  end;
end;

procedure TFrameVideo.Button1Click(Sender: TObject);
var
  p_mi: libvlc_media_player_t_ptr;
  fPath : String;
  CurRepAsk : rRepAsk;
  lstInd : Integer;
begin
  CurrFr:=lstFragments.ItemIndex;
//  s :=PathPic +  StringReplace(Pages.Items[FCurrPg-1].FPathPic,'\',PathDelim,[rfReplaceAll, rfIgnoreCase]);
  fPath:=rOptions.PathVideo + StringReplace(Shema.Fragments.Items[CurrFr].Files,'\',PathDelim,[rfReplaceAll, rfIgnoreCase]);
  PasLibVlcPlayer1.Play(WideString(fPath));
// Sleep(2000);

  p_mi := PasLibVlcPlayer1.GetPlayerHandle();

end;

procedure TFrameVideo.butResumeClick(Sender: TObject);
begin
  PasLibVlcPlayer1.Resume();
//  ProgBar.OnChange := NIL;
end;

procedure TFrameVideo.butNextPgClick(Sender: TObject);
begin
  inherited;
end;

procedure TFrameVideo.Button2Click(Sender: TObject);
begin
  PasLibVlcPlayer1.Pause();

end;

procedure TFrameVideo.Init;
var i : Integer;
    CurRepAsk : rRepAsk;
    lstInd : Integer;
begin
  inherited Init;

  lstFragments.Clear;
  for i := 0 to Shema.Fragments.Count-1 do
    lstFragments.Items.Append(Shema.Fragments.Items[i].Name);
  lstFragments.ItemIndex:=CurrFr;
  lstFragmentsClick(Self);
end;

end.

