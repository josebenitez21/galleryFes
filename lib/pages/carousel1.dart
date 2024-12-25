import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Carousel1());
}

class Carousel1 extends StatefulWidget {
  const Carousel1({super.key});

  @override
  State<Carousel1> createState() => _Carousel1State();
}

class _Carousel1State extends State<Carousel1> {
  final PageController _pageController = PageController(viewportFraction: 0.6);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Albumes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBar(),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: albumData.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      // Establecemos un tamaño predeterminado mientras las dimensiones se calculan
                      double value = 1.0;
                      double height = 400; // Tamaño predeterminado
                      double width = 300; // Tamaño predeterminado

                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        value = (_pageController.page! - index).abs();
                        value = (1 - value * 0.3).clamp(0.7, 1.0);

                        height = Curves.easeOut.transform(value) * 400;
                        width = Curves.easeOut.transform(value) * 300;
                      }

                      return Center(
                        child: SizedBox(
                          height: height, // Aplica el tamaño inicial o dinámico
                          width: width,
                          child: child,
                        ),
                      );
                    },
                    child: Transform(
                      transform: Matrix4.identity()
                        ..rotateY(
                          _pageController.hasClients &&
                                  _pageController.position.haveDimensions
                              ? _getRotationAngle(index)
                              : 0,
                        ),
                      alignment: Alignment.center,
                      child: AlbumCard(
                        imageUrl: albumData[index]['imageUrl']!,
                        title: albumData[index]['title']!,
                        date: albumData[index]['date']!,
                        photoCount: albumData[index]['photoCount']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calcula el ángulo de rotación de cada tarjeta
  double _getRotationAngle(int index) {
    if (_pageController.hasClients &&
        _pageController.position.haveDimensions &&
        _pageController.page != null) {
      return index == _pageController.page!.round()
          ? 0
          : (pi / 8) * (index < _pageController.page! ? 1 : -1);
    }
    return 0; // Valor predeterminado
  }
}

const List<Map<String, String>> albumData = [
  {
    'imageUrl':
        'https://images.pexels.com/photos/1164985/pexels-photo-1164985.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'title': 'LitioFest',
    'date': '20-12-2023',
    'photoCount': '150',
  },
  {
    'imageUrl':
        'https://images.pexels.com/photos/948199/pexels-photo-948199.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'title': 'Rock Fest',
    'date': '12-11-2023',
    'photoCount': '200',
  },
  {
    'imageUrl':
        'https://images.pexels.com/photos/1655329/pexels-photo-1655329.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'title': 'ElectroNight',
    'date': '15-10-2023',
    'photoCount': '180',
  },
];

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Ingresa el nombre del evento',
        hintStyle: const TextStyle(color: Colors.white60),
        prefixIcon: const Icon(Icons.search, color: Colors.white60),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String photoCount;

  const AlbumCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Imagen de fondo
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Cuadro con la fecha
          Positioned(
            top: 10,
            left: 10,
            child: _buildBlurBox(
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Cuadro con el número de fotos
          Positioned(
            top: 10,
            right: 10,
            child: _buildBlurBox(
              child: Row(
                children: [
                  const Icon(Icons.photo, color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    photoCount,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Título en la parte inferior
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Método para construir un cuadro con desenfoque (blur box)
  Widget _buildBlurBox({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Efecto de desenfoque
        child: Container(
          color: Colors.black.withOpacity(0.4), // Fondo semitransparente
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: child, // Contenido del cuadro
        ),
      ),
    );
  }
}
