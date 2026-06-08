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
    height: 220,
    banners: [
      BannerItem(
        header: "Promo Diskon 50%!",
        subText: "Khusus hari ini, jangan sampai kehabisan",
        backgroundColor: Colors.blueAccent,
        imageUrl: "https://...img",
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
    this.height = 200.0, 
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
    int initialPage = widget.banners.isNotEmpty ? widget.banners.length * 1000 : 0;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = initialPage;
    
    _startAutoPlay();
  }

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
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final itemIndex = index % widget.banners.length;
              final banner = widget.banners[itemIndex];

              return _buildBannerContent(banner);
            },
          ),
          
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
          child: Column( // <-- MENGGUNAKAN COLUMN UNTUK MENYUSUN HEADER & SUB-TEKS
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // WIDGET UNTUK HEADER BANNER
              Text(
                banner.header,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Tampilkan subText jika data subText diisi (tidak null)
              if (banner.subText != null && banner.subText!.isNotEmpty) ...[
                const SizedBox(height: 6), // Jarak kecil antara header dan sub-teks
                Text(
                  banner.subText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85), // Warna teks sedikit lebih soft
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    final isActive = (_currentPage % widget.banners.length) == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}