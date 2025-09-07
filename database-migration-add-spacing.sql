-- =====================================================
-- ADD SPACING BETWEEN ROWS IN ALL TEMPLATES MIGRATION
-- Add proper spacing between receipt rows to reduce congestion
-- =====================================================

-- =====================================================
-- 1. ADD SPACING TO ITEM ROWS
-- =====================================================

-- Add margin to item rows with display:flex
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:5px 0;font-size:12px',
    'margin:8px 0;font-size:12px'
)
WHERE template_html LIKE '%margin:5px 0;font-size:12px%';

-- Add margin to item rows with display:flex (alternative pattern)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:2px 0;font-size:10px',
    'margin:6px 0;font-size:10px'
)
WHERE template_html LIKE '%margin:2px 0;font-size:10px%';

-- Add margin to item rows with display:flex (another pattern)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:1px 0;font-size:10px',
    'margin:4px 0;font-size:10px'
)
WHERE template_html LIKE '%margin:1px 0;font-size:10px%';

-- Add margin to item rows with display:flex (tight spacing)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:0;font-size:10px',
    'margin:3px 0;font-size:10px'
)
WHERE template_html LIKE '%margin:0;font-size:10px%';

-- =====================================================
-- 2. ADD SPACING TO HEADER SECTIONS
-- =====================================================

-- Add margin to store name headers
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:0;font-size:12px',
    'margin:0 0 8px 0;font-size:12px'
)
WHERE template_html LIKE '%margin:0;font-size:12px%';

-- Add margin to store name headers (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:2px 0;font-size:12px',
    'margin:4px 0 8px 0;font-size:12px'
)
WHERE template_html LIKE '%margin:2px 0;font-size:12px%';

-- Add margin to store info paragraphs
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:2px 0;font-size:9px',
    'margin:4px 0;font-size:9px'
)
WHERE template_html LIKE '%margin:2px 0;font-size:9px%';

-- Add margin to store info paragraphs (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:1px 0;font-size:9px',
    'margin:3px 0;font-size:9px'
)
WHERE template_html LIKE '%margin:1px 0;font-size:9px%';

-- =====================================================
-- 3. ADD SPACING TO DATE/SLIP NUMBER ROWS
-- =====================================================

-- Add margin to date/slip number rows
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:4px 0;font-size:9px',
    'margin:6px 0;font-size:9px'
)
WHERE template_html LIKE '%margin:4px 0;font-size:9px%';

-- Add margin to date/slip number rows (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:3px 0;font-size:9px',
    'margin:5px 0;font-size:9px'
)
WHERE template_html LIKE '%margin:3px 0;font-size:9px%';

-- =====================================================
-- 4. ADD SPACING TO TOTAL SECTIONS
-- =====================================================

-- Add margin to total rows
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:1px 0;font-size:10px',
    'margin:3px 0;font-size:10px'
)
WHERE template_html LIKE '%margin:1px 0;font-size:10px%';

-- Add margin to total rows (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:2px 0;font-size:10px',
    'margin:4px 0;font-size:10px'
)
WHERE template_html LIKE '%margin:2px 0;font-size:10px%';

-- =====================================================
-- 5. ADD SPACING TO HR (HORIZONTAL RULES)
-- =====================================================

-- Add margin to horizontal rules
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:4px 0;',
    'margin:8px 0;'
)
WHERE template_html LIKE '%margin:4px 0;%';

-- Add margin to horizontal rules (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:3px 0;',
    'margin:6px 0;'
)
WHERE template_html LIKE '%margin:3px 0;%';

-- Add margin to horizontal rules (tight)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin:2px 0;',
    'margin:5px 0;'
)
WHERE template_html LIKE '%margin:2px 0;%';

-- =====================================================
-- 6. ADD SPACING TO CONTAINER DIVS
-- =====================================================

-- Add margin to container divs
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin-bottom:4px;',
    'margin-bottom:8px;'
)
WHERE template_html LIKE '%margin-bottom:4px;%';

-- Add margin to container divs (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin-bottom:6px;',
    'margin-bottom:10px;'
)
WHERE template_html LIKE '%margin-bottom:6px;%';

-- Add margin to container divs (tight)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    'margin-bottom:2px;',
    'margin-bottom:6px;'
)
WHERE template_html LIKE '%margin-bottom:2px;%';

-- =====================================================
-- 7. ADD SPACING TO SPECIFIC PATTERNS
-- =====================================================

-- Add spacing to items section
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<div>{{items}}</div>',
    '<div style="margin:8px 0;">{{items}}</div>'
)
WHERE template_html LIKE '%<div>{{items}}</div>%';

-- Add spacing to totals section
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<div style="text-align:right;">',
    '<div style="text-align:right;margin:8px 0;">'
)
WHERE template_html LIKE '%<div style="text-align:right;">%';

-- Add spacing to date/slip section
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<div style="display:flex;justify-content:space-between;">',
    '<div style="display:flex;justify-content:space-between;margin:6px 0;">'
)
WHERE template_html LIKE '%<div style="display:flex;justify-content:space-between;">%';

-- =====================================================
-- 8. ADD SPACING TO BR TAGS
-- =====================================================

-- Replace single <br> with <br><br> for more spacing
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<br>',
    '<br><br>'
)
WHERE template_html LIKE '%<br>%';

-- =====================================================
-- 9. ADD SPACING TO PARAGRAPH TAGS
-- =====================================================

-- Add margin to paragraph tags
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<p style="margin:0;">',
    '<p style="margin:0 0 4px 0;">'
)
WHERE template_html LIKE '%<p style="margin:0;">%';

-- Add margin to paragraph tags (alternative)
UPDATE public.slip_formats 
SET template_html = REPLACE(
    template_html, 
    '<p style="margin:1px 0;">',
    '<p style="margin:3px 0;">'
)
WHERE template_html LIKE '%<p style="margin:1px 0;">%';

-- =====================================================
-- 10. VERIFICATION QUERIES
-- =====================================================

-- Check templates that have been updated
SELECT 
    name,
    CASE 
        WHEN template_html LIKE '%margin:8px 0%' THEN 'SPACING ADDED ✓'
        WHEN template_html LIKE '%margin:6px 0%' THEN 'SPACING ADDED ✓'
        WHEN template_html LIKE '%margin:4px 0%' THEN 'SPACING ADDED ✓'
        ELSE 'NEEDS SPACING'
    END as spacing_status,
    LENGTH(template_html) as template_length
FROM public.slip_formats 
ORDER BY spacing_status, name;

-- Count templates by spacing status
SELECT 
    spacing_status,
    COUNT(*) as count
FROM (
    SELECT 
        CASE 
            WHEN template_html LIKE '%margin:8px 0%' OR template_html LIKE '%margin:6px 0%' OR template_html LIKE '%margin:4px 0%' THEN 'SPACING_ADDED'
            ELSE 'NEEDS_SPACING'
        END as spacing_status
    FROM public.slip_formats
) as status_check
GROUP BY spacing_status;

-- Show sample of updated templates
SELECT 
    name,
    SUBSTRING(template_html, 1, 500) as template_start
FROM public.slip_formats 
WHERE template_html LIKE '%margin:8px 0%' OR template_html LIKE '%margin:6px 0%'
LIMIT 3;

-- =====================================================
-- 11. BACKUP QUERY (Optional - run before migration)
-- =====================================================

-- Uncomment the following lines to create a backup before running the migration
-- CREATE TABLE slip_formats_backup_before_spacing AS 
-- SELECT * FROM public.slip_formats;

-- =====================================================
-- MIGRATION SUMMARY
-- =====================================================

/*
This migration adds proper spacing between rows in all slip templates.

What it does:
1. Adds margin to item rows (5px → 8px, 2px → 6px, 1px → 4px)
2. Adds margin to header sections
3. Adds margin to date/slip number rows
4. Adds margin to total sections
5. Adds margin to horizontal rules
6. Adds margin to container divs
7. Adds spacing to specific patterns
8. Adds spacing to BR tags
9. Adds margin to paragraph tags
10. Provides verification queries

Expected result:
- All templates will have better spacing between rows
- Receipts will be less congested
- Better readability on thermal printers
- More professional appearance

Run this migration after the footer removal migration.
*/
