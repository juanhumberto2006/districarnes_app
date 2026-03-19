import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilterChips(),
            Expanded(
              child: _buildNotificationsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE50615).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Notificaciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Marcar todo como leído',
              style: TextStyle(
                color: Color(0xFFE50615),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildChip('Todas', true),
          const SizedBox(width: 12),
          _buildChip('Pedidos', false),
          const SizedBox(width: 12),
          _buildChip('Ofertas', false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE50615) : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? null
            : Border.all(color: Colors.grey.shade800),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade300,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = [
      {
        'icon': Icons.local_shipping,
        'title': '¡Tu pedido #DC-98745 está en camino!',
        'message': 'Sigue tu entrega de cortes premium en tiempo real. El repartidor está cerca.',
        'time': 'Hace 30 min',
        'unread': true,
        'filled': true,
      },
      {
        'icon': Icons.percent,
        'title': '¡20% OFF en Ojo de Bife solo por hoy!',
        'message': 'Aprovecha esta oferta exclusiva de Districarnes. Stock limitado.',
        'time': 'Hace 2 horas',
        'unread': false,
        'filled': true,
      },
      {
        'icon': Icons.star,
        'title': 'Nuevas Achuras Premium',
        'message': 'Descubre nuestra nueva selección de Achuras Premium para tu próximo asado.',
        'time': 'Ayer',
        'unread': false,
        'filled': true,
      },
      {
        'icon': Icons.info_outline,
        'title': 'Horarios de feriado',
        'message': 'Conoce nuestros horarios de atención para este fin de semana largo.',
        'time': 'Hace 3 días',
        'unread': false,
        'filled': false,
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(
          icon: notification['icon'] as IconData,
          title: notification['title'] as String,
          message: notification['message'] as String,
          time: notification['time'] as String,
          unread: notification['unread'] as bool,
          filled: notification['filled'] as bool,
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool unread,
    required bool filled,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unread
            ? const Color(0xFFE50615).withOpacity(0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade900,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unread)
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE50615),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFE50615),
              size: 24,
              fill: filled ? 1.0 : 0.0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: unread ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50615),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE50615).withOpacity(0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  time.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
