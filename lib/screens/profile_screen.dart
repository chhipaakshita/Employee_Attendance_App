import 'package:employee_attendance_app/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employee_attendance_app/models/department_model.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController namecontroller = TextEditingController();
  int selectedValue = 0;


  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    dbService.allDepartments.isEmpty ? dbService.getAllDepartment() : null;
    namecontroller.text.isEmpty ? namecontroller.text = dbService.userModel!.name ?? '' : null;
    return Scaffold(
      body: dbService.userModel == null ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:80),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size:50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("Employee Id : ${dbService.userModel?.employeeId}" ),
                  SizedBox(height: 30,),
                  TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      label: Text("Fullname"),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 15,),
                  dbService.allDepartments.isEmpty ? LinearProgressIndicator() :
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          //onChanged: onChanged,
                          decoration: InputDecoration(
                                border: OutlineInputBorder()
                          ),
                          value: dbService.employeeDepartment ?? dbService.allDepartments.first.id,
                          items: dbService.allDepartments.map((DepartmentModel item) {
                                return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.title,style: TextStyle(
                                      fontSize: 20
                                    ),));
                          }).toList(), onChanged: (selectedValue) {
                            dbService.employeeDepartment = selectedValue;
                        },
                        ),
                      ),
                  SizedBox(height: 40,),
                  SizedBox(
                    width: 200,
                    height: 50,
                      child: ElevatedButton(
                            onPressed: (){
                              dbService.updateProfile(namecontroller.text.trim(), context);
                            },
                            child: Text("Update Profile",style: TextStyle(fontSize: 20),))
                    ),

                ],
              ),
        ),
      )
    );
  }
}
