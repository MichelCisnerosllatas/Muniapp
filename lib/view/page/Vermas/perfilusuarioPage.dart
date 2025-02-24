import '../../../config/library/import.dart';

class PerfilUsuariopage extends StatefulWidget {
  const PerfilUsuariopage({super.key});

  @override
  State<PerfilUsuariopage> createState() => _PerfilUsuariopageState();
}

class _PerfilUsuariopageState extends State<PerfilUsuariopage> {
  final UUsuario uusuario = Get.find<UUsuario>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Style.estiloAppbar(
        leadingbool: true, 
        title: Style.textTitulo(mensaje: "Perfil de Usuario", fontSize: 16, colorTexto: Theme.of(context).appBarTheme.foregroundColor, negitra: true),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed("/perfilusuarioMantpage"), 
            icon: Icon(Icons.edit)
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              radius: 70,
              child: uusuario.usuariologin['profile_picture'] == null || uusuario.usuariologin['profile_picture'].isEmpty
              ? Builder(
                  builder: (context) {
                    List<String> palabras = uusuario.usuariologin['name'].split(' ');
                    String iniciales;

                    if (palabras.length > 1 && palabras[1].isNotEmpty) { 
                      iniciales = palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
                    } else {
                      iniciales = palabras[0].substring(0, 1);
                    }

                    return Style.textTitulo(mensaje: iniciales.toUpperCase());
                  },
                )
              : ClipOval(
                child: Image.network(
                  uusuario.usuariologin['profile_picture'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person, size: 30, color: Colors.grey); 
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            Style.textTitulo(mensaje: uusuario.usuariologin['username'].toString().toUpperCase(), fontSize: 16),
            Style.textSubTitulo(mensaje: uusuario.usuariologin['email']),


            const SizedBox(height: 20),
            Style.estiloCard(
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Style.estiloIcon(icon: Icons.person, size: 25),
                        const SizedBox(width: 10),
                        Style.textTitulo(mensaje: "Datos Personales", negitra: true),
                      ]
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 25, color: Colors.greenAccent,),
                        const SizedBox(width: 10),
                        Style.textSubTitulo(mensaje: "Nombres: ${uusuario.usuariologin['name']}"),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 25, color: Colors.greenAccent,),
                        const SizedBox(width: 10),
                        Style.textSubTitulo(mensaje: "Apellidos: ${uusuario.usuariologin['last_name']}"),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 25, color: Colors.greenAccent,),
                        const SizedBox(width: 10),
                        Style.textSubTitulo(mensaje: "Rol: ${uusuario.usuariologin['rolnombre']}"),
                      ],
                    ),
                  ],
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}