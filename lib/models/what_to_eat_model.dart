import 'package:flutter/material.dart';

enum WhatToEatScreenState {
  categories,
  customCategory,
  wheelOfFortune,
  foodSelected
}

class FoodItem {
  final String name;
  final String image;
  final String description;

  const FoodItem({
    required this.name,
    required this.image,
    required this.description,
  });
}

class FoodCategory {
  final String name;
  final WhatToEatScreenState nextState;
  final List<FoodItem> foodItems;

  const FoodCategory({
    required this.name,
    required this.nextState,
    required this.foodItems,
  });
}

class SelectedFood {
  final FoodItem foodItem;
  const SelectedFood({required this.foodItem});
}

class WhatToEatModel extends ChangeNotifier {
  final FoodItem _defaultCustomFoodItem = FoodItem(
    name: 'Create Your Own',
    image: '',
    description:
        'In this category, you have the freedom to create your own unique dishes. Add, modify, or delete items to suit your taste. Once your list is ready, spin the wheel and let fate decide your next meal! Get creative and explore your culinary imagination!',
  );
  FoodItem get defaultCustomFoodItem => _defaultCustomFoodItem;

  WhatToEatScreenState _whatToEatScreenState = WhatToEatScreenState.categories;
  WhatToEatScreenState get whatToEatScreenState => _whatToEatScreenState;

  FoodCategory? _selectedCategory;
  FoodCategory? get selectedCategory => _selectedCategory;

  SelectedFood? _selectedFood;
  SelectedFood? get selectedFood => _selectedFood;

  FoodCategory get customCategory =>
      foodCategories.firstWhere((category) => category.name == 'Custom');

  void setWhatToEatScreenState(WhatToEatScreenState newState) {
    _whatToEatScreenState = newState;
    notifyListeners();
  }

  void setSelectedCategory(FoodCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedFood(FoodItem foodItem) {
    _selectedFood = SelectedFood(foodItem: foodItem);
    notifyListeners();
  }

  void addFoodToCustomCategory(FoodItem foodItem) {
    customCategory.foodItems.add(foodItem);
    notifyListeners();
  }

  void clearCustomCategory() {
    customCategory.foodItems.clear();
    notifyListeners();
  }

  static List<FoodCategory> foodCategories = [
    FoodCategory(
        name: 'Popular Food Types',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Pasta',
            image: 'empty_plate.jpg',
            description:
                'Pasta is a traditional Italian dish made from wheat and water, available in many shapes and sizes. It is often served with sauces such as tomato, pesto, or creamy Alfredo.',
          ),
          FoodItem(
            name: 'Pizza',
            image: 'empty_plate.jpg',
            description:
                'A world-famous Italian dish, pizza consists of a thin crust topped with tomato sauce, cheese, and a variety of toppings like pepperoni, vegetables, and more.',
          ),
          FoodItem(
            name: 'Sushi',
            image: 'empty_plate.jpg',
            description:
                'Sushi is a Japanese dish made with vinegared rice, raw or cooked seafood, and vegetables. Popular varieties include nigiri, sashimi, and maki rolls.',
          ),
          FoodItem(
            name: 'Burgers',
            image: 'empty_plate.jpg',
            description:
                'A burger is a sandwich consisting of a cooked patty of ground meat (or plant-based alternatives), placed inside a sliced bun and often topped with lettuce, cheese, tomato, and sauces.',
          ),
          FoodItem(
            name: 'Tacos',
            image: 'empty_plate.jpg',
            description:
                'Tacos are a traditional Mexican dish made with soft or crispy tortillas filled with a variety of ingredients such as meat, beans, vegetables, and topped with salsa or guacamole.',
          ),
          FoodItem(
            name: 'Tortillas',
            image: 'empty_plate.jpg',
            description:
                'Tortillas are thin, round flatbreads made from wheat or corn, commonly used in Mexican cuisine for tacos, burritos, and wraps, serving as a versatile base for many fillings.',
          ),
          FoodItem(
            name: 'Salad',
            image: 'empty_plate.jpg',
            description:
                'Salad is a light, healthy dish composed of raw or cooked vegetables, often tossed with a dressing. Ingredients can include leafy greens, tomatoes, cucumbers, and various proteins.',
          ),
          FoodItem(
            name: 'BBQ',
            image: 'empty_plate.jpg',
            description:
                'BBQ refers to a cooking style involving grilling or smoking meat over an open flame or hot coals, typically flavored with rich marinades or smoky barbecue sauces.',
          ),
          FoodItem(
            name: 'Sandwiches',
            image: 'empty_plate.jpg',
            description:
                'Sandwiches consist of two slices of bread or a roll filled with meats, cheeses, vegetables, and condiments. They can be served cold, grilled, or toasted.',
          ),
          FoodItem(
            name: 'Soup',
            image: 'empty_plate.jpg',
            description:
                'Soup is a warm, comforting dish made by combining a variety of ingredients such as vegetables, meats, and grains in a broth. Popular types include chicken soup, minestrone, and chowder.',
          ),
          FoodItem(
            name: 'Steak',
            image: 'empty_plate.jpg',
            description:
                'Steak is a high-quality cut of beef, typically grilled or pan-seared, and served as a hearty main course. It can be seasoned with salt, pepper, and a variety of herbs.',
          ),
          FoodItem(
            name: 'Curry',
            image: 'empty_plate.jpg',
            description:
                'Curry is a flavorful dish originating from South Asia, made with a mixture of spices, meat or vegetables, and a rich sauce. It is commonly served with rice or bread.',
          ),
          FoodItem(
            name: 'Chinese',
            image: 'empty_plate.jpg',
            description:
                'Chinese cuisine offers a wide range of dishes, such as stir-fries, dumplings, and noodle soups, known for their bold flavors, soy-based sauces, and fresh ingredients.',
          ),
          FoodItem(
            name: 'Ramen',
            image: 'empty_plate.jpg',
            description:
                'Ramen is a Japanese noodle soup consisting of wheat noodles served in a meat or fish-based broth, often flavored with soy sauce or miso and topped with ingredients like pork, eggs, and seaweed.',
          ),
          FoodItem(
            name: 'Wings',
            image: 'empty_plate.jpg',
            description:
                'Chicken wings are a popular finger food, often deep-fried and tossed in a variety of sauces, such as buffalo, barbecue, or garlic parmesan, and served as appetizers or snacks.',
          ),
        ]),
    FoodCategory(
        name: 'Comfort Foods',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Mac and Cheese',
            image: 'empty_plate.jpg',
            description:
                'Mac and cheese is a creamy and comforting dish made with tender pasta, typically elbow macaroni, coated in a rich cheese sauce, and often baked to golden perfection.',
          ),
          FoodItem(
            name: 'Mashed Potatoes and Gravy',
            image: 'empty_plate.jpg',
            description:
                'Mashed potatoes are smooth, buttery potatoes often served with a savory gravy made from meat drippings, adding rich flavor to this comfort classic.',
          ),
          FoodItem(
            name: 'Meatloaf',
            image: 'empty_plate.jpg',
            description:
                'Meatloaf is a homestyle dish made from ground meat, typically beef, mixed with breadcrumbs and seasonings, shaped into a loaf and baked, often topped with a tomato glaze.',
          ),
          FoodItem(
            name: 'Chicken Pot Pie',
            image: 'empty_plate.jpg',
            description:
                'Chicken pot pie is a hearty dish featuring a flaky pastry crust filled with tender chicken, vegetables, and a creamy gravy, baked until golden and delicious.',
          ),
          FoodItem(
            name: 'Shepherd\'s Pie',
            image: 'empty_plate.jpg',
            description:
                'A British classic, shepherd\'s pie is a baked dish made with ground lamb or beef, vegetables, and a topping of mashed potatoes, often browned for a crispy finish.',
          ),
          FoodItem(
            name: 'Beef Stew',
            image: 'empty_plate.jpg',
            description:
                'Beef stew is a slow-cooked dish made with tender chunks of beef, root vegetables, and a savory broth. It\'s the perfect warming meal for a cold day.',
          ),
          FoodItem(
            name: 'Chicken and Dumplings',
            image: 'empty_plate.jpg',
            description:
                'Chicken and dumplings is a Southern favorite, featuring tender chicken in a flavorful broth with fluffy dumplings made from dough or biscuit mix.',
          ),
          FoodItem(
            name: 'Grilled Cheese Sandwich',
            image: 'empty_plate.jpg',
            description:
                'A classic comfort food, grilled cheese sandwiches are made with melted cheese between slices of buttered bread, grilled until crispy and golden brown.',
          ),
          FoodItem(
            name: 'Tomato Soup',
            image: 'empty_plate.jpg',
            description:
                'Tomato soup is a smooth and tangy soup made from ripe tomatoes, often seasoned with herbs and served as a comforting starter or paired with a grilled cheese sandwich.',
          ),
          FoodItem(
            name: 'Sloppy Joes',
            image: 'empty_plate.jpg',
            description:
                'Sloppy Joes are sandwiches made with ground beef cooked in a tangy tomato-based sauce and served on a soft hamburger bun, making for a messy yet delicious meal.',
          ),
          FoodItem(
            name: 'Baked Ziti',
            image: 'empty_plate.jpg',
            description:
                'Baked ziti is an Italian-American pasta dish made with ziti pasta, marinara sauce, and melted cheese, often layered and baked for a gooey, delicious finish.',
          ),
          FoodItem(
            name: 'Tuna Casserole',
            image: 'empty_plate.jpg',
            description:
                'Tuna casserole is a hearty dish made with canned tuna, pasta, and a creamy sauce, often topped with breadcrumbs and baked until bubbly and golden.',
          ),
          FoodItem(
            name: 'Fettuccine Alfredo',
            image: 'empty_plate.jpg',
            description:
                'Fettuccine Alfredo is a rich Italian pasta dish made with fettuccine noodles tossed in a creamy sauce of butter, heavy cream, and Parmesan cheese.',
          ),
        ]),
    FoodCategory(
        name: 'Light and Healthy',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Grilled Salmon with Asparagus',
            image: 'empty_plate.jpg',
            description:
                'Grilled salmon is a light, healthy protein packed with omega-3 fatty acids. It is often paired with asparagus, which is grilled or roasted for a nutritious meal.',
          ),
          FoodItem(
            name: 'Quinoa and Black Bean Salad',
            image: 'empty_plate.jpg',
            description:
                'A filling and nutritious salad featuring quinoa, a protein-rich grain, mixed with black beans, vegetables, and a light vinaigrette, offering a balanced meal packed with fiber and protein.',
          ),
          FoodItem(
            name: 'Zucchini Noodles with Marinara',
            image: 'empty_plate.jpg',
            description:
                'Zucchini noodles, or "zoodles," are a low-carb pasta alternative made from spiralized zucchini. They are often served with marinara sauce for a healthy, gluten-free meal.',
          ),
          FoodItem(
            name: 'Turkey Lettuce Wraps',
            image: 'empty_plate.jpg',
            description:
                'Ground turkey is sautéed with seasonings and served in crispy lettuce leaves, making a low-carb, high-protein alternative to traditional wraps or tacos.',
          ),
          FoodItem(
            name: 'Grilled Chicken Caesar Salad',
            image: 'empty_plate.jpg',
            description:
                'Grilled chicken Caesar salad is a fresh and healthy dish featuring romaine lettuce, grilled chicken breast, Parmesan cheese, and a light Caesar dressing.',
          ),
          FoodItem(
            name: 'Greek Yogurt Parfait',
            image: 'empty_plate.jpg',
            description:
                'Greek yogurt parfait is a healthy snack or breakfast option made with layers of creamy Greek yogurt, fresh fruits, and crunchy granola, offering a good mix of protein and fiber.',
          ),
          FoodItem(
            name: 'Spinach and Feta Stuffed Chicken Breast',
            image: 'empty_plate.jpg',
            description:
                'Chicken breast is stuffed with a flavorful mixture of spinach and feta cheese, then baked or grilled to create a lean, nutritious, and protein-rich meal.',
          ),
          FoodItem(
            name: 'Avocado and Chickpea Salad',
            image: 'empty_plate.jpg',
            description:
                'Avocado and chickpea salad is a nutrient-dense dish that combines creamy avocado with protein-packed chickpeas, tossed with lemon juice, olive oil, and fresh herbs.',
          ),
          FoodItem(
            name: 'Cauliflower Rice Stir Fry',
            image: 'empty_plate.jpg',
            description:
                'Cauliflower rice is a low-carb substitute for regular rice, often stir-fried with vegetables and lean proteins like chicken or shrimp for a light, healthy meal.',
          ),
          FoodItem(
            name: 'Broiled Cod with Lemon',
            image: 'empty_plate.jpg',
            description:
                'Broiled cod is a light, flaky fish often seasoned with lemon juice, garlic, and herbs. It makes for a healthy, low-calorie main course that is rich in protein.',
          ),
          FoodItem(
            name: 'Roasted Brussels Sprouts and Sweet Potatoes',
            image: 'empty_plate.jpg',
            description:
                'This dish combines roasted Brussels sprouts and sweet potatoes for a hearty, healthy side that is rich in vitamins, minerals, and fiber, with a natural sweetness.',
          ),
          FoodItem(
            name: 'Chia Seed Pudding',
            image: 'empty_plate.jpg',
            description:
                'Chia seed pudding is a healthy dessert or snack made by soaking chia seeds in milk, creating a thick, creamy texture, often flavored with vanilla and fruits.',
          ),
          FoodItem(
            name: 'Kale Smoothie',
            image: 'empty_plate.jpg',
            description:
                'Kale smoothies are a nutrient-dense drink made with kale, fruits like bananas or berries, and liquids like almond milk or juice, offering a high dose of vitamins and antioxidants.',
          ),
          FoodItem(
            name: 'Soba Noodle Salad',
            image: 'empty_plate.jpg',
            description:
                'Soba noodle salad is a light and refreshing dish made with buckwheat soba noodles, vegetables, and a tangy dressing, often served cold for a healthy meal.',
          ),
        ]),
    FoodCategory(
        name: 'Grilling and BBQ',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'BBQ Ribs',
            image: 'empty_plate.jpg',
            description:
                'BBQ ribs are a popular dish where pork or beef ribs are slow-cooked or smoked until tender, then basted with barbecue sauce and grilled to perfection.',
          ),
          FoodItem(
            name: 'Grilled Steak',
            image: 'empty_plate.jpg',
            description:
                'Grilled steak is a juicy cut of beef, often seasoned simply with salt and pepper, then cooked on a grill to achieve a smoky, charred flavor with a tender interior.',
          ),
          FoodItem(
            name: 'Pulled Pork Sandwiches',
            image: 'empty_plate.jpg',
            description:
                'Pulled pork sandwiches consist of slow-cooked pork that is shredded and served on a bun, often with BBQ sauce and coleslaw, making for a delicious, hearty meal.',
          ),
          FoodItem(
            name: 'Grilled Corn on the Cob',
            image: 'empty_plate.jpg',
            description:
                'Grilled corn on the cob is a summer favorite where fresh corn is charred on the grill and served with butter, salt, and sometimes spices or cheese.',
          ),
          FoodItem(
            name: 'BBQ Chicken Wings',
            image: 'empty_plate.jpg',
            description:
                'BBQ chicken wings are marinated in a barbecue sauce, then grilled or baked until crispy on the outside and tender on the inside, making a popular party dish.',
          ),
          FoodItem(
            name: 'Bratwurst',
            image: 'empty_plate.jpg',
            description:
                'Bratwurst is a type of German sausage made from pork, beef, or veal, often grilled and served in a bun with mustard and sauerkraut.',
          ),
          FoodItem(
            name: 'Grilled Salmon',
            image: 'empty_plate.jpg',
            description:
                'Grilled salmon is a healthy, flavorful dish made by cooking fresh salmon fillets over a grill, often seasoned with herbs, lemon, and olive oil.',
          ),
          FoodItem(
            name: 'Grilled Shrimp Skewers',
            image: 'empty_plate.jpg',
            description:
                'Grilled shrimp skewers are a quick, tasty dish where shrimp are marinated and skewered, then grilled until lightly charred and juicy, often served as appetizers or mains.',
          ),
          FoodItem(
            name: 'Grilled Portobello Mushrooms',
            image: 'empty_plate.jpg',
            description:
                'Grilled portobello mushrooms are a hearty, plant-based option that is marinated and grilled, offering a meaty texture and rich flavor.',
          ),
          FoodItem(
            name: 'BBQ Brisket',
            image: 'empty_plate.jpg',
            description:
                'BBQ brisket is a tender, smoked cut of beef that is slow-cooked over a low flame for several hours, resulting in a flavorful and juicy meat dish.',
          ),
          FoodItem(
            name: 'Smoky BBQ Beans',
            image: 'empty_plate.jpg',
            description:
                'Smoky BBQ beans are a savory side dish made with slow-cooked beans in a rich, smoky barbecue sauce, often served with grilled meats.',
          ),
          FoodItem(
            name: 'Grilled Pineapple',
            image: 'empty_plate.jpg',
            description:
                'Grilled pineapple is a tropical treat where pineapple slices are caramelized on the grill, intensifying their natural sweetness and adding a smoky flavor.',
          ),
          FoodItem(
            name: 'BBQ Pork Chops',
            image: 'empty_plate.jpg',
            description:
                'BBQ pork chops are marinated in a barbecue sauce and grilled until juicy and flavorful, making a delicious main course often served with grilled vegetables or potatoes.',
          ),
          FoodItem(
            name: 'BBQ Baked Potatoes',
            image: 'empty_plate.jpg',
            description:
                'BBQ baked potatoes are large, fluffy potatoes wrapped in foil and cooked on the grill, often topped with sour cream, cheese, and bacon.',
          ),
        ]),
    FoodCategory(
        name: 'Pasta Varieties',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Spaghetti Bolognese',
            image: 'empty_plate.jpg',
            description:
                'Spaghetti Bolognese is a classic Italian dish made with tender spaghetti noodles topped with a rich, slow-cooked meat sauce, typically featuring ground beef, tomatoes, and herbs.',
          ),
          FoodItem(
            name: 'Fettuccine Alfredo',
            image: 'empty_plate.jpg',
            description:
                'Fettuccine Alfredo is a creamy Italian pasta dish made by tossing fettuccine noodles in a rich sauce of butter, cream, and Parmesan cheese.',
          ),
          FoodItem(
            name: 'Penne Arrabbiata',
            image: 'empty_plate.jpg',
            description:
                'Penne Arrabbiata is a spicy Italian pasta dish made with penne pasta and a fiery tomato sauce, spiced with red pepper flakes and garlic.',
          ),
          FoodItem(
            name: 'Carbonara',
            image: 'empty_plate.jpg',
            description:
                'Carbonara is a classic Roman pasta dish made with spaghetti or another long pasta, tossed with eggs, cheese, pancetta, and black pepper to create a creamy sauce.',
          ),
          FoodItem(
            name: 'Lasagna',
            image: 'empty_plate.jpg',
            description:
                'Lasagna is a layered pasta dish made with wide, flat pasta sheets, alternating layers of meat, tomato sauce, cheese, and sometimes vegetables, baked until bubbly and golden.',
          ),
          FoodItem(
            name: 'Ravioli',
            image: 'empty_plate.jpg',
            description:
                'Ravioli are pasta pockets filled with ingredients like cheese, meat, or vegetables, often served with a sauce such as marinara or butter and sage.',
          ),
          FoodItem(
            name: 'Pesto Pasta',
            image: 'empty_plate.jpg',
            description:
                'Pesto pasta is an Italian dish made with pasta tossed in a sauce made from fresh basil, pine nuts, Parmesan cheese, and olive oil.',
          ),
          FoodItem(
            name: 'Mac and Cheese',
            image: 'empty_plate.jpg',
            description:
                'Mac and cheese is a beloved comfort dish made from cooked macaroni pasta mixed with a creamy cheese sauce, often baked until golden.',
          ),
          FoodItem(
            name: 'Gnocchi',
            image: 'empty_plate.jpg',
            description:
                'Gnocchi are soft, pillowy dumplings made from potatoes, flour, and sometimes eggs, often served with a simple sauce like tomato or butter and sage.',
          ),
          FoodItem(
            name: 'Tortellini',
            image: 'empty_plate.jpg',
            description:
                'Tortellini are small, ring-shaped pasta filled with a variety of ingredients like cheese, meat, or spinach, typically served in broth or with a rich sauce.',
          ),
          FoodItem(
            name: 'Ziti with Marinara',
            image: 'empty_plate.jpg',
            description:
                'Ziti with marinara is a simple Italian pasta dish where ziti noodles are tossed in a fresh, tangy tomato sauce made from ripe tomatoes, garlic, and herbs.',
          ),
          FoodItem(
            name: 'Cacio e Pepe',
            image: 'empty_plate.jpg',
            description:
                'Cacio e Pepe is a simple Roman pasta dish made from only three ingredients: pasta, Pecorino Romano cheese, and black pepper, creating a creamy, cheesy sauce.',
          ),
        ]),
    FoodCategory(
        name: 'Breakfast & Brunch',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Pancakes',
            image: 'empty_plate.jpg',
            description:
                'Pancakes are a fluffy breakfast favorite made from a batter of flour, eggs, and milk, often served with butter, syrup, and a variety of toppings such as fruits or whipped cream.',
          ),
          FoodItem(
            name: 'French Toast',
            image: 'empty_plate.jpg',
            description:
                'French toast is a classic breakfast dish where slices of bread are dipped in a mixture of eggs, milk, and cinnamon, then fried until golden and served with syrup or fruit.',
          ),
          FoodItem(
            name: 'Scrambled Eggs and Bacon',
            image: 'empty_plate.jpg',
            description:
                'Scrambled eggs and bacon is a simple yet hearty breakfast, featuring fluffy eggs cooked in a pan and served with crispy, salty bacon strips.',
          ),
          FoodItem(
            name: 'Eggs Benedict',
            image: 'empty_plate.jpg',
            description:
                'Eggs Benedict is a brunch favorite consisting of poached eggs and Canadian bacon served on an English muffin, topped with creamy hollandaise sauce.',
          ),
          FoodItem(
            name: 'Smoothie Bowl',
            image: 'empty_plate.jpg',
            description:
                'A smoothie bowl is a thick smoothie served in a bowl and topped with fruits, nuts, seeds, and granola, offering a nutritious and refreshing breakfast option.',
          ),
          FoodItem(
            name: 'Avocado Toast',
            image: 'empty_plate.jpg',
            description:
                'Avocado toast is a trendy breakfast made by spreading mashed avocado on toasted bread, often topped with salt, pepper, and other seasonings or toppings like eggs.',
          ),
          FoodItem(
            name: 'Omelette',
            image: 'empty_plate.jpg',
            description:
                'An omelette is made by beating eggs and cooking them in a pan until set, then folding over fillings like cheese, vegetables, ham, or mushrooms.',
          ),
          FoodItem(
            name: 'Breakfast Burrito',
            image: 'empty_plate.jpg',
            description:
                'A breakfast burrito is a flour tortilla filled with scrambled eggs, cheese, sausage, and sometimes beans or vegetables, making a portable and satisfying breakfast.',
          ),
          FoodItem(
            name: 'Belgian Waffles',
            image: 'empty_plate.jpg',
            description:
                'Belgian waffles are thick, fluffy waffles with deep pockets, perfect for holding syrup, whipped cream, or fresh fruit as a sweet breakfast or brunch dish.',
          ),
          FoodItem(
            name: 'Granola and Yogurt',
            image: 'empty_plate.jpg',
            description:
                'Granola and yogurt is a healthy breakfast or snack made with creamy yogurt topped with crunchy granola and fresh fruits, offering a balance of protein and fiber.',
          ),
          FoodItem(
            name: 'Frittata',
            image: 'empty_plate.jpg',
            description:
                'A frittata is an Italian-style omelet, typically made with eggs, cheese, and vegetables or meats, cooked slowly and finished in the oven for a thick, hearty breakfast dish.',
          ),
          FoodItem(
            name: 'Bagels with Cream Cheese',
            image: 'empty_plate.jpg',
            description:
                'Bagels with cream cheese is a simple and satisfying breakfast made by toasting a bagel and spreading it with smooth, tangy cream cheese. Often paired with smoked salmon or other toppings.',
          ),
          FoodItem(
            name: 'Shakshuka',
            image: 'empty_plate.jpg',
            description:
                'Shakshuka is a Middle Eastern breakfast dish made with poached eggs cooked in a flavorful, spiced tomato and pepper sauce. It’s usually served with warm bread for dipping and is rich in flavor.',
          ),
          FoodItem(
            name: 'Chia Pudding',
            image: 'empty_plate.jpg',
            description:
                'Chia pudding is a nutritious breakfast or snack made by soaking chia seeds in milk or a milk alternative until they form a thick, pudding-like consistency. It’s often topped with fresh fruit and nuts.',
          ),
          FoodItem(
            name: 'Overnight Oats',
            image: 'empty_plate.jpg',
            description:
                'Overnight oats are a convenient and healthy breakfast option where rolled oats are soaked overnight in milk or yogurt. In the morning, they’re ready to be enjoyed with toppings like fruits, nuts, or honey.',
          ),
        ]),
    FoodCategory(
        name: 'Desserts',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Tiramisu',
            image: 'empty_plate.jpg',
            description:
                'Tiramisu is a classic Italian dessert made from layers of coffee-soaked ladyfingers and mascarpone cheese, topped with cocoa powder. It’s a rich and creamy treat with a coffee flavor.',
          ),
          FoodItem(
            name: 'Chocolate Cake',
            image: 'empty_plate.jpg',
            description:
                'Chocolate cake is a beloved dessert made with rich, moist chocolate layers, often topped with a chocolate frosting or ganache for an extra indulgent experience.',
          ),
          FoodItem(
            name: 'Mochi Ice Cream',
            image: 'empty_plate.jpg',
            description:
                'Mochi ice cream is a Japanese-inspired dessert where soft, chewy mochi (sweet rice dough) encases a core of creamy ice cream, available in various flavors like matcha, vanilla, and chocolate.',
          ),
          FoodItem(
            name: 'Cheesecake',
            image: 'empty_plate.jpg',
            description:
                'Cheesecake is a smooth, creamy dessert made with a sweetened cream cheese filling over a graham cracker or cookie crust. It can be topped with fruits, chocolate, or caramel.',
          ),
          FoodItem(
            name: 'Apple Pie',
            image: 'empty_plate.jpg',
            description:
                'Apple pie is a classic dessert featuring a flaky pastry crust filled with spiced, sweet apples. Often served warm with a scoop of ice cream, it’s a timeless favorite.',
          ),
          FoodItem(
            name: 'Brownies',
            image: 'empty_plate.jpg',
            description:
                'Brownies are a rich, chocolatey dessert with a dense, fudgy texture. They can be served plain or with add-ins like nuts, chocolate chips, or a dusting of powdered sugar.',
          ),
          FoodItem(
            name: 'Lemon Bars',
            image: 'empty_plate.jpg',
            description:
                'Lemon bars are a zesty, tangy dessert made with a creamy lemon curd layer over a buttery shortbread crust. They offer a bright, citrusy flavor in each bite.',
          ),
          FoodItem(
            name: 'Panna Cotta',
            image: 'empty_plate.jpg',
            description:
                'Panna cotta is a smooth, creamy Italian dessert made from sweetened cream thickened with gelatin, often flavored with vanilla and served with a fruity or caramel topping.',
          ),
          FoodItem(
            name: 'Baklava',
            image: 'empty_plate.jpg',
            description:
                'Baklava is a Middle Eastern dessert made from layers of crispy phyllo dough filled with chopped nuts and sweetened with honey or syrup. It’s a sticky, sweet treat with a rich flavor.',
          ),
          FoodItem(
            name: 'Creme Brulee',
            image: 'empty_plate.jpg',
            description:
                'Creme brulee is a French dessert consisting of a rich vanilla custard base topped with a thin, crunchy layer of caramelized sugar. The contrast between the creamy custard and brittle topping is delightful.',
          ),
          FoodItem(
            name: 'Churros',
            image: 'empty_plate.jpg',
            description:
                'Churros are a popular fried dough pastry often dusted with cinnamon and sugar. They are usually served with chocolate or caramel sauce for dipping and are a favorite street food in many countries.',
          ),
          FoodItem(
            name: 'Eclairs',
            image: 'empty_plate.jpg',
            description:
                'Eclairs are a French pastry made from choux dough, filled with cream or custard, and topped with a chocolate glaze. They are light, airy, and decadent.',
          ),
          FoodItem(
            name: 'Fruit Tart',
            image: 'empty_plate.jpg',
            description:
                'Fruit tarts are a refreshing dessert made with a buttery crust, filled with creamy custard or pastry cream, and topped with fresh fruits like berries, kiwi, and peaches.',
          ),
          FoodItem(
            name: 'Banoffee Pie',
            image: 'empty_plate.jpg',
            description:
                'Banoffee pie is an English dessert made with a biscuit base, layers of sliced bananas, thick caramel, and whipped cream, often dusted with cocoa or chocolate shavings.',
          ),
          FoodItem(
            name: 'Pavlova',
            image: 'empty_plate.jpg',
            description:
                'Pavlova is a meringue-based dessert with a crisp outer shell and a soft, marshmallow-like center, typically topped with whipped cream and fresh fruit like strawberries or kiwis.',
          ),
        ]),
    FoodCategory(
        name: 'National Cuisines',
        nextState: WhatToEatScreenState.wheelOfFortune,
        foodItems: [
          FoodItem(
            name: 'Mexico',
            image: 'empty_plate.jpg',
            description:
                'Mexican cuisine is known for its bold flavors, use of spices, and iconic dishes like tacos, enchiladas, and tamales. It’s a vibrant mix of indigenous and Spanish influences.',
          ),
          FoodItem(
            name: 'Italy',
            image: 'empty_plate.jpg',
            description:
                'Italian cuisine is celebrated for its regional diversity, focusing on fresh ingredients like tomatoes, olive oil, pasta, and cheese. Iconic dishes include pizza, pasta, and risotto.',
          ),
          FoodItem(
            name: 'Japan',
            image: 'empty_plate.jpg',
            description:
                'Japanese cuisine emphasizes seasonal ingredients, precision, and balance. Sushi, ramen, and tempura are among the well-known dishes that showcase Japan’s culinary finesse.',
          ),
          FoodItem(
            name: 'India',
            image: 'empty_plate.jpg',
            description:
                'Indian cuisine is rich in spices and diverse in flavors, with dishes ranging from mild to fiery. Curries, biryani, and tandoori are among the many beloved dishes across India’s regions.',
          ),
          FoodItem(
            name: 'China',
            image: 'empty_plate.jpg',
            description:
                'Chinese cuisine offers a wide variety of flavors, from savory stir-fries to spicy Szechuan dishes. Noodles, dumplings, and sweet and sour dishes are hallmarks of this cuisine.',
          ),
          FoodItem(
            name: 'France',
            image: 'empty_plate.jpg',
            description:
                'French cuisine is renowned for its sophistication and rich flavors, with an emphasis on technique. Croissants, coq au vin, and creme brulee are just a few examples of this refined tradition.',
          ),
          FoodItem(
            name: 'Thailand',
            image: 'empty_plate.jpg',
            description:
                'Thai cuisine is known for its bold balance of sweet, sour, salty, and spicy flavors. Dishes like pad Thai, green curry, and tom yum soup are loved worldwide for their complexity.',
          ),
          FoodItem(
            name: 'Greece',
            image: 'empty_plate.jpg',
            description:
                'Greek cuisine is Mediterranean at its best, featuring fresh ingredients like olive oil, herbs, lamb, and fish. Popular dishes include moussaka, tzatziki, and Greek salad.',
          ),
          FoodItem(
            name: 'Lebanon',
            image: 'empty_plate.jpg',
            description:
                'Lebanese cuisine is known for its mezze—small dishes like hummus, tabbouleh, and falafel—as well as flavorful grilled meats and rich desserts like baklava.',
          ),
          FoodItem(
            name: 'Spain',
            image: 'empty_plate.jpg',
            description:
                'Spanish cuisine highlights regional diversity, from seafood-rich paella to small tapas plates. Olive oil, garlic, and saffron are staples in many Spanish dishes.',
          ),
          FoodItem(
            name: 'Korea',
            image: 'empty_plate.jpg',
            description:
                'Korean cuisine is centered around fermented foods, rice, and vegetables, with famous dishes like kimchi, bibimbap, and Korean barbecue showcasing bold flavors and vibrant colors.',
          ),
          FoodItem(
            name: 'Vietnam',
            image: 'empty_plate.jpg',
            description:
                'Vietnamese cuisine is fresh and aromatic, with dishes like pho, banh mi, and fresh spring rolls exemplifying the use of herbs, rice noodles, and savory broths.',
          ),
          FoodItem(
            name: 'Germany',
            image: 'empty_plate.jpg',
            description:
                'German cuisine is known for hearty dishes like sausages, schnitzel, and pretzels. Potatoes, cabbage, and meats are staples, often served with mustard and beer.',
          ),
          FoodItem(
            name: 'Morocco',
            image: 'empty_plate.jpg',
            description:
                'Moroccan cuisine blends Arabic, Berber, and Mediterranean influences, with fragrant spices and slow-cooked dishes like tagine and couscous being central to the cuisine.',
          ),
          FoodItem(
            name: 'Turkey',
            image: 'empty_plate.jpg',
            description:
                'Turkish cuisine bridges European and Middle Eastern flavors, with kebabs, baklava, and rich yogurt-based sauces being highlights of this diverse culinary tradition.',
          ),
          FoodItem(
            name: 'Brazil',
            image: 'empty_plate.jpg',
            description:
                'Brazilian cuisine is vibrant and varied, known for dishes like feijoada (a black bean stew) and churrasco (grilled meats). It reflects the country’s blend of indigenous, African, and Portuguese influences.',
          ),
        ]),
    FoodCategory(
        name: 'Custom',
        nextState: WhatToEatScreenState.customCategory,
        foodItems: []),
  ];
}
