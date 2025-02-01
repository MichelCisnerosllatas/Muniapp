import '../config/library/import.dart';

class Notificacioncontroller extends GetxController {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  RxString deviceToken = "".obs;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    initFirebaseMessaging();
    setupLocalNotifications();
    setupNotificationListeners();
    checkInitialMessage();
    checkNotificationPermissions(); // Verifica si el usuario tiene permisos activados
  }

  Future<void> initFirebaseMessaging() async {
    try {
      // 🔹 Pedir permisos en iOS y Android 13+
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("✅ Permiso de notificaciones otorgado");
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print("⚠️ Permiso provisional otorgado (iOS)");
      } else {
        print("🚫 Permiso de notificaciones denegado");
      }

      String? token = await messaging.getToken();
      if (token != null) {
        deviceToken.value = token;
        print("🔥 Token del dispositivo: $token");
      } else {
        print("⚠️ No se pudo obtener el token");
      }
    } catch (e) {
      print("🚨 Error obteniendo el token: $e");
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      deviceToken.value = newToken;
      print("♻️ Nuevo Token: $newToken");
    }, onError: (e) {
      print("🚨 Error actualizando token: $e");
    });
  }

  void setupNotificationListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Notificación recibida en primer plano:");
      print("🔹 Título: ${message.notification?.title}");
      print("🔹 Cuerpo: ${message.notification?.body}");
      print("🔹 Datos: ${message.data}");

      // Mostrar notificación local
      mostrarNoticacionLocal(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 Usuario tocó la notificación:");
      print("🔹 Título: ${message.notification?.title}");
      print("🔹 Cuerpo: ${message.notification?.body}");
      print("🔹 Datos: ${message.data}");
    });
  }


  // Asegurar que las notificaciones también se manejen cuando la app está en segundo 
  // plano o cerrada Si la app está en segundo plano o cerrada, se debe manejar el mensaje inicial al abrir la app:
  //Añadimos checkInitialMessage() para detectar notificaciones cuando la app se abre desde una notificación.
  void checkInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("📬 Notificación al abrir la app:");
      print("🔹 Título: ${initialMessage.notification?.title}");
      print("🔹 Cuerpo: ${initialMessage.notification?.body}");
      print("🔹 Datos: ${initialMessage.data}");
    }
  }

  // Si el usuario rechaza los permisos, no podrá recibir notificaciones. 
  // Podemos verificar si el usuario los tiene habilitados.
  Future<void> checkNotificationPermissions() async {
    NotificationSettings settings = await messaging.getNotificationSettings();
    
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("🚫 El usuario denegó los permisos de notificaciones.");
      // Aquí podrías mostrar un mensaje o redirigirlo a los ajustes
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ El usuario tiene permisos de notificación activados.");
    } else {
      print("⚠️ El usuario aún no ha decidido.");
    }
  }

  Future<void> setupLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void mostrarNoticacionLocal(RemoteMessage message) {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.high, priority: Priority.high,
    );

    var iOSDetails = const DarwinNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      message.notification?.title ?? "Sin título",
      message.notification?.body ?? "Sin cuerpo",
      generalNotificationDetails,
    );
  }

}