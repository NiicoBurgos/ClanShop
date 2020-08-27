unit uArticulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons, Menus, uDAOArticulos, uCrudArticulos, uEstructura, utiles,
  frmTopVentas, uActualizarP, uDAOSolicitar, uEnviarMail;

type

  { TfrmArticulos }

  TfrmArticulos = class(TForm)
    edtDescripcion: TEdit;
    edtCodigo: TEdit;
    edtStock: TEdit;
    grdListaArticulos: TStringGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelTodos: TLabel;
    LabelMenor: TLabel;
    LabelIgual: TLabel;
    LabelMayor: TLabel;
    lblControl: TLabel;
    lblCriterios: TLabel;
    MainMenu1: TMainMenu;
    itemActualizar: TMenuItem;
    itemPorcentaje: TMenuItem;
    itemTodos: TMenuItem;
    itemSeleccionados: TMenuItem;
    RadioIgual: TRadioButton;
    RadioMayor: TRadioButton;
    RadioMenor: TRadioButton;
    RadioTodos: TRadioButton;
    SpeedButtonSolicitar: TSpeedButton;
    SpeedButtonOk: TSpeedButton;
    SpeedButtonAlta: TSpeedButton;
    SpeedButtonEliminar: TSpeedButton;
    SpeedButtonTopVentas1: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    SpeedButtonModificar: TSpeedButton;
    procedure edtCodigoChange(Sender: TObject);
    procedure edtDescripcionChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdListaArticulosDblClick(Sender: TObject);
    procedure grdListaArticulosPrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure itemPorcentajeClick(Sender: TObject);
    procedure itemSeleccionadosClick(Sender: TObject);
    procedure itemTodosClick(Sender: TObject);
    procedure SpeedButtonAltaClick(Sender: TObject);
    procedure SpeedButtonEliminarClick(Sender: TObject);
    procedure SpeedButtonModificarClick(Sender: TObject);
    procedure SpeedButtonOkClick(Sender: TObject);
    procedure SpeedButtonPorcentajeClick(Sender: TObject);
    procedure SpeedButtonSolicitarClick(Sender: TObject);
    procedure SpeedButtonTopVentasClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
     Procedure CargarGrilla(vArticulo:TvectorArticulo;N:integer);
     procedure mostrarRegistro;
     procedure LimpiarBusquedas;
     procedure Eleccion(sender:Tobject);
     procedure Limpiar;
     function buscargrilla(idinteger:integer):integer;
     procedure LeerFila(var rArticulos:TArticulo; C1,C2,C3,C4,C5,C6:cadena50);
     procedure asignar(fila:integer);
     procedure verificar;
  end;

var
  frmArticulos: TfrmArticulos;
  OK,StckInt:integer;
  idstr,cod,des,preciostr,stockstr,est:cadena50;
  habilitar:boolean;

implementation

{$R *.lfm}

{ TfrmArticulos }

procedure TfrmArticulos.Limpiar;
begin
  RadioIgual.Checked:=false;
  RadioMayor.Checked:=false;
  RadioMenor.Checked:=false;
  RadioTodos.Checked:=false;
end;

procedure TfrmArticulos.edtCodigoChange(Sender: TObject);
begin
    BuscarCodigo(edtCodigo.Text,vArticulo, N);
   if N=0 then
   begin
     showMessage('EL ARTICULO QUE BUSCA NO SE ENCUENTRA DISPONIBLE');
     FormActivate(Sender);
     edtCodigo.Text:='';
   end
   else
    CargarGrilla(vArticulo, N);
end;

procedure TfrmArticulos.edtDescripcionChange(Sender: TObject);
begin
   BuscarDescripcion(edtDescripcion.Text, vArticulo, N);
  if N=0 then
  begin
   showMessage('EL ARTICULO QUE BUSCA NO SE ENCUENTRA DISPONIBLE');
   edtDescripcion.Text:='';
   FormActivate(Sender);
   end
   else
   CargarGrilla(vArticulo, N);
 end;

procedure TfrmArticulos.LimpiarBusquedas();
begin
  edtCodigo.Text:='';
  edtDescripcion.Text:='';
end;
Procedure TfrmArticulos.CargarGrilla(vArticulo:TvectorArticulo;N:integer);
var
  i, fila: integer;
  idstring, stockstring, preciostring: String;
begin
  grdListaArticulos.RowCount:=1;
  for i:=1 to N do
  begin
    grdListaArticulos.RowCount:=grdListaArticulos.RowCount + 1;
    fila:=grdListaArticulos.RowCount;
    Str(vArticulo[i].id, idstring);
    Str(vArticulo[i].precioUnitario:8:2, preciostring);
    Str(vArticulo[i].stock, stockstring);
    grdListaArticulos.Cells[1,fila-1]:=idstring;
    grdListaArticulos.Cells[2,fila-1]:=vArticulo[i].codigo;
    grdListaArticulos.Cells[3,fila-1]:=vArticulo[i].descripcion;
    grdListaArticulos.Cells[4,fila-1]:=preciostring;
    grdListaArticulos.Cells[5,fila-1]:=stockstring;
    grdListaArticulos.Cells[6,fila-1]:=vArticulo[i].estado;
  end;

end;
procedure TfrmArticulos.Eleccion(sender:Tobject);
var
  RMenor,RMayor,RIgual,RTodos:boolean;
begin
   RMenor:=RadioMenor.Checked;
   RMayor:=RadioMayor.Checked;
   RIgual:=RadioIgual.Checked;
   RTodos:=RadioTodos.Checked;
   if (RMenor=false) and (RMayor=false) and (RIgual=false) and (RTodos=false) then
    showMessage('ELIJA UNA OPCION (Menor, mayor o igual)')
   else
   begin
    if RMenor=True then
      BuscarStockMenor(StckInt,vArticulo, N);
    if RMayor=True then
      BuscarStockMayor(StckInt,vArticulo,N);
    if RIgual=True then
      BuscarStockIgual(StckInt,vArticulo,N);
   if (N=0)then
    begin
      showMessage('NO SE ENCUENTRA ESA CANTIDAD DE ARTICULOS');
      edtStock.Text:='';
      edtStock.setfocus;
      FormActivate(Sender);
    end
   else
    begin
    CargarGrilla(vArticulo, N);
    edtStock.Text:='';
    edtStock.setfocus;
    end;
   end;
end;


function tfrmArticulos.buscargrilla(idinteger:integer):integer;
var
  encontrado,i:integer;
begin
  for i:=1 to grdListaArticulos.RowCount - 1 do
  begin
  if idinteger=strtoint(grdListaArticulos.Cells[1,i])then
   begin
    encontrado:=i;
   end;
  end;
  buscargrilla:=encontrado;
end;

procedure TfrmArticulos.grdListaArticulosPrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  i:integer;
begin
  buscar1(vArticulo,N);
  for i :=1 to N do
  begin
  if arow=buscargrilla(vArticulo[i].id) then
   grdListaArticulos.Canvas.Brush.Color:=clred;
end;
end;

procedure TfrmArticulos.itemPorcentajeClick(Sender: TObject);
begin
  frmActualizar.Showmodal;
end;



procedure TfrmArticulos.LeerFila(var rArticulos:TArticulo; C1,C2,C3,C4,C5,C6:cadena50);
begin
  rArticulos.id:=strtoInt(C1);
  rArticulos.codigo:=C2;
  rArticulos.descripcion:=C3;
  rArticulos.precioUnitario:=StringToFloat(C4);
  rArticulos.stock:=strtoint(C5);
  rArticulos.estado:=C6;
end;
procedure TfrmArticulos.asignar(fila:integer);
begin
  idstr:=grdListaArticulos.Cells[1,fila];
  cod:=grdListaArticulos.Cells[2,fila];
  des:=grdListaArticulos.Cells[3,fila];
  preciostr:=grdListaArticulos.Cells[4,fila];
  stockstr:=grdListaArticulos.Cells[5,fila];
  est:=grdListaArticulos.Cells[6,fila];
end;
function aplicar(precio,porcentaje:cadena10):real;
var
  aumento:real;
begin
   aumento:=(StringToFloat(precio)+(StringToFloat(precio)*StringToFloat(porcentaje)/100));
   aplicar:=aumento;
end;
procedure TfrmArticulos.verificar;
begin
  habilitar:=false;
  if frmActualizar.edtAumento.Text='' then
   showMessage('PRIMERO DEBE DETERMINAR EL PORCENTAJE DE AUMENTO HACIENDO CLIK EN EL BOTON POCENTAJE')
   else
    habilitar:=True;
end;
procedure TfrmArticulos.itemTodosClick(Sender: TObject);
var
i,pos: Integer;
pregunta:string;
begin
verificar;
if habilitar then
begin
pregunta:= (' ¿ESTA SEGURO QUE DESEA MODIFICAR EL PRECIO DE TODOS LOS ARTICULOS ?');
if confirmarOperacion(pregunta) then
begin
for  i :=1 to grdListaArticulos.RowCount-1 do
begin
  asignar(i);
  LeerFila(rArticulos,idstr,cod,des,preciostr,stockstr,est);
  pos:=buscarID(fi,strtoint(idstr));
  rArticulos.precioUnitario:=aplicar(preciostr,frmActualizar.edtAumento.Text);
  Modificar(rArticulos,pos);
end;
FormActivate(sender);
frmActualizar.edtAumento.text:='';
end;
end;
end;
procedure TfrmArticulos.itemSeleccionadosClick(Sender: TObject);
var
i,pos: Integer;
pregunta:string;
begin
verificar;
if habilitar then
begin
pregunta:= (' ¿ESTA SEGURO QUE DESEA MODIFICAR EL PRECIO DE LOS ARTICULOS SELECCIONADOS?');
if confirmarOperacion(pregunta) then
begin
for  i := (grdListaArticulos.Selection.Top) to (grdListaArticulos.Selection.Bottom) do
begin
  asignar(i);
  LeerFila(rArticulos,idstr,cod,des,preciostr,stockstr,est);
  pos:=buscarID(fi,strtoint(idstr));
  rArticulos.precioUnitario:=aplicar(preciostr,frmActualizar.edtAumento.Text);
  Modificar(rArticulos,pos);
end;
FormActivate(sender);
frmActualizar.edtAumento.text:='';
end;
end;
end;

procedure TfrmArticulos.SpeedButtonAltaClick(Sender: TObject);
begin
   frmCrudArticulos.Show;
  frmCrudArticulos.Caption:='Alta de Artículos';
  frmCrudArticulos.lblTitulo.Caption:='Alta de Artículos';
  frmCrudArticulos.SpeedButtonAlta.Caption:='ALTA';
  frmCrudArticulos.edtCodigo.Enabled:=true;
  frmCrudArticulos.edtId.caption:=IntToStr(getSiguienteId());
end;

procedure TfrmArticulos.SpeedButtonEliminarClick(Sender: TObject);
var
  codigo:cadena10;
  mensaje:string;
  articulo:TArticulo;
  posicion:integer;
begin
  codigo:=edtCodigo.Text;
  posicion:= buscarCod(fi, codigo);
  if (posicion<>NO_ENCONTRADO) and (OK=1) then
    begin
     mensaje:= '¿Está seguro que desea eliminar al artículo de código: '+codigo+' con descripción '+edtDescripcion.text+'?';
     if confirmarOperacion(mensaje) then
       begin
        eliminar(posicion, articulo);
        FormActivate(Sender);
       end;
    end
  else
      ShowMessage('Codigo no encontrado. Haga doble click en el codigo que desea eliminar' );
end;

procedure TfrmArticulos.SpeedButtonModificarClick(Sender: TObject);
begin
   if (OK=1) and (edtDescripcion.Text<>'') then
    begin
      mostrarRegistro;
      frmCrudArticulos.Show;
      frmCrudArticulos.Caption:='Modificación de Artículos';
      frmCrudArticulos.lblTitulo.Caption:='Modificación de Artículos';
      frmCrudArticulos.SpeedButtonAlta.Caption:='MODIFICAR';
      OK:=0;
  end
   else
     ShowMessage('DEBE SELECCIONAR EL ARTICULO QUE DESEA MODIFICAR');
end;

procedure TfrmArticulos.SpeedButtonOkClick(Sender: TObject);
begin
  if (RadioTodos.Checked=True) then
   FormActivate(Sender)
  else
    if (edtStock.Text<>'')then
     begin
      val(edtStock.Text,StckInt);
      Eleccion(sender);
     end
    else
       showMessage('INGRESE LA CANTIDAD QUE DESEA VEFIFICAR');
  limpiar;
end;

procedure TfrmArticulos.SpeedButtonPorcentajeClick(Sender: TObject);
begin
  frmActualizar.showmodal;
end;

procedure TfrmArticulos.SpeedButtonSolicitarClick(Sender: TObject);
var
  V:TvectorArticulo;
  Z:integer;
begin
  BuscarStockMenor(20,V,Z);
  if (Z>=5) then
  begin
    CrearFicheroStock();
    FormEMail.Showmodal();
  end
  else
  ShowMessage('Hay menos de 5 productos con stock menor a 20, No es necesario solicitar más stock aún');
end;

procedure TfrmArticulos.SpeedButtonTopVentasClick(Sender: TObject);
begin
  frmProductosMasVendidos.Showmodal;
end;

procedure TfrmArticulos.SpeedButtonVolverClick(Sender: TObject);
begin
  edtCodigo.Text:='';
  edtDescripcion.Text:='';
  close;
end;

procedure TfrmArticulos.FormActivate(Sender: TObject);
begin
  buscar(vArticulo, N);
  CargarGrilla(vArticulo, N);
  edtCodigo.Text:='';
  edtDescripcion.Text:='';
end;

procedure TfrmArticulos.FormCreate(Sender: TObject);
begin
   CrearFichero();
end;
procedure TfrmArticulos.mostrarRegistro;
var
  RArt:TArticulo;
begin
   frmCrudArticulos.edtId.Text:= grdListaArticulos.Cells[1,grdListaArticulos.Row];
   frmCrudArticulos.edtCodigo.Text:= grdListaArticulos.Cells[2,grdListaArticulos.Row];
   frmCrudArticulos.edtDescripcion.Text:= grdListaArticulos.Cells[3,grdListaArticulos.Row];
   frmCrudArticulos.edtPrecioUnitario.Text:= grdListaArticulos.Cells[4,grdListaArticulos.Row];
   frmCrudArticulos.edtStock.Text:= grdListaArticulos.Cells[5,grdListaArticulos.Row];
end;




procedure TfrmArticulos.grdListaArticulosDblClick(Sender: TObject);
begin
  OK:=1;
  edtCodigo.Text:=grdListaArticulos.Cells[2,grdListaArticulos.Row];
  edtDescripcion.Text:=grdListaArticulos.Cells[3,grdListaarticulos.Row];
end;

end.

