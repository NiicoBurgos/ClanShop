unit uMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, uUsuarios, uArticulos,
  uVentas, Buttons, StdCtrls, ExtCtrls,uConsultaVentas, uEstructura;

type

  { TfrmMenu }

  TfrmMenu = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Slider: TImage;
    SpeedButtonUsuarios: TSpeedButton;
    SpeedButtonArticulos: TSpeedButton;
    SpeedButtonVentas: TSpeedButton;
    SpeedButtonConsultar: TSpeedButton;
    SpeedButtonVolver: TSpeedButton;
    SpeedButtonDesplazar: TSpeedButton;
    Timer1: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonArticulosClick(Sender: TObject);
    procedure SpeedButtonConsultarClick(Sender: TObject);
    procedure SpeedButtonDesplazarClick(Sender: TObject);
    procedure SpeedButtonUsuariosClick(Sender: TObject);
    procedure SpeedButtonVentasClick(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private

  public

  end;

var
  frmMenu: TfrmMenu;
  men:boolean;
  y: integer;

implementation

{$R *.lfm}

{ TfrmMenu }
procedure MoveAnimation(moveobj:TControl;leftfrom:Integer;leftto:integer;topfrom:integer;topto:integer);
var
  i:integer;
  step:integer;
  moveareax,moveareay:integer;
begin
  step:=1;
    i:=1;
    moveareax:=leftto-leftfrom;
    moveareay:=topto-topfrom;
    while i<=90 do
     begin
     moveobj.Left:=round(leftfrom+(moveareax*i/100));
     moveobj.Top:=round(topfrom+(moveareay*i/100));

     Application.ProcessMessages;
     if i>=90 then
      exit;
     inc(i,step);
     if(90-i)<step then
     i:=90;
     end;

end;
procedure TfrmMenu.SpeedButtonDesplazarClick(Sender: TObject);
begin
  begin
   case men of
   false:
    begin
    MoveAnimation(Panel1,Panel1.Left,Panel1.Left-Panel1.Width+(SpeedButtonDesplazar.Width+10),Panel1.Top,Panel1.top);
    men:=true;
    end;
   true:
    begin
    MoveAnimation(Panel1,Panel1.Left,Panel1.Left+Panel1.Width-(SpeedButtonDesplazar.Width+10),Panel1.Top,Panel1.top);
    men:=false;
    end;
   end;
  end;
end;

procedure TfrmMenu.SpeedButtonUsuariosClick(Sender: TObject);
begin
  frmUsuarios.ShowModal;
end;

procedure TfrmMenu.SpeedButtonVentasClick(Sender: TObject);
begin
  frmConsulta.ShowModal;
end;

procedure TfrmMenu.SpeedButtonVolverClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMenu.Timer1Timer(Sender: TObject);
begin
  Slider.Picture.LoadFromFile(vImg[y]);
  y:=y+1;
  if(y=6) then
  begin
  y:=1;
  end;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
    MoveAnimation(Panel1,Panel1.Left,Panel1.Left-Panel1.Width+(SpeedButtonDesplazar.Width+10),Panel1.Top,Panel1.top);
    men:=true;
    y:=1;
    vImg[1]:=Image1;
    vImg[2]:=Image2;
    vImg[3]:=Image3;
    vImg[4]:=Image4;
    vImg[5]:=Image5;
end;



procedure TfrmMenu.SpeedButtonArticulosClick(Sender: TObject);
begin
  frmArticulos.ShowModal;
end;

procedure TfrmMenu.SpeedButtonConsultarClick(Sender: TObject);
begin
  frmVentasRealizadas.ShowModal;
end;




initialization
men:=false;


end.

