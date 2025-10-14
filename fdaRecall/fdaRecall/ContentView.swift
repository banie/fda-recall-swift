//
//  ContentView.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: FdaRecallsViewModel
    @Query(sort: \FdaRecallData.recallInitiationDate, order: .reverse) private var fdaRecalls: [FdaRecallData]

    init(repository: FdaRecallsRepository) {
        _viewModel = StateObject(wrappedValue: FdaRecallsViewModel(repository: repository))
    }

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(fdaRecalls) { recall in
                    NavigationLink {
                        RecallDetailView(recall: recall)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recall.displayTitle)
                                .font(.headline)
                                .lineLimit(2)
                            
                            Text(recall.displaySubtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(recall.formattedRecallDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                    .onAppear {
                        // Load more when we're near the end of the list
                        if recall == fdaRecalls.last && viewModel.hasMoreData {
                            viewModel.loadMore(from: fdaRecalls.count)
                        }
                    }
                }
                
                // Loading indicator for pagination
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView("Loading more...")
                            .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle("FDA Recalls")
            .toolbar {
                ToolbarItem {
                    Button(action: refreshData) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        } detail: {
            Text("Select a recall")
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private func refreshData() {
        viewModel.refresh()
    }
}



#Preview {
    let container = try! ModelContainer(for: FdaRecallData.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let repository = FdaRecallsRepositoryImpl(modelContext: container.mainContext)

    return ContentView(repository: repository)
        .modelContainer(container)
}
