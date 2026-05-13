program tvjournal;

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
  Forms, printer4lazarus, zcomponent, unFrmJorn, XML2HTML, rImgss, Utils,
  UnOptions, unRecords, unFrameAsk, unFrameVideo,
  unFrameRectAsk, unAsk, PasLibVlcPlayer, UtilitiesDB, UnFrameTopic,
  unFormSubsAsks, unFormStartEditor, unFormTasks;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmJorn, FrmJorn);
  Application.CreateForm(TFormStartEditor, FormStartEditor);
//  Application.CreateForm(TFormSubsAsks, FormSubsAsks);
//  Application.CreateForm(TFormTasks, FormTasks);
  Application.Run;
end.

