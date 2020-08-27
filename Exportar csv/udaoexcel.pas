unit uDAOExcel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uDAOVentas,uEstructura;
procedure CrearExcel();
procedure CrearFichero(var nombreArchivo:string);
var
   t:text;
implementation
procedure CrearExcel();
var
   detalles: TVectorDetalles;
  n,i: Integer;
  nombreArchivo,lineaFactura, lineaDetalle: String;
  t: text;
begin
  uDAOVentas.getAll(detalles,n,IntToStr(rfactura.id));
    crearFichero( nombreArchivo);
  Assign(t,nombreArchivo);
  Rewrite(t);
  WriteLn( t, tituloFactura );
  lineaFactura:= IntToStr(rFactura.id)+';'+DateTimeToStr(rFactura.fecha)+';'+rfactura.nombreCliente+';'
                 +FloatToStr(rFactura.total)+';'+rFactura.vendedor.usuario+';'+FloatToStr(rFactura.descuento)+';'
                 +FloatToStr(rFactura.efectivo)+';'+FloatToStr(rFactura.cambio)+';'+rFactura.estado;
  WriteLn( t , lineaFactura);
  WriteLn( t , '' );
  WriteLn(t,tituloDetalle);
  for i := 1 to n do
  begin
    lineaDetalle:= IntToStr(detalles[i].numeroLinea)+';'
    +detalles[i].articulo.descripcion+';'+IntToStr(detalles[i].cantidad)+';'+FloatToStr(detalles[i].precioUnitario)+';'
    +FloatToStr(detalles[i].subtotal);
    WriteLn(t , lineaDetalle);
  end;
  CloseFile(t);
end;

procedure CrearFichero(var nombreArchivo:string);
var
    dd,mm,yy: word;
  data: String;
begin
  DecodeDate(rFactura.fecha,yy,mm,dd);
  data := Format('%d-%d-%d', [dd,mm,yy]);
  nombreArchivo:= 'Exportar csv/FacturasExcel/Factura-'+IntToStr(rFactura.id)+'-'+data+'.csv';
  //nombreArchivo:= 'Facturas/FacturasExcel/Factura.csv';
  assign(t, nombreArchivo);
  {$i-}
       reset(t);
  {$i+}
  if(IOResult = 0) then
      close(t)
  else
      begin
           Rewrite(t);
           Close(t);
      end;
end;

end.

