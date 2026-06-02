import SwiftUI

@Observable
class ThemeManager {
    
    static let shared = ThemeManager()
    
    var colorScheme: ColorScheme? = nil
    
    private init() {}
    
    func setLight()  { colorScheme = .light }
    func setDark()   { colorScheme = .dark  }
    func setSystem() { colorScheme = nil    }
}
