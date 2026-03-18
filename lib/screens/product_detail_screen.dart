import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedWeightIndex = 0;
  int selectedImageIndex = 0;

  final List<Map<String, String>> images = [
    {'url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBmNdIssHZgoXcu_tiBNSlp7VJ5Npq_woXzzhpSdG8v-sf6VmtHnAp2KkqhoEAf1a-V5QFsIOYLjx3Foyk4H_eugN1yqufVsDdSKsGFzv8pAGJC_nwVz66_eGCXkSenIFhctxz10WMSaV_JbeZ4mV2C-QdJiiaH08iOohCFDhoGYBiKbdANP0-Vgsy4uhpIajot2WxNnAdGGibXSQF7w61ha7ZkMm8XWFYkYHRILmBDaaD4iI0QWtzTJIy0eGaTje6Ay9iLWPyBaDJt', 'alt': 'Ribeye steak'},
    {'url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAug8FfsR-yTomB2hM8QRh9QZ6_2IOM0j1NtPvJmvLjfyy00WHREXlwQBZQoOLvFiGpJzZmITaREIGiDTk7jzfN_KXZJ6wZE6kMJV8YJETe_yYx2X-jo708jnv3N0e-_yZB8uZo2q2L_y5iIrc-93MaBMxMX2ey_0GbyHlsPMTXc7RgWBnz6XZAhgUkuDgz2zA17NHe1UCObj0q76uc36zAXqFZJKFmSNGl0qAiD_bhxbd_LFGB2moJC7mZNdkyKCPA8uuabsXh7xV4', 'alt': 'Cooked steak'},
    {'url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCeb5jV8PeYqTr0X4EEXrRvWKU5_qM7Q62DF4tT4I0OkOjGc5LaVUHBB3nrGAwAn5OtFVI94ZmlN_QJTWlXSPhvrg6s1BpqtqFo_dhDguvWbeqJHgsdElk62P_z4UNYafaajrn6V7mD4yCgFde4Z5RTTJ1FK76TyfosLBVSGb0VgsNDbJM7d5AnENDVsiHv7PKLG_BetR6KpS5RxM_VsRvDCehfhta2OY5zjMtOUuBkRjknuvJEOc5Y5GROjDIClgV2QNRPwNGqEOdL', 'alt': 'Grill preparation'},
  ];

  final List<String> weights = ['500g', '1kg', '2kg'];

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildMainImage(),
                    _buildImageThumbnails(),
                    _buildProductInfo(),
                    _buildFeaturesGrid(),
                    _buildWeightSelector(),
                    _buildDescription(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    return Container(
      width: double.infinity,
      height: 350,
      color: Colors.grey[900],
      child: Image.network(
        images[selectedImageIndex]['url']!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[900],
            child: const Icon(Icons.image, color: Colors.grey, size: 80),
          );
        },
      ),
    );
  }

  Widget _buildImageThumbnails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedImageIndex;
            return GestureDetector(
              onTap: () => setState(() => selectedImageIndex = index),
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFE50615) : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE50615).withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Opacity(
                    opacity: isSelected ? 1.0 : 0.6,
                    child: Image.network(
                      images[index]['url']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFE50615),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '4.8',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' (125 reseñas)',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFE50615),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'por kilogramo',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (widget.product.hasDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50615),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '-20% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildFeatureItem(Icons.public, 'Origen', 'Argentina'),
          _buildFeatureItem(Icons.layers, 'Empaque', 'Al Vacío'),
          _buildFeatureItem(Icons.verified, 'Calidad', 'Exportación'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE50615).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE50615).withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFE50615), size: 24),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELECCIONAR PESO',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(weights.length, (index) {
              final isSelected = index == selectedWeightIndex;
              return GestureDetector(
                onTap: () => setState(() => selectedWeightIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE50615) : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFE50615) : Colors.grey.shade700,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE50615).withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    weights[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DESCRIPCIÓN GOURMET',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Corte de carne premium de la más alta calidad, seleccionado especialmente para garantizar la mejor experiencia gastronómica. Proveniente de las mejores razas ganaderas, nuestro Ojo de Bife se caracteriza por su jugosidad y sabor excepcional. Perfecto para parrilla, freidora de aire o sartén.',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.local_shipping, 'Envío gratis en pedidos mayores a \$100.000'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.eco, '100% Natural sin aditivos'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, 'Entrega en 24-48 horas'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE50615), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505).withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _decrementQuantity,
                    icon: Icon(Icons.remove, color: Colors.grey[300]),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _incrementQuantity,
                    icon: Icon(Icons.add, color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text('AÑADIR AL CARRITO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50615),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
