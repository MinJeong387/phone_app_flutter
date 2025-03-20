/**
 * ${PHONEAPP}
 *  FileName : ${list.dart}
 * Class: ${PhoneAppList}.
 * Created by ${승룡}.
 * Created On ${3.14}.
 * Description: 연락처 목록 불러오기, 연락처 추가 기능 및 검색 기능
 */

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phone_app_flutter/phoneAppVo.dart';
import 'package:dio/dio.dart';
import 'package:rive/rive.dart';

class PhoneAppList extends StatelessWidget {
  const PhoneAppList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호부 리스트"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.white,
        // padding: EdgeInsets.only(top: 50),
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: _PhoneAppList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/insert");
        },
        child: Icon(
          Icons.add,
          color: Colors.white, // 아이콘 색상을 하얀색으로 설정
        ),
        backgroundColor: Colors.blueGrey, // 배경색 파란색
        tooltip: '전화번호 추가',
      ),
    );
  }
}

class _PhoneAppList extends StatefulWidget {
  const _PhoneAppList({super.key});

  @override
  State<_PhoneAppList> createState() => _PhoneAppListState();
}

class _PhoneAppListState extends State<_PhoneAppList> {
  // static const String apiEndpoint = "http://10.0.2.2:8090/api/phoneApp";
  static const String apiEndpoint = "http://3.36.112.4:28088/api/phoneApp";
  List<PhoneAppVo>? phoneAppList;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'name';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchPhoneAppList();
  }

  Future<void> fetchPhoneAppList() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";
      final response = await dio.get(apiEndpoint);

      if (response.statusCode == 200) {
        setState(() {
          phoneAppList =
              response.data
                  .map<PhoneAppVo>((item) => PhoneAppVo.fromJson(item))
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      setState(() {
        errorMessage = "전화번호 목록을 불러오는데 실패했습니다.: $e";
        isLoading = false;
      });
    }
  }

  List<PhoneAppVo>? filterPhoneAppList() {
    if (_searchQuery.isEmpty) return phoneAppList;

    return phoneAppList?.where((item) {
      if (_searchType == 'name') {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      } else {
        return item.phone_number.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
      }
    }).toList();
  }

  // 숫자인지 체크하는 함수
  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '🔍 검색',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _searchQuery = text;

                      if (isNumeric(text)) {
                        _searchType = 'phone_number';
                      } else {
                        _searchType = 'name';
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : phoneAppList == null || phoneAppList!.isEmpty
                  ? Center(child: Text("전화번호가 없습니다."))
                  : ListView.builder(
                    itemCount: filterPhoneAppList()!.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(
                        filterPhoneAppList()![index],
                      ).animate().fadeIn(duration: 500.ms);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildListItem(PhoneAppVo phoneAppVo) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          "/detail",
          arguments: {"id": phoneAppVo.id},
        );

        if (result == true) {
          // ✅ DetailPage에서 삭제 후 돌아오면 리스트 새로고침
          fetchPhoneAppList();
        }
      },
      child: Card(
        color: Colors.lightBlueAccent,
        margin: EdgeInsets.symmetric(vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // 테두리를 둥글게
        ),
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          leading: SizedBox(
            width: 50,
            height: 50,
            child: RiveAnimation.asset(
              'assets/animations/bear_avatar_remix.riv',
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            phoneAppVo.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            phoneAppVo.phone_number,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
