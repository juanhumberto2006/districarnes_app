import 'package:flutter/material.dart';
import '../models/product.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPageTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCategoryCard(
                      context,
                      'Res',
                      'Cortes Premium',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBy5cnHTpkshzKg3QVqipGTQ0888MhUMY0sfXlCQx689XggEcDOT_oII42UePZW8bEP3dQeHOrlnRmN3bDidcKQPjAgxRHaDVWzPf36QRJYC7NmLS4NhoLY4DZ7GUulJvcMXYJUs0G5F-S4825LFxlpcww7AjTZ8v8ta0ZyhYA2GfTFKoxVAQZkO2M62FaNX956oEvE-zUeTuqA63cXNYZshalHBRgfbF5spqF9L-Shz_A4Ew2Z6w05PaH7I2QNk8rC-L1fONFHxcAs',
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'Cerdo',
                      'Selección Porcina',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuChHdH-pobTsIA29UHLFnSYlqYLnR12vuRumNkwzpntjIymX0_V7iF0X1GQqGZdYcgg4FsdNz9nVFNFX6gjgdR9gvTZB26Xq6CoErO7wWljunIg96Se9hxm9sraL-d-0RACidi3ZjpzPmV03wJUGa9AGHzKHhlT13NziFkNChfH097_5ve3bykyBjnpQEwfQ6EJPk_orxQgq7ZHfDUaAhp4J1kw-9vXWhISfB0R42huUCRm59DvdK5WDDwwUNLSqmF5yIF9OummrpJ8',
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'Pollo',
                      'Granja Seleccionada',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'Embutidos',
                      'Calidad Artesanal',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'Achuras',
                      'Especialidades',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBdp5nM3wwuGiJcbMvJwtzoCY9QOh5uSWKby2Fiixr7l8zEAUB38tOdIkUmYnyBPnLz6qJ6yowk1AyyUUgDgmNoV5By3jJ_kpqpcTzzZbUqYa9MmBRcmL6AznBCrMwY-zQyCAep77Rwq5E2chPGl5-E5bULjStxF9-GxQ-IgMmAyCE6CkofQfnig4fr2TmjnDHzObaZ7Dg9VhL21RTsHG8CTI2RKHYVeFtj3-rPoFMJTf2ueVVsCFxCbsGv3HaDOVM2iOi9NybCwkYp',
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      'Combos Parrilleros',
                      'Ahorro y Calidad',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCW3qaX2CFFcTI55ZD3z8VIZ8vUQ_w9PXYcUBp__8P3pwYBwL99lPiWkbNIPy96kQOp3N3W68b-Sdk1wyKBxvdttjQbCS30mDuwycEvaL3aDc6G5ZvWc4eXERuN-HlVmEj4ZJD3vYg2jA4LdnWWG-faLwjuLNgfx1kQ2BkH8WpQNquRJaE83tawaEBKwzArOevL0d_iCxW_v9UUbipeIBLUCaBhJxk76JqwqrZkEJNG6HmkFSOVIuEv-GEG600Jxl1KvPvtCPwdIjCu',
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Colors.white),
          const Text(
            'DISTRICARNES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NUESTRAS CATEGORÍAS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona los mejores cortes premium',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE50615).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFE50615),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE50615),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE50615),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Inicio', false),
              _buildNavItem(Icons.grid_view, 'Categorías', true),
              _buildCartNavItem(context),
              _buildNavItem(Icons.favorite, 'Favoritos', false),
              _buildNavItem(Icons.person, 'Perfil', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCartNavItem(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE50615),
            ),
          ),
          child: const Icon(
            Icons.shopping_cart,
            color: Color(0xFFE50615),
            size: 24,
          ),
        ),
      ],
    );
  }
}
