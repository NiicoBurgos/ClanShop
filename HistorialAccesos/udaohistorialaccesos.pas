unit uDAOhistorialaccesos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uEstructura,utiles;
var
  a:TFicheroAccesos;
  Acceso:TAccesos;
procedure CrearFichero();
procedure NuevoAcceso(var Acceso:TAccesos);
procedure buscar(var V:TvectorAccesos; var N:integer);
procedure buscarFecha(fecha:cadena10;var v:TvectorAccesos;var n:integer);
procedure buscarUsuario(usuario:cadena50;var v:TvectorAccesos;var n:integer);
procedure buscarCombinacionUsuarioFecha(usuario,fecha:cadena10;var v:TvectorAccesos;var n:integer);
implementation
procedure buscar(var V:TvectorAccesos; var N:integer);
var
  acceso:TAccesos;
begin
  try
      reset(a);
      N:=0;
      while not eof(a) do
       begin
         read(a,acceso);
         inc(N);
         V[N]:=acceso;
       end;
  finally
  closefile(a);
  end;
end;
procedure CrearFichero();
begin
   assignFile(a,FICHERO_ACCESOS);
   try
     reset(a);
     closeFile(a);
   except
     rewrite(a);
     CloseFile(a);
   end;
end;
procedure NuevoAcceso(var Acceso:TAccesos);
begin
   try
     reset(a);
     seek(a,FileSize(a));
     write(a,acceso);
   finally
     CloseFile(a);
   end;
end;
procedure buscarFecha(fecha:cadena10;var v:TvectorAccesos;var n:integer);
var
  acceso:TAccesos;
begin
  try
    reset(a);
    n:=0;
    while not eof(a) do
    begin
      read(a,acceso);
      if (pos(fecha,acceso.fecha)<>0)or (fecha='') then
        begin
          inc(N);
          v[n]:=acceso;
        end;
    end;
  finally
    closeFile(a);
  end;
end;
procedure buscarUsuario(usuario:cadena50;var v:TvectorAccesos;var n:integer);
  var
    acceso:TAccesos;
  begin
    try
      reset(a);
      n:=0;
      while not eof(a) do
      begin
        read(a,acceso);
         if (like(usuario,acceso.usuario))or (usuario='') then
          begin
            inc(N);
            v[n]:=acceso;
          end;
      end;
    finally
      closeFile(a);
    end;
  end;
procedure buscarCombinacionUsuarioFecha(usuario,fecha:cadena10;var v:TvectorAccesos;var n:integer);
  var
    acceso:TAccesos;
  begin
    try
     reset(a);
     n:=0;
     while not eof(a) do
      begin
       read(a,acceso);
       if (like(usuario,acceso.usuario))and (like(fecha,acceso.fecha)) then
        begin
         inc(N);
         v[n]:=acceso;
        end;
       end;
     finally
       closeFile(a);
     end;
  end;
end.

end.

