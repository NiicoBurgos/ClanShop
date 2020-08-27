unit uLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, uMenu,
  StdCtrls, ExtCtrls, Menus, uDAOhistorialaccesos, uDAOUsuarios, uEstructura,
  uVentas, uHistorialAccesos, uConsultaVentas,uAcerca;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    edtUsuario: TEdit;
    edtClave: TEdit;
    ImageLogo: TImage;
    ImageUsuario: TImage;
    ImageClave: TImage;
    MenuItemAccesos: TMenuItem;
    MenuItemVentas: TMenuItem;
    MenuItemAcerca: TMenuItem;
    N1: TMenuItem;
    MenuSalir: TMenuItem;
    MenuNotificaciones: TPopupMenu;
    SpeedButtonVer: TSpeedButton;
    SpeedButtonIngresar: TSpeedButton;
    SpeedButtonSalir: TSpeedButton;
    Notificaciones: TTrayIcon;
    procedure FormShow(Sender: TObject);
    procedure MenuItemAccesosClick(Sender: TObject);
    procedure MenuItemAcercaClick(Sender: TObject);
    procedure MenuItemVentasClick(Sender: TObject);
    procedure MenuSalirClick(Sender: TObject);
    procedure NotificacionesClick(Sender: TObject);
    procedure SpeedButtonVerClick(Sender: TObject);
    procedure SpeedButtonIngresarClick(Sender: TObject);
    procedure SpeedButtonSalirClick(Sender: TObject);

  private

  public

  end;

var
  frmLogin: TfrmLogin;
  cl,us,estado:integer;
  bvernotificaciones:boolean;
implementation

{$R *.lfm}

{ TfrmLogin }
procedure TfrmLogin.NotificacionesClick(Sender: TObject);
begin
  if bvernotificaciones then
  begin
   frmLogin.Hide;
   bvernotificaciones:=false;
  end
  else
   begin
    frmLogin.show;
    bvernotificaciones:=true;
   end;
end;
procedure MostrarNotificaciones(tit: string; msj: string;
  tipo: TBalloonFlags);
begin
  frmLogin.Notificaciones.BalloonTitle:=tit;
  frmLogin.Notificaciones.BalloonHint:=msj;
  frmLogin.Notificaciones.BalloonFlags:=tipo;
  frmLogin.Notificaciones.ShowBalloonHint;
end;
procedure guardarAcceso(usuario:cadena50);
begin
  rAccesos.usuario:=usuario;
  rAccesos.fecha:=DateToStr(date());
  rAccesos.hora:=TimeToStr(Now());
  NuevoAcceso(rAccesos);
end;
procedure Limpiar();
begin
  frmLogin.edtUsuario.text:='';
  frmLogin.edtClave.text:='';
end;
function ClaveValido():boolean;
begin
  ClaveValido:=false;
  if(frmlogin.edtClave.text<>'') then
  begin
   cl:=buscarClave(frmLogin.edtClave.text);
   ClaveValido:=true;
  end
  else
   begin
    ShowMessage('Complete el campo clave');
    frmlogin.edtClave.SetFocus;
   end;
end;
function UsuarioValido():boolean;
begin
  UsuarioValido:=false;
  if(frmLogin.edtUsuario.text<>'')then
  begin
   us:=buscarUsuario(frmLogin.edtUsuario.text);
   estado:=buscarEstado(us);
   UsuarioValido:=true;
  end
  else
  begin
    ShowMessage('Complete el campo usuario');
    frmLogin.edtUsuario.SetFocus;
  end;
  end;
function CamposValidos():boolean;
begin
  CamposValidos:=true;
  if(frmLogin.edtClave.text='')and(frmLogin.edtUsuario.text='')then
  begin
   ShowMessage('Todos los campos son obligatorios');
   CamposValidos:=false;
  end
  else
  begin
     us:=buscarUsuario(frmLogin.edtUsuario.text);
     estado:=buscarEstado(us);
     cl:=buscarClave(frmLogin.edtClave.text);
  end;
end;
function ValidarLogin():boolean;
begin
   if(us<>NO_ENCONTRADO) and (us=estado)then
     if(cl<>NO_ENCONTRADO) and (us=cl)then
     begin
      usuarioActual:=frmLogin.edtUsuario.Text;
      ValidarLogin:=true;
      MostrarNotificaciones('Se ha iniciado sesion correcctamente','Bienvenido: '+frmLogin.edtUsuario.text,bfinfo);
      guardarAcceso(frmlogin.edtUsuario.Text);
      frmMenu.ShowModal;
      Limpiar();
     end
     else
     begin
      ShowMessage('Error!!La clave es incorrecta');
      frmlogin.edtClave.SetFocus;
     end;
end;
procedure ErroresLogin();
begin
    if(us=NO_ENCONTRADO)then
     begin
      ShowMessage('Error!!El usuario: '+frmlogin.edtUsuario.text+' no existe');
      frmlogin.edtUsuario.SetFocus;
     end
     else
      if(estado=NO_ENCONTRADO) then
      begin
       MostrarNotificaciones('No se pudo iniciar sesion','El usuario:  '+frmLogin.edtUsuario.text+'  esta bloqueado',bfError);
      Limpiar();
      frmlogin.edtUsuario.SetFocus;
      end;
end;




procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edtUsuario.SetFocus;
end;

procedure TfrmLogin.MenuItemAccesosClick(Sender: TObject);
begin
   frmAccesos.ShowModal;
end;

procedure TfrmLogin.MenuItemAcercaClick(Sender: TObject);
begin
  frmAcerca.showmodal;
end;

procedure TfrmLogin.MenuItemVentasClick(Sender: TObject);
begin
   frmVentasRealizadas.ShowModal;
end;

procedure TfrmLogin.MenuSalirClick(Sender: TObject);
begin
   close;
end;



procedure TfrmLogin.SpeedButtonVerClick(Sender: TObject);
begin
   if (edtClave.PasswordChar='*') then
   begin
    edtClave.PasswordChar:=#0;
   end
   else
    if(edtClave.PasswordChar=#0) then
    edtClave.PasswordChar:='*';
end;

procedure TfrmLogin.SpeedButtonIngresarClick(Sender: TObject);
begin
  if (CamposValidos()=true)and(UsuarioValido()=true)and(ClaveValido()=true) then
   begin
   ValidarLogin();
   ErroresLogin();
   end;
end;

procedure TfrmLogin.SpeedButtonSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;



end.

