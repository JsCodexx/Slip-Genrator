-- =====================================================
-- CURRENCY CONVERSION SYSTEM MIGRATION
-- =====================================================
-- This migration adds currency conversion rates and updates
-- slip formats with proper currency information

-- =====================================================
-- 1. ADD CURRENCY CONVERSION RATES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.currency_rates (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    from_currency TEXT NOT NULL,
    to_currency TEXT NOT NULL,
    conversion_rate DECIMAL(10,6) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT currency_rates_pkey PRIMARY KEY (id),
    CONSTRAINT currency_rates_unique UNIQUE(from_currency, to_currency),
    CONSTRAINT currency_rates_rate_check CHECK (conversion_rate > 0)
);

-- =====================================================
-- 2. INSERT CURRENCY CONVERSION RATES
-- =====================================================
-- Base currency: Indian Rupees (Rs)
-- All rates are relative to Rs (1 Rs = X other_currency)

INSERT INTO public.currency_rates (from_currency, to_currency, conversion_rate) VALUES
-- Indian Rupees to other currencies (1 Rs = X other_currency)
('Rs', 'Rs', 1.000000),           -- Same currency
('Rs', '$', 0.012000),            -- 1 Rs = $0.012 (approximately)
('Rs', '€', 0.011000),            -- 1 Rs = €0.011 (approximately)
('Rs', '£', 0.009500),            -- 1 Rs = £0.0095 (approximately)
('Rs', '₹', 1.000000),            -- 1 Rs = ₹1 (same as Rs)
('Rs', '¥', 1.800000),            -- 1 Rs = ¥1.8 (approximately)
('Rs', '₽', 1.200000),            -- 1 Rs = ₽1.2 (approximately)
('Rs', 'AED', 0.044000),          -- 1 Rs = AED 0.044 (approximately)
('Rs', 'SAR', 0.045000),          -- 1 Rs = SAR 0.045 (approximately)

-- Reverse conversions (other_currency to Rs)
('$', 'Rs', 83.333333),           -- 1 $ = Rs 83.33
('€', 'Rs', 90.909091),           -- 1 € = Rs 90.91
('£', 'Rs', 105.263158),          -- 1 £ = Rs 105.26
('₹', 'Rs', 1.000000),            -- 1 ₹ = Rs 1
('¥', 'Rs', 0.555556),            -- 1 ¥ = Rs 0.56
('₽', 'Rs', 0.833333),            -- 1 ₽ = Rs 0.83
('AED', 'Rs', 22.727273),         -- 1 AED = Rs 22.73 (approximately)
('SAR', 'Rs', 22.222222)          -- 1 SAR = Rs 22.22 (approximately)
ON CONFLICT (from_currency, to_currency) DO UPDATE SET
    conversion_rate = EXCLUDED.conversion_rate,
    updated_at = NOW();

-- =====================================================
-- 3. UPDATE SLIP FORMATS WITH CURRENCY INFO
-- =====================================================
-- First, ensure the currency_symbol column exists
ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS currency_symbol TEXT DEFAULT 'Rs';

-- Update existing slip formats with proper currency symbols
UPDATE public.slip_formats SET 
    currency_symbol = 'Rs'
WHERE currency_symbol IS NULL OR currency_symbol = '';

-- =====================================================
-- 4. CREATE CURRENCY CONVERSION FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION convert_currency(
    amount DECIMAL,
    from_currency_param TEXT,
    to_currency_param TEXT
) RETURNS DECIMAL AS $$
DECLARE
    rate DECIMAL;
BEGIN
    -- If same currency, return same amount
    IF from_currency_param = to_currency_param THEN
        RETURN amount;
    END IF;
    
    -- Get conversion rate
    SELECT conversion_rate INTO rate
    FROM public.currency_rates
    WHERE from_currency = from_currency_param AND to_currency = to_currency_param AND is_active = TRUE;
    
    -- If rate not found, return original amount
    IF rate IS NULL THEN
        RETURN amount;
    END IF;
    
    -- Convert and round to 2 decimal places
    RETURN ROUND(amount * rate, 2);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 5. CREATE FUNCTION TO GET CONVERTED PRICE RANGES
-- =====================================================
CREATE OR REPLACE FUNCTION get_converted_price_range(
    base_price DECIMAL,
    max_price DECIMAL,
    target_currency TEXT
) RETURNS TABLE(
    converted_base_price DECIMAL,
    converted_max_price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        convert_currency(base_price, 'Rs', target_currency) as converted_base_price,
        convert_currency(max_price, 'Rs', target_currency) as converted_max_price;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 6. CREATE INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_currency_rates_from_currency ON public.currency_rates(from_currency);
CREATE INDEX IF NOT EXISTS idx_currency_rates_to_currency ON public.currency_rates(to_currency);
CREATE INDEX IF NOT EXISTS idx_currency_rates_active ON public.currency_rates(is_active);

-- =====================================================
-- 7. VERIFICATION QUERIES
-- =====================================================
-- Check currency rates
SELECT 
    from_currency, 
    to_currency, 
    conversion_rate,
    CASE 
        WHEN from_currency = 'Rs' THEN '1 Rs = ' || conversion_rate || ' ' || to_currency
        ELSE '1 ' || from_currency || ' = ' || conversion_rate || ' Rs'
    END as conversion_description
FROM public.currency_rates 
ORDER BY from_currency, to_currency;

-- Test conversion function
SELECT 
    '100 Rs to $' as test,
    convert_currency(100, 'Rs', '$') as result
UNION ALL
SELECT 
    '100 Rs to €' as test,
    convert_currency(100, 'Rs', '€') as result
UNION ALL
SELECT 
    '100 Rs to £' as test,
    convert_currency(100, 'Rs', '£') as result
UNION ALL
SELECT 
    '100 Rs to AED' as test,
    convert_currency(100, 'Rs', 'AED') as result
UNION ALL
SELECT 
    '100 Rs to SAR' as test,
    convert_currency(100, 'Rs', 'SAR') as result;

-- Test price range conversion
SELECT 
    'Apple prices in different currencies' as product,
    base_price as base_rs,
    max_price as max_rs,
    convert_currency(base_price, 'Rs', '$') as base_usd,
    convert_currency(max_price, 'Rs', '$') as max_usd,
    convert_currency(base_price, 'Rs', '€') as base_eur,
    convert_currency(max_price, 'Rs', '€') as max_eur,
    convert_currency(base_price, 'Rs', 'AED') as base_aed,
    convert_currency(max_price, 'Rs', 'AED') as max_aed,
    convert_currency(base_price, 'Rs', 'SAR') as base_sar,
    convert_currency(max_price, 'Rs', 'SAR') as max_sar
FROM public.fruits 
WHERE name = 'Apple';

-- =====================================================
-- 8. COMMENTS FOR DOCUMENTATION
-- =====================================================
COMMENT ON TABLE public.currency_rates IS 'Currency conversion rates relative to Indian Rupees (Rs)';
COMMENT ON FUNCTION convert_currency(DECIMAL, TEXT, TEXT) IS 'Converts amount from one currency to another using stored rates. Parameters: amount, from_currency_param, to_currency_param';
COMMENT ON FUNCTION get_converted_price_range(DECIMAL, DECIMAL, TEXT) IS 'Returns converted price range for a given currency';

-- =====================================================
-- 9. SAMPLE CURRENCY CONVERSION EXAMPLES
-- =====================================================
/*
Example conversions (approximate rates):

Product: Apple
Base Price: 120 Rs
Max Price: 180 Rs

In different currencies:
- Rs: 120.00 - 180.00 Rs
- $: $1.44 - $2.16
- €: €1.32 - €1.98
- £: £1.14 - £1.71
- ¥: 216.00 - 324.00 ¥
- ₽: 144.00 - 216.00 ₽
- AED: AED 5.28 - AED 7.92
- SAR: SAR 5.40 - SAR 8.10

This ensures realistic pricing for each currency!
*/
