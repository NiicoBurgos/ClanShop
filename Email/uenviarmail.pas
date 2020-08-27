unit uEnviarMail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  XMailer, uDAOSolicitar  ;

type

  { TFormEmail }

  TFormEmail = class(TForm)
    edtMail: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButtonEnviar: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButtonEnviarClick(Sender: TObject);
  private

  public
     function IsValidEmail(email: string): boolean;
  function EmailValido(correo: String): boolean;
  end;

var
  FormEmail: TFormEmail;

implementation

{$R *.lfm}

{ TFormEmail }
function TFormeMail.IsValidEmail(email: string): boolean;
const
  charslist = ['_', '-', '.', '0'..'9', 'A'..'Z', 'a'..'z'];
var
  Arobasc, lastpoint : boolean;
  i, n : integer;
  c : char;
begin
  n := Length(email);
  i := 1;
  Arobasc := false;
  lastpoint := false;
  result := true;
  while (i <= n) do begin
    c := email[i];
    if c = '@' then
    begin
      if Arobasc then
      begin
        result := false;
        exit;
      end;
      Arobasc := true;
    end
    else if (c = '.') and Arobasc then
    begin
      lastpoint := true;
    end
    else if not(c in charslist) then
    begin
      result := false;
      exit;
    end;
    inc(i);
  end;
  if not(lastpoint) or (email[n] = '.')then
    result := false;
end;
procedure TFormEmail.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TFormEmail.SpeedButtonEnviarClick(Sender: TObject);
var
Mail: TSendMail;

begin
Mail:= TSendMail.Create;
  if EmailValido(edtMail.text) then
  begin
  try
  Mail.Sender:='<lepra99@outlook.com>';
  Mail.Subject:= 'Falta de Stock';
  Mail.Receivers.Add(edtMail.text);
  Mail.Message.add('Se adjunta el pedido de stock');
  mail.smtp.UserName:= 'lepra99@outlook.com';
  Mail.smtp.password:='lu15m3ND35';
  mail.smtp.Host:= 'smtp.office365.com';
  Mail.smtp.port:= '587';
  Mail.Smtp.FullSSL:= False;
  Mail.Smtp.TLS:=True;
  Mail.Attachments.Add(rutaActual);
  Mail.Send;

finally
  if mail.Smtp.Login=false then
  ShowMessage('No hay conexion a internet')
  else
  begin
  Mail.Free;
  ShowMessage('Correo Enviado Exitosamente');
  edtMail.Text:='';

  end


  end;
end;
end;

function Tformemail.EmailValido(correo: String): boolean;
begin
  EmailValido:=false;
  if (IsValidEmail(edtMail.Text)) then
  begin
    EmailValido:=true
  end
  else
  begin
    ShowMessage('Dirección de Email Inválida');
    edtMail.text:='';
  end;
end;
end.

