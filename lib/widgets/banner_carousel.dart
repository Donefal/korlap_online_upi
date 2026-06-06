import 'package:flutter/material.dart';
import 'dart:async';
import '../models/banner_item.dart';

/*
== CARA MENGGUNAKAN ==
1. import banner item
  import 'package:korlap_online_upi/models/banner_item.dart';
2. pada widget panggil BannerCarousel
3. bungkus setiap item dengan banners
4. setiap banner tuliskan dalam banner item
contoh : 
  BannerCarousel (
  height:
    banners: [
      BannerItem(
        teks:
        backgroundColor:
        imageUrl:
      )
    ]
  )

*/


class BannerCarousel extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final Duration autoPlayDuration;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 200.0, // Ukuran fiks untuk semua banner
    this.autoPlayDuration = const Duration(seconds: 7),
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Memulai dari angka besar (kelipatan jumlah banner) agar bisa langsung digeser ke kiri (infinite effect)
    int initialPage = widget.banners.isNotEmpty ? widget.banners.length * 1000 : 0;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = initialPage;
    
    _startAutoPlay();
  }

  // Fungsi agar banner geser otomatis
  void _startAutoPlay() {
    if (widget.banners.isEmpty) return;
    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Banner Slides
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            // Tidak diberikan itemCount agar bisa loop tak terbatas
            itemBuilder: (context, index) {
              // Menggunakan modulo (%) agar index kembali ke 0 setelah mencapai batas array
              final itemIndex = index % widget.banners.length;
              final banner = widget.banners[itemIndex];

              return _buildBannerContent(banner);
            },
          ),
          
          // Titik Indikator (Dots) di bawah banner
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                (index) => _buildDotIndicator(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerContent(BannerItem banner) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: banner.backgroundColor ?? Colors.grey.shade300,
        image: banner.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(banner.imageUrl!),
                fit: BoxFit.cover,
                // Efek gelap sedikit agar teks putih tetap terbaca jika pakai gambar
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            banner.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    // Mencocokan index titik dengan index banner saat ini
    final isActive = (_currentPage % widget.banners.length) == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0, // Jika aktif bentuknya memanjang
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}