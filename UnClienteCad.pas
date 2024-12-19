unit UnClienteCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox;

type
  TfrmClienteCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    ListBox1: TListBox;
    lbiCPFCNPJ: TListBoxItem;
    lbiNome: TListBoxItem;
    lbiFone: TListBoxItem;
    lbiEmail: TListBoxItem;
    lbiEndereco: TListBoxItem;
    lbiNumero: TListBoxItem;
    lbiComplemento: TListBoxItem;
    lbiBairro: TListBoxItem;
    lbiCidade: TListBoxItem;
    lbiUF: TListBoxItem;
    lbiCEP: TListBoxItem;
    Label2: TLabel;
    lblCPFCNPJ: TLabel;
    Image4: TImage;
    Label1: TLabel;
    lblNome: TLabel;
    Image3: TImage;
    Label4: TLabel;
    lblFone: TLabel;
    Image5: TImage;
    Label6: TLabel;
    lblEmail: TLabel;
    Image6: TImage;
    Label8: TLabel;
    lblEndereco: TLabel;
    Image7: TImage;
    Label10: TLabel;
    lblNumero: TLabel;
    Image8: TImage;
    Label12: TLabel;
    lblComplemento: TLabel;
    Image9: TImage;
    Label14: TLabel;
    lblBairro: TLabel;
    Image10: TImage;
    Label16: TLabel;
    lblCidade: TLabel;
    Image11: TImage;
    Label18: TLabel;
    lblUF: TLabel;
    Image12: TImage;
    Label20: TLabel;
    lblCEP: TLabel;
    Image13: TImage;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    Line6: TLine;
    Line7: TLine;
    Line8: TLine;
    Line9: TLine;
    Line10: TLine;
    Line11: TLine;
    lbiLimite: TListBoxItem;
    Line12: TLine;
    Label22: TLabel;
    lblLimite: TLabel;
    Image14: TImage;
    Layout1: TLayout;
    btExcluir: TSpeedButton;
    Image15: TImage;
    btMapa: TSpeedButton;
    Image16: TImage;
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClienteCad: TfrmClienteCad;

implementation

{$R *.fmx}

uses UnPrincipal;

procedure TfrmClienteCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClienteCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmClienteCad := nil;

end;

end.
