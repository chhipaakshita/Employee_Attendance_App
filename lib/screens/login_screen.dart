import 'package:employee_attendance_app/screens/register_screen.dart';
import 'package:employee_attendance_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight/3,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(70))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code,color: Colors.white,size: 80,),
                  SizedBox(height: 20,),
                  Text('FAANG',style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.all(20),
              child:Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        label: Text('Employee Email Id'),
                        prefixIcon: Icon(Icons.person_2_outlined),
                        border: OutlineInputBorder()
                    ),
                    controller: _emailController,
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                        label: Text(' Password'),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder()
                    ),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 30,),
                  Consumer<AuthService>(
                      builder:(context,authServiceProvider,child){
                        return  SizedBox(
                          height: 60,
                          width: double.infinity,
                          child:authServiceProvider.isLoading?Center(
                            child: CircularProgressIndicator(),
                          ):
                          ElevatedButton(onPressed: (){
                            authServiceProvider.logInEmployee(_emailController.text.trim(),
                                _passwordController.text.trim(), context);
                          },

                            child: Text('LOGIN',style: TextStyle(fontSize: 20,color:Colors.white),
                            ),style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )),),
                        );
                      }
                  ),
                  SizedBox(height: 20,),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                  },
                      child: Text('Are you a new employee ? Reister here'))
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
