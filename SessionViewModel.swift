//
//  SessionViewModel.swift
//  GitHubPractice
//
//  Created by Scholar on 7/16/25.
//
import Foundation
import SwiftUI

struct ScheduledSession1: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let hour: Int
}

class SessionViewModel: ObservableObject {
    @Published var scheduledSessions: [ScheduledSession] = []
    
    func addSession(date: Date, hour: Int) {
        let newSession = ScheduledSession(date: date, hour: hour)
        if !scheduledSessions.contains(newSession) {
            scheduledSessions.append(newSession)
        }
    }
    
    func deleteSession(at offsets: IndexSet) {
        scheduledSessions.remove(atOffsets: offsets)
    }
}

