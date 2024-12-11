program Mobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnInicial in 'UnInicial.pas' {frmInicial},
  UnLogin in 'UnLogin.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmInicial, frmInicial);
  Application.Run;
end.
