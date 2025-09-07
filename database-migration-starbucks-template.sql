-- =====================================================
-- STARBUCKS RECEIPT TEMPLATE - STATIC DESIGN
-- =====================================================
-- This migration creates a Starbucks receipt template
-- with static items and signature Starbucks styling
-- Optimized for 80mm thermal printers
-- =====================================================

-- Insert Starbucks receipt template
INSERT INTO public.slip_formats (
  name,
  description,
  template_html,
  is_active,
  store_name,
  store_address,
  store_phone,
  store_email,
  store_website,
  tax_rate,
  currency_symbol,
  footer_text,
  category
) VALUES (
  'Starbucks Coffee - Receipt',
  'Starbucks coffee shop receipt with signature green styling and typical menu items',
  '<div style="width:80mm;margin:auto;font-family:\'Courier New\',monospace;font-size:10px;color:#000;padding:4mm;line-height:1.2;background:#fff;">
  
  <!-- Starbucks Header -->
  <div style="text-align:center;margin-bottom:6px;">
    <div style="font-size:14px;font-weight:bold;color:#00704A;margin-bottom:2px;">
      ⭐ STARBUCKS COFFEE ⭐
    </div>
    <div style="font-size:9px;margin-bottom:2px;">
      123 Coffee Street<br>
      Downtown District<br>
      Seattle, WA 98101
    </div>
    <div style="font-size:8px;">
      Tel: (206) 555-0123<br>
      www.starbucks.com
    </div>
  </div>

  <!-- Receipt Info -->
  <div style="text-align:center;margin-bottom:6px;font-size:9px;">
    <div style="border-top:1px dashed #000;border-bottom:1px dashed #000;padding:3px 0;">
      Receipt #: SB-2024-001234<br>
      Date: 15/12/2024 14:30<br>
      Cashier: Sarah M.
    </div>
  </div>

  <!-- Order Items -->
  <div style="margin-bottom:6px;">
    <div style="display:flex;justify-content:space-between;font-weight:bold;font-size:9px;margin-bottom:3px;border-bottom:1px solid #000;padding-bottom:2px;">
      <div style="width:50%;">Item</div>
      <div style="width:15%;text-align:center;">Size</div>
      <div style="width:20%;text-align:right;">Price</div>
      <div style="width:15%;text-align:right;">Total</div>
    </div>
    
    <!-- Coffee Items -->
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <div style="width:50%;">Grande Latte</div>
      <div style="width:15%;text-align:center;">16oz</div>
      <div style="width:20%;text-align:right;">$5.45</div>
      <div style="width:15%;text-align:right;">$5.45</div>
    </div>
    
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <div style="width:50%;">Venti Caramel Macchiato</div>
      <div style="width:15%;text-align:center;">20oz</div>
      <div style="width:20%;text-align:right;">$6.25</div>
      <div style="width:15%;text-align:right;">$6.25</div>
    </div>
    
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <div style="width:50%;">Tall Cappuccino</div>
      <div style="width:15%;text-align:center;">12oz</div>
      <div style="width:20%;text-align:right;">$4.75</div>
      <div style="width:15%;text-align:right;">$4.75</div>
    </div>
    
    <!-- Food Items -->
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <div style="width:50%;">Chocolate Croissant</div>
      <div style="width:15%;text-align:center;">1pc</div>
      <div style="width:20%;text-align:right;">$3.95</div>
      <div style="width:15%;text-align:right;">$3.95</div>
    </div>
    
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <div style="width:50%;">Blueberry Muffin</div>
      <div style="width:15%;text-align:center;">1pc</div>
      <div style="width:20%;text-align:right;">$2.95</div>
      <div style="width:15%;text-align:right;">$2.95</div>
    </div>
  </div>

  <!-- Totals Section -->
  <div style="border-top:1px dashed #000;margin:6px 0;padding-top:3px;">
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <span>Subtotal:</span>
      <span>$23.35</span>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:9px;margin-bottom:2px;">
      <span>Tax (8.5%):</span>
      <span>$1.98</span>
    </div>
    <div style="display:flex;justify-content:space-between;font-size:10px;font-weight:bold;margin-bottom:3px;border-top:1px solid #000;padding-top:2px;">
      <span>TOTAL:</span>
      <span>$25.33</span>
    </div>
  </div>

  <!-- Payment Info -->
  <div style="text-align:center;margin-bottom:6px;font-size:9px;">
    <div style="border:1px dashed #000;padding:3px;margin:3px 0;">
      Payment: Credit Card ****1234<br>
      Auth: 123456<br>
      Thank You!
    </div>
  </div>

  <!-- Starbucks Footer -->
  <div style="text-align:center;font-size:8px;color:#00704A;margin-top:6px;">
    <div style="border-top:1px dashed #000;padding-top:3px;">
      <div style="font-weight:bold;margin-bottom:2px;">
        ☕ INSPIRE AND NURTURE THE HUMAN SPIRIT ☕
      </div>
      <div style="margin-bottom:2px;">
        One person, one cup and one neighborhood at a time
      </div>
      <div style="font-size:7px;">
        Visit us at starbucks.com<br>
        Follow us @starbucks
      </div>
    </div>
  </div>

  <!-- Loyalty Program -->
  <div style="text-align:center;font-size:8px;margin-top:4px;background:#f0f0f0;padding:3px;border:1px dashed #000;">
    <div style="font-weight:bold;color:#00704A;">
      STARBUCKS REWARDS
    </div>
    <div>
      Earn 2 stars per $1 spent<br>
      Redeem 25 stars for free drink
    </div>
  </div>

</div>',
  true,
  'Starbucks Coffee',
  '123 Coffee Street, Downtown District',
  '(206) 555-0123',
  'info@starbucks.com',
  'www.starbucks.com',
  8.50,
  '$',
  'Thank you for choosing Starbucks!\nHave a great day!',
  'coffee'
);

-- Verify the template was created
SELECT 
  name,
  description,
  store_name,
  currency_symbol,
  tax_rate,
  category,
  'TEMPLATE_CREATED ✓' as status
FROM public.slip_formats 
WHERE name = 'Starbucks Coffee - Receipt';

-- Show template count by category
SELECT 
  category,
  COUNT(*) as template_count
FROM public.slip_formats 
WHERE is_active = true
GROUP BY category
ORDER BY template_count DESC;
