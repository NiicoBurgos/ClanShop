unit uActualizarP;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,utiles;

type

  { TfrmActualizar }

  TfrmActualizar = class(TForm)
    edtAumento: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private

  public

  end;

var
  frmActualizar: TfrmActualizar;

implementation

{$R *.lfm}


{ TfrmActualizar }

procedure TfrmActualizar.SpeedButton2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmActualizar.SpeedButton1Click(Sender: TObject);
begin
  if edtAumento.Text <>'' then
  begin
  if (StringToFloat(edtAumento.Text) <> 0) then
   showMessage('Se aplicará un aumento del'+ edtAumento.Text+ '% ')
  else
    showMessage('EL PORCENTAJE NO PUEDE SER CERO');
  end
  else
   showMessage('INGRESE UN PORCENTAJE ');
end;

procedure TfrmActualizar.FormActivate(Sender: TObject);
begin
  edtAumento.text:='';
end;

end.

