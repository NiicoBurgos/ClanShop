unit frmAOM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  uEstructura, uDAOUsuarios;

type

  { TformAOM }

  TformAOM = class(TForm)
    edtID: TEdit;
    edtDNI: TEdit;
    edtNombre: TEdit;
    edtUsuario: TEdit;
    edtClave: TEdit;
    edtConfirmarClave: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblTitulo: TLabel;
    SpeedButtonVer: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    SpeedButtonAoM: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButtonAoMClick(Sender: TObject);
    procedure SpeedButtonVerClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
    procedure leerRegistro(var rUsuarios: TUsuario);  //
    procedure inicializarComponentes(); //
    function Obligatorio():boolean;
    procedure ValidacionesObligatorias();
    procedure AltaUsuario();
    function DniValido():boolean;
    function ClaveValida(ClaveAValidar:String):boolean;
    function LongitudClave():boolean;
    procedure ValidacionesClaveValida();
    procedure ValidacionesLongitudClave();
    procedure ValidacionesDniValido();
    function ConfirmarClave():boolean;
    procedure ValidacionesConfirmarClave();
    procedure ValidacionesUsuario();
    procedure ValidacionesDNI();
    function CampoObligatorio(cadena: cadena10):boolean;
    procedure ValidacionesGenerales();
    procedure ValidacionesBusqueda();
    procedure Control();
    function ValidarUsuario():boolean;
    function ValidarDni():boolean;

  end;

var
  formAOM: TformAOM;
  controlUsuario, controlDni: cadena50;
  posicion, posicion1, codigo: integer;
  ControlBand, ControlBand1:boolean;
implementation

{$R *.lfm}

{ TformAOM }



procedure TformAOM.FormActivate(Sender: TObject);
begin
  controlUsuario:=edtUsuario.Text;
  controlDni:=edtDNI.Text;
end;

procedure TformAOM.inicializarComponentes();
begin
  edtID.Text:=IntToStr(getSiguienteId());
  edtDNI.Text:='';
  edtNombre.Text:='';
  edtUsuario.Text:='';
  edtClave.Text:='';
  edtConfirmarClave.Text:='';

end;

procedure TformAOM.leerRegistro(var rUsuarios: TUsuario);
var
  Idint:integer;
begin
  try
   Val(edtID.Text,Idint,codigo);
   rUsuarios.id:= Idint;
   rUsuarios.dni:=edtDNI.Text;
   rUsuarios.nombre:=edtNombre.Text;
   rUsuarios.usuario:=edtUsuario.Text;
   rUsuarios.clave:=edtClave.Text;
   rUsuarios.estado:=ESTADO_ACTIVO;
  except
    on e: EConvertError do
       Raise EConvertError.Create('Datos incorrectos ' + e.Message);
    on e: Exception do
       Raise Exception.Create('Error inesperado ' + e.Message);
   end;
end;




procedure TformAOM.FormShow(Sender: TObject);
begin
 // edtID.Text:=IntToStr(getSiguienteId());
end;

procedure TformAOM.SpeedButtonAoMClick(Sender: TObject);
var
Us:TUsuario;
posicion2:integer;
begin
  try
    posicion:=buscarGeneral(edtDNI.Text);
 posicion1:=buscarGeneral(edtUsuario.Text);

  if (Obligatorio()=true)then
     begin
        leerRegistro(Us);
       if (DniValido()=true) and (LongitudClave()=true) and (ClaveValida(edtClave.Text)=true) and (ConfirmarClave()=true) then
         begin
           if (SpeedButtonAoM.Caption='ALTA') then
             begin
                if (posicion = NO_ENCONTRADO) and (posicion1= NO_ENCONTRADO) then
                   begin
                    Nuevo(Us);
                    ShowMessage('Los datos se agregaron correctamente...') ;
                    inicializarComponentes();
                   end
                else
              ValidacionesBusqueda();
              end
           else
             if (SpeedButtonAoM.Caption='MODIFICAR') then
             begin
              Control();
              if (ControlBand=true) and (ControlBand1=true) then
              begin
               posicion2:=buscarGeneral(edtID.Text);
               ModificarU(posicion2, Us);
               ShowMessage('Los datos fueron modificados  correctamente...') ;

               close;
              end;
             end;
         end
       else
       ValidacionesGenerales();
     end
  else
    ValidacionesObligatorias();
  except
    on e: EConvertError do
       showMessage(e.Message);
    on e: Exception do
       showMessage('Error inesperado: ' +  E.ClassName + #13#10 + e.Message);
  end;

end;

procedure TformAOM.SpeedButtonVerClick(Sender: TObject);
begin
   if (edtclave.PasswordChar='*') and (edtConfirmarClave.PasswordChar='*') then
    begin
    edtclave.PasswordChar:=#0;
  edtConfirmarClave.PasswordChar:=#0

    end
  else
  if (edtclave.PasswordChar=#0) and (edtConfirmarClave.PasswordChar=#0) then
    begin
     edtclave.PasswordChar:='*';
  edtConfirmarClave.PasswordChar:='*';
    end;
end;

procedure TformAOM.SpeedButtonVolverClick(Sender: TObject);
begin
  Close;;
end;

function TformAOM.CampoObligatorio(cadena: cadena10):boolean;
begin
   if(cadena<>'') then
       begin
         CampoObligatorio:=true;
       end
   else
   begin
       CampoObligatorio:=false
   end;
end;

function TformAOM.Obligatorio(): boolean;
begin
     if (CampoObligatorio(edtDNI.Text)=true) and (CampoObligatorio(edtNombre.Text)=true) and (CampoObligatorio(edtUsuario.Text)=true) and (CampoObligatorio(edtClave.Text)=true) then
     Obligatorio:=true
  else
      Obligatorio:=false;
end;

procedure TformAOM.ValidacionesObligatorias();
begin
           if(CampoObligatorio(edtDNI.Text)=false) then
             begin
             ShowMessage('Debe completar el campo DNI');
             edtDNI.SetFocus;
             end;
           if(CampoObligatorio(edtNombre.Text)=false) then
             begin
               ShowMessage('Debe completar el campo Nombre');
               edtNombre.SetFocus;
             end;
           if(CampoObligatorio(edtUsuario.Text)=false) then
             begin
               ShowMessage('Debe completar el campo Usuario');
               edtUsuario.SetFocus;
             end;
           if(CampoObligatorio(edtClave.Text)=false) then
             begin
               ShowMessage('Debe completar el campo Clave');
               edtClave.SetFocus;
             end;
end;

function TformAOM.DniValido(): boolean;
begin
  if(Length(edtDNI.Text)>=7) and (Length(edtDNI.Text)<=8) then
  DniValido:=true
  else
  DniValido:=false;
end;

function TformAOM.ClaveValida(ClaveAValidar: String): boolean;
var
Numeros: String;
i, j, Cont:integer;
begin
   Numeros:='0123456789';
  Cont:=0;
  for i:=1 to Length(Numeros) do
     begin
         for j:=1 to  Length(ClaveAValidar) do
            begin
                if(Numeros[i]=ClaveAValidar[j]) then
                 Inc(Cont);
            end;
     end;
  if(Cont>=3) then
  ClaveValida:=true
  else
  ClaveValida:=false;
end;

function TformAOM.LongitudClave(): boolean;
begin
   if(Length(edtClave.Text)>=8) then
  LongitudClave:=true
  else
  LongitudClave:=false;
end;

function TformAOM.ConfirmarClave(): boolean;
var
posicion:integer;
begin
  posicion:=pos(edtClave.Text,edtConfirmarClave.Text);
 if(posicion<>0) then
 ConfirmarClave:=true
 else
 ConfirmarClave:=false;
end;

procedure TformAOM.ValidacionesGenerales();
begin
 if (DniValido()=false) then
   ValidacionesDniValido();
 if(LongitudClave()=false) then
   ValidacionesLongitudClave();
 if(ClaveValida(edtClave.Text)=false) then
   ValidacionesClaveValida();
 if(ConfirmarClave()=false) then
   ValidacionesConfirmarClave();
end;

procedure TformAOM.ValidacionesBusqueda();
begin
 if (posicion <> NO_ENCONTRADO) then
 ValidacionesDNI();
 if (posicion1<> NO_ENCONTRADO) then
 ValidacionesUsuario();
end;

procedure TformAOM.ValidacionesDniValido();
begin
  ShowMessage('El DNI debe tener 7 u 8 digitos. Ingrese uno valido');
          edtDNI.Text:='';
          edtDNI.SetFocus;
end;

procedure TformAOM.ValidacionesLongitudClave();
begin
   ShowMessage('La longitud de la clave debe ser igual o mayor a 8 para ser segura');
            edtClave.Text:='';
            edtClave.SetFocus;
end;

procedure TformAOM.ValidacionesClaveValida();
begin
  ShowMessage('La clave debe de tener por lo menos 3 números');
              edtClave.Text:='';
              edtClave.SetFocus;
end;

procedure TformAOM.ValidacionesConfirmarClave();
begin
   ShowMessage('Las claves no coinciden, confirme de nuevo');
       edtConfirmarClave.Text:='';
       edtConfirmarClave.SetFocus;
end;
procedure TformAOM.ValidacionesUsuario();
begin
 ShowMessage('El usuario ya existe');
 edtUsuario.Text:='';
 edtUsuario.SetFocus;
end;
procedure TformAOM.ValidacionesDNI();
begin
 ShowMessage('El dni ya existe');
 edtDNI.Text:='';
 edtDNI.SetFocus;
end;

function TformAOM.ValidarDni():boolean;
var
  pos: integer;

begin
  ValidarDni:=true;
  pos:=buscarGeneral(edtDNI.text);
  if pos<> NO_ENCONTRADO then
    begin
     ValidarDni:=false;
    end;
end;

function TformAOM.ValidarUsuario():boolean;
var
  pos: integer;
begin
  ValidarUsuario:=true;
  pos:=buscarGeneral(edtUsuario.text);
  if pos<> NO_ENCONTRADO then
    begin
     ValidarUsuario:=false;
    end;

end;

procedure TformAOM.Control();
begin
 ControlBand:=False;
   ControlBand1:=False;
   if (uppercase(controlUsuario)=uppercase(edtUsuario.Text))then
     ControlBand:=True;
   if (uppercase(controlDni)=uppercase(edtDNI.Text)) then
    ControlBand1:=True
     else
      if (uppercase(controlDni)<>uppercase(edtDNI.text)) then
       begin
        if (ValidarDni()) then
           ControlBand1:=true
           else
           begin
            ShowMessage('ERROR: El Dni: '+edtDNI.Text+' ya existe' );
            edtDNI.text:='';
            edtDNI.setfocus;
           end;
       end;
    if (uppercase(controlUsuario)<>uppercase(edtUsuario.Text)) then
     begin
      if (ValidarUsuario()) then
        ControlBand:=True
        else
        begin
         ShowMessage('ERROR: El usuario: '+edtUsuario.Text+' ya existe' );
           edtUsuario.text:='';
           edtUsuario.setfocus;
        end;
       end;
end;



procedure TformAOM.AltaUsuario();
var
Us:TUsuario;
posicion, posicion1: integer;
begin
  if (Obligatorio()=true)then
     begin
       if (DniValido()=true) then
         begin
          if (LongitudClave()=true) then
            begin
              if(ClaveValida(edtClave.Text)=true) then
              begin
                if(ConfirmarClave()=true) then
                 begin
                  posicion:=buscarGeneral(edtDNI.Text);
                   if (posicion = NO_ENCONTRADO) then
                     begin
                      posicion1:=buscarGeneral(edtUsuario.Text);
                       if (posicion1= NO_ENCONTRADO) then
                        begin
                          leerRegistro(Us);
                          Nuevo(Us);
                          ShowMessage('Los datos se agregaron correctamente...') ;
                          inicializarComponentes();
                        end
                       else
                         ValidacionesUsuario();
                       end
                  else
                     ValidacionesDNI();
                  end
                else
                 ValidacionesConfirmarClave();
              end
            else
              ValidacionesClaveValida();
          end
       else
            ValidacionesLongitudClave();
       end
     else
       ValidacionesDniValido();
   end
 else
    ValidacionesObligatorias();
end;


end.

