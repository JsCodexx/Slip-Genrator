-- Complete Slip Templates with All Required Placeholders
-- This file contains 20 different slip template designs
-- Each template includes ALL required placeholders:
-- {{logo}}, {{store_name}}, {{store_address}}, {{store_phone}}, {{store_email}}, {{store_website}}
-- {{date}}, {{slip_number}}, {{items}}, {{total}}, {{grand_total}}, {{tax_amount}}, {{tax_rate}}, {{currency_symbol}}, {{footer_text}}

INSERT INTO public.slip_formats (name, description, template_html, store_name, store_address, store_phone, store_email, store_website, tax_rate, currency_symbol, footer_text)
VALUES

-- 1. Minimal Classic
('Minimal Classic', 'Clean and simple design with all essential elements', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border:1px solid #000;padding:10px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <h2 style="margin:0;text-transform:uppercase;">{{store_name}}</h2>
    <p style="margin:2px 0;">{{store_address}}</p>
    <p style="margin:2px 0;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;">Email: {{store_email}}</p>
    <p style="margin:2px 0;">Website: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>Date: {{date}}</span>
    <span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Fresh Fruits Market', '123 Fruit Street, Garden City', '+1-555-0123', 'info@freshfruits.com', 'www.freshfruits.com', 5.00, 'Rs', 'Thank you for your purchase!'),

-- 2. Bold Double Border
('Bold Double Border', 'Bold design with double borders for strong visual impact', 
'<div style="max-width:320px;margin:auto;font-family:Tahoma,sans-serif;font-size:14px;color:#000;border:3px double #000;padding:12px;">
  <div style="text-align:center;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:8px;">
    <h1 style="margin:0;font-size:18px;">{{store_name}}</h1>
    <p style="margin:0;">{{store_address}}</p>
    <p>Tel: {{store_phone}}</p>
    <p>Email: {{store_email}}</p>
    <p>Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:6px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>Date: {{date}}</span><span>Slip: {{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:6px 0;">
  <div style="margin-bottom:10px;">{{items}}</div>
  <hr style="border:none;border-top:2px solid #000;margin:6px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:12px;margin-top:8px;">{{footer_text}}</div>
</div>', 
'Premium Fruits Co.', '456 Orchard Lane, Fruit Valley', '+1-555-0456', 'hello@premiumfruits.co', 'www.premiumfruits.co', 8.50, 'Rs', 'Quality guaranteed!'),

-- 3. Dotted Divider Style
('Dotted Divider Style', 'Elegant design with dotted dividers for a sophisticated look', 
'<div style="max-width:320px;margin:auto;font-family:Verdana,sans-serif;font-size:13px;color:#000;padding:10px;border:1px solid #000;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <h2 style="margin:0;">{{store_name}}</h2>
    <p style="margin:0;">{{store_address}}</p>
    <p style="margin:0;">Tel: {{store_phone}}</p>
    <p style="margin:0;">Email: {{store_email}}</p>
    <p style="margin:0;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px dotted #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px dotted #000;margin:5px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:1px dotted #000;margin:5px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="text-align:center;font-size:12px;margin-top:6px;">{{footer_text}}</div>
</div>', 
'Organic Fruits Hub', '789 Green Avenue, Eco Town', '+1-555-0789', 'organic@fruitshub.com', 'www.fruitshub.com', 0.00, 'Rs', '100% Organic & Fresh'),

-- 4. Boxed Invoice Look
('Boxed Invoice Look', 'Professional invoice-style layout with boxed sections', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:13px;color:#000;border:2px solid #000;padding:10px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="border:1px solid #000;padding:5px;text-align:center;">
    <h2 style="margin:0;">{{store_name}}</h2>
    <p style="margin:0;">{{store_address}}</p>
    <p style="margin:0;">Tel: {{store_phone}}</p>
    <p style="margin:0;">Email: {{store_email}}</p>
    <p style="margin:0;">Web: {{store_website}}</p>
  </div>
  <div style="margin-top:8px;border:1px solid #000;padding:5px;">
    <div style="display:flex;justify-content:space-between;">
      <span>{{date}}</span><span>{{slip_number}}</span>
    </div>
  </div>
  <div style="margin-top:8px;border:1px solid #000;padding:5px;">{{items}}</div>
  <div style="margin-top:8px;border:1px solid #000;padding:5px;text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="margin-top:8px;text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Fruit Paradise', '321 Tropical Road, Beach City', '+1-555-0321', 'paradise@fruits.com', 'www.fruitparadise.com', 10.00, 'Rs', 'Visit us again soon!'),

-- 5. Modern Receipt Strip
('Modern Receipt Strip', 'Contemporary design with left border accent', 
'<div style="max-width:320px;margin:auto;font-family:Helvetica,sans-serif;font-size:14px;color:#000;border-left:4px solid #000;padding:10px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <h2 style="margin:0;">{{store_name}}</h2>
    <p style="margin:0;">{{store_address}}</p>
    <p>Tel: {{store_phone}}</p>
    <p>Email: {{store_email}}</p>
    <p>Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="text-align:center;font-size:12px;margin-top:6px;">{{footer_text}}</div>
</div>', 
'Fresh Harvest Market', '654 Farm Road, Country Side', '+1-555-0654', 'harvest@freshmarket.com', 'www.freshharvest.com', 6.25, 'Rs', 'Fresh from the farm!'),

-- 6. Classic Cafe Look
('Classic Cafe Look', 'Vintage cafe-style receipt with monospace font', 
'<div style="max-width:320px;margin:auto;font-family:''Courier New'',monospace;font-size:13px;color:#000;border:1px solid #000;padding:8px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong>
    <p style="margin:0;">{{store_address}}</p>
    <p>Tel: {{store_phone}}</p>
    <p>Email: {{store_email}}</p>
    <p>Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:2px dashed #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:2px dashed #000;margin:5px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:2px dashed #000;margin:5px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Vintage Fruits', '987 Heritage Street, Old Town', '+1-555-0987', 'vintage@fruits.com', 'www.vintagefruits.com', 7.75, 'Rs', 'Traditional quality since 1950'),

-- 7. Elegant Thin Border
('Elegant Thin Border', 'Sophisticated design with serif font and thin borders', 
'<div style="max-width:320px;margin:auto;font-family:Georgia,serif;font-size:14px;color:#000;border:1px solid #000;padding:10px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <h3 style="margin:0;">{{store_name}}</h3>
    <p style="margin:0;">{{store_address}}</p>
    <p>{{store_phone}}</p>
    <p>{{store_email}}</p>
    <p>{{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Gourmet Fruits', '147 Luxury Lane, Elite City', '+1-555-0147', 'gourmet@fruits.com', 'www.gourmetfruits.com', 12.00, 'Rs', 'Premium quality guaranteed'),

-- 8. Big Title Impact
('Big Title Impact', 'Bold design with large store name for maximum impact', 
'<div style="max-width:320px;margin:auto;font-family:Impact,sans-serif;font-size:14px;color:#000;border:2px solid #000;padding:10px;">
  <div style="text-align:center;font-size:22px;margin-bottom:8px;">{{store_name}}</div>
  <div style="text-align:center;">
    <p style="margin:0;">{{store_address}}</p>
    <p>{{store_phone}}</p>
    <p>{{store_email}}</p>
    <p>{{store_website}}</p>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:5px 0;">
  <div>{{items}}</div>
  <hr style="border:none;border-top:2px solid #000;margin:5px 0;">
  <div style="text-align:right;">
    <p>Subtotal: {{currency_symbol}}{{total}}</p>
    <p>Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p><strong>Total: {{currency_symbol}}{{grand_total}}</strong></p>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'SUPER FRUITS', '258 Power Street, Metro City', '+1-555-0258', 'super@fruits.com', 'www.superfruits.com', 9.50, 'Rs', 'The best fruits in town!'),

-- 9. Compact Columns
('Compact Columns', 'Space-efficient design with compact layout', 
'<div style="max-width:300px;margin:auto;font-family:Arial,sans-serif;font-size:12px;color:#000;border:1px solid #000;padding:6px;">
  <div style="text-align:center;margin-bottom:5px;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:4px 0;">
  {{items}}
  <hr style="border:none;border-top:1px dashed #000;margin:4px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:11px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Quick Fruits', '369 Fast Lane, Speed City', '+1-555-0369', 'quick@fruits.com', 'www.quickfruits.com', 4.25, 'Rs', 'Fast & fresh service'),

-- 10. Thick Header Bar
('Thick Header Bar', 'Bold header bar design with black background', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border:1px solid #000;">
  <div style="background:#000;color:#fff;text-align:center;padding:5px 0;font-weight:bold;">
    {{store_name}}
  </div>
  <div style="text-align:center;padding:5px;">
    <p style="margin:0;">{{store_address}}</p>
    <p style="margin:0;">Tel: {{store_phone}}</p>
    <p style="margin:0;">Email: {{store_email}}</p>
    <p style="margin:0;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:0;">
  <div style="padding:5px;display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:0;">
  <div style="padding:5px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:0;">
  <div style="padding:5px;text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;padding:5px;">{{footer_text}}</div>
</div>', 
'BOLD FRUITS', '741 Strong Street, Power City', '+1-555-0741', 'bold@fruits.com', 'www.boldfruits.com', 11.25, 'Rs', 'Bold flavors, bold choices'),

-- 11. Minimalist Gap
('Minimalist Gap', 'Clean design with generous white space', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;padding:10px;">
  <div style="text-align:center;margin-bottom:12px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:10px;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <div style="margin:10px 0;">Date: {{date}}<br>Slip #: {{slip_number}}</div>
  <div style="margin:10px 0;">{{items}}</div>
  <div style="margin-top:12px;text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="margin-top:15px;text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Clean Fruits', '852 Pure Street, Clean City', '+1-555-0852', 'clean@fruits.com', 'www.cleanfruits.com', 3.75, 'Rs', 'Pure and simple'),

-- 12. Double Border Box
('Double Border Box', 'Elegant double border design with sophisticated styling', 
'<div style="max-width:320px;margin:auto;font-family:Verdana,sans-serif;font-size:14px;color:#000;border:3px double #000;padding:8px;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;">
    <h3 style="margin:0;">{{store_name}}</h3>
    <p style="margin:0;">{{store_address}}</p>
    <p style="margin:0;">{{store_phone}}</p>
    <p style="margin:0;">{{store_email}}</p>
    <p style="margin:0;">{{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  {{items}}
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Elegant Fruits', '963 Style Street, Fashion City', '+1-555-0963', 'elegant@fruits.com', 'www.elegantfruits.com', 8.75, 'Rs', 'Elegance in every bite'),

-- 13. Bold Number Right
('Bold Number Right', 'Right-aligned totals with bold emphasis', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:13px;color:#000;border:1px solid #000;padding:8px;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:8px;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <div style="display:flex;justify-content:space-between;">
    <span>Date:</span><span>{{date}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;">
    <span>Slip #:</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  {{items}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;font-weight:bold;">
    <span>Subtotal:</span><span>{{currency_symbol}}{{total}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;">
    <span>Tax ({{tax_rate}}%):</span><span>{{currency_symbol}}{{tax_amount}}</span>
  </div>
  <div style="display:flex;justify-content:space-between;font-size:15px;font-weight:bold;">
    <span>Total:</span><span>{{currency_symbol}}{{grand_total}}</span>
  </div>
  <div style="text-align:center;font-size:11px;margin-top:6px;">{{footer_text}}</div>
</div>', 
'Right Fruits', '147 Align Street, Order City', '+1-555-0147', 'right@fruits.com', 'www.rightfruits.com', 6.50, 'Rs', 'Everything in its right place'),

-- 14. Dashed Edge Ticket
('Dashed Edge Ticket', 'Ticket-style design with dashed borders', 
'<div style="max-width:320px;margin:auto;font-family:Tahoma,sans-serif;font-size:13px;color:#000;border:2px dashed #000;padding:8px;">
  <div style="text-align:center;margin-bottom:5px;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  {{items}}
  <hr style="border:none;border-top:1px dashed #000;margin:5px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Ticket Fruits', '258 Ticket Street, Event City', '+1-555-0258', 'ticket@fruits.com', 'www.ticketfruits.com', 5.75, 'Rs', 'Your ticket to fresh fruits'),

-- 15. Wide Top Banner
('Wide Top Banner', 'Bold top banner with wide header design', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border:1px solid #000;">
  <div style="background:#000;color:#fff;padding:6px;text-align:center;font-size:18px;font-weight:bold;">{{store_name}}</div>
  <div style="text-align:center;padding:6px;">
    {{store_address}}<br>{{store_phone}}<br>{{store_email}}<br>{{store_website}}
  </div>
  <hr style="border:none;border-top:1px solid #000;">
  <div style="padding:6px;display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;">
  <div style="padding:6px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;">
  <div style="padding:6px;text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;padding:6px;font-size:12px;">{{footer_text}}</div>
</div>', 
'Banner Fruits', '369 Banner Street, Display City', '+1-555-0369', 'banner@fruits.com', 'www.bannerfruits.com', 9.25, 'Rs', 'Banner quality fruits'),

-- 16. Centered Everything
('Centered Everything', 'Fully centered layout for balanced design', 
'<div style="max-width:300px;margin:auto;font-family:Arial,sans-serif;font-size:13px;color:#000;border:1px solid #000;padding:10px;text-align:center;">
  {{logo}}<br>
  <strong>{{store_name}}</strong><br>
  {{store_address}}<br>
  {{store_phone}}<br>
  {{store_email}}<br>
  {{store_website}}<br><br>
  Date: {{date}}<br>
  Slip #: {{slip_number}}<br><br>
  {{items}}<br>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  Subtotal: {{currency_symbol}}{{total}}<br>
  Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
  <strong>Total: {{currency_symbol}}{{grand_total}}</strong><br><br>
  {{footer_text}}
</div>', 
'Center Fruits', '741 Center Street, Balance City', '+1-555-0741', 'center@fruits.com', 'www.centerfruits.com', 7.00, 'Rs', 'Perfectly balanced fruits'),

-- 17. Left Aligned Simple
('Left Aligned Simple', 'Simple left-aligned layout for easy reading', 
'<div style="max-width:320px;margin:auto;font-family:Tahoma,sans-serif;font-size:14px;color:#000;border:1px solid #000;padding:8px;">
  {{logo}}
  <strong>{{store_name}}</strong><br>
  {{store_address}}<br>
  {{store_phone}}<br>
  {{store_email}}<br>
  {{store_website}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  Date: {{date}}<br>
  Slip #: {{slip_number}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  {{items}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  Subtotal: {{currency_symbol}}{{total}}<br>
  Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
  Total: {{currency_symbol}}{{grand_total}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  {{footer_text}}
</div>', 
'Simple Fruits', '852 Simple Street, Easy City', '+1-555-0852', 'simple@fruits.com', 'www.simplefruits.com', 4.50, 'Rs', 'Simple and straightforward'),

-- 18. Receipt with Shadow
('Receipt with Shadow', 'Modern design with subtle shadow effect', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border:1px solid #000;padding:10px;box-shadow:4px 4px 0 #000;">
  <div style="text-align:center;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  {{items}}
  <hr style="border:none;border-top:1px solid #000;margin:5px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;">{{footer_text}}</div>
</div>', 
'Shadow Fruits', '963 Shadow Street, Depth City', '+1-555-0963', 'shadow@fruits.com', 'www.shadowfruits.com', 8.00, 'Rs', 'Fruits with depth'),

-- 19. Wide Margin
('Wide Margin', 'Generous margins for comfortable reading', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border:1px solid #000;padding:20px;">
  <div style="text-align:center;margin-bottom:10px;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <div style="margin-top:10px;">Date: {{date}}</div>
  <div>Slip #: {{slip_number}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:10px 0;">
  {{items}}
  <hr style="border:none;border-top:1px solid #000;margin:10px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;margin-top:10px;">{{footer_text}}</div>
</div>', 
'Margin Fruits', '147 Margin Street, Space City', '+1-555-0147', 'margin@fruits.com', 'www.marginfruits.com', 6.75, 'Rs', 'Comfortable reading experience'),

-- 20. Bold Top and Bottom Bars
('Bold Top and Bottom Bars', 'Strong top and bottom borders for framing', 
'<div style="max-width:320px;margin:auto;font-family:Arial,sans-serif;font-size:14px;color:#000;border-top:4px solid #000;border-bottom:4px solid #000;padding:10px;">
  <div style="text-align:center;margin-bottom:8px;">{{logo}}</div>
  <div style="text-align:center;">
    <strong>{{store_name}}</strong><br>
    {{store_address}}<br>
    {{store_phone}}<br>
    {{store_email}}<br>
    {{store_website}}
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div style="display:flex;justify-content:space-between;">
    <span>{{date}}</span><span>{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  {{items}}
  <hr style="border:none;border-top:1px solid #000;margin:6px 0;">
  <div style="text-align:right;">
    Subtotal: {{currency_symbol}}{{total}}<br>
    Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}<br>
    <strong>Total: {{currency_symbol}}{{grand_total}}</strong>
  </div>
  <div style="text-align:center;font-size:12px;margin-top:6px;">{{footer_text}}</div>
</div>', 
'Frame Fruits', '258 Frame Street, Border City', '+1-555-0258', 'frame@fruits.com', 'www.framefruits.com', 10.50, 'Rs', 'Framed in quality');

-- Note: All templates include the complete set of placeholders:
-- {{logo}}, {{store_name}}, {{store_address}}, {{store_phone}}, {{store_email}}, {{store_website}}
-- {{date}}, {{slip_number}}, {{items}}, {{total}}, {{grand_total}}, {{tax_amount}}, {{tax_rate}}, {{currency_symbol}}, {{footer_text}}
