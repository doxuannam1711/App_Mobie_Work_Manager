import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_application/nav_drawer.dart';


class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _listAvatar = [
    'https://png.pngtree.com/png-vector/20191027/ourlarge/pngtree-cute-pug-avatar-with-a-yellow-background-png-image_1873432.jpg',
    'https://dogily.vn/wp-content/uploads/2022/12/Anh-avatar-cho-Shiba-4.jpg',
    'https://top10camau.vn/wp-content/uploads/2022/10/avatar-meo-cute-5.jpg',
  ];
bool? cbvalue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              
              Container(
                alignment: Alignment.centerLeft,
                width: 400,
                height: 40,
                decoration: BoxDecoration(
                  
                    color: Colors.grey.withOpacity(1.0),
                    
                ),
                padding: const EdgeInsets.fromLTRB(17,1,5,5) ,
                child: Text(
                  'Bảng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                    ),
                ),
                
                
              ),
              Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,                                 
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              'Việc làm ở công ty',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Text(
                          '7-11-2023',
                          style:
                              TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                      
                    ),
                  ),

                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Colors.grey[200],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,                                 
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              'Công ty ABC',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Text(
                          '9-10-2023',
                          style:
                              TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                      
                    ),
                  ),

              Container(
                alignment: Alignment.centerLeft,
                width: 400,
                height: 40,
                decoration: BoxDecoration(
                  
                    color: Colors.grey.withOpacity(1.0),
                    
                ),
                padding: const EdgeInsets.fromLTRB(17,1,5,5) ,
                child: Text(
                  'Thẻ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                    ),
                ),
              ),
              ListTile(
                minLeadingWidth: 1,
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
              ),
              
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'Front End',
                ),
              ),
            
              subtitle: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [         
                    const Icon(Icons.calendar_today_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(
                    '25-12-2023',
                    ),
              
                    const SizedBox(width: 8),

                    const Icon(Icons.comment_outlined, size: 16), 
                    const SizedBox(width: 4),
                    Text('15'),

                    const SizedBox(width: 8),

                    const Icon(Icons.check_box_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('14'),
                  ],
                ),
              ),
              
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 14,backgroundImage: NetworkImage(_listAvatar[0])),
                  const SizedBox(width: 2),
                  CircleAvatar(radius: 14,backgroundImage: NetworkImage(_listAvatar[1])),
                  const SizedBox(width: 2),
                  CircleAvatar(radius: 14,backgroundImage: NetworkImage(_listAvatar[2])),
                ],
              ),
            ),
              
              Container(
                alignment: Alignment.centerLeft,
                width: 400,
                height: 40,
                decoration: BoxDecoration(
                  
                    color: Colors.grey.withOpacity(1.0),
                    
                ),
                padding: const EdgeInsets.fromLTRB(17,1,5,5) ,
                child: Text(
                  'Công việc cần hoàn thành',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                    ),
                ),
              ),

              Row(
                children: [
                  Checkbox(value: cbvalue, onChanged: (value){
                setState(() {
                  cbvalue = value;
                });
                
              }),
              Text('Khảo sát phân tích nghiệp vụ'),
                ],
              )
              
              
            ],
            
          ),
        ],
      )
      
    );
  }

}