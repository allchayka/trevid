program trevid;

{$MODE Delphi}
//{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  SysUtils, Forms, printer4lazarus, runtimetypeinfocontrols, zcomponent,
  FrameViewer09, unFrmJorn, XML2HTML, rImgss, Utils, UnOptions, unRecords,
  unFrameAsk, unFrameVideo, unFrameRectAsk, unAsk, PasLibVlcPlayer, UtilitiesDB,
  UnFrameTopic, UnTreeTopic, UnFormPlay, unFormSubsAsks, unFormStartEditor,
  unFormTasks, unFormEdZ, unFrmEdLstAns, SizeControl, Unit1, unFormNewSc,
  unMessage;

{$R *.res}
var pth : string;
begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  pth:= ExtractFilePath(Application.ExeName);
  rOptions := TrOptions.Create(pth);
  ConnectDB(rOptions);
  Application.CreateForm(TFormStartEditor, FormStartEditor);
  Application.CreateForm(TFormNewSc, FormNewSc);
  Application.Run;
end.

