import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveOrders(),
                  _buildPastOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE50615).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFE50615),
              ),
            ),
          ),
          const Text(
            'Mis Pedidos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE50615).withOpacity(0.1),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFE50615),
        labelColor: const Color(0xFFE50615),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Activos'),
          Tab(text: 'Pasados'),
        ],
      ),
    );
  }

  Widget _buildActiveOrders() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'En Curso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE50615),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '1 Pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActiveOrderCard(),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE50615).withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[800],
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAN6wmMGSZczIAjW6LuAI5UNd5MExvNKfQGqv0u2nVzkESqgQ1To5kNPiCw_o-b0lpNK58MEZUMdI18Nor36-K25ohlT89AuyNDYQ28vjQCwgT2Ozkojb9ZRNrZPJ4JJ1WiORJzWa1y8EZkiqAR5OPfeAxH4P6auni_ITeA8i69T_ENDXYKh7DWwhpD5HxE09lS1wuBXMeFbO7O8-xoIV1C1BBhlFKRQoEB1GbtknNAs94JVlY6qjy3ovLbVv6OygnY4-squXR0dJ_f',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pedido #DC-98745',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            color: Color(0xFFE50615),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'En camino',
                            style: TextStyle(
                              color: Color(0xFFE50615),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Llegará hoy entre 2-3 horas',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE50615).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50615),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Rastrear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50615),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastOrders() {
    final orders = [
      {
        'id': '#DC-98520',
        'date': '05 Oct 2023',
        'total': 145.00,
        'images': [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBEWsJQ1aeSK8ml7PWZ5NCu-eEVu2f0xhZwdBYPoy5Vys0gh6IcDuZ8cxgBd8w6425hWceuiiEKgHdBjPB92rVV00_lzPG5yno-jYTu1WsGzKIP0hePvmBX3ffGzYCRX9UR0c_iZBjl2WACEyiqT7JpzzVrIkQFuJva9yJW2BChg_mYOkcnBUvqvUnIeHUwFdy_mGph3OtXdl_DoapMEce8hksrKjuCCmtH0V6ll3-0DPqnh3nZc6AZmuTadApEOoL3ZDZjDBdiDbc0',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJt9lT5tz_DrLx1Q1rO7twsJqMQa4G4FTAsrf8hdBb6BKiv1g-9BHYNocTjyzOB27r4dL9XfBMUiAl-LkCt3mM3eMILhFmqH628TYDyZvnWY8qbp4jBxF3zQTgEN3nvSMh6sJ357NslkSbafw0hlaWzwz4GjA78BotDy_MuwemY5yt2PNlty',
        ],
        'extraItems': 2,
      },
      {
        'id': '#DC-98411',
        'date': '28 Sep 2023',
        'total': 89.50,
        'images': [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA1GLfZL0s9oKtSIb1Rg9Zo6_RuPXKWf0indqHFhUv0TbGqnx9njakrBet9BfIbofWvxiXasv4GUpe124YgoIowZ_PisLZczemzzMT7S4VeWQXtE1QCUnhT24KFAB4_O-zXYz6lal78djywdG483Dh3Uy_RP_fwzEAOq70tCc70SEBMo8FsNWPkdJIs8LoO1SQAJSkJj3KZpEbt1pkOTtd_wGDPUFCkwYfaLcwV3HSFrp2XOWmckijPVzLvpAN_fz1ONS0-iOURuv-s',
        ],
        'extraItems': 0,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildPastOrderCard(
          id: order['id'] as String,
          date: order['date'] as String,
          total: order['total'] as double,
          images: order['images'] as List<String>,
          extraItems: order['extraItems'] as int,
        );
      },
    );
  }

  Widget _buildPastOrderCard({
    required String id,
    required String date,
    required double total,
    required List<String> images,
    required int extraItems,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE50615).withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    id,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFE50615),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ...images.map((img) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[800],
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )),
              if (extraItems > 0)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50615).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '+$extraItems',
                      style: const TextStyle(
                        color: Color(0xFFE50615),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFE50615),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Detalles',
                    style: TextStyle(
                      color: Color(0xFFE50615),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.reorder, size: 16),
                  label: const Text('Repetir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50615),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
