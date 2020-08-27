unit frmTopVentas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons, ExtCtrls, TAGraph, TASeries,uEstructura,uDAOArticulos;

type

  { TfrmProductosMasVendidos }

  TfrmProductosMasVendidos = class(TForm)
    ChartGrafico: TChart;
    ChartGraficoTarta: TPieSeries;
    grdProductos: TStringGrid;
    ImageColores: TImage;
    lblReferencias: TLabel;
    SpeedButtonVolver: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButtonVolverClick(Sender: TObject);
  private

  public
    procedure cargarGrilla(vector:TvectorArticulo);
    procedure hacerGrafico(vectorArt: TvectorArticulo);
  end;

var
  frmProductosMasVendidos: TfrmProductosMasVendidos;

implementation

{$R *.lfm}

{ TfrmProductosMasVendidos }

procedure TfrmProductosMasVendidos.SpeedButtonVolverClick(Sender: TObject);
begin
  close;
end;
procedure intercambiar(var art1,art2:TArticulo);
var
  aux:TArticulo;
begin
  aux:=art1;
  art1:=art2;
  art2:=aux;
end;

procedure ordenarPorSeleccion(var v: TvectorArticulo; n:integer);
var
i, j, m: integer;
begin
 for i := 1 to n-1 do
  begin
  m := i;
  for j := i+1 to n do
   if v[j].CantidadVendida > v[m].CantidadVendida then
    m := j;
  if i <> m then
    intercambiar(v[i],v[m]);
  end;
end;
procedure ordenarArticulos(var vector:TvectorArticulo;n:integer);
begin
  buscar(vector,n);
  ordenarPorSeleccion(vector,n);
end;
procedure TfrmProductosMasVendidos.cargarGrilla(vector:TvectorArticulo);
var
   fila:integer;
   cantidadstr:cadena50;
begin
 for fila:=1 to 5 do
  begin
  cantidadstr:=IntToStr(vector[fila].CantidadVendida);
  grdProductos.Cells[1,fila]:=vector[fila].descripcion;
  grdProductos.Cells[2,fila]:=cantidadstr;
  end;
end;
procedure TfrmProductosMasVendidos.hacerGrafico(vectorArt: TvectorArticulo);
var
   i:integer;
begin
  ChartGraficoTarta.Clear;
  for i:=1 to 5 do
   ChartGraficoTarta.Add(vectorArt[i].CantidadVendida,vectorArt[i].descripcion);
end;

procedure TfrmProductosMasVendidos.FormShow(Sender: TObject);
begin
  ordenarArticulos(vArticulo,n);
  cargarGrilla(vArticulo);
  hacerGrafico(vArticulo);
end;
end.

