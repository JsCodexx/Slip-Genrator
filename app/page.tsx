"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import Navigation from "@/components/Navigation";
import { getProductPriceDisplay, convertCurrency, formatPrice } from "@/lib/currency";

interface SlipFormat {
  id: string;
  name: string;
  description: string;
  template_html: string;
  category?: string;
  logo_data?: string;
  logo_type?: string;
  store_name?: string;
  store_address?: string;
  store_phone?: string;
  store_email?: string;
  store_website?: string;
  tax_rate?: number;
  currency_symbol?: string;
  footer_text?: string;
}

interface Fruit {
  id: string;
  name: string;
  base_price: number;
  max_price: number;
  unit: string;
  category: string;
}

interface GeneratedSlip {
  id: string;
  serial_number: string;
  slip_date: string;
  total_amount: number;
  items_count: number;
  format: SlipFormat;
  items: SlipItem[];
}

interface SlipItem {
  fruit: Fruit;
  quantity: number;
  unit_price: number;
  total_price: number;
}

// Move generateRealisticQuantity function outside the component for stability
const generateRealisticQuantity = (unit: string): number => {
  switch (unit.toLowerCase()) {
    case 'pieces':
    case 'piece':
    case 'pcs':
    case 'pc':
      return Math.floor(Math.random() * 20) + 1; // 1-20 pieces
    
    case 'kg':
    case 'kgs':
    case 'kilogram':
    case 'kilograms':
      return Math.floor(Math.random() * 7) + 1; // 1-7 kg
    
    case 'glass':
    case 'glasses':
    case 'bottle':
    case 'bottles':
    case 'can':
    case 'cans':
      return Math.floor(Math.random() * 20) + 1; // 1-20 glasses/bottles
    
    case 'dozen':
    case 'dozens':
      return Math.floor(Math.random() * 5) + 1; // 1-5 dozen
    
    case 'pack':
    case 'packs':
    case 'packet':
    case 'packets':
      return Math.floor(Math.random() * 10) + 1; // 1-10 packs
    
    default:
      return Math.floor(Math.random() * 10) + 1; // Default 1-10
  }
};

export default function Home() {
  const [user, setUser] = useState<any>(null);
  const [slipFormats, setSlipFormats] = useState<SlipFormat[]>([]);
  const [fruits, setFruits] = useState<Fruit[]>([]);
  const [selectedFormat, setSelectedFormat] = useState<string>(() => {
    // Initialize from localStorage if available
    if (typeof window !== 'undefined') {
      return localStorage.getItem('selectedSlipFormat') || "";
    }
    return "";
  });
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [numberOfSlips, setNumberOfSlips] = useState<number>(1);
  const [selectedCategory, setSelectedCategory] = useState<string>("");
  const [fruitQuantities, setFruitQuantities] = useState<{
    [key: string]: number;
  }>({});
  const [generatedSlips, setGeneratedSlips] = useState<GeneratedSlip[]>([]);
  const [isGenerating, setIsGenerating] = useState<boolean>(false);
  const [message, setMessage] = useState<string>("");
  const [messageType, setMessageType] = useState<"success" | "error" | "info">(
    "info"
  );
  const [showPreview, setShowPreview] = useState(false);
  
  // New state variables for item control
  const [maxItemsToShow, setMaxItemsToShow] = useState<number>(8);
  const [autoGenerateQuantities, setAutoGenerateQuantities] = useState<boolean>(true);
  const [selectedItemsCount, setSelectedItemsCount] = useState<number>(0);
  
  // New state for date mode
  const [dateMode, setDateMode] = useState<"range" | "exact">("range");
  const [exactDate, setExactDate] = useState<string>("");
  const [formatsLoaded, setFormatsLoaded] = useState<boolean>(false);

  useEffect(() => {
    const getUser = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (user) {
        setUser(user);
        loadSlipFormats();
        loadFruits("all"); // Load all categories initially
        
        // Set default date range: 15 days ago to today
        const today = new Date();
        const fifteenDaysAgo = new Date();
        fifteenDaysAgo.setDate(today.getDate() - 15);
        
        setEndDate(today.toISOString().split('T')[0]);
        setStartDate(fifteenDaysAgo.toISOString().split('T')[0]);
        setExactDate(today.toISOString().split('T')[0]);
      } else {
        window.location.href = "/auth";
      }
    };
    getUser();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event: any, session: any) => {
      if (session?.user) {
        setUser(session.user);
        // Only load formats if not already loaded to prevent resetting selected format
        if (!formatsLoaded) {
          loadSlipFormats();
        }
        loadFruits("all"); // Load all categories initially
        
        // Set default date range: 15 days ago to today
        const today = new Date();
        const fifteenDaysAgo = new Date();
        fifteenDaysAgo.setDate(today.getDate() - 15);
        
        setEndDate(today.toISOString().split('T')[0]);
        setStartDate(fifteenDaysAgo.toISOString().split('T')[0]);
        setExactDate(today.toISOString().split('T')[0]);
      } else {
        setUser(null);
        window.location.href = "/auth";
      }
    });
    return () => subscription.unsubscribe();
  }, []);

  // Debug: Monitor fruitQuantities state changes
  useEffect(() => {
  }, [fruitQuantities]);

  // Debug: Monitor fruits state changes
  useEffect(() => {
    // Initialize fruitQuantities with 0 for all fruits when fruits change
    if (fruits.length > 0) {
      const initialQuantities: { [key: string]: number } = {};
      fruits.forEach((fruit) => {
        // Only set to 0 if not already set by user
        if (fruitQuantities[fruit.id] === undefined) {
          initialQuantities[fruit.id] = 0;
        } else {
          initialQuantities[fruit.id] = fruitQuantities[fruit.id];
        }
      });
      
      // Only update if there are new fruits or if quantities are missing
      const hasNewFruits = fruits.some(fruit => fruitQuantities[fruit.id] === undefined);
      if (hasNewFruits) {
        setFruitQuantities(prev => ({
          ...prev,
          ...initialQuantities
        }));
      }
    }
  }, [fruits]); // Removed fruitQuantities from dependency array to prevent infinite loops

  // Track selected items count
  useEffect(() => {
    const selectedCount = Object.values(fruitQuantities).filter(qty => qty > 0).length;
    setSelectedItemsCount(selectedCount);
  }, [fruitQuantities]);

  // Auto-generate quantities when autoGenerateQuantities is enabled
  useEffect(() => {
    if (autoGenerateQuantities && fruits.length > 0) {
      console.log('🔄 Auto-generating quantities for', fruits.length, 'fruits');
      const newQuantities: { [key: string]: number } = {};
      
      fruits.forEach((fruit) => {
        // Only auto-generate if quantity is 0 or undefined
        if (fruitQuantities[fruit.id] === 0 || fruitQuantities[fruit.id] === undefined) {
          newQuantities[fruit.id] = generateRealisticQuantity(fruit.unit);
          console.log(`🔄 Auto-generated quantity for ${fruit.name}: ${newQuantities[fruit.id]} ${fruit.unit}`);
        } else {
          // Preserve existing user-set quantities
          newQuantities[fruit.id] = fruitQuantities[fruit.id];
        }
      });
      
      // Update the state with new quantities
      setFruitQuantities(prev => ({
        ...prev,
        ...newQuantities
      }));
      
      console.log('🔄 Updated fruitQuantities with auto-generated values:', newQuantities);
    }
  }, [autoGenerateQuantities, fruits]); // Depend on autoGenerateQuantities and fruits

  const handleFormatChange = (formatId: string) => {
    console.log('🔄 Format changed to:', formatId);
    setSelectedFormat(formatId);
    // Save to localStorage for persistence
    if (typeof window !== 'undefined') {
      localStorage.setItem('selectedSlipFormat', formatId);
    }
  };

  const loadSlipFormats = async () => {
    console.log('🔄 Loading slip formats...');
    try {
      const { data, error } = await supabase
        .from("slip_formats")
        .select("*")
        .eq("is_active", true)
        .order("name");

      if (error) throw error;
      if (data && data.length > 0) {
      }
      setSlipFormats(data || []);
      setFormatsLoaded(true);
      // Only set default format if no format is currently selected
      if (data && data.length > 0 && !selectedFormat) {
        handleFormatChange(data[0].id);
      }
    } catch (error) {
    }
  };

  const loadFruits = async (category?: string) => {
    try {
      let query = supabase
        .from("fruits")
        .select("*")
        .eq("is_active", true);
      
      if (category && category !== "all") {
        query = query.eq("category", category);
      }
      
      const { data, error } = await query.order("name");

      if (error) throw error;
      setFruits(data || []);

      // Initialize quantities to 0 for new fruits when category changes
      if (data && data.length > 0) {
        const newQuantities: { [key: string]: number } = {};
        data.forEach((fruit) => {
          // If we're changing categories, reset all quantities to 0
          // If we're keeping the same category, preserve existing quantities
          if (selectedCategory !== category || fruitQuantities[fruit.id] === undefined) {
            newQuantities[fruit.id] = 0;
          } else {
            newQuantities[fruit.id] = fruitQuantities[fruit.id];
          }
        });
        console.log(`🔄 Loaded ${data.length} fruits for category "${category}", initialized quantities:`, newQuantities);
        setFruitQuantities(newQuantities);
      }
    } catch (error) {
      console.error('collab: Error loading fruits:', error);
    }
  };

  const handleCategoryChange = (category: string) => {
    console.log(`🔄 Category changed from ${selectedCategory} to ${category}`);
    setSelectedCategory(category);
    // Reset quantities when category changes
    setFruitQuantities({});
    console.log('🔄 Reset fruitQuantities to empty object');
    loadFruits(category);
  };

  // Function to handle date mode changes
  const handleDateModeChange = (mode: "range" | "exact") => {
    setDateMode(mode);
    // Reset quantities when changing date mode to ensure fresh start
    setFruitQuantities({});
    setMessage(`Switched to ${mode === "range" ? "Date Range" : "Exact Date"} mode`);
    setMessageType("info");
    setTimeout(() => setMessage(""), 3000);
  };

  const resetQuantities = () => {
    if (autoGenerateQuantities) {
      // If auto-generation is enabled, generate new realistic quantities
      const newQuantities: { [key: string]: number } = {};
      fruits.forEach((fruit) => {
        newQuantities[fruit.id] = generateRealisticQuantity(fruit.unit);
      });
      setFruitQuantities(newQuantities);
      setMessage("Generated new realistic quantities for all items");
      setMessageType("success");
    } else {
      // If auto-generation is disabled, reset to 0
      const resetQuantities: { [key: string]: number } = {};
      fruits.forEach((fruit) => {
        resetQuantities[fruit.id] = 0;
      });
      setFruitQuantities(resetQuantities);
      setMessage("Reset all quantities to 0");
      setMessageType("info");
    }
    setTimeout(() => setMessage(""), 3000);
  };

  // Function to manually generate sample quantities
  const generateSampleQuantities = () => {
    const newQuantities: { [key: string]: number } = {};
    fruits.forEach((fruit) => {
      newQuantities[fruit.id] = generateRealisticQuantity(fruit.unit);
    });
    setFruitQuantities(newQuantities);
    setMessage("Generated sample quantities for all items");
    setMessageType("success");
    setTimeout(() => setMessage(""), 3000);
  };

  // Function to reset dates to default range (15 days ago to today)
  const resetDatesToDefault = () => {
    const today = new Date();
    const fifteenDaysAgo = new Date();
    fifteenDaysAgo.setDate(today.getDate() - 15);
    
    setEndDate(today.toISOString().split('T')[0]);
    setStartDate(fifteenDaysAgo.toISOString().split('T')[0]);
    setExactDate(today.toISOString().split('T')[0]);
    
    setMessage("Dates reset to default range (15 days ago to today)");
    setMessageType("info");
    setTimeout(() => setMessage(""), 3000);
  };

  const generateRandomPrice = (basePrice: number, maxPrice: number): number => {
    return (
      Math.round((Math.random() * (maxPrice - basePrice) + basePrice) * 100) /
      100
    );
  };

  const generateSlips = async () => {
    if (!selectedFormat || !selectedCategory) {
      setMessage("Please select a slip format and product category");
      setMessageType("error");
      return;
    }

    // Validate date based on mode
    if (dateMode === "range" && (!startDate || !endDate)) {
      setMessage("Please select start and end dates for date range mode");
      setMessageType("error");
      return;
    }

    if (dateMode === "exact" && !exactDate) {
      setMessage("Please select an exact date");
      setMessageType("error");
      return;
    }

    if (numberOfSlips < 1) {
      setMessage("Please enter a valid number of slips");
      setMessageType("error");
      return;
    }

    // Debug: Log the current state
    console.log('🔍 Debug generateSlips:', {
      fruits: fruits.length,
      fruitQuantities,
      selectedFruits: fruits.filter(fruit => fruitQuantities[fruit.id] > 0).length,
      maxItemsToShow,
      autoGenerateQuantities
    });

    // Only get fruits where user has selected quantity > 0
    const selectedFruits = fruits.filter(
      (fruit) => fruitQuantities[fruit.id] > 0
    );
    
    if (selectedFruits.length === 0) {
      setMessage("Please select at least one product with quantity greater than 0");
      setMessageType("error");
      return;
    }

    // Limit items based on maxItemsToShow - this is the key fix
    const maxItems = Math.min(maxItemsToShow, selectedFruits.length);
    const limitedFruits = selectedFruits.slice(0, maxItems);

    console.log('🔍 Limited fruits:', {
      maxItems,
      limitedFruits: limitedFruits.length,
      limitedFruitsDetails: limitedFruits.map(f => ({ name: f.name, quantity: fruitQuantities[f.id] }))
    });

    setIsGenerating(true);
    setMessage("Generating slips...");

    try {
      const newSlips: GeneratedSlip[] = [];
      
      // Handle date logic based on mode
      let slipDate: string;
      if (dateMode === "exact") {
        slipDate = exactDate;
      } else {
        // Range mode - generate random date within range
        const start = new Date(startDate);
        const end = new Date(endDate);
        const randomTime = start.getTime() + Math.random() * (end.getTime() - start.getTime());
        const randomDate = new Date(randomTime);
        slipDate = randomDate.toISOString().split("T")[0];
      }

      for (let i = 0; i < numberOfSlips; i++) {
        // Generate random serial number
        const timestamp = Date.now().toString().slice(-6);
        const randomNum = Math.floor(Math.random() * 100000)
          .toString()
          .padStart(5, "0");
        const serialNumber = `${timestamp}${randomNum}`;

        // Generate items with user-selected quantities OR auto-generated quantities
        const items: SlipItem[] = [];
        let totalAmount = 0;

        // Create a shuffled copy of limited fruits for this slip
        const shuffledFruits = [...limitedFruits].sort(() => Math.random() - 0.5);

        shuffledFruits.forEach((fruit) => {
          let quantity: number;
          
          console.log(`🔍 Processing fruit: ${fruit.name}, current quantity: ${fruitQuantities[fruit.id]}, autoGenerate: ${autoGenerateQuantities}`);
          
          // If user has set a quantity > 0, use it; otherwise auto-generate
          if (fruitQuantities[fruit.id] > 0) {
            quantity = fruitQuantities[fruit.id];
            console.log(`✅ Using user quantity: ${quantity}`);
          } else if (autoGenerateQuantities) {
            // Auto-generate realistic quantity based on unit
            quantity = generateRealisticQuantity(fruit.unit);
            console.log(`🎲 Auto-generated quantity: ${quantity} for unit: ${fruit.unit}`);
          } else {
            // If auto-generate is disabled, skip this fruit
            console.log(`⏭️ Skipping fruit: ${fruit.name} - no quantity and auto-generate disabled`);
            return;
          }

          const unitPrice = generateRandomPrice(
            fruit.base_price,
            fruit.max_price
          );
          
          // Convert unit price to selected currency if different from Rs
          const selectedCurrency = slipFormats.find(f => f.id === selectedFormat)?.currency_symbol || 'Rs';
          const convertedUnitPrice = selectedCurrency !== 'Rs' ? 
            convertCurrency(unitPrice, 'Rs', selectedCurrency) : unitPrice;
          
          const totalPrice = quantity * convertedUnitPrice;

          items.push({
            fruit,
            quantity,
            unit_price: convertedUnitPrice,
            total_price: totalPrice,
          });

          totalAmount += totalPrice;
        });

        const selectedFormatData = slipFormats.find(
          (f) => f.id === selectedFormat
        )!;

        newSlips.push({
          id: `temp-${i}`,
          serial_number: serialNumber,
          slip_date: slipDate,
          total_amount: totalAmount,
          items_count: items.length,
          format: selectedFormatData,
          items,
        });
      }

      setGeneratedSlips(newSlips);
      setMessage(`${numberOfSlips} slips generated successfully!`);
      setMessageType("success");
    } catch (error) {
      setMessage("Error generating slips");
      setMessageType("error");
    } finally {
      setIsGenerating(false);
    }
  };

  const saveSlipsToDatabase = async () => {
    if (generatedSlips.length === 0) {
      setMessage("No slips to save");
      setMessageType("error");
      return;
    }

    setIsGenerating(true);
    setMessage("Saving slips to database...");

    try {
      for (const slip of generatedSlips) {
        // Insert the generated slip
        const { data: slipData, error: slipError } = await supabase
          .from("slips")
          .insert({
            user_id: user.id,
            format_id: selectedFormat,
            serial_number: slip.serial_number,
            slip_date: slip.slip_date,
            total_amount: slip.total_amount,
            items_count: slip.items_count,
          })
          .select()
          .single();

        if (slipError) throw slipError;

        // Insert slip items
        for (const item of slip.items) {
          const { error: itemError } = await supabase
            .from("slip_items")
            .insert({
              slip_id: slipData.id,
              fruit_id: item.fruit.id,
              quantity: item.quantity,
              unit_price: item.unit_price,
              total_price: item.total_price,
            });

          if (itemError) throw itemError;
        }
      }

      setMessage("All slips saved successfully!");
      setMessageType("success");
      setGeneratedSlips([]);
    } catch (error) {
      setMessage("Error saving slips to database");
      setMessageType("error");
    } finally {
      setIsGenerating(false);
    }
  };

  const printSlips = () => {
    if (generatedSlips.length === 0) {
      setMessage("No slips to print");
      setMessageType("error");
      return;
    }

    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    let printContent = `
      <html>
        <head>
          <title>Generated Receipts</title>
          <style>
            @media print {
              body {
                margin: 0 !important;
                padding: 0 !important;
                background: white !important;
              }
              .receipt {
                width: 80mm !important;
                max-width: 80mm !important;
                margin: 0 auto !important;
                padding: 4mm !important;
                font-family: "Courier New", monospace !important;
                font-size: 10px !important;
                line-height: 1.2 !important;
                background: white !important;
                color: black !important;
                box-shadow: none !important;
                border: none !important;
                page-break-inside: avoid !important;
                break-inside: avoid !important;
              }
              .receipt div[style*="display:flex"] {
                display: flex !important;
                justify-content: space-between !important;
                margin: 2px 0 !important;
                font-size: 10px !important;
                line-height: 1.1 !important;
              }
              .receipt div[style*="display:flex"] span {
                display: inline-block !important;
                white-space: nowrap !important;
                font-size: 10px !important;
              }
              .receipt div[style*="margin:5px 0"] {
                margin: 2px 0 !important;
              }
              .receipt h1, .receipt h2, .receipt h3 {
                font-size: 12px !important;
                margin: 3px 0 !important;
                font-weight: bold !important;
              }
              .receipt p, .receipt div {
                font-size: 10px !important;
                margin: 1px 0 !important;
              }
              .receipt .item {
                margin: 1px 0 !important;
                padding: 1px 0 !important;
              }
              .receipt * {
                background: white !important;
                color: black !important;
              }
            }
          </style>
        </head>
        <body>
    `;

    generatedSlips.forEach((slip, index) => {
      const slipDate = new Date(slip.slip_date);
      const formattedDate = slipDate.toLocaleDateString("en-GB");

      const selectedTemplate = slipFormats.find((f) => f.id === selectedFormat);
      if (!selectedTemplate) return;

      // Items HTML
      let itemsHtml = "";
      slip.items.forEach((item) => {
        itemsHtml += `
          <div style="display:flex;justify-content:space-between;align-items:center;margin:5px 0;font-size:12px">
            <span style="flex:1;text-align:left;">${item.fruit.name}</span>
            <span style="flex:1;text-align:center;">${item.quantity} ${item.fruit.unit}</span>
            <span style="flex:1;text-align:right;">${formatPrice(item.total_price, selectedTemplate.currency_symbol || 'Rs')}</span>
          </div>
        `;
      });

      const taxAmount = (
        (slip.total_amount * (selectedTemplate.tax_rate || 0)) / 100
      ).toFixed(2);

      const grandTotal = slip.total_amount + parseFloat(taxAmount);

      // Replace placeholders and clean any potential \f characters
      let templateHtml = selectedTemplate.template_html
        .replace(
          /\{\{logo\}\}/g,
          selectedTemplate.logo_data
            ? `<img src="${selectedTemplate.logo_data}" alt="Logo" style="max-width: 60px; height: auto;">`
            : ""
        )
        .replace(
          /\{\{store_name\}\}/g,
          selectedTemplate.store_name || selectedTemplate.name
        )
        .replace(/\{\{store_address\}\}/g, selectedTemplate.store_address || "")
        .replace(/\{\{store_phone\}\}/g, selectedTemplate.store_phone || "")
        .replace(/\{\{store_email\}\}/g, selectedTemplate.store_email || "")
        .replace(/\{\{store_website\}\}/g, selectedTemplate.store_website || "")
        .replace(/\{\{date\}\}/g, formattedDate)
        .replace(/\{\{slip_number\}\}/g, slip.serial_number)
        .replace(/\{\{items\}\}/g, selectedTemplate.category === 'international' ? '' : itemsHtml)
        .replace(/\{\{total\}\}/g, slip.total_amount.toFixed(2))
        .replace(/\{\{tax_rate\}\}/g, (selectedTemplate.tax_rate || 0).toString())
        .replace(/\{\{tax_amount\}\}/g, taxAmount)
        .replace(/\{\{grand_total\}\}/g, grandTotal.toFixed(2))
        .replace(/\{\{currency_symbol\}\}/g, selectedTemplate.currency_symbol || 'Rs')
        .replace(/\{\{footer_text\}\}/g, selectedTemplate.footer_text || "")
        .replace(/<div[^>]*>\s*\{\{footer_text\}\}\s*<\/div>/gi, selectedTemplate.footer_text ? `<div>${selectedTemplate.footer_text}</div>` : "")
        .replace(/<div[^>]*>\s*\{\{footer_text\}\}\s*<\/div>/gi, "")
        // Clean any potential \f characters
        .replace(/\\f/g, '')
        .replace(/\f/g, '')
        .replace(/\\n/g, '\n')
        .replace(/\\r/g, '\r');

      // Debug: Check if template still contains \f characters
      if (templateHtml.includes('\\f') || templateHtml.includes('\f')) {
        console.warn('⚠️ Template still contains \\f characters:', templateHtml.match(/\\f|\f/g));
        templateHtml = templateHtml.replace(/\\f|\f/g, '');
      }

      printContent += `<div class="receipt">${templateHtml}</div>`;
      
      // Add spacing between receipts (no cutting elements)
      if (index < generatedSlips.length - 1) {
        printContent += `<div style="height: 30px; margin: 0; padding: 0; border: none;"></div>`;
      }
    });

    printContent += `
        </body>
      </html>
    `;

    // Final cleanup of print content to remove any \f characters
    const cleanPrintContent = printContent
      .replace(/\\f/g, '')
      .replace(/\f/g, '')
      .replace(/\\n/g, '\n')
      .replace(/\\r/g, '\r');

    printWindow.document.write(cleanPrintContent);
    printWindow.document.close();
    
    // Single print job
    setTimeout(() => {
      printWindow.focus();
      printWindow.print();
      printWindow.close();
    }, 100);
  };

  const previewSlip = () => {
    if (generatedSlips.length === 0) {
      setMessage("No slips to preview");
      setMessageType("error");
      return;
    }
    setShowPreview(true);
  };

  const closePreview = () => {
    setShowPreview(false);
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    window.location.href = "/auth";
  };

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navigation user={user} onSignOut={handleSignOut} />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Slip Generation Dashboard
          </h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">
            Generate unique slips with dynamic pricing and multiple format
            options
          </p>
        </div>

        {/* Configuration Form */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-8">
          <h2 className="text-xl font-semibold mb-4 text-gray-900 dark:text-white">
            Slip Configuration
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Slip Format
              </label>
              <select
                value={selectedFormat}
                onChange={(e) => {
                  const newFormat = e.target.value;
                  handleFormatChange(newFormat);
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select Format</option>
                {/* Group by category */}
                {Object.entries(
                  slipFormats.reduce((acc, format) => {
                    const category = format.category || 'standard';
                    if (!acc[category]) acc[category] = [];
                    acc[category].push(format);
                    return acc;
                  }, {} as Record<string, SlipFormat[]>)
                ).map(([category, formats]) => (
                  <optgroup key={category} label={`${category.charAt(0).toUpperCase() + category.slice(1)} Templates`}>
                    {formats.map((format) => (
                      <option key={format.id} value={format.id}>
                        {format.name}
                      </option>
                    ))}
                  </optgroup>
                ))}
              </select>
              {selectedFormat && (
                <div className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                  Currency: {slipFormats.find(f => f.id === selectedFormat)?.currency_symbol || 'Rs'}
                  {slipFormats.find(f => f.id === selectedFormat)?.currency_symbol !== 'Rs' && (
                    <span className="ml-1 text-blue-600">
                      (Prices will be converted from Rs)
                    </span>
                  )}
                </div>
              )}
            </div>

            {/* Date Mode Toggle */}
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Date Mode
              </label>
              <div className="flex space-x-2">
                <button
                  onClick={() => handleDateModeChange("range")}
                  className={`px-3 py-2 text-sm rounded-md transition-colors ${
                    dateMode === "range"
                      ? "bg-blue-600 text-white"
                      : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                  }`}
                >
                  Date Range
                </button>
                <button
                  onClick={() => handleDateModeChange("exact")}
                  className={`px-3 py-2 text-sm rounded-md transition-colors ${
                    dateMode === "exact"
                      ? "bg-blue-600 text-white"
                      : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                  }`}
                >
                  Exact Date
                </button>
              </div>
            </div>

                        {/* Conditional Date Inputs */}
            {dateMode === "range" ? (
              <>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Start Date
                  </label>
                  <input
                    type="date"
                    value={startDate}
                    onChange={(e) => setStartDate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    End Date
                  </label>
                  <input
                    type="date"
                    value={endDate}
                    onChange={(e) => setEndDate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </>
            ) : (
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Exact Date
                </label>
                <input
                  type="date"
                  value={exactDate}
                  onChange={(e) => setExactDate(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            )}

            {/* Show disabled date range inputs when in exact mode */}
            {dateMode === "exact" && (
              <>
                <div>
                  <label className="block text-sm font-medium text-gray-400 dark:text-gray-500 mb-2">
                    Start Date (Disabled - Exact Mode)
                  </label>
                  <input
                    type="date"
                    value={startDate}
                    disabled
                    className="w-full px-3 py-2 border border-gray-200 bg-gray-100 text-gray-400 rounded-md cursor-not-allowed"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-400 dark:text-gray-500 mb-2">
                    End Date (Disabled - Exact Mode)
                  </label>
                  <input
                    type="date"
                    value={endDate}
                    disabled
                    className="w-full px-3 py-2 border border-gray-200 bg-gray-100 text-gray-400 rounded-md cursor-not-allowed"
                  />
                </div>
              </>
            )}

            {/* Date Reset Button */}
            <div className="flex items-end">
              <button
                onClick={resetDatesToDefault}
                type="button"
                className="w-full px-3 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-md transition-colors border border-gray-300 dark:border-gray-600"
              >
                Reset to Default Dates
              </button>
            </div>
          </div>

          {/* Date Range Information */}
          <div className="mt-4 p-3 bg-green-50 dark:bg-green-900/20 rounded-lg">
            <div className="text-sm text-green-800 dark:text-green-200">
              <div className="font-medium mb-2">📅 Date Selection Options:</div>
              <div className="text-xs">
                <div className="mb-2">
                  <strong>🎯 Date Range Mode:</strong>
                  <br />
                  • <strong>Default Range:</strong> 15 days ago to today (automatically set)
                  <br />
                  • <strong>Custom Selection:</strong> You can manually select any start and end dates
                  <br />
                  • <strong>Random Generation:</strong> Each slip gets a random date within your selected range
                </div>
                <div className="mb-2">
                  <strong>📌 Exact Date Mode:</strong>
                  <br />
                  • <strong>Single Date:</strong> All slips will use the exact date you select
                  <br />
                  • <strong>No Randomization:</strong> Perfect for specific date requirements
                </div>
                <div>
                  • <strong>Quick Reset:</strong> Use "Reset to Default Dates" to return to 15 days ago → today
                </div>
              </div>
            </div>
          </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Number of Slips
              </label>
              <input
                type="number"
                min="1"
                max="100"
                value={numberOfSlips}
                onChange={(e) => setNumberOfSlips(parseInt(e.target.value))}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            {/* New Item Control Fields */}
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Maximum Items per Slip
              </label>
              <div className="flex items-center space-x-4">
                <input
                  type="range"
                  min="1"
                  max="20"
                  value={maxItemsToShow}
                  onChange={(e) => setMaxItemsToShow(parseInt(e.target.value))}
                  className="flex-1"
                />
                <span className="text-sm text-gray-600 dark:text-gray-400 min-w-[3rem]">
                  {maxItemsToShow}
                </span>
              </div>
              <p className="text-xs text-gray-500 mt-1">
                Control how many items appear on each slip (1-20)
              </p>
            </div>

            <div>
              <label className="flex items-center">
                <input
                  type="checkbox"
                  checked={autoGenerateQuantities}
                  onChange={(e) => setAutoGenerateQuantities(e.target.checked)}
                  className="mr-2"
                />
                <span className="text-sm text-gray-700 dark:text-gray-300">
                  Auto-generate realistic quantities based on product units
                </span>
              </label>
              <p className="text-xs text-gray-500 mt-1">
                When checked: Pieces (1-20), KG (1-7), Glasses (1-20), etc.
              </p>
            </div>
          
          {/* Currency Information */}
          <div className="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <div className="text-sm text-blue-800 dark:text-blue-200">
              <div className="font-medium mb-2">💱 Available Currencies:</div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-xs">
                <div>🇮🇳 Rs - Indian Rupees</div>
                <div>🇺🇸 $ - US Dollars</div>
                <div>🇪🇺 € - Euros</div>
                <div>🇬🇧 £ - British Pounds</div>
                <div>🇯🇵 ¥ - Japanese Yen</div>
                <div>🇷🇺 ₽ - Russian Ruble</div>
              </div>
              <div className="mt-2 text-xs text-blue-600 dark:text-blue-300">
                💡 Prices are automatically converted from Rs to your selected currency
              </div>
            </div>
          </div>

          {/* Category Selection */}
          <div className="mt-6">
            <h3 className="text-lg font-medium mb-3 text-gray-900 dark:text-white">
              Select Product Category
            </h3>
                         <p className="text-sm text-gray-600 dark:text-gray-400 mb-3">
               Choose the type of products you want to include in your slips. 
               {selectedFormat && (
                 <span className="font-medium"> 
                   Currency: {slipFormats.find(f => f.id === selectedFormat)?.currency_symbol || 'Rs'}
                   {slipFormats.find(f => f.id === selectedFormat)?.currency_symbol !== 'Rs' && (
                     <span className="text-blue-600"> (Prices converted from Rs)</span>
                   )}
                 </span>
               )}
             </p>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
              <button
                onClick={() => handleCategoryChange("fruits")}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  selectedCategory === "fruits"
                    ? "border-blue-500 bg-blue-50 text-blue-700 dark:bg-blue-900/20 dark:text-blue-300"
                    : "border-gray-300 hover:border-gray-400 dark:border-gray-600 dark:hover:border-gray-500"
                }`}
              >
                <div className="text-center">
                  <div className="text-2xl mb-1">🍎</div>
                  <div className="font-medium">Fruits</div>
                  <div className="text-xs text-gray-500">Fresh fruits with proper units</div>
                </div>
              </button>

              <button
                onClick={() => handleCategoryChange("vegetables")}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  selectedCategory === "vegetables"
                    ? "border-green-500 bg-green-50 text-green-700 dark:bg-green-900/20 dark:text-green-300"
                    : "border-gray-300 hover:border-gray-400 dark:border-gray-600 dark:hover:border-gray-500"
                }`}
              >
                <div className="text-center">
                  <div className="text-2xl mb-1">🥬</div>
                  <div className="font-medium">Vegetables</div>
                  <div className="text-xs text-gray-500">Fresh vegetables & greens</div>
                </div>
              </button>

              <button
                onClick={() => handleCategoryChange("shakes_juices")}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  selectedCategory === "shakes_juices"
                    ? "border-purple-500 bg-purple-50 text-purple-700 dark:bg-purple-900/20 dark:text-purple-300"
                    : "border-gray-300 hover:border-gray-400 dark:border-gray-600 dark:hover:border-gray-500"
                }`}
              >
                <div className="text-center">
                  <div className="text-2xl mb-1">🥤</div>
                  <div className="font-medium">Shakes & Juices</div>
                  <div className="text-xs text-gray-500">Beverages & smoothies</div>
                </div>
              </button>

              <button
                onClick={() => handleCategoryChange("mixed")}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  selectedCategory === "mixed"
                    ? "border-orange-500 bg-orange-50 text-orange-700 dark:bg-orange-900/20 dark:text-orange-300"
                    : "border-gray-300 hover:border-gray-400 dark:border-gray-600 dark:hover:border-gray-500"
                }`}
              >
                <div className="text-center">
                  <div className="text-2xl mb-1">🎁</div>
                  <div className="font-medium">Mixed Products</div>
                  <div className="text-xs text-gray-500">Combos & baskets</div>
                </div>
              </button>
            </div>
          </div>

          {/* Product Selection */}
          <div className="mt-6">
            <h3 className="text-lg font-medium mb-3 text-gray-900 dark:text-white">
              Select Products & Quantities
            </h3>
            
            {/* Debug Info */}
            <div className="mb-3 p-2 bg-yellow-50 dark:bg-yellow-900/20 rounded border border-yellow-200 dark:border-yellow-700">
              <div className="text-xs text-yellow-800 dark:text-yellow-200">
                <strong>🔍 Debug Info:</strong>
                <br />
                • Selected items: {Object.values(fruitQuantities).filter(qty => qty > 0).length}
                <br />
                • Max items per slip: {maxItemsToShow}
                <br />
                • Auto-generate quantities: {autoGenerateQuantities ? "ON" : "OFF"}
                <br />
                • Date mode: {dateMode === "range" ? "Range" : "Exact"}
                <br />
                • Total fruits loaded: {fruits.length}
                <br />
                • fruitQuantities keys: {Object.keys(fruitQuantities).length}
              </div>
              <button
                onClick={() => {
                  console.log('🔍 Current State:', {
                    fruits: fruits.map(f => ({ id: f.id, name: f.name, category: f.category })),
                    fruitQuantities,
                    selectedCategory,
                    maxItemsToShow,
                    autoGenerateQuantities,
                    dateMode
                  });
                  setMessage("Check browser console for debug info");
                  setMessageType("info");
                  setTimeout(() => setMessage(""), 3000);
                }}
                className="mt-2 px-2 py-1 bg-yellow-200 hover:bg-yellow-300 text-yellow-800 text-xs rounded border border-yellow-300"
              >
                Log State to Console
              </button>
              <button
                onClick={() => {
                  if (fruits.length === 0) {
                    setMessage("No fruits loaded yet");
                    setMessageType("error");
                    return;
                  }
                  
                  // Set random quantities for first 5 fruits
                  const sampleQuantities: { [key: string]: number } = {};
                  fruits.slice(0, 5).forEach((fruit) => {
                    sampleQuantities[fruit.id] = generateRealisticQuantity(fruit.unit);
                  });
                  
                  setFruitQuantities(prev => ({
                    ...prev,
                    ...sampleQuantities
                  }));
                  
                  setMessage("Set sample quantities for first 5 fruits");
                  setMessageType("success");
                  setTimeout(() => setMessage(""), 3000);
                }}
                className="mt-2 ml-2 px-2 py-1 bg-green-200 hover:bg-green-300 text-green-800 text-xs rounded border border-green-300"
              >
                Set Sample Quantities
              </button>
            </div>
            
            <p className="text-sm text-gray-600 dark:text-gray-400 mb-3">
              {selectedCategory ? 
                `Set quantity for each ${selectedCategory.replace('_', ' ')}. Items with quantity > 0 will appear on slips.` : 
                'Please select a category first'
              }
              {selectedCategory && (
                <span className="ml-2 font-medium text-blue-600">
                  Selected: {Object.values(fruitQuantities).filter(qty => qty > 0).length} items
                </span>
              )}
            </p>
            {selectedCategory ? (
              <>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                  {fruits.slice(0, maxItemsToShow).map((fruit) => (
                    <div key={fruit.id} className="flex items-center space-x-2 p-3 border border-gray-200 rounded-lg hover:border-gray-300 transition-colors">
                      <div className="flex-1">
                        <div className="font-medium text-gray-900 dark:text-white">{fruit.name}</div>
                        <div className="text-sm text-gray-500 dark:text-gray-400">
                          {selectedFormat ? 
                            getProductPriceDisplay(
                              fruit.base_price, 
                              fruit.max_price, 
                              slipFormats.find(f => f.id === selectedFormat)?.currency_symbol || 'Rs',
                              fruit.unit
                            ) :
                            `Price: ${fruit.base_price} - ${fruit.max_price} per ${fruit.unit}`
                          }
                        </div>
                        <div className="text-xs text-gray-400">
                          Unit: {fruit.unit}
                        </div>
                      </div>
                      <input
                        type="number"
                        min="0"
                        max="50"
                        value={fruitQuantities[fruit.id] || 0}
                        onChange={(e) => {
                          let newQuantity = parseInt(e.target.value) || 0;
                          
                          // Enforce quantity limits
                          if (newQuantity < 0) {
                            newQuantity = 0;
                          } else if (newQuantity > 50) {
                            newQuantity = 50;
                            setMessage("Quantity cannot exceed 50");
                            setMessageType("error");
                            setTimeout(() => setMessage(""), 3000);
                          }

                          setFruitQuantities({
                            ...fruitQuantities,
                            [fruit.id]: newQuantity,
                          });
                        }}
                        className="w-16 px-2 py-1 border border-gray-300 rounded text-center"
                        placeholder="0"
                      />
                    </div>
                  ))}
                </div>
                
                {/* Show message if items are limited */}
                {fruits.length > maxItemsToShow && (
                  <div className="mt-3 p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-700 rounded-md">
                    <p className="text-sm text-blue-800 dark:text-blue-200">
                      📋 Showing {maxItemsToShow} of {fruits.length} available items. 
                      Adjust the "Maximum Items per Slip" slider above to see more or fewer items.
                    </p>
                  </div>
                )}
              </>
            ) : (
              <div className="text-center py-8 text-gray-500 dark:text-gray-400">
                <div className="text-4xl mb-2">🍎</div>
                <p>Please select a product category to start</p>
              </div>
            )}
          </div>

          <div className="mt-6">
            <div className="flex space-x-4">
            <button
              onClick={generateSlips}
              disabled={isGenerating}
              className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-medium py-2 px-4 rounded-md transition-colors"
            >
              {isGenerating ? "Generating..." : "Generate Slips"}
            </button>
              <button
                onClick={generateSampleQuantities}
                type="button"
                className="bg-green-500 hover:bg-green-600 text-white font-medium py-2 px-4 rounded-md transition-colors"
              >
                Generate Sample Quantities
              </button>
              <button
                onClick={resetQuantities}
                type="button"
                className="bg-gray-500 hover:bg-gray-600 text-white font-medium py-2 px-4 rounded-md transition-colors"
              >
                Reset Quantities
              </button>
            </div>
          </div>
        </div>

        {/* Message Display */}
        {message && (
          <div
            className={`mb-6 p-4 rounded-md ${
              messageType === "success"
                ? "bg-green-100 text-green-800"
                : messageType === "error"
                ? "bg-red-100 text-red-800"
                : "bg-blue-100 text-blue-800"
            }`}
          >
            {message}
          </div>
        )}

        {/* Generated Slips Display */}
        {generatedSlips.length > 0 && (
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Generated Slips ({generatedSlips.length})
              </h2>
              <div className="space-x-2">
                <button
                  onClick={previewSlip}
                  className="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-md transition-colors"
                >
                  Preview Slips
                </button>
                <button
                  onClick={saveSlipsToDatabase}
                  disabled={isGenerating}
                  className="bg-purple-600 hover:bg-purple-700 disabled:bg-purple-400 text-white font-medium py-2 px-4 rounded-md transition-colors"
                >
                  {isGenerating ? "Saving..." : "Save to Database"}
                </button>
                <button
                  onClick={printSlips}
                  className="bg-orange-600 hover:bg-orange-700 text-white font-medium py-2 px-4 rounded-md transition-colors"
                >
                  Print Slips
                </button>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {generatedSlips.map((slip, index) => (
                <div
                  key={slip.id}
                  className="border border-gray-200 rounded-lg p-4"
                >
                  <div className="text-center mb-3">
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {slip.format.name}
                    </h3>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Serial: {slip.serial_number}
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Date: {slip.slip_date}
                    </p>
                  </div>

                  <div className="space-y-2 mb-3">
                    {slip.items.map((item, itemIndex) => (
                      <div
                        key={itemIndex}
                        className="flex justify-between text-sm"
                      >
                        <span className="text-gray-700 dark:text-gray-300">
                          {item.fruit.name} ({item.quantity} {item.fruit.unit})
                        </span>
                        <span className="font-medium text-gray-900 dark:text-white">
                          {slip.format.currency_symbol || "Rs"} {item.total_price.toFixed(2)}
                        </span>
                      </div>
                    ))}
                  </div>

                  <div className="border-t pt-2">
                    <div className="flex justify-between font-semibold">
                      <span>Total:</span>
                      <span>{slip.format.currency_symbol || "Rs"} {slip.total_amount.toFixed(2)}</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Template Preview Modal */}
      {showPreview && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-[90%] max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold">Slip Preview</h3>
              <button
                onClick={closePreview}
                className="text-gray-500 hover:text-gray-700 text-2xl"
              >
                ×
              </button>
            </div>

            <div className="space-y-6">
              {generatedSlips.map((slip, index) => {
                const slipDate = new Date(slip.slip_date);
                const formattedDate = slipDate.toLocaleDateString("en-GB");
                const formattedTime = slipDate.toLocaleTimeString("en-GB", {
                  hour: "2-digit",
                  minute: "2-digit",
                  second: "2-digit",
                });

                // Get the selected template
                const selectedTemplate = slipFormats.find(
                  (f) => f.id === selectedFormat
                );
                if (!selectedTemplate) {
                  return null;
                }

                // Generate items HTML for both formats
                let itemsHtml = "";
                let handlebarsItemsHtml = "";

                slip.items.forEach((item) => {
                  // Standard format
                  itemsHtml += `
                    <div class="item">
                      <div class="name">${item.fruit.name}</div>
                      <div class="price">${item.total_price.toFixed(2)}</div>
                    </div>
                  `;

                                     // Handlebars format - replace placeholders in the loop structure
                   const itemTemplate = `
  <div style="display:flex;justify-content:space-between;margin:5px 0;font-size:12px">
    <span>${item.fruit.name}</span>
    <span>${item.quantity} ${item.fruit.unit}</span>
    <span>${formatPrice(item.total_price, selectedTemplate.currency_symbol || 'Rs')}</span>
                    </div>
                  `;

                  handlebarsItemsHtml += itemTemplate;
                });

                // Calculate cash amount and change
                const cashAmount = Math.ceil(slip.total_amount / 100) * 100;
                const changeAmount = cashAmount - slip.total_amount;

                // Calculate tax amount and grand total
                const taxAmount = (
                  (slip.total_amount * (selectedTemplate.tax_rate || 0)) /
                  100
                ).toFixed(2);
                const grandTotal = slip.total_amount + parseFloat(taxAmount);

                // Replace template placeholders with actual data
                let templateHtml = selectedTemplate.template_html
                  // Handlebars-style double curly braces (if template uses them)
                  .replace(
                    /\{\{logo\}\}/g,
                    selectedTemplate.logo_data
                      ? `<img src="${selectedTemplate.logo_data}" alt="Logo" style="max-width: 80px; height: auto;">`
                      : ""
                  )
                  .replace(
                    /\{\{store_name\}\}/g,
                    selectedTemplate.store_name || selectedTemplate.name
                  )
                  .replace(
                    /\{\{store_address\}\}/g,
                    selectedTemplate.store_address ||
                      "Fresh Produce & Quality Goods"
                  )
                  .replace(
                    /\{\{store_phone\}\}/g,
                    selectedTemplate.store_phone || "+1234567890"
                  )
                  .replace(
                    /\{\{store_email\}\}/g,
                    selectedTemplate.store_email || ""
                  )
                  .replace(
                    /\{\{store_website\}\}/g,
                    selectedTemplate.store_website || ""
                  )
                  .replace(/\{\{date\}\}/g, formattedDate)
                  .replace(/\{\{slip_number\}\}/g, slip.serial_number)
                  .replace(/\{\{items\}\}/g, selectedTemplate.category === 'international' ? '' : handlebarsItemsHtml)
                  .replace(
                    /\{\{total\}\}/g,
                    formatPrice(slip.total_amount, selectedTemplate.currency_symbol || 'Rs')
                  )
                  .replace(
                    /\{\{grand_total\}\}/g,
                    formatPrice(grandTotal, selectedTemplate.currency_symbol || 'Rs')
                  )
                  .replace(
                    /\{\{tax_amount\}\}/g,
                    formatPrice(parseFloat(taxAmount), selectedTemplate.currency_symbol || 'Rs')
                  )
                  .replace(
                    /\{\{tax_rate\}\}/g,
                    (selectedTemplate.tax_rate || 0).toString()
                  )
                  // Additional placeholders for international templates
                  .replace(/\{\{cashier_name\}\}/g, "CASHIER")
                  .replace(/\{\{time\}\}/g, new Date().toLocaleTimeString())
                  .replace(/\{\{cash_amount\}\}/g, formatPrice(grandTotal + 3, selectedTemplate.currency_symbol || 'Rs'))
                  .replace(/\{\{change_amount\}\}/g, formatPrice(3, selectedTemplate.currency_symbol || 'Rs'))
                  .replace(/\{\{items_count\}\}/g, slip.items.length.toString())
                  .replace(/\{\{total_quantity\}\}/g, slip.items.reduce((sum, item) => sum + item.quantity, 0).toString())
                  .replace(/\{\{footer_text\}\}/g, selectedTemplate.footer_text || "Thank you for your business!")
                  // Additional placeholders for Dubai template
                  .replace(/\{\{counter\}\}/g, "COUNTER-1")
                  .replace(/\{\{trn\}\}/g, "100071695100003")
                  .replace(/\{\{invoice_number\}\}/g, "01888103")
                  // Item-specific placeholders for hardcoded items
                  .replace(/\{\{item1_price\}\}/g, "4.50")
                  .replace(/\{\{item1_qty\}\}/g, "1")
                  .replace(/\{\{item1_total\}\}/g, "4.50")
                  .replace(/\{\{item2_price\}\}/g, "2.50")
                  .replace(/\{\{item2_qty\}\}/g, "1")
                  .replace(/\{\{item2_total\}\}/g, "2.50")
                  .replace(
                    /\{\{currency_symbol\}\}/g,
                    selectedTemplate.currency_symbol || "Rs"
                  )
                  .replace(
                    /\{\{footer_text\}\}/g,
                    selectedTemplate.footer_text || ""
                  )
                  // Remove footer divs that contain only empty footer_text
                  .replace(/<div[^>]*>\s*\{\{footer_text\}\}\s*<\/div>/gi, selectedTemplate.footer_text ? `<div>${selectedTemplate.footer_text}</div>` : "")
                  // Remove any remaining empty footer sections
                  .replace(/<div[^>]*>\s*\{\{footer_text\}\}\s*<\/div>/gi, "")
                  // Handle Handlebars loop structure - process each item individually
                  .replace(
                    /\{\{#each items\}\}([\s\S]*?)\{\{\/each\}\}/g,
                    (match, loopContent) => {
                      let processedItems = "";
                      slip.items.forEach((item) => {
                        let itemHtml = loopContent
                          .replace(/\{\{name\}\}/g, item.fruit.name)
                  .replace(
                            /\{\{quantity\}\}/g,
                            item.quantity.toString()
                          )
                          .replace(/\{\{unit\}\}/g, item.fruit.unit)
                          .replace(
                            /\{\{price\}\}/g,
                            item.total_price.toFixed(2)
                          );
                        processedItems += itemHtml;
                      });
                      return processedItems;
                    }
                  );

                // Debug: Show specific placeholder replacements for preview

                // Debug: Check if date placeholder exists and is being replaced

                return (
                  <div key={index} className="border rounded-lg p-4">
                    <h4 className="text-sm font-medium text-gray-700 mb-2">
                      Slip {index + 1} - {slip.serial_number}
                    </h4>
                    <div
                      className="preview-container"
                      dangerouslySetInnerHTML={{ __html: templateHtml }}
                    />
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
