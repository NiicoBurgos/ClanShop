unit uUsuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls, uEstructura, frmAOM,
  uDAOUsuarios,Buttons, Menus,utiles,uHistorialAccesos;

type

  { TfrmUsuarios }

  TfrmUsuarios = class(TForm)
    edtBusquedaUsuario: TEdit;
    edtBusquedaDni: TEdit;
    edtBusquedaNombre: TEdit;
    grdListaUsuarios: TStringGrid;
    GroupBoxCriteriosBesqueda: TGroupBox;
    lblUsuario: TLabel;
    lblCriterios: TLabel;
    lblNombre: TLabel;
    lblDNI: TLabel;
    MenuItemAccesos: TMenuItem;
    PopupMenu1: TPopupMenu;
    SpeedButtonAlta: TSpeedButton;
    SpeedButtonEliminar: TSpeedButton;
    SpeedButtonHistorial: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    SpeedButtonModificar: TSpeedButton;
    procedure edtBusquedaUsuarioChange(Sender: TObject);
    procedure edtBusquedaDniChange(Sender: TObject);
    procedure edtBusquedaNombreChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdListaUsuariosDblClick(Sender: TObject);
    procedure MenuItemAccesosClick(Sender: TObject);
    procedure SpeedButtonAltaClick(Sender: TObject);
    procedure SpeedButtonEliminarClick(Sender: TObject);
    procedure SpeedButtonHistorialClick(Sender: TObject);
    procedure SpeedButtonModificarClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
   procedure mostrarUsuarios(v:TvectorUsuario; n:integer);
   procedure LimpiarBusquedas();
   procedure mostrarRegistro;
   procedure mostrarResultados(mensajeNoEncontrado:string);
  end;

var
  frmUsuarios: TfrmUsuarios;
  OK:integer;
  sender:TObject;

implementation

{$R *.lfm}

{ TfrmUsuarios }
procedure TfrmUsuarios.LimpiarBusquedas();
begin
  edtBusquedaDni.Text:='';
  edtBusquedaNombre.Text:='';
  edtBusquedaUsuario.Text:='';
end;
procedure TfrmUsuarios.mostrarResultados(mensajeNoEncontrado:string);
begin
    if N=0 then
    begin
     ShowMessage('No se han encontrado resultados: '+mensajeNoEncontrado);
     LimpiarBusquedas();
     FormActivate(Sender);
    end
  else
      mostrarUsuarios(vUsuario,N);
end;
procedure decidirBusquedaDniNombre(dni,nombre:cadena50;var v:TvectorUsuario;var n:integer;uso:integer);
var
  vacio:Boolean;
begin
  vacio:=false;
    case uso of
            3: vacio:=dni='';
            4: vacio:=nombre='';
            else ShowMessage('No se puede realizar la búsqueda');
    end;
    if (vacio) and (uso=USO_DNI) then
        buscarNombre(nombre,v,n)
    else
      if (vacio) and (uso=USO_NOMBRE) then
        buscarDNI(dni,v,n)
      else
          buscarCombinacionDniNombre(dni,nombre,v,n);
end;
procedure decidirBusquedaDniUsuario(dni,usuario:cadena50;var v:TvectorUsuario;var n:integer;uso:integer);
var
  vacio:Boolean;
begin
  vacio:=false;
    case uso of
            2: vacio:=usuario='';
            3: vacio:=dni='';
            else ShowMessage('No se puede realizar la búsqueda');
    end;
    if (vacio) and (uso=USO_USUARIO) then
        buscarDNI(dni,v,n)
    else
      if (vacio) and (uso=USO_DNI) then
        buscarUsuario(dni,v,n)
      else
          buscarCombinacionDniUsuario(dni,usuario,v,n);
end;
procedure decidirBusquedaNombreUsuario(nombre,usuario:cadena50;var v:TvectorUsuario;var n:integer;uso:integer);
var
  vacio:Boolean;
begin
  vacio:=false;
    case uso of
            2:vacio:=usuario='';
            4:vacio:=nombre='';
            else ShowMessage('No se puede realizar la búsqueda');
    end;
    if (vacio) and (uso=USO_USUARIO) then
        buscarNombre(nombre,v,n)
    else
      if (vacio) and (uso=USO_NOMBRE) then
        buscarUsuario(usuario,v,n)
      else
          buscarCombinacionNombreUsuario(nombre,usuario,v,n);
end;
procedure decidirMultiple(dni,nombre,usuario:cadena50;var v:TvectorUsuario;var n:integer;uso:integer);
var
  vacio:boolean;
begin
  vacio:=false;
  case uso of
          2:vacio:=usuario='';
          3:vacio:=dni='';
          4:vacio:=nombre='';
          else ShowMessage('No se puede realizar la búsqueda');
  end;
  if (vacio) and (uso=USO_USUARIO) then
     buscarCombinacionDniNombre(dni,nombre,v,n);
  if (vacio) and (uso=USO_DNI) then
     buscarCombinacionNombreUsuario(nombre,usuario,v,n)
  else
     buscarCombinacionDniUsuario(dni,usuario,v,n);
end;

procedure TfrmUsuarios.edtBusquedaDniChange(Sender: TObject);
begin
 if (edtBusquedaNombre.Text='') and (edtBusquedaUsuario.Text='') then
  begin
       buscarDNI(edtBusquedaDni.Text,vUsuario,N);
       mostrarResultados('DNI '+edtBusquedaDni.Text+' inexistente');
  end
  else
  begin
      if  (edtBusquedaNombre.Text<>'') and (edtBusquedaUsuario.Text<>'') then
           decidirMultiple(edtBusquedaDni.Text,edtBusquedaNombre.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_DNI)
      else
        if (edtBusquedaUsuario.Text<>'') then
         decidirBusquedaDniUsuario(edtBusquedaDni.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_DNI)
        else
         decidirBusquedaDniNombre(edtBusquedaDni.Text,edtBusquedaNombre.Text,vUsuario,n,USO_DNI);
      mostrarResultados('con los criterios seleccionados');
  end;
end;

procedure TfrmUsuarios.edtBusquedaUsuarioChange(Sender: TObject);
 begin
  if (edtBusquedaNombre.Text='') and (edtBusquedaDni.Text='') then
   begin
    buscarUsuario(edtBusquedaUsuario.text,vUsuario,n);
    mostrarResultados('usuario '+edtBusquedaUsuario.Text+' inexistente');
   end
  else
  begin
    if (edtBusquedaNombre.Text<>'') and (edtBusquedaDni.Text<>'') then
     decidirMultiple(edtBusquedaDni.Text,edtBusquedaNombre.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_USUARIO)
    else
      if (edtBusquedaDni.Text<>'') then
       decidirBusquedaDniUsuario(edtBusquedaDni.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_USUARIO)
      else
       decidirBusquedaNombreUsuario(edtBusquedaNombre.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_USUARIO);
      mostrarResultados('con los criterios seleccionados');
  end;
 end;

procedure TfrmUsuarios.edtBusquedaNombreChange(Sender: TObject);
begin
 if (edtBusquedaDni.Text='') and (edtBusquedaUsuario.Text='') then
   begin
    buscarNombre(edtBusquedaNombre.Text,vUsuario,N);
    mostrarResultados('nombre '+edtBusquedaNombre.Text+' inexistente');
   end
 else
 begin
     if (edtBusquedaDni.Text<>'') and (edtBusquedaUsuario.Text<>'') then
      decidirMultiple(edtBusquedaDni.Text,edtBusquedaNombre.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_NOMBRE)
     else
      if (edtBusquedaUsuario.Text<>'') then
       decidirBusquedaNombreUsuario(edtBusquedaNombre.Text,edtBusquedaUsuario.Text,vUsuario,n,USO_NOMBRE)
      else
       decidirBusquedaDniNombre(edtBusquedaDni.Text,edtBusquedaNombre.Text,vUsuario,n,USO_NOMBRE);
     mostrarResultados('con los criterios seleccionados');
 end;
end;

procedure TfrmUsuarios.FormActivate(Sender: TObject);
begin
  buscar(vUsuario, N);
  mostrarUsuarios(vUsuario,N);
  LimpiarBusquedas();
end;

procedure TfrmUsuarios.FormCreate(Sender: TObject);
begin
  Crearfichero();
end;

procedure TfrmUsuarios.grdListaUsuariosDblClick(Sender: TObject);
begin
   mostrarRegistro;
  OK:=1;
  edtBusquedaDni.Text:=grdListaUsuarios.Cells[2,grdListaUsuarios.Row];
  edtBusquedaNombre.Text:=grdListaUsuarios.Cells[3,grdListaUsuarios.Row];
end;

procedure TfrmUsuarios.MenuItemAccesosClick(Sender: TObject);
var
  usuario:cadena50;
begin
 usuario:=grdListaUsuarios.Cells[4,grdListaUsuarios.Row];
 frmAccesos.edtFecha.Enabled:=false;
 frmAccesos.edtUsuario.Enabled:=false;
 frmAccesos.Show;
 frmAccesos.edtUsuario.Text:=usuario;
end;

procedure TfrmUsuarios.SpeedButtonAltaClick(Sender: TObject);
begin
   formAOM.Show;
   formAOM.inicializarComponentes();
  formAOM.SpeedButtonAoM.Caption:='ALTA';
  formAOM.lblTitulo.Caption:='NUEVO USUARIO';
  formAOM.edtID.Text:=IntToStr(getSiguienteId());

end;

procedure TfrmUsuarios.SpeedButtonEliminarClick(Sender: TObject);
var
  dni:cadena10;
  mensaje:string;
  usuario:TUsuario;
  posicion:integer;
begin
  dni:=edtBusquedaDni.Text;
  posicion:= buscarGeneral(dni);
  if (posicion<>NO_ENCONTRADO) and (dni<>'')then
    begin
     mensaje:= '¿Está seguro que desea eliminar a '+edtBusquedaNombre.Text+ ' con Nro de DNI: '+dni+'?';
     if confirmarOperacion(mensaje) then
       begin
        eliminar(posicion, usuario);
        FormActivate(Sender);
       end;
    end
  else
      ShowMessage('Usuario no encontrado. Haga doble click en el usuario que desea eliminar' );
  LimpiarBusquedas();
end;

procedure TfrmUsuarios.SpeedButtonHistorialClick(Sender: TObject);
begin
    frmAccesos.Showmodal;
    frmAccesos.edtFecha.Enabled:=true;
    frmAccesos.edtUsuario.Enabled:=true;
    frmAccesos.limpiarEdits();
end;

procedure TfrmUsuarios.SpeedButtonModificarClick(Sender: TObject);
begin
    if (OK=1) and (edtBusquedaDni.Text<>'') then
  begin
  formAOM.Show;
      formAOM.Caption:='Modificación de Usuario';
      formAOM.lblTitulo.Caption:='MODIFICACION DE USUARIO';
      formAOM.SpeedButtonAoM.Caption:='MODIFICAR';
      LimpiarBusquedas();
      OK:=0;
  end
  else
  ShowMessage('Haciendo doble click en la lista, seleccione el usuario que desea modificar');
end;

procedure TfrmUsuarios.SpeedButtonVolverClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsuarios.mostrarUsuarios(v:TvectorUsuario; n:integer);
var
  i,fila:integer;
begin
  try
    grdListaUsuarios.RowCount:=1;
    for i:=1 to n do
    begin
      grdListaUsuarios.RowCount:=grdListaUsuarios.RowCount+1;
      fila:=grdListaUsuarios.RowCount-1;
      grdListaUsuarios.Cells[1,fila]:=IntToStr(v[i].id);
      grdListaUsuarios.Cells[2,fila]:=v[i].dni;
      grdListaUsuarios.Cells[3,fila]:=v[i].nombre;
      grdListaUsuarios.Cells[4,fila]:=V[i].usuario;
      grdListaUsuarios.Cells[5,fila]:=v[i].clave;
      grdListaUsuarios.Cells[6,fila]:=v[i].estado;
    end;
  Except
    on E:EInOutError do
    ShowMessage('Se ha producido un error en el fichero.Detalles: '+E.ClassName+'/'+E.Message );
  end;
end;
procedure TfrmUsuarios.mostrarRegistro;
begin
   formAOM.edtID.Text:= grdListaUsuarios.Cells[1,grdListaUsuarios.Row];
   formAOM.edtDNI.Text:= grdListaUsuarios.Cells[2,grdListaUsuarios.Row];
   formAOM.edtNombre.Text:= grdListaUsuarios.Cells[3,grdListaUsuarios.Row];
   formAOM.edtUsuario.Text:= grdListaUsuarios.Cells[4,grdListaUsuarios.Row];
   formAOM.edtClave.Text:= grdListaUsuarios.Cells[5,grdListaUsuarios.Row];
   formAOM.edtConfirmarClave.Text:=grdListaUsuarios.Cells[5,grdListaUsuarios.Row];
end;



end.

