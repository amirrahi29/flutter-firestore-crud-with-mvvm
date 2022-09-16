import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/view/AddStudent.dart';
import 'package:flutter_firestore_crud/view/UpdateStudent.dart';
import 'package:flutter_firestore_crud/view_model/StudentViewModel.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {

  final studentViewModel = Get.put(StudentViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("All Student"),
          ),
          body: Obx(()=>LoadingOverlay(
            isLoading: studentViewModel.isLoading.value,
            child: Container(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: studentViewModel.allStudentList.length,
                  itemBuilder: (context,index)
                  {
                    return InkWell(
                      onTap: (){
                        Get.to(UpdateStudent(),
                        arguments: studentViewModel.allStudentList[index]);
                      },
                      child: Row(
                        children: <Widget>[

                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                    image: NetworkImage(studentViewModel.allStudentList[index].image!),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),

                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text(studentViewModel.allStudentList[index].name!),
                                  Text(studentViewModel.allStudentList[index].email!)

                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              studentViewModel.deleteStudent(studentViewModel.allStudentList[index]);
                            },
                              child: Icon(Icons.close,color: Colors.red,size: 32,))

                        ],
                      ),
                    );
                  }
              ),
            ),
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Get.to(AddStudent());
            },
            child: Icon(Icons.add),
          ),
        )
    );
  }
}
