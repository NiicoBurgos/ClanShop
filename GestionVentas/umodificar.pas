unit uModificar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,uEstructura, Buttons, utiles, uDAOArticulos;

type

  { TfrmModificar }

  TfrmModificar = class(TForm)
    BitBtnCambiar: TBitBtn;
    BitBtnVolver: TBitBtn;
    edtCodigo: TEdit;
    edtDescripcion: TEdit;
    edtId: TEdit;
    edtCantidad: TEdit;
    edtPrecioUnit: TEdit;
    edtImporte: TEdit;
    lblCodigo: TLabel;
    lblDescripcion: TLabel;
    lblId: TLabel;
    lblCantidad: TLabel;
    lblPrecioUnit: TLabel;
    lblImporte: TLabel;
    procedure BitBtnCambiarClick(Sender: TObject);
    procedure BitBtnVolverClick(Sender: TObject);
  private

  public
    Procedure LeerDatos(var rVenta:TVenta);
  end;

var
  frmModificar: TfrmModificar;
  posicion:integer;

implementation

{$R *.lfm}

{ TfrmModificar }
Procedure TfrmModificar.LeerDatos(var rVenta:TVenta);
var
  code: integer;
  precioUnitario,Importe: real;
  Cantidad:integer;
begin
     val(frmModificar.edtImporte.text,Importe,code);
     val(frmModificar.edtPrecioUnit.text, precioUnitario, code);
     val(frmModificar.edtCantidad.text,Cantidad,code);
     rVenta.codigo:=frmModificar.edtCodigo.text;
     rVenta.descripcion:=frmModificar.edtDescripcion.text;
     rVenta.cantidad:=Cantidad;
     rVenta.PrecioU:=precioUnitario;
     rVenta.importe:=CalculoImporte(edtCantidad.Text,edtPrecioUnit.Text);

end;
procedure OrdenarCod(var vVenta:TvectorVenta; N:integer);
var
  i,j:integer;
  item:TVenta;
begin
	for i:=	2 to N do
	  begin
	    item:=vVenta[i];
	    j:=	i-1;
	    while(j>=1)	and(vVenta[j].codigo>item.codigo) do
	      begin
	       vVenta[j+1]:=vVenta[j];
	       dec(j);
	      end;
	      vVenta[j+1]:=item;
           end;
end;
function BusquedaBinaria(elemento:cadena10;var   vVenta:TvectorVenta; var N:integer):integer;
var
   e,d,medio:integer;
   pos:cadena10;
   encontrado:boolean;
begin
  e:=1;
  d:=N;
  encontrado:=false;
  while ((e<=d) and (not encontrado))do
  begin
  medio:=(e+d)div 2;
  if(vVenta[medio].codigo=elemento) then
    encontrado:=true
    else
      begin
      if(elemento>vVenta[medio].codigo)then
        e:=medio+1
        else
        d:=medio-1;
      end
  end;
   if encontrado then
  BusquedaBinaria:=medio
  else
  BusquedaBinaria:=NO_ENCONTRADO;
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
 BusquedaLineal:=-1;
end;
function BuscarCod(codigo:string):integer;
var
   pos:integer;
begin
   OrdenarCod(vVenta,M);
   pos:=BusquedaBinaria(codigo,vVenta,M);
   BuscarCod:=pos;
end;
procedure ModificarVenta(var vVenta:TvectorVenta;ventas:TVenta;posicion:integer);
begin
  vVenta[posicion]:=ventas;
end;

procedure TfrmModificar.BitBtnCambiarClick(Sender: TObject);
var
   pos:integer;
   Art:TArticulo;
begin
     if(edtCantidad.text<>'') then
  if(StrToInt(edtCantidad.text)>0)then
   begin
       pos:=buscarDescripcion(fi,edtDescripcion.Text);
       Art:=darUnArticulo(pos);
       if (ValidarStock(StrToInt(edtCantidad.text),Art)) then
       begin
       posicion:=BuscarCod(frmModificar.edtCodigo.text);
       leerdatos(rVenta);
       ModificarVenta(vVenta,rVenta, posicion);
       showMessage('Datos modificados correctamente.');
       close;
       end
       else
        begin
       ShowMessage('La cantidad de stock disponible es: '+ IntToStr(Art.stock) + '. Ingrese una cantidad valida');
       edtCantidad.Text:='';
       edtCantidad.SetFocus;
     end;
   end
   else
   begin
   edtCantidad.SetFocus;
   showMessage('Cantidad no válida: Ingrese una cantidad');
   end
  else
   showMessage('Ingrese una cantidad');
end;

procedure TfrmModificar.BitBtnVolverClick(Sender: TObject);
begin
  close;
end;

end.

