"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import Navigation from "@/components/Navigation";

interface SlipFormat {
  id: string;
  name: string;
  description: string;
  template_html: string;
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

export default function Home() {
  const [user, setUser] = useState<any>(null);
  const [slipFormats, setSlipFormats] = useState<SlipFormat[]>([]);
  const [fruits, setFruits] = useState<Fruit[]>([]);
  const [selectedFormat, setSelectedFormat] = useState<string>("");
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [numberOfSlips, setNumberOfSlips] = useState<number>(1);
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

  useEffect(() => {
    const getUser = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (user) {
        setUser(user);
        loadSlipFormats();
        loadFruits();
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
        loadSlipFormats();
        loadFruits();
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
    // Initialize fruitQuantities with 1 for all fruits when fruits change
    if (fruits.length > 0) {
      const initialQuantities: { [key: string]: number } = {};
      fruits.forEach((fruit) => {
        // Only set to 1 if not already set by user
        if (fruitQuantities[fruit.id] === undefined) {
          initialQuantities[fruit.id] = 1;
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

  const loadSlipFormats = async () => {
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
      if (data && data.length > 0) {
        setSelectedFormat(data[0].id);
      }
    } catch (error) {
    }
  };

  const loadFruits = async () => {
    try {
      const { data, error } = await supabase
        .from("fruits")
        .select("*")
        .eq("is_active", true)
        .order("name");

      if (error) throw error;
      setFruits(data || []);

      // Don't initialize quantities automatically - let user set them
      // This prevents overriding user input with default values
    } catch (error) {
    }
  };

  const resetQuantities = () => {
    const resetQuantities: { [key: string]: number } = {};
    fruits.forEach((fruit) => {
      resetQuantities[fruit.id] = 1;
    });
    setFruitQuantities(resetQuantities);
  };

  const generateRandomPrice = (basePrice: number, maxPrice: number): number => {
    return (
      Math.round((Math.random() * (maxPrice - basePrice) + basePrice) * 100) /
      100
    );
  };

  const generateSlips = async () => {
    if (!selectedFormat || !startDate || !endDate || numberOfSlips < 1) {
      setMessage("Please fill in all required fields");
      setMessageType("error");
      return;
    }

    // Debug: Log the current fruitQuantities state

    const selectedFruits = fruits.filter(
      (fruit) => fruitQuantities[fruit.id] >= 1
    );
    
    // Debug: Log selected fruits and their quantities
    
    if (selectedFruits.length === 0) {
      setMessage("Please select at least one fruit with quantity 1 or more");
      setMessageType("error");
      return;
    }

    setIsGenerating(true);
    setMessage("Generating slips...");

    try {
      const newSlips: GeneratedSlip[] = [];
      const start = new Date(startDate);
      const end = new Date(endDate);

      for (let i = 0; i < numberOfSlips; i++) {
        // Generate random date within range
        const randomTime =
          start.getTime() + Math.random() * (end.getTime() - start.getTime());
        const randomDate = new Date(randomTime);
        const slipDate = randomDate.toISOString().split("T")[0];

        // Generate random serial number
        const timestamp = Date.now().toString().slice(-6);
        const randomNum = Math.floor(Math.random() * 100000)
          .toString()
          .padStart(5, "0");
        const serialNumber = `${timestamp}${randomNum}`;

        // Generate items with random prices and random order
        const items: SlipItem[] = [];
        let totalAmount = 0;

        // Create a shuffled copy of selectedFruits for this slip
        const shuffledFruits = [...selectedFruits].sort(() => Math.random() - 0.5);

        shuffledFruits.forEach((fruit) => {
          const quantity = fruitQuantities[fruit.id];
          const unitPrice = generateRandomPrice(
            fruit.base_price,
            fruit.max_price
          );
          const totalPrice = quantity * unitPrice;

          items.push({
            fruit,
            quantity,
            unit_price: unitPrice,
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

      // Debug: Log the final generated slips with item details

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
              ${document.querySelector("style")?.innerHTML || ""}
          @media print {
            .receipt {
              width: 320px !important;
              margin: 0 auto !important;
              font-family: Verdana, sans-serif !important;
            }
            /* Ensure items display side by side */
            .receipt div[style*="display:flex"] {
              display: flex !important;
              justify-content: space-between !important;
              margin: 5px 0 !important;
              font-size: 12px !important;
            }
            .receipt div[style*="display:flex"] span {
              display: inline-block !important;
              white-space: nowrap !important;
            }
            /* Prevent line breaks in item rows */
            .receipt div[style*="margin:5px 0"] {
              page-break-inside: avoid !important;
              break-inside: avoid !important;
            }
          }
            </style>
          </head>
          <body>
      `;

      generatedSlips.forEach((slip) => {
        const slipDate = new Date(slip.slip_date);
        const formattedDate = slipDate.toLocaleDateString("en-GB");

      const selectedTemplate = slipFormats.find((f) => f.id === selectedFormat);
      if (!selectedTemplate) return;

      // Debug: Log the items and their quantities

      // Items HTML - Ensure quantity is properly displayed
        let itemsHtml = "";
        slip.items.forEach((item) => {
          itemsHtml += `
  <div style="display:flex;justify-content:space-between;align-items:center;margin:5px 0;font-size:12px">
    <span style="flex:1;text-align:left;">${item.fruit.name}</span>
    <span style="flex:1;text-align:center;">${item.quantity} ${
          item.fruit.unit
        }</span>
    <span style="flex:1;text-align:right;">${item.total_price.toFixed(2)}</span>
            </div>
          `;
        });

      const taxAmount = (
        (slip.total_amount * (selectedTemplate.tax_rate || 0)) /
        100
      ).toFixed(2);

      // Calculate grand total including tax
      const grandTotal = slip.total_amount + parseFloat(taxAmount);

      // Replace placeholders — strictly matching {{placeholder}}
        let templateHtml = selectedTemplate.template_html
        // Handle double curly braces (current format)
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
        .replace(/\{\{store_address\}\}/g, selectedTemplate.store_address || "")
        .replace(/\{\{store_phone\}\}/g, selectedTemplate.store_phone || "")
        .replace(/\{\{store_email\}\}/g, selectedTemplate.store_email || "")
        .replace(/\{\{store_website\}\}/g, selectedTemplate.store_website || "")
        .replace(/\{\{date\}\}/g, formattedDate)
        .replace(/\{\{slip_number\}\}/g, slip.serial_number)
        .replace(/\{\{items\}\}/g, itemsHtml)
        .replace(/\{\{total\}\}/g, slip.total_amount.toFixed(2))
        .replace(/\{\{tax_rate\}\}/g, (selectedTemplate.tax_rate || 0).toString())
        .replace(/\{\{tax_amount\}\}/g, taxAmount)
        .replace(/\{\{grand_total\}\}/g, grandTotal.toFixed(2))
        .replace(
          /\{\{currency_symbol\}\}/g,
          selectedTemplate.currency_symbol || "Rs"
        )
        .replace(/\{\{footer_text\}\}/g, selectedTemplate.footer_text || "");

      // Debug: Log the final template content

        printContent += templateHtml;
      });

    printContent += `</body></html>`;

      printWindow.document.write(printContent);
      printWindow.document.close();
      printWindow.focus();
      printWindow.print();
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
                  setSelectedFormat(newFormat);
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Select Format</option>
                {slipFormats.map((format) => (
                  <option key={format.id} value={format.id}>
                    {format.name}
                  </option>
                ))}
              </select>
            </div>

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
          </div>

          {/* Fruit Selection */}
          <div className="mt-6">
            <h3 className="text-lg font-medium mb-3 text-gray-900 dark:text-white">
              Select Fruits & Quantities
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-400 mb-3">
              Set quantity for each fruit (minimum: 1, maximum: 12)
            </p>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {fruits.map((fruit) => (
                <div key={fruit.id} className="flex items-center space-x-2">
                  <input
                    type="number"
                    min="1"
                    max="12"
                    value={fruitQuantities[fruit.id] || 0}
                    onChange={(e) => {
                      let newQuantity = parseInt(e.target.value) || 0;
                      const oldQuantity = fruitQuantities[fruit.id] || 0;
                      
                      // Enforce quantity limits
                      if (newQuantity < 1) {
                        newQuantity = 1;
                        setMessage("Quantity must be at least 1");
                        setMessageType("error");
                        setTimeout(() => setMessage(""), 3000);
                      } else if (newQuantity > 12) {
                        newQuantity = 12;
                        setMessage("Quantity cannot exceed 12");
                        setMessageType("error");
                        setTimeout(() => setMessage(""), 3000);
                      }
                      

                      setFruitQuantities({
                        ...fruitQuantities,
                        [fruit.id]: newQuantity,
                      });
                    }}
                    className="w-16 px-2 py-1 border border-gray-300 rounded text-center"
                    placeholder="1"
                  />
                  <span className="text-sm text-gray-700 dark:text-gray-300">
                    {fruit.name} (${fruit.base_price}-${fruit.max_price})
                  </span>
                </div>
              ))}
            </div>
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
    <span>${item.total_price.toFixed(2)}</span>
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
                  .replace(/\{\{items\}\}/g, handlebarsItemsHtml)
                  .replace(
                    /\{\{total\}\}/g,
                    slip.total_amount.toFixed(2)
                  )
                  .replace(
                    /\{\{grand_total\}\}/g,
                    grandTotal.toFixed(2)
                  )
                  .replace(
                    /\{\{tax_amount\}\}/g,
                    taxAmount
                  )
                  .replace(
                    /\{\{tax_rate\}\}/g,
                    (selectedTemplate.tax_rate || 0).toString()
                  )
                  .replace(
                    /\{\{currency_symbol\}\}/g,
                    selectedTemplate.currency_symbol || "Rs"
                  )
                  .replace(
                    /\{\{footer_text\}\}/g,
                    selectedTemplate.footer_text || ""
                  )
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
