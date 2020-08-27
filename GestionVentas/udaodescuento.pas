unit uDAOdescuento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEstructura;
var
  f:TextFile;
  posicion: integer;
const
  IMPORTE_MINIMO='importeMinimo=';
  DESCUENTO='porcentajeDescuento=';
procedure CrearFichero(var f:TextFile);
procedure CrearFicheroDescuento();
procedure ModificarDesc(var f:TextFile; cadena1, cadena2:string);
function ObtenerDescuento():integer;
function ObtenerDesc(var f:TextFile): integer;
function ObtenerImporteMin(var f:TextFile): integer;
function ObtenerImporteMinimo():integer;

implementation

procedure CrearFicheroDescuento();
begin
  CrearFichero(f);
end;

procedure CrearFichero(var f:TextFile);
begin
   assignFile(f,FICHERO_DESCUENTO);
   try
     reset(f);
     closeFile(f);
   except
     rewrite(f);
     CloseFile(f);
   end;
end;
procedure ModificarDesc(var f:TextFile; cadena1, cadena2:string);
begin
   try
     Rewrite(f);
     WriteLn(f,IMPORTE_MINIMO+cadena1);
     WriteLn(f,DESCUENTO+cadena2);
     CloseFile(f);
   finally
   end;
end;
function ObtenerDescuento():integer;
begin
    ObtenerDescuento:=ObtenerDesc(f);
end;

function ObtenerDesc(var f:TextFile): integer;
var
  linea:string;
  LongDescuento, posicion, Longlinea:integer;
begin
  reset(f);
  LongDescuento:=length(DESCUENTO);
  while not eof(f) do
    begin
      readLn(f,linea);
      Longlinea:=length(linea);
      posicion:=pos(DESCUENTO,linea);
      if(posicion<>0) then
      begin
       ObtenerDesc:=StrToint(copy(linea,(LongDescuento+1),Longlinea));
      end;
    end;
end;

function ObtenerImporteMinimo():integer;
begin
    ObtenerImporteMinimo:=ObtenerImporteMin(f);
end;

function ObtenerImporteMin(var f:TextFile): integer;
var
  linea:string;
  LongImporteMinimo, posicion, Longlinea:integer;
begin
  reset(f);
  LongImporteMinimo:=length(IMPORTE_MINIMO);
  while not eof(f) do
    begin
      readLn(f,linea);
      Longlinea:=length(linea);
      posicion:=pos(IMPORTE_MINIMO,linea);
      if(posicion<>0) then
      begin
       ObtenerImporteMin:=StrToint(copy(linea,(LongImporteMinimo+1),Longlinea));
      end;

    end;
end;



end.

