// =====================================================
// CURRENCY CONVERSION UTILITIES
// =====================================================

// Base currency conversion rates (relative to Indian Rupees)
// These rates are approximate and should match the database rates
const CURRENCY_RATES: { [key: string]: number } = {
  'Rs': 1.000000,    // Base currency
  '$': 0.012000,     // 1 Rs = $0.012
  '€': 0.011000,     // 1 Rs = €0.011
  '£': 0.009500,     // 1 Rs = £0.0095
  '₹': 1.000000,     // Same as Rs
  '¥': 1.800000,     // 1 Rs = ¥1.8
  '₽': 1.200000,     // 1 Rs = ₽1.2
  'AED': 0.044000,   // 1 Rs = AED 0.044
  'SAR': 0.045000    // 1 Rs = SAR 0.045
};

// =====================================================
// CURRENCY CONVERSION FUNCTIONS
// =====================================================

/**
 * Converts an amount from one currency to another
 * @param amount - The amount to convert
 * @param fromCurrency - Source currency (default: 'Rs')
 * @param toCurrency - Target currency
 * @returns Converted amount rounded to 2 decimal places
 */
export function convertCurrency(
  amount: number,
  fromCurrency: string = 'Rs',
  toCurrency: string
): number {
  // If same currency, return same amount
  if (fromCurrency === toCurrency) {
    return amount;
  }

  // Get conversion rate
  const rate = CURRENCY_RATES[toCurrency];
  if (!rate) {
    console.warn(`Unknown target currency: ${toCurrency}, returning original amount`);
    return amount;
  }

  // Convert and round to 2 decimal places
  return Math.round(amount * rate * 100) / 100;
}

/**
 * Converts price ranges for a product
 * @param basePrice - Base price in source currency
 * @param maxPrice - Maximum price in source currency
 * @param targetCurrency - Target currency
 * @returns Object with converted base and max prices
 */
export function convertPriceRange(
  basePrice: number,
  maxPrice: number,
  targetCurrency: string
): { basePrice: number; maxPrice: number } {
  return {
    basePrice: convertCurrency(basePrice, 'Rs', targetCurrency),
    maxPrice: convertCurrency(maxPrice, 'Rs', targetCurrency)
  };
}

/**
 * Formats a price with the appropriate currency symbol
 * @param amount - The amount to format
 * @param currency - Currency symbol
 * @param showSymbol - Whether to show currency symbol (default: true)
 * @returns Formatted price string
 */
export function formatPrice(amount: number, currency: string, showSymbol: boolean = true): string {
  // If currency symbol should be hidden, return only the number
  if (!showSymbol) {
    // For currencies that typically show 2 decimal places
    if (['$', '€', '£', 'AED', 'SAR'].includes(currency)) {
      return amount.toFixed(2);
    }
    
    // For currencies that typically show whole numbers
    if (['¥', '₽'].includes(currency)) {
      return Math.round(amount).toString();
    }
    
    // For Indian Rupees and similar
    return amount.toFixed(2);
  }

  // For currencies that typically show 2 decimal places
  if (['$', '€', '£', 'AED', 'SAR'].includes(currency)) {
    return `${currency}${amount.toFixed(2)}`;
  }
  
  // For currencies that typically show whole numbers
  if (['¥', '₽'].includes(currency)) {
    return `${currency}${Math.round(amount)}`;
  }
  
  // For Indian Rupees and similar
  return `${currency} ${amount.toFixed(2)}`;
}

/**
 * Gets all available currencies
 * @returns Array of currency symbols
 */
export function getAvailableCurrencies(): string[] {
  return Object.keys(CURRENCY_RATES);
}

/**
 * Gets the conversion rate between two currencies
 * @param fromCurrency - Source currency
 * @param toCurrency - Target currency
 * @returns Conversion rate or null if not found
 */
export function getConversionRate(fromCurrency: string, toCurrency: string): number | null {
  if (fromCurrency === toCurrency) {
    return 1;
  }
  
  return CURRENCY_RATES[toCurrency] || null;
}

/**
 * Validates if a currency symbol is supported
 * @param currency - Currency symbol to validate
 * @returns True if supported, false otherwise
 */
export function isSupportedCurrency(currency: string): boolean {
  return currency in CURRENCY_RATES;
}

// =====================================================
// PRICE DISPLAY HELPERS
// =====================================================

/**
 * Formats a price range for display
 * @param basePrice - Base price
 * @param maxPrice - Maximum price
 * @param currency - Currency symbol
 * @returns Formatted price range string
 */
export function formatPriceRange(
  basePrice: number,
  maxPrice: number,
  currency: string
): string {
  const converted = convertPriceRange(basePrice, maxPrice, currency);
  return `${formatPrice(converted.basePrice, currency)} - ${formatPrice(converted.maxPrice, currency)}`;
}

/**
 * Gets the display text for a product price in a specific currency
 * @param basePrice - Base price in Rs
 * @param maxPrice - Maximum price in Rs
 * @param currency - Target currency
 * @param unit - Product unit (kg, pieces, etc.)
 * @returns Formatted price display string
 */
export function getProductPriceDisplay(
  basePrice: number,
  maxPrice: number,
  currency: string,
  unit: string
): string {
  if (currency === 'Rs') {
    return `Rs ${basePrice} - ${maxPrice} per ${unit}`;
  }
  
  const converted = convertPriceRange(basePrice, maxPrice, currency);
  return `${formatPrice(converted.basePrice, currency)} - ${formatPrice(converted.maxPrice, currency)} per ${unit}`;
}

// =====================================================
// CURRENCY INFORMATION
// =====================================================

/**
 * Gets currency information for display
 * @param currency - Currency symbol
 * @returns Object with currency details
 */
export function getCurrencyInfo(currency: string): {
  symbol: string;
  name: string;
  description: string;
  example: string;
} {
  const currencyInfo: { [key: string]: any } = {
    'Rs': {
      symbol: 'Rs',
      name: 'Indian Rupees',
      description: 'Base currency for the system',
      example: 'Rs 120.00'
    },
    '$': {
      symbol: '$',
      name: 'US Dollars',
      description: 'American currency',
      example: '$1.44'
    },
    '€': {
      symbol: '€',
      name: 'Euros',
      description: 'European currency',
      example: '€1.32'
    },
    '£': {
      symbol: '£',
      name: 'British Pounds',
      description: 'UK currency',
      example: '£1.14'
    },
    '₹': {
      symbol: '₹',
      name: 'Indian Rupees (Symbol)',
      description: 'Alternative Rupee symbol',
      example: '₹120.00'
    },
    '¥': {
      symbol: '¥',
      name: 'Japanese Yen',
      description: 'Japanese currency',
      example: '¥216'
    },
    '₽': {
      symbol: '₽',
      name: 'Russian Ruble',
      description: 'Russian currency',
      example: '₽144'
    },
    'AED': {
      symbol: 'AED',
      name: 'UAE Dirham',
      description: 'United Arab Emirates currency',
      example: 'AED 5.28'
    },
    'SAR': {
      symbol: 'SAR',
      name: 'Saudi Riyal',
      description: 'Saudi Arabia currency',
      example: 'SAR 5.40'
    }
  };

  return currencyInfo[currency] || currencyInfo['Rs'];
}

// =====================================================
// EXPORT ALL FUNCTIONS
// =====================================================

export default {
  convertCurrency,
  convertPriceRange,
  formatPrice,
  formatPriceRange,
  getProductPriceDisplay,
  getAvailableCurrencies,
  getConversionRate,
  isSupportedCurrency,
  getCurrencyInfo
};
