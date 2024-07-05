program Project4;

uses
  Vcl.Forms,
  StudentManagement in 'StudentManagement.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
