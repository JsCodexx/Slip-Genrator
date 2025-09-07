-- =====================================================
-- CONVERT UK SUPERMARKET TEMPLATE TO STATIC DESIGN
-- Remove all placeholders and make it a fixed static design
-- =====================================================

-- Update the UK Supermarket template to be completely static
UPDATE public.slip_formats 
SET template_html = '<div style="width:80mm;margin:auto;font-family:''Courier New'',monospace;font-size:10px;color:#000;padding:4mm;line-height:1.2;">
  <div style="text-align:center;margin-bottom:3px;">
    TESCO SUPERMARKET<br><br>
    Oxford Street, London<br><br>
    London, United Kingdom<br><br>
    Tel +44-20-1234-5678
  </div>

  <div style="text-align:center;font-weight:600;margin-bottom:6px;">
    VAT Receipt<br><br>
    VAT Number: GB123456789
  </div>

  <div style="font-size:9px;margin-bottom:6px;">
    Receipt: #001234<br><br>
    Date: 15/12/2024
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-weight:600;font-size:9px;">
    <div style="width:60%;">Item</div>
    <div style="width:15%;text-align:right;">Price</div>
    <div style="width:15%;text-align:center;">Qty</div>
    <div style="width:10%;text-align:right;">Total</div>
  </div>

  <div style="display:flex;justify-content:space-between;font-size:9px;margin-top:2px;">
    <div style="width:60%;">Fish & Chips</div>
    <div style="width:15%;text-align:right;">£4.50</div>
    <div style="width:15%;text-align:center;">1</div>
    <div style="width:10%;text-align:right;">£4.50</div>
  </div>
  
  <div style="display:flex;justify-content:space-between;font-size:9px;margin-top:2px;">
    <div style="width:60%;">Tea & Biscuits</div>
    <div style="width:15%;text-align:right;">£2.50</div>
    <div style="width:15%;text-align:center;">1</div>
    <div style="width:10%;text-align:right;">£2.50</div>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">

  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Subtotal</span>
    <span>£7.00</span>
  </div>
  
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>VAT (20%)</span>
    <span>£1.40</span>
  </div>
  
  <div style="display:flex;justify-content:space-between;font-size:10px;font-weight:700;">
    <span>Total</span>
    <span>£8.40</span>
  </div>

  <hr style="border:none;border-top:1px dashed #000;margin:6px 0;">
  
  <div style="text-align:center;font-size:8px;margin-top:4px;">
    Every little helps!<br>
    Thank you for shopping at Tesco
  </div>
</div>',
description = 'Static UK supermarket receipt with fixed content - no placeholders'
WHERE name = 'UK Supermarket - VAT Receipt';

-- =====================================================
-- VERIFICATION QUERY
-- =====================================================

-- Check that the template has been updated to static
SELECT 
    name,
    description,
    CASE 
        WHEN template_html LIKE '%{{%' THEN 'HAS PLACEHOLDERS'
        ELSE 'STATIC DESIGN ✓'
    END as template_status,
    LENGTH(template_html) as template_length
FROM public.slip_formats 
WHERE name = 'UK Supermarket - VAT Receipt';

-- Show the updated template content
SELECT 
    name,
    SUBSTRING(template_html, 1, 500) as template_start
FROM public.slip_formats 
WHERE name = 'UK Supermarket - VAT Receipt';

-- =====================================================
-- MIGRATION SUMMARY
-- =====================================================

/*
This migration converts the UK Supermarket template to a static design.

What it does:
1. Removes all {{placeholder}} variables
2. Replaces with fixed static content
3. Updates the description to reflect static nature
4. Maintains the same visual design and layout

Static content includes:
- Fixed store name: TESCO SUPERMARKET
- Fixed address: Oxford Street, London
- Fixed phone: +44-20-1234-5678
- Fixed receipt number: #001234
- Fixed date: 15/12/2024
- Fixed items: Fish & Chips (£4.50), Tea & Biscuits (£2.50)
- Fixed totals: Subtotal £7.00, VAT £1.40, Total £8.40
- Fixed footer: "Every little helps! Thank you for shopping at Tesco"

The template will now print the same content every time without any dynamic data.
*/
