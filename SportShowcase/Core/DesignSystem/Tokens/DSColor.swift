import SwiftUI

enum DSColor {
    
    // MARK: - Brand
    static let primary   = Color("DSPrimary")
    static let accent    = Color("DSAccent")
    static let secondary = Color("DSSecondary")
    static let surface   = Color("DSSurface")
    
    // MARK: - Semantic
    enum Semantic {
        static let success = Color("DSSuccess")
        static let warning = Color("DSWarning")
        static let error   = Color("DSError")
        static let info    = Color("DSInfo")
    }
    
    // MARK: - Text
    enum Text {
        static let primary   = Color("DSTextPrimary")
        static let secondary = Color("DSTextSecondary")
        static let tertiary  = Color("DSTextTertiary")
        static let onAccent  = Color("DSTextOnAccent")
    }
    
    // MARK: - Background
    enum Background {
        static let primary   = Color("DSBackgroundPrimary")
        static let secondary = Color("DSBackgroundSecondary")
        static let card      = Color("DSBackgroundCard")
    }
}
