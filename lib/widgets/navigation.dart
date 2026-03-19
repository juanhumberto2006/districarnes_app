import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/offers_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/orders_history_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/coupons_screen.dart';
import '../screens/login_screen.dart';

class AppNavigator extends StatefulWidget {
  final int initialIndex;
  final Widget? child;
  final bool showBackButton;
  final String? title;
  final bool isAuthenticated;
  final VoidCallback? onLogout;

  const AppNavigator({
    super.key,
    this.initialIndex = 0,
    this.child,
    this.showBackButton = false,
    this.title,
    this.isAuthenticated = false,
    this.onLogout,
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _mainScreens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const OffersScreen(),
    const ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0505),
        appBar: widget.showBackButton
            ? AppBar(
                backgroundColor: const Color(0xFF0A0505),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: widget.title != null
                    ? Text(
                        widget.title!,
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
                centerTitle: true,
                elevation: 0,
              )
            : null,
        body: widget.child,
        bottomNavigationBar: _buildBottomNav(),
      );
    }

    return Scaffold(
      body: _mainScreens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE50615),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'INICIO'),
              _buildNavItem(1, Icons.grid_view, 'CATEGORÍAS'),
              _buildNavItem(2, Icons.shopping_cart, 'CARRITO'),
              _buildNavItem(3, Icons.sell, 'OFERTAS'),
              _buildNavItem(4, Icons.person, 'CUENTA'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;

    if (index == 2) {
      return GestureDetector(
        onTap: () => _onTabSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
                border: Border.all(color: const Color(0xFFE50615), width: 3),
              ),
              child: Icon(icon, color: const Color(0xFFE50615), size: 26),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final int currentNavIndex;

  const ScreenWrapper({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = true,
    this.currentNavIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0505),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE50615),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50615).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'INICIO'),
              _buildNavItem(context, 1, Icons.grid_view, 'CATEGORÍAS'),
              _buildNavItem(context, 2, Icons.shopping_cart, 'CARRITO'),
              _buildNavItem(context, 3, Icons.sell, 'OFERTAS'),
              _buildNavItem(context, 4, Icons.person, 'CUENTA'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = currentNavIndex == index;

    if (index == 2) {
      return GestureDetector(
        onTap: () => _navigateTo(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
                border: Border.all(color: const Color(0xFFE50615), width: 3),
              ),
              child: Icon(icon, color: const Color(0xFFE50615), size: 26),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _navigateTo(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 8,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OffersScreen()),
          (route) => false,
        );
        break;
      case 4:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
          (route) => false,
        );
        break;
    }
  }
}

void navigateToScreen(BuildContext context, Widget screen, {String? title}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateToLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}

void navigateToHome(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
    (route) => false,
  );
}

void navigateToCategories(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const CategoriesScreen()),
    (route) => false,
  );
}

void navigateToCart(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const CartScreen()),
    (route) => false,
  );
}

void navigateToOffers(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const OffersScreen()),
    (route) => false,
  );
}

void navigateToProfile(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const ProfileScreen()),
    (route) => false,
  );
}

void navigateToNotifications(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
  );
}

void navigateToOrdersHistory(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OrdersHistoryScreen()),
  );
}

void navigateToFavorites(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FavoritesScreen()),
  );
}

void navigateToHelpSupport(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
  );
}

void navigateToCoupons(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CouponsScreen()),
  );
}
