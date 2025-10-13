//
//  RecallDetailView.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-13.
//

import SwiftUI

// MARK: - Recall Detail View
struct RecallDetailView: View {
    let recall: FdaRecallData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recall.displayTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(recall.displaySubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Recall Number", value: recall.recallNumber)
                    DetailRow(title: "Classification", value: recall.classification)
                    DetailRow(title: "Product Type", value: recall.productType)
                    DetailRow(title: "Reason for Recall", value: recall.reasonForRecall)
                    DetailRow(title: "Recall Date", value: recall.formattedRecallDate)
                    DetailRow(title: "Status", value: recall.status)
                }
            }
            .padding()
        }
        .navigationTitle("Recall Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Detail Row Helper
struct DetailRow: View {
    let title: String
    let value: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 120, alignment: .leading)
            
            Text(value ?? "Not available")
                .font(.subheadline)
                .foregroundColor(value != nil ? .primary : .secondary)
            
            Spacer()
        }
    }
}
