//
//  ExternalLinkHandler.swift
//  Kiwix
//
//  Created by Chris Li on 8/13/23.
//  Copyright © 2023 Chris Li. All rights reserved.
//

import SwiftUI

import Defaults

struct ExternalLinkHandler: ViewModifier {
    @State private var isAlertPresented = false
    @State private var activeAlert: ActiveAlert?
    @State private var activeSheet: ActiveSheet?
    @Binding var externalURL: URL?
    
    enum ActiveAlert {
        case ask(url: URL)
        case notLoading
    }
    
    enum ActiveSheet: Hashable, Identifiable {
        var id: Int { hashValue }
        case safari(url: URL)
    }
    
    func body(content: Content) -> some View {
        content.onChange(of: externalURL) { url in
            guard let url else { return }
            switch Defaults[.externalLinkLoadingPolicy] {
            case .alwaysAsk:
                isAlertPresented = true
                activeAlert = .ask(url: url)
            case .alwaysLoad:
                load(url: url)
            case .neverLoad:
                isAlertPresented = true
                activeAlert = .notLoading
            }
        }
        .alert("external_link_handler.alert.title".localized, 
               isPresented: $isAlertPresented,
               presenting: activeAlert) { alert in
            if case .ask(let url) = alert {
                Button("external_link_handler.alert.button.load.link".localized) {
                    load(url: url)
                }
                Button("common.button.cancel".localized, role: .cancel) { }
            }
        } message: { alert in
            switch alert {
            case .ask:
                Text("external_link_handler.alert.ask.description".localized)
            case .notLoading:
                Text("external_link_handler.alert.not_loading.description".localized)
            }
        }
        #if os(iOS)
        .sheet(item: $activeSheet) { sheet in
            if case .safari(let url) = sheet {
                SafariView(url: url)
            }
        }
        #endif
    }
    
    private func load(url: URL) {
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #elseif os(iOS)
        activeSheet = .safari(url: url)
        #endif
    }
}
