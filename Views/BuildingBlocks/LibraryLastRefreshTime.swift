//
//  LibraryLastRefreshTime.swift
//  Kiwix
//
//  Created by Chris Li on 7/12/22.
//  Copyright © 2022 Chris Li. All rights reserved.
//

import SwiftUI

import Defaults

struct LibraryLastRefreshTime: View {
    @Default(.libraryLastRefresh) private var lastRefresh
    
    var body: some View {
        if let lastRefresh = lastRefresh {
            if Date().timeIntervalSince(lastRefresh) < 120 {
                Text("library_refresh_time.last".localized)
            } else {
                Text(RelativeDateTimeFormatter().localizedString(for: lastRefresh, relativeTo: Date()))
            }
        } else {
            Text("library_refresh_time.never".localized)
        }
    }
}
