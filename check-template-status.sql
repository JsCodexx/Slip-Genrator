-- =====================================================
-- CHECK CURRENT TEMPLATE STATUS
-- Run this FIRST to see what needs to be done
-- =====================================================

-- Check which templates still have footer_text
SELECT 
    name,
    CASE 
        WHEN template_html LIKE '%{{footer_text}}%' THEN 'HAS FOOTER_TEXT (NEEDS CLEANUP)'
        ELSE 'FOOTER REMOVED ✓'
    END as footer_status,
    LENGTH(template_html) as template_length
FROM public.slip_formats 
ORDER BY footer_status, name;

-- Count templates by footer status
SELECT 
    footer_status,
    COUNT(*) as count
FROM (
    SELECT 
        CASE 
            WHEN template_html LIKE '%{{footer_text}}%' THEN 'HAS FOOTER_TEXT'
            ELSE 'FOOTER_REMOVED'
        END as footer_status
    FROM public.slip_formats
) as status_check
GROUP BY footer_status;

-- Show sample templates that still have footer_text (if any)
SELECT 
    name,
    SUBSTRING(template_html, LENGTH(template_html) - 300, 300) as template_end
FROM public.slip_formats 
WHERE template_html LIKE '%{{footer_text}}%'
LIMIT 5;
