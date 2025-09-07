-- =====================================================
-- CLEAN ALL TEMPLATES - REMOVE \f CHARACTERS (FIXED VERSION)
-- =====================================================
-- This migration removes all \f characters from template_html
-- in all slip_formats to fix thermal printer cutting issues
-- =====================================================

-- Check current templates for \f characters
SELECT 
  name,
  CASE 
    WHEN template_html LIKE '%\f%' THEN 'HAS \f CHARACTERS'
    WHEN template_html LIKE '%\\f%' THEN 'HAS \\f CHARACTERS'
    ELSE 'CLEAN ✓'
  END as f_status,
  LENGTH(template_html) as template_length
FROM public.slip_formats 
WHERE is_active = true
ORDER BY name;

-- Remove all \f characters from all templates (simple approach)
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, '\f', '')
WHERE template_html LIKE '%\f%';

-- Remove any double backslashes followed by f
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, '\\f', '')
WHERE template_html LIKE '%\\f%';

-- Remove any form feed characters (ASCII 12)
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, CHR(12), '')
WHERE template_html LIKE '%' || CHR(12) || '%';

-- Remove page-break-after CSS properties (simplified)
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'page-break-after: always;', '')
WHERE template_html LIKE '%page-break-after: always;%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'page-break-after:always;', '')
WHERE template_html LIKE '%page-break-after:always;%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'page-break-after: always', '')
WHERE template_html LIKE '%page-break-after: always%';

-- Remove break-after CSS properties
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'break-after: page;', '')
WHERE template_html LIKE '%break-after: page;%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'break-after:page;', '')
WHERE template_html LIKE '%break-after:page;%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'break-after: page', '')
WHERE template_html LIKE '%break-after: page%';

-- Remove content properties with \f
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'content: "\\f\\f\\f";', '')
WHERE template_html LIKE '%content: "\\f\\f\\f";%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'content:"\\f\\f\\f";', '')
WHERE template_html LIKE '%content:"\\f\\f\\f";%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, 'content: "\\f\\f\\f"', '')
WHERE template_html LIKE '%content: "\\f\\f\\f"%';

-- Remove any remaining empty CSS rules
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, '::after { }', '')
WHERE template_html LIKE '%::after { }%';

UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, '::after{}', '')
WHERE template_html LIKE '%::after{}%';

-- Clean up extra whitespace
UPDATE public.slip_formats 
SET template_html = TRIM(REGEXP_REPLACE(template_html, '\s+', ' ', 'g'))
WHERE template_html ~* '\s+';

-- Verify the cleanup
SELECT 
  name,
  CASE 
    WHEN template_html LIKE '%\f%' OR template_html LIKE '%\\f%' OR template_html LIKE '%' || CHR(12) || '%' THEN 'STILL HAS \f CHARACTERS'
    ELSE 'CLEAN ✓'
  END as f_status,
  LENGTH(template_html) as template_length
FROM public.slip_formats 
WHERE is_active = true
ORDER BY name;

-- Show count of cleaned templates
SELECT 
  COUNT(*) as total_templates,
  COUNT(CASE WHEN template_html NOT LIKE '%\f%' AND template_html NOT LIKE '%\\f%' AND template_html NOT LIKE '%' || CHR(12) || '%' THEN 1 END) as clean_templates,
  COUNT(CASE WHEN template_html LIKE '%\f%' OR template_html LIKE '%\\f%' OR template_html LIKE '%' || CHR(12) || '%' THEN 1 END) as templates_with_f
FROM public.slip_formats 
WHERE is_active = true;
