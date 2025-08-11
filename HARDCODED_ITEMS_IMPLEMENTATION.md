# Hardcoded Items Implementation for International Templates

## Overview
This document explains how the slip generation system now handles hardcoded items for international templates, specifically the Dubai Supermarket template, as requested by the user.

## Key Changes Made

### 1. Frontend Logic Updates (`app/page.tsx`)

#### Print Function (`printSlips`)
- **Conditional Items Replacement**: For international templates (`selectedTemplate.category === 'international'`), the `{{items}}` placeholder is replaced with an empty string instead of dynamic items from the product catalog.
- **Hardcoded Item Placeholders**: Added support for item-specific placeholders:
  - `{{item1_price}}` → "4.50" (SHEZAN MANGO DRINK)
  - `{{item1_qty}}` → "1"
  - `{{item1_total}}` → "4.50"
  - `{{item2_price}}` → "2.50" (EXTRA SPEARMINT 14G)
  - `{{item2_qty}}` → "1"
  - `{{item2_total}}` → "2.50"

#### Preview Function (`previewSlip`)
- **Same Logic**: Applied the same conditional items replacement and hardcoded item placeholders for consistency between print and preview.

### 2. Database Template Updates (`database-migration-international-templates.sql`)

#### Dubai Supermarket Template
- **Hardcoded Items**: Replaced `{{items}}` placeholder with actual hardcoded HTML for:
  - SHEZAN MANGO DRINK (5078643001109) - 4.50 AED
  - EXTRA SPEARMINT 14G (50173686) - 2.50 AED
- **Item Placeholders**: Used dynamic placeholders for prices, quantities, and totals to allow for future customization.

#### Saudi Supermarket Template
- **Hardcoded Items**: Added sample items:
  - Fresh Dates - 25.00 SAR
  - Arabic Coffee - 15.50 SAR

#### UK Supermarket Template
- **Hardcoded Items**: Added sample items:
  - Fish & Chips - 8.50 £
  - Tea & Biscuits - 3.25 £

### 3. Additional Placeholders Added

#### General International Template Placeholders
- `{{cashier_name}}` → "CASHIER"
- `{{time}}` → Current time
- `{{cash_amount}}` → Calculated cash amount
- `{{change_amount}}` → "3.00"
- `{{items_count}}` → Number of items
- `{{total_quantity}}` → Total quantity

#### Dubai-Specific Placeholders
- `{{counter}}` → "COUNTER-1"
- `{{trn}}` → "100071695100003"
- `{{invoice_number}}` → "01888103"

## How It Works

### For International Templates
1. **Template Selection**: User selects an international template (category = 'international')
2. **Items Replacement**: The `{{items}}` placeholder is replaced with an empty string (no dynamic items)
3. **Hardcoded Items**: The template HTML already contains the hardcoded items with their specific placeholders
4. **Placeholder Resolution**: All placeholders are replaced with appropriate values:
   - Item details use hardcoded values
   - Totals, taxes, and other dynamic data use calculated values
   - Store information uses template-specific data

### For Standard Templates
1. **Normal Behavior**: The `{{items}}` placeholder is replaced with dynamically generated items from the product catalog
2. **Product Selection**: Users can select products, quantities, and generate slips as before

## Benefits

1. **Exact Template Reproduction**: International templates print exactly as designed with hardcoded items
2. **Consistent Formatting**: No dynamic item insertion that could break the carefully designed layout
3. **Professional Appearance**: Maintains the professional look of international business templates
4. **Flexibility**: Still allows for dynamic data like totals, taxes, dates, and slip numbers

## Usage

### To Use Hardcoded Items Template
1. Select an international template from the dropdown (e.g., "Dubai Supermarket - Tax Invoice")
2. The system will automatically use the hardcoded items from the template
3. Generate and print the slip - it will display exactly as the template was designed

### To Use Dynamic Items Template
1. Select a standard template from the dropdown
2. Choose products and quantities as usual
3. The system will dynamically insert selected products into the template

## Technical Implementation Details

### Conditional Logic
```typescript
.replace(/\{\{items\}\}/g, selectedTemplate.category === 'international' ? '' : itemsHtml)
```

### Hardcoded Item Placeholders
```typescript
.replace(/\{\{item1_price\}\}/g, "4.50")
.replace(/\{\{item1_qty\}\}/g, "1")
.replace(/\{\{item1_total\}\}/g, "4.50")
// ... etc
```

### Template Categories
- `standard`: Uses dynamic items from product catalog
- `international`: Uses hardcoded items with placeholders
- `premium`: Future category for premium templates
- `custom`: Future category for custom templates

## Future Enhancements

1. **Configurable Hardcoded Items**: Allow users to customize the hardcoded items for international templates
2. **Template Editor**: Provide an interface to edit hardcoded items without modifying SQL
3. **More International Templates**: Add templates for other countries and regions
4. **Dynamic Item Selection**: Allow users to choose from predefined item sets for international templates

## Conclusion

The implementation successfully addresses the user's requirement to print international templates (specifically the Dubai Supermarket template) exactly as provided, with hardcoded items that maintain the professional appearance and formatting of the original template. The system now intelligently handles both dynamic and hardcoded item scenarios based on the template category.
