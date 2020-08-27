unit uCrudArticulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  uEstructura, uDAOArticulos;

type

  { TfrmCrudArticulos }

  TfrmCrudArticulos = class(TForm)
    edtId: TEdit;
    edtCodigo: TEdit;
    edtDescripcion: TEdit;
    edtPrecioUnitario: TEdit;
    edtStock: TEdit;
    lblTitulo: TLabel;
    lblId: TLabel;
    lblCodigo: TLabel;
    lblDescripcion: TLabel;
    lblStock: TLabel;
    lblPrecioUnitario: TLabel;
    SpeedButtonAlta: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButtonAltaClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);

  private

  public
      procedure Control;
      Function ValidarCodigo():boolean;
      Function ValidarDescripcion():boolean;
      Function ValidarCampos():boolean;
      Function ValidarPrecio():boolean;
      Procedure LeerDatos(var rArticulo:TArticulo);
      Procedure LimpiarCampos();
      function LongitudCodigo(): boolean;
  end;

var
  frmCrudArticulos: TfrmCrudArticulos;
  control0,control1:cadena50;
  descripcion,codigo:boolean;
implementation
{$R *.lfm}

{ TfrmCrudArticulos }
function TfrmCrudArticulos.LongitudCodigo(): boolean;
begin
   if(Length(edtCodigo.Text)>6)and(11>Length(edtCodigo.Text)) then
  LongitudCodigo:=true
  else
  begin
  LongitudCodigo:=false;
  ShowMessage('ERROR:  El código debe estar entre 7 y 10 caracteres');
  edtCodigo.Text:='';
  edtCodigo.SetFocus;
  end;
end;
Function TfrmCrudArticulos.ValidarCodigo():boolean;
var
  pos: integer;
  codigo: cadena50;
begin
  ValidarCodigo:=true;
  codigo:=edtCodigo.text;
  pos:=buscarCod(fi, edtCodigo.text);
  if pos<> NO_ENCONTRADO then
    begin
     ShowMessage('ERROR: El código '+codigo+' ya existe' );
     edtCodigo.Text:='';
     edtCodigo.setfocus;
     ValidarCodigo:=false;
    end;

end;

Function TfrmCrudArticulos.ValidarDescripcion():boolean;
var
  pos: integer;
  descripcion: cadena50;
begin
  ValidarDescripcion:=true;
  descripcion:=edtDescripcion.text;
  pos:=buscarDescripcion(fi,edtDescripcion.text);
  if pos<> NO_ENCONTRADO then
    begin
     ShowMessage('ERROR: La descripción '+descripcion+' ya existe' );
     edtDescripcion.text:='';
      edtDescripcion.setfocus;
     ValidarDescripcion:=false;
    end;

end;

Function TfrmCrudArticulos.ValidarCampos():boolean;
var
  codigo, descripcion, precio, stock: string;
begin
  codigo:=edtCodigo.text;
  descripcion:=edtDescripcion.text;
  precio:=edtPrecioUnitario.text;
  stock:=edtStock.text;

  ValidarCampos:=true;
  if (codigo='')or(descripcion='')or(precio='')or(stock='') then
     begin
      ShowMessage('ERROR: Debe completar todos los campos!');
      ValidarCampos:=false;
     end
end;
Function TfrmCrudArticulos.ValidarPrecio():boolean;
var
  codigo:integer;
  auxprecio: real;
  begin

    val(edtPrecioUnitario.text,auxprecio, codigo);
    if auxprecio>0 then
       ValidarPrecio:=true
       else
         begin
         ShowMessage('ERROR: Ingrese un precio válido!');
         edtPrecioUnitario.Text:='';
         edtPrecioUnitario.setfocus;
         ValidarPrecio:=false;
         end;
  end;
Procedure TfrmCrudArticulos.LeerDatos(var rArticulo:TArticulo);
var
  code,idInt: integer;
  precioUnitario: real;
  begin
     val(edtPrecioUnitario.text, precioUnitario, code);
     val(edtId.text,idInt);
     rArticulo.id:=idInt;
     rArticulo.codigo:=edtCodigo.text;
     rArticulo.descripcion:=edtDescripcion.text;
     rArticulo.precioUnitario:=precioUnitario;
     rArticulo.stock:=StrToInt(edtStock.text);
     rArticulo.estado:=Estado_Activo;
  end;

Procedure TfrmCrudArticulos.LimpiarCampos();
begin
  edtCodigo.text:='';
  edtDescripcion.text:='';
  edtPrecioUnitario.text:='';
  edtStock.text:='';
end;
procedure TfrmCrudArticulos.Control;
begin
   descripcion:=False;
   codigo:=False;
   if uppercase(control0)=uppercase(edtDescripcion.Text) then
       descripcion:=True
   else
      if ValidarDescripcion() then
        descripcion:=True;
   if (control1=edtCodigo.Text) then
       codigo:=True
   else
   if ValidarCodigo() then
      codigo:=true;

end;



procedure TfrmCrudArticulos.FormActivate(Sender: TObject);
begin
  control0:=edtDescripcion.Text;
  control1:=edtCodigo.Text;
end;

procedure TfrmCrudArticulos.SpeedButtonAltaClick(Sender: TObject);
  var
  articulo:TArticulo;
  posicion:integer;
  id:integer;
begin
  if ValidarCampos()and ValidarPrecio()and LongitudCodigo() then
  begin
  leerDatos(articulo);
  id:=strtoint(edtId.Text);
  posicion:=buscarID(fi,id);
  if (SpeedButtonAlta.Caption='ALTA') then
     begin
       if ValidarDescripcion() and ValidarCodigo()then
          begin
           Nuevo(articulo);
           ShowMessage('Datos cargados correctamente');
           edtId.caption:=IntToStr(getSiguienteId());
           LimpiarCampos();
          end;
      end;
   if (SpeedButtonAlta.Caption='MODIFICAR')then
      begin
        control;
        if (descripcion=True) and (codigo=True)  then
          begin
           Modificar(articulo,posicion);
           showMessage('Datos modificados correctamente.');
           LimpiarCampos();
           close;
         end;
     end;
  end;
end;


procedure TfrmCrudArticulos.SpeedButtonVolverClick(Sender: TObject);
begin
  LimpiarCampos();
  close;
end;

end.

