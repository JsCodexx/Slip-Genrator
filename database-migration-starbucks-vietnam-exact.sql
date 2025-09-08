-- =====================================================
-- STARBUCKS RECEIPT TEMPLATE - EXACT REPLICA
-- =====================================================
-- This migration creates a Starbucks receipt template
-- that matches exactly the Vietnamese Starbucks receipt
-- Optimized for 80mm thermal printers
-- =====================================================

-- Update existing Starbucks Vietnam template with logo placeholder
UPDATE public.slip_formats SET
  description = 'Exact replica of Vietnamese Starbucks receipt with siren logo and Vietnamese text',
  template_html = '<div style="width:80mm;margin:auto;font-family:''Courier New'',monospace;font-size:10px;color:#000;padding:4mm;line-height:1.2;background:#fff;">
  
  <!-- Starbucks Logo -->
  <div style="text-align:center;margin-bottom:8px;">
    {{logo}}
  </div>

  <!-- Store Information -->
  <div style="text-align:center;margin-bottom:8px;font-size:9px;">
    <div style="font-weight:bold;margin-bottom:2px;">Store-Lan Vien</div>
    <div style="margin-bottom:2px;">
      32 Hang Bai St, Hoan Kiem Dist<br>
      Hanoi, Vietnam
    </div>
    <div>Tel: (024) 3936 8407</div>
  </div>

  <!-- Transaction Details -->
  <div style="margin-bottom:8px;font-size:9px;">
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Date:</span>
      <span>3/18/2019</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Time:</span>
      <span>07:36</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Terminal:</span>
      <span>0427101</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Partner:</span>
      <span>Hiển Anh</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Customer Name:</span>
      <span></span>
    </div>
  </div>

  <!-- Items Header -->
  <div style="margin-bottom:4px;font-size:9px;">
    <div style="display:flex;justify-content:space-between;font-weight:bold;border-bottom:1px solid #000;padding-bottom:2px;">
      <div style="width:60%;">Item</div>
      <div style="width:15%;text-align:center;">QTY</div>
      <div style="width:25%;text-align:right;">Amount</div>
    </div>
  </div>

  <!-- Items -->
  <div style="margin-bottom:8px;font-size:9px;">
    <div style="display:flex;justify-content:space-between;margin-bottom:2px;">
      <div style="width:60%;">Mon Nuoc CAFFE MOCHA G</div>
      <div style="width:15%;text-align:center;">1.00</div>
      <div style="width:25%;text-align:right;">88,000</div>
    </div>
  </div>

  <!-- Summary Section -->
  <div style="margin-bottom:8px;font-size:9px;">
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Subtotal:</span>
      <span>80,000</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Total tax:</span>
      <span>8,000</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:2px;font-weight:bold;border-top:1px solid #000;padding-top:2px;">
      <span>Total:</span>
      <span>88,000</span>
    </div>
  </div>

  <!-- Payment Information -->
  <div style="margin-bottom:8px;font-size:9px;">
    <div style="display:flex;justify-content:space-between;margin-bottom:1px;">
      <span>Cash paid:</span>
      <span>500,000</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin-bottom:2px;">
      <span>Change back (Cash):</span>
      <span>412,000</span>
    </div>
  </div>

  <!-- Footer Messages -->
  <div style="text-align:center;margin-bottom:8px;font-size:9px;">
    <div style="margin-bottom:4px;">Thank you!</div>
    <div style="margin-bottom:4px;">Please ask our staff for VAT invoice today</div>
    <div style="margin-bottom:4px;">
      Quý khách cần hóa đơn tài chính,<br>
      vui lòng cung cấp thông tin trong ngày.
    </div>
  </div>

  <!-- WiFi Information -->
  <div style="text-align:center;font-size:8px;border-top:1px dashed #000;padding-top:4px;">
    <div style="margin-bottom:2px;">Free wifi access code:</div>
    <div style="font-weight:bold;margin-bottom:2px;">1577152971</div>
    <div>Valid for one hour only.</div>
  </div>

</div>',
  store_name = 'Store-Lan Vien',
  store_address = '32 Hang Bai St, Hoan Kiem Dist, Hanoi, Vietnam',
  store_phone = '(024) 3936 8407',
  store_email = 'info@starbucks.com',
  store_website = 'www.starbucks.com',
  tax_rate = 10.00,
  currency_symbol = 'VND',
  footer_text = 'Thank you!\nPlease ask our staff for VAT invoice today\nQuý khách cần hóa đơn tài chính, vui lòng cung cấp thông tin trong ngày.',
  category = 'custom'
WHERE name = 'Starbucks Vietnam - Receipt';

-- Verify the template was updated
SELECT 
  name,
  description,
  store_name,
  store_address,
  currency_symbol,
  tax_rate,
  category,
  'TEMPLATE_UPDATED ✓' as status
FROM public.slip_formats 
WHERE name = 'Starbucks Vietnam - Receipt';

-- Show template count by category
SELECT 
  category,
  COUNT(*) as template_count
FROM public.slip_formats 
WHERE is_active = true
GROUP BY category
ORDER BY template_count DESC;
