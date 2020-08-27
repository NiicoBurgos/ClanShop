unit uHistorialAccesos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons, EditBtn, uDAOhistorialaccesos, uEstructura;

type

  { TfrmAccesos }

  TfrmAccesos = class(TForm)
    edtFecha: TDateEdit;
    edtUsuario: TEdit;
    grdAccesos: TStringGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblFecha: TLabel;
    lblUsuario: TLabel;
    lblHistorial: TLabel;
    SpeedButtonVolver: TSpeedButton;
    procedure edtFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure edtFechaChange(Sender: TObject);
    procedure edtUsuarioChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
    procedure mostrarAccesos(v:TvectorAccesos;n:integer);
    procedure limpiarEdits();
    procedure mostrarResultados(mensajeDeNoEncontrado:string);
  end;

var
  frmAccesos: TfrmAccesos;
  calendario:boolean;
  sender:TObject;
implementation

{$R *.lfm}

{ TfrmAccesos }
procedure TfrmAccesos.FormActivate(Sender: TObject);
begin
  if not calendario then
  begin
   buscar(vAccesos,n);
   mostrarAccesos(vAccesos,n);
  end;
end;
procedure decidirBusqueda(usuario,fecha:cadena10;var v:TvectorAccesos;var n:integer;uso:integer);
var
  vacio:Boolean;
begin
 vacio:=false;
    case uso of
            1: vacio:=fecha='';
            2: vacio:=usuario='';
            else ShowMessage('No se puede realizar la búsqueda');
    end;
    if (vacio) and (uso=USO_FECHA) then
        buscarUsuario(usuario,v,n)
    else
      if (vacio) and (uso=USO_USUARIO) then
        buscarFecha(fecha,v,n)
      else
          buscarCombinacionUsuarioFecha(usuario,fecha,v,n);
end;
procedure TfrmAccesos.mostrarResultados(mensajeDeNoEncontrado:string);
begin
  if N=0 then
     begin
       ShowMessage(mensajeDeNoEncontrado);
       FormActivate(sender);
       LimpiarEdits();
     end
  else
    mostrarAccesos(vAccesos,n);
end;

procedure TfrmAccesos.edtUsuarioChange(Sender: TObject);

 begin
   if edtFecha.Text=''then
      begin
        buscarUsuario(edtUsuario.Text,vAccesos,n);
        mostrarResultados( 'No se ha encontrado al usuario: '+edtUsuario.Text);
      end
   else
     begin
       decidirBusqueda(edtUsuario.Text,edtFecha.Text,vAccesos,n,USO_USUARIO);
       mostrarResultados('No se ha encontrado un acceso del usuario '+edtUsuario.Text+' en la fecha '+edtFecha.Text);
     end;
 end;

procedure TfrmAccesos.edtFechaChange(Sender: TObject);
 begin
  if edtUsuario.Text='' then
  begin
   buscarFecha(edtFecha.Text,vAccesos,N);
   mostrarResultados('No se ha encontrado ningún acceso en la fecha: '+edtFecha.Text);
  end
  else
  begin
       decidirBusqueda(edtUsuario.Text,edtFecha.Text,vAccesos,n,USO_FECHA);
       mostrarResultados('No se ha encontrado un acceso del usuario '+edtUsuario.Text+' en la fecha '+edtFecha.Text);
  end;
 end;

procedure TfrmAccesos.edtFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
  var AcceptDate: Boolean);
begin
    calendario:=AcceptDate;
end;

procedure TfrmAccesos.mostrarAccesos(v:TvectorAccesos;n:integer);
var
  i,fila:integer;
begin
  try
    grdAccesos.RowCount:=1;
    for i:=1 to n do
    begin
      grdAccesos.RowCount:=grdAccesos.RowCount+1;
      fila:=grdAccesos.RowCount-1;
      grdAccesos.Cells[1,fila]:=v[i].usuario;
      grdAccesos.Cells[2,fila]:=v[i].fecha;
      grdAccesos.Cells[3,fila]:=v[i].hora;
    end;
  finally
  end;
end;
procedure TfrmAccesos.limpiarEdits();
begin
  edtUsuario.Text:='';
  edtFecha.Text:='';
end;

procedure TfrmAccesos.FormCreate(Sender: TObject);
begin
  CrearFichero();
end;

procedure TfrmAccesos.SpeedButtonVolverClick(Sender: TObject);
begin
 limpiarEdits();
 calendario:=false;
 close;
end;

end.

