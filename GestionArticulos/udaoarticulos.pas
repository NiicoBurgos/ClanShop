unit uDAOArticulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEstructura,utiles;
 var
   fi:TFicheroArticulos;
   Articulo:TArticulo;
procedure CrearFichero();
Function buscarDescripcion(var fi:TFicheroArticulos; descripcion:cadena50):longInt;
function getSiguienteId():integer;
procedure eliminar(posicion:integer;articulo:TArticulo);
procedure Nuevo(Articulo:TArticulo);
procedure Modificar(articulo:TArticulo;posicion:integer);
Procedure BuscarDescripcion (descripcion:cadena50; var V:TVectorArticulo; var N:integer);
Procedure BuscarCodigo (codigo:cadena10; var V:TVectorArticulo; var N:integer);
Function buscarCod(var fi:TFicheroArticulos; codigo:cadena50):longInt;
procedure buscar(var V:TVectorArticulo; var N:integer);
Function buscarID(var fi:TFicheroArticulos; ID:integer):longInt;
Procedure BuscarStockMenor(stck:integer; var V:TVectorArticulo; var N:integer);
Procedure BuscarStockIgual(stck:integer; var V:TVectorArticulo; var N:integer);
Procedure BuscarStockMayor(stck:integer; var V:TVectorArticulo; var N:integer);
function darUnArticulo(posicion:integer):TArticulo;
procedure buscar1(var V:TVectorArticulo; var N:integer);
implementation

procedure buscar1(var V:TVectorArticulo; var N:integer);
var
  articulo:TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
       begin
         read(fi,articulo);
         if (articulo.estado<> ESTADO_ELIMINADO) then
          if(articulo.stock<=20) then
         begin
           inc(N);
           V[N]:=articulo;
         end;
       end;
  finally
  closefile(fi);
  end;
end;
function darUnArticulo(posicion:integer):TArticulo;
var
  art:TArticulo;
begin
  try
    reset(fi);
    seek(fi,posicion);
    read(fi,art);
  finally
    CloseFile(fi);
  end;
darUnArticulo:=art;
end;
procedure buscar(var V:TVectorArticulo; var N:integer);
var
  articulo:TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
       begin
         read(fi,articulo);
         if (articulo.estado<> ESTADO_ELIMINADO) then
         begin
           inc(N);
           V[N]:=articulo;
         end;
       end;
  finally
  closefile(fi);
  end;
end;
Function buscarCod(var fi:TFicheroArticulos; codigo:cadena50):longInt;
var
  i, posicion: LongInt;
  articulo:TArticulo;
  begin
     try
       reset(fi);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(fi) and (posicion=NO_ENCONTRADO) do
          begin
            read(fi, articulo);
            if  codigo=articulo.codigo then
              posicion:=i
              else
                i:=i+1;
          end;
       CloseFile(fi);
     finally
       buscarCod:=posicion;
     end;
  end;
Function buscarID(var fi:TFicheroArticulos; ID:integer):longInt;
var
  i, posicion: LongInt;
  art:TArticulo;
  begin
     try
       reset(fi);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(fi) and (posicion=NO_ENCONTRADO) do
          begin
            read(fi, art);
            if  ID=art.id then
              posicion:=i
              else
                i:=i+1;
          end;
       CloseFile(fi);
     finally
       buscarID:=posicion;
     end;
  end;


Function buscarDescripcion(var fi:TFicheroArticulos; descripcion:cadena50):longInt;
var
  i, posicion: LongInt;
  articulo:TArticulo;
  begin
     try
       reset(fi);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(fi) and (posicion=NO_ENCONTRADO) do
          begin
            read(fi, articulo);
            if uppercase(descripcion)=uppercase(articulo.descripcion) then
              posicion:=i
              else
                i:=i+1;
          end;
       CloseFile(fi);
     finally
       buscarDescripcion:=posicion;
     end;
  end;
procedure CrearFichero();
begin
   assignFile(fi,FICHERO_ARTICULOS);
   try
     reset(fi);
     closeFile(fi);
   except
     rewrite(fi);
     CloseFile(fi);
   end;
end;
procedure eliminar(posicion:integer;articulo:TArticulo);
begin
  try
    articulo.estado:=ESTADO_ELIMINADO;
    reset(fi);
    seek(fi,posicion);
    write(fi,articulo);
  finally
    CloseFile(fi);
  end;
end;
function getSiguienteId():integer;
var
id:integer;
articulo: TArticulo;
begin
  id:=0;
  reset(fi);
  while not eof(fi) do
    begin
      read(fi, articulo);
      inc(id);
      end;
  Closefile(fi);
  getSiguienteId:=id+1;
  end;
procedure Nuevo(Articulo:TArticulo);
begin
   try
     reset(fi);
     seek(fi,FileSize(fi));
     write(fi,Articulo);
   finally
     CloseFile(fi);
   end;

end;
procedure Modificar(articulo:TArticulo;posicion:integer);
begin
   try
     reset(fi);
     seek(fi,posicion);
     write(fi,Articulo);
     CloseFile(fi);
   finally
   end;
end;
Procedure BuscarDescripcion (descripcion:cadena50; var V:TVectorArticulo; var N:integer);
var
  RDes: TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
         begin
           read(fi,RDes);
           if (RDes.estado<> ESTADO_ELIMINADO) then
            if (like(descripcion,RDes.Descripcion)) or (descripcion='') then
            begin
              inc(N);
              V[N]:= RDes;
            end
         end;
  finally
    closeFile(fi);
  end;
end;
Procedure BuscarCodigo (codigo:cadena10; var V:TVectorArticulo; var N:integer);
var
  RCod: TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
         begin
           read(fi,RCod);
           if (RCod.estado<> ESTADO_ELIMINADO) then
            if (pos(codigo,RCod.codigo)<>0) or(codigo='')  then
            begin
              inc(N);
              V[N]:= RCod;
            end;
         end;
  finally
    closeFile(fi);
  end;
end;
Procedure BuscarStockMenor(stck:integer; var V:TVectorArticulo; var N:integer);
var
  RStk: TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
         begin
           read(fi,RStk);
           if (RStk.estado<> ESTADO_ELIMINADO) then
            if (RStk.stock<stck) then
            begin
              inc(N);
              V[N]:=RStk;
            end;
         end;
  finally
    closeFile(fi);
  end;
end;
Procedure BuscarStockIgual(stck:integer; var V:TVectorArticulo; var N:integer);
var
  RStk: TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
         begin
           read(fi,RStk);
           if (RStk.estado<> ESTADO_ELIMINADO) then
            if(RStk.stock=stck) then
            begin
              inc(N);
              V[N]:=RStk;
            end;
         end;
  finally
    closeFile(fi);
  end;
end;
Procedure BuscarStockMayor(stck:integer; var V:TVectorArticulo; var N:integer);
var
  RStk: TArticulo;
begin
  try
      reset(fi);
      N:=0;
      while not eof(fi) do
         begin
           read(fi,RStk);
           if (RStk.estado<> ESTADO_ELIMINADO) then
            if (RStk.stock>stck) then
            begin
              inc(N);
              V[N]:=RStk;
            end;
         end;
  finally
    closeFile(fi);
  end;
end;


end.

