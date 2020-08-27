unit uConsultaVentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  EditBtn, Buttons,uEstructura,uDetallesVenta,uDAOVentas,frmVendedoresTop;

type

  { TfrmVentasRealizadas }

  TfrmVentasRealizadas = class(TForm)
    edtBusqueda: TEdit;
    edtFecha: TDateEdit;
    grdVentasRealizadas: TStringGrid;
    GroupBox1: TGroupBox;
    Cliente: TLabel;
    Label1: TLabel;
    LabelCriterios: TLabel;
    lblFecha: TLabel;
    radbtnCliente: TRadioButton;
    radbtnVendedor: TRadioButton;
    SpeedButtonVerDetalles: TSpeedButton;
    SpeedButtonSalir: TSpeedButton;
    SpeedButtonMejoresVendedores: TSpeedButton;

    procedure btnSalirClick(Sender: TObject);
    procedure edtBusquedaChange(Sender: TObject);
    procedure edtFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure edtFechaChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure grdVentasRealizadasDblClick(Sender: TObject);
    procedure SpeedButtonMejoresVendedoresClick(Sender: TObject);
    procedure SpeedButtonSalirClick(Sender: TObject);
    procedure SpeedButtonVerDetallesClick(Sender: TObject);
  private

  public
    procedure mostrarVentas(v:TvectorFactura;n:integer);
    procedure mostrarResultados();
    procedure mostrarRegistro();
    procedure LimpiarBusquedas();
  end;

var
  frmVentasRealizadas: TfrmVentasRealizadas;
  Sender:TObject;
  seleccion:integer;
  calendario:Boolean;
implementation

{$R *.lfm}
procedure TfrmVentasRealizadas.btnSalirClick(Sender: TObject);
begin
  close;
end;



procedure TfrmVentasRealizadas.mostrarResultados();
begin
  if N=0 then
    begin
     ShowMessage('No se han encontrado resultados');
     LimpiarBusquedas();
     FormActivate(Sender);
    end
  else
      mostrarVentas(vFactura,N);
end;
procedure TfrmVentasRealizadas.LimpiarBusquedas();
begin
    edtFecha.Text:='';
    edtBusqueda.Text:='';
end;

procedure TfrmVentasRealizadas.edtBusquedaChange(Sender: TObject);
begin
  if radbtnCliente.Checked then
    buscarCliente(edtBusqueda.Text,vFactura,N)
  else
    if radbtnVendedor.Checked then
      buscarVendedor(edtBusqueda.Text,vFactura,N)
    else
      ShowMessage('Seleccione si desea buscar el nombre de un comprador o vendedor');
  mostrarResultados();
end;

procedure TfrmVentasRealizadas.edtFechaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  calendario:=AcceptDate;
end;

procedure TfrmVentasRealizadas.edtFechaChange(Sender: TObject);
begin
  buscarFecha(edtFecha.Text,vFactura,N);
  mostrarResultados();
end;
procedure TfrmVentasRealizadas.mostrarVentas(v:TvectorFactura;n:integer);
var
  i,fila:integer;
  totalstr:cadena10;
begin
    try
    grdVentasRealizadas.RowCount:=1;
    for i:=1 to n do
    begin
      grdVentasRealizadas.RowCount:=grdVentasRealizadas.RowCount+1;
      Str(V[i].total:8:2,totalstr);
      fila:=grdVentasRealizadas.RowCount-1;
      grdVentasRealizadas.Cells[1,fila]:=IntToStr(v[i].id);
      grdVentasRealizadas.Cells[2,fila]:=DateToStr(v[i].fecha);
      grdVentasRealizadas.Cells[3,fila]:=v[i].nombreCliente;
      grdVentasRealizadas.Cells[4,fila]:=V[i].vendedor.usuario;
      grdVentasRealizadas.Cells[5,fila]:=totalstr;
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


procedure TfrmVentasRealizadas.FormActivate(Sender: TObject);
begin
    if not calendario then
    begin
     buscarVentas(vFactura,n);
     mostrarVentas(vFactura,n);
     LimpiarBusquedas();
    end;
end;
procedure TfrmVentasRealizadas.mostrarRegistro();
begin
  frmDetallesFactura.edtFecha.Text:=grdVentasRealizadas.Cells[2,grdVentasRealizadas.Row];
  frmDetallesFactura.edtCliente.Text:=grdVentasRealizadas.Cells[3,grdVentasRealizadas.Row];
  frmDetallesFactura.edtVendedor.Text:=grdVentasRealizadas.Cells[4,grdVentasRealizadas.Row];
  idFac:=StrToInt(grdVentasRealizadas.Cells[1,grdVentasRealizadas.Row]);
end;

procedure TfrmVentasRealizadas.grdVentasRealizadasDblClick(Sender: TObject);
begin
  seleccion:=1;
  mostrarRegistro();
end;

procedure TfrmVentasRealizadas.SpeedButtonMejoresVendedoresClick(Sender: TObject);
begin
  frmMejoresVendedores.ShowModal;
end;

procedure TfrmVentasRealizadas.SpeedButtonSalirClick(Sender: TObject);
begin
  calendario:=false;
  close;
end;

procedure TfrmVentasRealizadas.SpeedButtonVerDetallesClick(Sender: TObject);
begin
  if seleccion=1 then
    begin
     frmDetallesFactura.ShowModal;
     calendario:=false;
    end
  else
    ShowMessage('Haga doble click en la lista para seleccionar una factura');
end;

end.

