import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_9/screens/about_hotel.dart';
import 'package:go_router/go_router.dart';

import 'models/hotel_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 211, 211, 211),
      ),
      routerConfig: _router,
      // home: const MyHomePage(title: 'Homework 9'),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const MyHomePage(
              title: 'Homework 9',
            );
          },
          routes: <GoRoute>[
            GoRoute(
              name: 'about_hotel',
              path: 'about_hotel/:title/:uuid',
              builder: (BuildContext context, GoRouterState state) {
                return AboutHotel(
                  title: state.params['title']!,
                  uuid: state.params['uuid']!,
                );
              },
            ),
          ]),
    ],
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<HotelModel> hotels;
  bool isListView = true;

  Future<List<HotelModel>> getHotelList() async {
    try {
      Response response = await Dio()
          .get('https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301');
      hotels =
          response.data.map<HotelModel>((hotels) => HotelModel.fromJson(hotels)).toList();
      return hotels;
    } on DioError catch (e) {
      throw Exception(e.error);
    }
  }

  void _switchToList() {
    setState(() {
      isListView = true;
    });
  }

  void _switchToGrid() {
    setState(() {
      isListView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: _switchToList,
              icon: const Icon(Icons.list),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: _switchToGrid,
              icon: const Icon(Icons.grid_on),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isListView
            ? FutureBuilder(
                future: getHotelList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView(
                          key: const PageStorageKey('list_key'),
                          children: <Widget>[
                            ...hotels.map((hotel) {
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'assets/images/${hotel.poster}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  hotel.name,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: ElevatedButton(
                                                onPressed: () => context
                                                    .pushNamed('about_hotel',
                                                        params: <String,
                                                            String>{
                                                      'title': hotel.name,
                                                      'uuid': hotel.uuid
                                                    }),
                                                child: const Text('Подробнее'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      );
                    default:
                      return const Center(child: Text('Нет данных с сервера!'));
                  }
                },
              )
            : FutureBuilder(
                future: getHotelList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: GridView(
                          key: const PageStorageKey('grid_key'),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 4,
                            childAspectRatio: 1,
                          ),
                          shrinkWrap: true,
                          children: <Widget>[
                            ...hotels.map((hotel) {
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/${hotel.poster}',
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: double.infinity,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                hotel.name,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => context.pushNamed(
                                              'about_hotel',
                                              params: {
                                                'title': hotel.name,
                                                'uuid': hotel.uuid
                                              }),
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          child: const Text(
                                            'Подробнее',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                          ],
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
