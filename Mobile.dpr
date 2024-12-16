program Mobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnInicial in 'UnInicial.pas' {frmInicial},
  UnLogin in 'UnLogin.pas' {frmLogin},
  UnPrincipal in 'UnPrincipal.pas' {frmPrincipal},
  DMGlobal in 'DataModule\DMGlobal.pas' {DM: TDataModule},
  uActionSheet in 'Units\uActionSheet.pas',
  uCombobox in 'Units\uCombobox.pas',
  uConstantes in 'Units\uConstantes.pas',
  uFancyDialog in 'Units\uFancyDialog.pas',
  uFormat in 'Units\uFormat.pas',
  uFunctions in 'Units\uFunctions.pas',
  uLoading in 'Units\uLoading.pas',
  uSession in 'Units\uSession.pas',
  uSuperChart in 'Units\uSuperChart.pas',
  DataModule.Usuario in 'DataModule\DataModule.Usuario.pas' {DmUsuario: TDataModule},
  DataModule.OS in 'DataModule\DataModule.OS.pas' {DMOS: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmInicial, frmInicial);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TDmUsuario, DmUsuario);
  Application.CreateForm(TDMOS, DMOS);
  Application.Run;
end.
