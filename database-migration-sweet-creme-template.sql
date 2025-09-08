-- =====================================================
-- SWEET CREME TEMPLATE MIGRATION - UPDATED STYLING
-- =====================================================
-- This migration adds the Sweet Creme Premium Soft Serve template
-- with improved styling: bigger logo, bold transaction details, minimal lines

-- Delete existing Sweet Creme template if it exists
DELETE FROM public.slip_formats WHERE name = 'Sweet Creme Premium Soft Serve';

-- Insert the new Sweet Creme template
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
  'Sweet Creme Premium Soft Serve',
  'Ice cream shop receipt template with detailed item table and premium soft serve branding',
  '<div style="width:80mm;margin:auto;font-family:''Courier New'',monospace;font-size:14px;color:#000;padding:8mm;line-height:1.4;background:#fff;">
  
  <!-- Logo Section -->
  <div style="text-align:center;margin-bottom:16px;">
    <div style="width:300px;height:300px;border-radius:50%;margin:0 auto 8px;display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:14px;">
      {{logo}}
    </div>
    <div style="font-size:8px;font-weight:bold;">Sweet Creme</div>
    <div style="font-size:7px;">Premium Soft Serve</div>
  </div>

  <!-- Store Information -->
  <div style="text-align:center;margin-bottom:16px;">
    <div style="font-size:16px;font-weight:bold;margin:0 0 6px 0;">Premium Soft Serve</div>
    <div style="font-size:13px;margin:3px 0;">SS Tower Shopping Mall, Bahawalpur</div>
    <div style="font-size:13px;margin:3px 0;">03-111-666-656</div>
  </div>


  <!-- Transaction Details -->
  <div style="margin:10px 0;font-size:13px;">
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span><span style="font-weight:bold;">Bill #:</span> {{slip_number}}</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span><span style="font-weight:bold;">Date:</span> {{date}}</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span><span style="font-weight:bold;">Time:</span> {{time}}</span>
    </div>
  </div>


  <hr style="border:none;border-top:1px dotted #000;margin:8px 0;">

  <!-- Items Table -->
  <table style="width:100%;margin:12px 0;font-size:12px;border-collapse:collapse;border-bottom:1px dotted #000;">
    <thead>
      <tr>
        <th style="width:8%;text-align:left;padding:6px 3px;font-weight:bold;font-size:12px;">#</th>
        <th style="width:35%;text-align:left;padding:6px 3px;font-weight:bold;font-size:12px;word-wrap:break-word;">Item Name</th>
        <th style="width:25%;text-align:left;padding:6px 3px;font-weight:bold;font-size:12px;">Rate</th>
        <th style="width:12%;text-align:center;padding:6px 3px;font-weight:bold;font-size:12px;">Qty</th>
        <th style="width:20%;text-align:right;padding:6px 3px;font-weight:bold;font-size:12px;">Amou</th>
      </tr>
    </thead>
    <tbody>
      {{items}}
    </tbody>
  </table>


  <!-- Summary Section -->
  <div style="margin:12px 0;font-size:13px;">
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span style="font-weight:bold;">Gross Amt:</span>
      <span>{{gross_amount}}</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span style="font-weight:bold;">Net Total:</span>
      <span>{{net_total}}</span>
    </div>
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span style="font-weight:bold;">Total Amount:</span>
      <span>{{total_amount}}</span>
    </div>
  </div>

 <hr style="border:none;border-top:1px dotted #000;margin:8px 0;">
  <!-- Footer -->
    <div style="margin:12px 0;font-size:13px;">
<div style="display:flex;justify-content:space-between;margin:10px 0;">
  <span style="font-weight:bold;">Credit Card Payment:</span>
  <span style="font-weight:bold;">{{payment_amount}}</span>
</div>
    <div style="display:flex;justify-content:space-between;margin:5px 0;">
      <span style="font-weight:bold;">Token #:</span>
      <span>{{token_number}}</span>
    </div>
  </div>
  <div style="text-align:center;margin-top:16px;font-size:13px;font-weight:bold;">
    THANK YOU FOR YOUR VISIT
  </div>

</div>',
  true,
  'Sweet Creme Premium Soft Serve',
  'SS Tower Shopping Mall, Bahawalpur',
  '03-111-666-656',
  'info@sweetcreme.com',
  'www.sweetcreme.com',
  0.00,
  'Rs',
  'Thank you for choosing Sweet Creme!',
  'custom'
);

-- =====================================================
-- VERIFICATION QUERY
-- =====================================================
-- Run this to verify the template was added successfully
SELECT 
    name,
    description,
    category,
    currency_symbol,
    is_active
FROM public.slip_formats 
WHERE name = 'Sweet Creme Premium Soft Serve';

-- =====================================================
-- NOTES
-- =====================================================
/*
Key Features of this template:
1. Bigger logo (80px x 80px) - centered
2. Bold transaction details (Bill #, Date, Time)
3. Minimal horizontal lines:
   - One after header
   - One dotted line after items table
   - One after totals
4. Proper table structure with headers above items
5. 80mm width optimized for thermal printers
6. All 10 placeholders supported:
   - {{logo}}, {{slip_number}}, {{date}}, {{time}}
   - {{items}}, {{gross_amount}}, {{net_total}}
   - {{total_amount}}, {{payment_amount}}, {{token_number}}
*/