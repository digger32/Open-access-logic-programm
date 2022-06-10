program logic;

{$MODE Delphi}

uses
  Forms, Interfaces,
  logic1 in 'logic1.pas' {Form1},
  classif1 in 'classif1.pas',
  optim1 in 'optim1.pas',
  search1 in 'search1.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
