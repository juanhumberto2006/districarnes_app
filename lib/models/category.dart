import 'product.dart';

class Category {
  final String name;
  final String imageUrl;
  final List<Product> products;

  Category({
    required this.name,
    required this.imageUrl,
    required this.products,
  });
}

final List<Category> categories = [
  Category(
    name: 'RES',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy5cnHTpkshzKg3QVqipGTQ0888MhUMY0sfXlCQx689XggEcDOT_oII42UePZW8bEP3dQeHOrlnRmN3bDidcKQPjAgxRHaDVWzPf36QRJYC7NmLS4NhoLY4DZ7GUulJvcMXYJUs0G5F-S4825LFxlpcww7AjTZ8v8ta0ZyhYA2GfTFKoxVAQZkO2M62FaNX956oEvE-zUeTuqA63cXNYZshalHBRgfbF5spqF9L-Shz_A4Ew2Z6w05PaH7I2QNk8rC-L1fONFHxcAs',
    products: [
      Product(
        name: 'Entraña Premium',
        price: 4200,
        rating: 5.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy5cnHTpkshzKg3QVqipGTQ0888MhUMY0sfXlCQx689XggEcDOT_oII42UePZW8bEP3dQeHOrlnRmN3bDidcKQPjAgxRHaDVWzPf36QRJYC7NmLS4NhoLY4DZ7GUulJvcMXYJUs0G5F-S4825LFxlpcww7AjTZ8v8ta0ZyhYA2GfTFKoxVAQZkO2M62FaNX956oEvE-zUeTuqA63cXNYZshalHBRgfbF5spqF9L-Shz_A4Ew2Z6w05PaH7I2QNk8rC-L1fONFHxcAs',
      ),
      Product(
        name: 'Ojo de Bife',
        price: 5500,
        originalPrice: 6875,
        rating: 4.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDzwvFwyUUldTbG9EIbWNpQJbJXnCkwNz58yMBzL3xIXPP5j-z5l_B1rTClCB9C8HG4zEWjOrjVpSofRMTNDrZVkF8s8p4jhF_Hny8Z3icU1So5iHbKvJlPFpYBjkRcK98exJicdptaY12q26RleQ1njeM7e9oIMA6diYPOMGp7XYUAH08CgzQN_RhT5yzhbJF5fxOLMS4arIogiCqOAX9WrXa615wOm-wTF4SZTHew8o15o-UxlqFqbKH6xmGg2KsdHV-FcxEzfAFM',
        hasDiscount: true,
      ),
      Product(
        name: 'T-Bone Export',
        price: 4800,
        rating: 4.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChHdH-pobTsIA29UHLFnSYlqYLnR12vuRumNkwzpntjIymX0_V7iF0X1GQqGZdYcgg4FsdNz9nVFNFX6gjgdR9gvTZB26Xq6CoErO7wWljunIg96Se9hxm9sraL-d-0RACidi3ZjpzPmV03wJUGa9AGHzKHhlT13NziFkNChfH097_5ve3bykyBjnpQEwfQ6EJPk_orxQgq7ZHfDUaAhp4J1kw-9vXWhISfB0R42huUCRm59DvdK5WDDwwUNLSqmF5yIF9OummrpJ8',
      ),
      Product(
        name: 'Ribeye Premium',
        price: 5200,
        rating: 5.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDzwvFwyUUldTbG9EIbWNpQJbJXnCkwNz58yMBzL3xIXPP5j-z5l_B1rTClCB9C8HG4zEWjOrjVpSofRMTNDrZVkF8s8p4jhF_Hny8Z3icU1So5iHbKvJlPFpYBjkRcK98exJicdptaY12q26RleQ1njeM7e9oIMA6diYPOMGp7XYUAH08CgzQN_RhT5yzhbJF5fxOLMS4arIogiCqOAX9WrXa615wOm-wTF4SZTHew8o15o-UxlqFqbKH6xmGg2KsdHV-FcxEzfAFM',
      ),
    ],
  ),
  Category(
    name: 'CERDO',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChHdH-pobTsIA29UHLFnSYlqYLnR12vuRumNkwzpntjIymX0_V7iF0X1GQqGZdYcgg4FsdNz9nVFNFX6gjgdR9gvTZB26Xq6CoErO7wWljunIg96Se9hxm9sraL-d-0RACidi3ZjpzPmV03wJUGa9AGHzKHhlT13NziFkNChfH097_5ve3bykyBjnpQEwfQ6EJPk_orxQgq7ZHfDUaAhp4J1kw-9vXWhISfB0R42huUCRm59DvdK5WDDwwUNLSqmF5yIF9OummrpJ8',
    products: [
      Product(
        name: 'Lomo de Cerdo',
        price: 2800,
        rating: 4.5,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChHdH-pobTsIA29UHLFnSYlqYLnR12vuRumNkwzpntjIymX0_V7iF0X1GQqGZdYcgg4FsdNz9nVFNFX6gjgdR9gvTZB26Xq6CoErO7wWljunIg96Se9hxm9sraL-d-0RACidi3ZjpzPmV03wJUGa9AGHzKHhlT13NziFkNChfH097_5ve3bykyBjnpQEwfQ6EJPk_orxQgq7ZHfDUaAhp4J1kw-9vXWhISfB0R42huUCRm59DvdK5WDDwwUNLSqmF5yIF9OummrpJ8',
      ),
      Product(
        name: 'Costillas',
        price: 2200,
        rating: 4.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChHdH-pobTsIA29UHLFnSYlqYLnR12vuRumNkwzpntjIymX0_V7iF0X1GQqGZdYcgg4FsdNz9nVFNFX6gjgdR9gvTZB26Xq6CoErO7wWljunIg96Se9hxm9sraL-d-0RACidi3ZjpzPmV03wJUGa9AGHzKHhlT13NziFkNChfH097_5ve3bykyBjnpQEwfQ6EJPk_orxQgq7ZHfDUaAhp4J1kw-9vXWhISfB0R42huUCRm59DvdK5WDDwwUNLSqmF5yIF9OummrpJ8',
      ),
    ],
  ),
  Category(
    name: 'POLLO',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
    products: [
      Product(
        name: 'Pechuga Premium',
        price: 1800,
        rating: 4.5,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
      ),
      Product(
        name: 'Muslos',
        price: 1500,
        rating: 4.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
      ),
    ],
  ),
  Category(
    name: 'EMBUTIDOS',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
    products: [
      Product(
        name: 'Chorizo Artesanal',
        price: 2100,
        rating: 5.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
        unit: '/ un',
      ),
      Product(
        name: 'Morcilla',
        price: 1900,
        rating: 4.5,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQTuhBwjRAzwUYj9imJotXkXl_MwIQ52EFIL3H6EuP3_zM2r8OcWeuXIZCSgyzShLjp9_JKi-skZck2HylteIwGILIb5nIl11_9zZPQ8cy5VCi2MjHVLCoWSYmXXQQYXbUFpE8hkcAVQdsEwVjbZvsxx9Mdc2HVwsHNaj_3e9I5uzdKZqAA426-gmUCyYd6PhjxiVLXS3sYhctbMSK3m_HSkHU5P2_zjw5C3CgkvrNp3I0Puw6e__FQQnCLRHeQP9vQ3pNFbK4Stet',
        unit: '/ un',
      ),
    ],
  ),
];
