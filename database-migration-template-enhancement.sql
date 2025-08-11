-- =====================================================
-- TEMPLATE ENHANCEMENT MIGRATION
-- Add logo and store details to slip_formats table
-- =====================================================

-- Add new columns to slip_formats table
ALTER TABLE public.slip_formats 
ADD COLUMN IF NOT EXISTS logo_data TEXT, -- Base64 encoded image data
ADD COLUMN IF NOT EXISTS logo_type TEXT, -- MIME type of the image
ADD COLUMN IF NOT EXISTS store_name TEXT, -- Store name for the template
ADD COLUMN IF NOT EXISTS store_address TEXT, -- Store address
ADD COLUMN IF NOT EXISTS store_phone TEXT, -- Store phone number
ADD COLUMN IF NOT EXISTS store_email TEXT, -- Store email
ADD COLUMN IF NOT EXISTS store_website TEXT, -- Store website
ADD COLUMN IF NOT EXISTS tax_rate DECIMAL(5,2) DEFAULT 0.00, -- Tax rate percentage
ADD COLUMN IF NOT EXISTS currency_symbol TEXT DEFAULT 'Rs', -- Currency symbol
ADD COLUMN IF NOT EXISTS footer_text TEXT; -- Custom footer text

-- Add comments for documentation
COMMENT ON COLUMN public.slip_formats.logo_data IS 'Base64 encoded logo image data';
COMMENT ON COLUMN public.slip_formats.logo_type IS 'MIME type of the logo image (e.g., image/png, image/jpeg)';
COMMENT ON COLUMN public.slip_formats.store_name IS 'Store name to display on slips using this template';
COMMENT ON COLUMN public.slip_formats.store_address IS 'Store address to display on slips using this template';
COMMENT ON COLUMN public.slip_formats.store_phone IS 'Store phone number to display on slips using this template';
COMMENT ON COLUMN public.slip_formats.store_email IS 'Store email to display on slips using this template';
COMMENT ON COLUMN public.slip_formats.store_website IS 'Store website to display on slips using this template';
COMMENT ON COLUMN public.slip_formats.tax_rate IS 'Tax rate percentage for this template';
COMMENT ON COLUMN public.slip_formats.currency_symbol IS 'Currency symbol to use for this template';
COMMENT ON COLUMN public.slip_formats.footer_text IS 'Custom footer text for this template';

-- Create index for better performance on store name searches
CREATE INDEX IF NOT EXISTS idx_slip_formats_store_name ON public.slip_formats(store_name);

-- Update existing templates with default values
UPDATE public.slip_formats 
SET 
    store_name = COALESCE(store_name, name),
    store_address = COALESCE(store_address, 'Fresh Produce & Quality Goods'),
    store_phone = COALESCE(store_phone, '+1234567890'),
    currency_symbol = COALESCE(currency_symbol, 'Rs')
WHERE store_name IS NULL;

-- Add trigger to update updated_at when new columns are modified
CREATE OR REPLACE FUNCTION update_slip_formats_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_slip_formats_updated_at ON public.slip_formats;

-- Create new trigger
CREATE TRIGGER update_slip_formats_updated_at
    BEFORE UPDATE ON public.slip_formats
    FOR EACH ROW EXECUTE FUNCTION update_slip_formats_updated_at();
