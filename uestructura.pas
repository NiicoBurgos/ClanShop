unit uEstructura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
  cadena10 = String[10];
  cadena50 = String[50];
  TUsuario =record
    id : integer;
    dni : cadena10;
    nombre : cadena50;
    usuario : cadena10;
    clave :  cadena10;
    ventasRealizadas:real;
    estado : cadena10;
  end;
  TArticulo = record
    id : integer;
    codigo : cadena10;
    descripcion : cadena50;
    precioUnitario : real;
    stock : integer;
    cantidadVendida: integer;
    estado : cadena10;
  end;
  TAccesos=record
    usuario:cadena50;
    fecha:cadena10;
    hora:cadena10;
  end;
  TFactura=record
    id:integer;
    fecha:TDateTime;
    nombreCliente:cadena50;
    total:real;
    vendedor:TUsuario;
    descuento: real;
    efectivo:real;
    cambio:real;
    estado:cadena10;
  end;
  TDetalle=record
    numeroLinea:integer;
    idFactura:integer;
    articulo:TArticulo;
    cantidad:Integer;
    precioUnitario:real;
    subtotal:real;
  end;
  TVenta=record
     descripcion:cadena50;
     cantidad:integer;
     PrecioU:real;
     importe:real;
     codigo:cadena10;
     numero: integer;
  end;

TFicheroUsuarios = file of TUsuario;
TFicheroArticulos = file of TArticulo;
TFicheroAccesos = file of TAccesos;
TFicheroFactura= file of TFactura;
TFicheroDetalles=file of TDetalle;
TvectorUsuario = Array [1..1000] of TUsuario;
TvectorArticulo = Array [1..1000] of TArticulo;
TvectorAccesos =Array [1..1000] of TAccesos;
TvectorFactura=Array[1..1000] of TFactura;
TvectorDetalles=Array[1..1000] of TDetalle;
TvectorVenta=Array[1..1000] of TVenta;
TvectorImg=Array[1..5]of string;
Const
  ESTADO_ACTIVO = 'ACTIVO';
  ESTADO_ELIMINADO = 'ELIMINADO';
  ESTADO_BLOQUEADO = 'BLOQUEADO';
  PATH_FICHEROS    = 'datos/';
  PATH_AUDIO = 'Audios/';
  AUDIO1 = PATH_AUDIO+'Pagado.wav';
  AUDIO2 = PATH_AUDIO+'Finalizar.wav';
  FICHERO_ARTICULOS = PATH_FICHEROS + 'articulos.dat';
  FICHERO_USUARIOS = PATH_FICHEROS +'usuarios.dat';
  FICHERO_ACCESOS = PATH_FICHEROS +'accesos.dat';
  FICHERO_FACTURAS = PATH_FICHEROS + 'facturas.dat';
  FICHERO_DETALLES= PATH_FICHEROS+ 'detalles.dat';
  FICHERO_DESCUENTO= PATH_FICHEROS + 'configuración.txt';
  NO_ENCONTRADO = -1;
  IMAGE1='Imagenes/Slider/Imagen1.jpg';
  IMAGE2='Imagenes/Slider/Imagen2.jpg';
  IMAGE3='Imagenes/Slider/Imagen3.jpg';
  IMAGE4='Imagenes/Slider/Imagen4.jpg';
  IMAGE5='Imagenes/Slider/Imagen5.jpg';
   tituloFactura = 'Id; Fecha; Cliente; Total; Vendedor; Descuento; Efectivo; Cambio; Estado';
  tituloDetalle = 'Numero de Linea; Articulo; Cantidad; Precio Unitario; Sub Total';
  USO_FECHA=1;
  USO_USUARIO=2;
  USO_DNI=3;
  USO_NOMBRE=4;
  CANTIDAD_REQUERIDA='Cantidad Solicitada: 100';
var
  rUsuarios: TUsuario;
  rArticulos: TArticulo;
  rAccesos:TAccesos;
  rFactura:TFactura;
  rDetalle:TDetalle;
  rVenta:TVenta;
  fUsuarios: TFicheroUsuarios;
  fArticulos: TFicheroArticulos;
  fAccesos:TFicheroAccesos;
  fFactura:TFicheroFactura;
  fDetalle:TFicheroDetalles;
  vUsuario: TvectorUsuario;
  vArticulo: TvectorArticulo;
  vAccesos:TvectorAccesos;
  vVenta: TvectorVenta;
  vFactura:TvectorFactura;
  vDetalles:TvectorDetalles;
  N,M:integer;
  usuarioActual:cadena50;
  idFac:integer;
  vImg: TvectorImg;
implementation

end.

