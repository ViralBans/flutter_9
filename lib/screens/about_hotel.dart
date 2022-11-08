import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/hotel_info_model.dart';

class AboutHotel extends StatefulWidget {
  const AboutHotel({Key? key, required this.title, required this.uuid})
      : super(key: key);

  final String title, uuid;

  @override
  State<AboutHotel> createState() => _AboutHotelState();
}

class _AboutHotelState extends State<AboutHotel> {
  String errorInfo = '';

  Future<HotelInfo> getHotelInfo(String uuid) async {
    HotelInfo hotelInfo;
    try {
      Response response = await Dio().get('https://run.mocky.io/v3/$uuid');
      Map<String, dynamic> data = Map.castFrom(response.data);
      hotelInfo = HotelInfo.fromJson(data);
      return hotelInfo;
    } on DioError catch (e) {
      Map<String, dynamic> errorData = Map.castFrom(e.response?.data);
      errorInfo = errorData['message'];
      print('Ошибка ${e.response?.statusCode} - $errorInfo');
      throw Exception(e.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getHotelInfo(widget.uuid),
          builder: (BuildContext context, AsyncSnapshot<HotelInfo> snapshot) {
            var info = snapshot.data;
            List<String> images = [];

            if (errorInfo.isEmpty) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  for (int i = 0; i < info!.photos.length; i++) {
                    images.add('assets/images/${info.photos[i]}');
                  }

                  final List<Widget> imageSliders = images
                      .map((item) => Container(
                            margin: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(item,
                                        fit: BoxFit.cover, width: 1000.0),
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(200, 0, 0, 0),
                                              Color.fromARGB(0, 0, 0, 0)
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Text(
                                          '${info.name} ${images.indexOf(item) + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ))
                      .toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                  ),
                                  items: imageSliders),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Страна: ${info.address.country}',
                                    ),
                                    Text(
                                      'Город: ${info.address.city}',
                                    ),
                                    Text(
                                      'Улица: ${info.address.street}',
                                    ),
                                    Text(
                                      'Рейтинг: ${info.rating}',
                                    ),
                                    const Center(
                                      child: Text(
                                        'Сервисы',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Платные',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Бесплатные',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 150,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  info.services.paid.length,
                                              itemBuilder: (context, index) {
                                                return Text(
                                                  info.services.paid[index],
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 150,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  info.services.free.length,
                                              itemBuilder: (context, index) {
                                                return Text(
                                                  info.services.free[index],
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return const Center(child: Text('Нет данных с сервера!'));
              }
            } else {
              return Center(child: Text(errorInfo));
            }
          },
        ),
      ),
    );
  }
}
