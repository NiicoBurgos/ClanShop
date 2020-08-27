unit uDetallesVenta;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons, uEstructura, uDAOVentas;

type

  { TfrmDetallesFactura }

  TfrmDetallesFactura = class(TForm)
    edtCambio: TEdit;
    edtCliente: TEdit;
    edtDescuento: TEdit;
    edtEfectivo: TEdit;
    edtFecha: TEdit;
    edtTotal: TEdit;
    edtVendedor: TEdit;
    grdDetalles: TStringGrid;
    GroupBox1: TGroupBox;
    lblDatos: TLabel;
    lblCambio: TLabel;
    lblCliente: TLabel;
    lblDescuento: TLabel;
    lblEfectivo: TLabel;
    lblFecha: TLabel;
    lblTotal: TLabel;
    lblVendedor: TLabel;
    SpeedButtonVolver: TSpeedButton;
    procedure btnSalirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
    procedure mostrarDetalles(v:TvectorDetalles;n:integer);
    procedure mostrarPrecios(idfactura:integer);
  end;

var
  frmDetallesFactura: TfrmDetallesFactura;

implementation

{$R *.lfm}
 procedure TfrmDetallesFactura.btnSalirClick(Sender: TObject);
begin
  close;
end;
 function ObtenerFactura(idFac:integer):TFactura;
var
  pos:integer;
  factura:TFactura;
begin
  pos:=buscarIdFactura(idFac);
  factura:=darUnaFactura(pos);
  ObtenerFactura:=factura;
end;
 procedure TfrmDetallesFactura.mostrarPrecios(idfactura:integer);
 var
   factura:TFactura;
   totalstr,descuentostr,cambiostr,efectivostr:cadena10;
 begin
     factura:=ObtenerFactura(idFac);
     str(factura.total:8:2,totalStr);
     str(factura.descuento:8:2,descuentostr);
     str(factura.cambio:8:2,cambiostr);
     str(factura.efectivo:8:2,efectivostr);
     edtTotal.Text:=totalStr;
     edtDescuento.Text:=descuentostr;
     edtCambio.Text:=cambiostr;
     edtEfectivo.Text:=efectivostr;
 end;

procedure TfrmDetallesFactura.mostrarDetalles(v:TvectorDetalles;n:integer);
var
  i,fila:integer;
  precioUstr,totalstr:cadena10;
begin
   try
    grdDetalles.RowCount:=1;
    for i:=1 to n do
    begin
      str(v[i].precioUnitario:8:2,precioUstr);
      str(v[i].subtotal:8:2,totalstr);
      grdDetalles.RowCount:=grdDetalles.RowCount+1;
      fila:=grdDetalles.RowCount-1;
      grdDetalles.Cells[0,fila]:=IntToStr(v[i].numeroLinea);
      grdDetalles.Cells[1,fila]:=v[i].articulo.codigo;
      grdDetalles.Cells[2,fila]:=v[i].articulo.descripcion;
      grdDetalles.Cells[3,fila]:=IntToStr(V[i].cantidad);
      grdDetalles.Cells[4,fila]:=precioUstr;
      grdDetalles.Cells[5,fila]:=totalstr;
    end;
  Except
    on E:EInOutError do
    ShowMessage('Se ha producido un error en el fichero.Detalles: '+E.ClassName+'/'+E.Message );
    on E:EConvertError do
    ShowMessage('No se ha podido convertir algún valor');
    on E:Exception do
    ShowMessage('Error inesperado');
  end;
end;

procedure TfrmDetallesFactura.FormActivate(Sender: TObject);
begin
  mostrarPrecios(idFac);
  buscarDetalles(vDetalles,N,idFac);
  mostrarDetalles(vDetalles,N);
end;

procedure TfrmDetallesFactura.SpeedButtonVolverClick(Sender: TObject);
begin
  Close;
end;

end.

