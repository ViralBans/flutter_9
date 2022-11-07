import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/hotel_address.dart';

class AboutHotel extends StatelessWidget {
  const AboutHotel({Key? key, required this.title, required this.uuid})
      : super(key: key);

  final String title, uuid;

  Future<List<Address>> getHotelAddress(String uuid) async {
    try {
      var response = await Dio().get('https://run.mocky.io/v3/$uuid');
      if (response.statusCode == 200) {
        Map hotelData = jsonDecode(response.data);
        List<dynamic> hotelInfo = hotelData["address"];
        return hotelInfo.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception("Ошибка! Код - ${response.statusCode}");
      }
    } on DioError catch (e) {
      return e.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getHotelAddress(uuid),
          builder: (BuildContext context, AsyncSnapshot<List<Address>> snapshot) {
            var currentAddress = snapshot.data![0];
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
                        Text('Test ${currentAddress.country} uuid = $uuid'),
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
