import '../../../config/library/import.dart';

class Vermas extends StatefulWidget {
  const Vermas({super.key});

  @override
  State<Vermas> createState() => _VermasState();
}

class _VermasState extends State<Vermas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(leadingbool: false, title: Style.textTitulo(mensaje: "MuniAPP", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen Circular
            const SizedBox(height: 20),
            ClipOval(
              child: Image.asset( 'assets/img/logo.png', width: 100,  height: 100, fit: BoxFit.cover ),
            ),

            const SizedBox(height: 20),
            Style.textTitulo(mensaje: "MuniApp", fontSize: 24),

            ListTile(
              leading: Style.estiloIcon(icon: Icons.person, size: 25),
              title: Style.textTitulo(mensaje: "Perfil", negitra: true),
              trailing: Style.estiloIcon(icon: Icons.arrow_forward_ios, size: 20),
              onTap: () => Get.toNamed('/perfilusuariopage'),
            ),

            ListTile(
              leading: Style.estiloIcon(icon: Icons.color_lens, size: 25),
              title: Style.textTitulo(mensaje: "Temas", negitra: true),
              trailing: Style.estiloIcon(icon: Icons.arrow_forward_ios, size: 20),
              onTap: () => Get.toNamed('/temaspage'),
            ),
            ListTile(
              leading: Style.estiloIcon(icon: Icons.login_sharp, size: 25),
              title: Style.textTitulo(mensaje: "Cerrar Sesion", negitra: true),
              trailing: Style.estiloIcon(icon: Icons.arrow_forward_ios, size: 20),
              onTap: () {
                GetStorage().remove("loginData");
                Get.offAllNamed("/");
              }
            )
          ],
        )
      )
    );
  }
}