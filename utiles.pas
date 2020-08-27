unit utiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs, Controls, uEstructura;
const
  SEPARADOR_MILES = ',';
  SEPARADOR_DECIMAL = '.';
function like(campo,campoRegistro:cadena50):boolean;
function confirmarOperacion(pregunta:string):boolean;
function StringToFloat(cadena: String): Real;
function ValidarStock(stock:integer;articulo:TArticulo):boolean;
function CalculoImporte(Cantidad, PrecioUnitario:string):real;


implementation

function ValidarStock(stock:integer;articulo:TArticulo):boolean;
begin
  ValidarStock:=true;
  if articulo.stock<stock then
     ValidarStock:=false;
end;

function CalculoImporte(Cantidad, PrecioUnitario:string):real;
var
  cant, codigo:integer;
  PrecioUni:real;
begin
  cant:=strtoInt(Cantidad);
  Val(PrecioUnitario,PrecioUni,codigo);
  CalculoImporte:=(cant*PrecioUni);
end;


function like(campo,campoRegistro:cadena50):boolean;
var
  coincidencia:boolean;
begin
  coincidencia:=false;
  campo:=UpperCase(campo);
  campoRegistro:=UpperCase(campoRegistro);
  if (pos(campo,campoRegistro)<>0) then
     coincidencia:=true;
  like:=coincidencia;
end;
function confirmarOperacion(pregunta:string):boolean;
var
  confirmar:boolean;
begin
  confirmar:=false;
  if (MessageDlg(pregunta, mtConfirmation,[mbOk,mbCancel],0)=mrOk) then
     confirmar:=true;
  confirmarOperacion:=confirmar;
end;
function StringToFloat(cadena: String): Real;
var
    format: TFormatSettings;
    valor : Real;
begin
  format.ThousandSeparator := SEPARADOR_MILES;
  format.DecimalSeparator := SEPARADOR_DECIMAL;
  valor:=StrToFloat(cadena, format);
  StringToFloat := valor;
end;


end.

