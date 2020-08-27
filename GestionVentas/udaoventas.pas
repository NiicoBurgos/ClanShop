unit uDAOVentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uEstructura,utiles;
var
  fac:TFicheroFactura;
  det:TFicheroDetalles;
  factura:TFactura;
  detalle:TDetalle;
  procedure crearFicheroFactura();
  procedure crearFicheroDetalle();
  function getSiguienteFactura():integer;
  procedure nuevaFactura( var factura:TFactura);
  procedure nuevoDetalle( var detalle:TDetalle);
  function darUnaFactura(posicion:integer):TFactura;
  procedure buscarVentas(var V:TvectorFactura; var N:integer);
  procedure buscarFecha(fecha:cadena50;var v:TvectorFactura;var n:integer);
  procedure buscarVendedor(nombre: cadena50; var v:TvectorFactura;var n:integer);
  procedure buscarCliente(nombre: cadena50; var v:TvectorFactura;var n:integer);
  procedure buscarDetalles( var v:TvectorDetalles; var N:integer; idfactura:integer);
  Function buscarIdFactura( id:integer):integer;
  procedure getAll(var vDetalles:TVectorDetalles; var N:integer ; idFactura: cadena10);
implementation
procedure getAll(var vDetalles:TVectorDetalles; var N:integer ; idFactura: cadena10);
begin
  try
    reset(det);
    N:=0;
    while not eof(det)do
          begin
             read(det, detalle);
             if ( detalle.idFactura = StrToInt(idFactura)) then
             begin
                 inc(N);
                 vDetalles[N]:=detalle;
             end;

          end;
  finally
    CloseFile(det);
  end;
end;
function darUnaFactura(posicion:integer):TFactura;
var
  factura:TFactura;
begin
  try
    reset(fac);
    seek(fac,posicion);
    read(fac,factura);
  finally
    CloseFile(fac);
  end;
  darUnaFactura:=factura;
end;
procedure crearFicheroFactura();
begin
  AssignFile(fac,FICHERO_FACTURAS);
  try
    reset(fac);
    closeFile(fac);
  Except
    rewrite(fac);
    closeFile(fac);
  end;
end;
procedure crearFicheroDetalle();
begin
    AssignFile(det,FICHERO_DETALLES);
  try
    reset(det);
    closeFile(det);
  Except
    rewrite(det);
    closeFile(det);
  end;
end;
function getSiguienteFactura():integer;
var
id:integer;
factura: TFactura;
begin
  id:=0;
  reset(fac);
  while not eof(fac) do
    begin
      read(fac, factura);
      inc(id);
      end;
  Closefile(fac);
  getSiguienteFactura:=id+1;
end;
procedure nuevaFactura(var factura:TFactura);
begin
  try
    reset(fac);
    seek(fac,FileSize(fac));
    Write(fac,factura);
  finally
    CloseFile(fac);
  end;
end;
procedure nuevoDetalle(var detalle:TDetalle);
begin
  try
    reset(det);
    seek(det,FileSize(det));
    Write(det,detalle);
  finally
    CloseFile(det);
  end;
end;
procedure buscarVentas(var V:TvectorFactura; var N:integer);
var
  factura:TFactura;
begin
  try
      reset(fac);
      N:=0;
      while not eof(fac) do
       begin
         read(fac,factura);
         if (factura.estado<> ESTADO_ELIMINADO) then
         begin
           inc(N);
           V[N]:=factura;
         end;
       end;
  finally
  closefile(fac);
  end;
end;
procedure buscarFecha(fecha:cadena50;var v:TvectorFactura;var n:integer);
var
  factura:TFactura;
begin
  try
    reset(fac);
    n:=0;
    while not eof(fac) do
    begin
      read(fac,factura);
      if(factura.estado<> ESTADO_ELIMINADO) then
       if (pos(fecha,factura.fecha)<>0)or (fecha='') then
        begin
          inc(N);
          v[n]:=factura;
        end;
    end;
  finally
    closeFile(fac);
  end;
end;
procedure buscarVendedor(nombre: cadena50; var v:TvectorFactura;var n:integer);
var
  factura:TFactura;
begin
  try
    reset(fac);
    n:=0;
    while not eof(fac) do
    begin
      read(fac,factura);
      if(factura.estado<> ESTADO_ELIMINADO) then
       if (like(nombre,factura.vendedor.usuario))or (nombre='') then
        begin
          inc(N);
          v[n]:=factura;
        end;
    end;
  finally
    closeFile(fac);
  end;
end;
procedure buscarCliente(nombre: cadena50; var v:TvectorFactura;var n:integer);
var
  factura:TFactura;
begin
  try
    reset(fac);
    n:=0;
    while not eof(fac) do
    begin
      read(fac,factura);
      if(factura.estado<> ESTADO_ELIMINADO) then
       if (like(nombre,factura.nombreCliente))or (nombre='') then
        begin
          inc(N);
          v[n]:=factura;
        end;
    end;
  finally
    closeFile(fac);
  end;
end;
procedure buscarDetalles(var V:TvectorDetalles; var N:integer; idfactura:integer);
var
  detalle:TDetalle;
begin
  try
      reset(det);
      N:=0;
      while not eof(det) do
       begin
         read(det,detalle);
         if (detalle.idFactura=idfactura) then
         begin
           inc(N);
           V[N]:=detalle;
         end;
       end;
  finally
  closefile(det);
  end;
end;
Function buscarIdFactura(id:integer):integer;
var
  i, posicion: integer;
  factura:TFactura;
  begin
     try
       reset(fac);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(fac) and (posicion=NO_ENCONTRADO) do
          begin
            read(fac, factura);
            if id=factura.id then
              posicion:=i
              else
                i:=i+1;
          end;
       CloseFile(fac);
     finally
       buscarIdFactura:=posicion;
     end;
  end;
end.

