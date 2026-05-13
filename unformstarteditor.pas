unit unFormStartEditor;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, unFormSubsAsks, unFormTasks, unFrmJorn, UnFormPlay;

type

  { TFormStartEditor }

  TFormStartEditor = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mnPlay: TMenuItem;
    mnJournal: TMenuItem;
    mnCreateNewDB: TMenuItem;
    mnSaveDB: TMenuItem;
    Separator2: TMenuItem;
    mnWinTask: TMenuItem;
    mnWinSub: TMenuItem;
    Separator1: TMenuItem;
    mnSubsAndTask: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mnJournalClick(Sender: TObject);
    procedure mnPlayClick(Sender: TObject);
    procedure mnSubsAndTaskClick(Sender: TObject);
    procedure mnWinSubClick(Sender: TObject);
    procedure mnWinTaskClick(Sender: TObject);
  private

  public

  end;

var
  FormStartEditor: TFormStartEditor;

implementation

{$R *.lfm}

{ TFormStartEditor }

procedure TFormStartEditor.mnWinSubClick(Sender: TObject);
var frm : TForm;
begin
  TFormSubsAsks.Create(Self).Show;
end;

procedure TFormStartEditor.mnSubsAndTaskClick(Sender: TObject);
begin
  TFormSubsAsks.Create(Self).Show;
  TFormTasks.Create(Self).Show;
end;

procedure TFormStartEditor.FormCreate(Sender: TObject);
begin

end;

procedure TFormStartEditor.mnJournalClick(Sender: TObject);
begin
  TFrmJorn.Create(Self).Show;
end;

procedure TFormStartEditor.mnPlayClick(Sender: TObject);
begin
  TFormPlay.Create(Self).Show;
end;

procedure TFormStartEditor.mnWinTaskClick(Sender: TObject);
begin
  TFormTasks.Create(Self).Show;
end;

end.

