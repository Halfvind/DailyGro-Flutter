import '../models/home_product_model.dart';

final Map<int, List<HomeProductModel>> productsByCategory = {
  1: [ // Fruits
    HomeProductModel(
      id: 101,
      name: 'Apples',
      rating: 4.5,
      categoryId: 1,
      isFeatured: true,
      description: 'Crisp, sweet apples fresh from the orchard.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg',
      reviewCount: 342,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 50), ProductVariant(unit: "1kg", price: 100)], category: '',
    ),
    HomeProductModel(
      id: 102,
      name: 'Bananas',
      rating: 4.3,
      categoryId: 1,
      isFeatured: true,
      isRecommended: true,
      description: 'Naturally sweet and full of energy.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
      reviewCount: 287,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 30), ProductVariant(unit: "1kg", price: 55)], category: '',
    ),
    HomeProductModel(
      id: 103,
      name: 'Grapes',
      rating: 4.5,
      categoryId: 1,
      description: 'Juicy grapes perfect for snacking.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/13/2018_Grapes.jpg',
      reviewCount: 198,
      isAvailable: true,
      isRecommended: true,
      isFeatured: true,
       isBestSeller: false,
      variants: [ProductVariant(unit: "500g", price: 80), ProductVariant(unit: "1kg", price: 150)], category: '',
    ),
    HomeProductModel(
      id: 104,
      name: 'Mangoes',
      rating: 4.7,
      categoryId: 1,
      description: 'Sweet and aromatic tropical mangoes.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg',
      reviewCount: 455,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 120), ProductVariant(unit: "1kg", price: 220)], category: '',
    ),
    HomeProductModel(
      id: 105,
      name: 'Oranges',
      rating: 4.4,
      categoryId: 1,
      isBestSeller: true,
      description: 'Juicy and vitamin C rich oranges.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg',
      reviewCount: 320,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 60), ProductVariant(unit: "1kg", price: 110)], category: '',
    ),
    HomeProductModel(
      id: 106,
      name: 'Strawberries',
      rating: 4.8,
      categoryId: 1,
      isFeatured: true,
      isRecommended: true,
      description: 'Fresh and sweet strawberries.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/29/PerfectStrawberry.jpg',
      reviewCount: 280,
      isAvailable: true,
      variants: [ProductVariant(unit: "250g", price: 150), ProductVariant(unit: "500g", price: 280)], category: '',
    ),
    HomeProductModel(
      id: 107,
      name: 'Pineapple',
      rating: 4.5,
      categoryId: 1,
      description: 'Sweet and tangy tropical pineapple.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cb/Pineapple_and_cross_section.jpg',
      reviewCount: 195,
      isAvailable: true,
      variants: [ProductVariant(unit: "1 pc", price: 80), ProductVariant(unit: "2 pcs", price: 150)], category: '',
    ),
  ],
  2: [ // Vegetables
    HomeProductModel(
      id: 201,
      name: 'Tomato',
      rating: 4.3,
      categoryId: 2,
      isFeatured: true,
      description: 'Fresh, ripe, and perfect for any dish.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg',
      reviewCount: 215,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 15), ProductVariant(unit: "1kg", price: 25)], category: '',
    ),
    HomeProductModel(
      id: 202,
      name: 'Onions',
      rating: 4.1,
      categoryId: 2,
      description: 'Pungent and flavorful cooking essential.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/25/Onion_on_White.JPG',
      reviewCount: 178,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 20), ProductVariant(unit: "1kg", price: 35)], category: '',
    ),
    HomeProductModel(
      id: 203,
      name: 'Potatoes',
      rating: 4.2,
      categoryId: 2,
      isFeatured: true,
      description: 'Versatile and fresh farm potatoes.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/60/Potato.jpg',
      reviewCount: 310,
      isAvailable: true,
      variants: [ProductVariant(unit: "1kg", price: 25), ProductVariant(unit: "2kg", price: 45)], category: '',
    ),
    HomeProductModel(
      id: 204,
      name: 'Broccoli',
      rating: 4.6,
      categoryId: 2,
      description: 'Fresh green broccoli rich in vitamins.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/03/Broccoli_and_cross_section_edit.jpg',
      reviewCount: 312,
      isAvailable: true,
      variants: [ProductVariant(unit: "250g", price: 25), ProductVariant(unit: "500g", price: 40)], category: '',
    ),
    HomeProductModel(
      id: 205,
      name: 'Carrots',
      rating: 4.3,
      categoryId: 2,
      isBestSeller: true,
      isRecommended: true,
      description: 'Fresh orange carrots rich in beta-carotene.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Vegetable-Carrot-Bundle-wStalks.jpg',
      reviewCount: 245,
      isAvailable: true,
      variants: [ProductVariant(unit: "500g", price: 30), ProductVariant(unit: "1kg", price: 55)], category: '',
    ),
    HomeProductModel(
      id: 206,
      name: 'Bell Peppers',
      rating: 4.4,
      categoryId: 2,
      description: 'Colorful bell peppers perfect for cooking.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/85/Green-Yellow-Red-Pepper-2009.jpg',
      reviewCount: 180,
      isAvailable: true,
      variants: [ProductVariant(unit: "250g", price: 40), ProductVariant(unit: "500g", price: 75)], category: '',
    ),
  ],
  // 3. Dairy
  3: [
    HomeProductModel(
      id: 301,
      name: 'Whole Milk',
      rating: 4.7,
      categoryId: 3,
      category: 'Dairy',
      isRecommended: true,
      description: 'Fresh and creamy whole milk from local farms.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4b/Milk_glass.jpg',
      reviewCount: 320,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500ml", price: 25),
        ProductVariant(unit: "1L", price: 45)
      ],
    ),
    HomeProductModel(
      id: 302,
      name: 'Cheddar Cheese',
      rating: 4.6,
      categoryId: 3,
      category: 'Dairy',
      description: 'Rich and tangy cheddar aged to perfection.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4c/Cheddar_cheese.jpg',
      reviewCount: 260,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "200g", price: 120),
        ProductVariant(unit: "500g", price: 280)
      ],
    ),
  ],

// 4. Beverages
  4: [
    HomeProductModel(
      id: 401,
      name: 'Orange Juice',
      rating: 4.5,
      categoryId: 4,
      category: 'Beverages',
      description: 'Freshly squeezed orange juice with no added sugar.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/cd/Orange_juice_1.jpg',
      reviewCount: 298,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500ml", price: 60),
        ProductVariant(unit: "1L", price: 110)
      ],
    ),
    HomeProductModel(
      id: 402,
      name: 'Green Tea',
      rating: 4.4,
      categoryId: 4,
      category: 'Beverages',
      description: 'Refreshing green tea rich in antioxidants.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/23/Green_tea_2.jpg',
      reviewCount: 185,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "25 bags", price: 150),
        ProductVariant(unit: "50 bags", price: 280)
      ],
    ),
  ],

// 5. Snacks
  5: [
    HomeProductModel(
      id: 501,
      name: 'Potato Chips',
      rating: 4.3,
      categoryId: 5,
      category: 'Snacks',
      description: 'Crispy salted potato chips fried to golden perfection.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/69/Potato-Chips.jpg',
      reviewCount: 410,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "100g", price: 40),
        ProductVariant(unit: "200g", price: 75)
      ],
    ),
    HomeProductModel(
      id: 502,
      name: 'Chocolate Cookies',
      rating: 4.6,
      categoryId: 5,
      category: 'Snacks',
      description: 'Chewy chocolate chip cookies made with real butter.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/d/d7/Chocolate_chip_cookies.jpg',
      reviewCount: 230,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "200g", price: 90),
        ProductVariant(unit: "400g", price: 170)
      ],
    ),
  ],

// 6. Bakery
  6: [
    HomeProductModel(
      id: 601,
      name: 'Baguette',
      rating: 4.7,
      categoryId: 6,
      category: 'Bakery',
      description: 'Crisp crust and soft inside — classic French baguette.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f0/French_baguettes.jpg',
      reviewCount: 152,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "1 pc", price: 50)
      ],
    ),
    HomeProductModel(
      id: 602,
      name: 'Chocolate Cake',
      rating: 4.8,
      categoryId: 6,
      category: 'Bakery',
      description: 'Rich and moist chocolate cake topped with ganache.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/70/Chocolate_Cake.jpg',
      reviewCount: 498,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 250),
        ProductVariant(unit: "1kg", price: 480),
      ],
    ),
  ],

// 7. Meat
  7: [
    HomeProductModel(
      id: 701,
      name: 'Chicken Breast',
      rating: 4.5,
      categoryId: 7,
      category: 'Meat',
      description: 'Fresh, boneless chicken breast perfect for grilling.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/53/Raw_chicken_breast.jpg',
      reviewCount: 290,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 180),
        ProductVariant(unit: "1kg", price: 350)
      ],
    ),
    HomeProductModel(
      id: 702,
      name: 'Lamb Chops',
      rating: 4.6,
      categoryId: 7,
      category: 'Meat',
      description: 'Tender lamb chops with rich flavor.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Lamb_chops.jpg',
      reviewCount: 175,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 450),
        ProductVariant(unit: "1kg", price: 880)
      ],
    ),
  ],

// 8. Fish
  8: [
    HomeProductModel(
      id: 801,
      name: 'Salmon Fillet',
      rating: 4.8,
      categoryId: 8,
      category: 'Fish',
      description: 'Fresh salmon fillet rich in Omega-3.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fc/Salmon_fillet.jpg',
      reviewCount: 310,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "250g", price: 300),
        ProductVariant(unit: "500g", price: 580)
      ],
    ),
    HomeProductModel(
      id: 802,
      name: 'Prawns',
      rating: 4.7,
      categoryId: 8,
      category: 'Fish',
      description: 'Fresh, juicy prawns perfect for curries and grills.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/39/Prawns.jpg',
      reviewCount: 265,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "250g", price: 220),
        ProductVariant(unit: "500g", price: 420)
      ],
    ),
  ],

// 9. Frozen
  9: [
    HomeProductModel(
      id: 901,
      name: 'Frozen Peas',
      rating: 4.4,
      categoryId: 9,
      category: 'Frozen',
      description: 'Garden-fresh peas frozen to preserve taste and nutrients.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6b/Frozen_peas.jpg',
      reviewCount: 195,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 80),
        ProductVariant(unit: "1kg", price: 150)
      ],
    ),
    HomeProductModel(
      id: 902,
      name: 'Ice Cream Vanilla',
      rating: 4.8,
      categoryId: 9,
      category: 'Frozen',
      description: 'Creamy vanilla ice cream made from real milk.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e4/Vanilla_ice_cream_cone.jpg',
      reviewCount: 480,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500ml", price: 120),
        ProductVariant(unit: "1L", price: 220)
      ],
    ),
  ],

// 10. Personal Care
  10: [
    HomeProductModel(
      id: 1001,
      name: 'Shampoo',
      rating: 4.5,
      categoryId: 10,
      category: 'Personal Care',
      description: 'Nourishing shampoo for smooth, healthy hair.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/48/Shampoo_bottle.jpg',
      reviewCount: 215,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "200ml", price: 150),
        ProductVariant(unit: "500ml", price: 350)
      ],
    ),
    HomeProductModel(
      id: 1002,
      name: 'Toothpaste',
      rating: 4.6,
      categoryId: 10,
      category: 'Personal Care',
      description: 'Fluoride toothpaste for fresh breath and cavity protection.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/70/Toothpaste.jpg',
      reviewCount: 160,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "100g", price: 80),
        ProductVariant(unit: "200g", price: 150)
      ],
    ),
  ],

// 11. Household
  11: [
    HomeProductModel(
      id: 1101,
      name: 'Dishwashing Liquid',
      rating: 4.4,
      categoryId: 11,
      category: 'Household',
      description: 'Tough on grease, gentle on hands.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Dishwashing_liquid.jpg',
      reviewCount: 140,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500ml", price: 70),
        ProductVariant(unit: "1L", price: 130)
      ],
    ),
    HomeProductModel(
      id: 1102,
      name: 'Laundry Detergent',
      rating: 4.5,
      categoryId: 11,
      category: 'Household',
      description: 'Powerful cleaning for bright, fresh-smelling clothes.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/81/Laundry_detergent_bottle.jpg',
      reviewCount: 180,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "1kg", price: 120),
        ProductVariant(unit: "2kg", price: 220)
      ],
    ),
  ],

// 12. Baby Care
  12: [
    HomeProductModel(
      id: 1201,
      name: 'Baby Lotion',
      rating: 4.8,
      categoryId: 12,
      category: 'Baby Care',
      description: 'Gentle moisturizing lotion for baby\'s delicate skin.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/39/Baby_lotion.jpg',
      reviewCount: 155,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "200ml", price: 200),
        ProductVariant(unit: "500ml", price: 380)
      ],
    ),
    HomeProductModel(
      id: 1202,
      name: 'Baby Powder',
      rating: 4.7,
      categoryId: 12,
      category: 'Baby Care',
      description: 'Soft and gentle powder to keep baby\'s skin dry.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/82/Baby_powder.jpg',
      reviewCount: 170,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "200g", price: 150),
        ProductVariant(unit: "400g", price: 280)
      ],
    ),
  ],

// 13. Organic
  13: [
    HomeProductModel(
      id: 1301,
      name: 'Organic Quinoa',
      rating: 4.8,
      categoryId: 13,
      category: 'Organic',
      isFeatured: true,
      isRecommended: true,
      description: 'Premium organic quinoa rich in protein and fiber.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8f/Quinoa.jpg',
      reviewCount: 220,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 280),
        ProductVariant(unit: "1kg", price: 520)
      ],
    ),
    HomeProductModel(
      id: 1302,
      name: 'Organic Honey',
      rating: 4.9,
      categoryId: 13,
      category: 'Organic',
      description: 'Pure organic honey from wildflower nectar.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/78/Runny_hunny.jpg',
      reviewCount: 340,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "250g", price: 320),
        ProductVariant(unit: "500g", price: 580)
      ],
    ),
  ],

// 14. Spices & Herbs
  14: [
    HomeProductModel(
      id: 1401,
      name: 'Turmeric Powder',
      rating: 4.6,
      categoryId: 14,
      category: 'Spices & Herbs',
      isBestSeller: true,
      description: 'Pure turmeric powder with anti-inflammatory properties.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Turmeric_powder.jpg',
      reviewCount: 180,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "100g", price: 45),
        ProductVariant(unit: "250g", price: 100)
      ],
    ),
    HomeProductModel(
      id: 1402,
      name: 'Fresh Basil',
      rating: 4.7,
      categoryId: 14,
      category: 'Spices & Herbs',
      description: 'Fresh aromatic basil leaves for cooking.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/44/Basil-Basilico-Ocimum_basilicum-albahaca.jpg',
      reviewCount: 95,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "50g", price: 25),
        ProductVariant(unit: "100g", price: 45)
      ],
    ),
  ],

// 15. Cereals & Grains
  15: [
    HomeProductModel(
      id: 1501,
      name: 'Basmati Rice',
      rating: 4.5,
      categoryId: 15,
      category: 'Cereals & Grains',
      isFeatured: true,
      description: 'Premium long-grain basmati rice.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c7/Basmati_Rice_Grains.jpg',
      reviewCount: 450,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "1kg", price: 120),
        ProductVariant(unit: "5kg", price: 550)
      ],
    ),
    HomeProductModel(
      id: 1502,
      name: 'Rolled Oats',
      rating: 4.4,
      categoryId: 15,
      category: 'Cereals & Grains',
      description: 'Healthy rolled oats perfect for breakfast.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Oats.jpg',
      reviewCount: 280,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 85),
        ProductVariant(unit: "1kg", price: 160)
      ],
    ),
  ],

// 16. Health & Wellness
  16: [
    HomeProductModel(
      id: 1601,
      name: 'Vitamin C Tablets',
      rating: 4.6,
      categoryId: 16,
      category: 'Health & Wellness',
      description: 'Essential vitamin C supplements for immunity.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f4/Vitamin_pills.jpg',
      reviewCount: 320,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "30 tablets", price: 180),
        ProductVariant(unit: "60 tablets", price: 320)
      ],
    ),
    HomeProductModel(
      id: 1602,
      name: 'Protein Powder',
      rating: 4.7,
      categoryId: 16,
      category: 'Health & Wellness',
      isBestSeller: true,
      isRecommended: true,
      description: 'High-quality whey protein for fitness enthusiasts.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8c/Protein_powder.jpg',
      reviewCount: 280,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "500g", price: 850),
        ProductVariant(unit: "1kg", price: 1500)
      ],
    ),
  ],

// 17. Pet Care
  17: [
    HomeProductModel(
      id: 1701,
      name: 'Dog Food Premium',
      rating: 4.5,
      categoryId: 17,
      category: 'Pet Care',
      description: 'Nutritious premium dog food for healthy pets.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/f8/Dog_food.jpg',
      reviewCount: 150,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "1kg", price: 450),
        ProductVariant(unit: "3kg", price: 1200)
      ],
    ),
    HomeProductModel(
      id: 1702,
      name: 'Cat Litter',
      rating: 4.3,
      categoryId: 17,
      category: 'Pet Care',
      description: 'Odor-control cat litter for clean homes.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/2f/Cat_litter.jpg',
      reviewCount: 95,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "5kg", price: 280),
        ProductVariant(unit: "10kg", price: 520)
      ],
    ),
  ],

// 18. Beauty
  18: [
    HomeProductModel(
      id: 1801,
      name: 'Face Moisturizer',
      rating: 4.8,
      categoryId: 18,
      category: 'Beauty',
      isFeatured: true,
      description: 'Hydrating face moisturizer for all skin types.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Face_cream.jpg',
      reviewCount: 240,
      isAvailable: false,
      variants: [
        ProductVariant(unit: "50ml", price: 320),
        ProductVariant(unit: "100ml", price: 580)
      ],
    ),
    HomeProductModel(
      id: 1802,
      name: 'Lip Balm',
      rating: 4.6,
      categoryId: 18,
      category: 'Beauty',
      description: 'Nourishing lip balm with natural ingredients.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8f/Lip_balm.jpg',
      reviewCount: 180,
      isAvailable: true,
      variants: [
        ProductVariant(unit: "4g", price: 85),
        ProductVariant(unit: "8g", price: 150)
      ],
    ),
  ],

};


List<HomeProductModel> getProductsByCategory(int categoryId) => productsByCategory[categoryId]?.where((p) => p.isAvailable).toList() ?? [];
List<HomeProductModel> getAllProducts() => productsByCategory.values.expand((products) => products).where((p) => p.isAvailable).toList();
List<HomeProductModel> getFeaturedProducts() => getAllProducts().where((p) => p.isFeatured == true && p.isAvailable).toList();
List<HomeProductModel> getRecommendedProducts() => getAllProducts().where((p) => p.isRecommended == true && p.isAvailable).toList();
