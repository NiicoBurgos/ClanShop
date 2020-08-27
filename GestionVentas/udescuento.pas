unit uDescuento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  uDAOdescuento, uEstructura;

type

  { TfrmDescuento }

  TfrmDescuento = class(TForm)
    edtImporteMinimo: TEdit;
    edtDescuento: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButtonOk: TSpeedButton;
    SpeedButtonSalir: TSpeedButton;
    procedure btnVolverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonOkClick(Sender: TObject);
    procedure SpeedButtonSalirClick(Sender: TObject);
  private

  public
   procedure Inicializar();
  end;

var
  frmDescuento: TfrmDescuento;

implementation

{$R *.lfm}

{ TfrmDescuento }

procedure TfrmDescuento.btnVolverClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDescuento.FormCreate(Sender: TObject);
begin
  CrearFicheroDescuento();
end;

procedure TfrmDescuento.SpeedButtonOkClick(Sender: TObject);
begin
  if (edtDescuento.Text<>'') and (edtImporteMinimo.Text<>'') then
  begin
  ModificarDesc(f,edtImporteMinimo.Text,edtDescuento.Text);
  ShowMessage('Importe minimo y Descuento agregados correctamente');
  Inicializar();
  close;
  end
  else
  ShowMessage('Debe completar todos los campos');
  edtImporteMinimo.SetFocus;
end;

procedure TfrmDescuento.SpeedButtonSalirClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDescuento.Inicializar();
begin
   edtImporteMinimo.Text:='';
   edtDescuento.Text:='';
end;


end.

