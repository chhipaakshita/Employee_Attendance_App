import 'package:employee_attendance_app/screens/login_screen.dart';
import 'package:employee_attendance_app/screens/splash_screen.dart';
import 'package:employee_attendance_app/services/attendance_service.dart';
import 'package:employee_attendance_app/services/auth_service.dart';
import 'package:employee_attendance_app/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    //load env
    await dotenv.load();
    //initialise supabase
    String supabaseUrl= dotenv.env['SUPABASE_URL'] ?? '';
    String supabaseKey= dotenv.env['SUPABASE_KEY'] ?? '';
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>AuthService()),
      ChangeNotifierProvider(create: (context)=>DbService()),
      ChangeNotifierProvider(create: (context)=>AttendanceService())
    ],
      child:  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen()
    )
    );
  }
}

