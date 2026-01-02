//
//  SupabaseManager.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init () {
        //TODO: relocate
        let supabaseURL = "https://yvkupfqknuaftseogdts.supabase.co"
        let supbaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2a3VwZnFrbnVhZnRzZW9nZHRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY2NjgyMTgsImV4cCI6MjA2MjI0NDIxOH0.bm8Hh1G5_foKfkxeOydR1D3Lx3w7ieBpGxO6QPWRU94"
        client = SupabaseClient(supabaseURL: URL(string: supabaseURL)!,
                                supabaseKey: supbaseKey,
                                options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(
                                    //NOTE: recommended due to known bug (https://github.com/supabase/supabase-swift/pull/822)
                                    emitLocalSessionAsInitialSession: true,
                                ))
        )
    }
    
    var auth: AuthClient {
        client.auth
    }
    
}
