unit uDAOSolicitar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uEstructura,uDAOArticulos;

var
  f: TextFile;
  num:integer;
  rutaActual:string;
procedure CrearFicherost(var f:TextFile);
procedure CrearFicheroStock();
procedure ModificarTexto(var f:TextFile);
procedure CrearSolicitud(var f:TextFile);
implementation

procedure CrearFicheroStock();
begin
  CrearFicherost(f);
end;
procedure CrearSolicitud(var f:TextFile);
var
  i: Integer;
  V:TvectorArticulo;
begin
  BuscarStockMenor(20,V,N);
  for i := 1 to N do
  begin
     WriteLn(f,'Artículo: ' +V[i].descripcion + ' - '+ CANTIDAD_REQUERIDA);
  end;

end;
procedure CrearFicherost(var f:TextFile);
var
  dd,mm,yy: word;
  data, nombreArchivo: String;
begin
  Inc(num);
  DecodeDate(Now(),yy,mm,dd);
  data := Format('%d-%d-%d', [dd,mm,yy]);
  nombreArchivo:= 'Solicitudes/Solicitud-'+IntToStr(num)+'-'+data+'.txt';
  rutaActual:=nombreArchivo;

  AssignFile(f, nombreArchivo);
  ModificarTexto(f);
       reset(f);

  if(IOResult = 0) then
      close(f)
  else
      begin
           Rewrite(f);
           Close(f);
      end;
end;
procedure ModificarTexto(var f:TextFile);
begin
   try
     Rewrite(f);
     WriteLn(f,'Solicitud de Clan Shop');
     WriteLn(f,'Fecha: '+DateToStr(Now()) + ' - ' + 'Hora: '+TimeToStr(now()));
     WriteLn(f,'');
     WriteLn(f, 'Solicitamos la reposición de los siguientes productos: ');
     WriteLn(f,'');
     CrearSolicitud(f);
     CloseFile(f);
   finally
   end;
end;
end.

