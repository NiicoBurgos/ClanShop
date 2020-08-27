unit uDAOUsuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uEstructura,utiles;
var
  f:TFicheroUsuarios;
  Usuario:TUsuario;
procedure CrearFichero();
procedure Nuevo(var Usuario:TUsuario);
procedure ModificarU(posicion:integer; Usuario: TUsuario);

function getSiguienteId():integer;
procedure buscarNombre(nombre: cadena50; var v:TvectorUsuario;var n:integer);
procedure buscarDNI(dni:cadena10;var v:TvectorUsuario;var n:integer);
procedure buscar(var V:TVectorUsuario; var N:integer);
procedure eliminar(posicion:integer;usuario:TUsuario);
function buscarGeneral(cadena:Cadena10):integer;
Function buscarClave(clave:cadena50):integer;
Function buscarEstado(us:integer):integer;
function buscarUsuario(Usuario:Cadena10):integer;
function darUnUsuario(posicion:integer):TUsuario;
procedure buscarUsuario(usuarioAbuscar: cadena50; var v:TvectorUsuario;var n:integer);
procedure buscarCombinacionDniNombre(criterioDni,criterioNombre:cadena50;
  var v:TvectorUsuario;var N:integer);
procedure buscarCombinacionDniUsuario(criterioDni, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
procedure buscarCombinacionNombreUsuario(criterioNombre, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
procedure buscarTodosLosCriterios(criterioDni, criterioNombre, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
implementation
function darUnUsuario(posicion:integer):TUsuario;
var
  us:TUsuario;
begin
  try
    reset(f);
    seek(f,posicion);
    read(f,us);
  finally
    CloseFile(f);
  end;
darUnUsuario:=us;
end;

procedure buscar(var V:TVectorUsuario; var N:integer);
var
  usuario:TUsuario;
begin
  try
      reset(f);
      N:=0;
      while not eof(f) do
       begin
         read(f,usuario);
         if (usuario.estado<> ESTADO_ELIMINADO) then
         begin
           inc(N);
           V[N]:=usuario;
         end;
       end;
  finally
  closefile(f);
  end;
end;
procedure CrearFichero();
begin
   assignFile(f,FICHERO_USUARIOS);
   try
     reset(f);
     closeFile(f);
   except
     rewrite(f);
     CloseFile(f);
   end;
end;
procedure Nuevo(var Usuario:TUsuario);
begin
   try
     reset(f);
     seek(f,FileSize(f));
     write(f,Usuario);
   finally
     CloseFile(f);
   end;

end;
procedure ModificarU(posicion:integer; Usuario: TUsuario);
begin
   try
     reset(f);
     seek(f,posicion);
     write(f,Usuario);
     CloseFile(f);
   finally
   end;
end;

function buscarGeneral(cadena:Cadena10):integer;
var
  i,posicion1 , IDint, codigo: integer;
   Us:TUsuario;
begin
 try
   reset(f);
   posicion1 := NO_ENCONTRADO;
   i := 0;
  while not eof(f) and (posicion1 = NO_ENCONTRADO) do
       begin
         read(f, Us);
         Val(cadena,IDint,codigo);
         if (cadena = Us.dni) or (cadena = Us.nombre) or (cadena = Us.usuario) or (IDint=Us.id) then
             posicion1:= i
         else
            i := i + 1;
       end;
    closeFile(f);
 finally
   buscarGeneral:=posicion1;
 end;
end;

function getSiguienteId():integer;
var
id:integer;
usuario: TUsuario;
begin
  id:=0;
  reset(f);
  while not eof(f) do
    begin
      read(f, usuario);
      inc(id);
      end;
  Closefile(f);
  getSiguienteId:=id+1;
  end;
procedure buscarNombre(nombre: cadena50; var v:TvectorUsuario;var n:integer);
var
  usuario:TUsuario;
begin
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if (like(nombre,usuario.nombre))or (nombre='') then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;

procedure buscarDNI(dni:cadena10;var v:TvectorUsuario;var n:integer);
var
  usuario:TUsuario;
begin
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if (pos(dni,usuario.dni)<>0)or (dni='') then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;
procedure eliminar(posicion:integer;usuario:TUsuario);
begin
  try
    usuario.estado:=ESTADO_ELIMINADO;
    reset(f);
    seek(f,posicion);
    write(f,usuario);
  finally
    CloseFile(f);
  end;
end;

function buscarUsuario(Usuario:Cadena10):integer;
var
  i,posicion1 : integer;
   Us:TUsuario;
begin
 try
   reset(f);
   posicion1 := NO_ENCONTRADO;
   i := 0;
  while not eof(f) and (posicion1 = NO_ENCONTRADO) do
       begin
         read(f, Us);
         if Usuario = Us.usuario then
             posicion1:= i
         else
            i := i + 1;
       end;
    closeFile(f);
 finally
   buscarUsuario:=posicion1;
 end;
end;

Function buscarClave(clave:cadena50):integer;
var
  i, posicion: integer;
  usuariob:TUsuario;
  begin
     try
       reset(f);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(f) and (posicion=NO_ENCONTRADO) do
          begin
            read(f, usuariob);
            if clave=usuariob.clave then
              posicion:=i
              else
                i:=i+1;
          end;
       CloseFile(f);
     finally
       buscarClave:=posicion;
     end;
  end;
Function buscarEstado(us:integer):integer;
var
  i, posicion: integer;
  usuariob:TUsuario;
  begin
     try
       reset(f);
       posicion:= NO_ENCONTRADO;
       i:=0;
       while not eof(f) and (posicion=NO_ENCONTRADO) do
          begin
            read(f, usuariob);
            if (usuariob.estado=ESTADO_ACTIVO) and (us=i) then
              posicion:=i
              else
                i:=i+1
          end;
       CloseFile(f);
     finally
       buscarEstado:=posicion;
     end;
end;
procedure buscarUsuario(usuarioAbuscar: cadena50; var v:TvectorUsuario;var n:integer);
var
  usuario:TUsuario;
begin
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if (like(usuarioAbuscar,usuario.nombre))or (usuarioAbuscar='') then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;
procedure buscarCombinacionDniNombre(criterioDni,criterioNombre:cadena50;
  var v:TvectorUsuario;var N:integer);
var
  usuario:TUsuario;
  vacio:Boolean;
begin
  vacio:=(criterioDni='') or (criterioNombre='');
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if ((like(criterioDni,usuario.dni))and (like(criterioNombre,usuario.nombre))) or (vacio) then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;
procedure buscarCombinacionDniUsuario(criterioDni, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
var
  usuario:TUsuario;
  vacio:Boolean;
begin
  vacio:= (criterioDni='') or (criterioUsuario='');
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if ((like(criterioDni,usuario.dni))and (like(criterioUsuario,usuario.usuario))) or (vacio) then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;
procedure buscarCombinacionNombreUsuario(criterioNombre, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
var
  usuario:TUsuario;
  vacio:boolean;
begin
  vacio:=(criterioNombre='') or (criterioUsuario='');
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if ((like(criterioNombre,usuario.nombre))and (like(criterioUsuario,usuario.usuario))) or (vacio) then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;
procedure buscarTodosLosCriterios(criterioDni, criterioNombre, criterioUsuario: cadena50;
  var v: TvectorUsuario; var N: integer);
var
  usuario:TUsuario;
  vacio:Boolean;
begin
  vacio:=(criterioDni='') or (criterioNombre='') or (criterioUsuario='');
  try
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      read(f,usuario);
      if(usuario.estado<> ESTADO_ELIMINADO) then
       if ((like(criterioDni,usuario.dni))and (like(criterioUsuario,usuario.usuario)))
       and(like(criterioNombre,usuario.nombre)) or (vacio) then
        begin
          inc(N);
          v[n]:=usuario;
        end;
    end;
  finally
    closeFile(f);
  end;
end;


end.

