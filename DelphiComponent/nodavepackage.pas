{ Diese Datei wurde automatisch von Lazarus erzeugt. Sie darf nicht bearbeitet werden!
Dieser Quelltext dient nur dem Übersetzen und Installieren des Packages.
 }

unit nodavepackage; 

interface

uses
  NoDaveComponent, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('NoDaveComponent', @NoDaveComponent.Register); 
end; 

initialization
  RegisterPackage('nodavepackage', @Register); 
end.
