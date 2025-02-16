//
//  ContentView.swift
//  calculator
//
//  Created by Thanh Huy on 16/2/25.
//

import Combine
import SwiftUI

enum Currency: CaseIterable, Identifiable {
    case USD, EUR, GBP, JPY, AUD, CAD, CHF, CNY, SEK, NZD
    case MXN, SGD, HKD, NOK, KRW, TRY, INR, RUB, BRL, ZAR, VND

    var id: Self { self }  // Making it Identifiable

    func getName() -> String {
        switch self {
        case .USD: return "US Dollar"
        case .EUR: return "Euro"
        case .GBP: return "British Pound"
        case .JPY: return "Japanese Yen"
        case .AUD: return "Australian Dollar"
        case .CAD: return "Canadian Dollar"
        case .CHF: return "Swiss Franc"
        case .CNY: return "Chinese Yuan"
        case .SEK: return "Swedish Krona"
        case .NZD: return "New Zealand Dollar"
        case .MXN: return "Mexican Peso"
        case .SGD: return "Singapore Dollar"
        case .HKD: return "Hong Kong Dollar"
        case .NOK: return "Norwegian Krone"
        case .KRW: return "South Korean Won"
        case .TRY: return "Turkish Lira"
        case .INR: return "Indian Rupee"
        case .RUB: return "Russian Ruble"
        case .BRL: return "Brazilian Real"
        case .ZAR: return "South African Rand"
        case .VND: return "Vietnamese Dong"
        }
    }

    func getCurrencySymbol() -> String {
        switch self {
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD: return "A$"
        case .CAD: return "C$"
        case .CHF: return "CHF"
        case .CNY: return "元"
        case .SEK: return "kr"
        case .NZD: return "NZ$"
        case .MXN: return "Mex$"
        case .SGD: return "S$"
        case .HKD: return "HK$"
        case .NOK: return "kr"
        case .KRW: return "₩"
        case .TRY: return "₺"
        case .INR: return "₹"
        case .RUB: return "₽"
        case .BRL: return "R$"
        case .ZAR: return "R"
        case .VND: return "₫"
        }
    }
}

struct ContentView: View {
    @State private var currencyAmount: String = ""
    @State private var selectedCurrency: Currency = Currency.USD
    @FocusState private var isFocus: Bool
    @State private var showPicker = false
    @State private var showCalculator = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    Section {
                        Button(action: {
                            showPicker = true
                        }) {
                            HStack {
                                Text("Currency")
                                Spacer()
                                Text(selectedCurrency.getCurrencySymbol())
                            }
                        }
                    }
                    Section {
                        HStack {
                            Text(selectedCurrency.getCurrencySymbol())
                            TextField("Amount", text: $currencyAmount)
                                #if !os(macOS)
                                    .keyboardType(.decimalPad)
                                #endif
                                .focused($isFocus).onReceive(
                                    Just(currencyAmount)
                                ) {
                                    newValue in
                                    let filtered = newValue.filter {
                                        "0123456789".contains($0)
                                    }
                                    if filtered != newValue {
                                        self.currencyAmount = filtered
                                    }
                                }
                            GroupBox {
                                Button(action: {
                                    withAnimation(.none) {
                                        showCalculator = true
                                    }
                                }) {
                                    Image(systemName: "plus.forwardslash.minus")
                                }.sheet(isPresented: $showCalculator) {
                                    VStack {
                                        #if os(macOS)
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    showCalculator = false
                                                }) {
                                                    Text("Close")
                                                }
                                            }.padding()
                                        #endif

                                        Text("Welcome")

                                    }
                                    .presentationDetents([
                                        .height(
                                            0.7 * geometry.size.height)
                                    ]).presentationDragIndicator(
                                        Visibility.visible)

                                }
                            }
                        }

                    }
                }.navigationTitle("Calculator")
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isFocus = false
                            }
                        }
                    }.navigationDestination(isPresented: $showPicker) {
                        CurrencyPickerView(selectedCurrency: $selectedCurrency)
                    }
            }
        }
    }
}

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: Currency
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss

    var filteredCurrencies: [Currency] {
        searchText.isEmpty
            ? Currency.allCases
            : Currency.allCases.filter {
                String(describing: $0).lowercased().contains(
                    searchText.lowercased())
            }
    }

    var body: some View {
        VStack {
            TextField("Search Currency", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            List {
                ForEach(filteredCurrencies) { currency in
                    Button {
                        selectedCurrency = currency
                        dismiss()
                    } label: {
                        HStack {
                            Text(
                                "\(currency.getName()) (\(currency.getCurrencySymbol()))"
                            )
                            Spacer()
                            if selectedCurrency == currency {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
