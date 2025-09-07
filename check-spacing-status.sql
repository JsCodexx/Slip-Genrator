-- =====================================================
-- CHECK CURRENT SPACING STATUS
-- Run this to see current spacing in templates
-- =====================================================

-- Check current spacing patterns in templates
SELECT 
    name,
    CASE 
        WHEN template_html LIKE '%margin:8px 0%' THEN 'GOOD SPACING ✓'
        WHEN template_html LIKE '%margin:6px 0%' THEN 'GOOD SPACING ✓'
        WHEN template_html LIKE '%margin:4px 0%' THEN 'GOOD SPACING ✓'
        WHEN template_html LIKE '%margin:2px 0%' THEN 'TIGHT SPACING'
        WHEN template_html LIKE '%margin:1px 0%' THEN 'VERY TIGHT SPACING'
        WHEN template_html LIKE '%margin:0%' THEN 'NO SPACING'
        ELSE 'MIXED SPACING'
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
            WHEN template_html LIKE '%margin:8px 0%' THEN 'GOOD_SPACING'
            WHEN template_html LIKE '%margin:6px 0%' THEN 'GOOD_SPACING'
            WHEN template_html LIKE '%margin:4px 0%' THEN 'GOOD_SPACING'
            WHEN template_html LIKE '%margin:2px 0%' THEN 'TIGHT_SPACING'
            WHEN template_html LIKE '%margin:1px 0%' THEN 'VERY_TIGHT_SPACING'
            WHEN template_html LIKE '%margin:0%' THEN 'NO_SPACING'
            ELSE 'MIXED_SPACING'
        END as spacing_status
    FROM public.slip_formats
) as status_check
GROUP BY spacing_status;

-- Show templates that need spacing improvement
SELECT 
    name,
    SUBSTRING(template_html, 1, 300) as template_start
FROM public.slip_formats 
WHERE template_html LIKE '%margin:1px 0%' OR template_html LIKE '%margin:2px 0%' OR template_html LIKE '%margin:0%'
LIMIT 5;
