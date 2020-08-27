unit uVentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ExtCtrls, Buttons, Spin, uEstructura, uDAOVentas, uDAOUsuarios, uDAOArticulos,
  uModificar, utiles, uDescuento, uDAOdescuento,uDAOExcel,mmsystem;

type

  { TfrmConsulta }

  TfrmConsulta = class(TForm)
    comboArt: TComboBox;
    comboCod: TComboBox;
    edtFecha: TEdit;
    edtDescuentoenPesos: TEdit;
    edtTotal: TEdit;
    edtEfectivo: TEdit;
    edtCambio: TEdit;
    edtCliente: TEdit;
    edtVendedor: TEdit;
    edtPrecioUnitario: TEdit;
    edtSubtotal: TEdit;
    GroupBoxFactura: TGroupBox;
    GroupBoxArticulo: TGroupBox;
    labelAviso: TLabel;
    lblFactura: TLabel;
    lblArticulo: TLabel;
    lblFecha: TLabel;
    lblDescuentoPesos: TLabel;
    lblTotal: TLabel;
    lblEfectivo: TLabel;
    Label17: TLabel;
    lblCambio: TLabel;
    Label19: TLabel;
    lblCliente: TLabel;
    lblVendedor: TLabel;
    lblCodigo: TLabel;
    lblDescripcion: TLabel;
    lblCantidad: TLabel;
    lblPrecioUnitario: TLabel;
    lblSubtotal: TLabel;
    grdVenta: TStringGrid;
    Panel1: TPanel;
    SpeedButtonCambiarcantidad: TSpeedButton;
    SpeedButtonDescuento: TSpeedButton;
    SpeedButtonFinalizar: TSpeedButton;
    SpeedButtonCobrar: TSpeedButton;
    SpeedButtonQuitar: TSpeedButton;
    SpeedButtonCancelar: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    SpeedButtonAgregar: TSpeedButton;
    SpinEdtCantidad: TSpinEdit;
    procedure btnCobrarClick(Sender: TObject);
    procedure btnDescuentoClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure comboArtChange(Sender: TObject);
    procedure comboArtKeyPress(Sender: TObject; var Key: char);
    procedure comboCodChange(Sender: TObject);
    procedure comboCodKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdVentaDblClick(Sender: TObject);
    procedure SpeedButtonCobrarClick(Sender: TObject);
    procedure SpeedButtonAgregarClick(Sender: TObject);
    procedure SpeedButtonCambiarcantidadClick(Sender: TObject);
    procedure SpeedButtonCancelarClick(Sender: TObject);
    procedure SpeedButtonDescuentoClick(Sender: TObject);
    procedure SpeedButtonFinalizarClick(Sender: TObject);
    procedure SpeedButtonQuitarClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
    procedure leerFactura(var rfactura:TFactura);
    procedure leerDetalle(var rdetalle:TDetalle;linea:integer);
    procedure descontarStocks(linea:integer);
    procedure mostarArticulos(vArticulo:TvectorArticulo;art:integer);
    procedure ActualizarTotal(v:TvectorVenta);
    procedure ActualizarSubTotal(v:TvectorVenta);
    procedure InicializarVenta();
    procedure aviso();
    procedure MostrarVenta(vVenta: TvectorVenta; M:integer);
    procedure LeerVenta(var rVenta:TVenta);
    procedure quitarArticulo(var M:integer; var vvVenta:TvectorVenta);
    function obtenerPos():integer;
    function CamposLlenos():boolean;
    procedure Limpiar();
    procedure ActualizarDescuento();
    procedure aviso(r:TArticulo);
    procedure controlArticulo(buscado:cadena50);
    procedure ventaMod;
    procedure sumarVentaAlVendedor();
  end;

var
  frmConsulta: TfrmConsulta;
  precio:cadena10;
  i, OK:integer;
  total:real;
  sender:TObject;
implementation

{$R *.lfm}

{ TfrmConsulta }


procedure TfrmConsulta.comboArtChange(Sender: TObject);
begin
   BuscarDescripcion(comboArt.Text,vArticulo,N);
   if N=0 then
    begin
    showMessage('No se encontró el artículo solicitado');
    comboArt.Text:='';
    comboArt.SetFocus;
    end
   else
     if vArticulo[N].descripcion=comboArt.Text then
    begin
    comboCod.Text:=vArticulo[N].codigo;
    str(vArticulo[N].precioUnitario:5:2,precio);
    edtPrecioUnitario.Text:=precio;
    SpinEdtCantidad.text:=inttostr(1);
    end;
end;

procedure TfrmConsulta.comboArtKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
   comboArtChange(sender);
end;

procedure TfrmConsulta.comboCodChange(Sender: TObject);
begin
  BuscarCodigo(comboCod.Text,vArticulo,N);
  if N=0 then
    begin
    showMessage('No se encontró el artículo solicitado');
    comboCod.Text:='';
    comboCod.SetFocus;
    end
  else
   if vArticulo[N].codigo=comboCod.Text then
    begin
    comboArt.Text:=vArticulo[N].descripcion;
    str(vArticulo[N].precioUnitario:5:2,precio);
    edtPrecioUnitario.Text:=precio;
    SpinEdtCantidad.text:=inttostr(1);
    end;
end;

procedure TfrmConsulta.comboCodKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   comboCodChange(sender);
end;

procedure TfrmConsulta.mostarArticulos(vArticulo:TvectorArticulo;art:integer);
var
  i:integer;
begin
   for i:=1 to art do
   begin
   comboArt.Items.Add(vArticulo[i].descripcion);
   comboCod.Items.Add(vArticulo[i].codigo);
   end;
end;

procedure TfrmConsulta.FormActivate(Sender: TObject);
begin
  buscar(vArticulo,N);
  mostarArticulos(vArticulo,N);
  MostrarVenta(vVenta,M);
  ActualizarSubTotal(vVenta);
  ActualizarDescuento();
  ActualizarTotal(vVenta);
  InicializarVenta();
  SpeedButtonAgregar.Caption:='AGREGAR';
end;

function ObtenerUsuario(vendedor:cadena50):TUsuario;
var
  pos:integer;
  us:TUsuario;
begin
  pos:=BuscarUsuario(vendedor);
  us:=darUnUsuario(pos);
  ObtenerUsuario:=us;
end;
function TfrmConsulta.CamposLlenos():boolean;
var
  llenos:boolean;
begin
  llenos:=false;
  if (edtSubtotal.Text<>'') and (edttotal.Text<>'')
  and (edtEfectivo.Text<>'')and (edtCambio.Text<>'')and(edtCliente.Text<>'') then
  llenos:=true;
  CamposLlenos:=llenos;
end;

procedure TfrmConsulta.leerFactura(var rfactura:TFactura);
begin
  try
    rFactura.id:=getSiguienteFactura();
    rFactura.fecha:=StrToDate(edtFecha.Text);
    rFactura.nombreCliente:=edtCliente.Text;
    rFactura.vendedor:=ObtenerUsuario(edtVendedor.Text);
    rFactura.total:=StringToFloat(edtTotal.Text);
    rFactura.descuento:=StringToFloat(edtDescuentoenPesos.Text);
    rFactura.efectivo:=StringToFloat(edtEfectivo.Text);
    rFactura.cambio:=StringToFloat(edtCambio.Text);
    rFactura.estado:=ESTADO_ACTIVO;
  except
    on e: EConvertError do
       Raise EConvertError.Create('Datos incorrectos ' + e.Message);
    on e: Exception do
       Raise Exception.Create('Error inesperado ' + e.Message);
  end;
end;
function obtenerArticulo(descripcion:cadena50):TArticulo;
var
  pos:integer;
  art:TArticulo;
begin
  pos:= buscarDescripcion(fi,descripcion);
  art:=darUnArticulo(pos);
  obtenerArticulo:=art;
end;

procedure TfrmConsulta.leerDetalle(var rdetalle:TDetalle;linea:integer);
begin
  try
  rDetalle.numeroLinea:=linea;
  rDetalle.idFactura:=rFactura.id;
  rDetalle.articulo:=obtenerArticulo(grdVenta.Cells[2,linea]);
  rDetalle.cantidad:=StrToInt(grdVenta.Cells[3,linea]);
  rDetalle.precioUnitario:=StringToFloat(grdVenta.Cells[4,linea]);
  rDetalle.subtotal:=StringToFloat(grdVenta.Cells[5,linea]);
  except
    on e: EConvertError do
       Raise EConvertError.Create('Datos incorrectos ' + e.Message);
    on e: Exception do
       Raise Exception.Create('Error inesperado ' + e.Message);
  end;
end;
procedure TfrmConsulta.descontarStocks(linea:integer);
var
   art:TArticulo;
   pos:integer;
begin
   pos:= buscarDescripcion(fi,grdVenta.Cells[2,linea]);
   art:=obtenerArticulo(grdVenta.Cells[2,linea]);
   art.stock:=art.stock-StrToInt(grdVenta.Cells[3,linea]);
   art.cantidadVendida:=art.cantidadVendida+StrToInt(grdVenta.Cells[3,linea]) ;
   Modificar(art,pos);
end;
procedure tfrmConsulta.Limpiar();
begin
  M:=0;
  comboCod.Text:='';
  comboArt.Text:='';
  edtPrecioUnitario.Text:='';
  edtSubtotal.Text:='';
  edtDescuentoenPesos.Text:=intToStr(0);
  edtTotal.Text:='';
  edtEfectivo.Text:='';
  edtCambio.Text:='';
  SpinEdtCantidad.Text:='';
  grdVenta.RowCount:=1;
  total:=0;
end;
procedure TfrmConsulta.sumarVentaAlVendedor();
var
   us:TUsuario;
   pos:integer;
begin
   pos:=BuscarUsuario(edtVendedor.Text);
   us:=ObtenerUsuario(edtVendedor.Text);
   us.VentasRealizadas:=us.VentasRealizadas+StringToFloat(edtTotal.Text);
   ModificarU(pos,us);
end;


function TfrmConsulta.obtenerPos():integer;
var
  i: integer;
begin
  for i:=1 to M do
  begin
   if (vVenta[i].codigo=comboCod.text) then
   obtenerPos:=i;
  end;
end;
procedure TfrmConsulta.quitarArticulo(var M:integer; var vvVenta:TvectorVenta);
 var
   i, pos: integer;
 begin
    pos:= obtenerPos;
    for i:=pos to M-1 do
  begin
    vVenta[i].codigo:=vVenta[i+1].codigo;
    vVenta[i].descripcion:=vVenta[i+1].descripcion;
    vVenta[i].cantidad:=vVenta[i+1].cantidad;
    vVenta[i].PrecioU:=vVenta[i+1].PrecioU;
    vVenta[i].importe:=vVenta[i+1].importe;
    vVenta[i].numero:=vVenta[i+1].numero;
  end;
     M:=M-1;
 end;

procedure TfrmConsulta.LeerVenta(var rVenta:TVenta);
begin
  rVenta.descripcion:=comboArt.Text;
  rVenta.cantidad:=StrToInt(SpinEdtCantidad.Text);
  rVenta.PrecioU:=StringToFloat(edtPrecioUnitario.Text);
  rVenta.codigo:=comboCod.Text;
  rVenta.importe:=CalculoImporte(SpinEdtCantidad.Text, edtPrecioUnitario.Text);

end;
procedure Cargar(rVenta:TVenta; var vVenta: TvectorVenta; var M:integer);
begin
  M:=M+1;
  vVenta[M]:=rVenta;
end;
procedure TfrmConsulta.MostrarVenta(vVenta: TvectorVenta; M:integer);
var
  i,fila:integer;
  importe,PreUni:cadena50;
begin
  grdVenta.RowCount:=1;
  for i:=1 to M do
  begin
    grdVenta.RowCount:=grdVenta.RowCount+1;
    fila:=grdVenta.RowCount;
    Str(vVenta[i].PrecioU:5:2,PreUni);
    str(vVenta[i].importe:5:2,importe);
    grdVenta.cells[0,fila-1]:=inttostr(fila-1);
    grdVenta.Cells[1,fila-1]:=vVenta[i].codigo;
    grdVenta.cells[2,fila-1]:=vVenta[i].descripcion;
    grdVenta.cells[3,fila-1]:=IntToStr(vVenta[i].cantidad);
    grdVenta.cells[4,fila-1]:=PreUni;
    grdVenta.cells[5,fila-1]:=importe;
  end;
end;
procedure TfrmConsulta.aviso();
begin
  if (comboArt.Text='') or (comboCod.Text='') or(edtPrecioUnitario.Text='')then
  showMessage('SE DEBEN COMPLETAR  TODOS LOS CAMPOS PARA REALIZAR LA VENTA')
end;
procedure TfrmConsulta.InicializarVenta();
begin
comboCod.Text:='';
  comboArt.Text:='';
  edtPrecioUnitario.Text:='';

end;
procedure mostrarRegistro();
begin
  frmModificar.edtId.Text:= frmConsulta.grdVenta.Cells[0,frmConsulta.grdVenta.Row];
  frmModificar.edtCodigo.Text:= frmConsulta.grdVenta.Cells[1,frmConsulta.grdVenta.Row];
  frmModificar.edtDescripcion.Text:= frmConsulta.grdVenta.Cells[2,frmConsulta.grdVenta.Row];
  frmModificar.edtCantidad.Text:= frmConsulta.grdVenta.Cells[3,frmConsulta.grdVenta.Row];
  frmModificar.edtPrecioUnit.Text:=frmConsulta.grdVenta.Cells[4,frmConsulta.grdVenta.Row];
  frmModificar.edtImporte.text:=frmConsulta.grdVenta.Cells[5,frmConsulta.grdVenta.Row];

end;

procedure TfrmConsulta.btnCobrarClick(Sender: TObject);
begin

end;

procedure TfrmConsulta.btnDescuentoClick(Sender: TObject);
begin

end;

procedure TfrmConsulta.btnFinalizarClick(Sender: TObject);
begin

end;

procedure TfrmConsulta.ActualizarSubTotal(v:TvectorVenta);
var
  subTotal:real;
  subTotalStr:cadena50;
begin
 subTotal:=0;
 for i:=0 to M do
 begin
  subTotal:=subTotal + v[i].importe;
 end;
 Str(subTotal:10:2,subTotalStr);
 edtSubtotal.Text:=subTotalStr;
end;

procedure TfrmConsulta.ActualizarDescuento();
var
  codigo, ImporteMin, Descuento:integer;
  Subtotalreal, Descuentoreal:real;
  Desc:cadena10;
begin
 Val(edtSubtotal.Text,Subtotalreal,codigo);
 ImporteMin:=ObtenerImporteMinimo();
 Descuento:=ObtenerDescuento();
 if (Subtotalreal>=ImporteMin) then
 begin
 Descuentoreal:=Subtotalreal*(Descuento/100);
 Str(Descuentoreal:5:2,Desc);
 edtDescuentoenPesos.Text:=Desc;
 end;
end;

procedure TfrmConsulta.ActualizarTotal(v:TvectorVenta);
var
  DescuentoenPesosreal, TotalconDescuento, Subtotalreal :real;
  TotalconDescuentostr:cadena10;
  ImporteMin:integer;
begin
 Val(edtDescuentoenPesos.Text,DescuentoenPesosreal);
 Val(edtSubtotal.Text,Subtotalreal);
 ImporteMin:=ObtenerImporteMinimo();
 if(Subtotalreal>=ImporteMin) then
 begin
 TotalconDescuento:= Subtotalreal-DescuentoenPesosreal;
 Str(TotalconDescuento:5:2,TotalconDescuentostr);
 edtTotal.Text:=TotalconDescuentostr;
 end
 else
 edtTotal.Text:=edtSubtotal.Text;
end;


procedure TfrmConsulta.FormCreate(Sender: TObject);
begin
  crearFicheroFactura();
  crearFicheroDetalle();
end;

procedure TfrmConsulta.FormShow(Sender: TObject);
begin
  edtFecha.Text:=DateToStr(Date());
  edtCliente.Text:='-Cliente Ocasional-';
  edtVendedor.Text:=usuarioActual;
  edtDescuentoenPesos.Text:=intToStr(0);
end;

procedure TfrmConsulta.grdVentaDblClick(Sender: TObject);
begin
  comboCod.Text:=grdVenta.Cells[1,grdVenta.Row];
  comboArt.Text:=grdVenta.Cells[2,grdVenta.Row];
  SpinEdtCantidad.Text:=grdVenta.Cells[3,frmConsulta.grdVenta.Row];
  edtPrecioUnitario.Text:=grdVenta.Cells[4,frmConsulta.grdVenta.Row];
  OK:=1;
end;

procedure TfrmConsulta.SpeedButtonCobrarClick(Sender: TObject);
var
  efectivo,total,cambio:real;
  cambiostr:cadena10;
begin
 edtCambio.Text:='';
 if (edtEfectivo.text<>'') and (edtTotal.Text<>'') then
 begin
  efectivo:=StringToFloat(edtEfectivo.Text);
  total:=StringToFloat(edtTotal.Text);
  if efectivo<total then
  begin
     ShowMessage('ADVERTENCIA: No es posible realizar el cobro,importe en efectivo menor al total');
     edtEfectivo.Text:='';
  end
  else
    begin
     PlaySound(AUDIO1,0,SND_ASYNC);
     cambio:=efectivo-total;
     str(cambio:10:2,cambiostr);
     edtCambio.Text:=cambiostr;
    end;
 end
 else
     ShowMessage('No es posible realizar el cobro: No ha ingresado ningún valor');
end;

procedure TfrmConsulta.aviso(r:TArticulo);
begin
 if (r.stock<=20) then
  begin
   labelAviso.Visible:=true;
   labelAviso.Caption:=('EL ARTICULO '+ r.descripcion+'ESTÁ PRÓXIMO A AGOTARSE');
  end
 else
   labelAviso.Visible:=false;
end;
function BusquedaLineal(elemento: cadena10; v: TvectorVenta; N:integer): integer;
var
i:integer;
begin
 i:=1;
 while ((i<=N) and (v[i].codigo<>elemento)) do
 inc(i);
 if (i<=N) then
 BusquedaLineal:=i
 else
 BusquedaLineal:=NO_ENCONTRADO;
end;

function comparar(suma:integer):boolean;
var
 pos:integer;
 articulo:TArticulo;
 comp:boolean;
begin
   comp:=false;
   pos:=buscarDescripcion(fi,frmConsulta.comboArt.text);
   articulo:=darUnArticulo(pos);
   if suma<=articulo.stock then
   comp:=true;
   comparar:=comp;
end;

procedure TfrmConsulta.controlArticulo(buscado:cadena50);
var
  l,pos,c, sumas:integer;
  encontrado:boolean;
begin
  encontrado:=false;
  for l:=1 to M do
  begin
   if(vVenta[l].descripcion=buscado) then
     begin
     encontrado:=True;
     pos:=l;
     c:=vVenta[l].cantidad;
   end;
  end;
  if encontrado then
   begin
   sumas:=( c + strtoint(SpinEdtCantidad.Text));
    if (comparar(sumas)) then
    begin
    rVenta.cantidad:=( c + strtoint(SpinEdtCantidad.Text));
    rVenta.importe:=CalculoImporte(inttostr(rVenta.cantidad),edtPrecioUnitario.Text);
    vVenta[pos].cantidad:= rVenta.cantidad;
    vVenta[pos].importe:=rVenta.importe;
    MostrarVenta(vVenta,M);
   end
    else
    showMessage('Ya no queda stock de '+comboArt.text +' disponible');
   end
  else
  begin
  LeerVenta(rVenta);
  Cargar(rVenta, vVenta, M);
  MostrarVenta(vVenta, M);
  end;
end;
procedure TfrmConsulta.ventaMod;
var
   posicion:integer;
begin
    posicion:=BusquedaLineal(comboCod.Text,vVenta,M);
    rVenta.cantidad:=strtoInt(SpinEdtCantidad.Text);
    rVenta.importe:=CalculoImporte(SpinEdtCantidad.Text,edtPrecioUnitario.Text);
    vVenta[posicion].cantidad:=rVenta.cantidad;
    vVenta[posicion].importe:=rVenta.importe;
    comboArt.Enabled:=true;
    comboCod.Enabled:=true;
    MostrarVenta(vVenta,M);
    SpeedButtonAgregar.Caption:='AGREGAR';
end;

procedure TfrmConsulta.SpeedButtonAgregarClick(Sender: TObject);
var
  pos:integer;
  Art:TArticulo;
begin
 if (comboArt.Text<>'') and(comboCod.Text<>'') and(edtPrecioUnitario.Text<>'')then
    begin
      pos:=buscarDescripcion(fi,comboArt.Text);
      Art:=darUnArticulo(pos);
        if (ValidarStock(StrToInt(SpinEdtCantidad.text),Art)=true) then
          begin
            if (SpeedButtonAgregar.Caption='AGREGAR') then
            controlArticulo(comboArt.Text);
            if(SpeedButtonAgregar.Caption='MODIFICAR') then
             ventaMod;
            ActualizarSubTotal(vVenta);
            ActualizarDescuento();
            ActualizarTotal(vVenta);
            InicializarVenta();
            SpinEdtCantidad.text:='';
            if edtEfectivo.text<>'' then
             SpeedButtonCobrarClick(sender);
            aviso(Art);
          end
        else
     begin
       ShowMessage('La cantidad de stock disponible es: '+ IntToStr(Art.stock) + '. Ingrese una cantidad valida');
       SpinEdtCantidad.Text:='';
       SpinEdtCantidad.SetFocus;
     end;
    end
   else
   aviso;
end;

procedure TfrmConsulta.SpeedButtonCambiarcantidadClick(Sender: TObject);
begin
   if OK=1 then
    begin
    SpeedButtonAgregar.Caption:='MODIFICAR';
    comboCod.Enabled:=false;
    comboArt.Enabled:=false;
    SpinEdtCantidad.Enabled:=true;
    SpinEdtCantidad.SetFocus;
    OK:=0;
    end
   else
    showMessage('Seleccione el artículo que desea modificar');
end;
procedure TfrmConsulta.SpeedButtonCancelarClick(Sender: TObject);
begin
    if confirmarOperacion('¿Está seguro que desea cancelar la compra?') then
     Limpiar();
end;

procedure TfrmConsulta.SpeedButtonDescuentoClick(Sender: TObject);
begin
  frmDescuento.Showmodal;
end;

procedure TfrmConsulta.SpeedButtonFinalizarClick(Sender: TObject);
var
  i,cantArticulos:integer;
begin
  if CamposLlenos()then
  begin
       leerFactura(rfactura);
       nuevaFactura(rfactura);
       cantArticulos:=grdVenta.RowCount-1;
       for i:=1 to cantArticulos do
       begin
          PlaySound(AUDIO2,0,SND_ASYNC);
         leerDetalle(rdetalle,i);
         nuevoDetalle(rdetalle);
         CrearExcel();
         DescontarStocks(i);
       end;
       sumarVentaAlVendedor();
       ShowMessage('La factura fue guardada con éxito');
       Limpiar();
  end
  else
      ShowMessage('No se han completado todos los campos');
end;

procedure TfrmConsulta.SpeedButtonQuitarClick(Sender: TObject);
var
  mensaje:string;
begin
  if (OK=1)and(comboArt.Text<>'') and(comboCod.Text<>'')then
    begin
     mensaje:= '¿Está seguro que desea eliminar al artículo de código: '+comboCod.Text+' con descripción '+comboArt.text+'?';
     if confirmarOperacion(mensaje) then
       begin
        quitarArticulo(M, vVenta);
        FormActivate(Sender);
        MostrarVenta(vVenta, M);
        InicializarVenta();
       end;
    end
  else
      ShowMessage('Codigo no encontrado. Haga doble click en el codigo que desea eliminar' );
end;

procedure TfrmConsulta.SpeedButtonVolverClick(Sender: TObject);
begin
  Close;
end;


initialization
total:=0;

end.

