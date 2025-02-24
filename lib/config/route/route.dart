import '../../config/library/import.dart';

final rutas = [
  GetPage(name: "/", page: () => const Splash(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/login", page: () => const Login(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/principal", page: () => const Principal(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/temaspage", page: () => const Temaspage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/perfilusuariopage", page: () => const PerfilUsuariopage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/perfilusuarioMantpage", page: () => const PerfilUsuariomantpage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),

  GetPage(name: "/navegacionpage", page: () => const Navegacionpage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/registrociudadanopage", page: () => const Registrociudadanopage(), binding: RegistroCiudadano2Binding(),  transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/registrociudadanopage2", page: () => const Registrociudadano2page(), binding: RegistroCiudadano2Binding(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/ciudadanopage2", page: () => Ciudadanopage2(), binding: Ciudadanopage2Bindings(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/detaellerecolector", page: () => Detallerecolectorpage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/detaellepersonal", page: () => Detallepersonapage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/detaellehistorialruta", page: () => Detallehistorialrutapage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),

];