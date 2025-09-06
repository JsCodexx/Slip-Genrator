-- =====================================================
-- COMPLETE SLIP TEMPLATES - 80MM THERMAL PRINTER OPTIMIZED
-- All templates updated for 80mm thermal printer rolls
-- =====================================================

-- Clear existing templates
DELETE FROM public.slip_formats;

-- Insert optimized templates for 80mm thermal printers
INSERT INTO public.slip_formats (name, description, template_html, store_name, store_address, store_phone, store_email, store_website, tax_rate, currency_symbol, footer_text) VALUES

-- 1. Classic Receipt (Optimized for 80mm)
('Classic Receipt', 'Traditional receipt layout optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;font-size:10px;">
    <p style="margin:1px 0;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Fresh Market', '123 Main Street, City Center', '+1-555-0123', 'info@freshmarket.com', 'www.freshmarket.com', 8.50, 'Rs', 'Thank you for your business!'),

-- 2. Modern Receipt (Optimized for 80mm)
('Modern Receipt', 'Clean modern design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;font-size:10px;">
    <p style="margin:1px 0;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Urban Fresh', '456 Downtown Ave, Metro City', '+1-555-0456', 'hello@urbanfresh.com', 'www.urbanfresh.com', 7.25, 'Rs', 'Fresh & Fast!'),

-- 3. Minimalist Receipt (Optimized for 80mm)
('Minimalist Receipt', 'Simple clean design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;font-size:10px;">
    <p style="margin:1px 0;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Simple Store', '789 Simple Street, Easy Town', '+1-555-0789', 'simple@store.com', 'www.simplestore.com', 5.00, 'Rs', 'Keep it simple!'),

-- 4. Boxed Invoice Look (Optimized for 80mm)
('Boxed Invoice Look', 'Professional invoice-style layout optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:2px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="border:1px solid #000;padding:3mm;text-align:center;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:1px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:1px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:1px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:1px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <div style="margin-top:4px;border:1px solid #000;padding:3mm;">
    <div style="display:flex;justify-content:space-between;font-size:9px;">
      <span>{{date}}</span><span>{{slip_number}}</span>
    </div>
  </div>
  <div style="margin-top:4px;border:1px solid #000;padding:3mm;">{{items}}</div>
  <div style="margin-top:4px;border:1px solid #000;padding:3mm;text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="margin-top:4px;text-align:center;font-size:8px;">{{footer_text}}</div>
</div>', 
'Fruit Paradise', '321 Tropical Road, Beach City', '+1-555-0321', 'paradise@fruits.com', 'www.fruitparadise.com', 10.00, 'Rs', 'Visit us again soon!'),

-- 5. Modern Receipt Strip (Optimized for 80mm)
('Modern Receipt Strip', 'Contemporary design with left border accent optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border-left:4px solid #000;padding:4mm;">
  <div style="text-align:center;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:3px;">{{footer_text}}</div>
</div>', 
'Fresh Harvest Market', '654 Farm Road, Country Side', '+1-555-0654', 'harvest@freshmarket.com', 'www.freshharvest.com', 6.25, 'Rs', 'Fresh from the farm!'),

-- 6. Classic Cafe Look (Optimized for 80mm)
('Classic Cafe Look', 'Vintage cafe-style receipt optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Corner Cafe', '987 Coffee Street, Morning City', '+1-555-0987', 'coffee@cornercafe.com', 'www.cornercafe.com', 8.75, 'Rs', 'Brewed with love!'),

-- 7. Elegant Receipt (Optimized for 80mm)
('Elegant Receipt', 'Sophisticated design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Elegant Store', '555 Luxury Lane, Premium City', '+1-555-0555', 'elegant@store.com', 'www.elegantstore.com', 12.50, 'Rs', 'Elegance in every detail!'),

-- 8. Bold Receipt (Optimized for 80mm)
('Bold Receipt', 'Strong bold design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:2px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:2px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:2px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Bold Market', '777 Power Street, Strong City', '+1-555-0777', 'bold@market.com', 'www.boldmarket.com', 9.25, 'Rs', 'Bold & Fresh!'),

-- 9. Clean Receipt (Optimized for 80mm)
('Clean Receipt', 'Ultra clean design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Clean Store', '888 Pure Street, Clean City', '+1-555-0888', 'clean@store.com', 'www.cleanstore.com', 6.50, 'Rs', 'Clean & Pure!'),

-- 10. Premium Receipt (Optimized for 80mm)
('Premium Receipt', 'High-end design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:3px double #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Premium Market', '999 Elite Street, Luxury City', '+1-555-0999', 'premium@market.com', 'www.premiummarket.com', 15.00, 'Rs', 'Premium Quality!'),

-- 11. Simple Receipt (Optimized for 80mm)
('Simple Receipt', 'Basic simple design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Simple Store', '111 Basic Street, Simple City', '+1-555-0111', 'simple@store.com', 'www.simplestore.com', 5.00, 'Rs', 'Simply the best!'),

-- 12. Professional Receipt (Optimized for 80mm)
('Professional Receipt', 'Business professional design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:2px dashed #000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Professional Store', '222 Business Street, Corporate City', '+1-555-0222', 'pro@store.com', 'www.prostore.com', 8.75, 'Rs', 'Professional Service!'),

-- 13. Compact Receipt (Optimized for 80mm)
('Compact Receipt', 'Space-efficient design optimized for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;border:1px solid #000;padding:3mm;">
  <div style="text-align:center;margin-bottom:4px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:3px;">
    <h2 style="margin:0;font-size:11px;">{{store_name}}</h2>
    <p style="margin:1px 0;font-size:8px;">{{store_address}}</p>
    <p style="margin:1px 0;font-size:8px;">Tel: {{store_phone}}</p>
    <p style="margin:1px 0;font-size:8px;">Email: {{store_email}}</p>
    <p style="margin:1px 0;font-size:8px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="display:flex;justify-content:space-between;font-size:8px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="font-size:9px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:3px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:9px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:9px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:9px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:7px;margin-top:3px;">{{footer_text}}</div>
</div>', 
'Compact Store', '333 Space Street, Efficient City', '+1-555-0333', 'compact@store.com', 'www.compactstore.com', 4.50, 'Rs', 'Compact & Efficient!'),

-- 14. Thermal Optimized Receipt (Optimized for 80mm)
('Thermal Optimized Receipt', 'Specifically designed for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:10px;color:#000;padding:4mm;">
  <div style="text-align:center;margin-bottom:6px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:4px;">
    <h2 style="margin:0;font-size:12px;">{{store_name}}</h2>
    <p style="margin:2px 0;font-size:9px;">{{store_address}}</p>
    <p style="margin:2px 0;font-size:9px;">Tel: {{store_phone}}</p>
    <p style="margin:2px 0;font-size:9px;">Email: {{store_email}}</p>
    <p style="margin:2px 0;font-size:9px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="display:flex;justify-content:space-between;font-size:9px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="font-size:10px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:4px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:10px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:10px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:10px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:8px;margin-top:4px;">{{footer_text}}</div>
</div>', 
'Thermal Store', '444 Print Street, Thermal City', '+1-555-0444', 'thermal@store.com', 'www.thermalstore.com', 7.00, 'Rs', 'Thermal Perfect!'),

-- 15. Ultra Compact Receipt (Optimized for 80mm)
('Ultra Compact Receipt', 'Maximum space efficiency for 80mm thermal printers', 
'<div style="width:80mm;margin:auto;font-family:Courier New,monospace;font-size:9px;color:#000;padding:3mm;">
  <div style="text-align:center;margin-bottom:3px;">{{logo}}</div>
  <div style="text-align:center;margin-bottom:2px;">
    <h2 style="margin:0;font-size:10px;">{{store_name}}</h2>
    <p style="margin:1px 0;font-size:7px;">{{store_address}}</p>
    <p style="margin:1px 0;font-size:7px;">Tel: {{store_phone}}</p>
    <p style="margin:1px 0;font-size:7px;">Email: {{store_email}}</p>
    <p style="margin:1px 0;font-size:7px;">Web: {{store_website}}</p>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:2px 0;">
  <div style="display:flex;justify-content:space-between;font-size:7px;">
    <span>Date: {{date}}</span><span>#{{slip_number}}</span>
  </div>
  <hr style="border:none;border-top:1px solid #000;margin:2px 0;">
  <div style="font-size:8px;">{{items}}</div>
  <hr style="border:none;border-top:1px solid #000;margin:2px 0;">
  <div style="text-align:right;">
    <p style="margin:1px 0;font-size:8px;">Subtotal: {{currency_symbol}}{{total}}</p>
    <p style="margin:1px 0;font-size:8px;">Tax ({{tax_rate}}%): {{currency_symbol}}{{tax_amount}}</p>
    <p style="margin:1px 0;font-size:8px;font-weight:bold;">Total: {{currency_symbol}}{{grand_total}}</p>
  </div>
  <div style="text-align:center;font-size:6px;margin-top:2px;">{{footer_text}}</div>
</div>', 
'Ultra Store', '555 Micro Street, Mini City', '+1-555-0555', 'ultra@store.com', 'www.ultrastore.com', 3.50, 'Rs', 'Ultra Compact!');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check that all templates now use 80mm width
SELECT 
    name,
    CASE 
        WHEN template_html LIKE '%width:80mm%' THEN '80mm ✓'
        WHEN template_html LIKE '%width:320px%' OR template_html LIKE '%max-width:320px%' THEN '320px (NEEDS UPDATE)'
        ELSE 'Other'
    END as width_status
FROM public.slip_formats 
ORDER BY width_status, name;

-- Count templates by width status
SELECT 
    width_status,
    COUNT(*) as count
FROM (
    SELECT 
        CASE 
            WHEN template_html LIKE '%width:80mm%' THEN '80mm ✓'
            WHEN template_html LIKE '%width:320px%' OR template_html LIKE '%max-width:320px%' THEN '320px (NEEDS UPDATE)'
            ELSE 'Other'
        END as width_status
    FROM public.slip_formats
) as status_check
GROUP BY width_status;
