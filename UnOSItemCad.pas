unit UnOSItemCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmOSItemCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    btVoltar: TSpeedButton;
    Image2: TImage;
    btSalvar: TSpeedButton;
    Image1: TImage;
    rectProduto: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    lblDescricao: TLabel;
    rectUnitario: TRectangle;
    Label4: TLabel;
    Image5: TImage;
    lblValorUnitario: TLabel;
    rectQuantidade: TRectangle;
    Label3: TLabel;
    Image7: TImage;
    lblQuantidade: TLabel;
    rectTotal: TRectangle;
    Label1: TLabel;
    Image3: TImage;
    lblValorTotal: TLabel;
    btMenos: TSpeedButton;
    imgIconeMenos: TImage;
    btMais: TSpeedButton;
    imgIconeMais: TImage;
    procedure rectQuantidadeClick(Sender: TObject);
    procedure rectUnitarioClick(Sender: TObject);
    procedure rectTotalClick(Sender: TObject);
    procedure btVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOSItemCad: TfrmOSItemCad;

implementation

{$R *.fmx}

uses UnEdicaoPadrao;

procedure TfrmOSItemCad.btVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOSItemCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmOSItemCad := nil;
end;

procedure TfrmOSItemCad.rectQuantidadeClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblQuantidade,
                          TTipoCampo.Valor,
                          'Quantidade do item',
                          'Informe a quantidade do item',
                          lblQuantidade.Text,
                          True,
                          0
                          );
end;

procedure TfrmOSItemCad.rectTotalClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblValorTotal,
                          TTipoCampo.Valor,
                          'Valor Total do Item',
                          'Informe o valor total do item',
                          lblValorTotal.Text,
                          True,
                          0
                          );
end;

procedure TfrmOSItemCad.rectUnitarioClick(Sender: TObject);
begin
  if not Assigned(frmEdicaoPadrao) then
    Application.CreateForm(TFrmEdicaoPadrao, frmEdicaoPadrao);

  FrmEdicaoPadrao.fEditar(lblValorUnitario,
                          TTipoCampo.Valor,
                          'Quantidade do item',
                          'Informe o valor unitário do item',
                          lblValorUnitario.Text,
                          True,
                          0
                          );
end;

end.
