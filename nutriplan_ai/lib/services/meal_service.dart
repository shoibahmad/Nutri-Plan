import '../models/meal.dart';

class MealService {
  static List<Meal> getSampleMeals() {
    return [
      // BREAKFAST
      Meal(
        id: 'b1',
        name: 'Avocado Toast with Eggs',
        description: 'Creamy avocado on whole grain toast with perfectly poached eggs',
        imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400',
        cuisine: 'American',
        mealType: MealType.breakfast,
        calories: 420,
        protein: 18,
        carbs: 35,
        fat: 24,
        preparationTime: 5,
        cookingTime: 10,
        ingredients: ['2 eggs', '1 avocado', '2 slices whole grain bread', 'Salt', 'Pepper', 'Red pepper flakes'],
        instructions: ['Toast the bread', 'Mash avocado with salt and pepper', 'Poach eggs', 'Assemble and serve'],
        dietaryTags: ['vegetarian', 'high-protein'],
        estimatedCost: 4.50,
        servings: 1,
      ),
      Meal(
        id: 'b2',
        name: 'Greek Yogurt Parfait',
        description: 'Layers of creamy Greek yogurt, fresh berries, and crunchy granola',
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
        cuisine: 'American',
        mealType: MealType.breakfast,
        calories: 350,
        protein: 20,
        carbs: 45,
        fat: 10,
        preparationTime: 5,
        cookingTime: 0,
        ingredients: ['200g Greek yogurt', '100g mixed berries', '50g granola', '1 tbsp honey'],
        instructions: ['Layer yogurt, berries, and granola', 'Drizzle with honey', 'Serve immediately'],
        dietaryTags: ['vegetarian', 'high-protein'],
        estimatedCost: 3.50,
        servings: 1,
      ),
      Meal(
        id: 'b3',
        name: 'Masala Omelette',
        description: 'Spiced Indian-style omelette with onions, tomatoes, and green chilies',
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
        cuisine: 'Indian',
        mealType: MealType.breakfast,
        calories: 280,
        protein: 16,
        carbs: 8,
        fat: 20,
        preparationTime: 5,
        cookingTime: 8,
        ingredients: ['3 eggs', '1/4 onion', '1/2 tomato', '1 green chili', 'Coriander', 'Salt', 'Turmeric'],
        instructions: ['Beat eggs with spices', 'Sauté vegetables', 'Pour eggs and cook until set', 'Fold and serve'],
        dietaryTags: ['vegetarian', 'keto', 'gluten-free'],
        estimatedCost: 2.50,
        servings: 1,
      ),
      
      // LUNCH
      Meal(
        id: 'l1',
        name: 'Grilled Chicken Salad',
        description: 'Fresh mixed greens with grilled chicken breast, cherry tomatoes, and balsamic dressing',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        cuisine: 'American',
        mealType: MealType.lunch,
        calories: 450,
        protein: 42,
        carbs: 15,
        fat: 25,
        preparationTime: 10,
        cookingTime: 15,
        ingredients: ['200g chicken breast', '150g mixed greens', 'Cherry tomatoes', 'Cucumber', 'Olive oil', 'Balsamic vinegar'],
        instructions: ['Season and grill chicken', 'Prepare salad base', 'Slice chicken and arrange', 'Drizzle dressing'],
        dietaryTags: ['high-protein', 'low-carb', 'gluten-free'],
        estimatedCost: 6.00,
        servings: 1,
      ),
      Meal(
        id: 'l2',
        name: 'Chickpea Buddha Bowl',
        description: 'Nourishing bowl with roasted chickpeas, quinoa, roasted vegetables, and tahini dressing',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        cuisine: 'Mediterranean',
        mealType: MealType.lunch,
        calories: 520,
        protein: 18,
        carbs: 65,
        fat: 22,
        preparationTime: 15,
        cookingTime: 25,
        ingredients: ['150g chickpeas', '100g quinoa', 'Sweet potato', 'Broccoli', 'Tahini', 'Lemon'],
        instructions: ['Cook quinoa', 'Roast chickpeas and vegetables', 'Prepare tahini dressing', 'Assemble bowl'],
        dietaryTags: ['vegan', 'vegetarian', 'high-fiber'],
        estimatedCost: 5.00,
        servings: 1,
      ),
      Meal(
        id: 'l3',
        name: 'Paneer Tikka Wrap',
        description: 'Spiced grilled paneer with mint chutney in a whole wheat wrap',
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        cuisine: 'Indian',
        mealType: MealType.lunch,
        calories: 480,
        protein: 24,
        carbs: 42,
        fat: 24,
        preparationTime: 15,
        cookingTime: 15,
        ingredients: ['200g paneer', 'Tikka masala', 'Whole wheat wrap', 'Onion', 'Capsicum', 'Mint chutney', 'Yogurt'],
        instructions: ['Marinate paneer', 'Grill until charred', 'Warm wrap', 'Assemble with vegetables and chutney'],
        dietaryTags: ['vegetarian', 'high-protein'],
        estimatedCost: 4.50,
        servings: 1,
      ),
      
      // DINNER
      Meal(
        id: 'd1',
        name: 'Salmon with Asparagus',
        description: 'Pan-seared salmon fillet with roasted asparagus and lemon butter sauce',
        imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
        cuisine: 'American',
        mealType: MealType.dinner,
        calories: 520,
        protein: 45,
        carbs: 12,
        fat: 32,
        preparationTime: 10,
        cookingTime: 20,
        ingredients: ['200g salmon fillet', '150g asparagus', 'Butter', 'Lemon', 'Garlic', 'Herbs'],
        instructions: ['Season salmon', 'Pan sear skin-side down', 'Roast asparagus', 'Make lemon butter sauce', 'Plate and serve'],
        dietaryTags: ['high-protein', 'keto', 'gluten-free'],
        estimatedCost: 12.00,
        servings: 1,
      ),
      Meal(
        id: 'd2',
        name: 'Chicken Stir Fry',
        description: 'Asian-inspired chicken and vegetable stir fry with ginger soy sauce',
        imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
        cuisine: 'Chinese',
        mealType: MealType.dinner,
        calories: 480,
        protein: 38,
        carbs: 35,
        fat: 18,
        preparationTime: 15,
        cookingTime: 12,
        ingredients: ['200g chicken breast', 'Bell peppers', 'Broccoli', 'Snow peas', 'Soy sauce', 'Ginger', 'Garlic', 'Rice'],
        instructions: ['Slice chicken and vegetables', 'Stir fry chicken', 'Add vegetables', 'Add sauce', 'Serve with rice'],
        dietaryTags: ['high-protein', 'dairy-free'],
        estimatedCost: 7.00,
        servings: 1,
      ),
      Meal(
        id: 'd3',
        name: 'Dal Tadka with Roti',
        description: 'Creamy yellow lentils with aromatic tempering, served with whole wheat roti',
        imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400',
        cuisine: 'Indian',
        mealType: MealType.dinner,
        calories: 420,
        protein: 18,
        carbs: 62,
        fat: 12,
        preparationTime: 10,
        cookingTime: 30,
        ingredients: ['150g yellow lentils', 'Cumin', 'Garlic', 'Dried red chilies', 'Ghee', 'Tomatoes', 'Whole wheat flour'],
        instructions: ['Cook dal until soft', 'Prepare tadka with ghee and spices', 'Pour over dal', 'Make rotis', 'Serve hot'],
        dietaryTags: ['vegetarian', 'vegan', 'high-fiber'],
        estimatedCost: 3.00,
        servings: 1,
      ),
      
      // SNACKS
      Meal(
        id: 's1',
        name: 'Protein Energy Balls',
        description: 'No-bake energy balls with oats, peanut butter, and dark chocolate',
        imageUrl: 'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=400',
        cuisine: 'American',
        mealType: MealType.snack,
        calories: 180,
        protein: 8,
        carbs: 20,
        fat: 9,
        preparationTime: 15,
        cookingTime: 0,
        ingredients: ['Oats', 'Peanut butter', 'Honey', 'Dark chocolate chips', 'Protein powder'],
        instructions: ['Mix all ingredients', 'Roll into balls', 'Refrigerate for 30 minutes', 'Enjoy!'],
        dietaryTags: ['vegetarian', 'high-protein'],
        estimatedCost: 2.00,
        servings: 4,
      ),
      Meal(
        id: 's2',
        name: 'Hummus with Veggies',
        description: 'Creamy homemade hummus with fresh vegetable sticks',
        imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767?w=400',
        cuisine: 'Mediterranean',
        mealType: MealType.snack,
        calories: 220,
        protein: 8,
        carbs: 24,
        fat: 12,
        preparationTime: 10,
        cookingTime: 0,
        ingredients: ['Chickpeas', 'Tahini', 'Lemon', 'Garlic', 'Olive oil', 'Carrots', 'Cucumber', 'Bell peppers'],
        instructions: ['Blend chickpeas with tahini, lemon, and garlic', 'Drizzle with olive oil', 'Cut vegetables into sticks', 'Serve together'],
        dietaryTags: ['vegan', 'vegetarian', 'gluten-free'],
        estimatedCost: 3.50,
        servings: 2,
      ),
      Meal(
        id: 's3',
        name: 'Masala Roasted Makhana',
        description: 'Crunchy fox nuts roasted with Indian spices - a healthy guilt-free snack',
        imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400',
        cuisine: 'Indian',
        mealType: MealType.snack,
        calories: 150,
        protein: 5,
        carbs: 18,
        fat: 7,
        preparationTime: 5,
        cookingTime: 10,
        ingredients: ['100g makhana (fox nuts)', 'Ghee', 'Salt', 'Black pepper', 'Chaat masala', 'Red chili powder'],
        instructions: ['Dry roast makhana', 'Add ghee and spices', 'Roast until crispy', 'Cool and serve'],
        dietaryTags: ['vegetarian', 'gluten-free', 'low-calorie'],
        estimatedCost: 2.00,
        servings: 2,
      ),
    ];
  }

  static List<Meal> getMealsByType(MealType type) {
    return getSampleMeals().where((meal) => meal.mealType == type).toList();
  }

  static List<Meal> getMealsByCuisine(String cuisine) {
    return getSampleMeals()
        .where((meal) => meal.cuisine.toLowerCase() == cuisine.toLowerCase())
        .toList();
  }

  static List<Meal> filterMeals({
    List<String>? cuisines,
    List<String>? dietaryTags,
    List<String>? excludeIngredients,
    int? maxPrepTime,
    double? maxCost,
  }) {
    return getSampleMeals().where((meal) {
      // Filter by cuisines
      if (cuisines != null &&
          cuisines.isNotEmpty &&
          !cuisines.contains(meal.cuisine)) {
        return false;
      }

      // Filter by dietary tags
      if (dietaryTags != null && dietaryTags.isNotEmpty) {
        bool hasTag = dietaryTags.any((tag) => meal.dietaryTags.contains(tag));
        if (!hasTag) return false;
      }

      // Exclude meals with specific ingredients
      if (excludeIngredients != null && excludeIngredients.isNotEmpty) {
        bool hasExcluded = excludeIngredients.any((ingredient) => meal
            .ingredients
            .any((i) => i.toLowerCase().contains(ingredient.toLowerCase())));
        if (hasExcluded) return false;
      }

      // Filter by max prep time
      if (maxPrepTime != null && meal.totalTime > maxPrepTime) {
        return false;
      }

      // Filter by max cost
      if (maxCost != null && meal.estimatedCost > maxCost) {
        return false;
      }

      return true;
    }).toList();
  }
}
