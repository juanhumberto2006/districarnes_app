import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageSearchService {
  static final ImageSearchService _instance = ImageSearchService._internal();
  factory ImageSearchService() => _instance;
  ImageSearchService._internal();

  final Map<String, String> _imageCache = {};

  Future<String?> searchImage(String productName, String category) async {
    final cacheKey = '${productName}_$category';
    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey];
    }

    try {
      String searchQuery = productName;
      if (!productName.toLowerCase().contains('carne') && 
          !productName.toLowerCase().contains('pollo') &&
          !productName.toLowerCase().contains('cerdo') &&
          !productName.toLowerCase().contains('res')) {
        searchQuery = '$productName carne';
      }

      final encodedQuery = Uri.encodeComponent(searchQuery);
      
      final url = 'https://en.wikipedia.org/w/api.php?action=query&titles=$encodedQuery&prop=pageimages&pithumbsize=500&format=json&origin=*';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']?['pages'];
        
        if (pages != null) {
          for (var page in pages.values) {
            if (page['thumbnail'] != null) {
              final imageUrl = page['thumbnail']['source'];
              _imageCache[cacheKey] = imageUrl;
              return imageUrl;
            }
          }
        }
      }
    } catch (e) {
      print('Error searching image: $e');
    }

    return _getDefaultImageByCategory(category);
  }

  String _getDefaultImageByCategory(String category) {
    final upperCategory = category.toUpperCase();
    
    final Map<String, String> defaultImages = {
      'RES': 'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=400&q=80',
      'CERDO': 'https://images.unsplash.com/photo-1606851181064-d6a567a5f8d4?w=400&q=80',
      'POLLO': 'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=400&q=80',
      'EMBUTIDOS': 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80',
      'OTROS': 'https://images.unsplash.com/photo-1606850780554-b55d26756aa3?w=400&q=80',
    };
    
    return defaultImages[upperCategory] ?? defaultImages['OTROS']!;
  }

  String getDefaultImage(String category) {
    return _getDefaultImageByCategory(category);
  }
}

final imageSearchService = ImageSearchService();
