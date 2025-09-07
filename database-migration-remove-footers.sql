-- =====================================================
-- REMOVE FOOTER SECTIONS FROM ALL TEMPLATES MIGRATION
-- Remove footer divs containing {{footer_text}} from all slip templates
-- =====================================================

-- =====================================================
-- 1. REMOVE FOOTER SECTIONS FROM ALL TEMPLATES
-- =====================================================

-- Remove footer divs with various styling patterns
-- Pattern 1: Simple footer div with text-align:center
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*text-align:center[^>]*font-size:[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 2: Footer div with margin-top
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*margin-top[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 3: Footer div with any styling containing footer_text
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 4: Footer div with font-size specification
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*font-size:[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 5: Footer div with text-align specification
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*text-align:[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 6: Footer div with margin specifications
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*margin:[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 7: Footer div with padding specifications
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*padding:[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- Pattern 8: Any remaining footer divs with footer_text
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- =====================================================
-- 2. CLEAN UP ANY REMAINING FOOTER_TEXT PLACEHOLDERS
-- =====================================================

-- Remove any standalone {{footer_text}} placeholders that might remain
UPDATE public.slip_formats 
SET template_html = REPLACE(template_html, '{{footer_text}}', '')
WHERE template_html LIKE '%{{footer_text}}%';

-- =====================================================
-- 3. CLEAN UP EXTRA WHITESPACE AND LINE BREAKS
-- =====================================================

-- Remove extra whitespace and line breaks that might be left after footer removal
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '\s*\n\s*\n\s*', 
    '\n', 
    'g'
)
WHERE template_html LIKE '%{{footer_text}}%' OR template_html LIKE '%</div>\s*</div>%';

-- Remove trailing whitespace before closing div tags
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '\s+</div>', 
    '</div>', 
    'g'
);

-- =====================================================
-- 4. SPECIFIC TEMPLATE FIXES FOR COMMON PATTERNS
-- =====================================================

-- Fix templates that might have specific footer patterns
-- Pattern: Footer with specific styling like "text-align:center;font-size:9px;"
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*text-align:center[^>]*font-size:9px[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%text-align:center%font-size:9px%{{footer_text}}%';

-- Pattern: Footer with margin-top and font-size
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*margin-top[^>]*font-size[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%margin-top%font-size%{{footer_text}}%';

-- Pattern: Footer with specific styling combinations
UPDATE public.slip_formats 
SET template_html = REGEXP_REPLACE(
    template_html, 
    '<div[^>]*>\s*\{\{footer_text\}\}\s*</div>', 
    '', 
    'gi'
)
WHERE template_html LIKE '%{{footer_text}}%';

-- =====================================================
-- 5. VERIFICATION QUERIES
-- =====================================================

-- Check templates that still contain footer_text (should be 0 after migration)
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

-- Show sample of cleaned templates (first 3)
SELECT 
    name,
    SUBSTRING(template_html, LENGTH(template_html) - 200, 200) as template_end
FROM public.slip_formats 
WHERE template_html NOT LIKE '%{{footer_text}}%'
LIMIT 3;

-- =====================================================
-- 6. BACKUP QUERY (Optional - run before migration)
-- =====================================================

-- Uncomment the following lines to create a backup before running the migration
-- CREATE TABLE slip_formats_backup_before_footer_removal AS 
-- SELECT * FROM public.slip_formats;

-- =====================================================
-- 7. ROLLBACK QUERY (If needed)
-- =====================================================

-- If you need to rollback, uncomment and run:
-- DROP TABLE IF EXISTS public.slip_formats;
-- CREATE TABLE public.slip_formats AS 
-- SELECT * FROM slip_formats_backup_before_footer_removal;

-- =====================================================
-- MIGRATION SUMMARY
-- =====================================================

/*
This migration removes all footer sections containing {{footer_text}} from slip templates.

What it does:
1. Removes footer divs with various styling patterns
2. Cleans up any remaining {{footer_text}} placeholders
3. Removes extra whitespace and line breaks
4. Handles specific template patterns
5. Provides verification queries

Expected result:
- All templates will have their footer sections completely removed
- No {{footer_text}} placeholders will remain
- Templates will be cleaner and more compact
- Thermal printer output will not show any footer text

Run this migration after the 80mm thermal printer optimization migration.
*/
