import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/model/StudentModel.dart';
import 'package:get/get.dart';

class StudentViewModel extends GetxController{

  var isLoading = false.obs;
  var allStudentList = <StudentModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllStudent();
  }

  fetchAllStudent() async{
    isLoading.value = true;
    allStudentList.clear();
    await FirebaseFirestore.instance.collection("students").get()
    .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs)
        {
          allStudentList.add(StudentModel(
            id:u['id'],
            name:u['name'],
            email:u['email'],
            password:u['password'],
            image:u['image'],
          ));
        }
      if(allStudentList != null)
        {
          isLoading.value = false;
        }
    });
  }

  addStudent(File profileImage, String name, String email, String password) async{
    isLoading.value = true;

    int uniqueId = DateTime.now().microsecondsSinceEpoch;
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("students/$uniqueId")
    .putFile(profileImage);
    TaskSnapshot snapshot = await uploadTask;
    String downloadImageUrl = await snapshot.ref.getDownloadURL();

    if(downloadImageUrl != null)
      {
        StudentModel studentModel = StudentModel();
        studentModel.id = uniqueId;
        studentModel.name = name;
        studentModel.email = email;
        studentModel.password = password;
        studentModel.image = downloadImageUrl;

        FirebaseFirestore.instance.collection("students").doc(uniqueId.toString())
        .set(studentModel.toMap())
        .then((value) {
          isLoading.value = false;
          fetchAllStudent();
          Get.snackbar("Student addition",
              "One student added successfully",
              colorText: Colors.white,backgroundColor: Colors.green);
        })
        .catchError((error){
          isLoading.value = false;
          Get.snackbar("Student addition",
              "One student addition failed",
              colorText: Colors.white,backgroundColor: Colors.red);
        });

      }

  }

  updateStudent(File profileImage, String name, String email, String password,
      int id) async{
    isLoading.value = true;

    UploadTask uploadTask = FirebaseStorage.instance.ref().child("students/$id")
        .putFile(profileImage);
    TaskSnapshot snapshot = await uploadTask;
    String downloadImageUrl = await snapshot.ref.getDownloadURL();

    if(downloadImageUrl != null)
    {
      FirebaseFirestore.instance.collection("students").doc(id.toString())
          .update({
            'name':name,
            'email':email,
            'password':password,
            'image':downloadImageUrl,
           })
          .then((value) {
        isLoading.value = false;
        fetchAllStudent();
        Get.snackbar("Student updation",
            "One student updated successfully",
            colorText: Colors.white,backgroundColor: Colors.green);
      })
          .catchError((error){
        isLoading.value = false;
        Get.snackbar("Student updation",
            "One student updation failed",
            colorText: Colors.white,backgroundColor: Colors.red);
      });

    }
  }

  deleteStudent(StudentModel studentModel) async{
    allStudentList.remove(studentModel);
    await FirebaseFirestore.instance.collection("students").doc(studentModel.id.toString()).delete()
        .then((value){
      Get.snackbar("Student deletion",
          "One student deleted successfully",
          colorText: Colors.white,backgroundColor: Colors.green);
    }).catchError((error){
      Get.snackbar("Student deletion",
          "One student deletion failed",
          colorText: Colors.white,backgroundColor: Colors.red);
    });
  }


}