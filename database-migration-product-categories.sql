-- =====================================================
-- PRODUCT CATEGORIES MIGRATION
-- =====================================================
-- This migration adds product categories and proper units
-- for fruits, vegetables, shakes/juices, and mixed products

-- =====================================================
-- 1. ADD CATEGORY COLUMN TO FRUITS TABLE
-- =====================================================
ALTER TABLE public.fruits 
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'fruits' 
CHECK (category IN ('fruits', 'vegetables', 'shakes_juices', 'mixed'));

-- =====================================================
-- 2. UPDATE EXISTING FRUITS WITH PROPER UNITS AND CATEGORIES
-- =====================================================
UPDATE public.fruits SET 
    unit = 'kg',
    category = 'fruits'
WHERE name IN ('Apple', 'Banana', 'Orange', 'Mango', 'Grapes', 'Watermelon', 'Strawberry', 'Kiwi', 'Peach', 'Pear', 'Plum', 'Cherry', 'Blueberry', 'Raspberry', 'Blackberry', 'Cranberry', 'Apricot', 'Nectarine', 'Fig');

UPDATE public.fruits SET 
    unit = 'piece',
    category = 'fruits'
WHERE name IN ('Pineapple');

-- =====================================================
-- 3. INSERT VEGETABLES WITH PROPER UNITS
-- =====================================================
INSERT INTO public.fruits (name, base_price, max_price, unit, category) VALUES
-- Leafy Vegetables
('Spinach', 40.00, 80.00, 'bunch', 'vegetables'),
('Lettuce', 30.00, 60.00, 'head', 'vegetables'),
('Kale', 50.00, 100.00, 'bunch', 'vegetables'),
('Cabbage', 25.00, 45.00, 'piece', 'vegetables'),
('Cauliflower', 40.00, 80.00, 'piece', 'vegetables'),
('Broccoli', 60.00, 120.00, 'piece', 'vegetables'),

-- Root Vegetables
('Carrot', 30.00, 60.00, 'kg', 'vegetables'),
('Potato', 20.00, 40.00, 'kg', 'vegetables'),
('Onion', 25.00, 50.00, 'kg', 'vegetables'),
('Garlic', 80.00, 150.00, 'kg', 'vegetables'),
('Ginger', 100.00, 200.00, 'kg', 'vegetables'),
('Beetroot', 40.00, 80.00, 'kg', 'vegetables'),

-- Other Vegetables
('Tomato', 40.00, 80.00, 'kg', 'vegetables'),
('Cucumber', 30.00, 60.00, 'kg', 'vegetables'),
('Bell Pepper', 60.00, 120.00, 'kg', 'vegetables'),
('Eggplant', 50.00, 100.00, 'kg', 'vegetables'),
('Zucchini', 45.00, 90.00, 'kg', 'vegetables'),
('Mushroom', 120.00, 250.00, 'kg', 'vegetables'),
('Green Beans', 80.00, 150.00, 'kg', 'vegetables'),
('Peas', 100.00, 200.00, 'kg', 'vegetables'),
('Corn', 30.00, 60.00, 'piece', 'vegetables')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 4. INSERT SHAKES AND JUICES WITH PROPER UNITS
-- =====================================================
INSERT INTO public.fruits (name, base_price, max_price, unit, category) VALUES
-- Fresh Juices
('Orange Juice', 80.00, 150.00, 'glass', 'shakes_juices'),
('Apple Juice', 70.00, 130.00, 'glass', 'shakes_juices'),
('Grape Juice', 90.00, 160.00, 'glass', 'shakes_juices'),
('Pineapple Juice', 85.00, 155.00, 'glass', 'shakes_juices'),
('Mango Juice', 95.00, 170.00, 'glass', 'shakes_juices'),
('Mixed Fruit Juice', 100.00, 180.00, 'glass', 'shakes_juices'),

-- Milkshakes
('Strawberry Milkshake', 120.00, 200.00, 'glass', 'shakes_juices'),
('Chocolate Milkshake', 110.00, 190.00, 'glass', 'shakes_juices'),
('Vanilla Milkshake', 100.00, 180.00, 'glass', 'shakes_juices'),
('Mango Milkshake', 130.00, 220.00, 'glass', 'shakes_juices'),
('Banana Milkshake', 90.00, 160.00, 'glass', 'shakes_juices'),
('Oreo Milkshake', 140.00, 240.00, 'glass', 'shakes_juices'),

-- Smoothies
('Berry Smoothie', 150.00, 250.00, 'glass', 'shakes_juices'),
('Green Smoothie', 120.00, 200.00, 'glass', 'shakes_juices'),
('Tropical Smoothie', 130.00, 220.00, 'glass', 'shakes_juices'),
('Protein Smoothie', 180.00, 300.00, 'glass', 'shakes_juices')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 5. INSERT MIXED PRODUCTS (FRUITS + VEGETABLES)
-- =====================================================
INSERT INTO public.fruits (name, base_price, max_price, unit, category) VALUES
-- Mixed Fruit Baskets
('Mixed Fruit Basket Small', 200.00, 350.00, 'basket', 'mixed'),
('Mixed Fruit Basket Medium', 350.00, 550.00, 'basket', 'mixed'),
('Mixed Fruit Basket Large', 500.00, 800.00, 'basket', 'mixed'),

-- Fruit and Vegetable Combos
('Fruit & Veg Combo A', 180.00, 320.00, 'combo', 'mixed'),
('Fruit & Veg Combo B', 250.00, 420.00, 'combo', 'mixed'),
('Fruit & Veg Combo C', 320.00, 550.00, 'combo', 'mixed'),

-- Seasonal Mixes
('Summer Mix', 220.00, 380.00, 'pack', 'mixed'),
('Winter Mix', 200.00, 350.00, 'pack', 'mixed'),
('Spring Mix', 240.00, 400.00, 'pack', 'mixed'),
('Autumn Mix', 210.00, 370.00, 'pack', 'mixed')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 6. UPDATE EXISTING FRUITS WITH PROPER UNITS
-- =====================================================
UPDATE public.fruits SET 
    unit = 'dozen'
WHERE name = 'Banana';

UPDATE public.fruits SET 
    unit = 'pieces'
WHERE name IN ('Apple', 'Orange', 'Mango', 'Kiwi', 'Peach', 'Pear', 'Plum', 'Cherry', 'Apricot', 'Nectarine', 'Fig');

UPDATE public.fruits SET 
    unit = 'bunch'
WHERE name IN ('Grapes', 'Strawberry', 'Blueberry', 'Raspberry', 'Blackberry', 'Cranberry');

-- =====================================================
-- 7. CREATE INDEX FOR CATEGORY SEARCHES
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_fruits_category ON public.fruits(category);
CREATE INDEX IF NOT EXISTS idx_fruits_category_active ON public.fruits(category, is_active);

-- =====================================================
-- 8. VERIFICATION QUERIES
-- =====================================================
-- Check categories distribution
SELECT category, COUNT(*) as product_count 
FROM public.fruits 
GROUP BY category 
ORDER BY category;

-- Check units distribution
SELECT unit, COUNT(*) as product_count 
FROM public.fruits 
GROUP BY unit 
ORDER BY unit;

-- Check fruits with proper units
SELECT name, unit, category, base_price, max_price 
FROM public.fruits 
WHERE category = 'fruits' 
ORDER BY name;

-- Check vegetables with proper units
SELECT name, unit, category, base_price, max_price 
FROM public.fruits 
WHERE category = 'vegetables' 
ORDER BY name;

-- Check shakes and juices
SELECT name, unit, category, base_price, max_price 
FROM public.fruits 
WHERE category = 'shakes_juices' 
ORDER BY name;

-- Check mixed products
SELECT name, unit, category, base_price, max_price 
FROM public.fruits 
WHERE category = 'mixed' 
ORDER BY name;
