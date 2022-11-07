import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/hotel_address.dart';

class AboutHotel extends StatefulWidget {
  const AboutHotel({Key? key, required this.title, required this.uuid})
      : super(key: key);

  final String title, uuid;

  @override
  State<AboutHotel> createState() => _AboutHotelState();
}

class _AboutHotelState extends State<AboutHotel> {
  late List<HotelInfo> _info = <HotelInfo>[];

  Future<List<HotelInfo>> getHotelAddress(String uuid) async {
    try {
      var response = await Dio().get('https://run.mocky.io/v3/$uuid');
      if (response.statusCode == 200) {
        var data = response.data;
        _info =
        jsonDecode(data) as List<HotelInfo>;
        print(_info);
        return _info;
      } else {
        return <HotelInfo>[];
      }
    } on DioError catch (e) {
      print(e.error);
      return <HotelInfo>[];
    }
  }

  @override
  void initState() {
    super.initState();
    getHotelAddress(widget.title).then((info) {
      setState(() {
        _info = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getHotelAddress(widget.uuid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text('Test ${_info.length} и uuid = ${widget.uuid}'),
                      ],
                    ),
                  ),
                );
              default:
                return const Center(child: Text('Нет данных с сервера!'));
            }
          },
        ),
      ),
    );
  }
}
