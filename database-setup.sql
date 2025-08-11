-- =====================================================
-- SLIP GENERATION PLATFORM - COMPLETE DATABASE SETUP
-- =====================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. PROFILES TABLE (User Management)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT profiles_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 2. SLIP FORMATS TABLE (20 Different Slip Templates)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.slip_formats (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    template_html TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT slip_formats_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 3. FRUITS TABLE (Product Catalog with Price Ranges)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.fruits (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    base_price DECIMAL(10,2) NOT NULL,
    max_price DECIMAL(10,2) NOT NULL,
    unit TEXT NOT NULL DEFAULT 'kg',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fruits_pkey PRIMARY KEY (id),
    CONSTRAINT fruits_price_check CHECK (max_price >= base_price AND base_price > 0)
);

-- =====================================================
-- 4. SLIPS TABLE (Main Slip Records)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.slips (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    format_id UUID NOT NULL,
    serial_number TEXT NOT NULL UNIQUE,
    slip_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    items_count INTEGER NOT NULL DEFAULT 0,
    print_count INTEGER DEFAULT 0,
    status TEXT DEFAULT 'generated' CHECK (status IN ('generated', 'printed', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT slips_pkey PRIMARY KEY (id),
    CONSTRAINT slips_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    CONSTRAINT slips_format_id_fkey FOREIGN KEY (format_id) REFERENCES slip_formats(id) ON DELETE RESTRICT
);

-- =====================================================
-- 5. SLIP ITEMS TABLE (Individual Items on Each Slip)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.slip_items (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    slip_id UUID NOT NULL,
    fruit_id UUID NOT NULL,
    quantity DECIMAL(10,3) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT slip_items_pkey PRIMARY KEY (id),
    CONSTRAINT slip_items_slip_id_fkey FOREIGN KEY (slip_id) REFERENCES slips(id) ON DELETE CASCADE,
    CONSTRAINT slip_items_fruit_id_fkey FOREIGN KEY (fruit_id) REFERENCES fruits(id) ON DELETE RESTRICT,
    CONSTRAINT slip_items_quantity_check CHECK (quantity > 0),
    CONSTRAINT slip_items_price_check CHECK (unit_price > 0 AND total_price > 0)
);

-- =====================================================
-- 6. GENERIC SLIPS TABLE (For Other Document Types)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.generic_slips (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    serial_number TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    content TEXT,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT generic_slips_pkey PRIMARY KEY (id),
    CONSTRAINT generic_slips_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Profiles indexes
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- Slip formats indexes
CREATE INDEX IF NOT EXISTS idx_slip_formats_active ON public.slip_formats(is_active);

-- Fruits indexes
CREATE INDEX IF NOT EXISTS idx_fruits_active ON public.fruits(is_active);
CREATE INDEX IF NOT EXISTS idx_fruits_name ON public.fruits(name);

-- Slips indexes
CREATE INDEX IF NOT EXISTS idx_slips_user_id ON public.slips(user_id);
CREATE INDEX IF NOT EXISTS idx_slips_format_id ON public.slips(format_id);
CREATE INDEX IF NOT EXISTS idx_slips_serial_number ON public.slips(serial_number);
CREATE INDEX IF NOT EXISTS idx_slips_date ON public.slips(slip_date);
CREATE INDEX IF NOT EXISTS idx_slips_status ON public.slips(status);
CREATE INDEX IF NOT EXISTS idx_slips_created_at ON public.slips(created_at);

-- Slip items indexes
CREATE INDEX IF NOT EXISTS idx_slip_items_slip_id ON public.slip_items(slip_id);
CREATE INDEX IF NOT EXISTS idx_slip_items_fruit_id ON public.slip_items(fruit_id);

-- Generic slips indexes
CREATE INDEX IF NOT EXISTS idx_generic_slips_user_id ON public.generic_slips(user_id);
CREATE INDEX IF NOT EXISTS idx_generic_slips_serial_number ON public.generic_slips(serial_number);
CREATE INDEX IF NOT EXISTS idx_generic_slips_status ON public.generic_slips(status);
CREATE INDEX IF NOT EXISTS idx_generic_slips_created_at ON public.generic_slips(created_at);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to generate unique serial numbers
CREATE OR REPLACE FUNCTION generate_serial_number()
RETURNS TEXT AS $$
DECLARE
    new_serial TEXT;
    counter INTEGER := 1;
BEGIN
    LOOP
        -- Format: SLIP-YYYYMMDD-XXXX (e.g., SLIP-20241201-0001)
        new_serial := 'SLIP-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
        
        -- Check if this serial number already exists
        IF NOT EXISTS (SELECT 1 FROM public.slips WHERE serial_number = new_serial) THEN
            RETURN new_serial;
        END IF;
        
        counter := counter + 1;
        
        -- Safety check to prevent infinite loop
        IF counter > 9999 THEN
            RAISE EXCEPTION 'Unable to generate unique serial number after 9999 attempts';
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate slip total
CREATE OR REPLACE FUNCTION calculate_slip_total(slip_uuid UUID)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    total DECIMAL(12,2) := 0;
BEGIN
    SELECT COALESCE(SUM(total_price), 0)
    INTO total
    FROM public.slip_items
    WHERE slip_id = slip_uuid;
    
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Function to update slip totals
CREATE OR REPLACE FUNCTION update_slip_totals()
RETURNS TRIGGER AS $$
BEGIN
    -- Update total_amount and items_count when slip_items change
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE public.slips 
        SET 
            total_amount = calculate_slip_total(NEW.slip_id),
            items_count = (
                SELECT COUNT(*) 
                FROM public.slip_items 
                WHERE slip_id = NEW.slip_id
            ),
            updated_at = NOW()
        WHERE id = NEW.slip_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.slips 
        SET 
            total_amount = calculate_slip_total(OLD.slip_id),
            items_count = (
                SELECT COUNT(*) 
                FROM public.slip_items 
                WHERE slip_id = OLD.slip_id
            ),
            updated_at = NOW()
        WHERE id = OLD.slip_id;
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Update updated_at columns
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_slip_formats_updated_at ON public.slip_formats;
CREATE TRIGGER update_slip_formats_updated_at
    BEFORE UPDATE ON public.slip_formats
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_fruits_updated_at ON public.fruits;
CREATE TRIGGER update_fruits_updated_at
    BEFORE UPDATE ON public.fruits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_slips_updated_at ON public.slips;
CREATE TRIGGER update_slips_updated_at
    BEFORE UPDATE ON public.slips
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_generic_slips_updated_at ON public.generic_slips;
CREATE TRIGGER update_generic_slips_updated_at
    BEFORE UPDATE ON public.generic_slips
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Update slip totals when items change
DROP TRIGGER IF EXISTS update_slip_totals_trigger ON public.slip_items;
CREATE TRIGGER update_slip_totals_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.slip_items
    FOR EACH ROW EXECUTE FUNCTION update_slip_totals();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slip_formats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fruits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.slip_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.generic_slips ENABLE ROW LEVEL SECURITY;

-- Profiles policies
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Slip formats policies (read-only for all authenticated users)
DROP POLICY IF EXISTS "Authenticated users can view slip formats" ON public.slip_formats;
CREATE POLICY "Authenticated users can view slip formats" ON public.slip_formats
    FOR SELECT USING (auth.role() = 'authenticated');

-- Fruits policies (read-only for all authenticated users)
DROP POLICY IF EXISTS "Authenticated users can view fruits" ON public.fruits;
CREATE POLICY "Authenticated users can view fruits" ON public.fruits
    FOR SELECT USING (auth.role() = 'authenticated');

-- Slips policies
DROP POLICY IF EXISTS "Users can view their own slips" ON public.slips;
CREATE POLICY "Users can view their own slips" ON public.slips
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own slips" ON public.slips;
CREATE POLICY "Users can insert their own slips" ON public.slips
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own slips" ON public.slips;
CREATE POLICY "Users can update their own slips" ON public.slips
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own slips" ON public.slips;
CREATE POLICY "Users can delete their own slips" ON public.slips
    FOR DELETE USING (auth.uid() = user_id);

-- Slip items policies
DROP POLICY IF EXISTS "Users can view items of their own slips" ON public.slip_items;
CREATE POLICY "Users can view items of their own slips" ON public.slip_items
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.slips 
            WHERE id = slip_id AND user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can insert items to their own slips" ON public.slip_items;
CREATE POLICY "Users can insert items to their own slips" ON public.slip_items
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.slips 
            WHERE id = slip_id AND user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can update items of their own slips" ON public.slip_items;
CREATE POLICY "Users can update items of their own slips" ON public.slip_items
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.slips 
            WHERE id = slip_id AND user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can delete items of their own slips" ON public.slip_items;
CREATE POLICY "Users can delete items of their own slips" ON public.slip_items
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.slips 
            WHERE id = slip_id AND user_id = auth.uid()
        )
    );

-- Generic slips policies
DROP POLICY IF EXISTS "Users can view their own generic slips" ON public.generic_slips;
CREATE POLICY "Users can view their own generic slips" ON public.generic_slips
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own generic slips" ON public.generic_slips;
CREATE POLICY "Users can insert their own generic slips" ON public.generic_slips
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own generic slips" ON public.generic_slips;
CREATE POLICY "Users can update their own generic slips" ON public.generic_slips
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own generic slips" ON public.generic_slips;
CREATE POLICY "Users can delete their own generic slips" ON public.generic_slips
    FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert sample slip formats (10 different templates)
INSERT INTO public.slip_formats (name, description, template_html) VALUES
('Classic Receipt', 'Traditional receipt format with company header', 
'<div class="receipt classic">
  <div class="brand">
    <div class="logo">{company_name}</div>
    <div class="logo" style="font-size:11px;font-weight:500">{company_name_upper} LTD</div>
    <div class="logo" style="font-size:10px;font-weight:300;margin-top:6px">Fresh Produce & Quality Goods</div>
  </div>
  <div class="meta">
    <div class="meta-left">
      <div>Date: <b>{date}</b></div>
      <div>Time: <b>{time}</b></div>
    </div>
    <div style="margin-top:6px">RECEIPT: <b>{serial_number}</b></div>
  </div>
  <div class="divider"></div>
  <div class="items">{items}</div>
  <div class="totals">
    <div class="row"><div class="small">Items Sold:</div><div>{items_count}</div></div>
    <div class="row"><div class="small">Total:</div><div>Rs {total_amount}</div></div>
    <div class="row"><div class="small">Cash:</div><div>Rs {cash_amount}</div></div>
    <div class="row"><div class="small">Change Due:</div><div>Rs {change_amount}</div></div>
  </div>
  <div class="foot">
    <div class="thanks">Thank you for shopping at {company_name}</div>
    <div class="small-print">Fresh produce, quality goods, and all your daily essentials in one place.</div>
    <div class="small-print" style="margin-top:6px">Please keep this copy for your records.</div>
  </div>
</div>'),

('Modern Slip', 'Clean modern design with better spacing', 
'<div class="receipt modern">
  <div class="header-modern">
    <h1 class="company-title">{company_name}</h1>
    <p class="company-subtitle">Premium Fresh Fruits & Vegetables</p>
  </div>
  <div class="info-modern">
    <div class="info-row">
      <span class="label">Receipt #:</span>
      <span class="value">{serial_number}</span>
    </div>
    <div class="info-row">
      <span class="label">Date:</span>
      <span class="value">{date}</span>
    </div>
    <div class="info-row">
      <span class="label">Time:</span>
      <span class="value">{time}</span>
    </div>
  </div>
  <div class="items-modern">{items}</div>
  <div class="summary-modern">
    <div class="summary-row">
      <span>Total Items:</span>
      <span>{items_count}</span>
    </div>
    <div class="summary-row total">
      <span>Total Amount:</span>
      <span>Rs {total_amount}</span>
    </div>
  </div>
  <div class="footer-modern">
    <p>Thank you for choosing {company_name}!</p>
    <small>Quality guaranteed • Fresh daily • Best prices</small>
  </div>
</div>'),

('Compact Slip', 'Space-efficient format for small items', 
'<div class="receipt compact">
  <div class="compact-header">
    <h3>{company_name}</h3>
    <p class="compact-sub">Quick Service</p>
  </div>
  <div class="compact-info">
    <span class="compact-id">#{serial_number}</span>
    <span class="compact-date">{date} {time}</span>
  </div>
  <div class="compact-items">{items}</div>
  <div class="compact-total">
    <span>Total: Rs {total_amount}</span>
    <span>Items: {items_count}</span>
  </div>
  <div class="compact-footer">
    <p>Thanks! Visit again</p>
  </div>
</div>'),

('Premium Slip', 'Luxury format with premium styling', 
'<div class="receipt premium">
  <div class="premium-header">
    <div class="premium-logo">
      <h2>★ {company_name} ★</h2>
      <p class="premium-tagline">Excellence in Every Bite</p>
    </div>
  </div>
  <div class="premium-details">
    <div class="detail-group">
      <div class="detail-item">
        <label>Receipt Number:</label>
        <span class="premium-value">{serial_number}</span>
      </div>
      <div class="detail-item">
        <label>Transaction Date:</label>
        <span class="premium-value">{date}</span>
      </div>
      <div class="detail-item">
        <label>Transaction Time:</label>
        <span class="premium-value">{time}</span>
      </div>
    </div>
  </div>
  <div class="premium-items">{items}</div>
  <div class="premium-summary">
    <div class="summary-line">
      <span>Quantity of Items:</span>
      <span class="premium-number">{items_count}</span>
    </div>
    <div class="summary-line total-line">
      <span>Total Amount:</span>
      <span class="premium-total">Rs {total_amount}</span>
    </div>
  </div>
  <div class="premium-footer">
    <p class="premium-thanks">We appreciate your business</p>
    <p class="premium-motto">Quality • Freshness • Excellence</p>
  </div>
</div>'),

('Simple Slip', 'Minimalist design', 
'<div class="receipt simple">
  <div class="simple-title">
    <h4>{company_name}</h4>
  </div>
  <div class="simple-details">
    <div>Receipt: {serial_number}</div>
    <div>{date} at {time}</div>
  </div>
  <div class="simple-items">{items}</div>
  <div class="simple-total">
    <div>Items: {items_count}</div>
    <div>Total: Rs {total_amount}</div>
  </div>
  <div class="simple-end">
    <p>Thank you</p>
  </div>
</div>'),

('Business Slip', 'Professional business format', 
'<div class="receipt business">
  <div class="business-header">
    <h2>{company_name}</h2>
    <p class="business-subtitle">Professional Fruit & Vegetable Services</p>
  </div>
  <div class="business-info">
    <table class="info-table">
      <tr><td>Receipt ID:</td><td>{serial_number}</td></tr>
      <tr><td>Date:</td><td>{date}</td></tr>
      <tr><td>Time:</td><td>{time}</td></tr>
    </table>
  </div>
  <div class="business-items">{items}</div>
  <div class="business-summary">
    <table class="summary-table">
      <tr><td>Total Items:</td><td>{items_count}</td></tr>
      <tr class="total-row"><td>Total Amount:</td><td>Rs {total_amount}</td></tr>
    </table>
  </div>
  <div class="business-footer">
    <p>Thank you for your business</p>
    <small>Professional service guaranteed</small>
  </div>
</div>'),

('Casual Slip', 'Friendly casual format', 
'<div class="receipt casual">
  <div class="casual-header">
    <h3>🍎 {company_name} 🍎</h3>
    <p class="casual-greeting">Hey there! Thanks for stopping by!</p>
  </div>
  <div class="casual-details">
    <div class="casual-info">
      <span>Receipt: {serial_number}</span>
      <span>{date} • {time}</span>
    </div>
  </div>
  <div class="casual-items">{items}</div>
  <div class="casual-total">
    <div class="casual-summary">
      <span>You got {items_count} items</span>
      <span>Total: Rs {total_amount}</span>
    </div>
  </div>
  <div class="casual-footer">
    <p>😊 Come back soon!</p>
    <small>Fresh fruits, friendly service!</small>
  </div>
</div>'),

('Formal Slip', 'Formal business format', 
'<div class="receipt formal">
  <div class="formal-header">
    <h2>{company_name}</h2>
    <p class="formal-subtitle">Established Fruit & Vegetable Merchants</p>
  </div>
  <div class="formal-details">
    <div class="formal-info">
      <div class="info-field">
        <label>Transaction Reference:</label>
        <span>{serial_number}</span>
      </div>
      <div class="info-field">
        <label>Transaction Date:</label>
        <span>{date}</span>
      </div>
      <div class="info-field">
        <label>Transaction Time:</label>
        <span>{time}</span>
      </div>
    </div>
  </div>
  <div class="formal-items">{items}</div>
  <div class="formal-summary">
    <div class="summary-section">
      <div class="summary-item">
        <span>Number of Items:</span>
        <span>{items_count}</span>
      </div>
      <div class="summary-item total">
        <span>Total Transaction Amount:</span>
        <span>Rs {total_amount}</span>
      </div>
    </div>
  </div>
  <div class="formal-footer">
    <p>We appreciate your continued patronage</p>
    <small>Quality products, professional service</small>
  </div>
</div>'),

('Colorful Slip', 'Vibrant colorful design', 
'<div class="receipt colorful">
  <div class="colorful-header">
    <h2 class="rainbow-text">🌈 {company_name} 🌈</h2>
    <p class="colorful-subtitle">Bringing Color to Your Day!</p>
  </div>
  <div class="colorful-details">
    <div class="colorful-info">
      <div class="colorful-item">
        <span class="color-label">Receipt #:</span>
        <span class="color-value">{serial_number}</span>
      </div>
      <div class="colorful-item">
        <span class="color-label">Date:</span>
        <span class="color-value">{date}</span>
      </div>
      <div class="colorful-item">
        <span class="color-label">Time:</span>
        <span class="color-value">{time}</span>
      </div>
    </div>
  </div>
  <div class="colorful-items">{items}</div>
  <div class="colorful-summary">
    <div class="colorful-total">
      <span>Items: {items_count}</span>
      <span class="total-highlight">Total: Rs {total_amount}</span>
    </div>
  </div>
  <div class="colorful-footer">
    <p>🎉 Thanks for shopping with us! 🎉</p>
    <small>Colorful fruits, happy life!</small>
  </div>
</div>'),

('Elegant Slip', 'Sophisticated elegant format', 
'<div class="receipt elegant">
  <div class="elegant-header">
    <div class="elegant-logo">
      <h2>✧ {company_name} ✧</h2>
      <p class="elegant-tagline">Where Elegance Meets Freshness</p>
    </div>
  </div>
  <div class="elegant-details">
    <div class="elegant-info">
      <div class="elegant-field">
        <label>Receipt Number:</label>
        <span class="elegant-value">{serial_number}</span>
      </div>
      <div class="elegant-field">
        <label>Date of Purchase:</label>
        <span class="elegant-value">{date}</span>
      </div>
      <div class="elegant-field">
        <label>Time of Purchase:</label>
        <span class="elegant-value">{time}</span>
      </div>
    </div>
  </div>
  <div class="elegant-items">{items}</div>
  <div class="elegant-summary">
    <div class="elegant-summary-content">
      <div class="elegant-line">
        <span>Items Purchased:</span>
        <span class="elegant-number">{items_count}</span>
      </div>
      <div class="elegant-line total-elegant">
        <span>Total Purchase Amount:</span>
        <span class="elegant-total">Rs {total_amount}</span>
      </div>
    </div>
  </div>
  <div class="elegant-footer">
    <p class="elegant-thanks">We are honored by your choice</p>
    <p class="elegant-motto">Elegance • Quality • Sophistication</p>
  </div>
</div>')
ON CONFLICT (name) DO NOTHING;

-- Insert sample fruits with price ranges
INSERT INTO public.fruits (name, base_price, max_price, unit) VALUES
('Apple', 120.00, 180.00, 'kg'),
('Banana', 80.00, 120.00, 'kg'),
('Orange', 100.00, 150.00, 'kg'),
('Mango', 150.00, 250.00, 'kg'),
('Grapes', 200.00, 300.00, 'kg'),
('Pineapple', 120.00, 200.00, 'piece'),
('Watermelon', 80.00, 150.00, 'kg'),
('Strawberry', 300.00, 500.00, 'kg'),
('Kiwi', 250.00, 400.00, 'kg'),
('Peach', 180.00, 280.00, 'kg'),
('Pear', 160.00, 240.00, 'kg'),
('Plum', 200.00, 320.00, 'kg'),
('Cherry', 400.00, 600.00, 'kg'),
('Blueberry', 350.00, 550.00, 'kg'),
('Raspberry', 380.00, 580.00, 'kg'),
('Blackberry', 320.00, 480.00, 'kg'),
('Cranberry', 280.00, 420.00, 'kg'),
('Apricot', 220.00, 340.00, 'kg'),
('Nectarine', 200.00, 300.00, 'kg'),
('Fig', 300.00, 450.00, 'kg')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE public.profiles IS 'User profile information for authentication and user management';
COMMENT ON TABLE public.slip_formats IS 'Available slip templates and formats for generating different slip styles';
COMMENT ON TABLE public.fruits IS 'Product catalog with base and maximum prices for random price generation';
COMMENT ON TABLE public.slips IS 'Main slip records with format, date, and total information';
COMMENT ON TABLE public.slip_items IS 'Individual items on each slip with quantities and prices';
COMMENT ON TABLE public.generic_slips IS 'Generic slip documents for other document types (separate from POS slips)';

COMMENT ON FUNCTION generate_serial_number() IS 'Generates unique serial numbers in format SLIP-YYYYMMDD-XXXX';
COMMENT ON FUNCTION calculate_slip_total(UUID) IS 'Calculates total amount for a given slip based on its items';
COMMENT ON FUNCTION update_slip_totals() IS 'Trigger function to automatically update slip totals when items change';

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify tables were created
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verify functions were created
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
ORDER BY routine_name;

-- Verify triggers were created
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers 
WHERE trigger_schema = 'public' 
ORDER BY trigger_name;

-- Verify sample data was inserted
SELECT 'slip_formats' as table_name, COUNT(*) as record_count FROM public.slip_formats
UNION ALL
SELECT 'fruits' as table_name, COUNT(*) as record_count FROM public.fruits;
