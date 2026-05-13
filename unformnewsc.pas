unit unFormNewSc;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ZDataset, UtilitiesDB,tren;

type

  { TFormNewSc }

  TFormNewSc = class(TForm)
    Button1: TButton;
    Button2: TButton;
    EdDolg: TEdit;
    Edfio: TEdit;
    EdGRP: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormNewSc: TFormNewSc;

implementation

{$R *.lfm}

{ TFormNewSc }

procedure TFormNewSc.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormNewSc.FormActivate(Sender: TObject);
begin
  Edfio.Text := tmpFam;
  EdDolg.Text := '';
  EdGRP.Text := tmpGrp;
end;

procedure TFormNewSc.Button1Click(Sender: TObject);
var QPupilsAdd : TZQuery;
begin
  QPupilsAdd := TZQuery.Create(nil);
  QPupilsAdd.Connection := DBcon;
  QPupilsAdd.SQL.Add('INSERT INTO Pupils (Family,Doljnost,"group")');
  QPupilsAdd.SQL.Add('VALUES ("'+Edfio.Text+'", "'+EdDolg.Text+'", "'+EdGRP.Text+'");');
  QPupilsAdd.ExecSQL;
  tmpFam := Edfio.Text;
  tmpGrp := EdGRP.Text;

end;

end.

