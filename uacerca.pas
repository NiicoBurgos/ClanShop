unit uAcerca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TfrmAcerca }

  TfrmAcerca = class(TForm)
    Image2: TImage;
    Image3: TImage;
    lblInt6: TLabel;
    lblVersion: TLabel;
    lblInt1: TLabel;
    Label2: TLabel;
    lblInt3: TLabel;
    lblInt4: TLabel;
    lblInt5: TLabel;
    lblIntegrantes: TLabel;
    SpeedButtonVolver: TSpeedButton;
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public

  end;

var
  frmAcerca: TfrmAcerca;

implementation

{$R *.lfm}

{ TfrmAcerca }

procedure TfrmAcerca.SpeedButtonVolverClick(Sender: TObject);
begin
    Close;
end;

end.

