unit frmVendedoresTop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons, TAGraph, TASeries,uDAOUsuarios,uEstructura;

type

  { TfrmMejoresVendedores }

  TfrmMejoresVendedores = class(TForm)
    ChartGrafico: TChart;
    ChartGraficoBarras: TBarSeries;
    grdVendedoresTop: TStringGrid;
    Label2: TLabel;
    lblReferencias: TLabel;
    lblTotal: TLabel;
    lblUsuario1: TLabel;
    lblUsuario2: TLabel;
    lblUsuario3: TLabel;
    lblUsuario4: TLabel;
    lblUsuario5: TLabel;
    SpeedButtonSalir: TSpeedButton;
    StaticText1: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure SpeedButtonSalirClick(Sender: TObject);
  private

  public
    procedure cargarGrilla();
    procedure CargarLabels();
    procedure hacerGrafica();
  end;

var
  frmMejoresVendedores: TfrmMejoresVendedores;

implementation

{$R *.lfm}

{ TfrmMejoresVendedores }

procedure intercambiar(var usuario1,usuario2:TUsuario);
var
  aux:TUsuario;
begin
  aux:=usuario1;
  usuario1:=usuario2;
  usuario2:=aux;
end;
procedure ordenarPorSeleccion(var v:TvectorUsuario;n:integer);
var
i, j, m: integer;
begin
 for i := 1 to n-1 do
  begin
  m := i;
  for j := i+1 to n do
   if v[j].VentasRealizadas > v[m].VentasRealizadas then
    m := j;
  if i <> m then
    intercambiar(v[i],v[m]);
  end;
end;
procedure ordenarUsuarios();
begin
   buscar(vUsuario,n);
   ordenarPorSeleccion(vUsuario,N);
end;
procedure TfrmMejoresVendedores.cargarGrilla();
var
   i:integer;
   ventasstr:cadena10;
begin
   for i:=1 to 5 do
    begin
      Str(vUsuario[i].VentasRealizadas:10:2,ventasstr);
      grdVendedoresTop.Cells[1,i]:=vUsuario[i].nombre;
      grdVendedoresTop.Cells[2,i]:=vUsuario[i].usuario;
      grdVendedoresTop.Cells[3,i]:=ventasstr;
    end;
end;
procedure TfrmMejoresVendedores.CargarLabels();
begin
  lblUsuario1.Caption:=vUsuario[1].usuario;
  lblUsuario2.Caption:=vUsuario[2].usuario;
  lblUsuario3.Caption:=vUsuario[3].usuario;
  lblUsuario4.Caption:=vUsuario[4].usuario;
  lblUsuario5.Caption:=vUsuario[5].usuario;
end;

procedure TfrmMejoresVendedores.hacerGrafica();
var
   i:integer;
begin
   ChartGraficoBarras.Clear;
  for i:=1 to 5 do
   begin
   ChartGraficoBarras.Add(vUsuario[i].VentasRealizadas,vUsuario[i].usuario,clYellow);
   end;
  CargarLabels();
end;

procedure TfrmMejoresVendedores.FormShow(Sender: TObject);
begin
   ordenarUsuarios();
   cargarGrilla();
   hacerGrafica();
end;

procedure TfrmMejoresVendedores.SpeedButtonSalirClick(Sender: TObject);
begin
  close;
end;

end.

