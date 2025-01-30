import '../config/library/import.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    pantallasiguiente();
  }

  void pantallasiguiente() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed("/login");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 23, 47, 226), // Azul
              Color(0xFF6dd5ed), // Celeste
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // Imagen Circular
                ClipOval(
                  child: Image.asset( 'assets/img/logo.png', width: 100,  height: 100, fit: BoxFit.cover ),
                ),

                const SizedBox(height: 20),
                Style.textTitulo(mensaje: "MuniApp", colorTexto: Colors.white, fontSize: 24),
              ],
            ),
            
            // CircularProgressIndicator en la parte inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
