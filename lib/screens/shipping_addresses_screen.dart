import 'package:flutter/material.dart';

class ShippingAddressesScreen extends StatelessWidget {
  const ShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildAddressCard(
                      type: 'Casa',
                      address: 'Av. Libertador 1250, Piso 4B, Ciudad Autónoma de Buenos Aires, C1425',
                      icon: Icons.home,
                      isDefault: true,
                    ),
                    const SizedBox(height: 16),
                    _buildAddressCard(
                      type: 'Trabajo',
                      address: 'Av. Corrientes 450, Piso 10, Microcentro, CABA',
                      icon: Icons.work,
                      isDefault: false,
                    ),
                    const SizedBox(height: 16),
                    _buildAddressCard(
                      type: 'Quinta Pilar',
                      address: 'Calle Los Olmos 45, Barrio Cerrado "La Toscana", Pilar, Buenos Aires',
                      icon: Icons.cottage,
                      isDefault: false,
                    ),
                    const SizedBox(height: 16),
                    _buildMapPreview(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildAddButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE50615)),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Direcciones de Envío',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tus ubicaciones guardadas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Gestiona tus puntos de entrega premium',
          style: TextStyle(
            color: Color(0xFFE50615),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard({
    required String type,
    required String address,
    required IconData icon,
    required bool isDefault,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A0A0A),
            Color(0xFF0D0606),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault
              ? const Color(0xFFE50615).withOpacity(0.3)
              : Colors.grey.shade800,
        ),
        boxShadow: isDefault
            ? [
                BoxShadow(
                  color: const Color(0xFFE50615).withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDefault
                          ? const Color(0xFFE50615).withOpacity(0.2)
                          : Colors.grey.shade800.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: isDefault
                          ? Border.all(color: const Color(0xFFE50615).withOpacity(0.3))
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: isDefault ? const Color(0xFFE50615) : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE50615),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Predeterminada',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: Colors.grey.shade500, size: 20),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete, color: Colors.grey.shade500, size: 20),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (!isDefault) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Establecer como principal',
                style: TextStyle(
                  color: Color(0xFFE50615),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE50615).withOpacity(0.2),
        ),
        color: Colors.grey.shade900.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: Container(
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0A0505),
                ],
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              color: Color(0xFFE50615),
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('AGREGAR NUEVA DIRECCIÓN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50615),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
