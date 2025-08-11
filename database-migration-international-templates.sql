-- =====================================================
-- INTERNATIONAL TEMPLATES MIGRATION
-- Add category field and Dubai supermarket template
-- =====================================================

-- =====================================================
-- 1. ADD MISSING COLUMNS TO SLIP FORMATS TABLE
-- =====================================================
-- Add store-related columns if they don't exist
ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS store_name TEXT DEFAULT 'Store Name';

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS store_address TEXT DEFAULT 'Store Address';

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS store_phone TEXT DEFAULT '+1-555-0000';

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS store_email TEXT DEFAULT 'info@store.com';

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS store_website TEXT DEFAULT 'www.store.com';

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS tax_rate DECIMAL(5,2) DEFAULT 0.00;

ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS footer_text TEXT DEFAULT 'Thank you for your purchase!';

-- =====================================================
-- 2. ADD CATEGORY FIELD TO SLIP FORMATS
-- =====================================================
ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'standard';

-- Add constraint for allowed categories
ALTER TABLE public.slip_formats 
ADD CONSTRAINT slip_formats_category_check 
CHECK (category IN ('standard', 'international', 'premium', 'custom'));

-- Update existing templates to have 'standard' category
UPDATE public.slip_formats 
SET category = 'standard' 
WHERE category IS NULL;

-- Create index for better performance on category searches
CREATE INDEX IF NOT EXISTS idx_slip_formats_category ON public.slip_formats(category);

-- Add comment for documentation
COMMENT ON COLUMN public.slip_formats.category IS 'Template category: standard, international, premium, custom';

-- =====================================================
-- 3. INSERT DUBAI SUPERMARKET TEMPLATE
-- =====================================================
INSERT INTO public.slip_formats (
    name, 
    description, 
    category,
    template_html, 
    store_name, 
    store_address, 
    store_phone, 
    store_email, 
    store_website, 
    tax_rate, 
    currency_symbol, 
    footer_text,
    is_active
) VALUES (
    'Dubai Supermarket - Tax Invoice',
    'Professional Dubai supermarket tax invoice with Arabic text and VAT details',
    'international',
    '<div style="max-width:320px;margin:auto;font-family:''Courier New'',monospace;font-size:13px;color:#000;border:1px solid #000;padding:8px;line-height:1.35;">
  <div style="text-align:center;margin-bottom:6px;">
    {{store_name}}<br>
    {{store_address}}<br>
    International City, Dubai-UAE<br>
    Tel {{store_phone}}
  </div>

  <div style="text-align:center;font-weight:600;margin-bottom:4px;">
    Tax Invoice<br>
    <span style="font-size:11px;">فاتورة ضريبية</span>
  </div>
  <div style="text-align:center;margin-bottom:6px;">
    TRN : 100071695100003
  </div>

  <div style="font-size:12px;margin-bottom:4px;">
    Invoice: {{slip_number}}<br>
    Date: {{date}}
  </div>
  <div style="font-size:12px;margin-bottom:4px;">
    Cashier: {{cashier_name}}<br>
    Time: {{time}}
  </div>
  <div style="font-size:12px;margin-bottom:6px;">
    Counter: {{counter}}
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-weight:600;font-size:12px;">
    <div style="width:58%;">Item<br><span style="font-weight:400;font-size:11px;">السلعة</span></div>
    <div style="width:14%;text-align:right;">Price<br><span style="font-weight:400;font-size:11px;">السعر</span></div>
    <div style="width:14%;text-align:center;">Qty<br><span style="font-weight:400;font-size:11px;">الكمية</span></div>
    <div style="width:14%;text-align:right;">Amount<br><span style="font-weight:400;font-size:11px;">المبلغ</span></div>
  </div>

  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:58%;">SHEZAN MANGO DRINK<br><span style="font-size:11px;">5078643001109</span></div>
    <div style="width:14%;text-align:right;">{{item1_price}}</div>
    <div style="width:14%;text-align:center;">{{item1_qty}}</div>
    <div style="width:14%;text-align:right;">{{item1_total}}</div>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:58%;">EXTRA SPEARMINT 14G<br><span style="font-size:11px;">50173686</span></div>
    <div style="width:14%;text-align:right;">{{item2_price}}</div>
    <div style="width:14%;text-align:center;">{{item2_qty}}</div>
    <div style="width:14%;text-align:right;">{{item2_total}}</div>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>Total (Ex. VAT)<br><span style="font-size:11px;">المبلغ الإجمالي</span></span>
    <span>{{total}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>VAT Amount<br><span style="font-size:11px;">قيمة الضريبة</span></span>
    <span>{{tax_amount}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:13px;font-weight:700;">
    <span>Net Total (In. VAT)<br><span style="font-size:11px;">الصافي الإجمالي</span></span>
    <span>{{grand_total}}</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>Cash<br><span style="font-size:11px;">نقداً</span></span>
    <span>{{cash_amount}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>Change<br><span style="font-size:11px;">الباقي</span></span>
    <span>{{change_amount}}</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>VAT%</span>
    <span>Amount</span>
    <span>VAT</span>
    <span>Net Amt</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>{{tax_rate}}</span>
    <span>{{total}}</span>
    <span>{{tax_amount}}</span>
    <span>{{grand_total}}</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="font-size:12px;">
    Total No. of items sold {{items_count}}<br>
    Total No. of qty sold {{total_quantity}}
  </div>

  <div style="text-align:center;margin-top:8px;">
    <div style="font-size:12px;">*{{slip_number}}*</div>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="text-align:center;font-size:12px;">
    {{footer_text}}
  </div>
</div>',
    'FAAZ SUPERMARKET',
    'Morocco Cluster, I-03',
    '04-5707396',
    'info@faazsupermarket.ae',
    'www.faazsupermarket.ae',
    5.00,
    'AED',
    'Free Home Delivery\nTo Get Latest Offers & Promotions',
    TRUE
) ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 4. INSERT MORE INTERNATIONAL TEMPLATES
-- =====================================================

-- Saudi Arabia Supermarket Template
INSERT INTO public.slip_formats (
    name, 
    description, 
    category,
    template_html, 
    store_name, 
    store_address, 
    store_phone, 
    store_email, 
    store_website, 
    tax_rate, 
    currency_symbol, 
    footer_text,
    is_active
) VALUES (
    'Saudi Supermarket - VAT Invoice',
    'Saudi Arabia supermarket invoice with Arabic text and 15% VAT',
    'international',
    '<div style="max-width:320px;margin:auto;font-family:''Arial'',sans-serif;font-size:13px;color:#000;border:1px solid #000;padding:8px;line-height:1.35;">
  <div style="text-align:center;margin-bottom:6px;">
    {{store_name}}<br>
    {{store_address}}<br>
    Riyadh, Saudi Arabia<br>
    Tel {{store_phone}}
  </div>

  <div style="text-align:center;font-weight:600;margin-bottom:4px;">
    VAT Invoice<br>
    <span style="font-size:11px;">فاتورة ضريبة القيمة المضافة</span>
  </div>
  <div style="text-align:center;margin-bottom:6px;">
    VAT Number: 300000000000000
  </div>

  <div style="font-size:12px;margin-bottom:4px;">
    Invoice: {{slip_number}}<br>
    Date: {{date}}
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-weight:600;font-size:12px;">
    <div style="width:60%;">Item</div>
    <div style="width:15%;text-align:right;">Price</div>
    <div style="width:15%;text-align:center;">Qty</div>
    <div style="width:10%;text-align:right;">Total</div>
  </div>

  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:60%;">Fresh Dates</div>
    <div style="width:15%;text-align:right;">{{item1_price}}</div>
    <div style="width:15%;text-align:center;">{{item1_qty}}</div>
    <div style="width:10%;text-align:right;">{{item1_total}}</div>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:60%;">Arabic Coffee</div>
    <div style="width:15%;text-align:right;">{{item2_price}}</div>
    <div style="width:15%;text-align:center;">{{item2_qty}}</div>
    <div style="width:10%;text-align:right;">{{item2_total}}</div>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>Subtotal</span>
    <span>{{total}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>VAT (15%)</span>
    <span>{{tax_amount}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:13px;font-weight:700;">
    <span>Total</span>
    <span>{{grand_total}}</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="text-align:center;font-size:12px;">
    {{footer_text}}
  </div>
</div>',
    'AL-RAJHI SUPERMARKET',
    'King Fahd Road, Riyadh',
    '+966-11-1234567',
    'info@alrajhi.com.sa',
    'www.alrajhi.com.sa',
    15.00,
    'SAR',
    'Thank you for shopping with us!\nWe appreciate your business',
    TRUE
) ON CONFLICT (name) DO NOTHING;

-- UK Supermarket Template
INSERT INTO public.slip_formats (
    name, 
    description, 
    category,
    template_html, 
    store_name, 
    store_address, 
    store_phone, 
    store_email, 
    store_website, 
    tax_rate, 
    currency_symbol, 
    footer_text,
    is_active
) VALUES (
    'UK Supermarket - VAT Receipt',
    'British supermarket receipt with VAT details and pound sterling',
    'international',
    '<div style="max-width:320px;margin:auto;font-family:''Arial'',sans-serif;font-size:13px;color:#000;border:1px solid #000;padding:8px;line-height:1.35;">
  <div style="text-align:center;margin-bottom:6px;">
    {{store_name}}<br>
    {{store_address}}<br>
    London, United Kingdom<br>
    Tel {{store_phone}}
  </div>

  <div style="text-align:center;font-weight:600;margin-bottom:4px;">
    VAT Receipt<br>
    VAT Number: GB123456789
  </div>

  <div style="font-size:12px;margin-bottom:4px;">
    Receipt: {{slip_number}}<br>
    Date: {{date}}
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-weight:600;font-size:12px;">
    <div style="width:60%;">Item</div>
    <div style="width:15%;text-align:right;">Price</div>
    <div style="width:15%;text-align:center;">Qty</div>
    <div style="width:10%;text-align:right;">Total</div>
  </div>

  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:60%;">Fish & Chips</div>
    <div style="width:15%;text-align:right;">{{item1_price}}</div>
    <div style="width:15%;text-align:center;">{{item1_qty}}</div>
    <div style="width:10%;text-align:right;">{{item1_total}}</div>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;margin-top:3px;">
    <div style="width:60%;">Tea & Biscuits</div>
    <div style="width:15%;text-align:right;">{{item2_price}}</div>
    <div style="width:15%;text-align:center;">{{item2_qty}}</div>
    <div style="width:10%;text-align:right;">{{item2_total}}</div>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>Subtotal</span>
    <span>{{total}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:12px;">
    <span>VAT (20%)</span>
    <span>{{tax_amount}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:13px;font-weight:700;">
    <span>Total</span>
    <span>{{grand_total}}</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="text-align:center;font-size:12px;">
    {{footer_text}}
  </div>
</div>',
    'TESCO SUPERMARKET',
    'Oxford Street, London',
    '+44-20-1234-5678',
    'info@tesco.co.uk',
    'www.tesco.co.uk',
    20.00,
    '£',
    'Every little helps!\nThank you for shopping at Tesco',
    TRUE
) ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 5. VERIFICATION QUERIES
-- =====================================================

-- Check all international templates
SELECT 
    name, 
    category, 
    currency_symbol, 
    tax_rate,
    store_name,
    store_address
FROM public.slip_formats 
WHERE category = 'international'
ORDER BY name;

-- Check template categories distribution
SELECT 
    category, 
    COUNT(*) as template_count
FROM public.slip_formats 
GROUP BY category
ORDER BY template_count DESC;

-- =====================================================
-- 6. COMMENTS FOR DOCUMENTATION
-- =====================================================
COMMENT ON TABLE public.slip_formats IS 'Slip templates with categories: standard, international, premium, custom';
COMMENT ON COLUMN public.slip_formats.category IS 'Template category for organization and filtering';

-- =====================================================
-- 7. SAMPLE USAGE EXAMPLES
-- =====================================================
/*
The new international templates include:

1. **Dubai Supermarket** (AED, 5% VAT)
   - Arabic text support
   - Dubai-specific formatting
   - Professional tax invoice layout

2. **Saudi Supermarket** (SAR, 15% VAT)
   - Saudi Arabia VAT compliance
   - Arabic text elements
   - Modern invoice design

3. **UK Supermarket** (GBP, 20% VAT)
   - UK VAT requirements
   - British supermarket style
   - Professional receipt format

All templates support:
- Dynamic item insertion
- Automatic tax calculations
- Currency-specific formatting
- Professional business layout
*/
