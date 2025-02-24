
import 'dart:math';

import 'package:employee_attendance_app/constants/constant.dart';
import 'package:employee_attendance_app/models/department_model.dart';
import 'package:employee_attendance_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class DbService extends ChangeNotifier{
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;
  List<DepartmentModel> allDepartments = [];
  int? employeeDepartment;
  String generateRandomEmployeeId(){
    final random = Random();
    const allChars = "faangFAANG0123456789";
    final randomString =
    List.generate(8, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  Future insertNewUser(String email, var id) async{
      await _supabase.from(Constant.employeeTable).insert({
        'id':id,
        'name':'',
        'email':email,
        'employee_id':generateRandomEmployeeId(),
        'department':null,
      });
  }

  Future<UserModel> getUserData() async{
    final userData = await _supabase
        .from(Constant.employeeTable)
        .select()
        .eq('id',_supabase.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromJson(userData);
    //Since this function can be called multiple times . then it will reset dept value
    //That is why we awe using condition to assign at first time
    employeeDepartment == null ? employeeDepartment = userModel?.department : null;
    return userModel!;
  }
  Future<void> getAllDepartment() async{
      final List result = await _supabase.from(Constant.departmentTable).select();
      allDepartments = result
          .map((department) => DepartmentModel.fromJson(department))
          .toList();
      notifyListeners();
  }

  Future updateProfile(String name,BuildContext context) async{
      await _supabase.from(Constant.employeeTable).update({
        'name': name,
        'department': employeeDepartment
      }).eq('id', _supabase.auth.currentUser!.id);
      
      Utils.showSnackbar("Profile updated successfully", context,color: Colors.green);
      notifyListeners();
  }
}