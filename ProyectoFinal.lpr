program ProyectoFinal;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, uLogin, uUsuarios, uMenu, uArticulos, uVentas,
  uEstructura, uDAOArticulos, uDAOUsuarios, frmAOM, uCrudArticulos, utiles,
  uHistorialAccesos, uDAOhistorialaccesos, uDAOVentas, uConsultaVentas,
  uDetallesVenta, uModificar, uDescuento, uDAOdescuento, uDAOExcel,
  frmTopVentas, uActualizarP, frmVendedoresTop, uEnviarMail,uAcerca;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmAcerca,frmAcerca);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmUsuarios, frmUsuarios);
  Application.CreateForm(TfrmArticulos, frmArticulos);
  Application.CreateForm(TfrmConsulta, frmConsulta);
  Application.CreateForm(TformAOM, formAOM);
  Application.CreateForm(TfrmCrudArticulos, frmCrudArticulos);
  Application.CreateForm(TfrmAccesos, frmAccesos);
  Application.CreateForm(TfrmVentasRealizadas, frmVentasRealizadas);
  Application.CreateForm(TfrmDetallesFactura, frmDetallesFactura);
  Application.CreateForm(TfrmModificar, frmModificar);
  Application.CreateForm(TfrmDescuento, frmDescuento);
  Application.CreateForm(TfrmProductosMasVendidos, frmProductosMasVendidos);
  Application.CreateForm(TfrmActualizar, frmActualizar);
  Application.CreateForm(TfrmMejoresVendedores, frmMejoresVendedores);
  Application.CreateForm(TFormEmail, FormEmail);
  Application.Run;
end.

