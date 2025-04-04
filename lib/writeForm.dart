/**
 * ${PHONEAPP}
 *  FileName : ${writeForm.dart}
 * Class: ${WriteForm}.
 * Created by ${승룡}.
 * Created On ${3.14}.
 * Description: 연락처 추가 폼
 *
 * 필수 필드 (id, name, phone_number, email) - Null 불가
 * 선택적 필드 (nickname, memo) - Null 가능
 */

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';

class WriteForm extends StatelessWidget {
  const WriteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호 추가"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: _WriteForm(),
    );
  }
}

class _WriteForm extends StatefulWidget {
  const _WriteForm({super.key});

  @override
  State<_WriteForm> createState() => _WriteFormState();
}

class _WriteFormState extends State<_WriteForm> {
  // static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";
  static const String apiEndpoint = "http://3.36.112.4:28088/api/phoneApp";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                _nameController,
                "이름",
                "이름을 입력하세요",
              ).animate().fadeIn(duration: 500.ms),
              _buildTextField(
                _phoneNumberController,
                "전화번호",
                "전화번호를 입력하세요",
              ).animate().fadeIn(duration: 500.ms),
              _buildTextField(
                _emailController,
                "이메일",
                "이메일을 입력하세요",
              ).animate().fadeIn(duration: 500.ms),
              _buildTextField(
                _nicknameController,
                "닉네임",
                "닉네임을 입력하세요",
              ).animate().fadeIn(duration: 500.ms),
              _buildMemoField(
                _memoController,
                "메모",
                "메모를 입력하세요",
              ).animate().fadeIn(duration: 500.ms),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    createInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white, // 버튼 배경색
                    foregroundColor: Colors.blue, // 버튼 텍스트 및 아이콘 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('정보 추가'),
                ).animate().fadeIn(duration: 500.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 기본 TextFormField 스타일을 위한 메소드
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  // 메모 입력 필드 스타일을 위한 메소드
  Widget _buildMemoField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  void createInfo() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      PhoneAppVo phoneAppVo = PhoneAppVo(
        id: 0,
        name: _nameController.text,
        phone_number: _phoneNumberController.text,
        email: _emailController.text,
        // nickname: _nicknameController.text,
        // memo: _memoController.text,
        nickname:
            _nicknameController.text.isEmpty ? null : _nicknameController.text,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
      );

      //  - apiPoint가 그냥 apiEndpoint/insert 일 경우 아래의 주소로
      // final response = await dio.post(
      // apiEndpoint + "/insert",
      // data: phoneAppVo.toJson(),
      // );

      // [연경] - apiPoint가 그냥 apiEndpoint일 경우 아래의 주소로
      final response = await dio.post(apiEndpoint, data: phoneAppVo.toJson());

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/home");
      } else {
        throw Exception("정보 추가 실패하였습니다.: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("정보를 추가하지 못했습니다.:$e");
    }
  }
}
