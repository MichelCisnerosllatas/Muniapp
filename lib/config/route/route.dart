import '../../config/library/import.dart';

final rutas = [
  GetPage(name: "/", page: () => const Splash(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/login", page: () => const Login(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/principal", page: () => const Principal(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/temaspage", page: () => const Temaspage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/perfilusuariopage", page: () => const PerfilUsuariopage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/navegacionpage", page: () => const Navegacionpage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/registrociudadanopage", page: () => const Registrociudadanopage(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/registrociudadanopage2", page: () => const Registrociudadano2page(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: "/ciudadanopage2", page: () => const Ciudadanopage2(), transition: Transition.rightToLeft, transitionDuration: const Duration(milliseconds: 500)),
];